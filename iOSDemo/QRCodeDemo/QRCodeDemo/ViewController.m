//
//  ViewController.m
//  QRCodeDemo
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import "ViewController.h"

#import "utils/QRCode/QRCodeGen.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
    [self initTapGR];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initView
{
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [_OKBtn setBackgroundColor:[UIColor darkGrayColor]];
    [_OKBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_OKBtn addTarget:self action:@selector(OKAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_textField setBackgroundColor:[UIColor whiteColor]];
    _textField.layer.cornerRadius = 2.0f;
}

-(void) OKAction
{
    NSString *string = _textField.text;
    
    QRCodeGen *qrCodeGen = [[QRCodeGen alloc] init];
    [_qrCodeImageView setImage:[qrCodeGen stringToQRCodeImage:string withSize:_qrCodeImageView.frame.size.height]];
}

-(void) initTapGR
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void) viewTapped:(UITapGestureRecognizer *)tapGr
{
    [self.view endEditing:YES];
}

@end
