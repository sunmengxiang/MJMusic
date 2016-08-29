//
//  CALayer+PauseAimate.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/22.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (PauseAimate)

// 暂停动画
- (void)pauseAnimate;

// 恢复动画
- (void)resumeAnimate;

@end
