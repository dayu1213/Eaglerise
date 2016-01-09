//
//  OverViewController.m
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "OverViewController.h"
#import "JXBarChartView.h"
#define channelOnPeropheralView @"OverView"
@interface OverViewController ()<UIScrollViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,CBPeripheralManagerDelegate>
{
    NSMutableArray *textIndicators;
    NSMutableArray *values;
    UILabel * popLbl;
    int week;
    int time;
    AppDelegate * mydelegate;
    NSUserDefaults *userdefaults;
    JXBarChartView *barChartView;
     NSTimer * timer;
}
@property (nonatomic,strong) UILabel * popLbl;
@property (nonatomic,strong) UIScrollView * contentSView;
@property (nonatomic,strong) UIButton * okBtn;
@property (nonatomic,strong) UISlider * slider;
@property (nonatomic,strong) UISlider * WeekSlider;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@end

@implementation OverViewController
@synthesize popLbl;
@synthesize contentSView;
@synthesize okBtn;
@synthesize slider,WeekSlider;


-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAction:) name:@"loadOverView" object:nil];
        
        mydelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        userdefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];

    [self iv];
    [self lc];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.currPeripheral = mydelegate.currPeripheral;
    self->baby  = mydelegate.baby;
    self.characteristic = [mydelegate.characteristics objectAtIndex:1];
    //设置蓝牙委托
    [self babyDelegate];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (self.currPeripheral != nil && self.characteristic != nil) {
//        [self loadAction];
//    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
   
    }

#pragma mark --
#pragma mark - 初始化页面元素
/**
 *初始化参数
 */
-(void)iv
{
     textIndicators = [[NSMutableArray alloc] initWithObjects:@"channel 1", @"channel 2", @"channel 3", @"channel 4", nil];
    if ([userdefaults objectForKey:@"channel1"]!=nil) {
        [textIndicators replaceObjectAtIndex:0 withObject:[userdefaults objectForKey:@"channel1"]];
    }
    if ([userdefaults objectForKey:@"channel2"]!=nil) {
        [textIndicators replaceObjectAtIndex:1 withObject:[userdefaults objectForKey:@"channel2"]];
    }
    if ([userdefaults objectForKey:@"channel3"]!=nil) {
        [textIndicators replaceObjectAtIndex:2 withObject:[userdefaults objectForKey:@"channel3"]];
    }
    if ([userdefaults objectForKey:@"channel4"]!=nil) {
        [textIndicators replaceObjectAtIndex:3 withObject:[userdefaults objectForKey:@"channel4"]];
    }
    values = [[NSMutableArray alloc] init];
    

    for (int i = 0; i<mydelegate.channelNum; i++) {
        switch (i) {
            case 0:
                [values addObject:@([[NSUserDefaults standardUserDefaults] objectForKey:@"slider1"] ==nil?100:[[[NSUserDefaults standardUserDefaults] objectForKey:@"slider1"]intValue])];
                break;
            case 1:
                [values addObject:@([[NSUserDefaults standardUserDefaults] objectForKey:@"slider2"] ==nil?100:[[[NSUserDefaults standardUserDefaults] objectForKey:@"slider2"]intValue])];
                break;
            case 2:
                [values addObject:@([[NSUserDefaults standardUserDefaults] objectForKey:@"slider3"] ==nil?100:[[[NSUserDefaults standardUserDefaults] objectForKey:@"slider3"]intValue])];
                break;
            case 3:
                [values addObject:@([[NSUserDefaults standardUserDefaults] objectForKey:@"slider4"] ==nil?100:[[[NSUserDefaults standardUserDefaults] objectForKey:@"slider4"]intValue])];
                break;
                
            default:
                break;
        }
    }
//    values = [[NSMutableArray alloc] initWithObjects:, , , , nil];
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDate *now;
//    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    now=[NSDate date];
//    comps = [calendar components:unitFlags fromDate:now];
//    week = (int)[comps weekday];
}

/**
 *加载控件
 */
-(void)lc
{
    contentSView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, Device_Height-100)];
    [contentSView setBackgroundColor:[UIColor whiteColor]];
//    contentSView.pagingEnabled = YES;
    contentSView.delegate = self;
    contentSView.showsVerticalScrollIndicator = NO;
    contentSView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentSView];
    

    
//     NSMutableArray *values = [[NSMutableArray alloc] initWithObjects:@5.4,@6,@7, nil];
//    [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"slider%ld",indexPath.row+1]] ==nil?100:[[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"slider%ld",indexPath.row+1]]intValue];

    
    CGRect frame = CGRectMake(10, 0, Device_Wdith-20, 200);

    barChartView = [[JXBarChartView alloc] initWithFrame:frame
                                                              startPoint:CGPointMake(20, 20)
                                                                  values:values maxValue:10
                                                          textIndicators:textIndicators
                                                               textColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]
                                                               barHeight:30
                                                             barMaxWidth:Device_Wdith<321?(Device_Wdith/5*3-50):(Device_Wdith/5*3)
                                                                gradient:nil];
    barChartView.tag = 101;
    [contentSView addSubview:barChartView];
    
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 240, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 246, 70, 30)];
    Lbl.text = @"Time";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 276, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 300, 40, 30)];
    Lbl.text = @"0";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(40, 305, Device_Wdith-100, 20)];
    slider.minimumValue = 0;
    slider.maximumValue = 1380;
    slider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    slider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    slider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    slider.value = (12*60);

    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];

    [contentSView addSubview:slider];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, 300, 40, 30)];
    Lbl.text = @"24";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    popLbl = [[UILabel alloc]initWithFrame:CGRectMake(slider.frame.origin.x, slider.frame.origin.y-10, 70, 20)];
    [popLbl setTextAlignment:NSTextAlignmentCenter];
    [popLbl setBackgroundColor:[UIColor clearColor]];
//    [popLbl setAlpha:0.f];
    [contentSView addSubview:popLbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 350, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 356, 70, 30)];
    Lbl.text = @"Week";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 390, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    
    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(50, 450, Device_Wdith-100, 3)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];

    float lenght = (Device_Wdith-205)/6+15;
    
   
    
    
    for (int i = 0; i<7; i++) {
        Lbl = [[UILabel alloc]initWithFrame:CGRectMake(50+lenght*i, 443.5, 15, 15)];
        
        Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
        [Lbl.layer setCornerRadius:CGRectGetHeight([Lbl bounds]) / 2];
        [Lbl.layer setMasksToBounds:YES];
        [Lbl.layer setBorderWidth:2];
        [Lbl.layer setBorderColor:[UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f].CGColor];
//        if (week-1 == 0) {
//            week = 7;
//        }
//        if (i == 0) {
//            Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
//            [Lbl.layer setBorderColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f].CGColor];
//        }
        [contentSView addSubview:Lbl];
        
        if (i==0 || i%2==0) {
            if (i==2) {
                Lbl = [[UILabel alloc]initWithFrame:CGRectMake(15+lenght*i, 420, lenght*2, 20)];
            }
            else
            {
            Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30+lenght*i, 420, lenght*2, 20)];
            }
            
           
        }
        else
        {
            Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30+lenght*i, 460, lenght*2, 20)];
        }
        Lbl.textAlignment = NSTextAlignmentLeft;
        Lbl.backgroundColor = [UIColor clearColor];
        Lbl.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
        [contentSView addSubview:Lbl];
        switch (i) {
            case 0:
                Lbl.text = @"Monday";
                break;
            case 1:
                Lbl.text = @"Tuesday";
                
                break;
            case 2:
                Lbl.text = @"Wednesday";
                break;
            case 3:
                Lbl.text = @"Thursday";
                break;
            case 4:
                Lbl.text = @"Friday";
                break;
            case 5:
                Lbl.text = @"Saturday";
                break;
            case 6:
                Lbl.text = @"Sunday";
                break;
                
            default:
                break;
        }
//        if (week-1 == 0) {
//            week = 7;
//        }
//        if (i == (week -1)) {
//            Lbl.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
//        }
        Lbl.tag = 100+i;
        if (Device_Wdith <= 320) {
            [Lbl setFont:[UIFont systemFontOfSize:12]];
        }
//        NSLog(@"%f",Device_Wdith);
    }
    
    WeekSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 449, Device_Wdith-100, 3)];
    WeekSlider.minimumValue = 0;
    WeekSlider.maximumValue = 6;
    WeekSlider.minimumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
   [WeekSlider setThumbImage:[UIImage imageNamed:@"BlueG"] forState:UIControlStateHighlighted];
    [WeekSlider setThumbImage:[UIImage imageNamed:@"BlueG"] forState:UIControlStateNormal];
    
    WeekSlider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    WeekSlider.value = 0;
    
    [WeekSlider addTarget:self action:@selector(updateValueTwo:) forControlEvents:UIControlEventValueChanged];
    [WeekSlider addTarget:self action:@selector(updateValueThree:) forControlEvents:UIControlEventTouchUpInside];
    [contentSView addSubview:WeekSlider];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 500, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    
    okBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith/4, 550, Device_Wdith/2, 35)];
    
    [okBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [okBtn setTitle:@"Auto Play" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [okBtn addTarget:self action:@selector(StartAction) forControlEvents:UIControlEventTouchUpInside];
    
    [okBtn.layer setMasksToBounds:YES];
    
    [okBtn.layer setCornerRadius:4.0];
    
    [contentSView addSubview:okBtn];
    
    contentSView.contentSize = CGSizeMake(Device_Wdith, 620);
    
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    rect.origin.x = rect.origin.x - 30 ;
    rect.origin.x = rect.origin.y - 30 ;
    rect.size.width = rect.size.width +60;
    rect.size.height = rect.size.height +60;
    return rect;
}

-(void)updateValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    time = (slider.value/60)+0.5;
    UIImageView *imageView = [slider.subviews objectAtIndex:2];
    
    CGRect theRect = [contentSView convertRect:imageView.frame fromView:imageView.superview];
    

    
    [popLbl setFrame:CGRectMake(theRect.origin.x-22, theRect.origin.y-20, popLbl.frame.size.width, popLbl.frame.size.height)];
    
    NSInteger v = (slider.value/60)+0.5;
    if (v<13) {
        [popLbl setText:[NSString stringWithFormat:@"%ld AM",(long)v]];
    }
    else
    {
        v =v-12;
        [popLbl setText:[NSString stringWithFormat:@"%ld PM",(long)v]];
    }
    
}


-(void)updateValueTwo:(id)sender{
    UISlider * sli = (UISlider *)sender;

//        float lenght = (Device_Wdith-205)/6+15;

    week = (int)lroundf(sli.value);
    UILabel * lbl1 = (UILabel *)[contentSView viewWithTag:100];
    UILabel * lbl2 = (UILabel *)[contentSView viewWithTag:101];
    UILabel * lbl3 = (UILabel *)[contentSView viewWithTag:102];
    UILabel * lbl4 = (UILabel *)[contentSView viewWithTag:103];
    UILabel * lbl5 = (UILabel *)[contentSView viewWithTag:104];
    UILabel * lbl6 = (UILabel *)[contentSView viewWithTag:105];
    UILabel * lbl7 = (UILabel *)[contentSView viewWithTag:106];
     lbl1.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
     lbl2.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
     lbl3.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
     lbl4.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
     lbl5.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
     lbl6.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
     lbl7.textColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    
    switch (lroundf(sli.value)) {
        case 1:
            lbl1.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
            break;
        case 2:
            lbl2.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
            break;
        case 3:
            lbl3.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
            break;
        case 4:
            lbl4.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
            break;
        case 5:
            lbl5.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
            break;
        case 6:
            lbl6.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
            break;
        case 7:
            lbl7.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
            break;
            
        default:
            break;
    }
    }

-(void)updateValueThree:(id)sender
{
    UISlider * sli = (UISlider *)sender;
    //    WeekSlider.value =ilogbf(sli.value);
    NSLog(@"---%ld=---",lroundf(sli.value));
    WeekSlider.value =week;
}

//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            //            [weakSelf insertSectionToTableView:s];
        }
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        //        [weakSelf insertRowToTableView:service];
        
        
        //        if([service.UUID isEqual:@"1912"])
        //           {
        //         NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",8],@"index",weakSelf.characteristic,@"characteristic",weakSelf.currPeripheral,@"currPeripheral",nil];
        //         [weakSelf getRequest:2 requestDic:temp delegate:weakSelf];
        //           }
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //硬件返回值
        NSLog(@"--1--characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        Byte * bytes = (Byte *)[characteristics.value bytes];
        
        NSString *newStr = [NSString stringWithFormat:@"%x",bytes[3]&0xff];///16进制数
        NSString        *snStr=@"";//识别码
        if([newStr length]==1)
            snStr = [NSString stringWithFormat:@"%@0%@",snStr,newStr];
        else
            snStr = [NSString stringWithFormat:@"%@%@",snStr,newStr];

        if ([snStr isEqualToString:@"0B"] ) {
 
                // 将值转成16进制
                NSString *newStr = [NSString stringWithFormat:@"%x",bytes[4]&0xff];///16进制数
            NSString * lengthStr = @"";
                if([newStr length]==1)
                    lengthStr = [NSString stringWithFormat:@"0%@",newStr];
                else
                    lengthStr = [NSString stringWithFormat:@"%@",newStr];
            
            
            //转换类型
            const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
            int  nResult=(int)strtol(swtr,NULL,16);
            weakSelf.slider.value = nResult;
        }
    }];
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

-(void)StartAction
{
    if(self.currPeripheral != nil &&self.characteristic != nil)
    {
//    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
    
        int value2 = week+1;
    if (week == 6) {
        value2 = 0;
    }
    NSDictionary * temp;
    if ([okBtn.titleLabel.text isEqualToString:@"Auto Play"]) {
        
        [okBtn setTitle:@"Stop Play" forState:UIControlStateNormal];
       temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%d",time],@"value1",[NSString stringWithFormat:@"%d",value2],@"value2", nil];
        [self getRequest:5 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(readAction) userInfo:nil repeats:YES];
        WeekSlider.enabled = NO;
        slider.enabled = NO;
    }
    else
    {
        [timer invalidate];
        timer = nil;
        [okBtn setTitle:@"Auto Play" forState:UIControlStateNormal];
        temp = [NSDictionary dictionaryWithObjectsAndKeys:@"7",@"index", nil];
        [self getRequest:2 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        WeekSlider.enabled = YES;
        slider.enabled = YES;
    }
    }
}

-(void)readAction
{
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index", nil];
    
    [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
}

-(void)loadAction
{
    if(self.currPeripheral != nil &&self.characteristic != nil)
    {
//    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
//    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index", nil];
//
//        [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
    }
}


-(void)loadDataAction:(NSNotification *)notification
{
    self.currPeripheral = mydelegate.currPeripheral;
    self->baby  = mydelegate.baby;
    self.characteristic = [mydelegate.characteristics objectAtIndex:1];
}

-(void)resultStr:(CBCharacteristic *)characteristics index:(int)index
{
    if (index == PreviewRead) {
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
        
        
        
        int hour = nResult;
        
        
        newStr = [NSString stringWithFormat:@"%x",bytes[12]&0xff];///16进制数
        if([newStr length]==1)
            lengthStr = [NSString stringWithFormat:@"0%@",newStr];
        else
            lengthStr = [NSString stringWithFormat:@"%@",newStr];
        
        
        //转换类型
        swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
        nResult=strtol(swtr,NULL,16) ;
        int minute = nResult;
        time = hour;

        slider.value = hour*60+minute;
        UIImageView *imageView = [slider.subviews objectAtIndex:2];
        
        CGRect theRect = [contentSView convertRect:imageView.frame fromView:imageView.superview];
        
        
        
        [popLbl setFrame:CGRectMake(theRect.origin.x-22, theRect.origin.y-20, popLbl.frame.size.width, popLbl.frame.size.height)];
        
        NSInteger v = time+0.5;
        if (v<13) {
            [popLbl setText:[NSString stringWithFormat:@"%ld AM",(long)time]];
        }
        else
        {
            v =v-12;
            [popLbl setText:[NSString stringWithFormat:@"%ld PM",(long)time]];
        }

        
        newStr = [NSString stringWithFormat:@"%x",bytes[12]&0xff];///16进制数
        if([newStr length]==1)
            lengthStr = [NSString stringWithFormat:@"0%@",newStr];
        else
            lengthStr = [NSString stringWithFormat:@"%@",newStr];
        
        
        //转换类型
        swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
        nResult=strtol(swtr,NULL,16) ;
        if (nResult == 0) {
            week = 6;
            
        }
        else
        {
            week = nResult-1;
        }
        WeekSlider.value = week;
        
        
        [textIndicators removeAllObjects];
        [values removeAllObjects];
        
        
//        newStr = [NSString stringWithFormat:@"%x",bytes[11]&0xff];///16进制数
//        if([newStr length]==1)
//            lengthStr = [NSString stringWithFormat:@"0%@",newStr];
//        else
//            lengthStr = [NSString stringWithFormat:@"%@",newStr];
//        
//        
//        //转换类型
//        swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
//        int len=strtol(swtr,NULL,16) ;
        
        for (int i =16; i<(16+mydelegate.channelNum); i++) {
            
            
            [textIndicators addObject:[userdefaults objectForKey:[NSString stringWithFormat:@"channel%d",(i-15)]]];
            newStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
            if([newStr length]==1)
                lengthStr = [NSString stringWithFormat:@"0%@",newStr];
            else
                lengthStr = [NSString stringWithFormat:@"%@",newStr];
            
            
            //转换类型
            swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
            nResult=strtol(swtr,NULL,16) ;
             [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到数据为%@，转为数值：%d",newStr,nResult]];
            [values addObject:@(nResult>100?100:nResult)];
        }
       

//        [contentSView clearsContextBeforeDrawing];
        [self reloadVoid];
//        [barChartView setValues: values];
//        [okBtn setTitle:@"Stop Play" forState:UIControlStateNormal];
           }
}


-(void)reloadVoid
{
    
//    for(barChartView in [contentSView subviews])
//    {
//        [subv removeFromSuperView];
//    }
    for(UIView *subview in [contentSView subviews]) {
        if([subview isKindOfClass:[JXBarChartView class]]) {
            [subview removeFromSuperview];
        } else {
            // Do nothing - not a UIButton or subclass instance
        }
    }

    
    CGRect frame = CGRectMake(10, 0, Device_Wdith-20, 200);
    
    barChartView = [[JXBarChartView alloc] initWithFrame:frame
                                              startPoint:CGPointMake(20, 20)
                                                  values:values maxValue:10
                                          textIndicators:textIndicators
                                               textColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]
                                               barHeight:30
                                             barMaxWidth:Device_Wdith<321?(Device_Wdith/5*3-50):(Device_Wdith/5*3)
                                                gradient:nil];
    barChartView.tag = 101;
    [contentSView addSubview:barChartView];
}
@end
