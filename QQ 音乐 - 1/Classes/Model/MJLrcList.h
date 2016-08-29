//
//  MJLrcList.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/24.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJLrcList : NSObject

/** time */
@property ( assign ,nonatomic)  NSTimeInterval  time;
/** lrcText */
@property (strong ,nonatomic) NSString * lrcText;

+ (instancetype)lrcListWithLrcLineString:(NSString *)lrcLine;

- (instancetype)initWithLrcLineString:(NSString *)lrcLine;
@end
