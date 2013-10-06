//
//  GNViewController.h
//  Goodnight
//
//  Created by Matt Zanchelli on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	GNSkyModeDusk,
	GNSkyModeDawn
} GNSkyMode;

@interface GNViewController : UIViewController

///
@property (nonatomic) GNSkyMode skyMode;

@end
