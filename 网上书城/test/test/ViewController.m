//
//  ViewController.m
//  test
//
//  Created by happy on 2017/2/23.
//  Copyright © 2017年 wumiaomiao. All rights reserved.
//

#import "ViewController.h"
#import "ZYDownloadProgressView.h"
#import "ZYProgressBar.h"

@interface ViewController (){
    ZYDownloadProgressView *_progressView;
    CGFloat _progress;
}
@property (strong,nonatomic) UIImageView *imageView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    //进度条长度
    CGFloat width = 100.f;
    _progressView = [[ZYDownloadProgressView alloc] initWithFrame:(CGRect){(self.view.bounds.size.width-width)/2,200,width,80}];
    _progressView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_progressView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(progressViewDownload)];
    [_progressView addGestureRecognizer:tap];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _imageView.backgroundColor = [UIColor blackColor];
    }
    return _imageView;
}
- (void)progressViewDownload
{
    if (!_progressView.isDownloading) {
        [_progressView startDownload];
        [self stopTimer];
        self.timer = [self timerWithSelector:@selector(getProgress)];
        
        __weak typeof(self) weakSelf = self;
        _progressView.readyBlock = ^(BOOL ready){
            if (ready) {
                [weakSelf.timer setFireDate:[NSDate date]];
            }
        };
    }
}
- (void)getProgress
{
    _progress += 0.1;
    _progressView.progress = _progress;
    _progressView.completeBlock = ^(BOOL success){
        if (success) {
            NSLog(@"download complete");
        }
    };
}

- (void)resumeProgressView
{
    _progress = 0;
    [_progressView resume];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (NSTimer *)timerWithSelector:(SEL)selector
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:selector userInfo:nil repeats:YES];
    return timer;
}

@end
