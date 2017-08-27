//
//  InputViewController.h
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/26/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@end
