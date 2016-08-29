//
//  MJLrcLineLabel.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/24.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJLrcLineLabel.h"

@implementation MJLrcLineLabel


- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
//    设置画板区域
    CGRect fillRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
//    添加颜色
    [[UIColor greenColor]set];
//    绘制
    UIRectFillUsingBlendMode(fillRect, kCGBlendModeSourceIn);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}




@end
