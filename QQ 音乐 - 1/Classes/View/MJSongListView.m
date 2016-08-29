//
//  MJSongListView.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/29.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJSongListView.h"
#import "MJMusics.h"
#import "MJListViewCell.h"
#define screenH  [UIScreen mainScreen].bounds.size.height
#define screenW  [UIScreen mainScreen].bounds.size.width
#define listTitleViewH 44
#define listViewH 300


@interface MJSongListView()<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic) MJSongListView * songListView;
@property (weak,nonatomic) UITableView * tableView;
@property (weak,nonatomic) UILabel * titleCenterLabel;
@property(strong,nonatomic) NSIndexPath * lastIndexPath;
@end

@implementation MJSongListView
static UIWindow * window_;
static NSString * MJNotificationListCellSelected = @"MJNotificationListCellSelected";



- (void)setMusicsArray:(NSArray *)musicsArray
{
    _musicsArray = musicsArray;
}
- (void)setUpTableView
{
    UITableView * tableView = [[UITableView alloc]init];
    tableView.frame = window_.bounds;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 30;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIView * titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor lightGrayColor];
    titleView.alpha = 0.7;
    titleView.frame = CGRectMake(0, 0, screenW, listTitleViewH);
    [self addSubview:titleView];
    UILabel * centerLabel = [[UILabel alloc]init];
    centerLabel.text = [NSString stringWithFormat:@"播放列表 (%zd)",self.musicsArray.count];
    centerLabel.alpha = 1;
    
    centerLabel.font = [UIFont systemFontOfSize:14];
//    分割线
    UIImageView * separtLine = [[UIImageView alloc]init];
    separtLine.backgroundColor = [UIColor lightGrayColor];
    separtLine.alpha = 0.7;
    separtLine.frame = CGRectMake(0, listTitleViewH - 1, screenW, 1);
    [titleView addSubview:separtLine];
    [titleView addSubview:centerLabel];
    self.titleCenterLabel = centerLabel;
    
  
}

- (void)show
{
    //    创建窗口
    window_ = [[UIWindow alloc]init];

    window_.frame = CGRectMake(0, screenH - listViewH, screenW, listViewH);
    window_.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];

    self.frame = window_.bounds;
    [window_ addSubview:self];
    //    显示 window
    window_.hidden = NO;
    [self setUpTableView];

}

- (void)dismiss
{
    window_.hidden = YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.musicsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJListViewCell * cell = [MJListViewCell cellWithTableView:tableView];

    MJMusics * musics = self.musicsArray[indexPath.row];
    cell.songLabel.text = musics.name;
    cell.singerLabel.text = musics.singer;
    if (indexPath.row == self.currentIndex)
    {
        cell.playingButton.hidden = NO;
        self.lastIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJListViewCell * lastCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
    lastCell.playingButton.hidden = YES;
    MJListViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.playingButton.hidden = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:MJNotificationListCellSelected object:indexPath];
    self.lastIndexPath = indexPath;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleCenterLabel.center = CGPointMake(self.center.x, listTitleViewH / 2.0);
    self.titleCenterLabel.bounds = CGRectMake(0, 0, 100, listTitleViewH);
}
@end
