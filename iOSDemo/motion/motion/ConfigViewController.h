//
//  ConfigViewController.h
//  motion
//
//  Created by Apple on 14-5-22.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "util/socket/GCDAsyncSocket.h"
#import "util/socket/GCDAsyncUdpSocket.h"

@interface ConfigViewController : UIViewController <GCDAsyncUdpSocketDelegate, UIAlertViewDelegate>
{
    GCDAsyncUdpSocket *asyncUdpSocket;
}

@property (nonatomic, strong) UITextField *IPTextField;
@property (nonatomic, strong) UITextField *portTextField;

@property (nonatomic, strong) NSString *IP;
@property (nonatomic, strong) NSString *port;

-(void) initView;

-(void) initSocket:(id)sender;

@end
