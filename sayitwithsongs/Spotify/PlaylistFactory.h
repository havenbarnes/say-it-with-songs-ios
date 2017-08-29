//
//  PlaylistFactory.h
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/28/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpotifyManager.h"

@interface PlaylistFactory : NSObject

- (void)generatePlaylist:(NSString *)phrase completion:(void(^)(SPTPlaylistSnapshot *))callback;
@end
