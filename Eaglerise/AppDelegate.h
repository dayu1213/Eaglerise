//
//  AppDelegate.h
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabyBluetooth.h"
#import "PeripheralInfo.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**控制指令累加值*/
@property int number;
/**读取指令累加值*/
@property int number2;
@property BabyBluetooth *baby;
@property(strong,nonatomic)CBPeripheral *currPeripheral;
@property (nonatomic,strong) NSMutableArray *characteristics;

@property (nonatomic,strong) PeripheralInfo * specialPeripheralInfo;

@property  int channelNum;
@end

