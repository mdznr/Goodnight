//
//  MTZScrollingCardsView.h
//
//  Created by Matt Zanchelli on 1/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTZScrollingCardsView : UIView<UIScrollViewDelegate>

#pragma mark Properties

/// An optional page control that you can associate with this scrolling card view
/// @discussion The page control's currentPage and numberOfPages properties are updated automatically by this class
@property (strong, nonatomic) UIPageControl *pageControl;

/// The current page the cards view is on
/// @discussion Changing this value will scroll the scroll view without animating. This will also set pageControl's (if not nil) currentPage
@property (nonatomic) NSInteger currentPage;

///
@property (nonatomic) CGFloat cardWidth;

///
@property (nonatomic) CGFloat cardPadding;

#pragma mark Initialization
///
///
- (id)initWithPages:(NSArray *)pages;


#pragma mark Configuring Pages
#warning add methods for sizing of cards (and padding?)

#pragma mark Adding Pages
///
///
- (void)addPage:(UIView *)page;

///
///
- (void)insertPage:(UIView *)page atIndex:(int)index;

///
///
- (void)addPages:(NSArray *)pages;


#pragma mark Scrolling
///
///
- (void)scrollToPageIndex:(int)index animated:(BOOL)animated;

///
///
- (void)scrollToPreviousPage;

///
///
- (void)scrollToNextPage;


#pragma mark View Misc.
///
///
- (void)viewDidResize;

@end
