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
    NSString *cleaned = [self removePuncuation:phrase];
    NSMutableArray *words = [[self components:cleaned] mutableCopy];
    
    [self findMessageTracks:words completion:^(NSArray *tracks) {
        if (!tracks) {
            callback(nil);
            return;
        }
        
        [self createSPTPlayList:tracks completion:^(SPTPlaylistSnapshot *playlist) {
            callback(playlist);
        }];
    
    }];
}

#pragma mark - String Manipulation

/// Converts string to mostly alphanumeric, keeping apostophres
- (NSString *)removePuncuation:(NSString *)message {
    NSString *trimmedMessage = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableCharacterSet *allowedSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [allowedSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
    return [[trimmedMessage componentsSeparatedByCharactersInSet:[allowedSet invertedSet]] componentsJoinedByString:@" "];
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

/// Finds tracks to represent the message using single words
- (void)findMessageTracks:(NSArray *)words completion:(void(^)(NSArray *))callback {
    
    SpotifyManager *manager = [SpotifyManager sharedInstance];
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    __block int queriesCompleted = 0;

    for (int i = 0; i < words.count; i++) {
        NSString *word = words[i];
        [manager search:word offset:0 completion:^(SPTPartialTrack *track) {
            
            queriesCompleted++;
            
            if (track) {
                // Keep the tracks in proper order
                if (i > tracks.count) {
                    [tracks addObject:track];
                } else {
                    [tracks insertObject:track atIndex: i];
                }
                
            } else {
                callback(nil);
                return;
            }
            
            if (queriesCompleted == words.count) {
                callback(tracks);
            }
        }];
    }
}

#pragma TODO: Finish recursive sliding window
/// Finds tracks to represent the message using a sliding window algorithm
- (void)findMessageTracks:(NSArray *)words existingTracks:(NSMutableArray *)existingTracks
               startIndex:(int)start depth:(int)depth completion:(void(^)(NSArray *))callback {
    NSMutableArray *tracks;
    if (existingTracks) {
        tracks = existingTracks;
    } else {
        tracks = [[NSMutableArray alloc] init];
    }
    
    __block int startIndex = start;
    __block int lengthToFind = depth;
    
    NSString *query = [self join:words start:startIndex length:lengthToFind];
    
    SpotifyManager *manager = [SpotifyManager sharedInstance];
    [manager search:query offset:0 completion:^(SPTPartialTrack *track) {
        if (track) {
            int remaining = (int) words.count - (lengthToFind + startIndex);
            startIndex = lengthToFind + remaining;
            lengthToFind = (int) words.count - startIndex;
            [tracks addObject:track];
            
            if (remaining == 0) {
                callback(tracks);
            } else {
                [self findMessageTracks:words
                         existingTracks:tracks
                             startIndex:startIndex
                                  depth:lengthToFind
                             completion:callback];
            }
        } else {
            lengthToFind--;
            if (lengthToFind == 0) {
                callback(nil);
                return;
            }
            [self findMessageTracks:words
                     existingTracks:tracks
                         startIndex:startIndex
                              depth:lengthToFind
                         completion:callback];
        }
    }];
    
}

/// Creates Spotify Playlist and adds predetermined tracks to it. Returns created playlist
- (void)createSPTPlayList:(NSArray *)tracks completion:(void(^)(SPTPlaylistSnapshot *))callback {
    NSString* username = [SPTAuth defaultInstance].session.canonicalUsername;
    NSString* accessToken = [SPTAuth defaultInstance].session.accessToken;
    [SPTPlaylistList createPlaylistWithName:@"My Message In Songs"
                                    forUser:username
                                 publicFlag:YES
                                accessToken:accessToken
                                   callback:^(NSError *error, SPTPlaylistSnapshot *playlist) {
        
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
