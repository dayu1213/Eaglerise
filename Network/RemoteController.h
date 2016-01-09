//
//  RemoteController.h
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MessageRequest.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface RemoteController : NSObject
{

}

+(RemoteController *)instance;

-(void)writeValue:(NSData *)messageRequest currPeripheral:(CBPeripheral *)currPeripheral characteristic:(CBCharacteristic *)characteristic delegate:(id)delegate;
-(void)HeartwriteValue:(NSData *)messageRequest currPeripheral:(CBPeripheral *)currPeripheral characteristic:(CBCharacteristic *)characteristic delegate:(id)delegate;
-(void)readValue:(NSData *)messageRequest headRequest:(NSData *)headRequest footRequest:(NSData *)footRequest currPeripheral:(CBPeripheral *)currPeripheral characteristicArray:(NSArray *)characteristicArray delegate:(id)delegate Baby:(BabyBluetooth *)baby callFrom:(int)callFrom;

@property __block NSMutableArray *services;

@end
