//
//  GNViewController.h
//  Goodnight
//
//  Created by Matt on 5/4/12.
//  Copyright (c) 2012 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GNViewController : UIViewController

@property (strong, nonatomic) UILocalNotification *alarm;

- (IBAction)didSayGoodnight:(UIButton *)sender;

@end
