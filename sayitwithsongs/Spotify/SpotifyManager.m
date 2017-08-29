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

- (void)search:(NSString *)query completion:(void(^)(SPTPartialTrack *))callback {
    NSString *accessToken = [SPTAuth defaultInstance].session.accessToken;
    
    [SPTSearch performSearchWithQuery:query
                            queryType:SPTQueryTypeTrack
                          accessToken:accessToken
                             callback:^(NSError *error, id object) {
                                 
                                 if (error) {
                                     NSLog(@"Search Error: %@", error);
                                 }
                                 
                                 NSArray *results = [(SPTListPage *) object items];
                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name =[c] %@", query];
                                 NSArray *exactResults = [results filteredArrayUsingPredicate:predicate];
                                 
                                 callback(exactResults.firstObject);
                             }];
}

- (void)logout {
    [self.player logout];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@kSessionUserDefaultsKey];
}

@end
