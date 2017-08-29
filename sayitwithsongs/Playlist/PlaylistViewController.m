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
    NSLog(@"%@", self.playlist.tracksForPlayback);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
