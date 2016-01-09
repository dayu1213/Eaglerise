//
//  ViewController.m
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "PeripheralInfo.h"

@implementation PeripheralInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        self.characteristics = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
