//
//  SpotifyManager.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/21/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "SpotifyManager.h"


@implementation SpotifyManager

/// Checks for
- (BOOL)isLoggedIn {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@kSessionUserDefaultsKey];
}

+ (id)sharedInstance {
    static SpotifyManager *current = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        current = [[self alloc] init];
    });
    return current;
}

- (void)initialize {
    self.auth = [SPTAuth defaultInstance];
    self.auth.clientID = @kClientId;
    self.auth.requestedScopes = @[SPTAuthStreamingScope, SPTAuthPlaylistModifyPublicScope];
    self.auth.redirectURL = [NSURL URLWithString:@kCallbackURL];
    self.auth.sessionUserDefaultsKey = @kSessionUserDefaultsKey;
    
    self.player = [SPTAudioStreamingController sharedInstance];
    self.player.delegate = self;
    NSError *audioStreamingError;
    [self.player startWithClientId:self.auth.clientID error:&audioStreamingError];
    
    [self.delegate spotifyAuthenticated:[self.auth.session isValid]
                                   auth:self.auth];
}

- (void)search:(NSString *)query offset:(int)offset completion:(void(^)(SPTPartialTrack *))callback {
    NSString *accessToken = [SPTAuth defaultInstance].session.accessToken;
    
    [SPTSearch performSearchWithQuery:query queryType:SPTQueryTypeTrack offset:offset accessToken:accessToken callback:^(NSError *error, id object) {
        
        if (error) {
            NSLog(@"Search Error: %@", error);
        }
        
        NSArray *results = [(SPTListPage *) object items];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name =[c] %@", query];
        NSArray *exactResults = [results filteredArrayUsingPredicate:predicate];
        
        if (exactResults.count == 0 && offset < 5) {
            int newOffset = offset + 1;
            [self search:query offset:newOffset completion:callback];
        } else {
            callback(exactResults.firstObject);
        }
    }];
}

- (void)loadPlaylist:(NSURL *)uri completion:(void(^)(SPTPlaylistSnapshot *))callback {
    NSString *accessToken = [SPTAuth defaultInstance].session.accessToken;
    [SPTPlaylistSnapshot playlistWithURI:uri accessToken:accessToken callback:^(NSError *error, id object) {
        NSLog(@"Load Playlist Results: %@", object);
        if(error) {
            NSLog(@"Load Playlist Error: %@", error);
        }
        SPTPlaylistSnapshot *playlist = (SPTPlaylistSnapshot *) object;
        callback(playlist);
    }];
}

- (NSString *)urlFromPlaylist:(SPTPartialPlaylist *)playlist {
    NSString *uri = playlist.uri.absoluteString;
    NSString *username = [SPTAuth defaultInstance].session.canonicalUsername;
    NSString *removeable = [NSString stringWithFormat:@"spotify:user:%@:playlist:", username];
    NSString *spotifyId = [uri stringByReplacingOccurrencesOfString:removeable withString:@""];
    NSString *url = [NSString stringWithFormat:@"https://open.spotify.com/user/%@/playlist/%@", username, spotifyId];
    return url;
}

- (void)logout {
    [self.player logout];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@kSessionUserDefaultsKey];
}

@end
