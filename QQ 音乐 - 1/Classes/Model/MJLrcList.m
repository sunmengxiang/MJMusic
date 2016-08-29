//
//  MJLrcList.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/24.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJLrcList.h"

@implementation MJLrcList

+ (instancetype)lrcListWithLrcLineString:(NSString *)lrcLine
{
    return [[self alloc]initWithLrcLineString:lrcLine];
}
- (instancetype)initWithLrcLineString:(NSString *)lrcLine
{
    if (self = [super init])
    {
        NSArray * stringArr = [lrcLine componentsSeparatedByString:@"]"];
        
        self.lrcText = stringArr[1];
        NSString * timeString = stringArr[0];
//        [00:55.29]从此我开始孤单思念
        NSInteger min = [[[timeString componentsSeparatedByString:@":"][0] componentsSeparatedByString:@"["][1] integerValue];
        NSInteger msec = [[timeString componentsSeparatedByString:@"."][1] integerValue];
        NSInteger sec = [[timeString substringWithRange:NSMakeRange(4, 2)] integerValue];
        self.time = (min * 60 + sec + msec / 60);
    }
    return self;
}
@end
