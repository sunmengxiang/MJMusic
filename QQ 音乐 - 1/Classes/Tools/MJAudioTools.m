//
//  MJAudioTools.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/23.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJAudioTools.h"
@interface MJAudioTools ()


@end

@implementation MJAudioTools
// 存储音效的字典
static NSMutableDictionary * _soundID;
// 储存音乐的字典
static NSMutableDictionary * _players;

+ (void)initialize
{
    _soundID = [NSMutableDictionary dictionary];
    _players = [NSMutableDictionary dictionary];
}
#pragma mark - 音乐的播放
+ (AVAudioPlayer *)playSoundWithMusicName:(NSString *)musicName
{
    
    AVAudioPlayer * player = nil;
    player = _players[musicName];
    
    if (player == nil)
    {
        NSURL * fileUrl = [[NSBundle mainBundle]URLForResource:musicName withExtension:nil];
        
        if (fileUrl == nil) return nil;
        
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
        
        [_players setObject:player forKey:musicName];
        
        [player prepareToPlay];
    }
    
    [player play];
    
    return player;
}

+ (void)pauseSoundWithMusicName:(NSString *)musicName
{
    AVAudioPlayer * player = _players[musicName];
    
    if (player)
    {
        [player pause];
    }
}
+ (void)stopSoundWithMusicName:(NSString *)musicName
{
    AVAudioPlayer * player = _players[musicName];
    
    if (player)
    {
        [player stop];
        [_players removeObjectForKey:musicName];
        player = nil;
    }
}

+ (void)playSoundWithSoundName:(NSString *)soundName
{
//    定义 soundID
    SystemSoundID soundID = 0;
//    从字典中取出 soundID,如果取出nil,表示未存放在字典中，进行懒加载
    soundID = [_soundID[soundName] unsignedIntValue];
//    懒加载
    if (soundID == 0)
    {
        CFURLRef fileUrl = (__bridge CFURLRef)[[NSBundle mainBundle]URLForResource:soundName withExtension:nil];
//       判断 soundName 是否为非法值，排除输入异常
        if(fileUrl == NULL) return;
        AudioServicesCreateSystemSoundID(fileUrl, &soundID);
        
        [_soundID setObject:@(soundID) forKey:soundName];
    }
//    播放音效
    AudioServicesPlaySystemSound(soundID);
    
}
@end
