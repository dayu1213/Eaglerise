//
//  ViewController.m
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FViewController.h"

@interface UIViewController(Servie)
/**
 *打包控制指令
 */
-(void)getRequest:(int)requestIndex requestDic:(NSDictionary *)requestDic characteristic:(CBCharacteristic *)characteristic  currPeripheral:(CBPeripheral *)currPeripheral  delegate:(id)delegate;

/**
 *打包控制指令
 */
-(void)readRequest:(int)requestIndex requestDic:(NSDictionary *)requestDic currPeripheral:(CBPeripheral *)currPeripheral characteristicArray:(NSArray *)characteristicArray delegate:(id)delegate Baby:(BabyBluetooth *)baby callFrom:(int)callFrom;
//-(void)postRequest:(NSString *)requestStr RequestDictionary:(NSDictionary *)requestDictionary delegate:(id)delegate;

@end
