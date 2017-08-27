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

- (void)textViewDidChange:(UITextView *)textView {
    
    CGSize fitSize = CGSizeMake(textView.frame.size.width, MAXFLOAT);
    CGSize textSize = [textView sizeThatFits: fitSize];
    
    self.textViewHeight.constant = textSize.height;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return textView.text.length + (text.length - range.length) <= 140;
}

- (IBAction)logoutButtonPressed:(id)sender {
    [self present:@"sbLoginViewController"];
}

- (void)present:(NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
