#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kTDLocationManagerDefaultAccuracy kCLLocationAccuracyBest
#define TDLocationManagerDidUpdateLocationNotification @"TDLocationManagerDidUpdateLocation"
#define kTDLocationManagerRequiredAccuracy 100.0
#define kTDLocationManagerRequiredDelta 30.0

@interface TDLocationManager : NSObject <CLLocationManagerDelegate>

@property (retain, nonatomic) CLLocation            *currentLocation;
@property (retain, nonatomic) CLLocationManager     *locationManager;

+ (TDLocationManager *)sharedInstance;

- (void)updateLocation;
- (void)stopUpdatingLocation;

@end
