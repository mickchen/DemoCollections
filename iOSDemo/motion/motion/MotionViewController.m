//
//  MotionViewController.m
//  motion
//
//  Created by Apple on 14-5-14.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import "MotionViewController.h"
#import "util/BasicAPI.h"
#import "Constants.h"
#import "FuncDef.h"

#define TIME_INTERVAL       (0.02)
#define PI      (3.1415926)
#define BASE_LINE_VALUE      (0.1)
#define CENTER_X        (self.view.frame.size.width / 2)
#define CENTER_Y        (self.view.frame.size.height / 2)
#define MAX_RADIUS          (0.8)
#define MIN_RADIUS          (0.4)
#define COORDINATE_X        (0)
#define COORDINATE_Y        (1)
#define HEADER_BAR_HEIGHT       (40)

#define START_Y             ([[UIDevice currentDevice].systemVersion doubleValue] > 7.0 ? 20 : 0)

#define RADIUS      (0.7)


@interface MotionViewController ()

@end

@implementation MotionViewController

@synthesize asyncSocket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initCurrentPoint];
    [self initData];
    [self initView];
    [self initMotion];
    
    if (asyncSocket) {
        [asyncSocket setDelegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initCurrentPoint
{
    CGFloat height = self.view.frame.size.height;
    CGFloat width = self.view.frame.size.width;
    
    currentPoint.x = width / 2;
    currentPoint.y =  height/ 2;
}

-(void) initView
{
    [self initHeaderBar];
    [self initImageView];
    [self initInfoLabel];
    
    _coordinateBtn = [[UIButton alloc] init];
    _coordinateBtn.layer.cornerRadius = 2.0f;
    _coordinateBtn.frame = CGRectMake(60, HEADER_BAR_HEIGHT + 100, 200, 50);
    [_coordinateBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_coordinateBtn setTitle:@"校准" forState:UIControlStateNormal];
    [self.view addSubview:_coordinateBtn];
    [_coordinateBtn addTarget:self action:@selector(startStopXCalibration:) forControlEvents:UIControlEventTouchUpInside];
    
    _btn = [[UIButton alloc] init];
    _btn.layer.cornerRadius = 2.0f;
    _btn.frame = CGRectMake(60, HEADER_BAR_HEIGHT + 170, 200, 50);
    [_btn setBackgroundColor:[UIColor lightGrayColor]];
    [_btn setTitle:@"开始" forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(startStopMotion:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn];
    
    
    UIButton *leftBtn = [[UIButton alloc] init];
    leftBtn.layer.cornerRadius = 2.0f;
    leftBtn.frame = CGRectMake(60, HEADER_BAR_HEIGHT + 250, 200, 50);
    [leftBtn setBackgroundColor:[UIColor lightGrayColor]];
    [leftBtn setTitle:@"左" forState:UIControlStateNormal];
    [self.view addSubview:leftBtn];
    [leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightBtn = [[UIButton alloc] init];
    rightBtn.layer.cornerRadius = 2.0f;
    rightBtn.frame = CGRectMake(60, HEADER_BAR_HEIGHT + 320, 200, 50);
    [rightBtn setBackgroundColor:[UIColor lightGrayColor]];
    [rightBtn setTitle:@"右" forState:UIControlStateNormal];
    [self.view addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) leftAction:(id)sender
{
    MoveMsg moveMsg;
    moveMsg.msgLen = 5;
    moveMsg.msgType = 4;
    moveMsg.director = 1;
    
    NSData *data = [[NSData alloc] initWithBytes:&moveMsg length:sizeof(moveMsg)];
    
    [asyncSocket writeData:data withTimeout:-1 tag:MSG_TYPE_POS];
}

-(void) rightAction:(id)sender
{
    MoveMsg moveMsg;
    moveMsg.msgLen = 5;
    moveMsg.msgType = 4;
    moveMsg.director = 2;
    
    NSData *data = [[NSData alloc] initWithBytes:&moveMsg length:sizeof(moveMsg)];
    
    [asyncSocket writeData:data withTimeout:-1 tag:MSG_TYPE_POS];
}

-(void) initHeaderBar
{
    CGFloat viewWidth = self.view.frame.size.width;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, START_Y, viewWidth, HEADER_BAR_HEIGHT);
    [label setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(15, START_Y + 10, 40, 20);
    [btn setTitle:@"back" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

-(void) back
{
    [asyncSocket disconnect];
    asyncSocket.delegate = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) initData
{
    xCoordinateArray = [[NSMutableArray alloc] init];
    yCoordinateArray = [[NSMutableArray alloc] init];
    
    baseAttitude.roll = 0;
    baseAttitude.pitch = 0;
    baseAttitude.yaw = 0;
    
    preAttitude.roll = 0;
    preAttitude.pitch = 0;
    preAttitude.yaw = 0;
    
    maxAttiude.roll = 0;
    maxAttiude.pitch = 0;
    maxAttiude.yaw = 0;
    
    minAttiude.roll = 0;
    minAttiude.pitch = 0;
    minAttiude.yaw = 0;
    
    preVelocity = 0;
}

// 开始/结束 X 校准
-(void) startStopXCalibration:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if (!btn) {
        return;
    }

    if ([btn.titleLabel.text isEqualToString:@"校准"]) {
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self initCoordinateSystemWithMotion:motion withFlag:COORDINATE_X];
        }];
    }
    else if ([btn.titleLabel.text isEqualToString:@"完成"])
    {
        [_motionManager stopDeviceMotionUpdates];
        [btn setTitle:@"校准" forState:UIControlStateNormal];
        
        [self calibrationScreenScope];
        [self phoneViewAndScreenWidthRate];
        [self phoneViewAndScreenHeightRate];
        
        ScreenSizeMsg screenSizeMsg;
        screenSizeMsg.msgLen = 9;
        screenSizeMsg.msgType = MSG_TYPE_SCREEN_SIZE;
        screenSizeMsg.width = screenWidth;
        screenSizeMsg.height = screenHeight;
        
        NSLog(@"screenWidth:%f", screenWidth);
        NSLog(@"screenHeight:%f", screenHeight);
        NSLog(@"rateMsg.msgType:%d", screenSizeMsg.msgType);
        
        
//        unsigned char *szbuff = (unsigned char*)&rateMsg;
//        for (int i = 0; i < sizeof(rateMsg); i++) {
//            NSLog(@"---%02X", szbuff[i]);
//        }
        
        NSData *data = [[NSData alloc] initWithBytes:&screenSizeMsg length:sizeof(screenSizeMsg)];
        NSLog(@"%@", data);
        [asyncSocket writeData:data withTimeout:-1 tag:MSG_TYPE_SCREEN_SIZE];
    }
}

-(void) startStopMotion:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    
    if (!btn) {
        return;
    }
    
    if ([btn.titleLabel.text isEqualToString:@"开始"]) {
        [self clearMotionData:sender];
        [self clearView];
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self handleMentionData:motion Error:error];;
        }];
        [btn setTitle:@"停止" forState:UIControlStateNormal];
    }
    
    else if ([btn.titleLabel.text isEqualToString:@"停止"]) {
        isRecordBaseMotionValue = NO;
        [btn setTitle:@"开始" forState:UIControlStateNormal];
        [_motionManager stopDeviceMotionUpdates];
    }
}

-(void) clearMotionData:(id)sender
{
    _rollInfoLabel.text = @"0.00";
    _pitchInfoLabel.text = @"0.00";
    _yawInfoLabel.text = @"0.00";
    
    _rotaionRateXInfoLabel.text = @"0.00";
    _rotaionRateYInfoLabel.text = @"0.00";
    _rotaionRateZInfoLabel.text = @"0.00";
    
    currentPoint.x = 0;
    currentPoint.y = 0;
    
    _rotaionRateYInfoLabel.text = @"0.00";
    
    preAttitude.roll = 0;
    preAttitude.pitch = 0;
    preAttitude.yaw = 0;
    
    preVelocity = 0;
}

-(void) clearView
{
    [BASIC_INST clearImage:_imageView withColor: _imageView.backgroundColor];
    [self initCurrentPoint];
}

-(void) initImageView
{
    CGFloat viewWidth = self.view.frame.size.width;
    CGFloat viewHeight = self.view.frame.size.height;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, START_Y + HEADER_BAR_HEIGHT, viewWidth, viewHeight);
    [_imageView setBackgroundColor:[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]];
    
    [self.view addSubview:_imageView];
}

-(void) initInfoLabel
{
    UILabel *rollLabel = [[UILabel alloc] init];
    [rollLabel setBackgroundColor:[UIColor clearColor]];
    rollLabel.frame = CGRectMake(20, HEADER_BAR_HEIGHT + 30, 50, 20);
    rollLabel.text = @"roll:";

    _rollInfoLabel = [[UILabel alloc] init];
    [_rollInfoLabel setBackgroundColor:[UIColor clearColor]];
    _rollInfoLabel.frame = CGRectMake(70, HEADER_BAR_HEIGHT + 30, 60, 20);
    _rollInfoLabel.text = @"0.00";

    [self.view addSubview:rollLabel];
    [self.view addSubview:_rollInfoLabel];

    UILabel *pitchLabel = [[UILabel alloc] init];
    [pitchLabel setBackgroundColor:[UIColor clearColor]];
    pitchLabel.frame = CGRectMake(20, HEADER_BAR_HEIGHT + 50, 50, 20);

    pitchLabel.text = @"pitch:";

    _pitchInfoLabel = [[UILabel alloc] init];
    [_pitchInfoLabel setBackgroundColor:[UIColor clearColor]];
    _pitchInfoLabel.frame = CGRectMake(70, HEADER_BAR_HEIGHT + 50, 60, 20);
    _pitchInfoLabel.text = @"0.00";

    [self.view addSubview:pitchLabel];
    [self.view addSubview:_pitchInfoLabel];

    UILabel *yawLabel = [[UILabel alloc] init];
    yawLabel.frame = CGRectMake(20, HEADER_BAR_HEIGHT + 70, 50, 20);
    [yawLabel setBackgroundColor:[UIColor clearColor]];
    yawLabel.text = @"yaw:";

    _yawInfoLabel = [[UILabel alloc] init];
    _yawInfoLabel.frame = CGRectMake(70, HEADER_BAR_HEIGHT + 70, 60, 20);
    _yawInfoLabel.text = @"0.00";
    [_yawInfoLabel setBackgroundColor:[UIColor clearColor]];

    [self.view addSubview:yawLabel];
    [self.view addSubview:_yawInfoLabel];
    
    
    UILabel *rotaionRateXLabel = [[UILabel alloc] init];
    [rotaionRateXLabel setBackgroundColor:[UIColor clearColor]];
    rotaionRateXLabel.frame = CGRectMake(160, HEADER_BAR_HEIGHT + 30, 120, 20);
    rotaionRateXLabel.text = @"rotaionRateX:";
    
    _rotaionRateXInfoLabel = [[UILabel alloc] init];
    [_rotaionRateXInfoLabel setBackgroundColor:[UIColor clearColor]];
    _rotaionRateXInfoLabel.frame = CGRectMake(270, HEADER_BAR_HEIGHT + 30, 100, 20);
    _rotaionRateXInfoLabel.text = @"0.00";
    
    [self.view addSubview:rotaionRateXLabel];
    [self.view addSubview:_rotaionRateXInfoLabel];
    
    UILabel *rotaionRateYLabel = [[UILabel alloc] init];
    [rotaionRateYLabel setBackgroundColor:[UIColor clearColor]];
    rotaionRateYLabel.frame = CGRectMake(160, HEADER_BAR_HEIGHT + 50, 120, 20);
    rotaionRateYLabel.text = @"rotaionRateY:";
    
    _rotaionRateYInfoLabel = [[UILabel alloc] init];
    [_rotaionRateYInfoLabel setBackgroundColor:[UIColor clearColor]];
    _rotaionRateYInfoLabel.frame = CGRectMake(270, HEADER_BAR_HEIGHT + 50, 100, 20);
    _rotaionRateYInfoLabel.text = @"0.00";
    
    [self.view addSubview:rotaionRateYLabel];
    [self.view addSubview:_rotaionRateYInfoLabel];
    
    UILabel *rotaionRateZLabel = [[UILabel alloc] init];
    rotaionRateZLabel.frame = CGRectMake(160, HEADER_BAR_HEIGHT + 70, 120, 20);
    [rotaionRateZLabel setBackgroundColor:[UIColor clearColor]];
    rotaionRateZLabel.text = @"rotaionRateZ:";
    
    _rotaionRateZInfoLabel = [[UILabel alloc] init];
    [_rotaionRateZInfoLabel setBackgroundColor:[UIColor clearColor]];
    _rotaionRateZInfoLabel.frame = CGRectMake(270, HEADER_BAR_HEIGHT + 70, 100, 20);
    _rotaionRateZInfoLabel.text = @"0.00";
    
    [self.view addSubview:rotaionRateZLabel];
    [self.view addSubview:_rotaionRateZInfoLabel];
}

// 初始化motion
-(void) initMotion
{
    _motionManager = [[CMMotionManager alloc] init];

    if (_motionManager.deviceMotionAvailable == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，此设备不支持三轴陀螺仪" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];

        [alert show];
        return;
    }

    // 刷新三轴陀螺仪频率设置
    _motionManager.deviceMotionUpdateInterval = TIME_INTERVAL;
    _motionManager.showsDeviceMovementDisplay = YES;
}

-(void) recordMaxMinValue:(CMDeviceMotion*)motion
{
    if (motion.attitude.roll > maxAttiude.roll) {
        maxAttiude.roll = motion.attitude.roll;
    }
    
    if (motion.attitude.roll < minAttiude.roll) {
        minAttiude.roll = motion.attitude.roll;
    }
    
    if (motion.attitude.pitch > maxAttiude.pitch) {
        maxAttiude.pitch = motion.attitude.pitch;
    }
    
    if (motion.attitude.pitch < minAttiude.pitch) {
        minAttiude.pitch = motion.attitude.pitch;
    }
    
    if (motion.attitude.yaw > maxAttiude.yaw) {
        maxAttiude.yaw = motion.attitude.yaw;
    }
    
    if (motion.attitude.yaw < minAttiude.yaw) {
        minAttiude.yaw = motion.attitude.yaw;
    }
}

-(void) handleMentionData:(CMDeviceMotion*)motion Error:(NSError *)error
{
    if (!motion)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"Error Code:%ld", (long)error.code] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [alertView show];
        return;
    }
    
    // 记录下基准值
    if (isRecordBaseMotionValue == NO) {
        preAttitude.roll = baseAttitude.roll = motion.attitude.roll;
        preAttitude.pitch = baseAttitude.pitch = motion.attitude.pitch;
        preAttitude.yaw = baseAttitude.yaw = motion.attitude.yaw;
        
        isRecordBaseMotionValue = YES;
        
        prePoint.y = screenHeight / 2;
        prePoint.x = screenWidth / 2;
    }
    
    
    // 与上次相比，此次旋转的变化
    double diffRoll = 0;
    if (fabs(motion.attitude.roll - preAttitude.roll) > BASE_LINE_VALUE) {
        diffRoll = motion.attitude.roll - preAttitude.roll;
        _rollInfoLabel.text = [BASIC_INST shotCutNumber:diffRoll withCount:3];
        preAttitude.roll = motion.attitude.roll;
    }
    
    double diffPitch = 0;
    if (fabs(motion.attitude.pitch - preAttitude.pitch) > BASE_LINE_VALUE) {
        diffPitch = motion.attitude.pitch - preAttitude.pitch;
        _pitchInfoLabel.text = [BASIC_INST shotCutNumber:diffPitch withCount:3];
        preAttitude.pitch = motion.attitude.pitch;
    }
    
    double diffYaw = 0;
    if (fabs(motion.attitude.yaw - preAttitude.yaw) > BASE_LINE_VALUE) {
        diffYaw = motion.attitude.yaw - preAttitude.yaw;
        _yawInfoLabel.text = [BASIC_INST shotCutNumber:diffYaw withCount:3];
        preAttitude.yaw = motion.attitude.yaw;
    }
    
    if (diffRoll == 0 && diffPitch == 0 && diffYaw == 0) {
        return;
    }

    // 因为规定手机是水平拿着的，所以yaw确定为水平的移动, pitch为垂直
    
    NSLog(@"diffRoll:%f", diffRoll);
    NSLog(@"diffPitch:%f", diffPitch);
    NSLog(@"diffYaw:%f", diffYaw);
    
    
    double horizontalDistance = sin(diffYaw / 2) * RADIUS * 2;
    double verticalDistance = sin(diffPitch / 2) * RADIUS * 2;
    
    currentPoint.x = prePoint.x + verticalDistance;
    currentPoint.y = prePoint.y + horizontalDistance;
    
    PosMsg posMsg;
    posMsg.msgLen = 21;
    posMsg.msgType = MSG_TYPE_POS;
    posMsg.pos1X = prePoint.x;
    posMsg.pos1Y = prePoint.y;
    posMsg.pos2X = currentPoint.x;
    posMsg.pos2Y = currentPoint.y;
    posMsg.diffRoll = diffRoll;         // 获取旋转，此旋转可以作为类似鼠标的点击事件（可分为左键、右键）
    
    
//    NSLog(@"---msgLen:%d", posMsg.msgLen);
//    NSLog(@"---msgType:%d", posMsg.msgType);
//    NSLog(@"---pos1X:%f", posMsg.pos1X);
//    NSLog(@"---pos1Y:%f", posMsg.pos1Y);
//    
//    NSLog(@"---pos2X:%f", posMsg.pos2X);
//    NSLog(@"---pos2Y:%f", posMsg.pos2Y);
//    
//    NSLog(@"---diffRoll:%f", posMsg.diffRoll);
    
    NSData *data = [[NSData alloc] initWithBytes:&posMsg length:sizeof(posMsg)];
    
    [asyncSocket writeData:data withTimeout:-1 tag:MSG_TYPE_POS];
    
    
    // 画图
//    [BASIC_INST drawLine:_imageView withStartPoint:prePoint withEndPoint:currentPoint];
    prePoint.x = currentPoint.x;
    prePoint.y = currentPoint.y;
}

-(void) phoneViewAndScreenWidthRate
{
    widthRate =  _imageView.frame.size.width / screenHeight;
}

-(void) phoneViewAndScreenHeightRate
{
    heightRate =  _imageView.frame.size.height / screenWidth;
}

-(void) initCoordinateSystemWithMotion:(CMDeviceMotion*)motion withFlag:(NSInteger)flag
{
    [self calibrateCoordinateXWithMotion:motion];
    [self calibrateCoordinateYWithMotion:motion];
}

-(void) calibrateCoordinateXWithMotion:(CMDeviceMotion*)motion
{
    // 记录最大、最小的值, 以确定移动的范围，以此来确定与屏幕的比例
    [self recordMaxMinValue:motion];
}

-(void) calibrateCoordinateYWithMotion:(CMDeviceMotion*)motion
{
    // 记录最大、最小的值, 以确定移动的范围，以此来确定与屏幕的比例
    [self recordMaxMinValue:motion];
}

// 校准手势范围与屏幕的映射
-(void) calibrationScreenScope
{
//    double maxRoll = maxAttiude.roll;
//    double minRoll = minAttiude.roll;
    
    double maxPitch = maxAttiude.pitch;
    double minPitch = minAttiude.pitch;
    
    double maxYaw = maxAttiude.yaw;
    double minYaw = minAttiude.yaw;
    
    screenWidth = sin((maxYaw - minYaw) / 2) * RADIUS * 2;
    screenHeight =  sin((maxPitch - minPitch) / 2) * RADIUS * 2;
}


#pragma mark -GCDAsyncSocketDelegate
-(void) socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (sock) {
        NSLog(@"Info Tag:%ld", tag);
    }
}

@end
