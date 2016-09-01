//
//  MJMusics.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/23.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJMusics.h"

@implementation MJMusics

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self=[super init]) {
        self.name=dict[@"name"];
        self.filename=dict[@"filename"];
        self.lrcname=dict[@"lrcname"];
        self.singer=dict[@"singer"];
        self.singerIcon=dict[@"singerIcon"];
        self.icon=dict[@"icon"];
    }
    return self;
}
@end
