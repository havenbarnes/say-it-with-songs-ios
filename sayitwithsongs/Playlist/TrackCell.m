//
//  TrackCell.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/28/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "TrackCell.h"

@implementation TrackCell

- (void)initialize {
    SPTPartialArtist *artist = self.track.artists.firstObject;
    SPTPartialAlbum *album = self.track.album;
    self.titleLabel.text = self.track.name;
    self.artistAlbumLabel.text = [NSString stringWithFormat:@"%@ •  %@", artist.name, album.name];
}

- (void)setNowPlaying {
    self.nowPlayingView.alpha = 1;
    for (int i = 0; i < self.barHeights.count; i++) {
        NSLayoutConstraint *height = self.barHeights[i];
        height.constant = self.nowPlayingView.frame.size.height;
        [self layoutIfNeeded];
        height.constant = 0;
        
        UIViewAnimationOptions options = UIViewAnimationOptionAutoreverse |
        UIViewAnimationOptionRepeat;
        [UIView animateWithDuration:0.5
                              delay:0.2 * (i + 1)
                            options:options
                         animations:^{
                             [self layoutIfNeeded];
                             
        } completion:nil];
    }
}

- (void)hideNowPlaying {
    
    for (int i = 0; i < self.barHeights.count; i++) {
        NSLayoutConstraint *height = self.barHeights[i];
        height.constant = self.nowPlayingView.frame.size.height;

        [UIView animateWithDuration:0.5
                              delay:0.2 * (i + 1)
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.nowPlayingView.alpha = 0;
                         } completion:^(BOOL completed) {
                             [self layoutIfNeeded];
                         }];
    }
}

@end
