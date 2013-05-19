#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kTDLocationManagerDefaultAccuracy kCLLocationAccuracyBest
#define TDLocationManagerDidUpdateLocationNotification @"TDLocationManagerDidUpdateLocation"
#define TDLocationManagerDidFailNotification @"TDLocationManagerDidFail"
#define kTDLocationManagerRequiredAccuracy 100.0
#define kTDLocationManagerRequiredDelta 300.0
#define kTDLocationManagerError @"Error"
#define kTDLocationManagerLocation @"Location"
#define kTDLocationManagerAuthStatusDeclined @"User has explicitly denied authorization for this application, or location services are disabled in Settings"
#define kTDLocationManagerErrorDomain [[NSBundle mainBundle] bundleIdentifier]

typedef enum{
    TDLocationManagerErrorAuthorizationStatus = 100,
    TDLocationManagerErrorUnknown = 101
}TDLocationManagerError;

@interface TDLocationManager : NSObject <CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocation            *currentLocation;
@property (retain, nonatomic) CLLocationManager     *locationManager;

+ (TDLocationManager *)sharedInstance;

- (void)updateLocation;
- (void)stopUpdatingLocation;

@end
