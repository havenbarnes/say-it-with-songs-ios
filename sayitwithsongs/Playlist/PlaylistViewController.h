//
//  PlaylistViewController.h
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/28/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Color.h"
#import "SpotifyManager.h"
#import "TrackCell.h"
#import <QuartzCore/QuartzCore.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <MessageUI/MessageUI.h>

@interface PlaylistViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate>

// Spotify Data
@property (nonatomic, strong) SPTPlaylistSnapshot *playlist;
@property (nonatomic, strong) NSURL *playlistUri;
@property (nonatomic, strong) SPTAudioStreamingController *player;
@property (nonatomic, strong) SPTPartialTrack *nowPlaying;

// UI
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;


@end
