//
//  PlaylistViewController.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/28/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "PlaylistViewController.h"

@interface PlaylistViewController ()

@end

@implementation PlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.linkButton.enabled = false;
    self.messageButton.enabled = false;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 60, 0)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];


    SpotifyManager *manager = [SpotifyManager sharedInstance];
    [manager loadPlaylist:self.playlistUri completion:^(SPTPlaylistSnapshot *playlist) {
        self.playlist = playlist;
        NSLog(@"%@", self.playlist.tracksForPlayback);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        self.linkButton.enabled = true;
        self.messageButton.enabled = true;
    }];
}

- (void)refresh {
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlist.trackCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sbTrackCell" forIndexPath:indexPath];
    
    SPTPartialTrack *track = self.playlist.tracksForPlayback[indexPath.row];
    cell.track = track;
    [cell initialize];
    
    if (cell.track == self.nowPlaying) {
        [cell setNowPlaying];
    } else {
        [cell hideNowPlaying];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.nowPlaying != cell.track) {
        self.nowPlaying = cell.track;
        [tableView reloadData];
        
        // Start playing track
    }
}

- (IBAction)playButtonPressed:(id)sender {
    NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:firstRow];
}


#pragma mark - Sharing / Dismissal

- (IBAction)linkButtonPressed:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    SpotifyManager *manager = [SpotifyManager sharedInstance];
    NSString *link = [manager urlFromPlaylist:self.playlist];
    pasteboard.string = link;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = @"Link Copied!";
    [hud hideAnimated:YES afterDelay:1.0];
    

}

- (IBAction)messageButtonPressed:(id)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        SpotifyManager *manager = [SpotifyManager sharedInstance];
        NSString *link = [manager urlFromPlaylist:self.playlist];
        controller.body = [NSString stringWithFormat:@"I couldn't think of a better way to say this:\n%@", link];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
