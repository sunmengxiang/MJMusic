//
//  MJListViewCell.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/29.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJListViewCell.h"

@implementation MJListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
static NSString *listCelID = @"listCell";
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MJListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:listCelID];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    }
    
    return cell;
}

@end
