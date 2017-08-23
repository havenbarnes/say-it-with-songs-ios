//
//  SpotifyManager.h
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/21/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <SpotifyAudioPlayback/SpotifyAudioPlayback.h>
#import <SafariServices/SafariServices.h>
#import "Config.h"

@protocol SpotifyManagerDelegate
- (void)spotifyAuthenticated:(BOOL)loggedIn auth:(SPTAuth *)auth;
@end

@interface SpotifyManager : NSObject

@property id<SpotifyManagerDelegate> delegate;
@property SPTAuth *auth;
@property (nonatomic, strong) UIViewController *authViewController;

+ (id)current;

- (void)initialize;

@end
