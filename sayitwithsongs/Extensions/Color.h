//
//  Color.h
//  sayitwithsongs
//
//  Created by Haven Barnes on 8/27/17.
//  Copyright © 2017 Azing. All rights reserved.
//

#ifndef Color_h
#define Color_h

#define UIColor(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#endif /* Color_h */
