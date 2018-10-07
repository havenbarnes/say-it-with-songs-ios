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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    SPTAuth *auth = [SPTAuth defaultInstance];
    SPTAudioStreamingController *player = [SPTAudioStreamingController sharedInstance];
    
    SPTAuthCallback authCallback = ^(NSError *error, SPTSession *session) {
        if (error) {
            NSLog(@"Spotify Authentication Error: %@", error);
        } else {
            auth.session = session;
            NSLog(@"Login complete, access token: %@", auth.session.accessToken);
            [player loginWithAccessToken:auth.session.accessToken];
        }
        
        [self.window.rootViewController dismissViewControllerAnimated:true completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@kSessionUpdatedKey object:self];
    };
    
    if ([auth canHandleURL:url]) {
        [auth handleAuthCallbackWithTriggeredAuthURL:url callback:authCallback];
        return YES;
    }
    
    return NO;
}


@end
