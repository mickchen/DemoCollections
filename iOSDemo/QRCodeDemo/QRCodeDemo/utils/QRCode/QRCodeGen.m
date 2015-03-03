//
//  QRCodeGen.m
//  yaoren
//
//  Created by Apple on 14-3-20.
//  Copyright (c) 2014年 MICK. All rights reserved.
//

#import "QRCodeGen.h"

#define qrMargin 5

@implementation QRCodeGen

-(UIImage*) stringToQRCodeImage:(NSString*)string withSize:(unsigned int)size
{
    if (!string || [string length] <= 0)
    {
        UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入要编码的字符串" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [tipsView show];
        
        return nil;
    }
    
//    if (![self isSizeAvilable:size])
//    {
//        UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"二维码的版本号应在1-40间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        
//        [tipsView show];
//        
//        return nil;
//    }
    
    QRcode *qrCode = QRcode_encodeString([string UTF8String], 0, QR_ECLEVEL_L, QR_MODE_8, 1);
    
    if (!qrCode)
    {
        UIAlertView *tipsView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"二维码生成失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [tipsView show];
        
        return nil;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(0, size, size, 8, size * 4, colorSpace, 1);
//    CGContextRef ctx = CGBitmapContextCreate(<#void *data#>, <#size_t width#>, <#size_t height#>, <#size_t bitsPerComponent#>, <#size_t bytesPerRow#>, <#CGColorSpaceRef space#>, CGBitmapInfo bitmapInfo)
    
    NSLog(@"ctx:%@", ctx);
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -200);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
    CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
    
    [QRCodeGen drawQRCode:qrCode context:ctx size:size];
    
    CGImageRef qrCGImage =CGBitmapContextCreateImage(ctx);
    UIImage *qrImage = [UIImage imageWithCGImage:qrCGImage];
    
    CGContextRelease(ctx);
    CGImageRelease(qrCGImage);
    CGColorSpaceRelease(colorSpace);
    QRcode_free(qrCode);

    return qrImage;
}

//-(BOOL) isSizeAvilable:(unsigned int)size
//{
//    if (size >= 1 && size <= 40)
//    {
//        return YES;
//    }
//    
//    return NO;
//}

+(void)drawQRCode:(QRcode *)code context:(CGContextRef)ctx size:(CGFloat)size
{
    unsigned char *data = 0;
    int width;
    data = code->data;
    width = code->width;
    float zoom = (double)size / (code->width + 2.0 * qrMargin);
    CGRect rectDraw =CGRectMake(0, 0, zoom, zoom);
    
    CGContextSetFillColor(ctx, CGColorGetComponents([UIColor blackColor].CGColor));
    for(int i = 0; i < width; ++i)
    {
        for(int j = 0; j < width; ++j)
        {
            if(*data & 1)
            {
                rectDraw.origin =CGPointMake((j + qrMargin) * zoom,(i + qrMargin) * zoom);
                CGContextAddRect(ctx, rectDraw);
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
}

@end
