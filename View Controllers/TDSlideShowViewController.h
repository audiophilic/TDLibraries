//	Version: 1.0
//	Instructions:
//
//	Use the class methods to create a SlideShowViewController with either Images or Views
//	If you want to use the built in timer to advance the scrollview, set the 'slideShowTimerDuration' property to the required value.
//  Once the scrollview has finished scrolling to the last page and the timer fires, the delegate method slideShowViewControllerDidFinishScrolling: is called.
//

#import <UIKit/UIKit.h>

@class TDSlideShowViewController;
@protocol TDSlideShowViewControllerDelegate <NSObject>

- (void)slideShowDidScroll:(TDSlideShowViewController *)slideShow;
- (void)slideShowDidEndDecelerating:(TDSlideShowViewController *)slideShow;
- (void)slideShowDidEndScrollingAnimation:(TDSlideShowViewController *)slideShow;
- (void)slideShowViewController:(TDSlideShowViewController *)slideShow handleTimer:(NSTimer *)timer scrollView:(UIScrollView *)scrollView;
- (void)slideShowViewControllerDidFinishScrolling:(TDSlideShowViewController *)slideShow;

@end

@interface TDSlideShowViewController : UIViewController <UIScrollViewDelegate>
{
	UIPageControl	*_pageControl;
	NSTimer			*_slideShowTimer;
}

+ (TDSlideShowViewController *)slideShowViewControllerWithImages:(NSArray *)images;
+ (TDSlideShowViewController *)slideShowViewControllerWithViews:(NSArray *)views;

@property (nonatomic, assign) id <TDSlideShowViewControllerDelegate> delegate;
@property (nonatomic, assign) NSTimeInterval slideShowTimerDuration;
@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) NSTimer *slideShowTimer;
@property (nonatomic, readonly) UIScrollView *scrollView;

@end
