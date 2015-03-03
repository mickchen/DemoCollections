//
//  ViewController.h
//  QRCodeDemo
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, retain) IBOutlet UIButton *OKBtn;

@property (nonatomic, retain) IBOutlet UIImageView *qrCodeImageView;

-(void) initView;

-(void) OKAction;

-(void) initTapGR;
-(void) viewTapped:(UITapGestureRecognizer *)tapGr;

@end
