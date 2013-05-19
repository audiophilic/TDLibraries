TDLibraries
===========

##Managers
###TDLocationManager
*TDLocationManager* allows you to use the iPhone's GPS chip to acquire the user's location without having to deal with the hassles of setting it up efficiently. Everythign is taken care of and it makes your life just that much easier!

###How to use it
1. Download the zip file of this repo
2. Add TDLocationManager.h/m files into your Xcode Project.
3. Add youself as an observer to the Notification 'TDLocationManagerDidUpdateLocationNotification' in your respective ViewControllers

```objective-c
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   [[NSNotificationCenter defaultCenter] addObserver:self 
                                         selector:@selector(yourSelector:) 
                                             name:TDLocationManagerDidUpdateLocationNotification 
                                           object:nil];
}
```
That's it! The new location (`CLLocation`) is returned as the object property of the Notification.
