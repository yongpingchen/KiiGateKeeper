//
//  AppDelegate.m
//  KiiGateKeeper
//
//  Created by Yongping on 11/17/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Kii initialization
    [Kii beginWithID:@"734a615f"
              andKey:@"c85705b17bd4f8961ebe3c18bc7e2178"
             andSite:kiiSiteJP];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestAlwaysAuthorization];
    _locationManager.delegate=self;
//    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"] major:0 minor:0 identifier:@"raspberry.pi"];
//    //TODO: implementation.
//    [self.locationManager startMonitoringForRegion:region];
//    NSError* error= nil;
//    [KiiUser authenticateSynchronous:@"kiisecurity" withPassword:@"kiisecurity" andError:&error];
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    if (!error) {
//        [defaults setObject:[KiiUser currentUser].accessToken forKey:@"accessToken"];
//        [defaults synchronize];
//    }
//    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - location 
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    NSLog(@"locationManager didDetermineState INSIDE for %@", region.identifier);

}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside) {
        //    NSLog(@"locationManager didDetermineState INSIDE for %@", region.identifier);
        [_locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }else if(state == CLRegionStateOutside) {
        
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion - error: %@ reg: %@", [error localizedDescription],region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count>0) {
        CLBeacon* b1 =[beacons objectAtIndex:0];
        NSString *desc1= [NSString stringWithFormat:@"%@-%ld-%ld",[b1.proximityUUID UUIDString],(long)[b1.major integerValue],(long)[b1.minor integerValue]];
        
        if (b1.rssi == 0) {
            return;
        }
        NSLog(@"%d - %f",b1.proximity, b1.accuracy);
        NSLog(@"Beacon %@",desc1);
    }
}
@end
