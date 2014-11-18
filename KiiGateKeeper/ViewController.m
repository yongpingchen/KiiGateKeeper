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
    

}
-(void) bluetoothTask:(KiiUser*) user{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:RP_UUID] major:0 minor:0 identifier:@"raspberry.pi"];
    //TODO: implementation.
    [appDelegate.locationManager startMonitoringForRegion:region];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:user.userID];
    
    // Initialize the Beacon Region
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                  major:0
                                                                  minor:0
                                                             identifier:@"mylogs"];
}
-(void) viewDidAppear:(BOOL)animated{
    
    if ([KiiUser currentUser]) {
        [self bluetoothTask:[KiiUser currentUser]];
        UITableViewController *roleTableVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RoleTableViewController"];
        [self.navigationController pushViewController:roleTableVC animated:YES];
        return;
    }
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* accessToken = [defaults objectForKey:@"accessToken"];
    if (accessToken) {
        [KiiUser authenticateWithToken:accessToken andBlock:^(KiiUser *user, NSError *error) {
            if (!error) {
                [self bluetoothTask:user];
//                [self performSegueWithIdentifier:@"showAccessLog" sender:nil];
                UITableViewController *roleTableVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RoleTableViewController"];
                [self.navigationController pushViewController:roleTableVC animated:YES];
            }else{
                [self performSegueWithIdentifier:@"showLogin" sender:nil];
            }
        }];
    }else{
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
