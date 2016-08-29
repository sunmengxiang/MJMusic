//
//  MJMusicTools.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/23.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJMusicTools.h"
#import "MJMusics.h"
#import "MJExtension.h"
#import <AVFoundation/AVFoundation.h>
@interface MJMusicTools ()

@end
@implementation MJMusicTools

static NSArray * _muscisArray;
static MJMusics * _currentMusics;
static NSInteger _currentIndex;

+ (void)initialize
{
    if (_muscisArray == nil)
    {
        _muscisArray = [MJMusics objectArrayWithFilename:@"Musics.plist"];
    }
    if (_currentMusics == nil)
    {
        _currentMusics = _muscisArray[0];
    }
}
+ (NSArray *)musics
{
    return _muscisArray;
}
+ (MJMusics *)playingMusics
{
    return _currentMusics;
}
+ (void)setPlayingMusics:(MJMusics *)musics
{
    _currentMusics = musics;
}
+ (MJMusics *)previousMusic
{
    _currentIndex = [_muscisArray indexOfObject:_currentMusics];
    
    NSInteger previousIndex = _currentIndex - 1;
    if (previousIndex < 0)
    {
        previousIndex = _muscisArray.count - 1;
    }
    MJMusics * previousMusics = _muscisArray[previousIndex];
    
    return previousMusics;
}
+ (MJMusics *)nextMusic
{
    _currentIndex = [_muscisArray indexOfObject:_currentMusics];
    
    NSInteger nextIndex = _currentIndex + 1;
    if (nextIndex >= _muscisArray.count)
    {
        nextIndex = 0;
    }
    MJMusics * nextMusics = _muscisArray[nextIndex];
    return nextMusics;
}
+ (MJMusics *)randomMusic
{
    _currentIndex = [_muscisArray indexOfObject:_currentMusics];
  
    NSInteger random = arc4random_uniform((int)(_muscisArray.count));
    NSInteger randomIndex = random;
//    随机新值跟旧值相同
    if (randomIndex == _currentIndex)
    {
        randomIndex = arc4random_uniform((int)(_muscisArray.count));
    }
    // 随机到越界的处理
    if (randomIndex >= _muscisArray.count)
    {
        randomIndex = 0;
    }
    MJMusics * randomMusic = _muscisArray[randomIndex];
    return randomMusic;
}
@end
