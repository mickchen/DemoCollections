//
//  SingletonUpdSocket.h
//  motion
//
//  Created by Apple on 14-5-23.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

#define BASIC_INST              [BasicAPI getInstance]

@interface SingletonUpdSocket : NSObject

+(SingletonUpdSocket*) getInstance;

@end
