#import "TDLocationManager.h"

static TDLocationManager *sharedLocationManager = nil;

@interface TDLocationManager ()

@end

@implementation TDLocationManager


+ (TDLocationManager *)sharedInstance
{
    if(!sharedLocationManager)
    {
        sharedLocationManager = [[TDLocationManager alloc] init];
    }
    
    return sharedLocationManager;
}

- (id)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kTDLocationManagerDefaultAccuracy;
    }
    
    return self;
}

- (void)dealloc
{
    [_currentLocation release];
    _currentLocation = nil;
    [_locationManager release];
    _locationManager = nil;
    [super dealloc];
    
}

- (void)updateLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}

- (BOOL)validateNewLocation:(CLLocation *)newLocation
{
    if(newLocation.horizontalAccuracy > kTDLocationManagerRequiredAccuracy)
        return NO;
    
    //check the timestamp of the location to make sure the cached location is recent
    NSDate *newLocationTimeStamp = [newLocation timestamp];
    NSTimeInterval delta = [newLocationTimeStamp timeIntervalSinceNow];
    
    if(ABS(delta) > kTDLocationManagerRequiredDelta)
        return NO;

    return YES;
    
}

#pragma mark -
#pragma mark -CLLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if([self validateNewLocation:newLocation])
    {
        [_locationManager stopUpdatingLocation];
        [_currentLocation release];
        _currentLocation = [newLocation retain];
        [[NSNotificationCenter defaultCenter] postNotificationName:TDLocationManagerDidUpdateLocationNotification object:newLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{


    CLLocation *newLocation = [locations lastObject];
    if([self validateNewLocation:newLocation])
    {
        [_locationManager stopUpdatingLocation];
        [_currentLocation release];
        _currentLocation = [newLocation retain];
        [[NSNotificationCenter defaultCenter] postNotificationName:TDLocationManagerDidUpdateLocationNotification object:newLocation];
    }
}

@end
