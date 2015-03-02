//
//  SingletonUpdSocket.m
//  motion
//
//  Created by Apple on 14-5-23.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import "SingletonUpdSocket.h"

static SingletonUpdSocket *singletonUpdSocketInstance;

@implementation SingletonUpdSocket

+(void) initialize
{
    static BOOL isInitialized = NO;
    
    if (!isInitialized)
    {
        isInitialized = YES;
        
        singletonUpdSocketInstance = [[SingletonUpdSocket alloc] init];
    }
}

+(SingletonUpdSocket*) getInstance
{
    return singletonUpdSocketInstance;
}

-(id) init
{
	if (singletonUpdSocketInstance != nil)
    {
		return singletonUpdSocketInstance;
	}
    
	self = [super init];
    
	return self;
}

@end
