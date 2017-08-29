//
//  TrackCell.h
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/28/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpotifyManager.h"

@interface TrackCell : UITableViewCell

@property SPTPartialTrack *track;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistAlbumLabel;
@property (weak, nonatomic) IBOutlet UIStackView *nowPlayingView;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *barHeights;


- (void)initialize;
- (void)setNowPlaying;
- (void)hideNowPlaying;

@end
