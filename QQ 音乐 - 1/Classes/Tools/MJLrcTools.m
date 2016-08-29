//
//  MJLrcTools.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/24.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJLrcTools.h"
#import "MJMusics.h"
#import "MJLrcList.h"
#import "MJExtension.h"
@implementation MJLrcTools

/*
 [ti:月半小夜曲]
 [ar:李克勤]
 [al:Purple dream]
 [00:00.00]月半小夜曲 李克勤
 [00:19.00]曲：河合奈保子 词：向雪怀
 [00:23.00]仍然倚在失眠夜望天边星宿

 */

+ (NSArray *)lrcWithMusic:(MJMusics *)musics
{
    NSString * lrcPath = [[NSBundle mainBundle]pathForResource:musics.lrcname ofType:nil];
    
    NSString * string = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray * stringArr = [string componentsSeparatedByString:@"\n"];

    //    遍历歌词数组，去除类似下面这样不要的字符串
    /*
    [ti:月半小夜曲]
    [ar:李克勤]
    [al:Purple dream]
     
    */
    NSMutableArray * tempArray = [NSMutableArray array];
    for (NSString * lrcString in stringArr)
    {
        if ([lrcString hasPrefix:@"[ti"] || [lrcString hasPrefix:@"[ar"] || [lrcString hasPrefix:@"[al"] || ![lrcString hasPrefix:@"["]) continue;
        MJLrcList * lrcList = [MJLrcList lrcListWithLrcLineString:lrcString];
        [tempArray addObject:lrcList];
    }
    NSArray * array = tempArray;

    return array;
}
@end
