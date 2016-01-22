//
//  ViewController.m
//  Eaglerise
//
//  Created by Evan on 15/11/11.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "UIViewController+Servie.h"
#import "AppDelegate.h"

@implementation UIViewController(Servie)


#pragma mark --
#pragma mark --- 获得网络控制器
-(RemoteController *)remoteController{
    return [RemoteController instance];
}




-(void)getRequest:(int)requestIndex requestDic:(NSDictionary *)requestDic characteristic:(CBCharacteristic *)characteristic  currPeripheral:(CBPeripheral *)currPeripheral  delegate:(id)delegate
{
    
    NSDictionary * temp = requestDic;
    

    switch (requestIndex) {
        case 0:
            [[self remoteController] writeValue:[self writeValue] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 1:
            [[self remoteController] writeValue:[self write2Value] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 2:
        {
            if ([[temp objectForKey:@"index"] intValue] == 1 || [[temp objectForKey:@"index"] intValue] ==2) {
                [[self remoteController] HeartwriteValue:[self writeValueList:[[temp objectForKey:@"index"] intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            }
            else            {
            [[self remoteController] writeValue:[self writeValueList:[[temp objectForKey:@"index"] intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            }
        }
            break;
        case 3:
            [[self remoteController] writeValue:[self writeValueList:[[temp objectForKey:@"index"] intValue] value:[[temp objectForKey:@"value"] intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 4:
            [[self remoteController] writeValue:[self writeValueList:[[temp objectForKey:@"index"] intValue] value1:[[temp objectForKey:@"value1"] intValue] value2:[[temp objectForKey:@"value2"] intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 5:
            [[self remoteController] writeValue:[self writeValueList2:[[temp objectForKey:@"index"] intValue] value1:[[temp objectForKey:@"value1"] intValue] value2:[[temp objectForKey:@"value2"] intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 6:
            [[self remoteController] writeValue:[self writeValueList:[[temp objectForKey:@"index"] intValue] value1:[[temp objectForKey:@"value1"] intValue] value2:[[temp objectForKey:@"value2"] intValue] value3:[[temp objectForKey:@"value3"] intValue] value4:[[temp objectForKey:@"value4"] intValue] value5:[[temp objectForKey:@"value5"] intValue] ] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 7:
            [[self remoteController] writeValue:[self writeValueList:[[temp objectForKey:@"index"] intValue] value1:[[temp objectForKey:@"value1"] intValue] value2:[[temp objectForKey:@"value2"] intValue] value3:[[temp objectForKey:@"value3"] intValue] value4:[[temp objectForKey:@"value4"] intValue] value5:[[temp objectForKey:@"value5"] intValue] value6:[[temp objectForKey:@"value6"] intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 8:
            [[self remoteController] writeValue:[self writeValueList:[[temp objectForKey:@"index"] intValue] value1:[[temp objectForKey:@"value1"] intValue] value2:[[temp objectForKey:@"value2"] intValue] value3:[[temp objectForKey:@"value3"] intValue] value4:[[temp objectForKey:@"value4"] intValue] value5:[[temp objectForKey:@"value5"] intValue] value6:[[temp objectForKey:@"value6"] intValue] value7:[[temp objectForKey:@"value7"] intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;

        case 9:
            [[self remoteController] writeValue:[self writeValueList2:[temp objectForKey:@"NameStr"]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 10:
            [[self remoteController] writeValue:[self writeValueList2:[temp objectForKey:@"NameStr"] value:[[temp objectForKey:@"value"]intValue]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 11:[[self remoteController] writeValue:[self writeValueList3:[temp objectForKey:@"NameStr"]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 12:[[self remoteController] writeValue:[self writeValueList4:[temp objectForKey:@"NameStr"]] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;
        case 13:[[self remoteController] writeValue:[self writeValueList5:nil] currPeripheral:currPeripheral characteristic:characteristic delegate:self];
            break;

            
            
        default:
            break;

    }
//
}

-(void)readRequest:(int)requestIndex requestDic:(NSDictionary *)requestDic currPeripheral:(CBPeripheral *)currPeripheral characteristicArray:(NSArray *)characteristicArray delegate:(id)delegate Baby:(BabyBluetooth *)baby callFrom:(int)callFrom
{
    NSDictionary * temp = requestDic;
    switch (requestIndex) {
  
        case 2:
     
      [[self remoteController] readValue:[self writeValueList:[[temp objectForKey:@"index"] intValue]] headRequest: [self readHead] footRequest:[self  readfoot] currPeripheral:currPeripheral characteristicArray:characteristicArray delegate:delegate Baby:baby callFrom:callFrom];
            break;
            
        case 10:
            
            [[self remoteController] readValue:[self writeValueList2:[temp objectForKey:@"NameStr"] value:[[temp objectForKey:@"value"]intValue]] headRequest: [self readHead] footRequest:[self  readfoot] currPeripheral:currPeripheral characteristicArray:characteristicArray delegate:delegate Baby:baby callFrom:callFrom];
            break;
            
        case 11:
            
            [[self remoteController] readValue:[self writeValueList4:[[temp objectForKey:@"index"] intValue] value1:[[temp objectForKey:@"value1"] intValue] value2:[[temp objectForKey:@"value2"] intValue]] headRequest: [self readHead] footRequest:[self  readfoot] currPeripheral:currPeripheral characteristicArray:characteristicArray delegate:delegate Baby:baby callFrom:callFrom];//通道类型
            break;

            
        default:
            break;
    }
}


/**11*/ //index 0 turn on 1 turn off 2 event1  3 event2
-(NSData *)writeValueList4:(int)type value1:(int)value1 value2:(int)value2
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    Byte byte[14];
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xf2;
    byte[8]=0x11;
    byte[9]=0x02;
    switch(type)
    {
        case 0:
            byte[10]=0x03;
            
            byte[11]=0x14;
            break;
        case 1:
            byte[10]=0x03;
            
            byte[11]=0x16;
            break;
        case 2:
            byte[10]=0x03;
            
            byte[11]=0x18;
            break;
        case 3:
            byte[10]=0x03;
            
            byte[11]=0x1A;
            break;
            
            
        default:
            break;
    }
    
    int offset = 0;
    byte[12] = (Byte)((value1>>offset)&0xff);
    byte[13] = (Byte)((value2>>offset)&0xff);
    //    byte[14] = (Byte)((value3>>offset)&0xff);
    //    byte[15] = (Byte)((value4>>offset)&0xff);
    //    byte[16] = (Byte)((value5>>offset)&0xff);
    //    byte[17] = (Byte)((value6>>offset)&0xff);
    
    data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
}



#pragma -- test

/**0*/
-(NSData *)writeValue{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    Byte byte[13];
    
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xd0;
    byte[8]=0x11;
    byte[9]=0x02;
    byte[10]=0x01;
    byte[11]=0x00;
    byte[12]=0x00;
    
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
    
}
/**1*/
-(NSData *)write2Value{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    Byte byte[13];
    
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xd0;
    byte[8]=0x11;
    byte[9]=0x02;
    byte[10]=0x00;
    byte[11]=0x00;
    byte[12]=0x00;
    NSData *data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
}



/**2*/
-(NSData *)writeValueList:(int)index
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    switch (index) {
        case 0:
        {
//            Byte byte[4];
//            byte[0]=0xEA;
//            byte[1]=0x01;
//            byte[2]=0x01;
            Byte byte[13];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
             byte[11]=0x01;
            byte[12]=0x00;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 1:
        {
//            Byte byte[4];
//            byte[0]=0xEA;
//            byte[1]=0x01;
//            byte[2]=0x01;
//            byte[3]=0x01;
            Byte byte[13];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
            byte[11]=0x01;
            byte[12]=0x01;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 2:
        {
            Byte byte[13];
//            byte[0]=0xEA;
//            byte[1]=0x02;
//            byte[2]=0x01;
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
            byte[11]=0x08;
            byte[12]=0x00;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 3:
        {
            Byte byte[13];
//            byte[0]=0xEA;
//            byte[1]=0x02;
//            byte[2]=0x01;
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
            byte[11]=0x08;
            byte[12]=0x01;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 4:
        {
            Byte byte[13];
//            byte[0]=0xEA;
//            byte[1]=0x02;
//            byte[2]=0x01;
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
            byte[11]=0x08;
            byte[12]=0x02;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 5:
        {
            Byte byte[13];
//            byte[0]=0xEA;
//            byte[1]=0x02;
//            byte[2]=0x01;
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
            byte[11]=0x08;
            byte[12]=0x03;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 6:
        {
            Byte byte[12];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x01;
            byte[11]=0x0B;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 7:
        {
            Byte byte[12];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x01;
            byte[11]=0x0C;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 8:
        {
            Byte byte[12];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x01;
            byte[11]=0x0D;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 9:
        {
            Byte byte[12];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x01;
            byte[11]=0x1C;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 10:
        {
            Byte byte[13];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
            byte[11]=0x1D;
            byte[12]=0x00;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 11:
        {
            Byte byte[13];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x02;
            byte[11]=0x1D;
            byte[12]=0x01;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 12:
        {
//            Byte byte[12];
//            for(int i=0;i<3;i++) {
//                int offset = (3 - 1 -i)*8;
//                byte[i] = (Byte)((delegate.number>>offset)&0xff);
//            }
//            
//            byte[3]=0x00;
//            byte[4]=0x00;
//            byte[5]=0x00;
//            byte[6]=0x00;
//            byte[7]=0xf2;
//            byte[8]=0x11;
//            byte[9]=0x02;
//            byte[10]=0x01;
//            byte[11]=0x22;
            Byte byte[3];
            byte[0]=0xF2;
            byte[1]=0x01;
            byte[2]=0x22;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 13:
        {
            Byte byte[12];
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x01;
            byte[11]=0x25;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
            
        case 14:
        {
//            Byte byte[13];
//            //            byte[0]=0xEA;
//            //            byte[1]=0x02;
//            //            byte[2]=0x01;
//            for(int i=0;i<3;i++) {
//                int offset = (3 - 1 -i)*8;
//                byte[i] = (Byte)((delegate.number>>offset)&0xff);
//            }
//            
//            byte[3]=0x00;
//            byte[4]=0x00;
//            byte[5]=0x00;
//            byte[6]=0x00;
//            byte[7]=0xf2;
//            byte[8]=0x11;
//            byte[9]=0x02;
//            byte[10]=0x02;
//            byte[11]=0x24;
//            byte[12]=0x01;
            Byte byte[4];
            byte[0]=0xF2;
            byte[1]=0x02;
            byte[2]=0x24;
            byte[3]=0x00;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 15:
        {
//            Byte byte[13];
//            //            byte[0]=0xEA;
//            //            byte[1]=0x02;
//            //            byte[2]=0x01;
//            for(int i=0;i<3;i++) {
//                int offset = (3 - 1 -i)*8;
//                byte[i] = (Byte)((delegate.number>>offset)&0xff);
//            }
//            
//            byte[3]=0x00;
//            byte[4]=0x00;
//            byte[5]=0x00;
//            byte[6]=0x00;
//            byte[7]=0xf2;
//            byte[8]=0x11;
//            byte[9]=0x02;
//             byte[10]=0x02;
//            byte[11]=0x24;
//            byte[12]=0x02;
            Byte byte[4];
            byte[0]=0xF2;
            byte[1]=0x02;
            byte[2]=0x24;
            byte[3]=0x01;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 16:
        {
//            Byte byte[13];
//            //            byte[0]=0xEA;
//            //            byte[1]=0x02;
//            //            byte[2]=0x01;
//            for(int i=0;i<3;i++) {
//                int offset = (3 - 1 -i)*8;
//                byte[i] = (Byte)((delegate.number>>offset)&0xff);
//            }
//            
//            byte[3]=0x00;
//            byte[4]=0x00;
//            byte[5]=0x00;
//            byte[6]=0x00;
//            byte[7]=0xf2;
//            byte[8]=0x11;
//            byte[9]=0x02;
//             byte[10]=0x02;
//            byte[11]=0x24;
//            byte[12]=0x03;
            Byte byte[4];
            byte[0]=0xF2;
            byte[1]=0x02;
            byte[2]=0x24;
            byte[3]=0x02;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;
        case 17:
        {
//            Byte byte[13];
//            //            byte[0]=0xEA;
//            //            byte[1]=0x02;
//            //            byte[2]=0x01;
//            for(int i=0;i<3;i++) {
//                int offset = (3 - 1 -i)*8;
//                byte[i] = (Byte)((delegate.number>>offset)&0xff);
//            }
//            
//            byte[3]=0x00;
//            byte[4]=0x00;
//            byte[5]=0x00;
//            byte[6]=0x00;
//            byte[7]=0xf2;
//            byte[8]=0x11;
//            byte[9]=0x02;
//             byte[10]=0x02;
//            byte[11]=0x24;
//            byte[12]=0x34;
            Byte byte[4];
            byte[0]=0xF2;
            byte[1]=0x02;
            byte[2]=0x24;
            byte[3]=0x03;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;

        case 18:
        {
            Byte byte[12];
            //            byte[0]=0xEA;
            //            byte[1]=0x02;
            //            byte[2]=0x01;
            for(int i=0;i<3;i++) {
                int offset = (3 - 1 -i)*8;
                byte[i] = (Byte)((delegate.number>>offset)&0xff);
            }
            
            byte[3]=0x00;
            byte[4]=0x00;
            byte[5]=0x00;
            byte[6]=0x00;
            byte[7]=0xf2;
            byte[8]=0x11;
            byte[9]=0x02;
            byte[10]=0x01;
            byte[11]=0x00;
            data = [NSData dataWithBytes:&byte length:sizeof(byte)];
        }
            break;

        default:
            break;
    }
    
    NSLog(@"%@",data);
   return data;
}
/**3*/
-(NSData *)writeValueList:(int)index value:(int)value
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    Byte byte[14];
//    byte[0]=0xEA;
//    byte[1]=0x02;
//    byte[2]=0x01;
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xf2;
    byte[8]=0x11;
    byte[9]=0x02;
    byte[10]=0x03;
    switch (index) {
        case 0:
        {

            byte[11]=0x07;
            byte[12]=0x00;
        }
            break;
        case 1:
        {

            byte[11]=0x07;
            byte[12]=0x01;
        }
            break;
        case 2:
        {

            byte[11]=0x07;
            byte[12]=0x02;
        }
            break;
        case 3:
        {

            byte[11]=0x07;
            byte[12]=0x03;
        }
            break;
        default:
            break;
    }
    int offset = 0;
    byte[13] = (Byte)((value>>offset)&0xff);
    data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSLog(@"%@",data);
    return data;
    
//    11 11 16 00 00 ff ff f2 11 02 03 07 00 00
}
/**4*/
-(NSData *)writeValueList:(int)index value1:(int)value1 value2:(int)value2
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    Byte byte[15];
//    byte[0]=0xEA;
//    byte[1]=0x03;
//    byte[2]=0x01;
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xf2;
    byte[8]=0x11;
    byte[9]=0x02;
    byte[10]=0x04;
    byte[11]=0x09;
    
    int offset = 0;
    switch (index) {
        case 0:
            
            byte[12]=0x00;
            break;
        case 1:
            byte[12]=0x01;
            break;
            
        default:
            break;
    }
    
    byte[13] = (Byte)((value1>>offset)&0xff);
    byte[14] = (Byte)((value2>>offset)&0xff);
    data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
}
/**5*/
-(NSData *)writeValueList2:(int)index value1:(int)value1 value2:(int)value2
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    Byte byte[14];
    //    byte[0]=0xEA;
    //    byte[1]=0x03;
    //    byte[2]=0x01;
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xf2;
    byte[8]=0x11;
    byte[9]=0x02;
    byte[10]=0x03;
    switch (index) {
        case 0:
            byte[11]=0x09;
            break;
        case 1:
            byte[11]=0x0A;
            break;
        case 2:
            byte[11]=0x011;
            break;
            
        default:
            break;
    }

    
    int offset = 0;
    byte[12] = (Byte)((value1>>offset)&0xff);
    byte[13] = (Byte)((value2>>offset)&0xff);
    data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
}
/**6*/
-(NSData *)writeValueList:(int)type value1:(int)value1 value2:(int)value2 value3:(int)value3 value4:(int)value4 value5:(int)value5
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    Byte byte[17];
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xf2;
    byte[8]=0x11;
    byte[9]=0x02;
    byte[10]=0x06;
    switch(type)
    {
        case 0:
            byte[11]=0x15;
            break;
        
        default:
            break;
    }

    int offset = 0;
    byte[12] = (Byte)((value1>>offset)&0xff);
    byte[13] = (Byte)((value2>>offset)&0xff);
    byte[14] = (Byte)((value3>>offset)&0xff);
    byte[15] = (Byte)((value4>>offset)&0xff);
    byte[16] = (Byte)((value5>>offset)&0xff);

    
    data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
}

/**7*/
-(NSData *)writeValueList:(int)type value1:(int)value1 value2:(int)value2 value3:(int)value3 value4:(int)value4 value5:(int)value5 value6:(int)value6
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    Byte byte[18];
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xf2;
    byte[8]=0x11;
    byte[9]=0x02;
     byte[10]=0x07;
    switch(type)
    {
        case 0:
            byte[11]=0x13;
            break;
        case 1:
            byte[11]=0x17;
            break;
        case 2:
            byte[11]=0x19;
            break;
        default:
            break;
    }
    
    int offset = 0;
    byte[12] = (Byte)((value1>>offset)&0xff);
    byte[13] = (Byte)((value2>>offset)&0xff);
    byte[14] = (Byte)((value3>>offset)&0xff);
    byte[15] = (Byte)((value4>>offset)&0xff);
    byte[16] = (Byte)((value5>>offset)&0xff);
    byte[17] = (Byte)((value6>>offset)&0xff);

    data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
}

/**8*/
-(NSData *)writeValueList:(int)type value1:(int)value1 value2:(int)value2 value3:(int)value3 value4:(int)value4 value5:(int)value5 value6:(int)value6 value7:(int)value7
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    Byte byte[19];
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    }
    
    byte[3]=0x00;
    byte[4]=0x00;
    byte[5]=0x00;
    byte[6]=0x00;
    byte[7]=0xf2;
    byte[8]=0x11;
    byte[9]=0x02;
    byte[10]=0x08;
    switch(type)
    {
        case 0:
            byte[11]=0x1B;
            break;
        case 1:
            byte[11]=0x17;
            break;
        default:
            break;
    }
    
    int offset = 0;
    byte[12] = (Byte)((value1>>offset)&0xff);
    byte[13] = (Byte)((value2>>offset)&0xff);
    byte[14] = (Byte)((value3>>offset)&0xff);
    byte[15] = (Byte)((value4>>offset)&0xff);
    byte[16] = (Byte)((value5>>offset)&0xff);
    byte[17] = (Byte)((value6>>offset)&0xff);
    byte[18] = (Byte)((value7>>offset)&0xff);
    data = [NSData dataWithBytes:&byte length:sizeof(byte)];
    return data;
}

/**9*/
-(NSData *)writeValueList2:(NSString *)NameStr
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    
    const char *swtr = [NameStr UTF8String];
    int jsonlenght = (int)strlen(swtr);
//    int csum = jsonlenght + 11;
    Byte byte[3];
//    for(int i=0;i<3;i++) {
//        int offset = (3 - 1 -i)*8;
//        byte[i] = (Byte)((delegate.number>>offset)&0xff);
//    }
    
//    byte[3]=0x00;
//    byte[4]=0x00;
//    byte[5]=0x00;
//    byte[6]=0x00;
//    byte[7]=0xf2;
//    byte[8]=0x11;
//    byte[9]=0x02;
//    byte[10]=0x02;
    byte[0]=0XF2;
    byte[1]=(Byte)(((jsonlenght+1)>>0)&0xff);
    byte[2]=0x21;
    NSMutableData *tempData = [NSMutableData data];
     NSData *  postbody = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSData * postbody2=[NameStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [tempData setData:postbody];
    //        NSLog(@"-1-%@\n\n",TT);
    //        NSLog(@"-2-%@\n\n",TT3);
    [tempData appendData:postbody2];
    data = tempData;
    return data;
}
/**10*/
-(NSData *)writeValueList2:(NSString *)NameStr value:(int)value
{
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    
    const char *swtr = [NameStr UTF8String];
    int jsonlenght = (int)strlen(swtr);
//    int csum = jsonlenght + 2;
    Byte byte[4];
//    for(int i=0;i<3;i++) {
//        int offset = (3 - 1 -i)*8;
//        byte[i] = (Byte)((delegate.number>>offset)&0xff);
//    }
    
//    byte[3]=0x00;
//    byte[4]=0x00;
//    byte[5]=0x00;
//    byte[6]=0x00;
//    byte[7]=0xf2;
//    byte[8]=0x11;
//    byte[9]=0x02;
//    byte[10]=0x03;
    byte[0]=0xF2;
     byte[1]=(Byte)(((jsonlenght+2)>>0)&0xff);
    byte[2]=0x23;
    int offset = 0;
    byte[3] = (Byte)((value>>offset)&0xff);
    NSMutableData *tempData = [NSMutableData data];
    NSData *  postbody = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSData * postbody2=[NameStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [tempData setData:postbody];
    //        NSLog(@"-1-%@\n\n",TT);
    //        NSLog(@"-2-%@\n\n",TT3);
    [tempData appendData:postbody2];
    data = tempData;
    return data;
}

-(NSData *)writeValueList3:(NSString *)NameStr
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    
    const char *swtr = [NameStr UTF8String];
    int jsonlenght = (int)strlen(swtr);
    //    int csum = jsonlenght + 11;
    Byte byte[1];
    //    for(int i=0;i<3;i++) {
    //        int offset = (3 - 1 -i)*8;
    //        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    //    }
    
    //    byte[3]=0x00;
    //    byte[4]=0x00;
    //    byte[5]=0x00;
    //    byte[6]=0x00;
    //    byte[7]=0xf2;
    //    byte[8]=0x11;
    //    byte[9]=0x02;
    //    byte[10]=0x02;
    byte[0]=0X04;
//    byte[1]=(Byte)(((jsonlenght+1)>>0)&0xff);
//    byte[2]=0x21;
    NSMutableData *tempData = [NSMutableData data];
    NSData *  postbody = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSData * postbody2=[NameStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [tempData setData:postbody];
    //        NSLog(@"-1-%@\n\n",TT);
    //        NSLog(@"-2-%@\n\n",TT3);
    [tempData appendData:postbody2];
    data = [self addZeroWithData:tempData];
//    NSLog(@"%@",data);
    return data;
}


- (NSData *)addZeroWithData:(NSData *)data{

    NSInteger length0 = data.length;

    Byte bt[1];
    bt[0] = 0x00;
    NSData * adddata = [NSData dataWithBytes:&bt length:sizeof(bt)];
    NSMutableData * returnData = [NSMutableData dataWithData:data];
    
    for (NSInteger i = length0; i < 17 ; i ++) {
        [returnData appendData:adddata];
        
    }
    
    
    return returnData;
}

-(NSData *)writeValueList4:(NSString *)NameStr
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    
    const char *swtr = [NameStr UTF8String];
    int jsonlenght = (int)strlen(swtr);
    //    int csum = jsonlenght + 11;
    Byte byte[1];
    //    for(int i=0;i<3;i++) {
    //        int offset = (3 - 1 -i)*8;
    //        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    //    }
    
    //    byte[3]=0x00;
    //    byte[4]=0x00;
    //    byte[5]=0x00;
    //    byte[6]=0x00;
    //    byte[7]=0xf2;
    //    byte[8]=0x11;
    //    byte[9]=0x02;
    //    byte[10]=0x02;
    byte[0]=0X05;
    //    byte[1]=(Byte)(((jsonlenght+1)>>0)&0xff);
    //    byte[2]=0x21;
    NSMutableData *tempData = [NSMutableData data];
    NSData *  postbody = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSData * postbody2=[NameStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [tempData setData:postbody];
    //        NSLog(@"-1-%@\n\n",TT);
    //        NSLog(@"-2-%@\n\n",TT3);
    [tempData appendData:postbody2];
    data = [self addZeroWithData:tempData];
//    NSLog(@"%@",data);
    return data;
}


-(NSData *)writeValueList5:(NSString *)NameStr
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    
//    const char *swtr = [NameStr UTF8String];
//    int jsonlenght = (int)strlen(swtr);
    //    int csum = jsonlenght + 11;
    Byte byte[17];
    //    for(int i=0;i<3;i++) {
    //        int offset = (3 - 1 -i)*8;
    //        byte[i] = (Byte)((delegate.number>>offset)&0xff);
    //    }
    
    byte[0]= 0X06;
    byte[1]= 0xc0;
    byte[2]=0xc1;
    byte[3]=0xc2;
    byte[4]=0xc3;
    byte[5]=0xc4;
    byte[6]=0xc5;
    byte[7]=0xc6;
    byte[8]=0xc7;
    byte[9]=0xd8;
    byte[10]=0xd9;
    byte[11] = 0xda;
    byte[12] = 0xdb;
    byte[13] = 0xdc;
    byte[14] = 0xdd;
    byte[15] = 0xde;
    byte[16] = 0xdf;

    NSMutableData *tempData = [NSMutableData data];
    NSData *  postbody = [NSData dataWithBytes:&byte length:sizeof(byte)];
    NSData * postbody2=[NameStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [tempData setData:postbody];
    //        NSLog(@"-1-%@\n\n",TT);
    //        NSLog(@"-2-%@\n\n",TT3);
    [tempData appendData:postbody2];
    data = tempData;
//    NSLog(@"%@",data);
    return data;
}



-(NSData *)readHead
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    

    Byte byteSent[16];
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byteSent[i] = (Byte)((delegate.number2>>offset)&0xff);
    }
    
    byteSent[3] = 0x00;
    byteSent[4] = 0x00;
    byteSent[5] = 0x00;
    byteSent[6] = 0x00;
    byteSent[7] = 0xf2;
    byteSent[8] = 0x11;
    byteSent[9] = 0x02;
    byteSent[10] =  0x05;
    byteSent[11] =  0x30;
    byteSent[12] = 0x31;
    byteSent[13] = 0x32;
    byteSent[14] = 0x33;
    byteSent[15] = 0x34;

    data = [NSData dataWithBytes:&byteSent length:sizeof(byteSent)];
 
    return data;
}


-(NSData *)readfoot
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSData *data;
    
    
    Byte byteSent[11];
    for(int i=0;i<3;i++) {
        int offset = (3 - 1 -i)*8;
        byteSent[i] = (Byte)((delegate.number2>>offset)&0xff);
    }
    
    byteSent[3] = 0x00;
    byteSent[4] = 0x00;
    byteSent[5] = 0x00;
    byteSent[6] = 0x00;
    byteSent[7] = 0xEA;
    byteSent[8] = 0x11;
    byteSent[9] = 0x02;
    byteSent[10] =  0x10;

    
    data = [NSData dataWithBytes:&byteSent length:sizeof(byteSent)];
    
    return data;
}
@end
