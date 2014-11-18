//
//  ViewController.h
//  MockRP
//
//  Created by Syah Riza on 11/18/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBPeripheralManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) CLBeaconRegion *myBeaconRegion;
@property (strong, nonatomic) NSDictionary *myBeaconData;
@property (strong, nonatomic) CBPeripheralManager *peripheralManager;

@end

