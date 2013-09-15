//
//  MTZScrollingCardsView.m
//
//  Created by Matt on 1/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZScrollingCardsView.h"

@implementation MTZScrollingCardsView
{
	NSMutableArray *allPages;
}

#pragma mark Initialization Methods
- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
    if ( self ) {
		[self setup];
	}
	return self;
}

- (id)initWithPages:(NSArray *)pages
{
	self = [super init];
	if ( self ) {
		[self setup];
		[self addPages:pages];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self setup];
    }
    return self;
}

- (void)setup
{
	[self setDelegate:self];
	
	[self setPagingEnabled:YES];
	[self setScrollsToTop:NO];
	[self setShowsHorizontalScrollIndicator:NO];
	[self setShowsVerticalScrollIndicator:NO];
	
	// Most should have at least three items.
	allPages = [[NSMutableArray alloc] initWithCapacity:3];
	
	// Start off the walkthrough on the first page
	_currentPage = 0;
}


#pragma mark Properties

- (void)setPageControl:(UIPageControl *)pageControl
{
	_pageControl = pageControl;
	_pageControl.numberOfPages = allPages.count;
	_pageControl.currentPage = _currentPage;
	
	[_pageControl addTarget:self
					 action:@selector(scrollToPageControlCurrentPageIndex)
		   forControlEvents:UIControlEventValueChanged];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
	_currentPage = currentPage;
	if ( _pageControl ) {
		_pageControl.currentPage = currentPage;
	}
	[self scrollToPageIndex:currentPage animated:NO];
}


#pragma mark Adding Pages
- (void)addPage:(UIView *)page
{
	[self addSubview:page];
	[allPages addObject:page];
	[self updateSizingAndPositioning];
}

- (void)insertPage:(UIView *)page atIndex:(int)index
{
	[self addSubview:page];
	[allPages insertObject:page atIndex:index];
	[self updateSizingAndPositioning];
}

- (void)addPages:(NSArray *)pages
{
	for ( NSInteger i=0; i < pages.count; ++i ) {
		[self addSubview:pages[i]];
	}
	[allPages addObjectsFromArray:pages];
	[self updateSizingAndPositioning];
}


#pragma Scrolling
- (void)scrollToPageIndex:(int)index animated:(BOOL)animated
{
	_currentPage = index;
    CGRect pageFrame = CGRectMake(self.frame.size.width * index, 1,
								  self.frame.size.width, 1);
    [self scrollRectToVisible:pageFrame animated:animated];
}

- (void)scrollToPreviousPage
{
	[self scrollToPageIndex:_currentPage-1 animated:YES];
}

- (void)scrollToNextPage
{
	[self scrollToPageIndex:_currentPage+1 animated:YES];
}

- (void)scrollToPageControlCurrentPageIndex
{
	NSInteger toPage = _pageControl.currentPage;
	_pageControl.currentPage = _currentPage;
	[self scrollToPageIndex:toPage animated:YES];
}

#pragma mark View Misc.
- (void)viewDidResize
{
	[self updateSizingAndPositioning];
	[self scrollToPageIndex:_currentPage animated:NO]; // animated or not?
}

- (void)updateSizingAndPositioning
{
	NSInteger numberOfPages = allPages.count;
	
	CGFloat width = self.frame.size.width;
	CGFloat height = self.frame.size.height;
	
	for ( NSInteger i=0; i < numberOfPages; ++i ) {
		((UIView *)allPages[i]).center = (CGPoint){width*(i+0.5f), height/2};
	}
	[self setContentSize:CGSizeMake(self.frame.size.width * numberOfPages, 0)];
	[_pageControl setNumberOfPages:numberOfPages];
}


#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Calculate the current page index and set it
	_currentPage = (NSInteger) ( scrollView.contentOffset.x / scrollView.frame.size.width + .5 );
	[_pageControl setCurrentPage:_currentPage];
}

@end
