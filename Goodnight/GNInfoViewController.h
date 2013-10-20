//
//  GNInfoViewController.h
//  Goodnight
//
//  Created by Matt on 9/18/13.
//  Copyright (c) 2013 Matt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNInfoViewController : UIViewController

@property (strong, nonatomic) id delegate;

- (void)show;
- (void)hide;

@end
