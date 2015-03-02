//
//  MotionViewController.h
//  motion
//
//  Created by Apple on 14-5-14.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "FuncDef.h"
#import "util/socket/GCDAsyncSocket.h"

@interface MotionViewController : UIViewController <GCDAsyncSocketDelegate>
{
    
    BOOL isRecordBaseMotionValue;
    
    Attitude baseAttitude;
    
    Attitude preAttitude;
    Attitude maxAttiude;
    Attitude minAttiude;
    
    CGPoint currentPoint;
    CGPoint prePoint;
    
    double distanceX;
    double distanceY;
    
    double radius;
    
    double screenWidth;
    double screenHeight;
    
    double widthRate;       // 空间与手机屏幕的宽度比
    double heightRate;       // 空间与手机屏幕的高度比
    
    double preVelocity;
    
    Coordinate coordinate;
    
    NSMutableArray *xCoordinateArray;
    NSMutableArray *yCoordinateArray;
}

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@property (nonatomic, strong) UIButton *coordinateBtn;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UILabel *rollInfoLabel;
@property (nonatomic, strong) UILabel *pitchInfoLabel;
@property (nonatomic, strong) UILabel *yawInfoLabel;

@property (nonatomic, strong) UILabel *rotaionRateXInfoLabel;
@property (nonatomic, strong) UILabel *rotaionRateYInfoLabel;
@property (nonatomic, strong) UILabel *rotaionRateZInfoLabel;

@property (nonatomic, strong) UIImageView *imageView;

// 界面初始化
-(void) initHeaderBar;

-(void) initView;
-(void) initData;

-(void) initImageView;
-(void) initInfoLabel;

// 初始化motion
-(void) initMotion;

-(void) initCurrentPoint;

-(void) clearView;
-(void) clearMotionData:(id)sender;

-(void) handleMentionData:(CMDeviceMotion*)motion Error:(NSError *)error;

// 开始/停止手机的加速、旋转定位
-(void) startStopMotion:(id)sender;

-(void) initCoordinateSystemWithMotion:(CMDeviceMotion*)motion withFlag:(NSInteger)flag;
-(void) calibrateCoordinateXWithMotion:(CMDeviceMotion*)motion;
-(void) calibrateCoordinateYWithMotion:(CMDeviceMotion*)motion;

-(void) recordMaxMinValue:(CMDeviceMotion*)motion;

// 校准手势范围与屏幕的映射
-(void) calibrationScreenScope;

-(void) phoneViewAndScreenWidthRate;
-(void) phoneViewAndScreenHeightRate;


-(void) back;

@end
