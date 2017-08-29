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

@optional
- (void)spotifyAuthenticated:(BOOL)loggedIn auth:(SPTAuth *)auth;

@end

@interface SpotifyManager : NSObject<SPTAudioStreamingDelegate>

@property id<SpotifyManagerDelegate> delegate;
@property SPTAuth *auth;
@property SPTAudioStreamingController *player;

@property (nonatomic, strong) UIViewController *authViewController;

+ (id)sharedInstance;

- (void)initialize;
- (void)search:(NSString *)query offset:(int)offset completion:(void(^)(SPTPartialTrack *))callback;
- (void)loadPlaylist:(NSURL *)uri completion:(void(^)(SPTPlaylistSnapshot *))callback;
- (NSString *)urlFromPlaylist:(SPTPlaylistSnapshot *)playlist;
- (BOOL)isLoggedIn;

@end
