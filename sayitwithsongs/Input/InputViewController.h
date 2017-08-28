//
//  InputViewController.h
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/26/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SpotifyManager.h"
#import "Color.h"
@interface InputViewController : UIViewController<UITextViewDelegate>

@property BOOL hasEdited;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptLabelY;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet UIView *textViewBorder;

@end
