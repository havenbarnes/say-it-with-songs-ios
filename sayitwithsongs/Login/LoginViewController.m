//
//  ViewController.m
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/21/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import "LoginViewController.h"
#import "SpotifyManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLogin:)
                                                 name:@kSessionUpdatedKey object:nil];
}

- (IBAction)loginButtonPressed:(id)sender {
    // Authorize.
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSURL *authURL = [auth spotifyWebAuthenticationURL];
    // Present in a SafariViewController
    SFSafariViewController *authViewController = [[SFSafariViewController alloc] initWithURL:authURL];
    [self presentViewController:authViewController animated:YES completion:nil];

}

- (void)handleLogin:(NSNotification *)note {
    [self present:@"sbInputViewController"];
}

- (void)present:(NSString *)identifier {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:vc animated:YES completion:NULL];
}

@end
