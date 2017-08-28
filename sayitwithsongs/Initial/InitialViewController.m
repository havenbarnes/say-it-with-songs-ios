//
//  InitialViewController.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/24/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "InitialViewController.h"

@implementation InitialViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SpotifyManager *spotifyManager = [SpotifyManager sharedInstance];
    spotifyManager.delegate = self;
    [spotifyManager initialize];
    
}

- (void)spotifyAuthenticated:(BOOL)loggedIn auth:(SPTAuth *)auth {
    if (loggedIn) {
        // Contine Into App
        [self present:@"sbInputViewController"];
    } else {
        [self present:@"sbLoginViewController"];
    }
}

- (void)present:(NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
