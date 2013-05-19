#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kMaxOriginPercentage 0.80
#define kMinOriginPercentage 0.20
#define kMinRequiredVelocity 500.0
#define kBorderPercentage 0.40
#define kDefaultSlideAnimationDuration 0.25

typedef enum {
	PanDirectionLeft,
	PanDirectionRight
}PanDirection;

typedef enum{
	SlideDirectionLeft,
	SlideDirectionRight,
    SlideDirectionEither
}SlideDirection;

@interface TDSlideViewController : UIViewController <UIGestureRecognizerDelegate>

@property (retain, nonatomic) UIViewController			*leftViewController;
@property (retain, nonatomic) UIViewController			*rightViewController;
@property (retain, nonatomic) UIViewController			*mainViewController;
@property (assign, nonatomic) BOOL						shadowEnabled;
@property (assign, nonatomic) BOOL						panGestureEnabled;

+ (TDSlideViewController *)sharedInstance;

@end
