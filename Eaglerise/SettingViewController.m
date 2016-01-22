//
//  SettingViewController.m
//  Eaglerise
//
//  Created by Evan on 15/10/30.
//  Copyright © 2015年 Eaglerise. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#define channelOnPeropheralView @"SettingView"
#define FONTSIZE 14
#define HIGHTLBL 30

@interface SettingViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,CBPeripheralManagerDelegate,UIActionSheetDelegate>
{
    float textHeight;
    // Yes 为 on，ON 为off
    BOOL onOrOff;
    NSMutableArray *pickerArray,*pickerArray6;
    NSArray *pickerArray2,*pickerArray3,*pickerArray4,*pickerArray5;
    NSDateFormatter *dateFormatter;
    int CH;
    NSString *  hour;
    NSString * second;
    NSString *  hour2;
    NSString * second2;
    NSString *  hour3;
    NSString * second3;
    NSString *  hour4;
    NSString * second4;
    int WEEK;
    int MODE;
//    bool isPop;
    AppDelegate * mydelegate;
    NSUserDefaults *userdefaults;
    NSMutableDictionary * SettingDic;
    UIActionSheet * actionSheet1,* actionSheet2,* actionSheet3;
    bool loading;
    NSString * loadName;
    int channelIndex;
    NSMutableDictionary* channelDic;
    NSArray *keys;
    NSTimer * timer;
    
    NSTimer * tm;

    UILabel * timeLabel;
    
    NSString * trunOnStr;
    NSString * fristEventStr;
    NSString * secondEventStr;
    NSString * trunOffStr;
    NSInteger modeNumber;
    UILabel * hourLbl;
    UILabel * minLbl;
    UISwitch * fristSwitch;
    UISwitch * secondSwitch;
    //0为未设置，1为设置。如果全为0则清除原有数据。
    NSMutableArray * nightlyArray;
    
    
    NSMutableDictionary * nowDic;
    BOOL ifSendMessage;
    
    UIView * dataView;
    
    
}
@property (nonatomic,strong) UITextField * deviceNameTxt,* channelTxt;
//@property (nonatomic,strong) UIPickerView *PickerView;
//@property (nonatomic,strong) UIPickerView *PickerView2;
@property (nonatomic,strong) UIScrollView * contentSView;
@property (nonatomic,strong) UILabel * SettingsLbl,* FristLbl,* SecondLbl,* ThirdLbl,* FourthLbl,* onLbl;

@property (nonatomic,strong) UIButton * TurnOnBtn,* FirstEventBtn,* SecondEventBtn,* TurnOffBtn,* TurnOnSaveBtn,* FirstEventSaveBtn,* SecondEventSaveBtn,* TurnOffSaveBtn,* ExactlyBtn,* AfterBtn,* SpecificBtn,* changeChannelBtn,* SettingsBtn;
@property (nonatomic,strong) UIView * PopView,* FirstView,* SecondView,* ThirdView,* FourthView;
@property (nonatomic,strong) UIPickerView * FristPicker;//,* SecondPicker,* ThirdPicker
@property (nonatomic,strong) UIDatePicker * FristdatePicker,* SeconddatePicker,* ThirddatePicker;
@property (nonatomic,strong) UISwitch *switchView, *switchView2;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,strong) UISlider * Fristslider,* Secondslider,* Thirdslider;
@property (nonatomic,strong) UIImageView * ivImageV;
@property (nonatomic,strong) UIAlertView *dialog;
@property (nonatomic,retain) NSMutableDictionary *setDic;

@end

@implementation SettingViewController
@synthesize deviceNameTxt,channelTxt;
//@synthesize PickerView2;//PickerView,
@synthesize contentSView;
@synthesize  FristLbl,SecondLbl,ThirdLbl,FourthLbl,onLbl;
@synthesize TurnOnBtn,FirstEventBtn,SecondEventBtn,TurnOffBtn,TurnOnSaveBtn,FirstEventSaveBtn,SecondEventSaveBtn,TurnOffSaveBtn,ExactlyBtn,AfterBtn,SpecificBtn,changeChannelBtn,SettingsBtn;
@synthesize PopView,FirstView,SecondView,ThirdView,FourthView;
@synthesize FristPicker,FristdatePicker,SeconddatePicker,ThirddatePicker;;
@synthesize switchView,switchView2;
@synthesize Fristslider,Secondslider,Thirdslider;
@synthesize ivImageV;
@synthesize setDic;
@synthesize dialog;
-(id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataAction:) name:@"loadSetting" object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceName) name:@"updateDeviceName2" object:nil];
        mydelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        mydelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopReadTime) name:@"readTimeStop" object:nil];
        nowDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self iv];
    [self lc];
//    [self readData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    //设置蓝牙委托
    [self babyDelegate];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)readData{

    NSDate * date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
//    NSInteger year = [dateComponent year];
//    NSInteger month = [dateComponent month];
//    NSInteger day = [dateComponent day];
    NSInteger hour1 = [dateComponent hour];
//    NSInteger minute = [dateComponent minute];
//    NSInteger second = [dateComponent second];
    NSInteger week = [dateComponent weekday];
    
    if(self.currPeripheral != nil &&self.characteristic != nil)
    {
        //    baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
        
        NSInteger value2 = week+1;
        if (week == 6) {
            value2 = 0;
        }
        
        NSDictionary * temp;
        
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%ld",hour1],@"value1",[NSString stringWithFormat:@"%ld",value2],@"value2", nil];
            [self getRequest:5 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(readAction) userInfo:nil repeats:YES];
        
            [timer invalidate];
            timer = nil;
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"7",@"index", nil];
            [self getRequest:2 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        
    }


}

-(void)readAction
{
    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index", nil];
    
    [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
}

#pragma mark --
#pragma mark - 初始化页面元素
/**
 *初始化参数
 */
-(void)iv
{
    
#pragma mark pickerArray更改
//    pickerArray = [[NSMutableArray alloc]initWithObjects:@"channel 1",@"channel 2",@"channel 3",@"channel 4", nil];
    pickerArray = [[NSMutableArray alloc]init];

    
    
    pickerArray2 = [[NSArray alloc]initWithObjects:@"Nightly",@"SUN/MON",@"MON/TUE",@"TUE/WED",@"WED/THU",@"THU/FRI",@"FRI/SAT",@"SAT/SUN",nil];
    
    pickerArray3 = [[NSArray alloc]initWithObjects:@"3",@"4",@"5",@"6",@"7",@"8",nil];
    pickerArray4 = [[NSArray alloc]initWithObjects:@"0",@"15",@"30",@"45",nil];
    pickerArray5 = [[NSArray alloc]initWithObjects:@"0",@"1",@"2",@"3",nil];
    pickerArray6 = [[NSMutableArray alloc]init];
    nightlyArray = [[NSMutableArray alloc]initWithObjects:@"0",@"0",@"0",@"0",nil];
    
    for(int i= 0;i<24;i++)
    {
        [pickerArray6 addObject:[NSString stringWithFormat:@"%d",i]];
    }
    setDic = [[NSMutableDictionary alloc]init];
    if(dateFormatter==nil)
    {
        dateFormatter=[[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"hh:mm aa"];
    userdefaults = [NSUserDefaults standardUserDefaults];
    
    SettingDic = [[NSMutableDictionary alloc]init];
    channelDic = [[NSMutableDictionary alloc]init];
    loading = NO;
#pragma mark 获取SettingDic
    SettingDic = [NSMutableDictionary dictionaryWithDictionary:[userdefaults objectForKey:@"setting"]];
    [self addDefaultDicToSettingDic];
    channelIndex = 1;
    CH = 1;
    WEEK=-1;
    hour = @"3";
    second = @"0";
    hour2 = @"3";
    second2 = @"0";
    hour3 = @"3";
    second3 = @"0";
    hour4 = @"3";
    second4 = @"0";


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
//    contentSView.showsVerticalScrollIndicator = NO;
//    contentSView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:contentSView];
    
    deviceNameTxt=[[UITextField alloc]initWithFrame:CGRectMake(20.0,0.0,Device_Wdith-40, 50)];//创建一个UITextField对象，及设置其位置及大小

    deviceNameTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    
    deviceNameTxt.textAlignment = NSTextAlignmentCenter;
    
    [deviceNameTxt setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    
    deviceNameTxt.leftViewMode=UITextFieldViewModeAlways;
    
    //    deviceNameTxt.placeholder=@"请输入关键字";//默认显示的字
    
    //    deviceNameTxt.secureTextEntry=YES;//设置成密码格式
    
    deviceNameTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    
    deviceNameTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    deviceNameTxt.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    deviceNameTxt.delegate=self;//设置委托
    deviceNameTxt.text = [userdefaults objectForKey:@"DeviceName"]!=nil?[userdefaults objectForKey:@"DeviceName"]:@"Eagleris Lighting 1";
    [contentSView addSubview:deviceNameTxt];
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 49.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    
    channelTxt=[[UITextField alloc]initWithFrame:CGRectMake(30.0,51.5,(Device_Wdith-60)/2, 50)];//创建一个UITextField对象，及设置其位置及大小
    
    channelTxt.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//设置其输入内容竖直居中
    
    channelTxt.textAlignment = NSTextAlignmentLeft;
    
    [channelTxt setClearButtonMode:UITextFieldViewModeWhileEditing];//右侧删除按钮
    
    channelTxt.leftViewMode=UITextFieldViewModeAlways;
    
    //    deviceNameTxt.placeholder=@"请输入关键字";//默认显示的字
    
    //    deviceNameTxt.secureTextEntry=YES;//设置成密码格式
    
    channelTxt.keyboardType=UIKeyboardTypeDefault;//设置键盘类型为默认的
    
    channelTxt.returnKeyType=UIReturnKeyDefault;//返回键的类型
    channelTxt.textColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    channelTxt.delegate=self;//设置委托
    channelTxt.text = [userdefaults objectForKey:@"channel1"]!=nil?[userdefaults objectForKey:@"channel1"]:@"channel 1";
    [contentSView addSubview:channelTxt];
    changeChannelBtn = [[UIButton alloc]initWithFrame:CGRectMake(30.0+(Device_Wdith-60)/2,51.5,(Device_Wdith-60)/2, 50)];
    
    [changeChannelBtn setBackgroundColor:[UIColor clearColor]];
    [changeChannelBtn setImage:[UIImage imageNamed:@"downward"] forState:UIControlStateNormal];
//    [changeChannelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
//    [changeChannelBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    changeChannelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [changeChannelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [changeChannelBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [contentSView addSubview:changeChannelBtn];
//    PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(30, 50, Device_Wdith-60, 120)];
//    //    指定Delegate
//    PickerView.delegate=self;
//    //    显示选中框
//    PickerView.showsSelectionIndicator=YES;
//    [contentSView addSubview:PickerView];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 101.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    UIButton * LoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 103, (Device_Wdith-60)/2, 40)];
    
    [LoadBtn setBackgroundColor:[UIColor clearColor]];
    [LoadBtn setTitle:@" Load Preset" forState:UIControlStateNormal];
    [LoadBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    LoadBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [LoadBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [LoadBtn addTarget:self action:@selector(LoadAction) forControlEvents:UIControlEventTouchUpInside];
    [contentSView addSubview:LoadBtn];
    
    UIButton * SaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/2, 103, (Device_Wdith-60)/2-10, 40)];
    
    [SaveBtn setBackgroundColor:[UIColor clearColor]];
    [SaveBtn setTitle:@"Save As Preset" forState:UIControlStateNormal];
    [SaveBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    SaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [SaveBtn addTarget:self action:@selector(SaveAction) forControlEvents:UIControlEventTouchUpInside];
    [SaveBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [contentSView addSubview:SaveBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 143, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 144.5, Device_Wdith-160, 40)];
    Lbl.text = @"Output Voltage";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-150, 151.5, 40, 30)];
    Lbl.text = @"12V";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    switchView = [[UISwitch alloc] initWithFrame:CGRectMake(Device_Wdith-115, 151.5, 80.0f, 28.0f)];
    
    
    switchView.on = YES;//设置初始为ON的一边
    switchView.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [contentSView addSubview:switchView];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, 151.5, 30, 30)];
    Lbl.text = @"15V";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 184.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 183, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Theses Settings for";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    Lbl.adjustsFontSizeToFitWidth = YES;
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
//    SettingsBtn = [[UILabel alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/2, 183, (Device_Wdith-60)/2, 40)];
//    SettingsLbl.text = @"Nightly";
//    SettingsLbl.backgroundColor = [UIColor clearColor];
//    [SettingsLbl setTextAlignment:NSTextAlignmentRight];
//    [SettingsLbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
//    [SettingsLbl setFont:[UIFont boldSystemFontOfSize:17]];
//    [contentSView addSubview:SettingsLbl];
    SettingsBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 183, (Device_Wdith-60), 40)];
    
    [SettingsBtn setBackgroundColor:[UIColor clearColor]];
    [SettingsBtn setTitle:@"Nightly" forState:UIControlStateNormal];
    [SettingsBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [SettingsBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [SettingsBtn setImage:[UIImage imageNamed:@"downward"] forState:UIControlStateNormal];
    [SettingsBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (Device_Wdith-90), 0, 0)];
    SettingsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [SettingsBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [SettingsBtn addTarget:self action:@selector(changeAction2) forControlEvents:UIControlEventTouchUpInside];
    [contentSView addSubview:SettingsBtn];

    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 223, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
//    PickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(30, 293, Device_Wdith-60, 120)];
//    //    指定Delegate
//    PickerView2.delegate=self;
//    //    显示选中框
//    PickerView2.showsSelectionIndicator=YES;
//    [contentSView addSubview:PickerView2];
    
//    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 413, Device_Wdith-60, 1.5)];
//    
//    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
//    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 224.5, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Turn on";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    TurnOnBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 224.5, (Device_Wdith-60), 40)];
    
    [TurnOnBtn setBackgroundColor:[UIColor clearColor]];
    [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
    [TurnOnBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    TurnOnBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [TurnOnBtn addTarget:self action:@selector(TurnOnAction) forControlEvents:UIControlEventTouchUpInside];
    [TurnOnBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:TurnOnBtn];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 264.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 266, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"First Event";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    FirstEventBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 266, (Device_Wdith-60), 40)];
    
    [FirstEventBtn setBackgroundColor:[UIColor clearColor]];
    [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
    [FirstEventBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    FirstEventBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [FirstEventBtn addTarget:self action:@selector(FirstEventAction) forControlEvents:UIControlEventTouchUpInside];
    [FirstEventBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:FirstEventBtn];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 306, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 307.5, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Second Event";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    SecondEventBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 307.5, (Device_Wdith-60), 40)];
    
    [SecondEventBtn setBackgroundColor:[UIColor clearColor]];
    [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
    [SecondEventBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    SecondEventBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [SecondEventBtn addTarget:self action:@selector(SecondEventAction) forControlEvents:UIControlEventTouchUpInside];
    [SecondEventBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:SecondEventBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 347.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 349, (Device_Wdith-60)/2, 40)];
    Lbl.text = @"Turn Off";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    TurnOffBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 349, Device_Wdith-60, 40)];
    
    [TurnOffBtn setBackgroundColor:[UIColor clearColor]];
    [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
    [TurnOffBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    TurnOffBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [TurnOffBtn addTarget:self action:@selector(TurnOffAction) forControlEvents:UIControlEventTouchUpInside];
    [TurnOffBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [contentSView addSubview:TurnOffBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 389, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 390.5, Device_Wdith-160, 40)];
    Lbl.text = @"Use DST";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-150, 397.5, 40, 30)];
    Lbl.text = @"OFF";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    switchView2 = [[UISwitch alloc] initWithFrame:CGRectMake(Device_Wdith-115, 397.5, 80.0f, 28.0f)];
    
    
    switchView2.on = YES;//设置初始为ON的一边
    switchView2.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [switchView2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [contentSView addSubview:switchView2];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-60, 397.5, 30, 30)];
    Lbl.text = @"ON";
    Lbl.backgroundColor = [UIColor clearColor];
    [Lbl setTextAlignment:NSTextAlignmentLeft];
    [Lbl setTextColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f]];
    [Lbl setFont:[UIFont boldSystemFontOfSize:16]];
    [contentSView addSubview:Lbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 438, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];

    
    UILabel * Label = [[UILabel alloc] initWithFrame:CGRectMake(10, 440, 80, 100)];
    Label.text = @"DeviceTime:";
    Label.textColor = [UIColor blackColor];
    Label.font = [UIFont systemFontOfSize:14];
    [contentSView addSubview:Label];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 440, Device_Wdith - 140, 40)];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    Label.center = CGPointMake(70, timeLabel.center.y);
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [contentSView addSubview:timeLabel];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 480, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [contentSView addSubview:Lbl];

#pragma mark 字体设置
    TurnOnBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    TurnOffBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    FirstEventBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    SecondEventBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    contentSView.contentSize = CGSizeMake(Device_Wdith, 485);
    
    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
//    //隐藏键盘
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
////    tapGr.cancelsTouchesInView = NO;
//
//    [self.view addGestureRecognizer:tapGr];
    
    [self roadPopView];
#pragma mark channelDic初始化
    channelDic.dictionary = [userdefaults objectForKey:@"settinglast"];
    if (channelDic != nil) {
#pragma mark setDic 初始化数据 xiugai
//        setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
//        loadName = [userdefaults objectForKey:@"loadName"];
        
        
        
//        [self loadMessage:setDic];
    }else
    {
        channelDic = [[NSMutableDictionary alloc]init];
    }
//    NSLog(@"channelDic==%@    setDic ==%@ settingDic==%@",channelDic,setDic,SettingDic);

}

-(void)roadPopView
{
    PopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, CGRectGetHeight(self.view.frame))];
    [PopView setBackgroundColor:[UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:0.3f]];
    //    [PopView setAlpha:0.2];
    [self.view addSubview:PopView];
    
//    //添加点击触摸手势
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
////    tapGr.cancelsTouchesInView = NO;
//    [PopView addGestureRecognizer:tapGr];
  /*
    FirstView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-459 , Device_Wdith, 400)];
    [FirstView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
//    FirstView.center = PopView.center;
    [PopView addSubview:FirstView];
    
    onLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Device_Wdith, 60)];
    onLbl.text = @"Turn on";
    onLbl.font = [UIFont boldSystemFontOfSize:16];
    onLbl.backgroundColor = [UIColor clearColor];
    onLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    onLbl.textAlignment = NSTextAlignmentCenter;
    
    [FirstView addSubview:onLbl];
    
    
    
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    ExactlyBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 61.5, Device_Wdith-120, 40)];
    [ExactlyBtn setTitle:@"Exactly at Sunset" forState:UIControlStateNormal];
    [ExactlyBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [ExactlyBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    ExactlyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    ExactlyBtn.backgroundColor = [UIColor clearColor];

    ExactlyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ExactlyBtn addTarget:self action:@selector(ExactlyAction:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:ExactlyBtn];
    
    ivImageV = [[UIImageView alloc]initWithFrame:CGRectMake(Device_Wdith-66, 69.5, 32, 20)];
    ivImageV.image = [UIImage imageNamed:@"duihao"];
    
    [FirstView addSubview:ivImageV];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 101.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    AfterBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 103, Device_Wdith-120, 40)];
    [AfterBtn setTitle:@"After Sunset" forState:UIControlStateNormal];
    [AfterBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [AfterBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    AfterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    AfterBtn.backgroundColor = [UIColor clearColor];
    
    AfterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [AfterBtn addTarget:self action:@selector(AfterAction:) forControlEvents:UIControlEventTouchUpInside];    [FirstView addSubview:AfterBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 143, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    SpecificBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 144.5, Device_Wdith-120, 40)];
    [SpecificBtn setTitle:@"Specific Time" forState:UIControlStateNormal];
    [SpecificBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [SpecificBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    SpecificBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    SpecificBtn.backgroundColor = [UIColor clearColor];
    
    SpecificBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [SpecificBtn addTarget:self action:@selector(SpecificAction:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:SpecificBtn];


    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 184.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    
    FristdatePicker  = [[UIDatePicker alloc]init];
    FristdatePicker.frame=CGRectMake(30, 186, Device_Wdith-60, 90);
    FristdatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    FristdatePicker.date = [NSDate date];
    FristdatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [FirstView addSubview:FristdatePicker];
    
    hourLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    hourLbl.text = @"hour";
    [hourLbl setTextAlignment:NSTextAlignmentCenter];
    hourLbl.hidden = YES;
    hourLbl.center = FristdatePicker.center;
    [FirstView addSubview:hourLbl];
    
    minLbl = [[UILabel alloc] initWithFrame:CGRectMake(Device_Wdith - 80,hourLbl.frame.origin.y, 40, 40)];
    minLbl.text = @"min";
    minLbl.hidden = YES;
    [hourLbl setTextAlignment:NSTextAlignmentRight];
    [FirstView addSubview:minLbl];

    
    
    
    
    FristPicker = [[UIPickerView alloc]init];
    FristPicker.frame= CGRectMake(30, 186, Device_Wdith-60, 90);
    FristPicker.delegate = self;
    FristPicker.dataSource = self;
    FristPicker.showsSelectionIndicator = YES;
    [FirstView addSubview:FristPicker];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 276, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
//    [FirstView addSubview:Lbl];
    
    Fristslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 288.5, Device_Wdith-120, 20)];
    Fristslider.minimumValue = 0;
    Fristslider.maximumValue = 100;
    Fristslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Fristslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Fristslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Fristslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Fristslider addTarget:self action:@selector(FirstValue:) forControlEvents:UIControlEventValueChanged];
    
    [FirstView addSubview:Fristslider];
    
    
    FristLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-70, 278.5, 80, 40)];
    FristLbl.text = @"0%";
    FristLbl.font = [UIFont boldSystemFontOfSize:16];
    FristLbl.backgroundColor = [UIColor clearColor];
    FristLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    FristLbl.textAlignment = NSTextAlignmentLeft;
    
    [FirstView addSubview:FristLbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 318.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
//    [FirstView addSubview:Lbl];
    
    TurnOnSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 330, (Device_Wdith-60)/2, 40)];
    
    [TurnOnSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [TurnOnSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [TurnOnSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    TurnOnSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [TurnOnSaveBtn addTarget:self action:@selector(TurnOnSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [TurnOnSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [FirstView addSubview:TurnOnSaveBtn];
    
    
    SecondView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-459, Device_Wdith, 440)];
    [SecondView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
//    SecondView.center = PopView.center;
    [PopView addSubview:SecondView];
    
    CGFloat pointX = (Device_Wdith)/2.0f;
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake((Device_Wdith - pointX) / 2.0f, 0, pointX, 60)];
    Lbl.text = @"Frist Event";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;
    
    [SecondView addSubview:Lbl];
    
#pragma mark 添加按钮1
    
    UILabel * offLbl = [[UILabel alloc] initWithFrame:CGRectMake(pointX -30, 0, 40, 60)];
    offLbl.text = @"off";
    offLbl.font = [UIFont boldSystemFontOfSize:16];
    offLbl.backgroundColor = [UIColor clearColor];
    offLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    offLbl.textAlignment = NSTextAlignmentCenter;
    [SecondView addSubview:offLbl];
    
    fristSwitch  = [[UISwitch alloc] initWithFrame:CGRectMake(pointX + 10, 10, 60, 60)];
    fristSwitch.on = YES;
    fristSwitch.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [fristSwitch addTarget:self action:@selector(fristSwitchHide) forControlEvents:UIControlEventValueChanged];
    [SecondView addSubview:fristSwitch];
    
    UILabel * onLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(pointX + 70, 0, 40, 60)];
    onLbl2.text = @"on";
    onLbl2.font = [UIFont boldSystemFontOfSize:16];
    onLbl2.backgroundColor = [UIColor clearColor];
    onLbl2.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    onLbl.textAlignment = NSTextAlignmentCenter;
    [SecondView addSubview:onLbl2];

    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 61.5 + 40, Device_Wdith-120, 40)];
    Lbl.text = @"Starting time";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentLeft;
    
    [SecondView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 98.5 + 40, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [SecondView addSubview:Lbl];
    
    SeconddatePicker  = [[UIDatePicker alloc]init];
    SeconddatePicker.frame=CGRectMake(30, 120 + 40, Device_Wdith-60, 90);
    SeconddatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    SeconddatePicker.date = [NSDate date];
    SeconddatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [SecondView addSubview:SeconddatePicker];
    
//    SecondPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(30, 120, Device_Wdith-60, 90)];
//    SecondPicker.delegate = self;
//    SecondPicker.dataSource = self;
//    SecondPicker.showsSelectionIndicator = YES;
//    [SecondView addSubview:SecondPicker];

 
    //-----------
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 210 + 40, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
//    [SecondView addSubview:Lbl];
    
    
    Secondslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 275.5 + 40, Device_Wdith-80, 20)];
    Secondslider.minimumValue = 0;
    Secondslider.maximumValue = 100;
    Secondslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Secondslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Secondslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Secondslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Secondslider addTarget:self action:@selector(SecondValue:) forControlEvents:UIControlEventValueChanged];
    
    [SecondView addSubview:Secondslider];
    
    
    SecondLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-110, 235.5 + 40, 80, 40)];
    SecondLbl.text = @"0%";
    SecondLbl.font = [UIFont boldSystemFontOfSize:16];
    SecondLbl.backgroundColor = [UIColor clearColor];
    SecondLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    SecondLbl.textAlignment = NSTextAlignmentLeft;
    
    [SecondView addSubview:SecondLbl];
    //------------
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 300 + 40, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [SecondView addSubview:Lbl];
    
    
    FirstEventSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 310.5 + 40, (Device_Wdith-60)/2, 40)];
    
    [FirstEventSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [FirstEventSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [FirstEventSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    FirstEventSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [FirstEventSaveBtn addTarget:self action:@selector(FirstEventSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [FirstEventSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [SecondView addSubview:FirstEventSaveBtn];
    
    
    
    
    //==============
    ThirdView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-459, Device_Wdith, 400)];
    [ThirdView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
//    ThirdView.center = PopView.center;
    [PopView addSubview:ThirdView];
#pragma mark 添加按钮2
    
    UILabel * offLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(pointX -30, 0, 40, 60)];
    offLbl2.text = @"off";
    offLbl2.font = [UIFont boldSystemFontOfSize:16];
    offLbl2.backgroundColor = [UIColor clearColor];
    offLbl2.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    offLbl2.textAlignment = NSTextAlignmentCenter;
    [ThirdView addSubview:offLbl2];
    
    secondSwitch  = [[UISwitch alloc] initWithFrame:CGRectMake(pointX + 10, 10, 60, 60)];
    secondSwitch.on = YES;
    secondSwitch.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [secondSwitch addTarget:self action:@selector(secondSwitchHide) forControlEvents:UIControlEventValueChanged];
    [ThirdView addSubview:secondSwitch];
    
    UILabel * onLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(pointX + 70, 0, 40, 60)];
    onLbl3.text = @"on";
    onLbl3.font = [UIFont boldSystemFontOfSize:16];
    onLbl3.backgroundColor = [UIColor clearColor];
    onLbl3.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    onLbl.textAlignment = NSTextAlignmentCenter;
    [ThirdView addSubview:onLbl3];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pointX, 60)];
    Lbl.text = @"Second Event";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;
    
    [ThirdView addSubview:Lbl];
    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 61.5 + 40, Device_Wdith-120, 40)];
    Lbl.text = @"Starting time";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentLeft;
    
    [ThirdView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 98.5 + 40, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [ThirdView addSubview:Lbl];
    
    ThirddatePicker  = [[UIDatePicker alloc]init];
    ThirddatePicker.frame=CGRectMake(30, 100 + 40, Device_Wdith-60, 90);
    ThirddatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    ThirddatePicker.date = [NSDate date];
    ThirddatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [ThirdView addSubview:ThirddatePicker];
    
//    ThirdPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(30, 100, Device_Wdith-60, 90)];
//    ThirdPicker.delegate = self;
//    ThirdPicker.dataSource = self;
//    ThirdPicker.showsSelectionIndicator = YES;
//    [ThirdView addSubview:ThirdPicker];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 210 + 40, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
//    [ThirdView addSubview:Lbl];
    
    //---
    Thirdslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 275.5 + 40, Device_Wdith-80, 20)];
    Thirdslider.minimumValue = 0;
    Thirdslider.maximumValue = 100;
    Thirdslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Thirdslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Thirdslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Thirdslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Thirdslider addTarget:self action:@selector(ThirdValue:) forControlEvents:UIControlEventValueChanged];
    
    [ThirdView addSubview:Thirdslider];
    
    
    ThirdLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-110, 235.5 + 40, 80, 40)];
    ThirdLbl.text = @"0%";
    ThirdLbl.font = [UIFont boldSystemFontOfSize:16];
    ThirdLbl.backgroundColor = [UIColor clearColor];
    ThirdLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    ThirdLbl.textAlignment = NSTextAlignmentLeft;
    
    [ThirdView addSubview:ThirdLbl];

    //--/
    
   
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 300 + 40, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [ThirdView addSubview:Lbl];
    
    
    SecondEventSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 310.5, (Device_Wdith-60)/2, 40)];
    
    [SecondEventSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [SecondEventSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [SecondEventSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    SecondEventSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [SecondEventSaveBtn addTarget:self action:@selector(SecondEventSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [SecondEventSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [ThirdView addSubview:SecondEventSaveBtn];
    */
    
    
    FirstView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-459 , Device_Wdith, 400)];
    [FirstView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
    //    FirstView.center = PopView.center;
    [PopView addSubview:FirstView];
    CGFloat pointX = (Device_Wdith)/2.0f;
    
    onLbl = [[UILabel alloc]initWithFrame:CGRectMake( pointX/2.0f, 10,pointX, HIGHTLBL)];
    onLbl.text = @"Turn on";
    onLbl.font = [UIFont boldSystemFontOfSize:16];
    onLbl.backgroundColor = [UIColor clearColor];
    onLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    onLbl.textAlignment = NSTextAlignmentCenter;
    
    [FirstView addSubview:onLbl];
    
    
    
    UILabel * Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    ExactlyBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 61.5, Device_Wdith-120, 40)];
    [ExactlyBtn setTitle:@"Exactly at Sunset" forState:UIControlStateNormal];
    [ExactlyBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [ExactlyBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    ExactlyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    ExactlyBtn.backgroundColor = [UIColor clearColor];
    
    ExactlyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [ExactlyBtn addTarget:self action:@selector(ExactlyAction:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:ExactlyBtn];
    
    ivImageV = [[UIImageView alloc]initWithFrame:CGRectMake(Device_Wdith-66, 69.5, 32, 20)];
    ivImageV.image = [UIImage imageNamed:@"duihao"];
    
    [FirstView addSubview:ivImageV];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 101.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    AfterBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 103, Device_Wdith-120, 40)];
    [AfterBtn setTitle:@"After Sunset" forState:UIControlStateNormal];
    [AfterBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [AfterBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    AfterBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    AfterBtn.backgroundColor = [UIColor clearColor];
    
    AfterBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [AfterBtn addTarget:self action:@selector(AfterAction:) forControlEvents:UIControlEventTouchUpInside];    [FirstView addSubview:AfterBtn];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 143, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    SpecificBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 144.5, Device_Wdith-120, 40)];
    [SpecificBtn setTitle:@"Specific Time" forState:UIControlStateNormal];
    [SpecificBtn setTitleColor:[UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [SpecificBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateSelected];
    
    SpecificBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    SpecificBtn.backgroundColor = [UIColor clearColor];
    
    SpecificBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [SpecificBtn addTarget:self action:@selector(SpecificAction:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:SpecificBtn];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 184.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [FirstView addSubview:Lbl];
    
    
    FristdatePicker  = [[UIDatePicker alloc]init];
    FristdatePicker.frame=CGRectMake(30, 186, Device_Wdith-60, 90);
    FristdatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    FristdatePicker.date = [NSDate date];
    FristdatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [FirstView addSubview:FristdatePicker];
    
    hourLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    hourLbl.text = @"hour";
    [hourLbl setTextAlignment:NSTextAlignmentCenter];
    hourLbl.hidden = YES;
    hourLbl.center = FristdatePicker.center;
    [FirstView addSubview:hourLbl];
    
    minLbl = [[UILabel alloc] initWithFrame:CGRectMake(Device_Wdith - 80,hourLbl.frame.origin.y, 40, 40)];
    minLbl.text = @"min";
    minLbl.hidden = YES;
    [hourLbl setTextAlignment:NSTextAlignmentRight];
    [FirstView addSubview:minLbl];
    
    
    
    
    
    FristPicker = [[UIPickerView alloc]init];
    FristPicker.frame= CGRectMake(30, 186, Device_Wdith-60, 90);
    FristPicker.delegate = self;
    FristPicker.dataSource = self;
    FristPicker.showsSelectionIndicator = YES;
    [FirstView addSubview:FristPicker];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 276, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    //    [FirstView addSubview:Lbl];
    
    Fristslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 288.5, Device_Wdith-120, 20)];
    Fristslider.minimumValue = 0;
    Fristslider.maximumValue = 100;
    Fristslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Fristslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Fristslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Fristslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Fristslider addTarget:self action:@selector(FirstValue:) forControlEvents:UIControlEventValueChanged];
    
    [FirstView addSubview:Fristslider];
    
    
    FristLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-70, 278.5, 80, 40)];
    FristLbl.text = @"0%";
    FristLbl.font = [UIFont boldSystemFontOfSize:16];
    FristLbl.backgroundColor = [UIColor clearColor];
    FristLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    FristLbl.textAlignment = NSTextAlignmentLeft;
    
    [FirstView addSubview:FristLbl];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 318.5, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    //    [FirstView addSubview:Lbl];
    
    TurnOnSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 330, (Device_Wdith-60)/2, 40)];
    
    [TurnOnSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [TurnOnSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [TurnOnSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    TurnOnSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [TurnOnSaveBtn addTarget:self action:@selector(TurnOnSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [TurnOnSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [FirstView addSubview:TurnOnSaveBtn];
    
    
    SecondView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-459, Device_Wdith, 440)];
    [SecondView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
    //    SecondView.center = PopView.center;
    [PopView addSubview:SecondView];
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake((Device_Wdith - pointX) / 2.0f, 0, pointX, HIGHTLBL)];
    Lbl.text = @"Frist Event";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;
    
    [SecondView addSubview:Lbl];
    
#pragma mark 添加按钮1
    
    UILabel * offLbl = [[UILabel alloc] initWithFrame:CGRectMake(pointX -110, 40, 80, HIGHTLBL)];
    offLbl.text = @"Disable";
    offLbl.font = [UIFont boldSystemFontOfSize:16];
    offLbl.backgroundColor = [UIColor clearColor];
    offLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    offLbl.textAlignment = NSTextAlignmentRight;
    [SecondView addSubview:offLbl];
    
    fristSwitch  = [[UISwitch alloc] initWithFrame:CGRectMake(pointX - 30, 40, 60, HIGHTLBL)];
    fristSwitch.on = YES;
    fristSwitch.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [fristSwitch addTarget:self action:@selector(fristSwitchHide) forControlEvents:UIControlEventValueChanged];
    [SecondView addSubview:fristSwitch];
    
    UILabel * onLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(pointX + 30, 40, 80, HIGHTLBL)];
    onLbl2.text = @"Enable";
    onLbl2.font = [UIFont boldSystemFontOfSize:16];
    onLbl2.backgroundColor = [UIColor clearColor];
    onLbl2.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    onLbl2.textAlignment = NSTextAlignmentLeft;
    [SecondView addSubview:onLbl2];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, HIGHTLBL + 40, Device_Wdith-120, 40)];
    Lbl.text = @"Starting time";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentLeft;
    
    [SecondView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, HIGHTLBL + 80, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [SecondView addSubview:Lbl];
    
    SeconddatePicker  = [[UIDatePicker alloc]init];
    SeconddatePicker.frame=CGRectMake(30, HIGHTLBL + 85, Device_Wdith-60, 90);
    SeconddatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    SeconddatePicker.date = [NSDate date];
    SeconddatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [SecondView addSubview:SeconddatePicker];
    
    //    SecondPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(30, 120, Device_Wdith-60, 90)];
    //    SecondPicker.delegate = self;
    //    SecondPicker.dataSource = self;
    //    SecondPicker.showsSelectionIndicator = YES;
    //    [SecondView addSubview:SecondPicker];
    
    
    //-----------
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 210 + 40, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    //    [SecondView addSubview:Lbl];
    
    
    Secondslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 265 + HIGHTLBL, Device_Wdith-80, 20)];
    Secondslider.minimumValue = 0;
    Secondslider.maximumValue = 100;
    Secondslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Secondslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Secondslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Secondslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Secondslider addTarget:self action:@selector(SecondValue:) forControlEvents:UIControlEventValueChanged];
    
    [SecondView addSubview:Secondslider];
    
    
    SecondLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-110, 225 + HIGHTLBL, 80, 40)];
    SecondLbl.text = @"0%";
    SecondLbl.font = [UIFont boldSystemFontOfSize:16];
    SecondLbl.backgroundColor = [UIColor clearColor];
    SecondLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    SecondLbl.textAlignment = NSTextAlignmentLeft;
    
    [SecondView addSubview:SecondLbl];
    //------------
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 290 + HIGHTLBL, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [SecondView addSubview:Lbl];
    
    
    FirstEventSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 300 + HIGHTLBL, (Device_Wdith-60)/2, 40)];
    
    [FirstEventSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [FirstEventSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [FirstEventSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    FirstEventSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [FirstEventSaveBtn addTarget:self action:@selector(FirstEventSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [FirstEventSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [SecondView addSubview:FirstEventSaveBtn];
    
    
    
    
    //==============
    ThirdView = [[UIView alloc]initWithFrame:CGRectMake(0, Device_Height-459, Device_Wdith, 440)];
    [ThirdView setBackgroundColor:[UIColor whiteColor]];
    //    [PopView setAlpha:0.2];
    //    ThirdView.center = PopView.center;
    [PopView addSubview:ThirdView];
#pragma mark 添加按钮2
    
    UILabel * offLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(pointX -110, 40, 80, HIGHTLBL)];
    offLbl2.text = @"Disabel";
    offLbl2.font = [UIFont boldSystemFontOfSize:16];
    offLbl2.backgroundColor = [UIColor clearColor];
    offLbl2.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    offLbl2.textAlignment = NSTextAlignmentRight;
    [ThirdView addSubview:offLbl2];
    
    secondSwitch  = [[UISwitch alloc] initWithFrame:CGRectMake(pointX - 30, 40, 60, HIGHTLBL)];
    secondSwitch.on = YES;
    secondSwitch.onTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [secondSwitch addTarget:self action:@selector(secondSwitchHide) forControlEvents:UIControlEventValueChanged];
    [ThirdView addSubview:secondSwitch];
    
    UILabel * onLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(pointX + 30, 40, 80, HIGHTLBL)];
    onLbl3.text = @"Enable";
    onLbl3.font = [UIFont boldSystemFontOfSize:16];
    onLbl3.backgroundColor = [UIColor clearColor];
    onLbl3.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    onLbl3.textAlignment = NSTextAlignmentLeft;
    [ThirdView addSubview:onLbl3];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake((Device_Wdith - pointX) / 2.0f, 0, pointX, HIGHTLBL)];
    Lbl.text = @"Second Event";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentCenter;
    
    [ThirdView addSubview:Lbl];
    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, HIGHTLBL + 40, Device_Wdith-120, 40)];
    Lbl.text = @"Starting time";
    Lbl.font = [UIFont boldSystemFontOfSize:16];
    Lbl.backgroundColor = [UIColor clearColor];
    Lbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    Lbl.textAlignment = NSTextAlignmentLeft;
    
    [ThirdView addSubview:Lbl];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, HIGHTLBL + 80, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    [ThirdView addSubview:Lbl];
    
    ThirddatePicker  = [[UIDatePicker alloc]init];
    ThirddatePicker.frame=CGRectMake(30, HIGHTLBL + 85, Device_Wdith-60, 90);
    ThirddatePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"EN"];
    //[NSDate date]获取当前的时间，并把这个时间数据作为这个datePicker控件的初始化值
    //当然也可以使用自己定义的时间值，不过要用 NSDateFormatter 来进行设计 时间格式，进行转换成date类型
    ThirddatePicker.date = [NSDate date];
    ThirddatePicker.datePickerMode = UIDatePickerModeTime;
    //把这个控件添加到view中
    [ThirdView addSubview:ThirddatePicker];
    
    //    ThirdPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(30, 100, Device_Wdith-60, 90)];
    //    ThirdPicker.delegate = self;
    //    ThirdPicker.dataSource = self;
    //    ThirdPicker.showsSelectionIndicator = YES;
    //    [ThirdView addSubview:ThirdPicker];
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 2*HIGHTLBL + 220, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)204/255.0 green:(float)204/255.0 blue:(float)204/255.0 alpha:1.0f];
    //    [ThirdView addSubview:Lbl];
    
    //---
    Thirdslider = [[UISlider alloc] initWithFrame:CGRectMake(40, 265 + HIGHTLBL, Device_Wdith-80, 20)];
    Thirdslider.minimumValue = 0;
    Thirdslider.maximumValue = 100;
    Thirdslider.minimumTrackTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Thirdslider.thumbTintColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    Thirdslider.maximumTrackTintColor = [UIColor colorWithRed:(float)202/255.0 green:(float)202/255.0 blue:(float)202/255.0 alpha:1.0f];
    Thirdslider.value = 0;
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateNormal];
    //        [slider setThumbImage:[UIImage imageNamed:@"DeviceSel"] forState:UIControlStateHighlighted];
    [Thirdslider addTarget:self action:@selector(ThirdValue:) forControlEvents:UIControlEventValueChanged];
    
    [ThirdView addSubview:Thirdslider];
    
    
    ThirdLbl = [[UILabel alloc]initWithFrame:CGRectMake(Device_Wdith-110, 225 + HIGHTLBL, 80, 40)];
    ThirdLbl.text = @"0%";
    ThirdLbl.font = [UIFont boldSystemFontOfSize:16];
    ThirdLbl.backgroundColor = [UIColor clearColor];
    ThirdLbl.textColor = [UIColor colorWithRed:(float)135/255.0 green:(float)135/255.0 blue:(float)135/255.0 alpha:1.0f];
    ThirdLbl.textAlignment = NSTextAlignmentLeft;
    
    [ThirdView addSubview:ThirdLbl];
    
    //--/
    
    
    
    Lbl = [[UILabel alloc]initWithFrame:CGRectMake(30, 290 + HIGHTLBL, Device_Wdith-60, 1.5)];
    
    Lbl.backgroundColor = [UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f];
    [ThirdView addSubview:Lbl];
    
    
    SecondEventSaveBtn = [[UIButton alloc]initWithFrame:CGRectMake(30+(Device_Wdith-60)/4, 300 + HIGHTLBL, (Device_Wdith-60)/2, 40)];
    
    [SecondEventSaveBtn setBackgroundColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
    [SecondEventSaveBtn setTitle:@"OK" forState:UIControlStateNormal];
    [SecondEventSaveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    SecondEventSaveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [SecondEventSaveBtn addTarget:self action:@selector(SecondEventSaveAction) forControlEvents:UIControlEventTouchUpInside];
    [SecondEventSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [ThirdView addSubview:SecondEventSaveBtn];

    
    UIButton * closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith-40, 0, 40, 40)];
    
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:closeBtn];
    closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith-40, 0, 40, 40)];
    
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [SecondView addSubview:closeBtn];
    closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(Device_Wdith-40, 0, 40, 40)];
    
    [closeBtn setBackgroundColor:[UIColor clearColor]];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f] forState:UIControlStateNormal];
    //    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [ThirdView addSubview:closeBtn];
    PopView.hidden = YES;
    FirstView.hidden = YES;
    SecondView.hidden = YES;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
    FristPicker.hidden = YES;
    FristdatePicker.hidden = YES;
    
    
}
//更新timeLaber时间

- (void)reloadDeviceTime{

    NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",9],@"index", nil];
    
    [self readRequest:2 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
    
}


#pragma mark-
#pragma mark--页面信息处理

/**
 *  获取输入框的Y坐标
 *
 *  @param textField <#textField description#>
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == deviceNameTxt) {
//        isPop = NO;
        textHeight=deviceNameTxt.frame.origin.y + CGRectGetHeight(deviceNameTxt.frame);
    }
        if (textField == channelTxt) {
            textHeight=channelTxt.frame.origin.y + CGRectGetHeight(channelTxt.frame);
        }
    
    
}
-(void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    
    CGPoint keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin;
    //自适应代码（输入法改变也可随之改变）
    if(keyboardSize.y<textHeight)
    {
        
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0.0f, -(textHeight-keyboardSize.y), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    
}
-(void)keyboardWillHide:(NSNotification *)note
{
    
    //    NSDictionary *info = [note userInfo];
    //    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //
    //    if((Device_Height-keyboardSize.height-48)<textHeight)
    //    {
    //还原
    [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(Device_Wdith*2, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    //    }
    
}
/**
 *	@brief	设置隐藏键盘
 *
 */
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    //    if (theTextField == self.remarksTxt) {
    //        [theTextField resignFirstResponder];
    //    }
    
#pragma mark 修改设备名称和通道名称
    if (theTextField == deviceNameTxt) {
        [theTextField resignFirstResponder];
        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:deviceNameTxt.text,@"NameStr",  nil];
        [self getRequest:9 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];
        [self getRequest:11 requestDic:temp characteristic:mydelegate.Characteristic1914 currPeripheral:self.currPeripheral delegate:self];
        NSDictionary * temp2 = @{@"NameStr":@"123"};
        [self getRequest:12 requestDic:temp2 characteristic:mydelegate.Characteristic1914 currPeripheral:self.currPeripheral delegate:self];

        [self getRequest:13 requestDic:nil characteristic:mydelegate.Characteristic1914 currPeripheral:self.currPeripheral delegate:self];

        
        [userdefaults setObject:deviceNameTxt.text forKey:@"DeviceName"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDeviceName" object:nil];

    }
    if (theTextField == channelTxt) {
        [theTextField resignFirstResponder];

        [pickerArray replaceObjectAtIndex:(channelIndex-1) withObject:channelTxt.text];
        [userdefaults setObject:channelTxt.text forKey:[NSString stringWithFormat:@"channel%d",channelIndex ]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadControlTable" object:self userInfo:nil];

        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:channelTxt.text,@"NameStr",[NSString stringWithFormat:@"%d",(channelIndex-1)],@"value",  nil];
        
        [self getRequest:10 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];

        
    }
    return YES;
    
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}
//-(void)viewTapped:(UITapGestureRecognizer*)tapGr
//{
////    NSLog(@"%@",tapGr.view);
////    if (isPop == YES) {
////         PopView.hidden = YES;
////    }
////    else
////    {
//    [deviceNameTxt resignFirstResponder];
//        [channelTxt resignFirstResponder];
////    }
//    //    [self.mobelTxt resignFirstResponder];
//   
//}

//babyDelegate
-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
//        for (CBService *s in peripheral.services) {
            ///插入section到tableview
            //            [weakSelf insertSectionToTableView:s];
//        }
        
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

-(void)loadDataAction:(NSNotification *)notification
{
    self.currPeripheral = mydelegate.currPeripheral;
    self->baby  = mydelegate.baby;
    self.characteristic = [mydelegate.characteristics objectAtIndex:1];
    
    
//    [self creatUIAview];
    
    if(pickerArray.count>0)
    {
        [pickerArray removeAllObjects];
    }
    
    for(int i = 0;i <mydelegate.channelNum ;i++)
    {
        [pickerArray addObject:[NSString stringWithFormat:@"channel %d",(i+1)]];
    }
    if ([userdefaults objectForKey:@"channel1"]!=nil) {
        if(pickerArray.count>0)
        {
            [pickerArray replaceObjectAtIndex:0 withObject:[userdefaults objectForKey:@"channel1"]];
        }
        else
        {
            [pickerArray addObject:[userdefaults objectForKey:@"channel1"]];
        }
    }
    if ([userdefaults objectForKey:@"channel2"]!=nil) {
        if(pickerArray.count>1)
        {
            [pickerArray replaceObjectAtIndex:1 withObject:[userdefaults objectForKey:@"channel2"]];
        }
        else
        {
            [pickerArray addObject:[userdefaults objectForKey:@"channel2"]];
        }
        
    }
    if ([userdefaults objectForKey:@"channel3"]!=nil) {
        if(pickerArray.count>2)
        {
            [pickerArray replaceObjectAtIndex:2 withObject:[userdefaults objectForKey:@"channel3"]];
        }
        else
        {
            [pickerArray addObject:[userdefaults objectForKey:@"channel3"]];
        }
        
    }
    
#pragma mark pickerArray
//    if ([userdefaults objectForKey:@"channel4"]!=nil) {
//        if(pickerArray.count>3)
//        {
//            [pickerArray replaceObjectAtIndex:3 withObject:[userdefaults objectForKey:@"channel4"]];
//        }
//        else
//        {
//            [pickerArray addObject:[userdefaults objectForKey:@"channel4"]];
//        }
//        //        [pickerArray replaceObjectAtIndex:3 withObject:[userdefaults objectForKey:@"channel4"]];
//    }

#pragma mark time
    
    [self reloadDeviceTime];
    
    
    if (tm == nil) {
        tm = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(reloadDeviceTime) userInfo:nil repeats:YES];
        
    }

    
    [self readClick];
    [self readClick1];
    [self readClick2];
    [self readClick3];

    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == dialog) {
        if (buttonIndex == 1) {
#pragma mark 数组重新创建
//            channelDic = [[NSMutableDictionary alloc] init];
//            SettingDic = [[NSMutableDictionary alloc] init];
//            
//            if ([[[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] >0) {
//                if (setDic != nil) {
//                    [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
//                    [channelDic setObject:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
//
//                }
//
//                [SettingDic setValue:channelDic forKey:[alertView textFieldAtIndex:0].text];
//                [SettingDic setObject:channelDic forKey:[alertView textFieldAtIndex:0].text];
//                [userdefaults setObject:SettingDic forKey:@"setting"];
//                [userdefaults setObject:channelDic forKey:@"settinglast"];
//                
//                NSLog(@"%@ %@ %@",SettingDic,channelDic,setDic);
            
//            if ([[[alertView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] >0) {
            if ([[alertView textFieldAtIndex:0].text length] >0) {
                
            
                if (setDic != nil) {
                    [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
                }
                
//                [SettingDic setValue:channelDic forKey:[alertView textFieldAtIndex:0].text];
//                
//                [userdefaults setObject:SettingDic forKey:@"setting"];
//                [userdefaults setObject:channelDic forKey:@"settinglast"];
                
                
                if(setDic != nil)
                {
                    [SettingDic setValue:[setDic copy] forKey:[alertView textFieldAtIndex:0].text];
#pragma mark 保存SettingDic

                    [userdefaults setObject:SettingDic forKey:@"setting"];
                    [userdefaults setObject:channelDic forKey:@"settinglast"];
#pragma mark 重新创建了setDic  SettingDic
//                    setDic = [[NSMutableDictionary alloc] init];
//                    SettingDic = [[NSMutableDictionary alloc] init];
                }
                else
                {
                    [SVProgressHUD showInfoWithStatus:@"You haven't set any parameters"];
                }


            }
            else
            {
                [SVProgressHUD showInfoWithStatus:@"Please enter a correct name"];
                
            }
        }

    }
    else
    {
        if (buttonIndex == 0) {
#pragma mark return 注释掉了
//            return;
            [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
            
            [SettingDic setValue:channelDic forKey:loadName];
#pragma mark 保存SettingDic

            [userdefaults setObject:SettingDic forKey:@"setting"];
        }
        else
        {
            dialog = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit",nil];
            [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[dialog textFieldAtIndex:0] setKeyboardType: UIKeyboardTypeDefault];
            [[dialog textFieldAtIndex:0] setPlaceholder:@"Name"];
            [[dialog textFieldAtIndex:0] setSecureTextEntry:NO];
            [dialog show];
        }

    }
}

//#pragma mark -
//#pragma mark Picker Date Source Methods
//
////返回显示的列数
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
////返回当前列显示的行数
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
////    if (pickerView == PickerView) {
////        return [pickerArray count];
////    }
////    else
////    {
//        return [pickerArray2 count];
////    }
//}
//
//#pragma mark Picker Delegate Methods
//
////返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
////    if (pickerView == PickerView) {
////        return [pickerArray objectAtIndex:row];
////    }
////    else
////    {
//        return [pickerArray2 objectAtIndex:row];
////    }
//    
//}
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel* pickerLabel = (UILabel*)view;
//    if (!pickerLabel){
//        pickerLabel = [[UILabel alloc] init];
//        // Setup label properties - frame, font, colors etc
//        //adjustsFontSizeToFitWidth property to YES
//        pickerLabel.minimumFontSize = 8;
//        pickerLabel.adjustsFontSizeToFitWidth = YES;
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
//        [pickerLabel setTextColor:[UIColor blackColor]];
//    }
//    // Fill the label text here
//    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
//    return pickerLabel;
//}
//
//
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    UILabel* pickerLabel;
////    if (pickerView == PickerView) {
////        pickerLabel = (UILabel *)[PickerView viewForRow:row forComponent:component];
////        
////        
////        
////    }
////    else
////    {
//        pickerLabel = (UILabel *)[PickerView2 viewForRow:row forComponent:component];
////        SettingsLbl.text = pickerLabel.text;
//    [SettingsBtn setTitle:pickerLabel.text forState:UIControlStateNormal];
//        WEEK = row;
//        
//        NSArray *keys = [SettingDic allKeys];
//        if(keys.count>0)
//        {
//        setDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(row)]]];
//        loadName = [keys objectAtIndex:(row)];
//        bool full = NO;
//        
//        
//        NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value5"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//        
//        temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value5"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//
//        
//        temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value5"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//
//        
//        temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
//        if (temp !=nil) {
//            int h = [[[temp copy] objectForKey:@"value4"] intValue];
//            if (h>12) {
//                
//                h -=12;
//            }
//            
//            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
//            full = YES;
//        }
//        else
//        {
//            [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
//        }
//
//        
//        loading = full;
//        }
////    }
//    [pickerLabel setTextColor:[UIColor colorWithRed:(float)10/255.0 green:(float)182/255.0 blue:(float)248/255.0 alpha:1.0f]];
//    [pickerLabel setFont:[UIFont boldSystemFontOfSize:17]];
//    CH = (int)row;
//}


#pragma mark -
#pragma mark UIPickerViewDelegate methods
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20.0f;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *pTitle = nil;
    if (component == 0) {
        if (pickerView == FristPicker) {
            if (MODE ==1) {
                pTitle = [pickerArray5 objectAtIndex:row];
            }
            else if (MODE ==2)
            {
                if (onOrOff) {
//                    pTitle = [pickerArray3 objectAtIndex:row];
                    pTitle = [pickerArray6 objectAtIndex:row];
#pragma mark turnOnShowStyle
                }
                else
                {
                    pTitle = [pickerArray6 objectAtIndex:row];
                    
                }
                
            }
        }
        else
        {
            pTitle = [pickerArray6 objectAtIndex:row];
        }
    }
    if (component == 1) {
        pTitle = [pickerArray4 objectAtIndex:row];
    }
//    if (component == 2) {
//        pTitle = @"PM";
//    }
    return pTitle;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    
    if (pickerView == FristPicker) {
        if (onOrOff == YES) {
            if (component == 0) {
                if (MODE ==1) {
                    hour = [pickerArray5 objectAtIndex:row];
                }
                else if (MODE ==2)
                {
                    if (onOrOff) {
#pragma mark showStyle
//                        hour = [pickerArray3 objectAtIndex:row];
                        hour = [pickerArray6 objectAtIndex:row];

                    }
                    else
                    {
                        hour = [pickerArray6 objectAtIndex:row];
                        
                    }

                }
               
                
            }
            if (component == 1) {
                second = [pickerArray4 objectAtIndex:row];
            }
            
        }
        else
        {
            if (component == 0) {
                if (MODE ==1) {
                    hour4 = [pickerArray5 objectAtIndex:row];
                }
                else if (MODE ==2)
                {
                    if (onOrOff) {
#pragma mark shoeStyle
//                        hour4 = [pickerArray3 objectAtIndex:row];
                        hour4 = [pickerArray6 objectAtIndex:row];

                    }
                    else
                    {
                        hour4 = [pickerArray6 objectAtIndex:row];
                        
                    }
                }
//                hour4 = [pickerArray3 objectAtIndex:row];
                
            }
            if (component == 1) {
                second4 = [pickerArray4 objectAtIndex:row];
            }
        }
    }
//    else if (pickerView == SecondPicker) {
//        
//        if (component == 0) {
//            hour2 = [pickerArray6 objectAtIndex:row];
//            
//        }
//        if (component == 1) {
//            second2 = [pickerArray4 objectAtIndex:row];
//        }
//        
//    }
//    else if (pickerView == ThirdPicker) {
//        
//        if (component == 0) {
//            hour3 = [pickerArray6 objectAtIndex:row];
//            
//        }
//        if (component == 1) {
//            second3 = [pickerArray4 objectAtIndex:row];
//        }
//        
//    }

}

#pragma mark -
#pragma mark UIPickerViewDataSource methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger RCount;
    switch (component) {
        case 0:
        {
            if (pickerView == FristPicker) {
                if (MODE ==1) {
                    
                    RCount = [pickerArray5 count];
                }
                else if (MODE ==2)
                {
                    if (onOrOff) {
#pragma mark showStyle
//                        RCount = [pickerArray3 count];
                        RCount = [pickerArray6 count];

                    }
                    else
                    {
                        RCount = [pickerArray6 count];
                        
                    }
                    
                }
                else
                {
                    RCount = 0;
                }
            }
            
            else
            {
                 RCount = [pickerArray6 count];
            }
        }
            break;
        case 1:
            RCount = [pickerArray4 count];

            break;
        case 2:
            RCount = 1;
            break;
        default:
            break;
    }
    return RCount;
    
    
}

#pragma mark --
#pragma mark - UIActionSheet
/*
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    if (buttonIndex == 0) {
        
    }
    else
    {
        if (actionSheet == actionSheet1) {
            NSArray *keys = [SettingDic allKeys];
            channelDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(buttonIndex-1)]]];
            [userdefaults setObject:channelDic forKey:@"settinglast"];
            setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
            loadName = [keys objectAtIndex:(buttonIndex-1)];
            [userdefaults setObject:loadName forKey:@"loadName"];
           [self loadMessage:setDic];
        }
        else if(actionSheet == actionSheet2)
        {
            channelTxt.text = [pickerArray objectAtIndex:(buttonIndex -1)];
            if ([setDic count] != 0 && !loading) {
                 [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
            }
            channelIndex = buttonIndex;
            CH = buttonIndex;
            setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];

            bool full = NO;
            
            
            NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
#pragma mark setbtnTitle
//                [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
                NSString * v4 = [temp objectForKey:@"value4"];
                NSString * v5 = [temp objectForKey:@"value5"];
                NSString * v6 = [temp objectForKey:@"value6"];

                if (v3 == 0) {
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunset to %@%%",[temp objectForKey:@"value4"]] forState:UIControlStateNormal];
                }else if (v3 == 1){
                
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"After Sunset to %@%%",v4] forState:UIControlStateNormal];
                }else if (v3 == 2){
                    NSString * strq;
                    if (h>12) {
                        strq = [NSString stringWithFormat:@"%d:%@PM",h-12,v6];
                    }else{
                    
                        strq = [NSString stringWithFormat:@"%d:%@AM",h,v6];
                    }
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"At %@ to %@%%",strq,v4] forState:UIControlStateNormal];
                }
                
//                [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
//                [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value4"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [TurnOffBtn setTitle:[NSString stringWithFormat:@"At %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
                full = YES;
            }
            else
            {
                [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
            }

            
            loading = full;

        }
        else if(actionSheet == actionSheet3)
        {
//            channelTxt.text = [pickerArray objectAtIndex:(buttonIndex -1)];
            [SettingsBtn setTitle:[pickerArray2 objectAtIndex:(buttonIndex -1)] forState:UIControlStateNormal];
 
            WEEK = (buttonIndex -2);
            
            NSArray *keys = [channelDic allKeys];
            if(keys.count>0)
            {
//#pragma mark 这里可会有问题，自己加了一个if判断
//                if (keys.count <= buttonIndex - 1) {
//                    return;
//                }
                setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
//                loadName = [keys objectAtIndex:(buttonIndex-1)];
                
//                setDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(buttonIndex -1)]]];
//                loadName = [keys objectAtIndex:(buttonIndex -1)];
                bool full = NO;
                
                
                NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
#pragma mark 需要修改
                    
                    NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
                    NSString * v4 = [temp objectForKey:@"value4"];
                    NSString * v5 = [temp objectForKey:@"value5"];
                    NSString * v6 = [temp objectForKey:@"value6"];
                    
                    if (v3 == 0) {
                        [TurnOnBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunset to %@%%",[temp objectForKey:@"value4"]] forState:UIControlStateNormal];
                    }else if (v3 == 1){
                        
                        [TurnOnBtn setTitle:[NSString stringWithFormat:@"After Sunset to %@%%",v4] forState:UIControlStateNormal];
                    }else if (v3 == 2){
                        NSString * strq;
                        if (h>12) {
                            strq = [NSString stringWithFormat:@"%d:%@PM",h-12,v6];
                        }else{
                            
                            strq = [NSString stringWithFormat:@"%d:%@AM",h,v6];
                        }
                        [TurnOnBtn setTitle:[NSString stringWithFormat:@"At %@ to %@%%",strq,v4] forState:UIControlStateNormal];
                    }

                    
//                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value4"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [TurnOffBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to%@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
                    full = YES;
                }
                else
                {
                    [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                loading = full;
            }
        }
        
        
           }
}
*/

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    if (buttonIndex == 0) {
        
    }
    else
    {
        if (actionSheet == actionSheet1) {
            
//            NSArray *keys = [SettingDic allKeys];
            channelDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(buttonIndex-1)]]];
            [userdefaults setObject:channelDic forKey:@"settinglast"];
            setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
            loadName = [keys objectAtIndex:(buttonIndex-1)];
            [userdefaults setObject:loadName forKey:@"loadName"];
            
            
            nowDic = [SettingDic objectForKey:keys[buttonIndex - 1]];
            ifSendMessage = YES;
            [self loadMessage:nowDic];
#pragma mark loading 修改
//            loading = YES;
        }
        else if(actionSheet == actionSheet2)
        {
            channelTxt.text = [pickerArray objectAtIndex:(buttonIndex -1)];
            if ([setDic count] != 0 && !loading) {
                [channelDic setValue:setDic forKey:[NSString stringWithFormat:@"%d",channelIndex]];
            }
            channelIndex = buttonIndex;
            CH = buttonIndex;
            setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
            
            //            bool full = NO;
            
            
            NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
#pragma mark setbtnTitle
                //                [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                //                full = YES;
            }
            
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
                NSString * v4 = [temp objectForKey:@"value4"];
                //                NSString * v5 = [temp objectForKey:@"value5"];
                NSString * v6 = [temp objectForKey:@"value6"];
                
                if (v3 == 0) {
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunset to %@%%",[temp objectForKey:@"value4"]] forState:UIControlStateNormal];
                }else if (v3 == 1){
                    
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"After Sunset to %@%%",v4] forState:UIControlStateNormal];
                }else if (v3 == 2){
                    NSString * strq;
                    if (h>12) {
                        strq = [NSString stringWithFormat:@"%d:%@PM",h-12,v6];
                    }else{
                        
                        strq = [NSString stringWithFormat:@"%d:%@AM",h,v6];
                    }
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"At %@ to %@%%",strq,v4] forState:UIControlStateNormal];
                }
                
                [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

                //                [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                //                full = YES;
            }
            else
            {
                [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                //                full = YES;
                [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            }
            else
            {
                [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value5"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                //                full = YES;
                [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            }
            else
            {
                [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            
            temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
            if (temp !=nil) {
                int h = [[[temp copy] objectForKey:@"value4"] intValue];
                if (h>12) {
                    
                    h -=12;
                }
                
                [TurnOffBtn setTitle:[NSString stringWithFormat:@"At %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
                //                full = YES;
                [self getRequest:6 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            }
            else
            {
                [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
            }
            
            
            //            loading = full;
            
        }
        else if(actionSheet == actionSheet3)
        {
            //            channelTxt.text = [pickerArray objectAtIndex:(buttonIndex -1)];
            [SettingsBtn setTitle:[pickerArray2 objectAtIndex:(buttonIndex -1)] forState:UIControlStateNormal];
            
            WEEK = ((int)buttonIndex -2);
            ifSendMessage = NO;
            [self loadMessage:nowDic];
            /*
            
            NSArray *keys = [channelDic allKeys];
            if(keys.count>0)
            {
                //#pragma mark 这里可会有问题，自己加了一个if判断
                //                if (keys.count <= buttonIndex - 1) {
                //                    return;
                //                }
//                setDic = [NSMutableDictionary dictionaryWithDictionary:[channelDic objectForKey:[NSString stringWithFormat:@"%d",channelIndex]]];
                //                loadName = [keys objectAtIndex:(buttonIndex-1)];
                
                //                setDic = [NSMutableDictionary dictionaryWithDictionary:[SettingDic objectForKey:[keys objectAtIndex:(buttonIndex -1)]]];
                //                loadName = [keys objectAtIndex:(buttonIndex -1)];
                //                bool full = NO;
                
                
                NSDictionary *temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOn",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
#pragma mark 需要修改
                    
                    NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
                    NSString * v4 = [temp objectForKey:@"value4"];
                    //                    NSString * v5 = [temp objectForKey:@"value5"];
                    NSString * v6 = [temp objectForKey:@"value6"];
                    
                    if (v3 == 0) {
                        [TurnOnBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunset to %@%%",[temp objectForKey:@"value4"]] forState:UIControlStateNormal];
                    }else if (v3 == 1){
                        
                        [TurnOnBtn setTitle:[NSString stringWithFormat:@"After Sunset to %@%%",v4] forState:UIControlStateNormal];
                    }else if (v3 == 2){
                        NSString * strq;
                        if (h>12) {
                            strq = [NSString stringWithFormat:@"%d:%@PM",h-12,v6];
                        }else{
                            
                            strq = [NSString stringWithFormat:@"%d:%@AM",h,v6];
                        }
                        [TurnOnBtn setTitle:[NSString stringWithFormat:@"At %@ to %@%%",strq,v4] forState:UIControlStateNormal];
                        
                    }
                    [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
                    
                    //                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    //                    full = YES;
                }
                else
                {
                    [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event1",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    //                    full = YES;
                    [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
                }
                else
                {
                    [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"event2",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value5"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
                    //                    full = YES;
                    [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
                }
                else
                {
                    [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                temp = [setDic objectForKey:[NSString stringWithFormat:@"%@%d",@"turnOff",WEEK]];
                if (temp !=nil) {
                    int h = [[[temp copy] objectForKey:@"value4"] intValue];
                    if (h>12) {
                        
                        h -=12;
                    }
                    
                    [TurnOffBtn setTitle:[NSString stringWithFormat:@"At %d:%@ to%@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
                    //                    full = YES;
                    [self getRequest:6 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
                }
                else
                {
                    [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
                }
                
                
                //                loading = full;
            }
            else
            {
                [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
                [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
                [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
                [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
            }*/
        }
        
        
    }
}


- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}


#pragma mark -
#pragma mark --TOUCH

- (void)addDefaultDicToSettingDic{

    NSMutableDictionary * defaultDic = [[NSMutableDictionary alloc] init];
    NSDictionary * temp1 = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",0],@"value1",[NSString stringWithFormat:@"%d",255],@"value2",[NSString stringWithFormat:@"%d",2],@"value3",[NSString stringWithFormat:@"%.0f",50.00],@"value4",[NSString stringWithFormat:@"%d",18],@"value5",[NSString stringWithFormat:@"%d",30],@"value6", nil];
    
    for (int i = -1; i<7; i++) {
        NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp1 copy]];
        [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark turnOn数据保存
        
        [defaultDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"turnOn%d",i]];
        tempDic2 = nil;
        
    }
    
    
    NSDictionary * temp2 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"0",@"value3",[NSString stringWithFormat:@"%.0f",Secondslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour2 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second2 intValue]],@"value6",@"0",@"value7", nil];
    
    for (int i = -1; i<7; i++) {
        NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp2 copy]];
        [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark event1数据保存
        
        [defaultDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"event1%d",i]];
        tempDic2 = nil;
    }
    
    
    NSDictionary * temp3 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"index",[NSString stringWithFormat:@"%d",0],@"value1",[NSString stringWithFormat:@"%d",255],@"value2",@"0",@"value3",[NSString stringWithFormat:@"%.0f",Secondslider.value],@"value4",[NSString stringWithFormat:@"%d",6],@"value5",[NSString stringWithFormat:@"%d",30],@"value6",@"0",@"value7", nil];
    
    for (int i = -1; i<7; i++) {
        NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp3 copy]];
        [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark event2数据保存
        
        [defaultDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"event2%d",i]];
        tempDic2 = nil;
    }
    
    
    NSDictionary * temp4 = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",1],@"value1",[NSString stringWithFormat:@"%d",255],@"value2",[NSString stringWithFormat:@"%d",2],@"value3",[NSString stringWithFormat:@"%d",6],@"value4",[NSString stringWithFormat:@"%d",30],@"value5", nil];
    for (int i = -1; i<7; i++) {
        NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp4 copy]];
        [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark turnOff数据保存
        
        [defaultDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"turnOff%d",i]];
        tempDic2 = nil;
    }
    
    
    
    [SettingDic setObject:defaultDic forKey:@"Default"];

}

-(void)LoadAction
{
    
    
#pragma mark 获取settingDic 111
    SettingDic = [NSMutableDictionary dictionaryWithDictionary:[userdefaults objectForKey:@"setting"]];
    [self addDefaultDicToSettingDic];
    
    if (SettingDic.count<1) {
        [SVProgressHUD showInfoWithStatus:@"The list is empty"];
    }
    else
    {
       
        actionSheet1 = [[UIActionSheet alloc]
                       initWithTitle:@"select"
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:nil];
#pragma mark allKeys
        keys = [SettingDic allKeys];
        for (int i = 0; i< SettingDic.count; i++) {
            [actionSheet1 addButtonWithTitle:[keys objectAtIndex:i] ];
            
        }
        actionSheet1.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet1 showInView:self.view];

    }
    [userdefaults objectForKey:@""];
    
    
//    NSLog(@"%@",SettingDic);
}

-(void)SaveAction
{
    if(loading)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Select" delegate:self cancelButtonTitle:@"update" otherButtonTitles:@"save", nil];
        
        [alertView show];

    }
    else
    {
        dialog = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Submit",nil];
        [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [[dialog textFieldAtIndex:0] setKeyboardType: UIKeyboardTypeDefault];
        [[dialog textFieldAtIndex:0] setPlaceholder:@"Name"];
        [[dialog textFieldAtIndex:0] setSecureTextEntry:NO];
        [dialog show];
    }
}
-(void)TurnOnAction
{
    onLbl.text = @"Turn on";
    [ExactlyBtn setTitle:@"Exactly at Sunset" forState:UIControlStateNormal];
    [AfterBtn setTitle:@"After Sunset" forState:UIControlStateNormal];
    PopView.hidden = NO;
    onOrOff = YES;
    FirstView.hidden = NO;
    SecondView.hidden = YES;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
    Fristslider.hidden = NO;
    FristLbl.hidden = NO;
//    isPop = YES;
    /*
    if(MODE == 0)
    {
        FristPicker.hidden = YES;
        FristdatePicker.hidden = YES;
    }
    else
    {
//        FristPicker.hidden = NO;
        [FristPicker reloadAllComponents];
//        FristdatePicker.hidden = YES;
        FristdatePicker.hidden = NO;
        FristPicker.hidden = YES;
        
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
#pragma mark showStyle2
        if (MODE == 1) {
            hour=[pickerArray5 objectAtIndex:row];
            second = [pickerArray4 objectAtIndex:row2];

        }else{
//        hour=[pickerArray3 objectAtIndex:row];
            hour = [pickerArray6 objectAtIndex:row];
        second = [pickerArray4 objectAtIndex:row2];
        }
    }
//    else
//    {
//        FristPicker.hidden = YES;
//        
//        FristdatePicker.hidden = NO;
//    }
*/
    if(MODE == 0)
    {
        FristPicker.hidden = YES;
        FristdatePicker.hidden = YES;
    }
    else if(MODE == 1)
    {
        FristPicker.hidden = NO;
        [FristPicker reloadAllComponents];
        FristdatePicker.hidden = YES;
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour=[pickerArray5 objectAtIndex:row];
        second = [pickerArray4 objectAtIndex:row2];
    }
    else
    {
        FristPicker.hidden = YES;
        
        FristdatePicker.hidden = NO;
    }


}

-(void)FirstEventAction
{
    PopView.hidden = NO;
//    isPop = YES;

    FirstView.hidden = YES;
    SecondView.hidden = NO;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
}

-(void)SecondEventAction
{
    PopView.hidden = NO;
//    isPop = YES;

    FirstView.hidden = YES;
    SecondView.hidden = YES;
    ThirdView.hidden = NO;
    FourthView.hidden = YES;
    
}

-(void)TurnOffAction
{
    onLbl.text = @"Turn off";
    onOrOff = NO;
//    isPop = YES;
    [ExactlyBtn setTitle:@"Exactly at Sunrise" forState:UIControlStateNormal];
    [AfterBtn setTitle:@"After Sunrise" forState:UIControlStateNormal];

    PopView.hidden = NO;
    
    FirstView.hidden = NO;
    SecondView.hidden = YES;
    ThirdView.hidden = YES;
    FourthView.hidden = YES;
    Fristslider.hidden = YES;
    if(MODE == 0)
    {
        FristPicker.hidden = YES;
        FristdatePicker.hidden = YES;
    }
    else if(MODE == 1)
    {
        FristPicker.hidden = NO;
        [FristPicker reloadAllComponents];
        FristdatePicker.hidden = YES;
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour4=[pickerArray5 objectAtIndex:row];
        second4 = [pickerArray4 objectAtIndex:row2];
    }
    else
    {
        FristPicker.hidden = YES;

        FristdatePicker.hidden = NO;
    }
    
    FristLbl.hidden = YES;
}

-(void)switchAction:(id)sender
{
    UISwitch * switchw = (UISwitch *)sender;
    int on = 0;
    if (switchw == switchView) {
        
        if (switchw.on) {
            on = 1;
            
        }
        else
        {
            
            on = 0;
            
        }
        if(self.currPeripheral != nil &&self.characteristic != nil)
        {
//            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
            NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",on],@"value2",  nil];
#pragma mark 写入事件信息
            [self getRequest:5 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            
           [setDic setObject:temp forKey:@"ov"];
            
        }
    }
    if (switchw == switchView2) {
        NSDictionary * temp;
        if (switchw.on) {
            on = 1;
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"11",@"index",  nil];
        }
        else
        {
            
            on = 0;
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"10",@"index",  nil];
        }
        if(self.currPeripheral != nil &&self.characteristic != nil)
        {
//            baby.channel(channelOnPeropheralView).characteristicDetails(self.currPeripheral,self.characteristic);
            
            [self getRequest:2 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            [setDic setObject:temp forKey:@"det"];
        }
    }
}


-(void)FirstValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    FristLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}

-(void)SecondValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    SecondLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}

-(void)ThirdValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    ThirdLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}

-(void)FourthValue:(id)sender{
    
    UISlider * slider = (UISlider *)sender;
    float f = slider.value; //读取滑块的值
    FourthLbl.text = [NSString stringWithFormat:@"%.0f%%",f];
}
-(void)TurnOnSaveAction
{
    
    PopView.hidden = YES;
    NSDictionary * temp;
    if (onOrOff == YES) {
        if (MODE == 0) {
//            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  00:00 to %@",FristLbl.text] forState:UIControlStateNormal];
            
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunset to %.0f%%",Fristslider.value] forState:UIControlStateNormal];
//            TurnOnBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",[NSString stringWithFormat:@"%d",MODE],@"value3",[NSString stringWithFormat:@"%.0f",Fristslider.value],@"value4",[NSString stringWithFormat:@"%d",0],@"value5",[NSString stringWithFormat:@"%d",0],@"value6", nil];
#pragma mark turnOn数据保存
            [setDic setObject:temp forKey:[NSString stringWithFormat:@"turnOn%d",WEEK]];
            NSLog(@"%@",setDic);
            
            [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        }
        else if (MODE == 1)
        {
//            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %@:%@  to %@",[hour intValue]<10?[NSString stringWithFormat:@"0%@",hour]:hour,[second intValue]<10?[NSString stringWithFormat:@"0%@",second]:second,FristLbl.text] forState:UIControlStateNormal];
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"After Sunset to %@",FristLbl.text] forState:UIControlStateNormal];
//            TurnOnBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",[NSString stringWithFormat:@"%d",MODE],@"value3",[NSString stringWithFormat:@"%.0f",Fristslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour intValue]],@"value5",[NSString stringWithFormat:@"%d",[second intValue]],@"value6", nil];
#pragma mark turnOn数据保存
           
            [setDic setObject:temp forKey:[NSString stringWithFormat:@"turnOn%d",WEEK]];
            
            
            [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
            
        }else if (MODE == 2){
            
           

        
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At%@:%@ to %@",[hour intValue]<10?[NSString stringWithFormat:@"0%@",hour]:hour,[second intValue]<10?[NSString stringWithFormat:@"0%@",second]:second,FristLbl.text] forState:UIControlStateNormal];
            NSDate *selected = [FristdatePicker date];
            [dateFormatter setDateFormat:@"hh:mm aa"];
            NSString *str=[dateFormatter stringFromDate:selected];

            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At time %@ to %@",str,FristLbl.text] forState:UIControlStateNormal];

//            TurnOnBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            
            NSString *str2=[dateFormatter stringFromDate:selected];
            NSArray * tempArray = [str2 componentsSeparatedByString:@":"];
            hour = [tempArray objectAtIndex:0];
            second = [tempArray objectAtIndex:1];
            temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",[NSString stringWithFormat:@"%d",MODE],@"value3",[NSString stringWithFormat:@"%.0f",Fristslider.value],@"value4",[NSString stringWithFormat:@"%d",MODE!=0?[hour intValue]:0],@"value5",[NSString stringWithFormat:@"%d",MODE!=0?[second intValue]:0],@"value6", nil];
#pragma mark turnOn数据保存
            
            [setDic setObject:temp forKey:[NSString stringWithFormat:@"turnOn%d",WEEK]];
//            NSLog(@"%@",setDic);

            
            [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

            
        }

//        if (MODE == 0) {
//            hour = 0;
//            second = 0;
//        }
//        else if(MODE == 1)
//        {
//            if ([[tempArray objectAtIndex:0]integerValue]>12) {
//                hour = @"12";
//            }
//            else
//            {
//            hour = [tempArray objectAtIndex:0];
//            }
//            second = [tempArray objectAtIndex:1];
//
//        }
//
//        else{
//            hour = [tempArray objectAtIndex:0];
//            second = [tempArray objectAtIndex:1];
//        }

        
        if(WEEK==-1)
        {
            if (![nightlyArray containsObject:@"1"]) {
               [setDic removeAllObjects];
            }
            

            for (int i = -1; i<7; i++) {
                NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp copy]];
                [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark turnOn数据保存

                [setDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"turnOn%d",i]];
                tempDic2 = nil;
//                NSLog(@"%@",setDic);

            }
            [nightlyArray replaceObjectAtIndex:0 withObject:@"1"];
        }
    }
    else
    {
        NSDate *selected = [FristdatePicker date];
        [dateFormatter setDateFormat:@"hh:mm aa"];
        NSString *str=[dateFormatter stringFromDate:selected];
        
        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//        
//        NSDateComponents *comps = nil;
//        
//        comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//        
//        NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//        
//        [adcomps setHour:1];
//        
//        
//        NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:selected options:0];
        
//        if(MODE == 1)
//        {
//            [dateFormatter setDateFormat:@"H:mm"];
//            
//        }
//        else
            if(MODE == 2)
        {
            [dateFormatter setDateFormat:@"HH:mm"];
        }
        
        NSString *str2=[dateFormatter stringFromDate:selected];
        NSArray * tempArray = [str2 componentsSeparatedByString:@":"];

        if (MODE == 0) {
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At 00:00 to %@",FristLbl.text] forState:UIControlStateNormal];
            [TurnOffBtn setTitle:@"Exactly at Sunrise" forState:UIControlStateNormal];
//            TurnOffBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
            
        }
        else if(MODE == 1)
        {
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At %@:%@ to %@",[hour4 intValue]<10?[NSString stringWithFormat:@"0%@",hour4]:hour4,[second4 intValue]<10?[NSString stringWithFormat:@"0%@",second4]:second4,FristLbl.text] forState:UIControlStateNormal];
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"After Sunrise"] forState:UIControlStateNormal];
            TurnOffBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];

        }
        else if (MODE == 2)
        {
//            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %@:%@  to %@",[hour4 intValue]<10?[NSString stringWithFormat:@"0%@",hour4]:hour4,[second4 intValue]<10?[NSString stringWithFormat:@"0%@",second4]:second4,FristLbl.text] forState:UIControlStateNormal];
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At %@ to %@",str,FristLbl.text] forState:UIControlStateNormal];
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At time %@",str] forState:UIControlStateNormal];
//            TurnOffBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];

            
        }
//        if (MODE == 0) {
//            hour4 = @"0";
//            second4 = @"0";
//        }
//        else if(MODE == 1)
//        {
//            if ([[tempArray objectAtIndex:0]integerValue]>12) {
//                hour4 = @"12";
//            }
//            else
//            {
//                hour4 = [tempArray objectAtIndex:0];
//            }
//            second4 = [tempArray objectAtIndex:1];
//            
//        }
        if (MODE == 2)
        {
            hour4 = [tempArray objectAtIndex:0];
            second4 = [tempArray objectAtIndex:1];
        }
        temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",[NSString stringWithFormat:@"%d",MODE],@"value3",[NSString stringWithFormat:@"%d",MODE!=0?[hour4 intValue]:0],@"value4",[NSString stringWithFormat:@"%d",MODE!=0?[second4 intValue]:0],@"value5", nil];
        
//       [setDic setObject:temp forKey:@"turnOff"];
#pragma mark turnOff数据保存

        [setDic setObject:temp forKey:[NSString stringWithFormat:@"turnOff%d",WEEK]];
        [self getRequest:6 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        if(WEEK==-1)
        {
            if (![nightlyArray containsObject:@"1"]) {
                [setDic removeAllObjects];
            }
            
            
            for (int i = -1; i<7; i++) {
                NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp copy]];
                [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark turnOff数据保存

                [setDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"turnOff%d",i]];
                tempDic2 = nil;
            }
            [nightlyArray replaceObjectAtIndex:3 withObject:@"1"];
        }

    }
    
}

-(void)FirstEventSaveAction
{
    
    
    PopView.hidden = YES;
    NSDictionary * temp;
    if (!fristSwitch.on) {
        [FirstEventBtn setTitle:@"Disable" forState:UIControlStateNormal];

        temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"0",@"value3",[NSString stringWithFormat:@"%.0f",Secondslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour2 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second2 intValue]],@"value6",[NSString stringWithFormat:@"%d",fristSwitch.on],@"value7", nil];
        [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

    }else{
    
        NSDate *selected = [SeconddatePicker date];
    
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    [dateFormatter setDateFormat:@"hh:mm aa"];
    NSString *str=[dateFormatter stringFromDate:selected];
//
    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At %@ to %@",str,SecondLbl.text] forState:UIControlStateNormal];
    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At %@ to %@",str,SecondLbl.text] forState:UIControlStateNormal];
//    FirstEventBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSDateComponents *comps = nil;
//    
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    
//    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//    
//    [adcomps setHour:1];
//    
//    
//    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
//    
//
        [dateFormatter setDateFormat:@"HH:mm"];
//
//    
    NSString *str2=[dateFormatter stringFromDate:selected];
    NSArray * tempArray = [str2 componentsSeparatedByString:@":"];
    hour2 = [tempArray objectAtIndex:0];
    second2 = [tempArray objectAtIndex:1];
    
    temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"1",@"value3",[NSString stringWithFormat:@"%.0f",Secondslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour2 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second2 intValue]],@"value6",[NSString stringWithFormat:@"%d",fristSwitch.on],@"value7", nil];
        [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
    }
//    [setDic setObject:temp forKey:@"event1"];
#pragma mark event1数据保存

    [setDic setObject:temp forKey:[NSString stringWithFormat:@"event1%d",WEEK]];
    
    if(WEEK==-1)
    {
        if (![nightlyArray containsObject:@"1"]) {
            [setDic removeAllObjects];
        }
        
        for (int i = -1; i<7; i++) {
            NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp copy]];
            [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark event1数据保存

            [setDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"event1%d",i]];
            tempDic2 = nil;
        }
        [nightlyArray replaceObjectAtIndex:1 withObject:@"1"];
    }


    
}

-(void)SecondEventSaveAction
{
    PopView.hidden = YES;
    NSDictionary * temp;
    if (!secondSwitch.on) {
        [SecondEventBtn setTitle:@"Disable" forState:UIControlStateNormal];
        
        temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"0",@"value3",[NSString stringWithFormat:@"%.0f",Thirdslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour3 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second3 intValue]],@"value6",[NSString stringWithFormat:@"%d",secondSwitch.on],@"value7", nil];
        [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

        
        
    }else{

    
    
    [dateFormatter setDateFormat:@"hh:mm aa"];
    NSDate *selected = [ThirddatePicker date];
    
    NSString *str=[dateFormatter stringFromDate:selected];
//
    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At %@ to %@",str,ThirdLbl.text] forState:UIControlStateNormal];
    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At %@ to %@",str,ThirdLbl.text] forState:UIControlStateNormal];
//    SecondEventBtn.titleLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSDateComponents *comps = nil;
//    
//    comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
//    
//    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
//    
//    [adcomps setHour:1];
//    
//    
//    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:[NSDate date] options:0];
//    
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    
    NSString *str2=[dateFormatter stringFromDate:selected];
    NSArray * tempArray = [str2 componentsSeparatedByString:@":"];
    hour3 = [tempArray objectAtIndex:0];
    second3 = [tempArray objectAtIndex:1];
    
    temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"1",@"value3",[NSString stringWithFormat:@"%.0f",Thirdslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour3 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second3 intValue]],@"value6",[NSString stringWithFormat:@"%d",secondSwitch.on],@"value7", nil];
        [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
    }
//    [setDic setObject:temp forKey:@"event2"];
#pragma mark event2数据保存

    [setDic setObject:temp forKey:[NSString stringWithFormat:@"event2%d",WEEK]];
    
    if(WEEK==-1)
    {
        if (![nightlyArray containsObject:@"1"]) {
            [setDic removeAllObjects];
        }
        
        for (int i = -1; i<7; i++) {
            NSMutableDictionary * tempDic2 = [NSMutableDictionary dictionaryWithDictionary:[temp copy]];
            [tempDic2 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"value2"];
#pragma mark event2数据保存

            [setDic setObject:[tempDic2 copy] forKey:[NSString stringWithFormat:@"event2%d",i]];
            tempDic2 = nil;
        }
        [nightlyArray replaceObjectAtIndex:2 withObject:@"1"];
    }

}


-(void)ExactlyAction:(id)sender
{
    hourLbl.hidden = YES;
    minLbl.hidden = YES;

    FristPicker.hidden = YES;
    FristdatePicker.hidden = YES;
    ivImageV.frame = CGRectMake(Device_Wdith-66, 69.5, 32, 20);
    MODE = 0;
    ExactlyBtn.selected = YES;
    AfterBtn.selected = NO;
    SpecificBtn.selected = NO;
    hour = @"0";

    hour4 = @"0";
    

}


#pragma mark AfterBtn hide no
-(void)AfterAction:(id)sender
{
    
    hourLbl.hidden = NO;
    minLbl.hidden = NO;
    
     MODE = 1;
    if (onOrOff) {
        FristPicker.hidden = NO;
        FristdatePicker.hidden = YES;
        [FristPicker reloadAllComponents];
        
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour=[pickerArray5 objectAtIndex:row];
        second = [pickerArray4 objectAtIndex:row2];
    }
    else
    {
        FristPicker.hidden = NO;
        [FristPicker reloadAllComponents];
        FristdatePicker.hidden = YES;
        
        NSInteger row=[FristPicker selectedRowInComponent:0];
        NSInteger row2=[FristPicker selectedRowInComponent:1];
        //然后是获取这个行中的值，就是数组中的值
        
        hour4=[pickerArray5 objectAtIndex:row];
        second4 = [pickerArray4 objectAtIndex:row2];
    
    }
    
//    FristPicker.hidden = NO;
//    [FristPicker reloadAllComponents];

    ivImageV.frame = CGRectMake(Device_Wdith-66, 111, 32, 20);
   
    ExactlyBtn.selected = NO;
    AfterBtn.selected = YES;
    SpecificBtn.selected = NO;
//    hour = @"0";
//
//    hour4 = @"0";

}

-(void)SpecificAction:(id)sender
{MODE = 2;
    hourLbl.hidden = YES;
    minLbl.hidden = YES;
#pragma mark specific time showStyle
//    if (onOrOff) {
////        FristPicker.hidden = NO;
////        FristdatePicker.hidden = YES;
//
//        
//        FristPicker.hidden = YES;
//        FristdatePicker.hidden = NO;
//        [FristPicker reloadAllComponents];
//        
//        NSInteger row=[FristPicker selectedRowInComponent:0];
//        NSInteger row2=[FristPicker selectedRowInComponent:1];
//        //然后是获取这个行中的值，就是数组中的值
//#pragma mark shoeStyle
////        hour=[pickerArray3 objectAtIndex:row];
//        hour = [pickerArray6 objectAtIndex:row];
//        second = [pickerArray4 objectAtIndex:row2];
//    }
//    else
//    {
        FristPicker.hidden = YES;
        FristdatePicker.hidden = NO;
//    }
    
    ivImageV.frame = CGRectMake(Device_Wdith-66, 152.5, 32, 20);
    
    ExactlyBtn.selected = NO;
    AfterBtn.selected = NO;
    SpecificBtn.selected = YES;
//    hour = @"3";
//    
//    hour4 = @"3";
}
-(void)changeAction
{
    actionSheet2 = [[UIActionSheet alloc]
                    initWithTitle:@"select"
                    delegate:self
                    cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                    otherButtonTitles:nil];
    
//    NSArray *keys = [pickerArray allKeys];
    for (int i = 0; i< pickerArray.count; i++) {
        [actionSheet2 addButtonWithTitle:[pickerArray objectAtIndex:i] ];
        
    }
    actionSheet2.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet2 showInView:self.view];

}
-(void)changeAction2
{
    actionSheet3 = [[UIActionSheet alloc]
                    initWithTitle:@"select"
                    delegate:self
                    cancelButtonTitle:@"Cancel"
                    destructiveButtonTitle:nil
                    otherButtonTitles:nil];
    
    //    NSArray *keys = [pickerArray allKeys];
    for (int i = 0; i< pickerArray2.count; i++) {
        [actionSheet3 addButtonWithTitle:[pickerArray2 objectAtIndex:i] ];
        
    }
    actionSheet3.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet3 showInView:self.view];
    
}

-(void)closeAction
{
    PopView.hidden = YES;
    
//    if (!fristSwitch.on) {
//        
//        
//        [FirstEventBtn setTitle:@"disabled" forState:UIControlStateNormal];
//    }else{
//    
//        if ([FirstEventBtn.titleLabel.text isEqualToString:@"--"]) {
//            [FirstEventBtn setTitle:@"unused" forState:UIControlStateNormal];
//
//        }
//        
//
//    }
//
//    if (!secondSwitch.on) {
//        
//        [SecondEventBtn setTitle:@"disabled" forState:UIControlStateNormal];
//        
//    }else{
//        
//        if ([SecondEventBtn.titleLabel.text isEqualToString:@"--"]) {
//            [SecondEventBtn setTitle:@"unused" forState:UIControlStateNormal];
//
//        }
//        
//    }

    
}


-(void)loadMessage:(NSMutableDictionary *)setDics
{
    
//    bool full = NO;
//    NSLog(@"%@",setDics);
//    NSArray * k = [setDics allKeys];
//    NSLog(@"%@",k);
    
    if (setDics.count == 0) {
        return;
    }
    
    NSString * str1 = [NSString stringWithFormat:@"turnOn%d",WEEK];
    NSDictionary *temp = [setDics objectForKey:str1];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value5"] intValue];
//        if (h>12) {
//            
//            h -=12;
//        }
        NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
        NSString * v4 = [temp objectForKey:@"value4"];
        NSString * v5 = [temp objectForKey:@"value5"];
        NSString * v6 = [temp objectForKey:@"value6"];
        
        if (v3 == 0) {
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunset"] forState:UIControlStateNormal];
        }else if (v3 == 1){
            
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"After Sunset to %@%%",v4] forState:UIControlStateNormal];
        }else if (v3 == 2){
            NSString * strq;
            if (h>12) {
                strq = [NSString stringWithFormat:@"%d:%@PM",h-12,v6];
            }else{
                
                strq = [NSString stringWithFormat:@"%d:%@AM",h,v6];
            }
            [TurnOnBtn setTitle:[NSString stringWithFormat:@"At time %@ to %@%%",strq,v4] forState:UIControlStateNormal];
        }
// [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        
//        [TurnOnBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
//        full = YES;
    }
    else
    {
        [TurnOnBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    NSString * str2 = [NSString stringWithFormat:@"event1%d",WEEK];
    temp = [setDics objectForKey:str2];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value5"] intValue];
        NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
        NSString * v4 = [temp objectForKey:@"value4"];
//        NSString * v5 = [temp objectForKey:@"value5"];
        NSString * v6 = [temp objectForKey:@"value6"];
        NSString * strT;
        if (!v3) {
            [FirstEventBtn setTitle:@"Disable" forState:UIControlStateNormal];
            //        full = YES;
//            [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

        }else{
        if (h>12) {
            
            h -=12;
            strT = [NSString stringWithFormat:@"%d:%@",h,v6];
        }else{
        
            strT = [NSString stringWithFormat:@"%d:%@",h,v6];
        }
        
        
        
        
        
//        [FirstEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
        [FirstEventBtn setTitle:[NSString stringWithFormat:@"At %@ PM to %@%%",strT,v4] forState:UIControlStateNormal];
//        full = YES;
//         [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
    }
//    else
//    {
//        [FirstEventBtn setTitle:@"--" forState:UIControlStateNormal];
//    }
    }
    NSString * str3 = [NSString stringWithFormat:@"event2%d",WEEK];
    temp = [setDics objectForKey:str3];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value5"] intValue];
        NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
        NSString * v4 = [temp objectForKey:@"value4"];
        //        NSString * v5 = [temp objectForKey:@"value5"];
        NSString * v6 = [temp objectForKey:@"value6"];
        NSString * strT;
        
        if (!v3) {
            [SecondEventBtn setTitle:@"Disable" forState:UIControlStateNormal];
            //        full = YES;
//            [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

        }else{
        if (h>12) {
            
            h -=12;
            strT = [NSString stringWithFormat:@"%d:%@",h,v6];
        }else{
            
            strT = [NSString stringWithFormat:@"%d:%@",h,v6];
        }
        
//        [SecondEventBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];
        [SecondEventBtn setTitle:[NSString stringWithFormat:@"At %@ PM to %@%%",strT,v4] forState:UIControlStateNormal];

//        full = YES;
//         [self getRequest:7 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
    }
//    else
//    {
//        [SecondEventBtn setTitle:@"--" forState:UIControlStateNormal];
//    }
    }
    NSString * str4 = [NSString stringWithFormat:@"turnOff%d",WEEK];
    temp = [setDics objectForKey:str4];
    if (temp !=nil) {
        int h = [[[temp copy] objectForKey:@"value4"] intValue];
//        if (h>12) {
//            
//            h -=12;
//        }
        
//        [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value5"],[[temp copy] objectForKey:@"value3"]] forState:UIControlStateNormal];
        
        NSInteger v3 =  [[temp objectForKey:@"value3"] integerValue];
        NSString * v4 = [temp objectForKey:@"value4"];
        NSString * v5 = [temp objectForKey:@"value5"];
        NSString * v6 = [temp objectForKey:@"value6"];
        
        if (v3 == 0) {
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunrise"] forState:UIControlStateNormal];
        }else if (v3 == 1){
            
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"After Sunrise"] forState:UIControlStateNormal];
        }else if (v3 == 2){
            NSString * strq;
            if (h>12) {
                strq = [NSString stringWithFormat:@"%d:%@PM",h-12,v5];
            }else{
                
                strq = [NSString stringWithFormat:@"%d:%@AM",h,v5];
            }
            [TurnOffBtn setTitle:[NSString stringWithFormat:@"At time %@",strq] forState:UIControlStateNormal];
        }
        
//        [self getRequest:6 requestDic:[temp copy] characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
//        [TurnOffBtn setTitle:[NSString stringWithFormat:@"At  %d:%@  to %@%%",h,[[temp copy] objectForKey:@"value6"],[[temp copy] objectForKey:@"value4"]] forState:UIControlStateNormal];

//        full = YES;
    }
    else
    {
        [TurnOffBtn setTitle:@"--" forState:UIControlStateNormal];
    }
    
    
//    loading = full;
    
    
//    NSLog(@"%@",setDics);
    if (ifSendMessage) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addDataView" object:nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        
//        [self creatUIAview];
        
        for (NSInteger i = 0; i < 7; i ++) {
            
            NSString * event1 = [NSString stringWithFormat:@"event1%d",i];
//            NSLog(@"%@",event1);
            if ([setDics objectForKey:event1]) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableDictionary * temp1 = [NSMutableDictionary dictionaryWithDictionary:[setDics objectForKey:event1]];
                    
                    [temp1 setObject:[NSString stringWithFormat:@"%d",CH -1] forKey:@"value1"];
                    [self getRequest:7 requestDic:temp1 characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

//                });

            }
            
            [NSThread sleepForTimeInterval:0.5];
            NSString * event2 = [NSString stringWithFormat:@"event2%d",i];
            if ([setDics objectForKey:event2]) {

                
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{

                    NSMutableDictionary * temp2 = [NSMutableDictionary dictionaryWithDictionary:[setDics objectForKey:event2]];
                    [temp2 setObject:[NSString stringWithFormat:@"%d",CH -1] forKey:@"value1"];
                    
                    [self getRequest:7 requestDic:temp2 characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
//                });
                

            }
            [NSThread sleepForTimeInterval:0.5];

            NSString * turnOn = [NSString stringWithFormat:@"turnOn%d",i];
            if ([setDics objectForKey:turnOn]) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                    NSMutableDictionary * temp3 = [NSMutableDictionary dictionaryWithDictionary:[setDics objectForKey:turnOn]];
                    [temp3 setObject:[NSString stringWithFormat:@"%d",CH -1] forKey:@"value1"];
                    
                    [self getRequest:7 requestDic:temp3 characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

//                });

            }
            [NSThread sleepForTimeInterval:0.5];

            NSString * turnOff = [NSString stringWithFormat:@"turnOff%d",i];
            if ([setDics objectForKey:turnOff]) {
//                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                    NSMutableDictionary * temp4 = [NSMutableDictionary dictionaryWithDictionary:[setDics objectForKey:turnOff]];
                    [temp4 setObject:[NSString stringWithFormat:@"%d",CH -1] forKey:@"value1"];
                    
                    [self getRequest:6 requestDic:temp4 characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

//                });

            }
            
        }
        
    });

    
    }
    ifSendMessage = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeView" object:nil];


//    [self moveView];
}
#pragma mark 添加一个view菊花
- (void)creatUIAview{
    
    
    dataView = [[UIView alloc] initWithFrame:self.view.frame];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Device_Wdith, 40)];
    
    label.text = @"Are connecting, please wait a moment...";
    label.center = self.view.center;
    label.textColor = [UIColor blackColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    //    [dataView addSubview:label];
    dataView.backgroundColor = [UIColor clearColor];
    
    UIActivityIndicatorView * aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    aiv.center = CGPointMake(label.center.x, label.center.y - 40);
    aiv.color = [UIColor blueColor];
    [aiv startAnimating];
    
    [dataView addSubview:aiv];
    [self.view addSubview:dataView];
//    [self.view addSubview:aiv];

}


- (void)moveView{
    
    [dataView removeFromSuperview];
}



/**更新设备名称*/
-(void)updateDeviceName
{
    
    
    deviceNameTxt.text = [userdefaults objectForKey:@"DeviceName"];
}


-(void)resultStr:(CBCharacteristic *)characteristics index:(int)index{
    
    if (index == TimeRead) {
//        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"获取到日期信息，数据为%@",characteristics.value]];
        NSLog(@"获取到日期信息，数据为%@",characteristics.value);
        NSString * year,* month,* day,* hour,* minute,* second;
        NSData * data = characteristics.value;
//        Byte *bytee = (Byte *)[data bytes];
        //遍历内容长度
        unsigned char rsp[20];
        [characteristics.value getBytes:&rsp length:20];

        NSLog(@"%s  %@",rsp,data);
        NSString * lengthStr = nil;
        // 将值转成16进制
        NSString *newStr;
        for(int i= 12; i<sizeof(rsp);i++)
        {
            newStr = [NSString stringWithFormat:@"%x",rsp[i]&0xff];///16进制数
            if([newStr length]==1)
                lengthStr = [NSString stringWithFormat:@"0%@",newStr];
            else
                lengthStr = [NSString stringWithFormat:@"%@",newStr];
            
            
            //转换类型
            const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
            int  nResult=(int)strtol(swtr,NULL,16) ;
            switch (i - 8) {
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
            NSString * deviceDate = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
            
            
//            NSLog(@"deviceTime是+++++++++++++%@++++++++++++++++++++++",deviceDate);
            
            timeLabel.text = deviceDate;
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            
//            [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//            
//            NSDate *destDate= [dateFormatter dateFromString:deviceDate];
//            
//            
//            NSTimeInterval late1=[destDate timeIntervalSince1970]*1;
//            
//            
//            
//            NSDate *d2=[NSDate date];
//            
//            NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
//            NSTimeInterval cha=late2-late1;
//            int min = (int)cha/60%60;
//            DateLbl.text =  [dateFormatter stringFromDate:d2];
//            if (min>1) {
//                NSArray * array1 =  [[dateFormatter stringFromDate:d2] componentsSeparatedByString:@" "];
//                NSArray * array2 = [[array1 objectAtIndex:0]componentsSeparatedByString:@":"];
//                NSArray * array3 = [[array1 objectAtIndex:1]componentsSeparatedByString:@":"];
//                
//                
//                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//                
//                NSDateComponents *comps = [[NSDateComponents alloc] init];
//                NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//                NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//                
//                comps = [calendar components:unitFlags fromDate:d2];
//                int weeknum = (int)[comps weekday];
//                if(weeknum ==1)
//                {
//                    weeknum = 7;
//                }
//                else
//                {
//                    weeknum--;
//                }
//                NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"index",[array2 objectAtIndex:0],@"value1",[array2 objectAtIndex:1],@"value2",[array2 objectAtIndex:2],@"value3",weeknum,@"value4",[array3 objectAtIndex:0],@"value5",[array3 objectAtIndex:1],@"value6",[array3 objectAtIndex:2],@"value7",nil];
//                [self getRequest:8 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
//            }
            
        }
    }
    
    if (index == TurnOnStatus||index == TurnOffStatus || index == FristEvent || index == SecondEvent) {
        NSString * chaneStr ;
        NSString * weekStr ;
        NSString * modeStr;
        NSString * valueStr ;
        NSString * hourStr ;
        NSString * minStr;
        
        
        unsigned char rsp[20];
        [characteristics.value getBytes:&rsp length:20];
        NSString * lengthStr = nil;
        // 将值转成16进制
        NSString *newStr;
        for(int i= 12; i<sizeof(rsp);i++)
        {
            newStr = [NSString stringWithFormat:@"%x",rsp[i]&0xff];///16进制数
            lengthStr = [NSString stringWithFormat:@"%@",newStr];
            
            
            //转换类型
            const char *swtr = [lengthStr cStringUsingEncoding:NSASCIIStringEncoding];
            int  nResult=(int)strtol(swtr,NULL,16) ;
            switch (i - 12) {
                case 0:
                    chaneStr = [NSString stringWithFormat:@"%d",nResult];
                    break;
                case 1:
                    weekStr = [NSString stringWithFormat:@"%d",nResult];
                    break;
                case 2:
                    modeStr = [NSString stringWithFormat:@"%d",nResult];
                    break;
                case 3:
                    valueStr = [NSString stringWithFormat:@"%d",nResult];
                    
                    break;
                case 4:
                    hourStr = [NSString stringWithFormat:@"%d",nResult];
                    break;
                case 5:
                    minStr = [NSString stringWithFormat:@"%d",nResult];
                    break;
                default:
                    break;
            }
            
        }
        
        NSInteger  weekDay = [weekStr integerValue];
        NSInteger modeNum = [modeStr integerValue];
        float valueNum = [valueStr floatValue];
        NSInteger hourNum = [hourStr integerValue];
        NSInteger minNum = [minStr integerValue];
        if (index == TurnOnStatus) {
            NSLog(@"读取到开的状态%@",characteristics.value);
            
            switch (modeNum) {
                case 0:
                    [TurnOnBtn setTitle:[NSString stringWithFormat:@"Exactly at Sunset to %.0f%%",valueNum] forState:UIControlStateNormal];
                    break;
                case 1:[TurnOnBtn setTitle:[NSString stringWithFormat:@"After Sunset to %@%%",valueStr] forState:UIControlStateNormal];
                    break;
                case 2:[TurnOnBtn setTitle:[NSString stringWithFormat:@"At%@:%@ to %@%%",hourStr,minStr,valueStr] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        
        if (index == TurnOffStatus) {
            NSLog(@"读取到关的状态%@",characteristics.value);
            
            switch (modeNum) {
                case 0:
                    [TurnOffBtn setTitle:@"Exactly at Sunrise" forState:UIControlStateNormal];
                    break;
                case 1:
                    [TurnOffBtn setTitle:[NSString stringWithFormat:@"After Sunrise"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [TurnOffBtn setTitle:[NSString stringWithFormat:@"At time %@%%",valueStr] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }

            
        }
        
        
        if (index == FristEvent) {
            NSLog(@"读取到event1的状态%@",characteristics.value);
            if (modeNum == 0) {
                [FirstEventBtn setTitle:@"Disable" forState:UIControlStateNormal];
//                [SecondEventBtn setTitle:@"Disable" forState:UIControlStateNormal];

            }else{
                
                if (hourNum < 12) {
                    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@AM to %@%%",hourNum,minStr,valueStr] forState:UIControlStateNormal];

                }else{
                    [FirstEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@PM to %@%%",hourNum -12,minStr,valueStr] forState:UIControlStateNormal];
                }

                
            }
            
        }
        
        if (index == SecondEvent) {
            NSLog(@"读取到event2的状态%@",characteristics.value);
            
            if (modeNum == 0) {
//                [FirstEventBtn setTitle:@"Disable" forState:UIControlStateNormal];
                [SecondEventBtn setTitle:@"Disable" forState:UIControlStateNormal];
                
            }else{
            
                if (hourNum < 12) {
                    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@AM to %@%%",hourNum,minStr,valueStr] forState:UIControlStateNormal];
                    
                }else{
                    [SecondEventBtn setTitle:[NSString stringWithFormat:@"At %d:%@PM to %@%%",hourNum -12,minStr,valueStr] forState:UIControlStateNormal];
                }


            }

            
        }

    }

    
}
//fristSwitchHide控制
- (void)fristSwitchHide{

    if (!fristSwitch.on) {
        SeconddatePicker.hidden = YES;
        Secondslider.hidden = YES;
        SecondLbl.hidden = YES;
//        FirstEventSaveBtn.hidden = YES;
        
//        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"0",@"value3",[NSString stringWithFormat:@"%.0f",Secondslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour2 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second2 intValue]],@"value6", nil];
//        [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];

        
    }else{
    
        SeconddatePicker.hidden = NO;
        Secondslider.hidden = NO;
        SecondLbl.hidden = NO;
//        FirstEventSaveBtn.hidden = NO;
        
    }
    
}
//secondSwitchHide
- (void)secondSwitchHide{

    
    if (!secondSwitch.on) {
        ThirddatePicker.hidden = YES;
        Thirdslider.hidden = YES;
        ThirdLbl.hidden = YES;
//        SecondEventSaveBtn.hidden = YES;
        
//        NSDictionary * temp = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"index",[NSString stringWithFormat:@"%d",CH-1],@"value1",[NSString stringWithFormat:@"%d",(WEEK==-1?255:WEEK)],@"value2",@"0",@"value3",[NSString stringWithFormat:@"%.0f",Secondslider.value],@"value4",[NSString stringWithFormat:@"%d",[hour2 intValue]],@"value5",[NSString stringWithFormat:@"%d",[second2 intValue]],@"value6", nil];
//        [self getRequest:7 requestDic:temp characteristic:self.characteristic  currPeripheral:self.currPeripheral delegate:self];
        
        
    }else{
        
        ThirddatePicker.hidden = NO;
        Thirdslider.hidden = NO;
        ThirdLbl.hidden = NO;
//        SecondEventSaveBtn.hidden = NO;
        
    }

    
}


- (void)stopReadTime{
    
    [tm invalidate];
    tm = nil;
}



//测试读取按钮
- (void)readClick{
    
    NSDictionary * temp = @{@"index":@"0",@"value1":@"0",@"value2":@"1"};
    //    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.specialPeripheralInfo.characteristics delegate:self Baby:self->baby callFrom:DeviceNameRead];
    
    CBCharacteristic * c = [mydelegate.characteristics objectAtIndex:0];
    
    NSLog(@"%@",c.UUID);
    //    [self getRequest:11 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];
    
    
    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
    
}


- (void)readClick1{
    
    
    NSDictionary * temp = @{@"index":@"1",@"value1":@"0",@"value2":@"1"};
    //    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.specialPeripheralInfo.characteristics delegate:self Baby:self->baby callFrom:DeviceNameRead];
    
    CBCharacteristic * c = [mydelegate.characteristics objectAtIndex:0];
    
    NSLog(@"%@",c.UUID);
    //    [self getRequest:11 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];
    
    
    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
    
}

- (void)readClick2{
    
    NSDictionary * temp = @{@"index":@"2",@"value1":@"0",@"value2":@"1"};
    //    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.specialPeripheralInfo.characteristics delegate:self Baby:self->baby callFrom:DeviceNameRead];
    
    CBCharacteristic * c = [mydelegate.characteristics objectAtIndex:0];
    
    NSLog(@"%@",c.UUID);
    //    [self getRequest:11 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];
    
    
    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
    
}

- (void)readClick3{
    
    NSDictionary * temp = @{@"index":@"3",@"value1":@"0",@"value2":@"255"};
    //    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.specialPeripheralInfo.characteristics delegate:self Baby:self->baby callFrom:DeviceNameRead];
    
    CBCharacteristic * c = [mydelegate.characteristics objectAtIndex:0];
    
    NSLog(@"%@",c.UUID);
    //    [self getRequest:11 requestDic:temp characteristic:[mydelegate.specialPeripheralInfo.characteristics objectAtIndex:0]  currPeripheral:self.currPeripheral delegate:self];
    
    
    [self readRequest:11 requestDic:temp currPeripheral:self.currPeripheral characteristicArray:mydelegate.characteristics delegate:self Baby:self->baby callFrom:PreviewRead];
    
}



@end
