//
//  ViewController.m
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "DeviceViewController.h"
#import "SVProgressHUD.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
     BabyBluetooth *baby;
    NSMutableArray *peripherals;
    NSMutableArray *peripheralsAD;
    NSMutableArray *RSSIArray;
    NSMutableArray *DeviceName;
    NSArray *characteristics;
    int indexRow;
    NSUserDefaults *userdefaults;
    
    CBPeripheral *peripheralTest;
    
}
@property (nonatomic,strong) UITableView * DeviceTView;
@property (nonatomic,strong) NSMutableArray * DeviceArray;
@property (nonatomic,strong) UIButton * reloadBtn;
@end

@implementation DeviceViewController
@synthesize DeviceTView;
@synthesize reloadBtn;

-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roadBLEAction:) name:@"roadBLE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roadingAction) name:@"Refresh" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Disconnect) name:@"DisconnectBtnClick" object:nil];
    
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self iv];
    [self lc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}


#pragma mark --
#pragma mark - 初始化页面元素
/**
 *初始化参数
 */
-(void)iv
{
    userdefaults = [NSUserDefaults standardUserDefaults];
    //初始化其他数据 init other
    peripherals = [[NSMutableArray alloc]init];
    peripheralsAD = [[NSMutableArray alloc]init];
    RSSIArray = [[NSMutableArray alloc]init];
    DeviceName = [[NSMutableArray alloc]init];
     self.DeviceArray = [NSMutableArray arrayWithObjects:@"light1",@"light2", nil];
//    wordColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
//    wordSelColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
}

/**
 *加载控件
 */
-(void)lc
{
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    
//    [userdefaults setObject:self.mobelTxt.text forKey:@"phoneNumber"];
//    [userdefaults setObject:province forKey:@"province"];
//    [userdefaults setObject:city forKey:@"city"];
//    [userdefaults setObject:usertype forKey:@"usertype"];
//    [userdefaults setInteger:provinceSelect forKey:@"provinceSelect"];
//    [userdefaults setInteger:citySelect forKey:@"citySelect"];
//    [userdefaults setInteger:userTypeSelect forKey:@"userTypeSelect"];
//
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    pNum = [userdefaults objectForKey:@"phoneNumber"] == nil?@"":[userdefaults objectForKey:@"phoneNumber"];
//    province = [userdefaults objectForKey:@"province"] == nil?@"广东":[userdefaults objectForKey:@"province"];
//    city = [userdefaults objectForKey:@"city"] == nil?@"广州":[userdefaults objectForKey:@"city"];
//    usertype = [userdefaults objectForKey:@"usertype"] == nil?@"用户属性":[userdefaults objectForKey:@"usertype"];
//    provinceSelect = ([userdefaults objectForKey:@"provinceSelect"] == nil?5:[[userdefaults objectForKey:@"provinceSelect"]intValue]);
//    citySelect = ([userdefaults objectForKey:@"citySelect"] == nil?0:[[userdefaults objectForKey:@"citySelect"]intValue]);
//    
//    userTypeSelect  = ([userdefaults objectForKey:@"userTypeSelect"] == nil?0:[[userdefaults objectForKey:@"userTypeSelect"]intValue]);
    
    
    DeviceTView =[[UITableView alloc] init];
    DeviceTView.backgroundColor = [UIColor clearColor];
    DeviceTView.frame=CGRectMake(0, 0, Device_Wdith, Device_Height-293);
    DeviceTView.dataSource = self;
    DeviceTView.delegate = self;
    //设置table是否可以滑动
    DeviceTView.scrollEnabled = YES;
    //隐藏table自带的cell下划线
    DeviceTView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:DeviceTView];
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, Device_Height-283, Device_Wdith-80, (Device_Wdith-80)/3)];
    [imgView setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:imgView];
    
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, Device_Height-280+(Device_Wdith-80)/3, Device_Wdith, 30)];
    Lbl.text = @"Smart Control";
    Lbl.font = [UIFont systemFontOfSize:26];
    Lbl.backgroundColor = [UIColor colorWithRed:(float)253/255.0 green:(float)253/255.0 blue:(float)253/255.0 alpha:1.0f];
    Lbl.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:Lbl];
    
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    //设置蓝牙委托
    [self babyDelegate];

    reloadBtn = [[UIButton alloc]initWithFrame: CGRectMake(30, 90, Device_Wdith-60, 40)];
    [reloadBtn setTitle:@"To scan" forState:UIControlStateNormal];
    [reloadBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [reloadBtn setBackgroundColor:[UIColor clearColor]];
//    [reloadBtn setCenter:self.view.center];
    [reloadBtn addTarget:self action:@selector(roadingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadBtn];
//    [reloadBtn.layer setBorderColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f].CGColor];
//    [reloadBtn.layer setBorderWidth:1];
    reloadBtn.hidden = YES;
}

#pragma mark --
#pragma mark - 表单设置



// 设置cell的高度
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *detailIndicated =@"tableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailIndicated];
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    NSDictionary *ad = [peripheralsAD objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailIndicated];
            UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (Device_Wdith-88)/2, 44)];
            Lbl.tag = 100;
            Lbl.backgroundColor = [UIColor clearColor];
            [Lbl setTextAlignment:NSTextAlignmentRight];
            [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
            [Lbl setFont:[UIFont systemFontOfSize:15]];
            [cell addSubview:Lbl];
            
            UIImageView * signalImg = [[UIImageView alloc]initWithFrame:CGRectMake((Device_Wdith-50)/2+20, 12, 20, 20)];
            
//            [signalImg setImage:[UIImage imageNamed:@"signal1"]];
            [signalImg setImage:[UIImage imageNamed:RSSIArray[indexPath.row]]];
            
            NSLog(@"%@",RSSIArray[indexPath.row]);
            
            [signalImg setBackgroundColor:[UIColor clearColor]];
            signalImg.tag = 1000 + indexPath.row;
            [cell addSubview:signalImg];
            Lbl = [[UILabel alloc]initWithFrame:CGRectMake((Device_Wdith-50)/2+50, 0, (Device_Wdith-50)/2, 44)];
            Lbl.tag = 101;
            Lbl.backgroundColor = [UIColor clearColor];
            [Lbl setTextAlignment:NSTextAlignmentLeft];
            [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
            [Lbl setFont:[UIFont systemFontOfSize:15]];
            [cell addSubview:Lbl];
            
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel * Lbl = (UILabel *)[cell viewWithTag:100];
        UILabel * Lbl2 = (UILabel *)[cell viewWithTag:101];
     UIImageView * signalImg = (UIImageView *)[cell viewWithTag:1000+indexPath.row];
    
    [signalImg setImage:[UIImage imageNamed:[RSSIArray objectAtIndex:indexPath.row]]];
    
    
    
    //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
//    NSString *localName;
//    if ([ad objectForKey:@"kCBAdvDataLocalName"]) {
//        localName = [NSString stringWithFormat:@"%@",[ad objectForKey:@"kCBAdvDataLocalName"]];
//    }else{
//        localName = peripheral.name;
//    }
//    [Lbl setText:peripheral.name];
    [Lbl setText:[DeviceName objectAtIndex:indexPath.row]];
    
    [Lbl2 setText:@"100%"];
//    cell.textLabel.text = localName;
//    //信号和服务
//    cell.detailTextLabel.text = @"读取中...";
    //找到cell并修改detaisText
    NSArray *serviceUUIDs = [ad objectForKey:@"kCBAdvDataServiceUUIDs"];
    if (serviceUUIDs) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu个service",(unsigned long)serviceUUIDs.count];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"0个service"];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary * tempDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"bool",nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnect" object:self userInfo:[tempDic copy]];
//    tempDic = nil;
//    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"18",@"index", nil];
//
    indexRow = (int)indexPath.row;
//    [self readRequest:2 requestDic:temp currPeripheral:[peripherals objectAtIndex:indexPath.row] characteristicArray:characteristics delegate:self Baby:self->baby callFrom:DeviceTypeRead];
//
    
    [baby cancelScan];
    
    CBPeripheral *peripheral = [peripherals objectAtIndex:indexPath.row];
    
    peripheralTest = peripheral;
    
    NSLog(@"你点击了第%d行,选择名字为%@的设备",indexRow,peripheral.name);
    
//    [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"你点击了第%d行,选择名字为%@的设备",indexRow,peripheral.name]];

    CBPeripheral * per = [peripherals objectAtIndex:indexRow];
    NSLog(@"连接到得外设%@",per.name);
    NSDictionary * temp  =  [NSDictionary dictionaryWithObjectsAndKeys:[peripherals objectAtIndex:indexRow], @"currPeripheral",self->baby,@"baby", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabAction" object:self userInfo:[temp copy]];
    temp =nil;
    NSDictionary * tempDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"bool",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnect" object:self userInfo:[tempDic copy]];
    tempDic = nil;

    

   //    PeripheralViewContriller *vc = [[PeripheralViewContriller alloc]init];
//    vc.currPeripheral = [peripherals objectAtIndex:indexPath.row];
//    vc->baby = self->baby;
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

#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
    

        NSLog(@"搜索到了设备:%@ 信号强度为 %@",peripheral.name,RSSI);
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:[RSSI intValue]];
    }];
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        NSLog(@"设备：%@--连接成功",peripheral.name);
    }];
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
    }];
    //设置设备断开连接的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--断开连接",peripheral.name);
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
       
        //找到cell并修改detaisText
        for (int i=0;i<peripherals.count;i++) {
            UITableViewCell *cell = [weakSelf.DeviceTView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.textLabel.text == peripheral.name) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu个service",(unsigned long)peripheral.services.count];
            }
        }
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
            characteristics = service.characteristics;
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        
       

    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName) {
        
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 2
        if (peripheralName.length >2) {
            return YES;
        }
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelPeripheralConnectionBlock:^(CBCentralManager *centralManager, CBPeripheral *peripheral) {
        NSLog(@"setBlockOnCancelPeripheralConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    /*设置babyOptions
     
     参数分别使用在下面这几个地方，若不使用参数则传nil
     - [centralManager scanForPeripheralsWithServices:scanForPeripheralsWithServices options:scanForPeripheralsWithOptions];
     - [centralManager connectPeripheral:peripheral options:connectPeripheralWithOptions];
     - [peripheral discoverServices:discoverWithServices];
     - [peripheral discoverCharacteristics:discoverWithCharacteristics forService:service];
     
     该方法支持channel版本:
     [baby setBabyOptionsAtChannel:<#(NSString *)#> scanForPeripheralsWithOptions:<#(NSDictionary *)#> connectPeripheralWithOptions:<#(NSDictionary *)#> scanForPeripheralsWithServices:<#(NSArray *)#> discoverWithServices:<#(NSArray *)#> discoverWithCharacteristics:<#(NSArray *)#>]
     */
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    //    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(int)RSSI{
    if(![peripherals containsObject:peripheral]){
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        [peripherals addObject:peripheral];
        [peripheralsAD addObject:advertisementData];
        [DeviceName addObject:peripheral.name];
        if(abs(RSSI)>=-40)
        {
            [RSSIArray addObject:@"signal1"];
        }
        else if(abs(RSSI)>=-70&&RSSI<-40)
        {
            [RSSIArray addObject:@"signal2"];
        }
        else if(abs(RSSI)>-80 && RSSI<-70)
        {
           [RSSIArray addObject:@"signal3"];
        }
        
        
    }
    
    [DeviceTView reloadData];

    
}





//- (void) addSavedDevice:(CFUUIDRef)uuid {
//    NSArray *storedDevices = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
//    NSMutableArray *newDevices = nil;
//    CFStringRef uuidString = NULL;
//    if (![storedDevices isKindOfClass:[NSArray class]]) {
//        NSLog(@"Can't find/create an array to store the uuid");
//        return;
//    }
//    
//    newDevices = [NSMutableArray arrayWithArray:storedDevices];
//    uuidString = CFUUIDCreateString(NULL, uuid);
//    if (uuidString) {
//        [newDevices addObject:(__bridge NSString*)uuidString];
//        CFRelease(uuidString);
//    }
//    
//    /* Store */
//    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//- (void) loadSavedDevices {
//    NSArray *storedDevices = [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
//    if (![storedDevices isKindOfClass:[NSArray class]]) {
//        NSLog(@"No stored array to load");
//        return;
//    }
//    
//    for (id deviceUUIDString in storedDevices) {
//        if (![deviceUUIDString isKindOfClass:[NSString class]]) continue;
//        
//        CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)deviceUUIDString);
//        if (!uuid) continue;
////        [CBCentralManager retrievePeripherals:[NSArray arrayWithObject:(__bridge id)uuid]];
////        [CBCentralManager.]
//        CFRelease(uuid);
//    }
//}
//
////And the delegate function for the Retrieve Peripheral
//
//- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripheralss {
//    CBPeripheral *peripheral;
//    /* Add to list. */
//    for (peripheral in peripheralss) {
//        [central connectPeripheral:peripheral options:nil];
//    }
//}
//
//- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral {
//    [central connectPeripheral:peripheral options:nil];
//}
/**判断是否需要显示网络异常时的刷新按钮*/
-(void)roadBLEAction:(NSNotification *)notification
{
    reloadBtn.hidden = NO;
    [self.view bringSubviewToFront:reloadBtn];
}

-(void)roadingAction
{
    
    reloadBtn.hidden = YES;
    //停止之前的连接
//    [baby stop];
    
    [baby babyStop];

    [baby cancelAllPeripheralsConnection];
    [baby cancelPeripheralConnection:peripheralTest];
    
//    [baby stop];
//    [indexPaths addObject:indexPath];
    [peripherals removeAllObjects];
    peripherals = nil;
    peripherals = [[NSMutableArray alloc] init];
    [peripheralsAD removeAllObjects];
    peripheralsAD = nil;
    peripheralsAD = [[NSMutableArray alloc] init];
    [RSSIArray removeAllObjects];
    RSSIArray = nil;
    RSSIArray = [[NSMutableArray alloc] init];
    [DeviceName removeAllObjects];
    DeviceName = nil;
    DeviceName = [[NSMutableArray alloc] init];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    
//=============================================================================
//    sleep(2);
    baby.scanForPeripherals().begin();
}
/**Nofity返回值*/
-(void)resultStr:(CBCharacteristic *)characteristics index:(int)index
{
    if (index == DeviceTypeRead) {
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
        if (nResult ==2) {
            NSDictionary * temp  =  [NSDictionary dictionaryWithObjectsAndKeys:[peripherals objectAtIndex:indexRow], @"currPeripheral",self->baby,@"baby", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tabAction" object:self userInfo:[temp copy]];
            temp =nil;
            NSDictionary * tempDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"bool",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Disconnect" object:self userInfo:[tempDic copy]];
            tempDic = nil;

        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"arning：the device is currently set to local control instead of App control. Please switch it to App control."];
        }
    }
}


//断开连接
- (void)Disconnect{

//    [baby cancelAllPeripheralsConnection];
//    baby = nil;
//    //初始化BabyBluetooth 蓝牙库
//    baby = [BabyBluetooth shareBabyBluetooth];
//    //设置蓝牙委托
//    [self babyDelegate];
    [baby cancelPeripheralConnection:peripheralTest];



}

@end
