//
//  MJSongListView.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/29.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJSongListView : UIView

/** 装有音乐模型数组 */
@property (strong ,nonatomic)  NSArray * musicsArray;
/** 当前播放的音乐 */
@property (assign ,nonatomic)  NSInteger currentIndex;
- (void)dismiss;
- (void)show;
@end
