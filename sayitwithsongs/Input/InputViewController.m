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
        
        [[SpotifyManager sharedInstance] search:textView.text];
        
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 80;
}

- (IBAction)logoutButtonPressed:(id)sender {
    [[SpotifyManager sharedInstance] logout];
    [self present:@"sbLoginViewController"];
}

- (void)present:(NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
