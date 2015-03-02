//
//  ConnectViewController.h
//  motion
//
//  Created by Apple on 14-5-23.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "util/socket/GCDAsyncSocket.h"

@interface ConnectViewController : UIViewController <GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *asyncSocket;
}

@property (nonatomic, strong) UITextField *IPTextField;
@property (nonatomic, strong) UITextField *portTextField;

@property (nonatomic, strong) NSString *IP;
@property (nonatomic, strong) NSString *port;

-(void) initView;

-(void) initSocket:(id)sender;

@end
