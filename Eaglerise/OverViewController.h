//
//  OverViewController.h
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
#import "SVProgressHUD.h"
#import "FViewController.h"
#import "AppDelegate.h"

@interface OverViewController : FViewController
{
@public
    BabyBluetooth *baby;
}
@property __block NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@end
