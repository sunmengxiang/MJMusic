//
//  MJMusics.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/23.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJMusics : NSObject

/** 歌名 */
@property (strong ,nonatomic) NSString * name;
/** 歌曲路径 */
@property (strong ,nonatomic) NSString * filename;
/** 歌词信息 */
@property (strong ,nonatomic) NSString * lrcname;
/** 歌手 */
@property (strong ,nonatomic) NSString * singer;
/** singer 小头像 */
@property (strong ,nonatomic) NSString * singerIcon;
/** name */
@property (strong ,nonatomic) NSString * icon;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
