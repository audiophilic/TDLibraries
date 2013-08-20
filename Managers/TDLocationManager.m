#import "TDLocationManager.h"

static TDLocationManager *sharedLocationManager = nil;

@interface TDLocationManager ()

- (BOOL)checkLocationServices;
@end

@implementation TDLocationManager


+ (TDLocationManager *)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedLocationManager = [[TDLocationManager alloc] init];
    });
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
- (BOOL)checkLocationServices
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            NSError *error = nil;
            NSMutableDictionary *errorInfo = nil;
            errorInfo = [NSMutableDictionary dictionaryWithObject:kTDLocationManagerAuthStatusDeclined forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:kTDLocationManagerErrorDomain
                                        code:TDLocationManagerErrorAuthorizationStatus
                                    userInfo:errorInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:TDLocationManagerDidFailNotification
                                                                object:error];
            return NO;
        }
    }
    
    return YES;
}
- (void)updateLocation
{
    if ([self checkLocationServices])
    {
        [self.locationManager startUpdatingLocation];
    }

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
    switch ([error code]) {
        case kCLErrorLocationUnknown:
            break;
        case kCLErrorDenied:
        {
            [self.locationManager stopUpdatingLocation];
            [[NSNotificationCenter defaultCenter] postNotificationName:TDLocationManagerDidFailNotification object:error];
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSError *error = nil;
    NSMutableDictionary *errorInfo = nil;
    switch (status) {
        case kCLAuthorizationStatusDenied:
        {
            errorInfo = [NSMutableDictionary dictionaryWithObject:kTDLocationManagerAuthStatusDeclined forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:kTDLocationManagerErrorDomain
                                        code:TDLocationManagerErrorAuthorizationStatus
                                    userInfo:errorInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:TDLocationManagerDidFailNotification
                                                                object:error];
                    break;
        }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if([self validateNewLocation:newLocation])
    {
        [_locationManager stopUpdatingLocation];
        [_currentLocation release];
        _currentLocation = [newLocation retain];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.currentLocation, kTDLocationManagerLocation,
                              nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TDLocationManagerDidUpdateLocationNotification object:info];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"%@", [newLocation description]);
    if([self validateNewLocation:newLocation])
    {
        [_locationManager stopUpdatingLocation];
        [_currentLocation release];
        _currentLocation = [newLocation retain];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              self.currentLocation, kTDLocationManagerLocation,
                              nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:TDLocationManagerDidUpdateLocationNotification object:info];
    }
}

@end
