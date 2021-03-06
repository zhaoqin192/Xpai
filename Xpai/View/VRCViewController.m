//
//  VRCViewController.m
//  Xpai
//
//  Created by  cLong on 16/1/12.
//  Copyright © 2016年  沃安科技. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>
#import <CoreMotion/CoreMotion.h>
#import "VRCViewController.h"
#import "UIButton+VRCButton.h"
#import "UILabel+VRCLabel.h"
#import "XpaiInterface.h"
#import "SwttingView.h"
#import "resolutionRatioView.h"
#import "BitStreamView.h"
#import "CLSettingConfig.h"
#import "NetOverTimeView.h"
#import "reconnectTimeView.h"
#import "transcribeView.h"
#import "TransferModelView.h"
#import "AudioParameterView.h"
#import "NetDeptionView.h"
#import "SaveRedioView.h"
#import "PlayViedoViewController.h"
#import "UploadVideoView.h"
#import "outPutLabel.h"
#import "WoanPlayerInterface.h"
#import "SetFPSView.h"
#import "resolutionRatioCell.h"
#import "VolumeView.h"
#import "UIView+Extension.h"
#import "MBProgressHUD.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@import CoreTelephony;


@interface VRCViewController ()<uploadChooseVideoDelegate,upLoadVideoDelegate,SubViewName,chooseAudioSampling,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SetFPSViewDelegate,UIGestureRecognizerDelegate>
{
    UIButton * _loginButton;//连接状态
    UIButton * _backButton;//返回按钮
    UIButton * _changeCameraButton;//切换前后摄像头
    UIButton * _preViewButton;//预览
    UIButton * _settingButton;//设置
    UIButton * _PlayVideoButton;//播放本地视频
    UIButton * _UploadingButton;//上传
    
    UIButton * _makeVideoButton;//录制视频
    UIButton * _suspendButton; //暂停按钮
    UIButton * _soundButton;//静音按钮
    UIButton * _photographButton;//拍照
    
    UILabel * _SDKVerLabel; //SDK版本
    UILabel * _DemoVerLabel; //Demo版本
    
    UILabel * _DurationLabel;//持续时间
    UILabel * _FPSLabel; //帧数
    UILabel * _NetLabel;//网络传输速度
    UILabel * _sentLabel;//上传内容大小
    UILabel * _Chche;//缓存大小
    UILabel * _informationLabel;//显示消息
    
    UIView * _settingBackgroundView;//设置页面背景
    UIImageView * logoImage;//LOGO图片
    SwttingView * _settingView;//设置页面
    resolutionRatioView * _resolution;//分辨率页面
    BitStreamView * _bitStreamView;//码流页面
    NetOverTimeView * _netOverTimeView;//网络超时页面
    reconnectTimeView * _reconnectOverTimeView;//重连超时页面
    transcribeView * _transcribeView;//录制类型页面
    AudioParameterView * _audioParameterView;//音频编码参数页面
    outPutLabel * _outPutView;//输出格式标签页面
    NetDeptionView * _deptionView;//网络自适应页面
    SaveRedioView * _saveRedioView;//是否自动保存视频页面
    SetFPSView * _setFPSView;//修改帧率页面
    TransferModelView * _TransferView;//修改输出流格式
    VolumeView * _VolumeView;//增音页面
    
    PlayViedoViewController * _playViedoView;//播放本地视频视频控制器
    UploadVideoView * _uploadVideoView;//上传页面
    UIImageView * _touchsImageView;//触摸图框

    
    UITableView * _audioSamplingTableView;//音频采样率参数选择页面
    NSArray * _audioSamplingDataSource;//音频采样率参数数组
    
    UIAlertView * _isOffLineAlert;//提示为离线模式
    UIAlertView * _loginAlert ;//提示是否断线
    UIAlertView * _backAlert;//提示是否返回
    
    SInt64 VideoID;//直播、录制ID
    NSString * _ViedoFileName;//文件名
    NSString * _ViedoFilePath;//文件路径
    NSString * _ViedoStreamID;//文件服务器ID
    
    NSTimer * _timer;//计时器
    
    AVCaptureVideoPreviewLayer * _PlayLayer;//预览层
    AVCaptureDevicePosition * _DevicePosition;//前置或后置摄像头
    AVCaptureVideoOrientation * _VideoOeientation;//视频方向
    
    AVAudioPlayer * _audioPlayer;//播放音频消息
    
    BOOL isMKPhoto;//是否开始预览(照片模式)
    BOOL isMKViedo;//开启录像模式
    BOOL isBackCamera; //是否为后摄像头
    BOOL isSuspend; //是否暂停
    BOOL isMute;//是否静音
    BOOL isback;//返回
    BOOL isReconnect;//是否重连
    
    int _durationTime;//录制时长
    CGFloat pinchScale;//缩放比例对照
    CGFloat zoomNum;//当前焦距
    
    NSInteger orientation;//选择竖屏或者横屏
    int workMord;
    
    CGFloat settingViewW;//普通子页面宽度
    CGFloat settingViewH;//普通子页面高度
    
    CGFloat screenW;
    CGFloat screenH;
    
    CTCallCenter * Callcenter;
}

@property (nonatomic, assign) BOOL isLive;

@end

@implementation VRCViewController

-(void)dealloc {
    [_loginButton release];
    [_DemoVerLabel release];
    [_changeCameraButton release];
    [_preViewButton release];
    [_settingButton release];
    [_backButton release];
    [_PlayVideoButton release];
    [_UploadingButton release];
    [_makeVideoButton release];
    [_suspendButton release];
    [_photographButton release];
    [_soundButton release];
    [_SDKVerLabel release];
    [_isOffLineAlert release];
    [_DurationLabel release];
//    [_FPSLabel release];
//    [_NetLabel release];
    [_sentLabel release];
    [_Chche release];
    [_informationLabel release];
    [_settingBackgroundView release];
    [_settingView release];
    [_resolution release];
    [_bitStreamView release];
    [_netOverTimeView release];
    [_reconnectOverTimeView release];
    [_transcribeView release];
    [_audioParameterView release];
    [_audioSamplingTableView release];
    [_audioSamplingDataSource release];
    [_saveRedioView release];
    [_playViedoView release];
    [_ViedoFileName release];
    [_ViedoFilePath release];
    [_ViedoStreamID release];
    [_uploadVideoView release];
    [_timer release];
    [_outPutView release];
    [_loginAlert release];
    [_backAlert release];
    [Callcenter release];
    [_setFPSView release];
    [_TransferView release];
    [_VolumeView release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景"]];
    [self DeviceInitialize];
    _isOffLineAlert = [[UIAlertView alloc]initWithTitle:@"离线模式" message:@"当前为离线模式 无法正常直播。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if (_isLogin == NO) {
        [_isOffLineAlert show];
    }
    
    [XpaiInterface setDelegate:self];
    
    [self NotificationCenter];
    [self CallPhone];
//    [self addLogoView];//创建Logo标志
    [self addButton];//创建各类按钮
    [self addSettingView];//创建设置页面
    [self adduploadVideoView];//上传视频页面
}

#pragma mark ---callPhone
-(void)CallPhone {
    __block typeof(_timer) weakTimer = _timer;
    
    Callcenter = [[CTCallCenter alloc] init];
    Callcenter.callEventHandler = ^(CTCall * call)
    {
        static BOOL callPhone;
        //TODO:检测到来电后的处理
        if ([XpaiInterface isRecording]) {
            if (callPhone) {
                [XpaiInterface resumeRecord];
                callPhone = NO;
                [weakTimer setFireDate:[NSDate distantPast]];
                NSLog(@"CURRENTVIDEO%lld",[XpaiInterface getCurrentRecordVideoID]);
            }else {
                [XpaiInterface interruptLive];
                callPhone = YES;
                [weakTimer setFireDate:[NSDate distantFuture]];
                }
        }
    };
}


#pragma 搭建通知中心
-(void)NotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeResolution) name:@"resolution" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenSamplingView) name:@"audioSampling" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:)
//                                                 name:UIApplicationDidEnterBackgroundNotification object:nil]; //监听是否触发home键挂起程序.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:)
//                                                 name:UIApplicationWillEnterForegroundNotification object:nil]; //监听是否重新进入程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishVudioMessage) name:WoanPlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishVudioMessage) name:WoanPlayerLoadDidPreparedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishVudioMessage) name:WoanPlayerPlaybackErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishVudioMessage) name:WoanPlayerSeekingDidFinishNotification object:nil];
    

}

//语音消息播放结束
-(void)finishVudioMessage {
    [self informationWithSte:@"语音消息播放结束"];
    NSLog(@"语音播放结束");
}

//更改分辨率
-(void)changeResolution {
    int camera = 0;
    if (isMKPhoto == YES && isMKViedo == NO) {
        if (isBackCamera == YES) {
            camera = AVCaptureDevicePositionBack;
        }else {
            camera = AVCaptureDevicePositionFront;
        }
        [XpaiInterface setVideoResolution:(int)[CLSettingConfig sharedInstance].resolution width:640 height:360];
        if ([CLSettingConfig sharedInstance].resolution == 9) {
            _PlayLayer.videoGravity = AVLayerVideoGravityResize;
        }else {
            _PlayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//设置预览页全屏
        }
        [XpaiInterface resetRecorder:camera workMode:PHOTO_MODE audioSampleRate:22050 focusMode:AVCaptureFocusModeContinuousAutoFocus torchMode:AVCaptureTorchModeOff captureVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
}

#pragma mark --设备初始化
-(void)DeviceInitialize {
    
    if (_isAcross == YES) {
        orientation = AVCaptureVideoOrientationLandscapeRight;
    }else {
        orientation = AVCaptureVideoOrientationPortrait;
    }
    isBackCamera = YES;
    isSuspend = NO;
    isMute = NO;
    [[CLSettingConfig sharedInstance] loadData];
    
    
    if (_isAcross == YES) {
        settingViewW = kScreenH / 3;
        settingViewH = kScreenW - 20;
    }else {
        settingViewW = kScreenW -20;
        settingViewH = kScreenH / 3;
    }
    
    NSLog(@"settingW%f settingH %f",settingViewW,settingViewH);
    
    _ViedoFileName = [[NSString alloc]init];
    _ViedoFilePath = [[NSString alloc]init];
    _ViedoStreamID = [[NSString alloc]init];
    
    _durationTime = 0;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];
    
    _audioSamplingDataSource = [[NSArray alloc]initWithObjects:@"8000",@"11025",@"12000",@"16000",@"22050",@"24000",@"32000",@"44100",@"48000",@"64000",@"88200",@"96000", nil];
    
    _loginAlert = [[UIAlertView alloc]initWithTitle:@"是否开启离线模式" message:@"开启离线模式后将无法直播与上传，离线后再次点击按钮可重新连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _loginAlert.delegate = self;
    
    _backAlert = [[UIAlertView alloc]initWithTitle:@"是否返回登录界面" message:@"您将要退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _backAlert.delegate = self;
    
    workMord = 1;
    
}

-(void)WhetherLogin {//判断网络状态
    
    if ([XpaiInterface isConnected] == TRUE) {
        _isLogin = YES;
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"断开链接"] forState:UIControlStateNormal];
    }else {
        _isLogin = NO;
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"链接"] forState:UIControlStateNormal];
    }
}

#pragma mark --计时器方法
-(void)timer {
    //持续时间
    _DurationLabel.text =[NSString stringWithFormat:@"Duration:%d",_durationTime];
    _Chche.text = [NSString stringWithFormat:@"Chche:%uk",(unsigned int)[XpaiInterface getCacheRemaining] / 1024];
    _durationTime += 1;
//    if (_durationTime % 2 == 0) {
//        [_makeVideoButton setBackgroundImage:[UIImage imageNamed:@"record_active"] forState:UIControlStateNormal];
//    }else  {
//        [_makeVideoButton setBackgroundImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
//    }

        NSLog(@"cache%u",(unsigned int)[XpaiInterface getCacheRemaining]);
}

#pragma mark --搭建界面
//创建Logo图标
-(void)addLogoView {
    CGFloat imageW = kScreenH / 3;
    CGFloat imageH = kScreenW / 4;
    
    logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenH / 3, kScreenW / 4 * 2 - imageH / 2, imageW, imageH)];
    logoImage.backgroundColor = [UIColor blackColor];
    logoImage.image = [UIImage imageNamed:@"logo"];
    logoImage.contentMode = UIViewContentModeScaleAspectFill;
    if (_isAcross == NO) {
        logoImage.frame =CGRectMake(kScreenW / 2 - imageW / 2, kScreenH / 4 * 2 - imageH / 2, imageW, imageH);
    }
    [self.view addSubview:logoImage];
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomSize:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];//添加捏合手势
}

//改变焦距
-(void)zoomSize:(UIPinchGestureRecognizer *)pinch {
    
    if (pinch.scale > 1 && pinch.scale > pinchScale ) {
        zoomNum = zoomNum + 0.04;
    }else if (pinch.scale > 1 && pinch.scale < pinchScale){
        zoomNum = zoomNum - 0.04;
    }else if (pinch.scale < 1 && pinch.scale > pinchScale) {
        zoomNum = zoomNum + 0.04;
    }else if (pinch.scale < 1 && pinch.scale < pinchScale){
        zoomNum = zoomNum - 0.04;
    }
    
    if (zoomNum  > 4) {
        zoomNum = 4;
    }else if( zoomNum  < 1){
        zoomNum = 1;
    }
    pinchScale = pinch.scale;
    NSLog(@"zoom:%f",zoomNum);
    NSLog(@"pinch:%f",pinch.scale);
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setVideoZoomFactor:zoomNum];
    [device unlockForConfiguration];
    
    CGFloat W ;
    CGFloat H ;
    if (_isAcross) {
        W = screenH;
        H = screenW;
    }else {
        W = screenW;
        H = screenH;
    }
    if ([pinch state] == UIGestureRecognizerStateEnded) {
        [XpaiInterface tapToFocus:CGPointMake(W / 2, H / 2)];
        if ([XpaiInterface isRecording] == YES) {
            [XpaiInterface setFocusMode:AVCaptureFocusModeAutoFocus];
            [self ViewAnimtion:CGPointMake(W/2 , H / 2 )];
        }
        
    }
}

//创建各类按钮
-(void)addButton {
    CGFloat buttonW = 40;
    CGFloat buttonH = 40;
    
    //连接Button
    if (_isLogin == YES) {//连接上
        _loginButton = [UIButton ButtonWithFrame:CGRectMake(34, 30, buttonW, buttonH) image:@"断开链接"];
    }else {//未连接
       _loginButton = [UIButton ButtonWithFrame:CGRectMake(34, 30, buttonW, buttonH) image:@"链接"];
        CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"opacity"];
        basic.toValue = [NSNumber numberWithFloat:0];
        basic.duration = 1;
        basic.autoreverses = YES;
        basic.repeatCount = MAXFLOAT;
        basic.removedOnCompletion = NO;
        [_loginButton.layer addAnimation:basic forKey:@"123"];
    }
    [_loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    //返回按钮
//    _backButton = [UIButton ButtonWithFrame:CGRectMake(_loginButton.maxX + 10,_loginButton.y,buttonW,  buttonH) image:@"get"];
//    _backButton = [UIButton ButtonWithFrame:CGRectMake(30, 30, buttonW, buttonH) image:@"断开链接"];
//    [_backButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_backButton];
    
    UIView *buttonBackView = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenW / 2 - buttonH, 48, 96)];
    buttonBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Rectangle 2"]];
    
    //摄像头切换
    _changeCameraButton = [UIButton ButtonWithFrame:CGRectMake(4, 2, buttonW, buttonH) image:@"p2"];
    [_changeCameraButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    _changeCameraButton.hidden = YES;
//    [self.view addSubview:_changeCameraButton];
    [buttonBackView addSubview:_changeCameraButton];
    
//    //预览
//    _preViewButton = [UIButton ButtonWithFrame:CGRectMake(10, _changeCameraButton.maxY + 5, buttonW, buttonH) image:@"preview_inactive"];
//    [_preViewButton addTarget:self action:@selector(preView) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_preViewButton];
    //设置
    _settingButton = [UIButton ButtonWithFrame:CGRectMake(9, 60, buttonW - 10, buttonH - 10) image:@"设置"];
    [_settingButton addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_settingButton];
    [buttonBackView addSubview:_settingButton];
    [self.view addSubview:buttonBackView];
    
//    //播放本地视频
//    _PlayVideoButton = [UIButton ButtonWithFrame:CGRectMake(10, _settingButton.maxY + 5, buttonW, buttonH) image:@"IconsLand_017"];
//    [_PlayVideoButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_PlayVideoButton];
//    //上传
//    _UploadingButton = [UIButton ButtonWithFrame:CGRectMake(10, kScreenW - buttonH - 10, buttonW, buttonH) image:@"u=1237581358,81804969&fm=21&gp=0"];
//    [_UploadingButton addTarget:self action:@selector(uploadVideoFile) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_UploadingButton];
    
        //录制视频
    _makeVideoButton = [UIButton ButtonWithFrame:CGRectMake(kScreenH - 70, kScreenW / 2 - 30, 60, 60) image:@"录制"];
    if (_isAcross == NO) {
        _makeVideoButton.frame = CGRectMake(kScreenW / 2 - buttonW / 2, kScreenH - buttonH - 10, buttonW, buttonH);
    }
    [_makeVideoButton addTarget:self action:@selector(makeVideo) forControlEvents:UIControlEventTouchUpInside];
//    [_makeVideoButton addTarget:self action:@selector(liveVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_makeVideoButton];
    
    //暂停录制、直播
    _suspendButton = [UIButton ButtonWithFrame:CGRectMake(_makeVideoButton.x, _makeVideoButton.maxY + 10, buttonW, buttonH) image:@"暂停"];
    _suspendButton.hidden = YES;
    [_suspendButton addTarget:self action:@selector(suspendVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_suspendButton];
    
    //返回上一层
    UIButton *backButton = [UIButton ButtonWithFrame:CGRectMake(34, kScreenW - 70, buttonW, buttonH) image:@"关闭"];
    [backButton addTarget:self action:@selector(backLastView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
//    //静音模式
//    _soundButton = [UIButton ButtonWithFrame:CGRectMake(_makeVideoButton.x, _suspendButton.maxY + 10, buttonW, buttonH) image:@"mic"];
//    _soundButton.hidden = YES;
//    [_soundButton addTarget:self action:@selector(mute) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_soundButton];
    
//    //拍照
//    _photographButton = [UIButton ButtonWithFrame:CGRectMake(_makeVideoButton.x, kScreenW - buttonH - 10, buttonW, buttonH) image:@"take_picture"];
//    if (_isAcross == NO) {
//        _photographButton.frame = CGRectMake(kScreenW - 10 - buttonW, _makeVideoButton.y, buttonW, buttonH);
//        _UploadingButton.frame = CGRectMake(10, kScreenH - buttonH - 10, buttonW, buttonH);
//        _PlayVideoButton.frame = CGRectMake(10, _UploadingButton.y - buttonW - 10, buttonW, buttonH);
//        _settingButton.frame = CGRectMake(10, _PlayVideoButton.y - buttonW - 10, buttonW, buttonH);
//        _preViewButton.frame = CGRectMake(10, _settingButton.y - buttonW - 10, buttonW, buttonH);
//        _changeCameraButton.frame = CGRectMake(10, _preViewButton.y - buttonW -10, buttonW, buttonH);
//        _suspendButton.frame = CGRectMake(_makeVideoButton.maxX + 10, _makeVideoButton.y, buttonW, buttonH);
//        _soundButton.frame = CGRectMake(_makeVideoButton.x - buttonW - 10, _makeVideoButton.y, buttonW - 5, buttonH - 5);
//    }
//    [_photographButton addTarget:self action:@selector(Photograph) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_photographButton];
    
}

- (void)backLastView {
    
    NSString *message = nil;
    if (isMKViedo == YES) {
        message = @"是否要终止直播退出应用";
    }
    else {
        message = @"是否要退出应用";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (isMKViedo == YES) {
            [XpaiInterface stopRecord];
        }
        if (_isLogin == YES) {
            [XpaiInterface disconnect];
        }
        exit(0);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:determineAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

//创建设置页面
-(void)addSettingView {
    
    _settingBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW * -1, 0, kScreenW, kScreenH)];
    _settingBackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    if (_isAcross == YES) {
        _settingBackgroundView.backgroundColor = [UIColor clearColor];
    }
//    _settingBackgroundView.alpha = 0.5;
    [self.view addSubview:_settingBackgroundView];
    
    _settingView = [[SwttingView alloc]initWithFrame:CGRectMake(0, 15, settingViewW, settingViewH)];
    _settingView.delegate = self;
    [_settingBackgroundView addSubview:_settingView];
    
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [_settingView addGestureRecognizer:swipe];
    [swipe release];
    
    [self resolutionView];//分辨率页面
    [self BitStreamView];//码流页面
    [self NetOverTimeView];//网络超时页面
    [self ReconnectOverTimeView];//重连超时页面
    [self transcribeView];//录制类型页面
    [self audioParameterView];//音频编码参数
    [self audioSamplingTabView];//音频采样率参数选择页面
    [self outPutView];//输出格式标签
    [self netDeptionView];//网络自适应页面
    [self saveRedioView];//视频自动保存页面
    [self setFPSView];//设置FPS页面
    [self setTranferModelView];//设置输出流格式
    [self setVolumeView];//设置增音页面
}

//上传页面
-(void)adduploadVideoView {
    _uploadVideoView = [[UploadVideoView alloc]initWithFrame:CGRectMake(0, kScreenW, kScreenH, 50)];
    _uploadVideoView.Delegate = self;
    NSLog(@"屏幕宽度高度:%f %f",kScreenW,kScreenH);
    screenW = kScreenW;
    screenH = kScreenH;
//    [self.view addSubview:_uploadVideoView];
}

#pragma mark --设置页面子页面
//分辨率
-(void) resolutionView {
    _resolution = [[resolutionRatioView alloc]initWithFrame:CGRectMake(0, 15, settingViewW, settingViewH)];
    _resolution.isVertical = !_isAcross;
    _resolution.alpha = 0;
    [self.view addSubview:_resolution];
}

//码流页面
-(void)BitStreamView {
    _bitStreamView = [[BitStreamView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 -30 , kScreenW, 90)];
    _bitStreamView.alpha = 0;
    [self.view addSubview:_bitStreamView];
    
}

//网络超时页面
-(void)NetOverTimeView {
    _netOverTimeView = [[NetOverTimeView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 -30 , kScreenW, 90)];
    _netOverTimeView.alpha = 0;
    [self.view addSubview:_netOverTimeView];
}

//重连超时页面
-(void)ReconnectOverTimeView {
    _reconnectOverTimeView = [[reconnectTimeView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 - 30, kScreenW, 90)];
    _reconnectOverTimeView.alpha = 0;
    [self.view addSubview:_reconnectOverTimeView];
}

//录制类型页面
-(void)transcribeView {
    _transcribeView = [[transcribeView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 - 30, settingViewW, 140)];
    _transcribeView.alpha = 0;
    _transcribeView.isVertical = !_isAcross;
    [self.view addSubview:_transcribeView];
}


//音频编码参数页面
-(void)audioParameterView {
    _audioParameterView = [[AudioParameterView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 - 30, settingViewW, 180)];
    _audioParameterView.alpha = 0;
    _audioParameterView.delegate = self;
    [self.view addSubview:_audioParameterView];
}

//音频采样率参数选择页面
-(void)audioSamplingTabView {
    _audioSamplingTableView = [[UITableView alloc]initWithFrame:CGRectMake(kScreenH - settingViewW , 10, settingViewW, settingViewH) style:UITableViewStylePlain];
    if (_isAcross == NO) {
        _audioSamplingTableView.x = 0;
        _audioSamplingTableView.y = kScreenH - settingViewH;
    }
    _audioSamplingTableView.dataSource = self;
    _audioSamplingTableView.delegate = self;
    _audioSamplingTableView.bounces = NO;
    _audioSamplingTableView.alpha = 0;
    [self.view addSubview:_audioSamplingTableView];
}

//输出格式标签
-(void)outPutView {
    _outPutView = [[outPutLabel alloc]initWithFrame:CGRectMake(0, _sentLabel.maxY, settingViewW, 70)];
    _outPutView.alpha = 0;
    [self.view addSubview:_outPutView];
}

//网络自适应页面
-(void)netDeptionView {
    _deptionView = [[NetDeptionView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 - 30, settingViewW, 140)];
    _deptionView.alpha = 0;
    [self.view addSubview:_deptionView];
}

//保存视频页面
-(void)saveRedioView {
    _saveRedioView = [[SaveRedioView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 - 30, settingViewW, 140)];
    _saveRedioView.alpha = 0;
    [self.view addSubview:_saveRedioView];
}

-(void)setFPSView {
    _setFPSView = [[SetFPSView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 - 30, settingViewW, 180)];
    _setFPSView.delegate = self;
    _setFPSView.alpha = 0;
    [self.view addSubview:_setFPSView];
}

-(void)setTranferModelView {
    _TransferView = [[TransferModelView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 -30, settingViewW, 160)];
    _TransferView.alpha = 0;
    [self.view addSubview:_TransferView];
}


-(void)setVolumeView {
    _VolumeView = [[VolumeView alloc]initWithFrame:CGRectMake(0, kScreenW / 2 -30 , kScreenW, 90)];
    _VolumeView.alpha = 0;
    [self.view addSubview:_VolumeView];

}

#pragma mark -- 手势方法
//设置页面向左轻扫
-(void)swipeGesture {
    [UIView animateWithDuration:0.3 animations:^{
        _settingView.x = _settingView.width * -1;
        _settingBackgroundView.x = _settingBackgroundView.width * -1;
        _resolution.x = 0;
        _resolution.alpha = 0;
        _bitStreamView.x = 0;
        _bitStreamView.alpha = 0;
        _netOverTimeView.x = 0;
        _netOverTimeView.alpha = 0;
        _reconnectOverTimeView.x = 0;
        _reconnectOverTimeView.alpha = 0;
        _transcribeView.x = 0;
        _transcribeView.alpha = 0;
        _audioParameterView.x = 0;
        _audioParameterView.alpha = 0;
        _audioSamplingTableView.alpha = 0;
        _deptionView.x = 0;
        _deptionView.alpha = 0;
        _saveRedioView.x = 0;
        _saveRedioView.alpha = 0;
        _outPutView.x = 0;
        _outPutView.alpha = 0;
        _setFPSView.x = 0;
        _setFPSView.alpha = 0;
        _TransferView.x = 0;
        _TransferView.alpha = 0;
        _VolumeView.x = 0;
        _VolumeView.alpha = 0;

    }];
}

#pragma mark -- informationLabel消息提示方法
-(void)informationWithSte:(NSString *)str {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = str;
    [hud hide:YES afterDelay:1.5f];
    
}

//多线程方法
-(void)showInformation {
    sleep(3);
    [UIView animateWithDuration:3 animations:^{
        _informationLabel.alpha = 0;
    }];
}

#pragma mark -- 各类点击方法
//连接 断开连接
-(void)login {
    if (_isLogin == NO) {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        switch (_kindOfLogin) {
            case 1:
            {
                [XpaiInterface connectCloud:@"http://c.zhiboyun.com/api/20140928/get_vs" u:_UserName pd:_PassWord svcd:_serviceCode];
            }
                break;
            case 2:
            {
                [XpaiInterface connectCloud:_GetVCUrl u:_UserName pd:_PassWord svcd:_serviceCode];
            }
                break;
            case 3:
            {
                [XpaiInterface connectToServer:_mainUrl p:_mainPort u:_UserName pd:_PassWord svcd:_serviceCode OnUDP:_isTcp];
            }
                break;
                
            default:
                break;
        }
        
        }else {
            [_loginAlert show];
    }
}

//返回按钮
-(void)backView {
    [_backAlert show];
}
//预览
-(void)preView {

    if (isMKPhoto == NO) {
        [XpaiInterface setAudioRecorderParams:(int)[CLSettingConfig  sharedInstance].audioParameter channels:1 sampleRate:(int)[CLSettingConfig sharedInstance].audioSampling  audioBitRate:(int)[CLSettingConfig sharedInstance].audioBit];//音频
        
        int camera;//判断前后摄像头
        if (isBackCamera == YES) {
            camera = AVCaptureDevicePositionBack;
        }else {
            camera =AVCaptureDevicePositionFront;
        }
        NSLog(@"分辨率%d",(int)[CLSettingConfig sharedInstance].resolution);
        NSInteger playerOrientation;
        if (_isAcross == YES) {
            orientation = AVCaptureVideoOrientationLandscapeRight;
            playerOrientation = AVCaptureVideoOrientationLandscapeRight;
        }else {
            orientation = AVCaptureVideoOrientationPortrait;
            playerOrientation = AVCaptureVideoOrientationPortrait;
        }
        
        [[CLSettingConfig sharedInstance]loadData];
        [XpaiInterface setVideoResolution:(int)[CLSettingConfig sharedInstance].resolution width:640 height:360];
        [XpaiInterface initRecorder:camera workMode:workMord audioSampleRate:22050 focusMode:AVCaptureFocusModeContinuousAutoFocus  torchMode:AVCaptureTorchModeOff  glView:nil prevRect:self.view.frame captureVideoOrientation:orientation];
        _PlayLayer = [AVCaptureVideoPreviewLayer layerWithSession:[XpaiInterface getVideoCaptureSession] ];
        NSLog(@"分辨率%ld",(long)[CLSettingConfig sharedInstance].resolution);

        [self.view.layer insertSublayer:_PlayLayer atIndex:1];

            _PlayLayer.frame = self.view.frame;
            _PlayLayer.connection.videoOrientation =playerOrientation;//设置预览方向向右边
        
        if ([CLSettingConfig sharedInstance].resolution == 9) {
            _PlayLayer.videoGravity = AVLayerVideoGravityResize;
        }else {
            _PlayLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//设置预览页全屏
        }
        [XpaiInterface startVideoCapture];
        
        [_preViewButton setBackgroundImage:[UIImage imageNamed:@"preview"] forState:UIControlStateNormal];
        _changeCameraButton.hidden = NO;
        isMKPhoto = YES;
    }else {
        [_preViewButton setBackgroundImage:[UIImage imageNamed:@"preview_inactive"] forState:UIControlStateNormal];
        if (_PlayLayer) {
        [_PlayLayer removeFromSuperlayer];
        [XpaiInterface stopVideoCapture];
        }

        isMKPhoto = NO;
        _changeCameraButton.hidden = YES;
        if (isMKViedo ==YES) {
            [XpaiInterface stopRecord];
            isMKViedo = NO;
        }
    }
}

//切换摄像头
-(void)changeCamera {
    int workMode;
    if (isMKViedo == YES) {//判定是否为视频模式
        workMode = VIDEO_MODE;
    }else {
        workMode = PHOTO_MODE;
    }
    if (isBackCamera == YES) {
        isBackCamera = NO;
        [self RePreviewWithCameraModel:workMode];//重置预览
    }else {
        isBackCamera = YES;
        [self RePreviewWithCameraModel:workMode];
    }
}

//设置
-(void)setting {
    if (_settingBackgroundView.x != 0) {
        [UIView animateWithDuration:0.3 animations:^{
//            _settingView.x = 0;
            _settingBackgroundView.x = 0;
            _settingView.x = 0;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
//            _settingView.x = _settingView.width * -1;
            _settingBackgroundView.x = kScreenW * -1;
        }];
    }
}

//播放本地视频
-(void)playVideo {
    _playViedoView = [[PlayViedoViewController alloc]init];
    _playViedoView.screenW = screenW;
    _playViedoView.screenH = screenH;
    _playViedoView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:_playViedoView animated:YES completion:^{
        
    }];
}

//拍照
-(void)Photograph {
    if (isMKPhoto) {
        [XpaiInterface takePhoto];//拍照
    }else {
        UIAlertView * PhotoAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请打开预览模式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [PhotoAlert show];
        [PhotoAlert release];
    }
    
}

//录制视频
-(void)makeVideo {
    if (isMKPhoto ==NO) {
        workMord = 1;
        [self preView];
    }
    if (!_isLive) {//未连接服务器
        [self RePreviewWithCameraModel:VIDEO_MODE];
        [XpaiInterface setFocusMode:AVCaptureFocusModeAutoFocus];//设置为 手动对焦
        
        [self WhetherLogin];//判定是否连上服务器
        if (_isLogin == YES) {
            [self live];
        }else {
            [self record];
        }
        
        [_makeVideoButton setBackgroundImage:[UIImage imageNamed:@"停止"] forState:UIControlStateNormal];
        _photographButton.hidden = YES;
//        _suspendButton.hidden = NO;
//        _soundButton.hidden = NO;
        _preViewButton.hidden = YES;
        _PlayVideoButton.hidden = YES;
        isMKViedo = YES;
        _settingButton.hidden = YES;
        _UploadingButton.hidden = YES;
        [_timer setFireDate:[NSDate distantPast]];
        self.isLive = YES;
    }
    else {
        if (isSuspend == NO) {
            [self informationWithSte:@"暂停直播"];
            CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"opacity"];
            basic.toValue = [NSNumber numberWithFloat:0];
            basic.duration = 1;
            basic.autoreverses = YES;
            basic.repeatCount = MAXFLOAT;
            basic.removedOnCompletion = NO;
            [_suspendButton.layer addAnimation:basic forKey:@"123"];
            isSuspend = YES;
            [XpaiInterface pauseRecord];
            [_timer setFireDate:[NSDate distantFuture]];
            NSLog(@"%d",[XpaiInterface isConnected]);
            [_makeVideoButton setBackgroundImage:[UIImage imageNamed:@"录制"] forState:UIControlStateNormal];

        }else {
//            [_suspendButton setBackgroundImage:[UIImage imageNamed:@"record_pause"] forState:UIControlStateNormal];
            isSuspend = NO;
//            [_suspendButton.layer removeAnimationForKey:@"123"];
            [XpaiInterface resumeRecord];
            [_timer setFireDate:[NSDate distantPast]];
            [self informationWithSte:@"继续直播"];
            [_makeVideoButton setBackgroundImage:[UIImage imageNamed:@"停止"] forState:UIControlStateNormal];

        }
    }
}

//暂停视频录制
-(void)suspendVideo {
    
    if (_isLogin == YES) {
        if (isSuspend == NO) {
            [self informationWithSte:@"暂停录制"];
            CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"opacity"];
            basic.toValue = [NSNumber numberWithFloat:0];
            basic.duration = 1;
            basic.autoreverses = YES;
            basic.repeatCount = MAXFLOAT;
            basic.removedOnCompletion = NO;
            [_suspendButton.layer addAnimation:basic forKey:@"123"];
            isSuspend = YES;
            [XpaiInterface pauseRecord];
            [_timer setFireDate:[NSDate distantFuture]];
            NSLog(@"%d",[XpaiInterface isConnected]);
        }else {
            [_suspendButton setBackgroundImage:[UIImage imageNamed:@"record_pause"] forState:UIControlStateNormal];
            isSuspend = NO;
            [_suspendButton.layer removeAnimationForKey:@"123"];
            [XpaiInterface resumeRecord];
            [_timer setFireDate:[NSDate distantPast]];
            [self informationWithSte:@"继续录制"];
        }
    }else {
        if (isSuspend == NO) {
            [XpaiInterface pauseRecord];
            CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"opacity"];
            basic.toValue = [NSNumber numberWithFloat:0];
            basic.duration = 1;
            basic.autoreverses = YES;
            basic.repeatCount = MAXFLOAT;
            basic.removedOnCompletion = NO;
            [_suspendButton.layer addAnimation:basic forKey:@"123"];
            isSuspend = YES;
            [_timer setFireDate:[NSDate distantFuture]];
            [self informationWithSte:@"暂停录制"];
        }else {
            [XpaiInterface resumeRecord];
            [_suspendButton setBackgroundImage:[UIImage imageNamed:@"record_pause"] forState:UIControlStateNormal];
            isSuspend = NO;
            [_suspendButton.layer removeAnimationForKey:@"123"];
            [_timer setFireDate:[NSDate distantPast]];
            [self informationWithSte:@"继续录制"];
        }
    }
}

//静音
-(void)mute {
    if (isMute == YES) {
        [_soundButton setBackgroundImage:[UIImage imageNamed:@"mic"] forState:UIControlStateNormal];
        [XpaiInterface toggleMute:NO];
        isMute = NO;
    }else {
        [_soundButton setBackgroundImage:[UIImage imageNamed:@"mic_mute"] forState:UIControlStateNormal];
        [XpaiInterface toggleMute:YES];
        isMute = YES;
                
    }
}

//上传视频文件
-(void)uploadVideoFile {
    
    
    if (_isLogin == NO) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"当前为离线模式" message:@"请登陆后继续上传视频" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
//    [UIView animateWithDuration:0.3 animations:^{
//        _uploadVideoView.y = screenW - 50;
//        NSLog(@"上传页面Y坐标%f",kScreenW);
//
//    }]; //因为一些功能未开发 暂时用不上
    
    PlayViedoViewController * videoView = [[PlayViedoViewController alloc]init];
    videoView.isUpLoad = YES;
    videoView.Delegate = self;
    videoView.screenH = screenH;
    videoView.screenW = screenW;
    videoView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:videoView animated:YES completion:^{
        //                [videoView release];
//        _uploadVideoView.y = screenW + 50;
    }];
    
}

#pragma  mark -- 提示框代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == _loginAlert) {
        if (buttonIndex == 1) {
            [XpaiInterface disconnect];
        }
    }else if (alertView == _backAlert){
        if (buttonIndex == 1) {
            isback = YES;
            if (isMKViedo == YES) {
                [XpaiInterface stopRecord];
            }
            if (_isLogin == YES) {
                [XpaiInterface disconnect];
            }
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }
}

#pragma mark -- 直播与录像
//直播
-(void)live {
    [self informationWithSte:@"开始直播"];
    [[CLSettingConfig sharedInstance] loadData];
    [XpaiInterface setVideoBitRate:(int)[CLSettingConfig sharedInstance].BitStream];//设置码流
    NSLog(@"码流%d",(int)[CLSettingConfig sharedInstance].BitStream);
    [XpaiInterface setNetWorkingAdaptive:[CLSettingConfig sharedInstance].NetDeption];//网络自适应
    NSLog(@"网络自适应%d",[CLSettingConfig sharedInstance].NetDeption);
    [XpaiInterface setNetworkTimeout:(int)[CLSettingConfig sharedInstance].NetOverTime];//设置网络超时
    NSString *sa = [NSString stringWithFormat:@"请大家"];
    sa = [sa stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *paras = [NSDictionary dictionaryWithObjectsAndKeys:sa,XPAI_TASK_OPAQUE,[CLSettingConfig sharedInstance].outPutTag,XPAI_OUTPUT_TAG,nil];
    int transcribe;
    if ([CLSettingConfig sharedInstance].transcribe == 0) {//选择硬编或软编
        transcribe = HARDWARE_SOFTWARE_ENCODER_LOW_DELAY;
    }else {
        transcribe = HARDWARE_ENCODER_STREAM;
    }
    
    NSLog(@"%d",(int)[CLSettingConfig sharedInstance].TransferModel);
    
    VideoID = [XpaiInterface startRecord:transcribe TransferMode:(int)[CLSettingConfig sharedInstance].TransferModel forceReallyFile:[CLSettingConfig sharedInstance].SaveRedio volume:[CLSettingConfig sharedInstance].volume parameters:paras];
}

//录制
-(void)record {
    NSLog(@"录制视频");
    [self informationWithSte:@"开始录制本地视频"];

    VideoID = [XpaiInterface startRecord:HARDWARE_ENCODER_LOCAL_STORAGE_ONLY TransferMode:(int)[CLSettingConfig sharedInstance].TransferModel forceReallyFile:TRUE volume:[CLSettingConfig sharedInstance].volume parameters:nil];
}

#pragma mark ---常用方法调用
//重置预览
-(void)RePreviewWithCameraModel:(int)Model  {
    workMord = Model;
    int camera;//判定前后摄像头
    if (isBackCamera == YES) {
        camera = AVCaptureDevicePositionBack;
    }else {
        camera = AVCaptureDevicePositionFront;
    }
    if ([XpaiInterface isRecording]) {
        [XpaiInterface resetRecorder:camera workMode:Model audioSampleRate:22050 focusMode:AVCaptureFocusModeAutoFocus torchMode:AVCaptureTorchModeOff captureVideoOrientation:orientation];
    }else {
     [XpaiInterface resetRecorder:camera workMode:Model audioSampleRate:22050 focusMode:AVCaptureFocusModeContinuousAutoFocus torchMode:AVCaptureTorchModeOff captureVideoOrientation:orientation];
    }
}

#pragma mark -- xpaiInterface回调


//语音消息
-(void)doReceiveAudioMessage:(NSString *)userName msgFile:(NSString *)url {
    [self informationWithSte:[NSString stringWithFormat:@"收到一条来自%@用户的语音消息",userName]];
    WoanPlayerInterface * woanPlayer = [[WoanPlayerInterface alloc]initWithContentString:url parameters:nil];
    [woanPlayer prepareToPlay];
    [woanPlayer release];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self informationWithSte:@"语音消息播放结束"];
}

//文字消息
-(void)doReceiveMessage:(NSString *)userName msg:(NSString *)message {
        NSString * str = [NSString stringWithFormat:@"用户:%@  发送消息:%@",userName,message];
        [self informationWithSte:str];
    NSLog(@"message:%@",message);
        
//        WoanPlayerInterface * woanPlayer = [[WoanPlayerInterface alloc]initWithContentString:message parameters:nil];
//        [woanPlayer prepareToPlay];
//        [woanPlayer release];
    
}



//拍照回调
- (void)didTakePhoto:(NSString *)url {
    NSLog(@"拍照回调%@",url);
    [self informationWithSte:[NSString stringWithFormat:@"照片存储路径：%@",url]];
}

//服务器收到发送数据后回调
- (void)didSendToServer:(SInt64)ID sentLen:(UInt64)sentLen currentPoint:(UInt32)currentPoint videoLen:(UInt32)videoLen {
//    NSLog(@"631行 服务器接收数据回调%d",(unsigned int)sentLen);
    int num =(unsigned int) sentLen / 1024;
    _sentLabel.text = [NSString stringWithFormat:@"Sent: %02d KByte",num];
//    NSLog(@"cache%u",(unsigned int)[XpaiInterface getCacheRemaining]);
    
}

-(void)didCompleteUpload:(SInt64)ID {
    NSLog(@"uploadVideoSuccess:%lld",ID);
    NSLog(@"上传成功");
//    [self informationWithSte:[NSString stringWithFormat:@"上传视频成功 ID：%lld",ID]];
    [self informationWithSte:[NSString stringWithFormat:@"视频上传成功"]];
    [UIView animateWithDuration:0.3 animations:^{
        _UploadingButton.alpha = 1;
        _makeVideoButton.alpha = 1;
    }];
}

//当服务器成功获取一定数据 生成直播流
-(void)didStreamIdNotify:(NSString *)streamId {
    _ViedoStreamID = [XpaiInterface getVideoStreamID:VideoID ];//视频服务器上的ID
    _ViedoFileName = [XpaiInterface getVideoFileName:VideoID];//获取本地视频的文件名
    _ViedoFilePath = [XpaiInterface getVideoStreamPath:VideoID];//获取本地视频的路径
//    NSLog(@"VideoStreamID : %@",_ViedoStreamID);
//    NSLog(@"videoFileName : %@",_ViedoFileName);
//    NSLog(@"videoFilePath : %@",_ViedoFilePath);
}

-(void)didDisconnect {
    NSLog(@"断开连接");
    _isLogin = NO;
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"链接"] forState:UIControlStateNormal];
    CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"opacity"];
    basic.toValue = [NSNumber numberWithFloat:0];
    basic.duration = 1;
    basic.autoreverses = YES;
    basic.repeatCount = MAXFLOAT;
    basic.removedOnCompletion = NO;
    [_loginButton.layer addAnimation:basic forKey:@"disconnect"];
    if (!isback) {
        [_isOffLineAlert show];
    }
}

-(void)didConnectToServer {
    NSLog(@"链接成功");
    _isLogin = YES;
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"断开链接"] forState:UIControlStateNormal];
    [_loginButton.layer removeAnimationForKey:@"disconnect"];
}

//尝试重新连接回调
-(void)doTryResumeLive {
    if (!isReconnect) {
        CABasicAnimation * basic = [CABasicAnimation animationWithKeyPath:@"opacity"];
        basic.toValue = [NSNumber numberWithFloat:0];
        basic.duration = 1;
        basic.autoreverses = YES;
        basic.repeatCount = MAXFLOAT;
        basic.removedOnCompletion = NO;
        [_loginButton.layer addAnimation:basic forKey:@"disconnect"];
    }
    isReconnect = YES;
    [self informationWithSte:@"正在尝试重连，请保持网络畅通"];
}

//重连成功回调
-(void)didResumeLiveOk {
    [self informationWithSte:@"尝试重连成功，恢复直播"];
    [_loginButton.layer removeAnimationForKey:@"disconnect"];
    isReconnect =  NO;
}

//重连失败回调
-(void)didResumeLiveFail:(int)errorCode {
    [self informationWithSte:[NSString stringWithFormat:@"错误码:%d 尝试重连失败，请重新登录直播",errorCode]];
    isReconnect = NO;
    [_loginButton.layer removeAnimationForKey:@"disconnect"];
}
#pragma mark --设置页面及子页面的代理方法
//设置页面的代理方法
-(void)subViewAppearWithNum:(NSInteger)num {
    for (UIView * view in self.view.subviews) {
        if ([view isKindOfClass:[resolutionRatioView class]] || [view isKindOfClass:[BitStreamView class]] || [view isKindOfClass:[NetOverTimeView class]] ||[view isKindOfClass:[transcribeView class]] || [view isKindOfClass:[AudioParameterView class]] || [view isKindOfClass:[NetDeptionView class]]|| [view isKindOfClass:[SaveRedioView class]] || [view isKindOfClass:[outPutLabel class]] || [view isKindOfClass:[reconnectTimeView class]] || [view isKindOfClass:[SetFPSView class]] || [view isKindOfClass:[TransferModelView class]] || [view isKindOfClass:[VolumeView class]]) {
            view.alpha = 0 ;
            view.x = 0;
        }
        _audioSamplingTableView.alpha = 0;
    }
    switch (num) {
        case 0://分辨率
        {
            [UIView animateWithDuration:0.3 animations:^{
                _resolution.alpha = 1;
                if (_isAcross == YES) {
                    _resolution.x = _settingView.maxX;
                }else {
                    _resolution.y = _settingView.maxY + 2;
                }
            }];
        }
            break;
        case 1://码流设置
        {
            [UIView animateWithDuration:0.3 animations:^{
                _bitStreamView.alpha = 1;
                if (_isAcross == YES) {
                    _bitStreamView.x = _settingView.maxX;
                }else {
                    _bitStreamView.y = _settingView.maxY + 2;
                    
                }
            }];
        }
            break;
        case 2://网络超时设置
        {
            [UIView animateWithDuration:0.3 animations:^{
                _netOverTimeView.alpha = 1;
                if (_isAcross == YES) {
                    _netOverTimeView.x = _settingView.maxX;
                }else {
                    _netOverTimeView.y = _settingView.maxY + 2;
                }
            }];
        }
            break;
        case 3://录制类型
        {
            [UIView animateWithDuration:0.3 animations:^{
                _reconnectOverTimeView.alpha = 1;
                if (_isAcross == YES) {
                    _reconnectOverTimeView.x = _settingView.maxX;
                }else {
                    _reconnectOverTimeView.y = _settingView.maxY + 2;
                }
                
            }];
        }
            break;

        case 4://录制类型
        {
            [UIView animateWithDuration:0.3 animations:^{
                _transcribeView.alpha = 1;
                if (_isAcross == YES) {
                    _transcribeView.x = _settingView.maxX;
                }else {
                    _transcribeView.y = _settingView.maxY + 2;
                }

            }];
        }
            break;
        case 5://音频编码参数
        {
            [UIView animateWithDuration:0.3 animations:^{
                _audioParameterView.alpha = 1;
                if (_isAcross == YES) {
                    _audioParameterView.x = _settingView.maxX;
                }else {
                    _audioParameterView.y = _settingView.maxY + 2;
                }

            }];
        }
            break;
        case 6://输出格式标签
        {
            [UIView animateWithDuration:0.3 animations:^{
                _outPutView.alpha = 1;
                if (_isAcross == YES) {
                    _outPutView.x = _settingView.maxX;
                }else {
                    _outPutView.y = _settingView.maxY + 2;
                }

            }];
        }
            break;
        case 7://网络自适应
        {
            [UIView animateWithDuration:0.3 animations:^{
                _deptionView.alpha = 1;
                if (_isAcross == YES) {
                    _deptionView.x = _settingView.maxX;
                }else {
                    _deptionView.y = _settingView.maxY + 2;
                }

            }];
        }
            break;
        case 8://是否保存视频文件
        {
            [UIView animateWithDuration:0.3 animations:^{
                _saveRedioView.alpha = 1;
                if (_isAcross == YES) {
                    _saveRedioView.x = _settingView.maxX;
                }else {
                    _saveRedioView.y = _settingView.maxY + 2;
                }

            }];
        }
            break;
            
            
        case 9://设置帧率
        {
            [UIView animateWithDuration:0.3 animations:^{
                _setFPSView.alpha = 1;
                if (_isAcross == YES) {
                    _setFPSView.x = _settingView.maxX;
                }else {
                    _setFPSView.y = _settingView.maxY + 2;
                }
                
            }];

            
        }
            break;
            
            case 10://设置输出流
        {
            [UIView animateWithDuration:0.3 animations:^{
                _TransferView.alpha = 1;
                if (_isAcross == YES) {
                    _TransferView.x = _settingView.maxX;
                }else {
                    _TransferView.y = _settingView.maxY + 2;
                }
                
            }];

        }
            break;
            
            case 11://增音
        {
            [UIView animateWithDuration:0.3 animations:^{
                _VolumeView.alpha = 1;
                if (_isAcross == YES) {
                    _VolumeView.x = _settingView.maxX;
                }else {
                    _VolumeView.y = _settingView.maxY + 2;
                }
            }];

        }
            break;
            
        default:
            break;
    }
}

//显示选择音频参数页面的代理方法
-(void)ShowSamplingView {
    [UIView animateWithDuration:0.3 animations:^{
        _audioSamplingTableView.alpha = 1;
    }];
}
//通知消失选择音频参数页面的代理方法
-(void)hiddenSamplingView {
    [UIView animateWithDuration:0.3 animations:^{
        _audioSamplingTableView.alpha = 0;
    }];
}

//上传视频页面的代理方法
-(void)uploadKindOfNum:(NSInteger)num {
//    NSLog(@"%ld",(long)num);
    
    switch (num) {
        case 0://上传照片
        {
            
        }
            break;
        case 1://上传离线视频
        {
            
            PlayViedoViewController * videoView = [[PlayViedoViewController alloc]init];
            videoView.isUpLoad = YES;
            videoView.Delegate = self;
            videoView.screenH = screenH;
            videoView.screenW = screenW;
            [self presentViewController:videoView animated:YES completion:^{
//                [videoView release];
                _uploadVideoView.y = screenW + 50;

            }];
        }
            break;
        case 2://断点续传
        {
            _ViedoStreamID = [XpaiInterface getVideoStreamID:VideoID ];//视频服务器上的ID
            _ViedoFileName = [XpaiInterface getVideoFileName:VideoID];//获取本地视频的文件名
            _ViedoFilePath = [XpaiInterface getVideoStreamPath:VideoID];//获取本地视频的路径
            
            NSLog(@"uploadVideoStreamID : %@",_ViedoStreamID);
            NSLog(@"uploadvideoFileName : %@",_ViedoFileName);
            NSLog(@"uploadvideoFilePath : %@",_ViedoFilePath);
            
            [XpaiInterface uploadVideoFile:_ViedoFileName mode:UPLOAD_FROM_RESUME_POINT sId:_ViedoStreamID sPath:_ViedoFilePath isRecordDone:YES opaque:nil];
            
            NSLog(@"uploadVideoStreamID : %@",_ViedoStreamID);
            NSLog(@"uploadvideoFileName : %@",_ViedoFileName);
            NSLog(@"uploadvideoFilePath : %@",_ViedoFilePath);
            
        }
            break;
        case 3://测试
        {
            
        }
            break;
            
        default:
            break;
    }
}

//上传页面选择上传文件地址方法
-(void)uploadVideoOfFilePath:(NSString *)filePath {
    
    //    NSLog(@"VideoStreamID : %@",_ViedoStreamID);
    //    NSLog(@"videoFileName : %@",_ViedoFileName);
    //    NSLog(@"videoFilePath : %@",_ViedoFilePath);
    NSLog(@"filePath :%@",filePath);
    
    [XpaiInterface uploadVideoFile:filePath mode:UPLOAD_FROM_FILE_BEGIN sId:nil sPath:nil isRecordDone:YES opaque:nil];
    [UIView animateWithDuration:0.3 animations:^{
        _UploadingButton.alpha = 0;
        _makeVideoButton.alpha = 0;
    }];
    [self informationWithSte:@"开始上传视频"];
    
    NSLog(@"当前上传ID:%lld",[XpaiInterface getCurrentSendVideoID]);
    
}
#pragma mark -- 点击屏幕方法
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:0.3 animations:^{
//        _settingView.x = _settingView.width * -1;
        _settingBackgroundView.x = kScreenW * -1;
        _resolution.x = 0;
        _resolution.alpha = 0;
        _bitStreamView.x = 0;
        _bitStreamView.alpha = 0;
        _netOverTimeView.x = 0;
        _netOverTimeView.alpha = 0;
        _reconnectOverTimeView.x = 0;
        _reconnectOverTimeView.alpha = 0;
        _transcribeView.x = 0;
        _transcribeView.alpha = 0;
        _audioParameterView.x = 0;
        _audioParameterView.alpha = 0;
        _audioSamplingTableView.alpha = 0;
        _deptionView.x = 0;
        _deptionView.alpha = 0;
        _saveRedioView.x = 0;
        _saveRedioView.alpha = 0;
        _outPutView.x = 0;
        _outPutView.alpha = 0;
        _setFPSView.x = 0;
        _setFPSView.alpha = 0;
        _TransferView.x = 0;
        _TransferView.alpha = 0;
        _VolumeView.x = 0;
        _VolumeView.alpha = 0;
        _uploadVideoView.y = screenW + 50;
    }];
    
    [self.view endEditing:YES]; //所有放弃第一响应
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (isMKPhoto == NO) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    //touchPoint.x ，touchPoint.y
    [XpaiInterface tapToFocus:touchPoint];
    [self ViewAnimtion:touchPoint];
    
    if ([XpaiInterface isRecording] == YES) {
        [XpaiInterface setFocusMode:AVCaptureFocusModeAutoFocus];
    }
}

-(void)ViewAnimtion:(CGPoint)point {
    
    if (!_touchsImageView) {
        _touchsImageView = [[UIImageView alloc]init];
        _touchsImageView.backgroundColor = [UIColor clearColor];
        _touchsImageView.layer.masksToBounds = YES;
        _touchsImageView.layer.borderColor = [[UIColor greenColor] CGColor];
        _touchsImageView.layer.borderWidth = 2;
        [self.view addSubview:_touchsImageView];
    }
    _touchsImageView.alpha = 0;
    _touchsImageView.transform = CGAffineTransformIdentity;
    _touchsImageView.frame = CGRectMake(point.x , point.y , 140, 140);
    _touchsImageView.center = CGPointMake(point.x, point.y);
    [UIView animateWithDuration:0.3 animations:^{
        _touchsImageView.alpha = 1;
        _touchsImageView.transform = CGAffineTransformScale(_touchsImageView.transform, 0.6, 0.6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.5  //动画持续时间
                                       delay:0.0  //动画延时
                                     options: UIViewAnimationOptionCurveEaseInOut//设置动画曲线
                                  animations:^{
                                      if ([XpaiInterface isRecording]) {
                                          _touchsImageView.alpha = 0.3;//变换透明度
                                      }else {
                                          _touchsImageView.alpha = 0;
                                      }
                                  }
                                  completion:^(BOOL finished){//动画结束时，调用如下方法
                                  }];
    }];
}


#pragma mark ---代理
-(void)SetFPSWithMax:(int)MaxFPS Min:(int)MinFPS {
    [XpaiInterface setVideoFpsRange:MinFPS maxFps:MaxFPS];
    [self RePreviewWithCameraModel:PHOTO_MODE];
}


#pragma mark -- TableVIew代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _audioSamplingDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str = @"sampling";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = _audioSamplingDataSource[indexPath.row];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger num = [_audioSamplingDataSource[indexPath.row] integerValue];
    [CLSettingConfig sharedInstance].audioSampling = num;
    [[CLSettingConfig sharedInstance] WriteData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"numOfSamping" object:nil];
}

#pragma mark --监听Home按钮
//按下Home键及电话
- (void)applicationDidEnterBackground:(UIApplication *)application
//当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
{
    if ([XpaiInterface isRecording]) {
        [XpaiInterface interruptLive];
        [_timer setFireDate:[NSDate distantFuture]];

    }
}
//重新进入程序
- (void)applicationWillEnterForeground:(UIApplication *)application
//当应用程序入活动状态执行，这个刚好跟上面那个方法相反
{
    if ([XpaiInterface isRecording] == YES) {
        [XpaiInterface resumeRecord];
        [_timer setFireDate:[NSDate distantPast]];

    }
}


#pragma mark -- 控制屏幕为横屏显示
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (_isAcross == YES) {
        return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }else {
        return (toInterfaceOrientation == UIDeviceOrientationPortrait);
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    if (_isAcross == YES) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
  
}

- (void)applicationWillResignActive:(UIApplication *)application
//当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
{
//    [_player pause];
//    [_player stop];
    NSLog(@"resign active");
}
//重新进入程序
- (void)applicationDidBecomeActive:(UIApplication *)application
//当应用程序入活动状态执行，这个刚好跟上面那个方法相反
{
//    [self CreatePlayView];
//    [_player play];
    NSLog(@"bacome active");
}



@end

