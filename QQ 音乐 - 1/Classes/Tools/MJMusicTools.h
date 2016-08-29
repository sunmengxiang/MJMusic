//
//  MJMusicTools.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/23.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MJMusics;
@interface MJMusicTools : NSObject
+ (NSArray *)musics;

+ (MJMusics *)playingMusics;

+ (void)setPlayingMusics:(MJMusics *)musics;

+ (MJMusics *)previousMusic;

+ (MJMusics *)nextMusic;

+ (MJMusics *)randomMusic;
@end
