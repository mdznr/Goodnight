//
//  MTZScrollingCardsView.m
//
//  Created by Matt Zanchelli on 1/14/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "MTZScrollingCardsView.h"

@interface MTZScrollingCardsView ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *allPages;

@end

@implementation MTZScrollingCardsView

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
#warning reset frame when cardWidth or cardPadding changes
	_scrollView = [[UIScrollView alloc] init];
	_scrollView.clipsToBounds = NO;
	_scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	[self addSubview:_scrollView];
	
	_scrollView.delegate = self;
	_scrollView.pagingEnabled = YES;
	_scrollView.scrollsToTop = NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.showsVerticalScrollIndicator = NO;
	
	// Most should have at least three items.
	_allPages = [[NSMutableArray alloc] initWithCapacity:3];
	
	// Start off on the first page
	_currentPage = 0;
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(didTap:)];
	[self addGestureRecognizer:tap];
}


#pragma mark Properties

- (void)setPageControl:(UIPageControl *)pageControl
{
	_pageControl = pageControl;
	_pageControl.numberOfPages = _allPages.count;
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

- (void)setCardWidth:(CGFloat)cardWidth
{
	_cardWidth = cardWidth;
	_scrollView.frame = (CGRect){0, 0, cardWidth + _cardPadding, self.frame.size.height};
	_scrollView.center = self.center;
	[self updateSizingAndPositioning];
}

- (void)setCardPadding:(CGFloat)cardPadding
{
	_cardPadding = cardPadding;
	_scrollView.frame = (CGRect){0, 0, _cardWidth + cardPadding, self.frame.size.height};
	_scrollView.center = self.center;
	[self updateSizingAndPositioning];
}


#pragma mark Adding Pages
- (void)addPage:(UIView *)page
{
	[_scrollView addSubview:page];
	[_allPages addObject:page];
	[self updateSizingAndPositioning];
}

- (void)insertPage:(UIView *)page atIndex:(int)index
{
	[_scrollView addSubview:page];
	[_allPages insertObject:page atIndex:index];
	[self updateSizingAndPositioning];
}

- (void)addPages:(NSArray *)pages
{
	for ( NSInteger i=0; i < pages.count; ++i ) {
		[_scrollView addSubview:pages[i]];
	}
	[_allPages addObjectsFromArray:pages];
	[self updateSizingAndPositioning];
}


#pragma Scrolling
- (void)scrollToPageIndex:(int)index animated:(BOOL)animated
{
	_currentPage = index;
    CGRect pageFrame = CGRectMake(_scrollView.frame.size.width * index, 1,
								  _scrollView.frame.size.width, 1);
    [_scrollView scrollRectToVisible:pageFrame animated:animated];
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
	NSInteger numberOfPages = _allPages.count;
	
	CGFloat width = _scrollView.frame.size.width;
	CGFloat height = _scrollView.frame.size.height;
	
	for ( NSInteger i=0; i < numberOfPages; ++i ) {
		((UIView *)_allPages[i]).center = (CGPoint){width*(i+0.5f), height/2};
	}
	[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width * numberOfPages, 0)];
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


#pragma mark Gesture Recognizers

- (void)didTap:(UITapGestureRecognizer *)sender
{
	[self scrollToNextPage];
	
	CGPoint point = [sender locationInView:self];
	if ( _currentPage >= 1 && [((UIView*)_allPages[_currentPage-1]) pointInside:point withEvent:nil] ) {
		[self scrollToPreviousPage];
	} else if ( _currentPage+1 < _allPages.count && [((UIView*)_allPages[_currentPage+1]) pointInside:point withEvent:nil] ) {
		[self scrollToNextPage];
	}
}


#pragma mark Override hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if ( [self pointInside:point withEvent:event] && !self.hidden && self.alpha > 0.1f ) {
		return _scrollView;
	} else {
		return nil;
	}
}

@end
