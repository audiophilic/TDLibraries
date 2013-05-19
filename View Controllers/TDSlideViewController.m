#import "TDSlideViewController.h"

static TDSlideViewController *_slideViewController = nil;

@interface TDSlideViewController ()

//Properties
@property (retain, nonatomic) UIPanGestureRecognizer	*panGestureRecognizer;
@property (assign, nonatomic) CGPoint					beginningTouchLocation;
@property (assign, nonatomic) BOOL						isDrawerOpen;
@property (assign, nonatomic) BOOL						leftDrawerVisible;
@property (assign, nonatomic) BOOL						rightDrawerVisible;
@property (assign, nonatomic) BOOL						leftDrawerOpen;
@property (assign, nonatomic) BOOL						rightDrawerOpen;

//Methods
- (void)openLeftDrawer:(BOOL)open withDuration:(CGFloat)duration;
- (void)openRightDrawer:(BOOL)open withDuration:(CGFloat)duration;
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture;
- (void)slideView:(UIView *)view withVelocity:(CGFloat)velocity inDirection:(SlideDirection)direction;
- (void)translateGesture:(UIPanGestureRecognizer *)gesture byTranslation:(CGFloat)translation inDirection:(PanDirection)direction;
- (void)orientationChanged;
@end

@implementation TDSlideViewController
{}
#pragma mark Getters and Setters
- (BOOL)isLeftDrawerOpen
{
    return (self.mainViewController.view.frame.origin.x == kMaxOriginPercentage * CGRectGetWidth(self.mainViewController.view.bounds));
}
-(BOOL)isRightDrawerOpen
{
    return (self.mainViewController.view.frame.origin.x == -kMaxOriginPercentage * CGRectGetWidth(self.mainViewController.view.bounds));
}

- (void)setDrawerStates
{
	CGRect mainViewRect = self.mainViewController.view.frame;
	self.beginningTouchLocation = CGPointZero;
	if(mainViewRect.origin.x == 0)
        self.isDrawerOpen = self.leftDrawerVisible = self.rightDrawerVisible = self.leftDrawerOpen = self.rightDrawerOpen = NO;
    
	else if(mainViewRect.origin.x < 0)
	{
		self.isDrawerOpen = self.rightDrawerVisible = self.rightDrawerOpen = YES;
		self.leftDrawerVisible = NO;
	}
	else
	{
		self.isDrawerOpen = self.leftDrawerVisible =self.leftDrawerOpen = YES;
		self.rightDrawerVisible = NO;
	}
}

- (void)setMainViewController:(UIViewController *)mainViewController
{
	if(_mainViewController != mainViewController)
	{
		[_mainViewController release];
		_mainViewController = [mainViewController retain];
		[self.mainViewController.view setFrame:self.view.bounds];
		[self.view addSubview:self.mainViewController.view];
		if(self.shadowEnabled)
		{
			[self.mainViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
			[self.mainViewController.view.layer setShadowOpacity:0.8];
			[self.mainViewController.view.layer setShadowRadius:4.0];
			[self.mainViewController.view.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
			self.mainViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.mainViewController.view.frame].CGPath;
		}
	}
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
	if(_leftViewController != leftViewController)
	{
		[_leftViewController release];
		_leftViewController = [leftViewController retain];
		CGRect leftRect = self.leftViewController.view.frame;
		leftRect.size.width = kMaxOriginPercentage * CGRectGetWidth(self.view.bounds);
		[self.leftViewController.view setFrame:leftRect];
	}
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
	if(_rightViewController != rightViewController)
	{
		[_rightViewController release];
		_rightViewController = [rightViewController retain];
		CGRect rightRect = self.view.bounds;
		rightRect.origin.x = kMinOriginPercentage * CGRectGetWidth(self.view.bounds);
		rightRect.size.width = kMaxOriginPercentage * CGRectGetWidth(self.view.bounds);
		[self.rightViewController.view setFrame:rightRect];
	}
}

#pragma mark -
#pragma mark Class and Instance Methods
+ (TDSlideViewController *)sharedInstance
{
	if (!_slideViewController)
	{
		_slideViewController = [[TDSlideViewController alloc] init];
	}
	
	return _slideViewController;
}
- (void)setupSlideController
{
	self.shadowEnabled = YES;
	self.panGestureEnabled = YES;
	self.leftDrawerVisible = self.rightDrawerVisible = self.isDrawerOpen = NO;
	self.beginningTouchLocation = CGPointZero;
}
- (id)init
{
	if(self = [super init])
	{
		[self setupSlideController];
	}
	
	return self;
}

#pragma mark -
#pragma mark View Lifecycle
- (void)viewDidLoad
{
	[super viewDidLoad];
	if(self.panGestureEnabled)
	{
		self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
		self.panGestureRecognizer.maximumNumberOfTouches = 1;
		self.panGestureRecognizer.delegate = self;
		[self.view addGestureRecognizer:self.panGestureRecognizer];
        [self.view setBackgroundColor:[UIColor blackColor]];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[_panGestureRecognizer release];
	[_leftViewController release];
	[_rightViewController release];
	[_mainViewController release];
	[super dealloc];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [[event allTouches] anyObject];
	CGRect mainViewRect = self.mainViewController.view.frame;
	CGPoint location = [touch locationInView:self.mainViewController.view];
	
	if((self.rightDrawerOpen || self.leftDrawerOpen) && !CGPointEqualToPoint(self.beginningTouchLocation, CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)))
	{
		if (CGRectContainsPoint(CGRectMake(0, 0, kMinOriginPercentage * CGRectGetWidth(mainViewRect), mainViewRect.size.height), location)) {
            
			[self openLeftDrawer:NO withDuration:kDefaultSlideAnimationDuration];
		}
		
		else if (CGRectContainsPoint(CGRectMake(kMaxOriginPercentage * CGRectGetWidth(mainViewRect), 0, kMinOriginPercentage * CGRectGetWidth(mainViewRect), mainViewRect.size.height), location))
		{
			[self openRightDrawer:NO withDuration:kDefaultSlideAnimationDuration];
		}
	}
}

- (void)orientationChanged
{
    [self openLeftDrawer:self.leftDrawerOpen withDuration:kDefaultSlideAnimationDuration];
    [self openRightDrawer:self.rightDrawerOpen withDuration:kDefaultSlideAnimationDuration];
}
#pragma mark - 
#pragma mark SlideController Methods
- (void)openLeftDrawer:(BOOL)open withDuration:(CGFloat)duration
{
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView animateWithDuration:kDefaultSlideAnimationDuration animations:^{
		CGRect mainViewRect = self.mainViewController.view.frame;
		mainViewRect.origin.x = (open ? kMaxOriginPercentage * CGRectGetWidth(mainViewRect) : 0.0);
		self.mainViewController.view.frame = mainViewRect;
	} completion:^(BOOL finished) {
		[self setDrawerStates];
	}];
}

- (void)openRightDrawer:(BOOL)open withDuration:(CGFloat)duration
{
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView animateWithDuration:kDefaultSlideAnimationDuration animations:^{
		CGRect mainViewRect = self.mainViewController.view.frame;
		mainViewRect.origin.x = (open ? -kMaxOriginPercentage * CGRectGetWidth(mainViewRect) : 0.0);
		self.mainViewController.view.frame = mainViewRect;
	} completion:^(BOOL finished) {
		[self setDrawerStates];
	}];
}

- (void)translateGesture:(UIPanGestureRecognizer *)gesture byTranslation:(CGFloat)translation inDirection:(PanDirection)direction
{
	if (direction == PanDirectionLeft)
	{
		if(!self.rightDrawerVisible && !self.isDrawerOpen)
		{
			[self.view insertSubview:self.rightViewController.view belowSubview:self.mainViewController.view];
			self.rightDrawerVisible = YES;
			self.isDrawerOpen = YES;
		}
		CGRect mainViewRect = self.mainViewController.view.frame;
		CGFloat maxOrigin = (self.leftDrawerVisible ? 0 : - (kMaxOriginPercentage * CGRectGetWidth(mainViewRect)));
		mainViewRect.origin.x = MAX(maxOrigin, mainViewRect.origin.x + translation);
		self.mainViewController.view.frame = mainViewRect;
	}
	
	else
	{
		if(!self.leftDrawerVisible && !self.isDrawerOpen)
		{
			[self.view insertSubview:self.leftViewController.view belowSubview:self.mainViewController.view];
			self.leftDrawerVisible = YES;
			self.isDrawerOpen = YES;
		}
		CGRect mainViewRect = self.mainViewController.view.frame;
		CGFloat maxOrigin = (self.rightDrawerVisible ? 0 : kMaxOriginPercentage * CGRectGetWidth(mainViewRect));
		mainViewRect.origin.x = MIN(maxOrigin, mainViewRect.origin.x + translation);
		self.mainViewController.view.frame = mainViewRect;
	}
	
	[gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];
}
- (void)slideView:(UIView *)view withVelocity:(CGFloat)velocity inDirection:(SlideDirection)direction
{
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    CGFloat newOrigin = 0.0;
    CGFloat distance = 0.0;
    __block CGRect viewRect = view.frame;
    
    if(!velocity)
    {
		/*
		1.	If right drawer is open and you have panned the view less than the minimum required to close the drawer, then keep it open.
		2.	If left drawer is open and you have panned the view less than the minimum required to close the drawer, then keep it open.
        3.  Else view has just been panned and has not met requirements to open either drawer, so close it.
		 */
        
		if ((self.rightDrawerOpen || !self.rightDrawerOpen) && viewRect.origin.x <= -kBorderPercentage * CGRectGetWidth(viewRect))
			[self openRightDrawer:YES withDuration:kDefaultSlideAnimationDuration];
		
		else if ((self.leftDrawerOpen || !self.leftDrawerOpen) && viewRect.origin.x >= kBorderPercentage * CGRectGetWidth(viewRect))
			[self openLeftDrawer:YES withDuration:kDefaultSlideAnimationDuration];
		
		else
			[self openRightDrawer:NO withDuration:kDefaultSlideAnimationDuration];
    }
    
    else
    {
		if(direction == SlideDirectionRight)
		{
			newOrigin = (self.rightDrawerOpen || self.leftDrawerOpen || self.rightDrawerVisible ? 0 : kMaxOriginPercentage * CGRectGetWidth(viewRect));
			distance = round(abs(abs(viewRect.origin.x) - abs(newOrigin)));
			[self openLeftDrawer:(newOrigin != 0.0) withDuration:(distance/velocity)];
		}

		else if (direction == SlideDirectionLeft)
		{
			newOrigin = (self.rightDrawerOpen || self.leftDrawerOpen || self.leftDrawerVisible ? 0 : -kMaxOriginPercentage * CGRectGetWidth(viewRect));
			distance = round(abs(abs(viewRect.origin.x) - abs(newOrigin)));
			[self openRightDrawer:(newOrigin != 0.0) withDuration:(distance/velocity)];
		}
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
	CGPoint translation = [gesture translationInView:gesture.view];
	//pan view with finger
	if(gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged)
	{
		CGFloat translationInX = translation.x;
        if (translationInX != 0.0) 
            [self translateGesture:gesture byTranslation:translationInX inDirection:(translationInX < 0.0 ? PanDirectionLeft : PanDirectionRight)];
	}
	
	//open or close the drawers.
	else if(gesture.state == UIGestureRecognizerStateEnded)
	{
        CGPoint velocity = [gesture velocityInView:gesture.view];
        if (abs(velocity.x) < kMinRequiredVelocity)
            [self slideView:self.mainViewController.view withVelocity:0.0 inDirection:SlideDirectionEither];
        else
            [self slideView:self.mainViewController.view  withVelocity:velocity.x inDirection:(velocity.x > 0 ? SlideDirectionRight : SlideDirectionLeft)];
	}
}
@end
