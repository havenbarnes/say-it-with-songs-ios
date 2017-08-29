//
//  PlaylistFactory.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/28/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "PlaylistFactory.h"

@implementation PlaylistFactory

/// Takes a phrase and attempts to generate a SPTPlaylistSnapshot which it returns in a callback
- (void)generatePlaylist:(NSString *)phrase completion:(void(^)(SPTPlaylistSnapshot *))callback {
    SpotifyManager *manager = [SpotifyManager sharedInstance];
    
    
    NSString *cleaned = [self removePuncuation:phrase];
    NSArray *allWords = [self components:cleaned];
    
    //    int indexLength = (int) allWords.count - 1;
    //    int startIndex = 0;
    //    for (int l = indexLength; l >= 0; l--) {
    //        NSString *query = [self join:allWords start:startIndex length:l];
    //
    //    }
    __block NSMutableArray *tracks = [[NSMutableArray alloc] initWithCapacity:allWords.count];
    __block int queriesCompleted = 0;
    
    // Test with just single words for now
    
    for (int i = 0; i < allWords.count; i++) {
        NSString *word = allWords[i];
        [manager search:word completion:^(SPTPartialTrack *track) {
            
            queriesCompleted++;
            
            if (track) {
                // Keep the tracks in proper order
                [tracks insertObject:track atIndex: tracks.count == 0 ? 0 : i];
            } else {
                callback(nil);
                return;
            }
            
            if (queriesCompleted == allWords.count) {
                [self createSPTPlayList:tracks completion:^(SPTPlaylistSnapshot *playlist) {
                    callback(playlist);
                }];
            }
        }];
    }
}

#pragma mark - String Manipulation

/// Converts string to purely alphabet
- (NSString *)removePuncuation:(NSString *)message {
    NSString *trimmedMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [[trimmedMessage componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@" "];
}

/// Filters out punctuation and breaks up phrase into string components
- (NSArray *)components:(NSString *)phrase {
    NSArray *components = [phrase componentsSeparatedByString:@" "];
    return components;
}

/// Filters out punctuation and breaks up phrase into string components
- (NSString *)join:(NSArray *)components start:(int)start length:(int)length {
    NSRange range;
    range.location = start;
    range.length = length;
    NSArray *array = [components subarrayWithRange:range];
    return [array componentsJoinedByString:@" "];
}

#pragma mark - Spotify Playlist Helpers


/// Creates Spotify Playlist and adds predetermined tracks to it. Returns created playlist
- (void)createSPTPlayList:(NSArray *)tracks completion:(void(^)(SPTPlaylistSnapshot *))callback {
    NSString* username = [SPTAuth defaultInstance].session.canonicalUsername;
    NSString* accessToken = [SPTAuth defaultInstance].session.accessToken;
    [SPTPlaylistList createPlaylistWithName:@"Say It With Songs" forUser:username publicFlag:YES accessToken:accessToken callback:^(NSError *error, SPTPlaylistSnapshot *playlist) {
        
        [self addTracksToPlaylist:tracks playlist:playlist completion:^{
            callback(playlist);
        }];
    }];
}

/// Adds all tracks to playlist with
- (void)addTracksToPlaylist:(NSArray *)tracks
                   playlist:(SPTPlaylistSnapshot *)playlist
                 completion:(void(^)(void))callback  {
    
    NSString* accessToken = [SPTAuth defaultInstance].session.accessToken;
    [playlist addTracksToPlaylist:tracks withAccessToken:accessToken callback:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        callback();
    }];
}

@end
