//
//  ViewController.m
//  KiiGateKeeper
//
//  Created by Yongping on 11/17/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* accessToken = [defaults objectForKey:@"accessToken"];
    if (accessToken) {
        [KiiUser authenticateWithToken:accessToken andBlock:^(KiiUser *user, NSError *error) {
            if (!error) {
                
                CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:RP_UUID] identifier:@"raspberry_pi"];
                //TODO: implementation.
                [appDelegate.locationManager startMonitoringForRegion:region];
                NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:user.userID];
                
                // Initialize the Beacon Region
                self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                              major:0
                                                                              minor:0
                                                                         identifier:@"mylogs"];
                
            }
        }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
