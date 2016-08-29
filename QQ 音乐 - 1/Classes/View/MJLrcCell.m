//
//  MJLrcCell.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/28.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJLrcCell.h"
#import "MJLrcLineLabel.h"
#import "Masonry.h"
@implementation MJLrcCell


static NSString * cellID = @"lrcCell";
+ (instancetype)lrcCellWithTableView:(UITableView *)tableView
{
    MJLrcCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[MJLrcCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        MJLrcLineLabel * label = [[MJLrcLineLabel alloc]init];
        self.label = label;
        [self.contentView addSubview:label];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setFont:[UIFont systemFontOfSize:14.0]];
        [self.label setTextColor:[UIColor whiteColor]];
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
       
    }
    return self;
}
@end
