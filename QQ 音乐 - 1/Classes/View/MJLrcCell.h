//
//  MJLrcCell.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/28.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJLrcLineLabel;
@interface MJLrcCell : UITableViewCell

/** lrcLabel */
@property (weak ,nonatomic) MJLrcLineLabel * label;
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView;

@end
