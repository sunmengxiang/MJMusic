//
//  MJListViewCell.h
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/29.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playingButton;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
