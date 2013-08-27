#import "TDSlideShowViewController.h"

@interface TDSlideShowViewController ()

- (id)initWithViews:(NSArray *)theViews;
- (id)initWithImages:(NSArray *)images;
- (void)handleSlideShowTimer:(NSTimer *)timer;

@end
@implementation TDSlideShowViewController

- (void)dealloc
{
	[_items release];
	[_scrollView release];
	[_pageControl release];
	[_slideShowTimer release];
	[_slideShowTimer invalidate];
	_slideShowTimer = nil;
	_delegate = nil;
	[super dealloc];
}

- (void)setSlideShowTimerDuration:(NSTimeInterval)duration
{
	_slideShowTimerDuration = duration;
	if (_slideShowTimer)
	{
		[_slideShowTimer release];
		[_slideShowTimer invalidate];
		_slideShowTimer = nil;
	}
	_slideShowTimer = [[NSTimer timerWithTimeInterval:self.slideShowTimerDuration target:self selector:@selector(handleSlideShowTimer:) userInfo:nil repeats:YES] retain];
	[[NSRunLoop mainRunLoop] addTimer:_slideShowTimer forMode:NSRunLoopCommonModes];
	
}
#pragma mark -
#pragma mark Init

+ (TDSlideShowViewController *)slideShowViewControllerWithViews:(NSArray *)views
{
	TDSlideShowViewController *slideShowViewController = [[TDSlideShowViewController alloc] initWithViews:views];
	return [slideShowViewController autorelease];
}

+ (TDSlideShowViewController *)slideShowViewControllerWithImages:(NSArray *)images;
{
	TDSlideShowViewController *slideShowViewController = [[TDSlideShowViewController alloc] initWithImages:images];
	return [slideShowViewController autorelease];
}

- (id)initWithImages:(NSArray *)images
{
	self = [super init];
	if (self)
	{
		NSMutableArray *array = [NSMutableArray array];
		for (UIImage *image in images)
		{
			if ([image isKindOfClass:[UIImage class]])
			{
				UIImageView *iv = [[UIImageView alloc] initWithImage:image];
				[array addObject:iv];
				[iv release];
			}
			else
			{
				NSException *exception = [NSException exceptionWithName:@"SlideShowViewController_Invalid_Type"
																 reason:[NSString stringWithFormat:@"Expected object of type UIImage. Type is '%@'", [image class]]
															   userInfo:nil];
				[exception raise];
			}
		}
		
		_items = [array retain];
		
	}
	
	return self;
}

- (id)initWithViews:(NSArray *)theViews
{
	self = [super init];
	if (self)
	{
		NSMutableArray *array = [NSMutableArray array];
		for (UIView *view in theViews)
		{
			if ([view isKindOfClass:[UIView class]])
			{
				[array addObject:view];
			}
			else
			{
				NSException *exception = [NSException exceptionWithName:@"SlideShowViewController_Invalid_Type"
																 reason:[NSString stringWithFormat:@"Expected object of type UIImage. Type is %@", [view class]]
															   userInfo:nil];
				[exception raise];
			}
		}
		
		_items = [array retain];
		[self setupSlideShowViewController];
	}
	
	return self;
}

#pragma mark -
#pragma mark Setup

- (void)setupSlideShowViewController
{
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.delegate = self;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.bounces = NO;
	
	_pageControl = [[UIPageControl alloc] init];
	_pageControl.numberOfPages = _items.count;
	CGSize pageControlSize = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
	_pageControl.frame = CGRectMake(round((self.view.bounds.size.width - pageControlSize.width)/2.0), round(0.8 * self.view.bounds.size.height), pageControlSize.width, pageControlSize.height);
	
	[self.view addSubview:_scrollView];
	[self.view addSubview:_pageControl];
}

- (void)setupScrollView
{
	CGFloat xOrigin = 0.0;
	for (int index = 0; index < _items.count; index++)
	{
		UIView *item = [_items objectAtIndex:index];
		if ([item isKindOfClass:[UIView class]])
		{
			CGRect frame = item.bounds;
			frame.origin.x = xOrigin;
			item.frame = frame;
			[_scrollView addSubview:item];
			xOrigin += item.bounds.size.width;
		}
	}
	
	[_scrollView setContentSize:CGSizeMake(xOrigin, _scrollView.bounds.size.height)];
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupSlideShowViewController];
	[self setupScrollView];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
	return NO;
}


#pragma mark -
#pragma mark Page Control

- (void)updatePageControlForScrollView:(UIScrollView *)theScrollView
{
	NSInteger page = theScrollView.contentOffset.x / theScrollView.bounds.size.width;
	_pageControl.currentPage = page;
	
}
#pragma mark-
#pragma mark ScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
	if (_slideShowTimer) {
		[_slideShowTimer release];
		[_slideShowTimer invalidate];
		_slideShowTimer = nil;
	}
	
	[self updatePageControlForScrollView:theScrollView];
	
	if ([_delegate respondsToSelector:@selector(slideShowDidEndDecelerating:)])
	{
		[_delegate slideShowDidEndDecelerating:self];
	}
	
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)theScrollView
{
	[self updatePageControlForScrollView:theScrollView];
	if ([_delegate respondsToSelector:@selector(slideShowDidEndScrollingAnimation:)])
	{
		[_delegate slideShowDidEndDecelerating:self];
	}
	
}

#pragma mark -
#pragma mark SlideShow Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ([_delegate respondsToSelector:@selector(slideShowDidScroll:)])
	{
		[_delegate slideShowDidScroll:self];
	}
}

- (void)handleSlideShowTimer:(NSTimer *)timer
{
	if ((self.items.count - 1) * _scrollView.bounds.size.width == _scrollView.contentOffset.x)
	{
		[_slideShowTimer release];
		[_slideShowTimer invalidate];
		_slideShowTimer = nil;
		if ([_delegate respondsToSelector:@selector(slideShowViewControllerDidFinishScrolling:)])
		{
			[_delegate slideShowViewControllerDidFinishScrolling:self];
		}
	}
	else
	{
		[_scrollView setContentOffset:CGPointMake(MIN(_scrollView.contentOffset.x + _scrollView.bounds.size.width, self.items.count * _scrollView.bounds.size.width), 0) animated:YES];
	}
	
	if ([_delegate respondsToSelector:@selector(slideShowViewController:handleTimer:scrollView:)])
	{
		[_delegate slideShowViewController:self handleTimer:timer scrollView:_scrollView];
	}
}
@end
