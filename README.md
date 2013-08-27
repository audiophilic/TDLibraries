TDLibraries
===========


##Managers


##TDLocationManager
*TDLocationManager* allows you to acquire the user's location without having to deal with the hassles of setting it up correctly and efficiently. Everything is taken care of and it is very easy to use.

###Setup
1. Download the zip file of this repo
2. Add TDLocationManager.h/m files into your Xcode Project.
3. Add youself as an observer to the two Notifications `TDLocationManagerDidUpdateLocationNotification` and `TDLocationManagerDidFailNotification` in your respective ViewControllers

###Example Code:
```objective-c
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    	...
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didUpdateToLocation:)
                                                     name:TDLocationManagerDidUpdateLocationNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFailWithError:)
                                                     name:TDLocationManagerDidFailNotification
                                                   object:nil];
    	...
    }
    return self;
}

````
That's it! The new `CLLocation` and `NSError` are returned in the object property of the `NSNotifications`.

=
##TDSlideViewController
*TDSlideViewController* is a simple and easy to use `UIViewController` container that is designed to have two revealable panels (left and right) underneath a centre panel. It is inspired by the Facebook slide controller.

###Features
- Supports both left and right panels
- Supports both iPhone and iPad


###Setup
1. Download the zip file of this repo.
2. Add TDSlideViewController.h/m files into your Xcode Project.
3. If you want to enable shadows (enabled by default), you will need to link your project with QuartzCore.framework.

###Example Code:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    ...
    TDSlideViewController *slideViewController = [TDSlideViewController sharedInstance];
    MainViewController *mainViewController = [[MainViewController alloc] init];
    LeftViewController *leftViewController = [[LeftViewController alloc] init];
    RightViewController *rightViewController = [[RightViewController alloc] init];

    [slideViewController setMainViewController:mainViewController];
    [slideViewController setLeftViewController:leftViewController];
    [slideViewController setRightViewController:rightViewController];

    [mainViewController release];
    [leftViewController release];
    [rightViewController release];
    ...
    
    return YES;
}

````

##TDSlideShowViewController
*TDSlideShowViewController* is a drop-in solution to present the user with a SlideShow/Tutorial.

###Features
- Automatically advance slideshow
- Forward delegate methods for added functionality

###Setup
1. Download the zip file of this repo.
2. Add TDSlideShowViewController.h/m files into your Xcode Project.
3. Use the class methods `slideShowViewControllerWithImages:` or `slideShowViewControllerWithViews:` to create the a Slide Show View Controller with the respective Objects.
4. If you want to use the built in timer to automatically advance the scrollview, just set the `slideShowTimerDuration` property.
5. Once the scrollview has finished scrolling to the last page and the timer fires, the delegate method slideShowViewControllerDidFinishScrolling: is called.

###Example Code:
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    ...
	UIImageView *iv1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image1.jpg"]];
	UIImageView *iv2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image2.jpg"]];
	UIImageView *iv3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image3.jpg"]];
	UIImageView *iv4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Image4.jpg"]];

    TDSlideShowViewController *slideShowViewController = [TDSlideShowViewController slideShowViewControllerWithViews:@[iv1, iv2, iv3, iv4]];
	slideShowViewController.slideShowTimerDuration = 3.0;
    slideShowViewController.delegate = self;

	[iv1 release];
	[iv2 release];
	[iv3 release];
	[iv4 release];

    ...
    
    return YES;
}

````

===
##License

> TDSlideViewController, TDLocationManager - Copyright (C) 2013 Thisal De Silva
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
> 
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
> 
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
