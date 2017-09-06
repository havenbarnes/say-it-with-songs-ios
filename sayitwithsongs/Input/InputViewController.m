//
//  InputViewController.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/26/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.hasEdited) {
        [UIView transitionWithView:self.textView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            [self.textView setText:nil];
                            [self textViewDidChange:self.textView];
        } completion:nil];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (self.hasEdited) {
        return;
    }
    // Animate prompt label and underline
    [textView setTintColor:UIColor(0x41B956)];
    [UIView animateWithDuration:0.3 delay:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self animatePrompt];
        [self animateBorder];
    } completion:^(BOOL completed){
        self.hasEdited = true;
    }];
}

- (void)animatePrompt {
    CGRect sourceRect = self.promptLabel.frame;
    CGRect finalRect = sourceRect;
    finalRect.size.width -= finalRect.size.width * 0.5;
    finalRect.size.height -= finalRect.size.height * 0.5;
    self.promptLabelY.constant -= 18;
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform,
                                           -(CGRectGetMidX(sourceRect)-CGRectGetMidX(finalRect)),
                                           -(CGRectGetMidY(sourceRect)-CGRectGetMidY(finalRect)));
    transform = CGAffineTransformScale(transform,
                                       finalRect.size.width/sourceRect.size.width,
                                       finalRect.size.height/sourceRect.size.height);
    self.promptLabel.transform = transform;
    self.promptLabel.textColor = [UIColor whiteColor];
    [self.view layoutIfNeeded];
}

- (void)animateBorder {
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = UIColor(0x41B956);
    greenView.frame = CGRectZero;
    [self.textViewBorder addSubview: greenView];
    greenView.center = self.textViewBorder.center;
    greenView.frame = self.textViewBorder.bounds;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    CGSize fitSize = CGSizeMake(textView.frame.size.width, MAXFLOAT);
    CGSize textSize = [textView sizeThatFits: fitSize];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.textViewHeight.constant = textSize.height;
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        // Enter pressed, create playlist
        [self buildPlaylist:textView.text];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 80;
}

- (void)buildPlaylist:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"Building Playist";
    
    PlaylistFactory *factory = [[PlaylistFactory alloc] init];
    [factory generatePlaylist:message completion:^(SPTPlaylistSnapshot *playlist) {
        [hud hideAnimated:YES];
        [self presentNewPlaylist:playlist];
    }];
}

/// Presents new playlist view or displays message if playlist could not be made
- (void)presentNewPlaylist:(SPTPlaylistSnapshot *)playlist {
    if (playlist) {
        PlaylistViewController *vc = (PlaylistViewController *) [self instantiate:@"sbPlaylistViewController"];
        vc.playlistUri = playlist.uri;
        [self presentViewController:vc animated:YES completion:NULL];
    } else {
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:@"Playlist Creation Failed"
                                    message:@"Sorry, a playlist with this message could not be made."
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction
                                        actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)logoutButtonPressed:(id)sender {
    [[SpotifyManager sharedInstance] logout];
    [self present:@"sbLoginViewController"];
}

- (UIViewController *)instantiate:(NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:identifier];
}

- (void)present:(NSString *)identifier {
    UIViewController *vc = [self instantiate:identifier];
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
