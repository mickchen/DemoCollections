//
//  ConfigViewController.m
//  motion
//
//  Created by Apple on 14-5-22.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import "ConfigViewController.h"
#import "MotionViewController.h"

#define START_X         20
#define START_Y         100
#define LABEL_WIDTH     100
#define LABEL_HEIGHT    30
#define TEXT_FIELD_WIDTH     220
#define TEXT_FIELD_HEIGHT     30


@interface ConfigViewController ()

@end

@implementation ConfigViewController

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
    
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initView
{
    CGFloat viewWidth = self.view.frame.size.width;
    
    UILabel *IPLabel = [[UILabel alloc] init];
    IPLabel.frame = CGRectMake(START_X, START_Y, LABEL_WIDTH, LABEL_HEIGHT);
    IPLabel.text = @"IP:";
    [self.view addSubview:IPLabel];
    
    _IPTextField = [[UITextField alloc] init];
    _IPTextField.frame = CGRectMake(LABEL_HEIGHT + START_X * 2, START_Y, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT);
    _IPTextField.text = @"10.66.195.38";
    [_IPTextField setBorderStyle:UITextBorderStyleBezel];
    [self.view addSubview:_IPTextField];
    
    UILabel *portLabel = [[UILabel alloc] init];
    portLabel.frame = CGRectMake(START_X, START_Y + LABEL_HEIGHT * 2, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT);
    portLabel.text = @"Port:";
    [self.view addSubview:portLabel];
    
    _portTextField = [[UITextField alloc] init];
    _portTextField.frame = CGRectMake(LABEL_HEIGHT + START_X * 2, START_Y + LABEL_HEIGHT * 2, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT);
    _portTextField.text = @"9090";
    [_portTextField setBorderStyle:UITextBorderStyleBezel];
    [self.view addSubview:_portTextField];
    
    UIButton *connectBtn = [[UIButton alloc] init];
    connectBtn.frame = CGRectMake((viewWidth - TEXT_FIELD_WIDTH) / 2, START_Y + LABEL_HEIGHT * 4, TEXT_FIELD_WIDTH, TEXT_FIELD_HEIGHT * 1.5);
    [connectBtn setBackgroundColor:[UIColor lightGrayColor]];
    [connectBtn setTitle:@"连接" forState:UIControlStateNormal];
    [self.view addSubview:connectBtn];
    connectBtn.showsTouchWhenHighlighted = YES;
    [connectBtn addTarget:self action:@selector(initSocket:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) initSocket:(id)sender
{
    NSString *IP = [_IPTextField text];
    NSString *port = [_portTextField text];
    
    if (!IP || [IP length] == 0 ||
        !port || [port length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整的信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return;
    }
    
    NSLog(@"IP:%@", IP);
    NSLog(@"port:%@", port);
    
    NSError *error1;
    asyncUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [asyncUdpSocket setIPv6Enabled:NO];
    [asyncUdpSocket setIPv4Enabled:YES];
    
    NSString *message = @"connect";
    [asyncUdpSocket enableBroadcast:YES error:&error1];
    [asyncUdpSocket sendData:[message dataUsingEncoding:NSUTF8StringEncoding]  toHost:IP port:[port intValue] withTimeout:5 tag:10];
    
    NSError *error2;
    if ([asyncUdpSocket beginReceiving:&error2] == NO) {
        NSLog(@"beginReceiving : error");
    }
}

#pragma mark -udpSocket
-(void) udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    if (sock) {
        NSLog(@"%@-%d: %@", [GCDAsyncUdpSocket hostFromAddress:address], [GCDAsyncUdpSocket portFromAddress:address], [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        if ([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"connect success."]) {
            [asyncUdpSocket pauseReceiving];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
            return;
        }
    }
}

-(void) udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    if (tag == 10) {
        NSLog(@"Send Data:%@", error);
    }
}

#pragma mark -alertView
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *btnTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([btnTitle isEqualToString:@"确定"]) {
        MotionViewController *motionViewController = [[MotionViewController alloc] init];
//        [motionViewController setUpdSocket:asyncUdpSocket];
        [self.navigationController pushViewController:motionViewController animated:YES];
    }
}



@end
