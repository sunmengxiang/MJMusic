//
//  MJLrcScrollView.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/24.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJLrcLineLabel;
@interface MJLrcScrollView : UIScrollView

/** lrc 模型数组 */
@property (strong ,nonatomic)  NSArray * lrcArray;

/** currentTime */
@property (assign ,nonatomic) NSTimeInterval  currentTime;

/** 主界面的歌词 label */
@property (weak ,nonatomic) MJLrcLineLabel * lrcLabel;
@end
