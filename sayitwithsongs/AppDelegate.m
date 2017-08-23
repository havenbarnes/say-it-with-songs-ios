//
//  AppDelegate.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/21/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "AppDelegate.h"
#import "SpotifyManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
        if (error) {
            NSLog(@"Spotify Authentication Error: %@", error);
        } else {
            auth.session = session;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@kSessionUpdatedKey object:self];
    };
    
    if ([auth canHandleURL:url]) {
        [auth handleAuthCallbackWithTriggeredAuthURL:url callback:authCallback];
        return YES;
    }
    
    return NO;
}


@end
