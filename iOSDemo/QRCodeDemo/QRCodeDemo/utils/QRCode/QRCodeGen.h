//
//  QRCodeGen.h
//  yaoren
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libqrencode/qrencode.h"

@interface QRCodeGen : NSObject

-(UIImage*) stringToQRCodeImage:(NSString*)string withSize:(unsigned int)size;

//-(BOOL) isSizeAvilable:(unsigned int)size;

+(void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size;

@end
