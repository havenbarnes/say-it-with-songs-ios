//
//  SpotifyManager.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/21/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "SpotifyManager.h"


@implementation SpotifyManager

+ (SpotifyManager *)current {
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
    self.auth.requestedScopes = @[SPTAuthStreamingScope];
    self.auth.redirectURL = [NSURL URLWithString:@kCallbackURL];
    self.auth.sessionUserDefaultsKey = @kSessionUserDefaultsKey;
    
    [self.delegate spotifyAuthenticated:[self.auth.session isValid]
                                   auth:self.auth];
}

@end
