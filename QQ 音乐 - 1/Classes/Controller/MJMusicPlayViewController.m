//
//  MJMusicPlayViewController.m
//  QQ 音乐 - 1
//
//  Created by 孙梦翔 on 16/8/22.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//
#define MJColor(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#import "MJMusicPlayViewController.h"
#import "MJExtension.h"
#import "MJMusics.h"
#import "MJAudioTools.h"
#import "MJMusicTools.h"
#import "CALayer+PauseAimate.h"
#import <AVFoundation/AVFoundation.h>
#import "MJLrcScrollView.h"
#import "MJLrcLineLabel.h"
#import "MJLrcTools.h"
#import "MJLrcList.h"
#import "Masonry.h"
#import "MJSongListView.h"
typedef NS_ENUM(NSUInteger,MJSongPlaySequence)
{
    MJSongPlaySequenceList = 0,
    MJSongPlaySequenceRandom = 1,
    MJSongPlaySequenceOnly = 2,
};
@interface MJMusicPlayViewController ()<UIScrollViewDelegate,AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UISlider *playProgressSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentProgressLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet MJLrcScrollView *lrcView;
@property (weak, nonatomic) IBOutlet MJLrcLineLabel *lrcLineLabel;
@property (weak, nonatomic) IBOutlet UIView *topToolsView;

@property (weak, nonatomic) IBOutlet UIView *bottomToolsView;
@property (weak, nonatomic) IBOutlet UIButton *songListButton;
@property (weak, nonatomic) IBOutlet UIButton *changeSongSequenceBtn;

/** slider定时器 */
@property (strong ,nonatomic) NSTimer * timer;
/** 歌词的定时器 */
@property (strong ,nonatomic)  CADisplayLink * lrcTimer;
/** 当前的播放器 */
@property (strong ,nonatomic)  AVAudioPlayer * currentPlayer;
@property (assign,nonatomic) MJSongPlaySequence sequenceIndex;
/** sequenceArray */
@property (strong ,nonatomic) NSArray * sequenceArray;
/** 播放列表 view */
@property (strong ,nonatomic) MJSongListView * songList;
@property (assign,nonatomic) BOOL songListIsShow;
#pragma mark  -播放暂停 next previous 按钮的点击
- (IBAction)previousClick:(UIButton *)sender;

- (IBAction)playOrPauseClick:(UIButton *)sender;

- (IBAction)nextClick:(UIButton *)sender;
#pragma mark - slider 滑动动作点击
- (IBAction)sliderValueChange:(UISlider *)sender;

- (IBAction)sliderStartTouch:(UISlider *)sender;

- (IBAction)sliderEndTouch:(UISlider *)sender;

@end

@implementation MJMusicPlayViewController
// 禁止自动旋转
- (BOOL)shouldAutorotate
{
    return NO;
}
#pragma mark - 懒加载
- (UIView *)songList
{
    if (_songList == nil)
    {
        _songList = [[MJSongListView alloc]init];
    }
    return _songList;
}
- (NSArray *)sequenceArray
{
    if (_sequenceArray == nil)
    {
        _sequenceArray = @[@"列表播放",@"随机播放",@"单曲循环"];
    }
    return _sequenceArray;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置背景图片毛玻璃效果
    [self setUpBlurEffect];
    
    //    设置 slider 样式
    [self setUpProgressSlider];
    
    //    布局页面
    [self startPlayMusic];
//    listView 发送的通知,设置控制器为 listView 的观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickSongListCell:) name:@"MJNotificationListCellSelected" object:nil];
}
#pragma mark - listView cell 点击的观察者方法
- (void)clickSongListCell:(NSNotification *)notification
{
    NSIndexPath * indexPath = notification.object;
    NSArray * musicArray = [MJMusicTools musics];
    MJMusics * selectedMusics = musicArray[indexPath.row];
    
    [self playingMusic:selectedMusics];
    
    [MJMusicTools setPlayingMusics:selectedMusics];
    
    [self startPlayMusic];
}
#pragma mark - 设置 lrcView
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //    设置 lrcScrollView
    [self setUpLrcScrollView];
}

#pragma mark - view加载完成时会自动调用的方法
//    设置 lrcScrollView
- (void)setUpLrcScrollView
{
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
}
// 设置将要播放音乐的图片歌名等内容以及开启定时器
- (void)startPlayMusic
{
//    更新 progressInfo
    [self updateProgressInfo];
    MJMusics * musics = [MJMusicTools playingMusics];

//    设置背景图片和 icon
    self.iconImageView.image = [UIImage imageNamed:musics.icon];
    self.backgroundImageView.image = [UIImage imageNamed:musics.icon];
//    拿到 currentPlayer，并开始播放
    self.currentPlayer = [MJAudioTools playSoundWithMusicName:musics.filename];
    self.currentPlayer.delegate = self;
//    设置当前播放时间以及播放总时间
    NSTimeInterval duration = [self.currentPlayer duration];
    NSTimeInterval currentTime = [self.currentPlayer currentTime];
    self.durationLabel.text = [self stringWithTime:duration];
    self.currentProgressLabel.text = [self stringWithTime:currentTime];
//    设置歌手和歌曲名称
    self.songLabel.text = musics.name;
    self.singerLabel.text = musics.singer;
//     设置 play 按钮的mode
    self.playOrPauseButton.selected = self.currentPlayer.isPlaying;
//    添加歌词
    self.lrcView.lrcArray = [MJLrcTools lrcWithMusic:musics];
    self.lrcView.currentTime = currentTime;
    self.lrcView.lrcLabel = self.lrcLineLabel;
    self.lrcView.delegate = self;
//    开始旋转动画
    [self startRotationAnimation];
    
//    开始的 lrclabel 内容为空
    self.lrcLineLabel.text = @"";
//    添加定时器
    [self removeLrcTimer];
    [self addLrcTimer];
    
    [self removeSliderTimer];
    [self addSliderTimer];
}
// 设置背景图片的毛玻璃效果
- (void)setUpBlurEffect
{
    UIToolbar * tool = [[UIToolbar alloc]init];
    
    tool.frame = self.view.bounds;
    
    tool.barStyle = UIBarStyleBlack;
    
    [self.backgroundImageView addSubview:tool];
}
//设置 slider 的滑块样式
- (void)setUpProgressSlider
{
    [self.playProgressSlider setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
}

# pragma mark - 对子控件尺寸等的设置
- (void)viewDidLayoutSubviews
{
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.height * 0.5;
    
    self.iconImageView.layer.masksToBounds = YES;
    
    self.iconImageView.layer.borderWidth = 8;
    
    self.iconImageView.layer.borderColor = [MJColor(36, 36, 36) CGColor];
    
}
#pragma mark - 设置 statusBar 的样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - 播放指定的 music，并将上一个 player stop
- (void)playingMusic:(MJMusics *)musics
{
    MJMusics * oldMusics = [MJMusicTools playingMusics];
    
    [MJAudioTools stopSoundWithMusicName:oldMusics.filename];
    
    self.currentPlayer = [MJAudioTools playSoundWithMusicName:musics.filename];
    
}
#pragma mark - 播放暂停 next previous 按钮的点击
- (IBAction)previousClick:(UIButton *)sender
{
    MJMusics * previousMusic = [MJMusicTools previousMusic];
    
    [self playingMusic:previousMusic];
    
    [MJMusicTools setPlayingMusics:previousMusic];
    
    [self.iconImageView.layer removeAllAnimations];
    
    [self startPlayMusic];
    
    
    
}

- (IBAction)playOrPauseClick:(UIButton *)sender
{
    self.playOrPauseButton.selected = !self.playOrPauseButton.selected;
    if (!self.currentPlayer.isPlaying)
    {
        //        开始播放
        [self.currentPlayer play];
        //        添加定时器
        [self addSliderTimer];
        
        [self addLrcTimer];
        // icon 开始旋转动画
        [self.iconImageView.layer resumeAnimate];
    }
    else
    {
        [self.currentPlayer pause];
        //        移除 slider 定时器
        [self removeSliderTimer];
        //        移除歌词的定时器
        [self removeLrcTimer];
        //        暂停 icon 的旋转动画
        [self.iconImageView.layer pauseAnimate];
    }
}

- (IBAction)nextClick:(UIButton *)sender
{
    
    MJMusics * nextMusic = nil;
    if (self.sequenceIndex == MJSongPlaySequenceList )
    {
        //    拿到下一首歌曲的数据模型
        nextMusic = [MJMusicTools nextMusic];
    }
     else if (self.sequenceIndex == MJSongPlaySequenceOnly)
    {
//        自动播完音乐才执行单曲循环
        if (sender == nil)
        {
            nextMusic = [MJMusicTools playingMusics];
        }
        else
        {
//        点击下一首，效果跟列表循环一样
        nextMusic = [MJMusicTools nextMusic];
        }
    }
    else if (self.sequenceIndex == MJSongPlaySequenceRandom)
    {
        nextMusic = [MJMusicTools randomMusic];
    }
//     播放下一首歌曲，并在这个方法里将上一首歌曲暂停
    [self playingMusic:nextMusic];
//     记录当前正在播放的音乐
    [MJMusicTools setPlayingMusics:nextMusic];
    [self.iconImageView.layer removeAllAnimations];
//    开始布局当前播放的音乐图片等内容
    [self startPlayMusic];
}

- (IBAction)changePlaySequence:(UIButton *)sender
{
    self.sequenceIndex++;
    if (self.sequenceIndex >= self.sequenceArray.count ) {
        self.sequenceIndex = MJSongPlaySequenceList;
    }
    [self.changeSongSequenceBtn setTitle:self.sequenceArray[self.sequenceIndex] forState:UIControlStateNormal];
}
// 展示播放列表
- (IBAction)showSongList:(UIButton *)sender
{
    self.songListIsShow = YES;
    self.lrcView.scrollEnabled = NO;
    self.songList.musicsArray = [MJMusicTools musics];
    self.songList.currentIndex = [self.songList.musicsArray indexOfObject:[MJMusicTools playingMusics]];
        [self.songList show];
    
}
#pragma mark - 定时器
- (void)addSliderTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)removeSliderTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addLrcTimer
{
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcInfo)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
#pragma mark - 更新 progress
- (void)updateProgressInfo
{
    NSTimeInterval currentTime = [self.currentPlayer currentTime];
    self.currentProgressLabel.text = [self stringWithTime:currentTime];
    NSTimeInterval durationTime = [self.currentPlayer duration];
    self.durationLabel.text = [self stringWithTime:durationTime];
    self.playProgressSlider.value = currentTime / durationTime ;
}
# pragma mark - 旋转动画
static NSString * rotationAnimKeyPath = @"transform.rotation.z";
- (void)startRotationAnimation
{
    CABasicAnimation * anim = [CABasicAnimation animationWithKeyPath:rotationAnimKeyPath];
    
    anim.fromValue = @(0);
    anim.toValue = @(M_PI * 2);
    anim.repeatCount = MAXFLOAT;
    anim.duration = 50;
    [self.iconImageView.layer addAnimation:anim forKey:@"rotationAnim"];
}
- (void)updateLrcInfo
{
    self.lrcView.currentTime = [self.currentPlayer currentTime];
}
# pragma mark - 对时间进行 分钟和秒 的处理
- (NSString *)stringWithTime:(NSTimeInterval )time
{
    NSInteger min = time / 60;
    NSInteger sec = (NSInteger)time % 60;
    
    return [NSString stringWithFormat:@"%02zd:%02zd",min,sec];
}
#pragma mark - slider 滑动动作点击
- (IBAction)sliderValueChange:(UISlider *)sender
{
    NSTimeInterval duration = [self.currentPlayer duration];
    NSTimeInterval currentTime = sender.value * duration;
//    设置 currentLabel 的时间
    self.currentProgressLabel.text = [self stringWithTime:currentTime];
}

- (IBAction)sliderStartTouch:(UISlider *)sender
{
//    暂停计时器
    [self removeLrcTimer];
    [self removeSliderTimer];
//    暂停播放
    [self.currentPlayer pause];
//    icon 停止旋转
    [self.iconImageView.layer pauseAnimate];
}

- (IBAction)sliderEndTouch:(UISlider *)sender
{
//    开始计时器
    [self addLrcTimer];
    [self addSliderTimer];
//    icon 开始旋转
    [self.iconImageView.layer resumeAnimate];
//    拿到开始播放的时间
    NSTimeInterval duration = [self.currentPlayer duration];
    NSTimeInterval currentTime = sender.value * duration;
//    设置播放开始时间
    self.currentPlayer.currentTime = currentTime;
//    开始播放
    [self.currentPlayer play];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat progress = scrollView.contentOffset.x / self.view.bounds.size.width;
    
    self.iconImageView.alpha = 1 - ABS(progress);
    self.lrcLineLabel.alpha = 1 - ABS(progress);
}

#pragma mark - <AVAudioPlayerDelegate>
// 播放完成后自动播放下一首
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    if (flag)
    {
        [self nextClick:nil];
    }
}
#pragma mark -ScrollView 点按手势方法
- (IBAction)scrollViewClick:(UITapGestureRecognizer *)sender
{
    if (self.songListIsShow)
    {
        [self.songList dismiss];
        self.songListIsShow = NO;
        self.lrcView.scrollEnabled = YES;
        return;
    }
    
        CGPoint touchPointInView = [sender locationInView:self.lrcView];
        CGFloat screenW = self.view.bounds.size.width;
        CGPoint contentOffsetRight = CGPointMake(screenW, 0);
        if (touchPointInView.x < screenW)
        {
            [self.lrcView setContentOffset:contentOffsetRight animated:YES];
        }
        else
        {
            [self.lrcView setContentOffset:CGPointZero animated:YES];
        }
}

#pragma mark - 锁屏后接收远程事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl)
    {
        switch (event.subtype)
        {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playOrPauseClick:nil];
                NSLog(@"playOrPauseClick--%zd",self.playOrPauseButton.selected);
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self nextClick:nil];
                NSLog(@"nextClick");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self previousClick:nil];
                NSLog(@"previousClick");
                break;
            default:
                break;
        }
    }
}


@end
