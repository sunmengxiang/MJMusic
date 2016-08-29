//
//  MJLrcScrollView.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/24.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJLrcScrollView.h"
#import "MJLrcCell.h"
#import "MJLrcList.h"
#import "Masonry.h"
#import "MJLrcLineLabel.h"
@interface MJLrcScrollView ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (weak ,nonatomic) UITableView * tableView;

@property(nonatomic,assign) NSInteger currentIndex;
@end
@implementation MJLrcScrollView

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    if (currentTime == 0)
    {
        //    启动之后，第一句歌词就居中显示
        NSIndexPath * topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
    
    NSInteger count = self.lrcArray.count;
    //    拿到当前行
    for (int i = 0; i < count ; i ++)
    {
        MJLrcList * lrcLine = self.lrcArray[i];
        
        //        下一行的 lrcLine
        NSInteger nextLineIndex = i + 1;
        MJLrcList * nextLine = nil;
        if (nextLineIndex < count)
        {
            nextLine = self.lrcArray[nextLineIndex];
            
        }
        //        当前时间 currentTime与歌词的时间比较，找出正在播放的歌词
        if (lrcLine.time < currentTime && nextLine.time > currentTime && self.currentIndex != i)
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            NSIndexPath * previousPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
            
            //            记录当前的行号
            self.currentIndex = i;
//            刷新当前播放 行 以及还原上一句
            [self.tableView reloadRowsAtIndexPaths:@[indexPath,previousPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
            self.lrcLabel.text = [self.lrcArray[i] lrcText];
            
        }
        if (i == self.currentIndex)
        {
            //            刷新 label
            NSIndexPath * currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            CGFloat progress =  (currentTime - lrcLine.time)/(nextLine.time - lrcLine.time);
            MJLrcCell * cell = [self.tableView cellForRowAtIndexPath:currentIndexPath];
            cell.label.progress = progress;
            self.lrcLabel.progress = progress;
        }
    }
}

- (void)setLrcArray:(NSArray *)lrcArray
{
    self.currentIndex = 0;
    
    _lrcArray = lrcArray;
    
    [self.tableView reloadData];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setUpTableView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpTableView];
    }
    return self;
}

- (void)setUpTableView
{
    UITableView * tableView = [[UITableView alloc]init];
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.contentInset = UIEdgeInsetsMake(self.frame.size.height * 0.5, 0, self.frame.size.height * 0.5, 0);
    [self addSubview:tableView];
    self.tableView = tableView;

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset([UIScreen mainScreen].bounds.size.width);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
    
}
#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcArray.count;
}
static NSString * cellID = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MJLrcCell* cell = [MJLrcCell lrcCellWithTableView:tableView];
    
#warning 模拟器 bug,真机调试无异常，上线时改为 clearColor
    cell.backgroundColor = [UIColor redColor];
    
    MJLrcList * lrcLine = self.lrcArray[indexPath.row];
    
    cell.label.text = lrcLine.lrcText;
    if (self.currentIndex == indexPath.row)
    {
        [cell.label setFont:[UIFont systemFontOfSize:18.0]];
    }
    else
    {
        [cell.label setFont:[UIFont systemFontOfSize:14.0]];
        cell.label.progress = 0.0;
    }

    return cell;
}

@end
