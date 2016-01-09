//
//  SocketDelegate.h
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MessageResponse.h"

@protocol SocketDelegate <NSObject>

-(void)resultStr:(CBCharacteristic *)characteristics index:(int)index;

//-(void)onReciveData:(NSMutableArray *) messageResponse with:(long)tag;
-(void)onError:(NSError *)error with:(long)tag;
//-(void)startRequest;
//-(void)endResponse;
//-(void)endResponse:(BOOL)resultStatus;
//-(void)startRequest:(NSString *)ViewControllerName;
//-(void)setMyView:(NSString *)ViewControllerName;

@end


