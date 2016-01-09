//
//  TwoiewController.h
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

@interface ControlViewController : FViewController
{
@public
    BabyBluetooth *baby;
}
@property (strong,nonatomic) NSMutableArray *services;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (strong,nonatomic) NSArray *characteristicArray;
@end
