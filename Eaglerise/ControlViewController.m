//
//  TwoiewController.m
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "ControlViewController.h"
#import "AppDelegate.h"
#define channelOnPeropheralView @"ControlView"
@interface ControlViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,CBPeripheralManagerDelegate>
{
//    UISlider *slider;
//    UISlider *slider2;
//    UISlider *slider3;
//    
//    
    UISwitch *switchView1;
    UISwitch *switchView2;
//    UISwitch *switchView3;
//    UISwitch *switchView4;
//    UISwitch *switchView5;
    NSUserDefaults *userdefaults;
    
    UIPickerView *PickerView;
    
    NSArray *pickerArray;
    bool show;
    int number;
    //请求类型
    int calltype;
    NSTimer * Hearttimer;
    NSTimer * allTimer;
    UIActionSheet *actionSheet;
    AppDelegate * mydelegate;
    
    BOOL isRead;
    int ChannelNum;
    int timerNum;
    BOOL HeartSave;
    bool isUPdate;
    BOOL heartStart;
    
}

@property (nonatomic,strong) UITableView * sliderTView;
@property (nonatomic,strong) UILabel * DateLbl;
@property (nonatomic,strong) UILabel * DeviceLbl;
@property (nonatomic,strong) NSMutableArray * sliderArray;
@property (nonatomic,strong) NSMutableArray * selArray;

//@property (nonatomic,strong) UIView * PopView;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@end

@implementation ControlViewController
@synthesize sliderTView;
//@synthesize PopView;
@synthesize DateLbl,DeviceLbl;
-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAction:) name:@"ld" object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeartStart) name:@"heartBegan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeartStop) name:@"heartstop" object:nil];
        mydelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTable) name:@"loadControlTable" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceName) name:@"updateDeviceName" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Disconnect) name:@"DisconnectBtnClick" object:nil];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    [self iv];
    [self lc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
//    [self startTimer];
}

#pragma mark --
#pragma mark - 初始化页面元素
/**
 *初始化参数
 */
-(void)iv
{
    //初始化
    self.services = [[NSMutableArray alloc]init];
    HeartSave = NO;
    heartStart = YES;
    show = NO;
//    修改
    ChannelNum = 2;
    timerNum = 20;
//    [SVProgressHUD showInfoWithStatus:@"准备连接设备"];
    self.sliderArray  = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"3", nil];
    self.selArray = [NSMutableArray arrayWithObjects:@"on",@"on",@"on", nil];
//    self.selArray = [[NSMutableArray alloc]init];

    userdefaults = [NSUserDefaults standardUserDefaults];
    
    pickerArray = [[NSArray alloc]initWithObjects:@"30 Minute",@"1 Hour",@"2 Hour",@"4 Hour",@"6 Hour",@"next event", nil];
    number = 1;
    if ([userdefaults objectForKey:@"channel1"]==nil) {
        [userdefaults setObject:@"channel 1" forKey:@"channel1"];
    }
    if ([userdefaults objectForKey:@"channel2"]==nil) {
        [userdefaults setObject:@"channel 2" forKey:@"channel2"];
    }
    if ([userdefaults objectForKey:@"channel3"]==nil) {
        [userdefaults setObject:@"channel 3" forKey:@"channel3"];
    }
    if ([userdefaults objectForKey:@"channel4"]==nil) {
        [userdefaults setObject:@"channel 4" forKey:@"channel4"];
    }

    if ([userdefaults objectForKey:@"slider1"]==nil) {
        [userdefaults setFloat:100 forKey:@"slider1"];
    }
    if ([userdefaults objectForKey:@"slider2"]==nil) {
        [userdefaults setFloat:100 forKey:@"slider2"];
    }
    if ([userdefaults objectForKey:@"slider3"]==nil) {
        [userdefaults setFloat:100 forKey:@"slider3"];
    }
    if ([userdefaults objectForKey:@"slider4"]==nil) {
        [userdefaults setFloat:100 forKey:@"slider4"];
    }


    
}

/**
 *加载控件
 */
-(void)lc
{
    DeviceLbl = [[UILabel alloc]initWithFrame:CGRectMake(40, 30, 100, 30)];
    DeviceLbl.text = @"light 1";
    DeviceLbl.backgroundColor = [UIColor clearColor];
    [DeviceLbl setTextAlignment:NSTextAlignmentLeft];
    [DeviceLbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [DeviceLbl setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:DeviceLbl];
    
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-150, 30, 40, 30)];
    Lbl.text = @"OFF";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:Lbl];

    switchView1 = [[UISwitch alloc] initWithFrame:CGRectMake(Device_Wdith-115, 30, 80.0f, 28.0f)];
    

    switchView1.on = YES;//设置初始为ON的一边
    switchView1.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [switchView1 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView1];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, 30, 30, 30)];
    Lbl.text = @"ON";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:Lbl];

    
    sliderTView =[[UITableView alloc] init];
    sliderTView.backgroundColor = [UIColor clearColor];
    sliderTView.frame=CGRectMake(0, 90, Device_Wdith, Device_Height/2);
    sliderTView.dataSource = self;
    sliderTView.delegate = self;
    //设置table是否可以滑动
    sliderTView.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    sliderTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:sliderTView];


    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetHeight(sliderTView.frame)+sliderTView.frame.origin.y, Device_Wdith-80, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [self.view addSubview:Lbl];
    float y = CGRectGetHeight(Lbl.frame)+Lbl.frame.origin.y;
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(40, y, 130, 50)];
    Lbl.text = @"Brightness Lock";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:Lbl];

    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-150, y+10, 40, 30)];
    Lbl.text = @"OFF";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:Lbl];
    
    switchView2 = [[UISwitch alloc] initWithFrame:CGRectMake(Device_Wdith-115, y+11, 80.0f, 28.0f)];
    
    
    switchView2.on = NO;
    switchView2.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [switchView2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchView2];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, y+10, 30, 30)];
    Lbl.text = @"ON";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:Lbl];
    
    float y2 = CGRectGetHeight(Lbl.frame)+Lbl.frame.origin.y;
    DateLbl = [[UILabel alloc]initWithFrame:CGRectMake(30, y2+10, Device_Wdith-60, 30)];
    DateLbl.text = @"";
    DateLbl.backgroundColor = [UIColor clearColor];
    [DateLbl setTextAlignment:NSTextAlignmentLeft];
    [DateLbl setTextColor:[UIColor blackColor]];
    [DateLbl setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:DateLbl];
    
    
    
//    PopView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-330, Device_Wdith, 300)];
//    [PopView setBackgroundColor:[UIColor clearColor]];
//    //    [PopView setAlpha:0.2];
//    [self.view addSubview:PopView];
//    
//    //添加点击触摸手势
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    tapGr.cancelsTouchesInView = NO;
//    [PopView addGestureRecognizer:tapGr];
//    
//    PopView.hidden = YES;
//    
//    
//    PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, Device_Wdith, 150)];
//    //    指定Delegate
//    PickerView.delegate=self;
//    //    显示选中框
//    PickerView.showsSelectionIndicator=YES;
//    [PopView addSubview:PickerView];
//    
//    UIButton * okBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith/4, 150, Device_Wdith/2, 35)];
//
//    [okBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
//    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
//    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
//    [okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
//
//    [okBtn.layer setMasksToBounds:YES];
//
//    [okBtn.layer setCornerRadius:4.0];
//
//    [PopView addSubview:okBtn];

}
//-(void)viewTapped:(UITapGestureRecognizer*)tapGr
//{
//    
//    PopView.hidden = YES;
//    
//}

//退出时断开连接
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}


//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
//    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开连接",peripheral.name]];
//    }];
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        
        
//        NSLog(@"%d",peripheral.services.count);
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        if (isRead != YES) {
//            NSLog(@"===service :%@====",service);
            [weakSelf insertRowToTableView:service];
        }
        
        else
        {
//            if([[NSString stringWithFormat:@"%@",service] isEqualToString:@"<EA000201>"])
//            {
//                HeartSave = YES;
//            }
            
//            else
            
//             NSLog(@"===service :%@====",service);
        }
        
//        if([service.UUID isEqual:@"1912"])
//           {
//         NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",8],@"index",weakSelf.characteristic,@"characteristic",weakSelf.currPeripheral,@"currPeripheral",nil];
//         [weakSelf getRequest:2 requestDic:temp delegate:weakSelf];
//           }
        
    }];
    //设置读取characteristics的委托
//    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
//        //硬件返回值
////        NSLog(@"--1--characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
//        
////        Byte * bytes = (Byte *)[characteristics.value bytes];
////        
////        NSString *newStr = [NSString stringWithFormat:@"%x",bytes[3]&0xff];///16进制数
////        NSString        *snStr=@"";//识别码
////        if([newStr length]==1)
////            snStr = [NSString stringWithFormat:@"%@0%@",snStr,newStr];
////        else
////            snStr = [NSString stringWithFormat:@"%@%@",snStr,newStr];
////        
////        if ([snStr isEqualToString:@"08"] ) {
////            
////            // 将值转成16进制
////            NSString *newStr = [NSString stringWithFormat:@"%x",bytes[4]&0xff];///16进制数
////            NSString * lengthStr = @"";
////            if([newStr length]==1)
////                lengthStr = [NSString stringWithFormat:@"0%@",newStr];
////            else
////                lengthStr = [NSString stringWithFormat:@"%@",newStr];
////            
////            
////            //转换类型
////            const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
////            int  nResult=(int)strtol(swtr,NULL,16);
////            
////            newStr = [NSString stringWithFormat:@"%x",bytes[5]&0xff];///16进制数
////            lengthStr = @"";
////            if([newStr length]==1)
////                lengthStr = [NSString stringWithFormat:@"0%@",newStr];
////            else
////                lengthStr = [NSString stringWithFormat:@"%@",newStr];
////            
////            
////            //转换类型
////            const char *swtr2 = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
////            int  nResult2=(int)strtol(swtr2,NULL,16);
////            NSIndexPath *indexPath = [weakSelf.sliderTView indexPathForSelectedRow];
////            UITableViewCell *cell = [weakSelf.sliderTView cellForRowAtIndexPath:indexPath];
////            UISlider * slider = (UISlider *)[cell viewWithTag:(100+nResult)];
////            slider.value = nResult2;
////        }
////        
////         if ([snStr isEqualToString:@"0D"] ) {
////             // 将值转成16进制
////             NSString *newStr = [NSString stringWithFormat:@"%x",bytes[5]&0xff];///16进制数
////             NSString * lengthStr = @"";
////             if([newStr length]==1)
////                 lengthStr = [NSString stringWithFormat:@"0%@",newStr];
////             else
////                 lengthStr = [NSString stringWithFormat:@"%@",newStr];
////             
////             
////             //转换类型
////             const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
////             int  nResult=(int)strtol(swtr,NULL,16);
////         }
//
//    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}
-(void)loadData{
    isUPdate = NO;
//    [SVProgressHUD showInfoWithStatus:@"开始连接设备"];
    baby.having(self.currPeripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    //    baby.connectToPeripheral(self.currPeripheral).begin();
}



#pragma mark -
#pragma mark Picker Date Source Methods

//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerArray count];
}

#pragma mark Picker Delegate Methods

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerArray objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [pickerLabel setTextColor:[UIColor blackColor]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel* pickerLabel = (UILabel *)[PickerView viewForRow:row forComponent:component];
    [pickerLabel setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
}

#pragma mark -插入table数据
-(void)insertSectionToTableView:(CBService *)service{
//    NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    NSLog(@"Test service.UUID is:%@",service.UUID);

    [info setServiceUUID:service.UUID];
    if( ![[NSString stringWithFormat:@"%@",service.UUID] isEqualToString:@"Device Information"])
    {
        [self.services addObject:info];
    }
//    [self.services addObject:info];
    
//    mydelegate.specialPeripheralInfo = [[PeripheralInfo alloc]init];
//    [mydelegate.specialPeripheralInfo setServiceUUID:(CBUUID *)@"19210D0C0B0A09080706050403020100"];

//    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.services.count-1];
//    [sliderTView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)insertRowToTableView:(CBService *)service{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    int sect = -1;
    for (int i=0;i<self.services.count;i++) {
        PeripheralInfo *info = [self.services objectAtIndex:i];
         NSLog(@"info.serviceUUID is:%@,service.UUID:%@",info.serviceUUID,service.UUID);
        if (info.serviceUUID == service.UUID) {
            sect = i;
        }
    }
    if (sect !=-1) {
        PeripheralInfo *info =[self.services objectAtIndex:sect];
        for (int row=0;row<service.characteristics.count;row++) {
            CBCharacteristic *c = service.characteristics[row];
            [info.characteristics addObject:c];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:sect];
            [indexPaths addObject:indexPath];
//            NSLog(@"add indexpath in row:%d, sect:%d",row,sect);
        }
        PeripheralInfo *curInfo =[self.services objectAtIndex:sect];
//        NSLog(@"%@",curInfo.characteristics);
        //(sect%2 == 1 || sect == 1)
//        NSLog(@"info.serviceUUID is:%@,sect:%d",curInfo.serviceUUID,sect);
//        if (sect >0 ) {
            if(sect == 0)
            {
                
             mydelegate.characteristics = curInfo.characteristics;
            }
            if (sect ==1) {
                mydelegate.specialPeripheralInfo = [self.services objectAtIndex:sect];
                mydelegate.specialPeripheralInfo.characteristics = curInfo.characteristics;
                            }
//            NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"18",@"index", nil];
//            
//            [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:curInfo.characteristics delegate:self Baby:self->baby callFrom:DeviceTypeRead];
//            


            
            
//        }
        
        if (isUPdate == NO &&mydelegate.specialPeripheralInfo!=nil) {
            isUPdate = YES;
            [self updateValue];

        }
    }
   
    
}

-(void)resultStr:(CBCharacteristic *)characteristics index:(int)index
{
    
    if (index == DeviceRead) {
        
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到设备信息，数据为%@",characteristics.value]];
        NSLog(@"获取到设备信息，数据为%@",characteristics.value);
        Byte *bytes = (Byte *)[characteristics.value bytes];
        //遍历内容长度
 
        NSString * lengthStr = nil;
        // 将值转成16进制
        NSString *newStr = [NSString stringWithFormat:@"%x",bytes[13]&0xff];///16进制数
        if([newStr length]==1)
            lengthStr = [NSString stringWithFormat:@"0%@",newStr];
        else
            lengthStr = [NSString stringWithFormat:@"%@",newStr];
        
        
        //转换类型
        const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
        int  nResult=(int)strtol(swtr,NULL,16) ;

       
        
        if (nResult>0) {
            if (self.selArray.count>0) {
                [self.selArray removeAllObjects];
                
                
            }
            for (int i = 0; i<nResult; i++) {
                [self.selArray addObject:@"on"];
            }
            mydelegate.channelNum = self.selArray.count;
//            [SVProgressHUD showInfoWithStatus:@"获取到正确地设备信息"];
            
            NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"12",@"index",nil];
             [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.specialPeripheralInfo.characteristics delegate:self Baby:self->baby callFrom:DeviceNameRead];

        }
    }
    if (index == OutPutRead) {
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到输出信息，数据为%@",characteristics.value]];
         NSLog(@"获取到输出信息，数据为%@",characteristics.value);
        Byte *bytes = (Byte *)[characteristics.value bytes];
        //遍历内容长度
        
        NSString * lengthStr = nil;
        // 将值转成16进制
        NSString *newStr = [NSString stringWithFormat:@"%x",bytes[13]&0xff];///16进制数
        if([newStr length]==1)
            lengthStr = [NSString stringWithFormat:@"0%@",newStr];
        else
            lengthStr = [NSString stringWithFormat:@"%@",newStr];
        
        
        //转换类型
        const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
        int  nResult=strtol(swtr,NULL,16) ;
        switch ((ChannelNum-2)) {
            case 0:
                [userdefaults setInteger:nResult forKey:@"slider1"];
                
                
                break;
            case 1:
                [userdefaults setInteger:nResult forKey:@"slider2"];
                
                break;
            case 2:
                [userdefaults setInteger:nResult forKey:@"slider3"];
                break;
            case 4:
                [userdefaults setInteger:nResult forKey:@"slider4"];
                break;
            default:
                break;
        }

        
        ChannelNum++;
        if (ChannelNum<(self.selArray.count+2)) {
            [self loadCannel];
        }
        else
        {
            ChannelNum = 2;
//            NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"9",@"index",nil];
//            [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:TimeRead];
            [self loadCannelName];
        }
        
    }
    
    if (index == CannelNameRead) {
        
        NSLog(@"获取到通道名称信息，数据为%@",characteristics.value);
        NSData *adataTest = characteristics.value;
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到通道名称信息，数据为%@",adataTest]];
        Byte *bytes = (Byte *)[adataTest bytes];
        
        //遍历内容长度
        
//        int StrNum = sizeof(bytes)-12;
//        Byte bytesss[StrNum];
//        int j=0;
//        //去包头包尾，存需要的值进入新数组
//        for(int i=13;i<sizeof(bytes);i++)
//        {
//            bytesss[j]=bytes[i];
//            j++;
//            
//        }
        
        NSString * lengthStr = nil;
        // 将值转成16进制
        NSString *newStr = [NSString stringWithFormat:@"%x",bytes[0]&0xff];///16进制数
        if([newStr length]==1)
            lengthStr = [NSString stringWithFormat:@"0%@",newStr];
        else
            lengthStr = [NSString stringWithFormat:@"%@",newStr];
        
        
        //转换类型
        const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
        int  nResult=strtol(swtr,NULL,16) ;
        
        int j=0;

         Byte bytesss[nResult];
        for(int i=3;i<nResult+1;i++)
        {
            bytesss[j]=bytes[i];
            j++;
            
        }
        
        

        NSData *adata=[[NSData alloc] initWithBytes:bytesss length:(nResult-2)];
        
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到通道名称转换前的数据：为%@，转换后的数据，为：%@",adataTest,adata]];
        NSString* Str = [[NSString alloc] initWithData:adata
                                                 encoding:NSUTF8StringEncoding];
//       [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到通道名称为(%@)",Str]];
        NSString * lengthStr2 = nil;
        // 将值转成16进制
        NSString *newStr2 = [NSString stringWithFormat:@"%x",bytes[2]&0xff];///16进制数
        if([newStr2 length]==1)
            lengthStr2 = [NSString stringWithFormat:@"0%@",newStr2];
        else
            lengthStr2 = [NSString stringWithFormat:@"%@",newStr2];
        
        
        //转换类型
        const char *swtr2 = [lengthStr2 cStringUsingEncoding:NSASCIIStringEncoding];
        int  nResult2=strtol(swtr2,NULL,16) ;
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到通道名称序列为(%d)，newStr2为：%@",nResult2,newStr2]];
        switch ((nResult2)) {
            case 0:
                [userdefaults setObject:[Str copy] forKey:@"channel1"];
                
                
                break;
            case 1:
                [userdefaults setObject:[Str copy] forKey:@"channel2"];
                
                break;
            case 2:
                [userdefaults setObject:[Str copy] forKey:@"channel3"];
                break;
            case 4:
                [userdefaults setObject:[Str copy] forKey:@"channel4"];
                break;
            default:
                break;
        }
        newStr = nil;
        Str  = nil;
        ChannelNum++;
        if (ChannelNum<self.selArray.count+2) {
            [self loadCannelName];
        }
        else
        {
            ChannelNum = 2;
//            [sliderTView reloadData];
            NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"9",@"index",nil];
            [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:TimeRead];
//            if(mydelegate.characteristics.count>0)
//            {
//                [self startTimer];
//            }
//            [sliderTView reloadData];

        }
        
    }
    if (index == TimeRead) {
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到日期信息，数据为%@",characteristics.value]];
        NSLog(@"获取到日期信息，数据为%@",characteristics.value);
        NSString * year,* month,* day,* hour,* minute,* second;
        Byte *bytes = (Byte *)[characteristics.value bytes];
        //遍历内容长度
        
        NSString * lengthStr = nil;
        // 将值转成16进制
        NSString *newStr;
        for(int i= 12; i<sizeof(bytes);i++)
        {
        newStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newStr length]==1)
            lengthStr = [NSString stringWithFormat:@"0%@",newStr];
        else
            lengthStr = [NSString stringWithFormat:@"%@",newStr];
        
        
        //转换类型
        const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
        int  nResult=(int)strtol(swtr,NULL,16) ;
            switch (i) {
                case 4:
                    year = [NSString stringWithFormat:@"%d",nResult+2000];
                    break;
                case 5:
                    month = nResult>9?[NSString stringWithFormat:@"%d",nResult]:[NSString stringWithFormat:@"0%d",nResult];
                    break;
                case 6:
                    day = nResult>9?[NSString stringWithFormat:@"%d",nResult]:[NSString stringWithFormat:@"0%d",nResult];
                    break;
                case 7:
                    hour = nResult>9?[NSString stringWithFormat:@"%d",nResult]:[NSString stringWithFormat:@"0%d",nResult];
                    break;
                case 8:
                    minute = nResult>9?[NSString stringWithFormat:@"%d",nResult]:[NSString stringWithFormat:@"0%d",nResult];
                    break;
                case 9:
                    second = nResult>9?[NSString stringWithFormat:@"%d",nResult]:[NSString stringWithFormat:@"0%d",nResult];
                    break;
                default:
                    break;
            }
            NSString * deviceDate = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",year,month,day,hour,minute,second];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *destDate= [dateFormatter dateFromString:deviceDate];
            
            
            NSTimeInterval late1=[destDate timeIntervalSince1970]*1;
            
            
            
            NSDate *d2=[NSDate date];
            
            NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
            NSTimeInterval cha=late2-late1;
            int min = (int)cha/60%60;
            DateLbl.text =  [dateFormatter stringFromDate:d2];
            if (min>1) {
                NSArray * array1 =  [[dateFormatter stringFromDate:d2] componentsSeparatedByString:@" "];
                NSArray * array2 = [[array1 objectAtIndex:0]componentsSeparatedByString:@":"];
                NSArray * array3 = [[array1 objectAtIndex:1]componentsSeparatedByString:@":"];
                
                
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
   
                NSDateComponents *comps = [[NSDateComponents alloc] init];
                NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
                NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

                comps = [calendar components:unitFlags fromDate:d2];
                int weeknum = (int)[comps weekday];
                if(weeknum ==1)
                {
                    weeknum = 7;
                }
                else
                {
                    weeknum--;
                }
                NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[array2 objectAtIndex:0],@"value1",[array2 objectAtIndex:1],@"value2",[array2 objectAtIndex:2],@"value3",weeknum,@"value4",[array3 objectAtIndex:0],@"value5",[array3 objectAtIndex:1],@"value6",[array3 objectAtIndex:2],@"value7",nil];
                [self getRequest:8 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            }
           
        }
        if(mydelegate.characteristics.count>0)
        {
            [self startTimer];
        }
        [sliderTView reloadData];
    }
if(index == DeviceTypeRead)
{
    Byte *bytes = (Byte *)[characteristics.value bytes];
    //遍历内容长度
    
    NSString * lengthStr = nil;
    // 将值转成16进制
    NSString *newStr = [NSString stringWithFormat:@"%x",bytes[12]&0xff];///16进制数
    if([newStr length]==1)
        lengthStr = [NSString stringWithFormat:@"0%@",newStr];
    else
        lengthStr = [NSString stringWithFormat:@"%@",newStr];
    
    
    //转换类型
    const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
    int  nResult=strtol(swtr,NULL,16) ;
//    if (nResult ==2) {
//    [self updateValue];
    //    }
//    else
//    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"tab2Action" object:self userInfo:nil];
//        [SVProgressHUD showInfoWithStatus:@"arning：the device is currently set to local control instead of App control. Please switch it to App control."];
//    }
}
      if (index == DeviceNameRead) {
          NSLog(@"获取到设备名称信息，数据为%@",characteristics.value);
          NSData *adataTest = characteristics.value;
          //        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到通道名称信息，数据为%@",adataTest]];
          Byte *bytes = (Byte *)[adataTest bytes];

          NSString * lengthStr = nil;
          // 将值转成16进制
          NSString *newStr = [NSString stringWithFormat:@"%x",bytes[0]&0xff];///16进制数
          if([newStr length]==1)
              lengthStr = [NSString stringWithFormat:@"0%@",newStr];
          else
              lengthStr = [NSString stringWithFormat:@"%@",newStr];
          
          
          //转换类型
          const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
          int  nResult=strtol(swtr,NULL,16) ;
          
          int j=0;
          
          Byte bytesss[nResult];
          for(int i=2;i<nResult+1;i++)
          {
              bytesss[j]=bytes[i];
              j++;
              
          }
          
          
          
          NSData *adata=[[NSData alloc] initWithBytes:bytesss length:(nResult-1)];
          
//                  [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到通道名称转换前的数据：为%@，转换后的数据，为：%@,名称长度为：%d",adataTest,adata,nResult]];
          NSString* Str = [[NSString alloc] initWithData:adata
                                                encoding:NSUTF8StringEncoding];
          
          
          
          [userdefaults setObject:Str forKey:@"DeviceName"];
          DeviceLbl.text = Str;
          [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceName2" object:nil];
          [self loadCannel];
      }
    
    
    
}

-(void)updateValue
{
    show = YES;
    if (self.selArray.count>0) {
        [self.selArray removeAllObjects];
    }
    for (int i = 0; i<mydelegate.characteristics.count; i++) {
        [self.selArray addObject:@"on"];
        
        
        
        //                NSLog(@"%@",[[curInfo.characteristics objectAtIndex:i] UUID]);
        //                NSString * str = [NSString stringWithFormat:@"%@",[[curInfo.characteristics objectAtIndex:i] UUID]];
        //                if([ [str substringFromIndex:str.length-4] isEqual:@"1912"])
        //                {
        //
        //                    self.characteristic = [curInfo.characteristics objectAtIndex:i];
        //                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pant2Action:) userInfo:nil repeats:YES];
        //                    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        //
        isRead = YES;
       
        //                    [[[self.services objectAtIndex:1] characteristics]objectAtIndex:num]
        
        
        //                }
        //                [userdefaults setObject:curInfo.characteristics forKey:@"characteristics"];
        
    }
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",8],@"index",nil];
    
    [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:DeviceRead];
    

//    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"12",@"index",nil];
//    [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.specialPeripheralInfo.characteristics delegate:self Baby:self->baby callFrom:DeviceNameRead];
    

}

//读取输出
-(void)loadCannel
{
    
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",ChannelNum],@"index",nil];
    
    [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:OutPutRead];
}

//读取通道名称
-(void)loadCannelName
{

    
     NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(ChannelNum+12)],@"index",nil];
    
    [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.specialPeripheralInfo.characteristics delegate:self Baby:self->baby callFrom:CannelNameRead];
}

#pragma mark --
#pragma mark - 表单设置






// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//     return self.sliderArray.count;
    if(self.selArray.count>0 && show == YES)
    {
//        show = NO;
//    PeripheralInfo *info = [self.services objectAtIndex:1];
//
        return self.selArray.count;
//        if(self.services.count>3)
//        {
//        return 3;
//        }
//        else
//        {
//            return [info.characteristics count];
//        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CBCharacteristic *characteristic = [[[self.services objectAtIndex:1] characteristics]objectAtIndex:indexPath.row];
    static NSString *detailIndicated =@"tableCell";
//    NSString *string1 =[NSString stringWithFormat:@"%@",characteristic.UUID];
//    NSString *string2 = [string1 substringFromIndex:string1.length-4];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
        UILabel *Lbl = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 80, 30)];
      
//        Lbl.text = string2;
//        Lbl.text = [userdefaults objectForKey:[NSString stringWithFormat:@"channel%ld",(long)(indexPath.row+1)]];
        NSLog(@"%@",[userdefaults objectForKey:[NSString stringWithFormat:@"channel%ld",(long)(indexPath.row+1)]]);
         Lbl.text = [userdefaults objectForKey:[NSString stringWithFormat:@"channel%ld",(long)(indexPath.row+1)]];
        
               Lbl.backgroundColor = [UIColor clearColor];
        [Lbl setTextAlignment:NSTextAlignmentLeft];
        [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
        [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
        Lbl.tag = 10000 + indexPath.row;
        [cell addSubview:Lbl];
        
        UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 50, Device_Wdith-190, 20)];
        slider.minimumValue = 0;
        slider.maximumValue = 100;
//        slider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
//        slider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
//        slider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
//        slider.value = 50;
//        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
//        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
//        [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(saveSlider:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        slider.tag = 100 + indexPath.row;
        [cell addSubview:slider];
        
        Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-150, 45, 40, 30)];
        Lbl.text = @"OFF";
        Lbl.backgroundColor = [UIColor clearColor];
        [Lbl setTextAlignment:NSTextAlignmentLeft];
        [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
        [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
        [cell addSubview:Lbl];
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(Device_Wdith-115, 49, 80.0f, 28.0f)];
        
        
        switchView.on = YES;//设置初始为ON的一边
        switchView.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
        [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        switchView.tag = 1000 + indexPath.row;
        [cell addSubview:switchView];
        
        Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, 45, 30, 30)];
        Lbl.text = @"ON";
        Lbl.backgroundColor = [UIColor clearColor];
        [Lbl setTextAlignment:NSTextAlignmentLeft];
        [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
        [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
        [cell addSubview:Lbl];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISlider * slider = (UISlider *)[cell viewWithTag:(100+indexPath.row)];
    UISwitch * switchView = (UISwitch *)[cell viewWithTag:(1000+indexPath.row)];
  UILabel * Lbl = (UILabel *)[cell viewWithTag:(10000+indexPath.row)];
    
    Lbl.text = [userdefaults objectForKey:[NSString stringWithFormat:@"channel%ld",(long)(indexPath.row+1)]];
    
            if ([[self.selArray objectAtIndex:indexPath.row] isEqualToString:@"on"]) {
                slider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
               
                switchView.on = YES;
//                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"slider%ld",indexPath.row+1]]);
                slider.value = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"slider%ld",indexPath.row+1]] ==nil?100:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"slider%ld",indexPath.row+1]]intValue];
                [slider setThumbImage:[UIImage imageNamed:@"blue_circle"] forState:UIControlStateNormal];
//                [slider setThumbImage:[UIImage imageNamed:@"blue_circle"] forState:UIControlStateHighlighted];
                
                [slider setMinimumTrackImage:[UIImage imageNamed:@"Blue_cord"] forState:UIControlStateNormal];
                [slider setMaximumTrackImage:[UIImage imageNamed:@"filament"] forState:UIControlStateNormal];
                [slider setMaximumTrackImage:[UIImage imageNamed:@"filament"] forState:UIControlStateHighlighted];
                
                
//                - (void)setMinimumTrackImage:(nullable UIImage *)image forState:(UIControlState)state;
//                - (void)setMaximumTrackImage:(nullable UIImage *)image forState:(UIControlState)state;
            }
            else
            {
                slider.minimumTrackTintColor = [UIColor colorWithRed:(float)182/255.0 green:(float)182/255.0 blue:(float)182/255.0 alpha:1.0f];
               
                switchView.on = NO;
                slider.value = 0;
                [slider setThumbImage:[UIImage imageNamed:@"Grey_circle"] forState:UIControlStateNormal];
                [slider setThumbImage:[UIImage imageNamed:@"Grey_circle"] forState:UIControlStateHighlighted];
                
                [slider setMinimumTrackImage:[UIImage imageNamed:@"Gray_thickline"] forState:UIControlStateNormal];

                [slider setMaximumTrackImage:[UIImage imageNamed:@"filament"] forState:UIControlStateNormal];
                [slider setMaximumTrackImage:[UIImage imageNamed:@"filament"] forState:UIControlStateHighlighted];
            }
    
//    NSLog(@"%@",self.selArray);
//    if (dataView != nil) {
//        [dataView removeFromSuperview];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeView" object:nil];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

//重写UIGestureRecognizerDelegate,解决UITapGestureRecognizer与didSelectRowAtIndexPath冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}




-(void)saveSlider:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    
    switch ((slider.tag-100)) {
        case 0:
            [userdefaults setFloat:f forKey:@"slider1"];
            
            
            break;
        case 1:
            [userdefaults setFloat:f forKey:@"slider2"];
            
            break;
        case 2:
            [userdefaults setFloat:f forKey:@"slider3"];
            break;
        case 4:
            [userdefaults setFloat:f forKey:@"slider4"];
            break;
        default:
            break;
    }
//    self.characteristic = [[[self.services objectAtIndex:1] characteristics]objectAtIndex:slider.tag-100];
    self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:1];
    
    if(self.currPeripheral != nil &&self.characteristic != nil)
    {
        //    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
//        switchView1.on = YES;
        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)(slider.tag-100)],@"index",[NSString stringWithFormat:@"%.0f",f],@"value", nil];
         isRead = NO;
        [self getRequest:3 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
    }
}
- (void)startTimer
 {
         Hearttimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
//         //[[NSRunLoop currentRunLoop] run];
     }
- (void)timerFire
{
    
#pragma mark 心跳包控制
    
    if (!heartStart) {
        return;
    }
    
    if (timerNum==20) {
        NSLog(@"test timer");
        if (self.services.count == 0) {
            return;
        }
        self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:1];
        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index", nil];
        [self getRequest:2 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        timerNum = 0;
    }
//    if (HeartSave == NO && timerNum>2) {
//        [Hearttimer invalidate];
//        Hearttimer = nil;
//        timerNum = 20;
//        self.characteristic = [[[self.services objectAtIndex:1] characteristics]objectAtIndex:1];
//        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index", nil];
//        [self getRequest:2 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
//        NSDictionary * tempDic = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"bool",nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnect" object:self userInfo:[tempDic copy]];
//        tempDic = nil;
//    }
    timerNum++;
}
/*
-(void) switchAction:(id)sender
{
    
    UISwitch * switchw = (UISwitch *)sender;
    long num = 0;

    if (switchw == switchView1&& self.services.count>0) {
        self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:1];

        if (switchw.on) {
            int num = self.selArray.count;
            [self.selArray removeAllObjects];
            for (int i; i<num; i++) {
                [self.selArray addObject:@"on"];
            }
//            self.selArray = [NSMutableArray arrayWithObjects:@"on",@"on",@"on",@"on", nil];
             allTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(allOnAction:) userInfo:nil repeats:YES];
        }
        else
        {
            int num = self.selArray.count;
            [self.selArray removeAllObjects];
            for (int i; i<num; i++) {
                [self.selArray addObject:@"off"];
            }
//            self.selArray = [NSMutableArray arrayWithObjects:@"off",@"off",@"off",@"off", nil];
             allTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(allOffAction:) userInfo:nil repeats:YES];
       
        }
        
        
       
    }
    else if (switchw == switchView2)
    {
        
        if (switchw.on) {
            
//            PopView.hidden = NO;
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:@"select"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];

            
            for (int i = 0; i< pickerArray.count; i++) {
                [actionSheet addButtonWithTitle:[pickerArray objectAtIndex:i] ];
                
            }
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
            
        }
        else
        {
//            PopView.hidden = YES;
            if(self.currPeripheral != nil &&self.characteristic != nil)
            {
                //         num = switchw.tag - 1000;
                num = 1;
            self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:num];
//            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
            [self writeList:0 value:0 value2:0];
            }
        }
        
    }
    else
    {
//         num = switchw.tag - 1000;
        num = 1;
        self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:num];
//        if(self.currPeripheral != nil &&self.characteristic != nil)
//        {
//            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);}
        if (switchw.on) {
            [self.selArray replaceObjectAtIndex:(switchw.tag - 1000) withObject:@"on"];
            if(self.currPeripheral != nil &&self.characteristic != nil)
            {
//            [self writeOn];
                if(self.currPeripheral != nil &&self.characteristic != nil)
                {
                    //    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
//                    switchView1.on = YES;
                    ;
                    isRead = NO;
                    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)(switchw.tag - 1000)],@"index",[NSString stringWithFormat:@"%@",[userdefaults objectForKey:[NSString stringWithFormat:@"slider%d",(int)(switchw.tag - 999)]]],@"value", nil];
                    [self getRequest:3 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
                }
            }
        }
        else
        {
            
            [self.selArray replaceObjectAtIndex:(switchw.tag - 1000) withObject:@"off"];
            if(self.currPeripheral != nil &&self.characteristic != nil)
            {
//            [self writeOff];
                isRead = NO;
                NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)(switchw.tag - 1000)],@"index",@"0",@"value", nil];
                [self getRequest:3 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

            }
        }
       [sliderTView reloadData];
    }
    
    //读取服务
    [sliderTView reloadData];


//    UISwitch * switchw = (UISwitch *)sender;
}
 */
 


-(void) switchAction:(id)sender
{
    
    UISwitch * switchw = (UISwitch *)sender;
    long num = 0;
    
    if (switchw == switchView1&& self.services.count>0) {
        self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:1];
#pragma mark self.selArray 数量更改
        [self.selArray removeAllObjects];

        if (switchw.on) {
            
            self.selArray = [NSMutableArray arrayWithObjects:@"on",@"on",@"on", nil];
//            for (int i = 0; i < ChannelNum; i ++) {
//                [self.selArray addObject:@"on"];
//            }
            allTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(allOnAction:) userInfo:nil repeats:YES];
        }
        else
        {
            self.selArray = [NSMutableArray arrayWithObjects:@"off",@"off",@"off", nil];
//            [self.selArray addObject:@"off"];
            allTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(allOffAction:) userInfo:nil repeats:YES];
            
        }
        
        
//        dataView = [[UIView alloc] initWithFrame:self.view.frame];
//        dataView.backgroundColor = [UIColor blackColor];
//        UIActivityIndicatorView * aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        aiv.center = dataView.center;
//        aiv.color = [UIColor blueColor];
//        [aiv startAnimating];
//        
//        [dataView addSubview:aiv];
//        [self.view addSubview:dataView];
//        [dataView bringSubviewToFront:self.view];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addDataView" object:nil];
    }
    else if (switchw == switchView2)
    {
        
        if (switchw.on) {
            
            //            PopView.hidden = NO;
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:@"select"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:nil];
            
            
            for (int i = 0; i< pickerArray.count; i++) {
                [actionSheet addButtonWithTitle:[pickerArray objectAtIndex:i] ];
                
            }
            actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [actionSheet showInView:self.view];
            
        }
        else
        {
            num = 1;
            self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:num];
            //            PopView.hidden = YES;
            if(self.currPeripheral != nil &&self.characteristic != nil)
            {
                //         num = switchw.tag - 1000;
               
                //            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
                [self writeList:0 value:0 value2:0];
            }
        }
        
    }
    else
    {
        //         num = switchw.tag - 1000;
        num = 1;
        self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:num];
        //        if(self.currPeripheral != nil &&self.characteristic != nil)
        //        {
        //            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);}
        if (switchw.on) {
            switchView1.on = YES;
            [self.selArray replaceObjectAtIndex:(switchw.tag - 1000) withObject:@"on"];
            if(self.currPeripheral != nil &&self.characteristic != nil)
            {
                //            [self writeOn];
                if(self.currPeripheral != nil &&self.characteristic != nil)
                {
                    //    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
                    //                    switchView1.on = YES;
                    ;
                    isRead = NO;
                    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)(switchw.tag - 1000)],@"index",[NSString stringWithFormat:@"%@",[userdefaults objectForKey:[NSString stringWithFormat:@"slider%d",(int)(switchw.tag - 999)]]],@"value", nil];
                    [self getRequest:3 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
                }
            }
        }
        else
        {
            
            [self.selArray replaceObjectAtIndex:(switchw.tag - 1000) withObject:@"off"];
            if(self.currPeripheral != nil &&self.characteristic != nil)
            {
                //            [self writeOff];
                isRead = NO;
                NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)(switchw.tag - 1000)],@"index",@"0",@"value", nil];
                [self getRequest:3 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
                
            }
            BOOL isyes = NO;
//            NSLog(@"%d  %@",self.selArray.count,self.selArray);
            for (NSString * str in self.selArray) {
                if ([str isEqualToString:@"on"]) {
                    isyes = YES;
                }
            }
            switchView1.on = isyes;
        }
        [sliderTView reloadData];
    }
    
    //读取服务
    
    
    //    UISwitch * switchw = (UISwitch *)sender;
}


#pragma mark --
#pragma mark - UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    }
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        switchView2.on = NO;
    }
    else
    {
        if(self.currPeripheral != nil &&self.characteristic != nil)
        {
            
            if (buttonIndex == 1) {
                [self writeList:1 value:0 value2:30];
            }
            else if(buttonIndex == 2)
            {
//                [self writeList:1 value:[[pickerArray objectAtIndex:(buttonIndex-1)]intValue] value2:0];
                [self writeList:1 value:2 value2:0];
            }else if (buttonIndex == 3){
            
                [self writeList:1 value:4 value2:0];
            }else if (buttonIndex == 4){
            
                [self writeList:1 value:6 value2:0];
            }else if (buttonIndex == 5){
            
                [self writeList:1 value:0 value2:0];
            }
            
        }
    }

}


#pragma  --
#pragma touch
//-(void) okAction
//{
////    NSInteger row =[PickerView selectedRowInComponent:0];
////    NSString *selected = [pickerArray objectAtIndex:row];
////    NSString *message = [[NSString alloc] initWithFormat:@"你选择的是:%@",selected];
////    
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
////                                                    message:message
////                                                   delegate:self
////                                          cancelButtonTitle:@"OK"
////                                          otherButtonTitles: nil];
////    [alert show];
//    
////    self.characteristic = [[[self.services objectAtIndex:1] characteristics]objectAtIndex:num];
//    if(self.currPeripheral != nil &&self.characteristic != nil)
//    {
////    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
//    [self writeList:1 value:0 value2:0];
//    }
//
//    
//}


-(void)loadDataAction:(NSNotification *)notification
{
    
    isRead = NO;
    NSDictionary * temp = notification.userInfo;
    self.currPeripheral = [temp objectForKey:@"currPeripheral"];
    
    
    if (self.services.count > 0) {
        [self.services removeAllObjects];
    }
#pragma mark 需要打开或关闭
//    if (mydelegate.characteristics.count > 0) {
//        [mydelegate.characteristics removeAllObjects];
//    }
//    
//    if(mydelegate.specialPeripheralInfo.characteristics.count>0)
//    {
//        [mydelegate.specialPeripheralInfo.characteristics removeAllObjects];
//    }
    
//    if(baby!=nil)
//    {
////        [baby cancelAllPeripheralsConnection];
//        [baby stop];
//    }
    
    
    if (mydelegate.characteristics.count > 0) {
        [mydelegate.characteristics removeAllObjects];
    }
    
    if(mydelegate.specialPeripheralInfo.characteristics.count>0)
    {
        [mydelegate.specialPeripheralInfo.characteristics removeAllObjects];
    }
    if(mydelegate.specialPeripheralInfo!=nil)
    {
        
        mydelegate.specialPeripheralInfo = nil;
    }

    
    self ->baby = nil;
    self->baby = [temp objectForKey:@"baby"];
//    [baby cancelAllPeripheralsConnection];
//    self->baby = [temp objectForKey:@"baby"];

    
    [self babyDelegate];
    mydelegate.currPeripheral = [temp objectForKey:@"currPeripheral"];
    mydelegate.baby = [temp objectForKey:@"baby"];


    //开始扫描设备
    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    
    
    
    
}

-(void)writeOn{

isRead = NO;
   [self getRequest:1 requestDic:nil  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
}
//写一个值
-(void)writeOff{
isRead = NO;
    [self getRequest:0 requestDic:nil  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
}

-(void)writeList:(int)index
{
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",index],@"index", nil];
    isRead = NO;
    [self getRequest:2 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

}

-(void)writeList:(int)index value:(int)value
{isRead = NO;
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",index],@"index",[NSString stringWithFormat:@"%d",value],@"value", nil];
    [self getRequest:3 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
}
//-(void)writeList:(int)index value:(int)value value2:(int)value2
//{isRead = NO;
//    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",value],@"value1",[NSString stringWithFormat:@"%d",value2],@"value2", nil];
//    [self getRequest:5 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
//}

-(void)writeList:(int)index value:(int)value value2:(int)value2
{isRead = NO;
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",index],@"index",[NSString stringWithFormat:@"%d",value],@"value1",[NSString stringWithFormat:@"%d",value2],@"value2", nil];
    [self getRequest:4 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
}

//-(void)writeList:(int)type value1:(int)value1 value2:(int)value2 value3:(int)value3 value4:(int)value4 value5:(int)value5 value6:(int)value6 value7:(int)value7
//{
//   
//}

//-(void)pantAction
//{
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pant2Action:) userInfo:nil repeats:YES];
//     [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
////
//}
-(void)allOnAction:(NSTimer *)theTimer
{
    
    if(self.currPeripheral != nil &&self.characteristic != nil)
    {
        //            [self writeOn];
        if(self.currPeripheral != nil &&self.characteristic != nil)
        {
            //    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
            switchView1.on = YES;
            ;
            isRead = NO;
            NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(number - 1)],@"index",[NSString stringWithFormat:@"%@",[userdefaults objectForKey:[NSString stringWithFormat:@"slider%d",number]]],@"value", nil];
            [self getRequest:3 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        }
    }

   
    if (number ==mydelegate.channelNum && allTimer != nil) {
        [allTimer invalidate];
        allTimer = nil;
        number = 1;
        [sliderTView reloadData];
        return;
    }
     number ++;
}


-(void)allOffAction:(NSTimer *)theTimer
{
    
    if(self.currPeripheral != nil &&self.characteristic != nil)
    {
        isRead = NO;
        //            [self writeOff];
        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",(int)(number - 1)],@"index",@"0",@"value", nil];
        [self getRequest:3 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        
    }
    
    
    if (number ==4 && allTimer != nil) {
        [allTimer invalidate];
        allTimer = nil;
        number = 1;
        [sliderTView reloadData];
        return;
    }
    number ++;
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"写入数据错误");
    }else
    {
        NSLog(@"写入数据正确");
    }
    
}


-(void)loadTable
{
    
    [sliderTView reloadData];
}
/**更新设备名称*/
-(void)updateDeviceName
{
    
    
    DeviceLbl.text = [userdefaults objectForKey:@"DeviceName"];
}

//断开链接
- (void)Disconnect{

    
}

//修改heartStart参数
- (void)setHeartStart{

    heartStart = YES;
#pragma mark 每次进来开始一次心跳包
    sleep(1);
    NSLog(@"第一次心跳包发送");
    self.characteristic = [[[self.services objectAtIndex:0] characteristics]objectAtIndex:1];
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index", nil];
    [self getRequest:2 requestDic:temp  characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

}

- (void)setHeartStop{

    heartStart = NO;
}







@end
