//
//  MainViewController.m
//  Pomodoro Timer
//
//  Created by ivan on 16/11/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "MainViewController.h"
#import "PresentingAnimationController.h"
#import "DismissingAnimationController.h"
#import "SettingsViewController.h"
#import "SettingsTableViewController.h"
#import "ChartsViewController.h"
#import "CircleView.h"
#import "PNChart.h"
#import <AVFoundation/AVFoundation.h>
typedef enum {
  idling,
  pomodoroing,
  breaking,
  pomodoroingPaused,
  breakingPaused
} states;

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UILabel *timerLable;
@property (weak, nonatomic) IBOutlet UILabel *board;
@property (nonatomic) CircleView *circleView;
@property (nonatomic) NSTimer * pomodoroTimer;
@property (nonatomic) NSMutableDictionary *settingsDic;
@property (nonatomic) NSMutableDictionary *pomodoroRecordsDic;
@property (nonatomic) float secondsLeft;
@property (nonatomic) states state;
@property(nonatomic, strong) AVAudioPlayer *backgroundMusic;

@end

@implementation MainViewController

const float btnShiftX = 60.0;
const float btnShiftY = 130.0;
const float circleShiftY = -90.0;


- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES];
  [self addCircleView];
  
  _startBtn.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
  _startBtn.center = CGPointMake(self.view.center.x, self.view.center.y + btnShiftY);
  _startBtn.layer.cornerRadius = 15;
  _startBtn.layer.borderColor = [UIColor whiteColor].CGColor;
  _startBtn.layer.borderWidth = .8f;
  _startBtn.layer.masksToBounds = NO;
  _startBtn.layer.shadowOffset = CGSizeMake(0, 0);
  _startBtn.layer.shadowRadius = 4;
  _startBtn.layer.shadowOpacity = 0.25;
  
  _stopBtn.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1];
  _stopBtn.center = CGPointMake(self.view.center.x + btnShiftX, self.view.center.y + btnShiftY);
  _stopBtn.layer.cornerRadius = 15;
  _stopBtn.layer.borderColor = [UIColor whiteColor].CGColor;
  _stopBtn.layer.borderWidth = .8f;
  _stopBtn.hidden = YES;
  _stopBtn.layer.masksToBounds = NO;
  _stopBtn.layer.shadowOffset = CGSizeMake(0, 0);
  _stopBtn.layer.shadowRadius = 4;
  _stopBtn.layer.shadowOpacity = 0.25;
  
  _board.hidden = YES;
  
  _settingsDic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroSettingsDic"] mutableCopy];
  if(!_settingsDic){
    _settingsDic = [[NSMutableDictionary alloc] init];
    _settingsDic[@"pomodoroTime"] = @"25";
    _settingsDic[@"breakTime"] = @"5";
    _settingsDic[@"backgroundMusic"] = @"None";
    [[NSUserDefaults standardUserDefaults] setObject:_settingsDic forKey:@"PomodoroSettingsDic"];
  }
  _secondsLeft = [_settingsDic[@"pomodoroTime"] floatValue] * 60;
  [self setTimerLable];
  
  _pomodoroRecordsDic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroRecordsDic"] mutableCopy];
  if(!_pomodoroRecordsDic){
    _pomodoroRecordsDic = [[NSMutableDictionary alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:_pomodoroRecordsDic forKey:@"PomodoroRecordsDic"];
  }
  
  NSMutableDictionary *pomodoroPlans = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroPlans"] mutableCopy];
  if(!pomodoroPlans){
    pomodoroPlans = [[NSMutableDictionary alloc] init];
    pomodoroPlans[@"daily"] = @"10";
    pomodoroPlans[@"weekly"] = @"70";
    [[NSUserDefaults standardUserDefaults] setObject:pomodoroPlans forKey:@"PomodoroPlans"];
  }
  
//  _pomodoroRecordsDic[@"2016-12-17"] = @"8";
//  _pomodoroRecordsDic[@"2016-12-15"] = @"12";
//  _pomodoroRecordsDic[@"2016-12-10"] = @"11";
//  _pomodoroRecordsDic[@"2016-12-09"] = @"8";
//  _pomodoroRecordsDic[@"2016-12-08"] = @"12";
//  [_pomodoroRecordsDic removeObjectForKey:@"2016-12-10"];

  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(updateSettings:)
             name:@"do"
           object:nil];
  
  _state = idling;
}

- (void)startBackgroundMusic{
  NSURL *musicFile = [[NSBundle mainBundle] URLForResource:_settingsDic[@"backgroundMusic"]
                                             withExtension:@"mp3"];
  self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile
                                                                error:nil];
  self.backgroundMusic.numberOfLoops = -1;
  [self.backgroundMusic play];
}

- (void)stopBackgroundMusic{
  [_backgroundMusic stop];
}

- (void)updateSettings:(NSNotification*)sender{
  _settingsDic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroSettingsDic"] mutableCopy];
  _secondsLeft = [_settingsDic[@"pomodoroTime"] floatValue] * 60;
  [self setTimerLable];
}

- (void)addCircleView
{
  CGRect frame = CGRectMake(0.f, 0.f, 250.f, 250.f);
  self.circleView = [[CircleView alloc] initWithFrame:frame];
  self.circleView.backgroundColor = [UIColor whiteColor];
  self.circleView.layer.cornerRadius = 125.f;
  self.circleView.layer.zPosition = -1;
  self.circleView.layer.masksToBounds = NO;
  self.circleView.layer.shadowOffset = CGSizeMake(0, 0);
  self.circleView.layer.shadowRadius = 4;
  self.circleView.layer.shadowOpacity = 0.25;
  
  self.circleView.strokeColor = [UIColor colorWithRed:0.39 green:0.73 blue:0.90 alpha:1.0];
  self.circleView.center = CGPointMake(self.view.center.x, self.view.center.y + circleShiftY);
  self.timerLable.center = CGPointMake(self.view.center.x, self.view.center.y + circleShiftY);
  [self.circleView setStrokeEnd:1];
  [self.view addSubview:self.circleView];
}

- (IBAction)didClickOnPresentSettings:(id)sender {
  SettingsViewController * settings = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
  settings.transitioningDelegate = self;
  settings.modalPresentationStyle = UIModalPresentationCustom;
  [self presentViewController:settings animated:YES completion:nil];

}

- (IBAction)didClickOnPresentCharts:(id)sender {
  ChartsViewController * charts = [self.storyboard instantiateViewControllerWithIdentifier:@"charts"];
  charts.transitioningDelegate = self;
  charts.modalPresentationStyle = UIModalPresentationCustom;
  [self presentViewController:charts animated:YES completion:nil];
  
}

- (IBAction)didClickOnStartBtn:(id)sender {
  switch (_state) {
    case idling:{
      if(![_settingsDic[@" "] isEqualToString:@"None"]) [self startBackgroundMusic];
      _secondsLeft = [_settingsDic[@"pomodoroTime"] floatValue] * 60;
      _pomodoroTimer = [NSTimer timerWithTimeInterval: 1 target: self selector: @selector(updateTimer) userInfo: nil repeats: YES];
      [[NSRunLoop currentRunLoop] addTimer: _pomodoroTimer forMode: NSDefaultRunLoopMode];
      [_startBtn setTitle:@"Pause" forState:UIControlStateNormal];
      _startBtn.center = CGPointMake(self.view.center.x, self.view.center.y + btnShiftY);
      _stopBtn.hidden = YES;
      _state = pomodoroing;
      
      _board.hidden = NO;
      _board.text = @"Concentrating";
      break;
    }
    case pomodoroing:{
      [_pomodoroTimer invalidate];
      _startBtn.center = CGPointMake(self.view.center.x - btnShiftX, self.view.center.y + btnShiftY);
      [_startBtn setTitle:@"Continue" forState:UIControlStateNormal];
      _stopBtn.hidden = NO;
      _state = pomodoroingPaused;
      break;
    }
    case breaking:{
      [_pomodoroTimer invalidate];
      _startBtn.center = CGPointMake(self.view.center.x - btnShiftX, self.view.center.y + btnShiftY);
      [_startBtn setTitle:@"Continue" forState:UIControlStateNormal];
      _stopBtn.hidden = NO;
      _state = breakingPaused;
      break;
    }
    case pomodoroingPaused:{
      _pomodoroTimer = [NSTimer timerWithTimeInterval: 1 target: self selector: @selector(updateTimer) userInfo: nil repeats: YES];
      [[NSRunLoop currentRunLoop] addTimer: _pomodoroTimer forMode: NSDefaultRunLoopMode];
      [_startBtn setTitle:@"Pause" forState:UIControlStateNormal];
      _startBtn.center = CGPointMake(self.view.center.x, self.view.center.y + btnShiftY);
      _stopBtn.hidden = YES;
      _state = pomodoroing;
      break;
    }
    case breakingPaused:{
      _pomodoroTimer = [NSTimer timerWithTimeInterval: 1 target: self selector: @selector(updateTimer) userInfo: nil repeats: YES];
      [[NSRunLoop currentRunLoop] addTimer: _pomodoroTimer forMode: NSDefaultRunLoopMode];
      [_startBtn setTitle:@"Pause" forState:UIControlStateNormal];
      _startBtn.center = CGPointMake(self.view.center.x, self.view.center.y + btnShiftY);
      _stopBtn.hidden = YES;
      _state = breaking;
      break;
    }
    default:
      break;
  }

}
- (IBAction)didClickOnStopBtn:(id)sender {
  [_pomodoroTimer invalidate];
  [self stopBackgroundMusic];
  [self.circleView setStrokeEnd:1];
  _secondsLeft = [_settingsDic[@"pomodoroTime"] floatValue] * 60;
  [self setTimerLable];
  
  _startBtn.center = CGPointMake(self.view.center.x, self.view.center.y + btnShiftY);
  [_startBtn setTitle:@"Start" forState:UIControlStateNormal];
  _stopBtn.hidden = YES;
  _board.hidden = YES;
  _state = idling;
}

- (void)updateTimer{
  _secondsLeft--;
  if(_secondsLeft < 0){
    AudioServicesPlaySystemSound (1313);
    if(_state == pomodoroing){
      _secondsLeft = [_settingsDic[@"breakTime"] floatValue] * 60;
      [self setTimerLable];
      
      NSDate *today = [NSDate date];
      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
      [dateFormat setDateFormat:@"yyyy-MM-dd"];
      NSString *dateString = [dateFormat stringFromDate:today];
      if(_pomodoroRecordsDic[dateString]){
        _pomodoroRecordsDic[dateString] = [NSString stringWithFormat: @"%d", [_pomodoroRecordsDic[dateString] intValue] + 1];
      }
      else{
        _pomodoroRecordsDic[dateString] = @"1";
      }
      [[NSUserDefaults standardUserDefaults] setObject:_pomodoroRecordsDic forKey:@"PomodoroRecordsDic"];
      _state = breaking;
      
      _board.text = @"Breaking";
    }
    else if(_state == breaking){
      _secondsLeft = [_settingsDic[@"pomodoroTime"] floatValue]  * 60;
      [self setTimerLable];
      _state = pomodoroing;
      _board.text = @"Concentrating";
    }
  }
  
  float totalSeconds = [_settingsDic[_state == pomodoroing ? @"pomodoroTime" : @"breakTime"] floatValue] * 60;
  float length = 1 - (totalSeconds - _secondsLeft)/totalSeconds;
  [self.circleView setStrokeEnd:length];
  [self setTimerLable];
}

- (void) setTimerLable{
  int min = floor(_secondsLeft/60);
  int sec = fmod(_secondsLeft, 60);
  NSString *minText;
  NSString *secText;
  minText = min > 9 ? [NSString stringWithFormat:@"%d", min] :  [NSString stringWithFormat:@"0%d", min];
  secText = sec > 9 ? [NSString stringWithFormat:@"%d", sec] :  [NSString stringWithFormat:@"0%d", sec];
  _timerLable.text = [NSString stringWithFormat:@"%@:%@", minText, secText];
}

#pragma mark - UIViewControllerTransitionDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
  PresentingAnimationController *pac = [[PresentingAnimationController alloc] init];
  if([presented isKindOfClass:[SettingsViewController class]]){
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    pac.centerPoint = CGPointMake(screenRect.size.width, 0);
    return pac;
  }
  else if([presented isKindOfClass:[ChartsViewController class]]){
    pac.centerPoint = CGPointMake(0, 0);
    return pac;
  }
  return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
  DismissingAnimationController *dac = [[DismissingAnimationController alloc] init];
  if([dismissed isKindOfClass:[SettingsViewController class]]){
    dac.transitionX = [[UIScreen mainScreen] bounds].size.width;
    return dac;
  }
  if([dismissed isKindOfClass:[ChartsViewController class]]){
    dac.transitionX = 0;
    return dac;
  }
  return nil;
}


@end
