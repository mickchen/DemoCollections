//
//  FuncDef.h
//  motion
//
//  Created by Apple on 14-5-16.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#ifndef motion_FuncDef_h
#define motion_FuncDef_h


/**
 * define the coordinate
 */
typedef struct
{
    double radius;
    double coordinateXRange;
    double coordinateYRange;
} Coordinate;

/**
 * define 
 */
typedef struct
{
    double roll;
    double pitch;
    double yaw;
} Attitude;


#pragma pack(1)

typedef struct
{
    short msgLen;
    UInt8 msgType;
    float widthRate;
    float heightRate;
} RateMsg;

#pragma pack()

#pragma pack(1)

typedef struct
{
    short msgLen;
    UInt8 msgType;
    float width;
    float height;
} ScreenSizeMsg;

#pragma pack()


#pragma pack(1)

typedef struct
{
    short msgLen;
    UInt8 msgType;
    float pos1X;
    float pos1Y;
    float pos2X;
    float pos2Y;
    float diffRoll;         // 以手机旋转来代替鼠标的点击（可区分左转、右转）
} PosMsg;

#pragma pack()

#pragma pack(1)

typedef struct
{
    short msgLen;
    UInt8 msgType;
    int32_t director;
} MoveMsg;

#pragma pack()

#endif
