//
//  BasicAPI.h
//  BlueToothClient
//
//  Created by Apple on 14-4-23.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASIC_INST              [BasicAPI getInstance]

@interface BasicAPI : NSObject

+(BasicAPI*) getInstance;

-(void) drawLine:(UIView*)view withStartPoint:(CGPoint)startPoint withEndPoint:(CGPoint)endPoint;

-(void) clearImage:(UIView*)view withColor:(UIColor*)color;

/**
 * shot cut the number
 *
 * @param number  input number
 * @param count  figures after the point
 * return the result
 */
-(NSString*) shotCutNumber:(double)number withCount:(NSInteger)count;

/**
 * filter the valid rotaion rate
 *
 * @param baseline
 * @return result YES,if Meet the requirements. otherwise NO
 */
-(BOOL) isValidData:(double)baseline withInput:(double)data;

-(double) calcXCoordinate:(double)radius withRadian:(double)radian;
-(double) calcYCoordinate:(double)radius withRadian:(double)radian;

-(double) calcDistance:(double)acceleration withInterval:(double)interval;
-(double) calcRadius:(double)distance withRadian:(double)radian;

@end
