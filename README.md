# MJMusic
##这是一个本地音乐 App Demo具有如下功能
- 1.音乐播放
- 2.音乐切换
  - 2.1 音乐切换模式三种：随机播放、列表播放、单曲循环
- 3.播放列表查看
  - 3.1 播放列表选择想听的歌曲
- 4.播放歌词实时同步动画
- 5.播放页面专辑封面旋转
- 6.背景实现专辑封面蒙版
- 7.进入后台后，继续播放音乐
- 8.锁屏后，锁屏界面控制音乐的播放，切歌
- 9.耳机拔掉之后，暂停音乐播放

##待完善部分
~~- 1.进入后台后，继续播放音乐~~	
~~- 2.锁屏后，锁屏界面控制音乐的播放，切歌~~	
~~- 3.耳机拔掉之后，暂停音乐播放~~


### 使用到的第三方框架有：
	- pod 'Masonry'

### 完成的功能如下：

![image](https://github.com/sunmengxiang/MJMusic/blob/master/functionImage/listPlay.png)
![image](https://github.com/sunmengxiang/MJMusic/blob/master/functionImage/lrcLineLabel.png)
![image](https://github.com/sunmengxiang/MJMusic/blob/master/functionImage/randomPlay.png)
![image](https://github.com/sunmengxiang/MJMusic/blob/master/functionImage/songAnimation.png)
**ps因为模拟器问题，歌词背景颜色无法调整，真机测试无异常**	
![image](https://github.com/sunmengxiang/MJMusic/blob/master/functionImage/songList.png)

#### 解析:
- 0.分层设计模式:
	- 0.0 表示层:*由MJMusicPlayViewController* 控制器；若干自定义 *UIView* 组成
  	- 0.1 业务逻辑层:有 *MJAudioTools* *MJLrcTools* *MJMusicTools* 组成，分别给表示层提供*控制播放* *显示歌词* *管理播放顺序* 的功能
- 1.音乐播放实现*(MJAudioTools*)：
	 - 1.1 实现音乐播放有两个方法:
		 - 1.1.1 音效的播放

				+ (void)playSoundWithSoundName:(NSString *)soundName
				{
				//    定义 soundID
				    SystemSoundID soundID = 0;
				//    从字典中取出 soundID,如果取出nil,表示未存放在字典中，进行懒加载
				    soundID = [_soundID[soundName] unsignedIntValue];
				//    懒加载
				    if (soundID == 0)
				    {
				        CFURLRef fileUrl = (__bridge CFURLRef)[[NSBundle mainBundle]URLForResource:soundName withExtension:nil];
				//       判断 soundName 是否为非法值，排除输入异常
				        if(fileUrl == NULL) return;
				        AudioServicesCreateSystemSoundID(fileUrl, &soundID);

				        [_soundID setObject:@(soundID) forKey:soundName];
				    }
				//    播放音效
				    AudioServicesPlaySystemSound(soundID);
			        //    ps:   AudioServicesPlayAlertSound(soundID) 可以播放时带*振动*效果
				}
                音效的播放一般用于短时间的声音播放，如特效声音这些1~2 s时长的音频
      		使用到 *AVFoundation/AVFoundation.h* 框架	
		  - 1.1.2 音乐的播放
		  
					#pragma mark - 音乐的播放
                    + (AVAudioPlayer *)playSoundWithMusicName:(NSString *)musicName
                    {

                        AVAudioPlayer * player = nil;
                        player = _players[musicName];

                        if (player == nil)
                        {
                        NSURL * fileUrl = [[NSBundle mainBundle]URLForResource:musicName withExtension:nil];

                        if (fileUrl == nil) return nil;

                        player = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];

                        [_players setObject:player forKey:musicName];

                        [player prepareToPlay];
                      }
                        [player play];

                        return player;
                        }
		音乐的播放一般用* AVAudioPlayer* 类
      		使用到 *AVFoundation/AVFoundation.h* 框架	
		使用到*- (void)prepareToPlay;*是为了缓冲，提高播放流畅性	
		暂停:*- (void)pause;* 停止:*- (void)stop* 停止后，建议将 _player = nil;
- 2.音乐切换(MJMusicTools)
   	- 2.1 随机播放
				+ (MJMusics *)randomMusic
				{
				    _currentIndex = [_muscisArray indexOfObject:_currentMusics];

				    NSInteger random = arc4random_uniform((int)(_muscisArray.count));
				    NSInteger randomIndex = random;
				//    随机新值跟旧值相同
				    if (randomIndex == _currentIndex)
				    {
				        randomIndex = arc4random_uniform((int)(_muscisArray.count));
				    }
				    // 随机到越界的处理
				    if (randomIndex >= _muscisArray.count)
				    {
				        randomIndex = 0;
				    }
				    MJMusics * randomMusic = _muscisArray[randomIndex];
				    return randomMusic;
				}

	 - 2.2 单曲循环		
			伪代码:	
		
					Event:nextClick --> Action:- (IBAction)nextClick 执行
					{
						if（playType == OneCirclePlay）
						
						[currentPlayer play]
					}
   	- 2.3 列表播放(略)
- 3.播放列表查看及播放选中歌曲
	- 3.1 *storyBoard* 增加按钮 --> 实现 action 方法 --> 方法中调用列表视图 *ListView* 对象方法*-(void)show* --> 用户选中列表中歌曲 -->列表视图发送通知 --> 控制器这个观察者接到通知 --> 播放音乐
	- 3.2 这里用到 *NSNotification* 并不太妥，因为用户点击事件只需要一个结果，就是播放音乐，而通知是一对多的关系，所以采用代理 *delegate* 方式会更好 *update*
- 4.播放歌词实时同步动画(*MJLrcTools*)
	- 4.1  开始播放音乐 playing --> 开始 CADisplayLink 定时器 --> 按照屏幕刷新的频率调用 *- (void)updateLrcInfo;*方法 --> 将playing Music 已经播放的事件 *currentTime* 传给显示歌词的 *lrcView* --> 重写 *currentTime* setter 方法 --> 遍历装有每行歌词的数组 --> 找到跟 *currentTime* 匹配的歌词 --> 告诉显示歌词的自定义 label 根据 *progress* 进行重绘 --> 重绘下一句歌词时，将上一句复原
- 5.专辑封面圆形剪切及动画旋转、暂停、停止
	- 5.1  圆形剪切:*因为只有一张图片的，就不考虑离屏渲染的问题了，采用*mask*的 *cornerRadius* 进行设置*
				- (void)viewDidLayoutSubviews
				{
				    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.height * 0.5;

				    self.iconImageView.layer.masksToBounds = YES;

				    self.iconImageView.layer.borderWidth = 8;

				    self.iconImageView.layer.borderColor = [MJColor(36, 36, 36) CGColor];

				}
		- 5.1.1 Quartz-2D补充	
		
				@implementation UIImage (MJCircleImage)
				
				- (UIImage *)imageWithCircleImage
				{
				// 开启上下文
				    UIGraphicsBeginImageContextWithOptions(self.size, 0, 0);

				//    获取上下文
				    CGContextRef ref  = UIGraphicsGetCurrentContext();


				    CGContextAddEllipseInRect(ref, CGRectMake(0, 0, self.size.width, self.size.height));

				    CGContextClip(ref);

				    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];

				//    拿到图片
				    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
				//    关闭上下文
				    UIGraphicsEndImageContext();

				    return image;
				}
		将经过 Quartz-2D处理过的图片交给 *self.iconImageView.image* 即可，这里考虑开发实用性及简便性，就采用了 *mask* 的方法
- 6.背景实现专辑封面蒙版
	- 6.1 mask 做法
	
				//  创建一个跟背景图片一样大的 layer
				    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
				    CGRect maskRect = self.view.bounds;

				//  创建一个矩形 的 maskRect 大小的 CGPath
				    CGMutablePathRef path = CGPathCreateMutable();
				    CGPathAddRect(path, nil, maskRect);

				//  将CGPath 滑到 layer 上
				    [maskLayer setPath:path];

				 // Release the path since it's not covered by ARC.
				    CGPathRelease(path);

				 // Set the mask of the view.
				    self.backgroundImageView.layer.mask = maskLayer;

	- 6.2 利用 UIToolBar
				// 设置背景图片的毛玻璃效果
				- (void)setUpBlurEffect
				{
				    UIToolbar * tool = [[UIToolbar alloc]init];

				    tool.frame = self.view.bounds;

				    tool.barStyle = UIBarStyleBlack;

				    [self.backgroundImageView addSubview:tool];
				}
- 7.进入后台后，继续播放音乐
				- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

				/**    设置音乐后台播放 **/
				//    拿到音频会话
				    AVAudioSession * session = [AVAudioSession sharedInstance];
				//    设置后台播放类型
				    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
				//    激活音频会话
				    [session setActive:YES error:nil];

				    return YES;
				}
			在 AppDelegate 中application：didFinishLaunchingWithOptions：；方法中设置音频会话的 setCategory 方法，并激活会话，即可实现	
			*AVAudioSession*是单例,是<AVFoundation/AVFoundation.h>框架中的	
			可以通过 setCategory 方法其他的会话方法，具体可以command+鼠标左键点进去查看
- 8.锁屏后，锁屏界面控制音乐的播放，切歌
	- 8.1 在 info.plist 中增加*Required background modes* 项，这是一个 NSArray，进去后设置*App plays audio or streams audio/video using AirPlay*
	- 8.2 在控制器中实现:*- (void)remoteControlReceivedWithEvent:(UIEvent *)event;*方法	

				- (void)remoteControlReceivedWithEvent:(UIEvent *)event
				{
				// 判断 event 是否 remoteControl 事件
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
- 9.耳机拔掉之后，暂停音乐播放

				//    监听耳机的状态，拔出耳机后，通知观察者，暂停播放
				    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
				//    监听耳机的插拔
				- (void)routeChange:(NSNotification *)notification
				{
				    NSDictionary * dict = notification.userInfo;
				    NSInteger changeReason = [dict[AVAudioSessionRouteChangeReasonKey] integerValue];
				    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable)
				    {
				//        拿到 routeChange 时，原来的设备
				        AVAudioSessionRouteDescription * routeDescription = dict[AVAudioSessionRouteChangePreviousRouteKey];
				        AVAudioSessionPortDescription * portDescription = [routeDescription.outputs firstObject];
				//        如果原来的设备是耳机，就停止播放
				        if ([portDescription.portType isEqualToString:@"Headphones"])
				        {
				            [self.currentPlayer pause];
				            self.playOrPauseButton.selected = self.currentPlayer.isPlaying;
				            [self playOrPauseClick:nil];
				        }

				    }
				}
