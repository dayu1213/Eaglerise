//
//  RemoteController.m
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "RemoteController.h"
#import "SVProgressHUD.h"

#import "PeripheralInfo.h"
#import "FViewController.h"
#import "SocketDelegate.h"
//#import "MessageParse.h"

#import "AppDelegate.h"
//#import "Public.h"
#import "zlib.h"


@interface RemoteController ()//<GCDAsyncSocketDelegate>
{
    AppDelegate * mydelegate;
    NSMutableArray *peripheralsAD;
}

//@property(nonatomic, retain) AsyncSocket *socket;
//@property(strong)  GCDAsyncSocket *socket;

@property(nonatomic, retain) NSMutableDictionary *clientDelegates;

@property FViewController *progress;
/**旧的请求Tag*/
@property long OldTag;
/**请求服务器超时*/
@property (strong,nonatomic) NSTimer * CallServerTimeOver;
/**正在请求的窗体名称*/
@property (nonatomic,strong) NSString *requestViewName;


/**正在请求的数量*/
@property (nonatomic) NSInteger  requestNum;


@property (nonatomic) NSInteger  length;



@property (nonatomic,strong)CBCharacteristic *characteristic;
@end



@implementation RemoteController
//@synthesize peripherals;
static RemoteController *instance;

@synthesize  clientDelegates;//socket,




- (id)init
{

    self = [super init];
    if (self)
    {
//        _isRunning = NO;
//        ResponseMessage = [[NSMutableDictionary alloc] init];
        mydelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    }
    return self;
}



#pragma mark ---
#pragma mark ---单例实现
+(RemoteController *)instance{

    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        if(instance==nil){
            instance = [[self alloc] init];
        }
        
    });
    return instance;
}




#pragma mark ---
#pragma mark --- 处理业务逻辑委托
-(NSMutableDictionary *)clientDelegates{
//    NSLog(@"--------------3------------------");
    if(clientDelegates==nil){
        clientDelegates = [[NSMutableDictionary alloc] init];
    }
    
    return clientDelegates;
}





#pragma mark ---
#pragma mark --- 向硬件端发送数据

-(void)writeValue:(NSData *)messageRequest currPeripheral:(CBPeripheral *)currPeripheral characteristic:(CBCharacteristic *)characteristic delegate:(id)delegate{
    
    [[self clientDelegates] setValue:delegate forKey:@"0"];
//    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSLog(@"向硬件端发送数据:%@，服务为：%lu",messageRequest,(unsigned long)characteristic.properties);
   
         if(characteristic.properties & CBCharacteristicPropertyWrite){
              if ([[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"f20224"].location !=NSNotFound&&[[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"f20122"].location !=NSNotFound&&[[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"23"].location !=NSNotFound&&[[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"21"].location !=NSNotFound) {
             [currPeripheral writeValue:messageRequest forCharacteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0] type:CBCharacteristicWriteWithResponse];
//        characteristic.properties = @"19210D0C0B0A09080706050403020100";
        }
    else
    {
   
        [currPeripheral writeValue:messageRequest forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        
//        NSLog(@"%@",characteristic.UUID);
//        NSLog(@"------------1--------------");
        
            mydelegate.number++;
        }
        
    }else{
        NSLog(@"该字段不可写！");
    }

}



-(void)HeartwriteValue:(NSData *)messageRequest currPeripheral:(CBPeripheral *)currPeripheral characteristic:(CBCharacteristic *)characteristic delegate:(id)delegate{
    
    [[self clientDelegates] setValue:delegate forKey:@"1"];
    //    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
//    NSLog(@"向硬件端发送数据:%@",messageRequest);
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        [currPeripheral writeValue:messageRequest forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        //        NSLog(@"------------1--------------");
        mydelegate.number++;
    }else{
        NSLog(@"该字段不可写！");
    }
    
}



#pragma mark -读取蓝色设备信息

-(void)readValue:(NSData *)messageRequest headRequest:(NSData *)headRequest footRequest:(NSData *)footRequest currPeripheral:(CBPeripheral *)currPeripheral characteristicArray:(NSArray *)characteristicArray delegate:(id)delegate Baby:(BabyBluetooth *)baby callFrom:(int)callFrom
{
     NSLog(@"向硬件端发送读取数据:%@",messageRequest);
    [self head:headRequest currPeripheral:currPeripheral characteristic:[characteristicArray objectAtIndex:0] delegate:delegate Baby:baby callFrom:callFrom];
//    if ([[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"f20224"].location ==NSNotFound&&[[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"f20122"].location ==NSNotFound&&[[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"23"].location ==NSNotFound&&[[NSString stringWithFormat:@"%@",messageRequest] rangeOfString:@"21"].location ==NSNotFound) {
    if (callFrom != DeviceNameRead && callFrom != CannelNameRead) {
        [self writeValue:messageRequest currPeripheral:currPeripheral characteristic:[characteristicArray objectAtIndex:1] delegate:delegate];
    }
    else
    {
//    [self writeValue:messageRequest currPeripheral:currPeripheral characteristic:[characteristicArray objectAtIndex:1] delegate:delegate];
        [currPeripheral writeValue:messageRequest forCharacteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0] type:CBCharacteristicWriteWithResponse];
    }
//    sleep(1);
//    [self foot:footRequest currPeripheral:currPeripheral characteristic:[characteristicArray objectAtIndex:1] Baby:baby];
}
-(void)head:(NSData *)messageRequest currPeripheral:(CBPeripheral *)currPeripheral characteristic:(CBCharacteristic *)characteristic delegate:(id)delegate  Baby:(BabyBluetooth *)baby callFrom:(int)callFrom
{

    if(currPeripheral.state != CBPeripheralStateConnected){
        [SVProgressHUD showErrorWithStatus:@"peripheral已经断开连接，请重新连接"];
        return;
    }
    if (characteristic.properties & CBCharacteristicPropertyNotify ||  characteristic.properties & CBCharacteristicPropertyIndicate){
        
        if(characteristic.isNotifying){
            [baby cancelNotify:currPeripheral characteristic:characteristic];
//            [btn setTitle:@"通知" forState:UIControlStateNormal];
        }else{
            [currPeripheral setNotifyValue:YES forCharacteristic:characteristic];
//            [btn setTitle:@"取消通知" forState:UIControlStateNormal];
            [baby notify:currPeripheral
          characteristic:characteristic
                   block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                       NSLog(@"notify block 为%@",characteristics.value);
                       //哥们，在这里characteristics.value就是你这边需要的数据；
                     

                       self.progress = delegate;
                       
                       Byte *bytes = (Byte *)[characteristics.value bytes];
                       //遍历内容长度
                       
                       NSString * lengthStr = nil;
                       // 将值转成16进制
                       NSString * newStr;
                       if(callFrom == DeviceNameRead ||callFrom == CannelNameRead )
                       {
//                             [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到设备名称信息，数据为%@",characteristics.value]];
                           newStr = [NSString stringWithFormat:@"%x",bytes[1]&0xff];///16进制数
                           if([newStr length]==1)
                           {
                               lengthStr = [NSString stringWithFormat:@"0%@",newStr];
                           }
                           else
                           {
                               lengthStr = [NSString stringWithFormat:@"%@",newStr];
                           }

                           if ([lengthStr isEqualToString:@"22"])
                           {
                               [self.progress resultStr:characteristics index:DeviceNameRead];
                           }
                           else if ([lengthStr isEqualToString:@"24"])
                           {
                               [self.progress resultStr:characteristics index:CannelNameRead];
                           }

                       }
                       else
                       {
                           newStr = [NSString stringWithFormat:@"%x",bytes[11]&0xff];///16进制数
                           if([newStr length]==1)
                           {
                               lengthStr = [NSString stringWithFormat:@"0%@",newStr];
                           }
                           else
                           {
                               lengthStr = [NSString stringWithFormat:@"%@",newStr];
                           }

                       if([lengthStr isEqualToString:@"0d"])
                       {
                           [self.progress resultStr:characteristics index:DeviceRead];
                       }
                       else if ([lengthStr isEqualToString:@"08"])
                       {
                           [self.progress resultStr:characteristics index:OutPutRead];
                       }
                       else if ([lengthStr isEqualToString:@"0b"])
                       {
                           [self.progress resultStr:characteristics index:PreviewRead];
                       }
                       else if ([lengthStr isEqualToString:@"1c"])
                       {
                           [self.progress resultStr:characteristics index:TimeRead];
                       }
                        else if ([lengthStr isEqualToString:@"25"])
                       {
                           [self.progress resultStr:characteristics index:VersionRead];
                       }
                       else if ([lengthStr isEqualToString:@"00"])
                       {
                           [self.progress resultStr:characteristics index:DeviceTypeRead];
                       }
                       }
//                       switch (callFrom) {
//                           case DeviceRead:
//                               [self.progress resultStr:characteristics index:DeviceRead];
//                               break;
//                           case OutPutRead:
//                               [self.progress resultStr:characteristics index:OutPutRead];
//                               break;
//                           case PreviewRead:
//                               [self.progress resultStr:characteristics index:PreviewRead];
//                               break;
//                           case TimeRead:
//                               [self.progress resultStr:characteristics index:TimeRead];
//                               break;
//                           case DeviceNameRead:
//                               [self.progress resultStr:characteristics index:DeviceNameRead];
//                               break;
//                           case CannelNameRead:
//                               [self.progress resultStr:characteristics index:CannelNameRead];
//                               break;
//                           case VersionRead:
//                               [self.progress resultStr:characteristics index:VersionRead];
//                               break;
//                           case DeviceTypeRead:
//                               [self.progress resultStr:characteristics index:DeviceTypeRead];
//                               break;
//                           default:
//                               break;
//                       }
                       
                       
//                       NSString *valueStr = [NSString alloc]
//                       [SVProgressHUD showInfoWithStatus:@"notify block 为"];
                       //                NSLog(@"new value %@",characteristics.value);
//                       [self insertReadValues:characteristics];
//                       [self writeValue:messageRequest currPeripheral:currPeripheral characteristic:characteristic delegate:delegate];
                   }];
        }
    }
    else{
         if(callFrom == DeviceNameRead)
         {
        [SVProgressHUD showErrorWithStatus:@"这个characteristic没有nofity的权限,设备名称获取失败"];
         }
        return;
    }

    
//    [baby cancelNotify:currPeripheral characteristic:characteristic];
//    [currPeripheral writeValue:messageRequest forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    mydelegate.number2++;
}


-(void)foot:(NSData *)messageRequest currPeripheral:(CBPeripheral *)currPeripheral characteristic:(CBCharacteristic *)characteristic Baby:(BabyBluetooth *)baby
{
    

    [currPeripheral writeValue:messageRequest forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    mydelegate.number2++;
}






@end
