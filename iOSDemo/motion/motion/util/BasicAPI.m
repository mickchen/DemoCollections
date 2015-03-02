//
//  BasicAPI.m
//  BlueToothClient
//
//  Created by Apple on 14-4-23.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import "BasicAPI.h"

static BasicAPI *basicApiInstance;

@implementation BasicAPI

+(void) initialize
{
    static BOOL isInitialized = NO;
    
    if (!isInitialized)
    {
        isInitialized = YES;
        
        basicApiInstance = [[BasicAPI alloc] init];
    }
}

+(BasicAPI*) getInstance
{
    return basicApiInstance;
}

-(id) init
{
	if (basicApiInstance != nil)
    {
		return basicApiInstance;
	}
    
	self = [super init];
    
	return self;
}

-(void) drawLine:(UIView*)view withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint
{
    if ([view isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView*)view;
        UIGraphicsBeginImageContext(imageView.frame.size);
        [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
        CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), startPoint.x, startPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), endPoint.x, endPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageView.image=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

-(void) clearImage:(UIView*)view withColor:(UIColor*)color
{
    if ([view isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView*)view;
        UIGraphicsBeginImageContext(imageView.frame.size);

        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);

        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}


/**
 * shot cut the number
 *
 * @param number  input number
 * @param count  figures after the point
 * return the result
 */
-(NSString*) shotCutNumber:(double)number withCount:(NSInteger)count
{
    NSString *inputNumber = [NSString stringWithFormat:@"%f", number];
    
    NSInteger numberLength = [inputNumber length];
    NSInteger pointLocation = [inputNumber rangeOfString:@"."].location;
    NSInteger pointLenght = [inputNumber rangeOfString:@"."].length;

    if (count <= 0) {
        if (pointLenght > 0) {
            return [inputNumber substringToIndex:pointLocation];
        }
        else{
            return inputNumber;
        }
    }
    else
    {
        if (pointLocation + count <= numberLength) {
            return [inputNumber substringToIndex:pointLocation + count];
        }
        else
        {
            return inputNumber;
        }
    }
}

-(BOOL) isValidData:(double)baseline withInput:(double)data
{
    return fabs(baseline) > fabs(data) ? NO : YES;
}

-(double) calcXCoordinate:(double)radius withRadian:(double)radian
{
    double X = sin(radian) * radius;
    return X;
}
-(double) calcYCoordinate:(double)radius withRadian:(double)radian
{
    
    double Y = cos(radian) * radius;
    return Y;
}

-(double) calcDistance:(double)acceleration withInterval:(double)interval
{
    return acceleration * interval * interval;
}

-(double) calcRadius:(double)distance withRadian:(double)radian
{
    return distance / radian;
}


//    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
//
//        [self handleMentionData:motion Error:error];


//        double accelerationX = motion.userAcceleration.x * (-1);
//        double accelerationY = motion.userAcceleration.y;
//
//        if (sqrt(accelerationX * accelerationX + accelerationY * accelerationY) < 0.4)
//        {
//            return ;
//        }
//
//        double distx = accelerationX * 0.02 * 0.02;
//        double disty = accelerationY * 0.02 * 0.02;
//
////        NSLog(@"distx:%f", distx);
////        NSLog(@"disty:%f", disty);
//
//        //  将空间移动的距离转换成像素 以1cm ＝ 1 pixel
//        CGFloat XPixel = distx * 50000;//floor(distx * 1000);
//        CGFloat YPixel = disty * 50000;//floor(disty * 1000);
//
////        if (XPixel < 0 || YPixel < 0) {
////            NSLog(@"XPixel:%f", XPixel);
////            NSLog(@"YPixel:%f", YPixel);
////        }
//
//        CGPoint startPoint = currentPoint;
//
//        currentPoint.x = currentPoint.x + XPixel;
//        currentPoint.y = currentPoint.y + YPixel;
//
//        CGPoint endPoint = currentPoint;
//
//        NSLog(@"startPoint X:%f", startPoint.x);
//        NSLog(@"startPoint Y:%f", startPoint.y);
//        NSLog(@"endPoint X:%f", endPoint.x);
//        NSLog(@"endPoint Y:%f", endPoint.y);
//
//        [BASIC_INST drawLine:_imageView withStartPoint:startPoint withEndPoint:endPoint];
//    }];



//// 界面初始化
//-(void) initView
//{
//    _btn = [[UIButton alloc] init];
//    _btn.layer.cornerRadius = 2.0f;
//    _btn.frame = CGRectMake(50, 200, 200, 50);
//    [_btn setBackgroundColor:[UIColor lightGrayColor]];
//    [_btn setTitle:@"开始" forState:UIControlStateNormal];
//    [_btn addTarget:self action:@selector(startStopMotion:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_btn];
//
//    UILabel *rollLabel = [[UILabel alloc] init];
//    rollLabel.frame = CGRectMake(20, 30, 50, 20);
//    rollLabel.text = @"roll:";
//
//    _label1 = [[UILabel alloc] init];
//    _label1.frame = CGRectMake(70, 30, 60, 20);
//    _label1.text = @"0.00";
//
//    [self.view addSubview:rollLabel];
//    [self.view addSubview:_label1];
//
//    UILabel *pitchLabel = [[UILabel alloc] init];
//    pitchLabel.frame = CGRectMake(20, 50, 50, 20);
//
//    pitchLabel.text = @"pitch:";
//
//    _label2 = [[UILabel alloc] init];
//    _label2.frame = CGRectMake(70, 50, 60, 20);
//    _label2.text = @"0.00";
//
//    [self.view addSubview:pitchLabel];
//    [self.view addSubview:_label2];
//
//    UILabel *yawLabel = [[UILabel alloc] init];
//    yawLabel.frame = CGRectMake(20, 70, 50, 20);
//
//    yawLabel.text = @"yaw:";
//
//    _label3 = [[UILabel alloc] init];
//    _label3.frame = CGRectMake(70, 70, 60, 20);
//    _label3.text = @"0.00";
//
//    [self.view addSubview:yawLabel];
//    [self.view addSubview:_label3];
//
//
//    UILabel *distanceLabel = [[UILabel alloc] init];
//    distanceLabel.frame = CGRectMake(20, 90, 70, 20);
//
//    distanceLabel.text = @"distance:";
//
//    _distance = [[UILabel alloc] init];
//    _distance.frame = CGRectMake(90, 90, 60, 20);
//    _distance.text = @"0.00";
//
//    [self.view addSubview:distanceLabel];
//    [self.view addSubview:_distance];
//}


// 暂时注释掉此部分



//// 初始化motion
//-(void) initMotion
//{
//    // motion manager的初始化
//    _motionManager = [[CMMotionManager alloc] init];
//
//    if (_motionManager.accelerometerAvailable == NO)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，此设备不支持加速传感器" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//        [alert show];
//        return;
//    }
//
//    if (_motionManager.deviceMotionAvailable == NO) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，此设备不支持三轴陀螺仪" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//        [alert show];
//        return;
//    }
//
//    if (_motionManager.gyroAvailable == NO) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不好意思，此设备不支持三轴陀螺仪" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//
//        [alert show];
//        return;
//    }
//
//    _motionManager.gyroUpdateInterval = 1;
//
//    // 刷新的加速频率设置为100HZ
//    _motionManager.accelerometerUpdateInterval = 0.5;
//
//    // 刷新三轴陀螺仪频率设置
//    _motionManager.deviceMotionUpdateInterval = 0.01;
//    _motionManager.showsDeviceMovementDisplay = YES;
//}




//// 开始
//-(void) startStopMotion:(id)sender
//{
//    UIButton *btn = (UIButton*)sender;
//
//    if ([btn.titleLabel.text isEqualToString:@"开始"])
//    {
//        [_btn setTitle:@"结束" forState:UIControlStateNormal];
//        _distance.text = @"0.00";
//
//        // 采用push方式
////        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
////
//////            NSLog(@"accelerate1 X:%f", accelerometerData.acceleration.x);
//////            NSLog(@"accelerate Y:%f", accelerometerData.acceleration.y);
//////            NSLog(@"accelerate Z:%f", accelerometerData.acceleration.z);
////        }];
//
//        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
////            NSLog(@"accelerate2 X:%f", motion.rotationRate.x);
////            NSLog(@"accelerate2 Y:%f", motion.rotationRate.y);
////            NSLog(@"accelerate2 Z:%f", motion.rotationRate.z);
//
//            if (isMotionValueInited == NO) {
//                roll = motion.attitude.roll;
//                pitch = motion.attitude.pitch;
//                yaw = motion.attitude.yaw;
//                isMotionValueInited = YES;
//            }
//
//            NSInteger i = 4;
//            NSInteger j = 4;
//            NSInteger k = 4;
//            if (motion.attitude.roll - roll < 0) {
//                i = 5;
//            }
//            if (motion.attitude.pitch - pitch < 0) {
//                j = 5;
//            }
//            if (motion.attitude.yaw - yaw < 0) {
//                k = 5;
//            }
//
//            _label1.text = [[NSString stringWithFormat:@"%f", motion.attitude.roll - roll] substringToIndex:i];
//            _label2.text = [[NSString stringWithFormat:@"%f", motion.attitude.pitch - pitch] substringToIndex:j];
//            _label3.text = [[NSString stringWithFormat:@"%f", motion.attitude.yaw - yaw] substringToIndex:k];
//
//            double acceleration = motion.userAcceleration.x * motion.userAcceleration.x + motion.userAcceleration.y * motion.userAcceleration.y;
//
//            if (acceleration > 0.2) {
//                NSLog(@"***************");
//                dist += sqrt(motion.rotationRate.x * 0.01 * motion.rotationRate.x * 0.01 + motion.rotationRate.y * 0.01 * motion.rotationRate.y * 0.01);
//
//
//                NSLog(@"distance%@", [NSString stringWithFormat:@"%f", dist]);
//            }
//            else{
//                if (dist > 0.1)
//                {
//                    _distance.text = [[NSString stringWithFormat:@"%f", dist] substringToIndex:4];
//                }
//
//                return ;
//            }
//        }];
//
////        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
//////            NSLog(@"motion X:%f", gyroData.rotationRate.x);
//////            NSLog(@"motion Y:%f", gyroData.rotationRate.y);
//////            NSLog(@"motion Z:%f", gyroData.rotationRate.z);
////        }];
//
//    }
//    else if ([btn.titleLabel.text isEqualToString:@"结束"])
//    {
//        [_btn setTitle:@"开始" forState:UIControlStateNormal];
//        [_motionManager stopAccelerometerUpdates];
////        [_motionManager stopGyroUpdates];
//        [_motionManager stopDeviceMotionUpdates];
//        dist = 0;
//        isMotionValueInited = NO;
//    }
//}

@end
