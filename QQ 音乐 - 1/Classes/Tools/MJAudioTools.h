//
//  MJAudioTools.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/23.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface MJAudioTools : NSObject
/** 播放音乐*/
+ (AVAudioPlayer *)playSoundWithMusicName:(NSString *)musicName;
/** 暂停音乐*/
+ (void)pauseSoundWithMusicName:(NSString *)musicName;
/** 停止音乐，并移除释放*/
+ (void)stopSoundWithMusicName:(NSString *)musicName;
/** 播放音效 */
+ (void)playSoundWithSoundName:(NSString *)soundName;
@end
