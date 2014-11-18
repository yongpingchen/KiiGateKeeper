//
//  AppDelegate.h
//  KiiGateKeeper
//
//  Created by Yongping on 11/17/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, nonatomic) CLLocationManager *locationManager;

@end

