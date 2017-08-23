//
//  ViewController.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/21/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SpotifyManager *spotifyManager = [SpotifyManager current];
    spotifyManager.delegate = self;
    [spotifyManager initialize];
}

- (void)spotifyAuthenticated:(BOOL)loggedIn auth:(SPTAuth *)auth {
    if (loggedIn) {
        // Contine Into App
    } else {
        // Authorize
        NSURL *authURL = [auth spotifyWebAuthenticationURL];
        // Present in a SafariViewController
        SFSafariViewController *authViewController = [[SFSafariViewController alloc] initWithURL:authURL];
        [self presentViewController:authViewController animated:YES completion:nil];
    }
}

@end
