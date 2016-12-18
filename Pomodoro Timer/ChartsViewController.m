//
//  ChartsViewController.m
//  Pomodoro Timer
//
//  Created by ivan on 16/12/13.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "ChartsViewController.h"
#import "PNChart.h"

@interface ChartsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNBarChart * weeklyBarChart;
@property (nonatomic) NSMutableDictionary *pomodoroRecordsDic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dayOrWeekSgmt;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (nonatomic) NSString *finishedToday;
@property (nonatomic) NSString *finishedThisWeek;


@end
CGFloat screenWidth;
CGFloat screenHeight;
const NSArray *WEEKDAYS;
CGFloat chartHeight;

@implementation ChartsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  screenWidth = screenRect.size.width;
  screenHeight = screenRect.size.height;
  WEEKDAYS = @[@"SUN",@"MON",@"TUE",@"WEN",@"THU",@"FRI",@"SAT"];
  
  chartHeight = 200.0;
  
  self.view.layer.cornerRadius = self.view.bounds.size.height/2 * 1.2;
  _pomodoroRecordsDic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroRecordsDic"] mutableCopy];
}

-(void)viewDidLayoutSubviews{
  _closeBtn.center = CGPointMake(self.view.bounds.size.width/2 - screenWidth/2 + 30, self.view.bounds.size.height/2 - screenHeight/2 + 42);
  _dayOrWeekSgmt.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 - chartHeight/2 - 70);
  _label1.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 - chartHeight/2 + 210);
  _label2.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2 - chartHeight/2 + 235);
  
  [self addDailyBarChart];
  [self addWeeklyBarChart];
  self.weeklyBarChart.hidden = YES;
  NSMutableDictionary *pomodoroPlans = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroPlans"] mutableCopy];
  self.label1.text = [NSString stringWithFormat:@"Daily Plan: %@", pomodoroPlans[@"daily"]];
  self.label2.text = [NSString stringWithFormat:@"Finished Today: %@", _finishedToday];
}

- (void)addDailyBarChart{
  NSDate *now = [NSDate date];
  NSMutableDictionary *recentRecords = [[NSMutableDictionary alloc] init];
  int i = 0;
  while(i < 7){
    NSDate *day = [now dateByAddingTimeInterval:-i*24*60*60];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:day];
    recentRecords[dateString] = _pomodoroRecordsDic[dateString] ? _pomodoroRecordsDic[dateString] : @"0";//--------------------------------------
    i++;
  }
  
//    NSMutableArray * keys = [[NSMutableArray alloc] init];
//    int count = 0;
//    for (NSString* key in bars) {
//      if(count > 6) break;
//      NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//      [dateFormat setDateFormat:@"yyyy-MM-dd"];
//      NSDate *date = [dateFormat dateFromString:key];
//      [keys addObject:date];
//      count++;
//    }
//    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
//    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
//    NSArray *sortedKeys=[keys sortedArrayUsingDescriptors:descriptors];
  NSArray *keys = [recentRecords allKeys];
  NSArray *sortedKeys = [keys sortedArrayUsingComparator:^(id a, id b) {
    NSArray *arrayA = [a componentsSeparatedByString:@"-"];
    NSArray *arrayB = [b componentsSeparatedByString:@"-"];
    if([[arrayA objectAtIndex:0] intValue] > [[arrayB objectAtIndex:0] intValue])
      return NSOrderedDescending;
    if([[arrayA objectAtIndex:1] intValue] > [[arrayB objectAtIndex:1] intValue])
      return NSOrderedDescending;
    if([[arrayA objectAtIndex:2] intValue] > [[arrayB objectAtIndex:2] intValue])
      return NSOrderedDescending;
    return NSOrderedAscending;
  }];
  NSMutableArray * values = [[NSMutableArray alloc] init];
  for(int i = 0; i < [sortedKeys count]; i++){
    [values addObject:recentRecords[[sortedKeys objectAtIndex:i]]];
  }
  
//  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//  [dateFormatter setDateFormat:@"EEEE"];
//  NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
  NSInteger weekday = [comps weekday];
  NSMutableArray *xLabels = [[NSMutableArray alloc] init];
  int j = 0;
  while(j < 7){
    if(weekday > 6) weekday = weekday - 7;
    [xLabels addObject:[WEEKDAYS objectAtIndex:weekday]];
    weekday++;
    j++;
  }
  
  self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - screenWidth/2, self.view.bounds.size.height/2 - 120, SCREEN_WIDTH, chartHeight)];
  self.barChart.backgroundColor = [UIColor clearColor];
  
  self.barChart.yChartLabelWidth = 20.0;
  self.barChart.chartMarginLeft = 30.0;
  self.barChart.chartMarginRight = 10.0;
  self.barChart.chartMarginTop = 5.0;
  self.barChart.chartMarginBottom = 10.0;
  
  self.barChart.labelTextColor = [UIColor whiteColor];
  
  self.barChart.labelMarginTop = 5.0;
  self.barChart.showChartBorder = YES;
  [self.barChart setXLabels:xLabels];
  [self.barChart setYValues:values];
  //[self.barChart setStrokeColors:@[PNBlue,PNGreen,PNRed,PNGreen,PNGreen,PNGreen,PNRed]];
  [self.barChart setStrokeColor:[UIColor colorWithRed:0.51 green:0.80 blue:0.80 alpha:1.0]];
  self.barChart.isGradientShow = NO;
  self.barChart.isShowNumbers = NO;
  NSMutableDictionary *pomodoroPlans = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroPlans"] mutableCopy];
  self.barChart.dottedLineValue = [pomodoroPlans[@"daily"] intValue];
  
  [self.barChart strokeChart];
  
  [self.view addSubview:self.barChart];
  
  _finishedToday = [values lastObject];
}

- (void)addWeeklyBarChart{
  NSMutableDictionary *recentRecords = [[NSMutableDictionary alloc] init];
  int i = 0;
  while(i < 49){
    NSDate *day = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                           value:-i
                                                          toDate:[NSDate date]
                                                         options:0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:day];
    recentRecords[dateString] = _pomodoroRecordsDic[dateString] ? _pomodoroRecordsDic[dateString] : @"0";
    i++;
  }

  NSArray *keys = [recentRecords allKeys];
  NSArray *sortedKeys = [keys sortedArrayUsingComparator:^(id a, id b) {
    NSArray *arrayA = [a componentsSeparatedByString:@"-"];
    NSArray *arrayB = [b componentsSeparatedByString:@"-"];

    if([[arrayA objectAtIndex:0] intValue] > [[arrayB objectAtIndex:0] intValue])
      return NSOrderedDescending;
    if([[arrayA objectAtIndex:0] intValue] < [[arrayB objectAtIndex:0] intValue])
      return NSOrderedAscending;
    
    if([[arrayA objectAtIndex:1] intValue] > [[arrayB objectAtIndex:1] intValue])
      return NSOrderedDescending;
    if([[arrayA objectAtIndex:1] intValue] < [[arrayB objectAtIndex:1] intValue])
      return NSOrderedAscending;
    
    if([[arrayA objectAtIndex:2] intValue] > [[arrayB objectAtIndex:2] intValue])
      return NSOrderedDescending;
    return NSOrderedAscending;
  }];
  NSMutableArray * xLabels = [[NSMutableArray alloc] init];
  NSMutableArray * weekValues = [[NSMutableArray alloc] init];
  int weekValue = 0;
  for(int i = 0; i < [sortedKeys count]; i++){
    weekValue += [recentRecords[[sortedKeys objectAtIndex:i]] intValue];
    if(!((i + 1) % 7)){
      [weekValues addObject:[NSString stringWithFormat:@"%d", weekValue]];
      weekValue = 0;
    }
    if(!(i % 7)){
      NSArray *dateArray = [[sortedKeys objectAtIndex:i] componentsSeparatedByString:@"-"];
      NSString *date = [NSString stringWithFormat:@"%@-%@", [dateArray objectAtIndex:1], [dateArray objectAtIndex:2]];
      [xLabels addObject:date];
    }
  }
  
  //  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  //  [dateFormatter setDateFormat:@"EEEE"];
  //  NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
  
//  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//  NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:[NSDate date]];
//  NSInteger weekday = [comps weekday];
//  NSMutableArray *xLabels = [[NSMutableArray alloc] init];
//  int j = 0;
//  while(j < 7){
//    if(weekday > 6) weekday = weekday - 7;
//    [xLabels addObject:[WEEKDAYS objectAtIndex:weekday]];
//    weekday++;
//    j++;
//  }
  
  self.weeklyBarChart = [[PNBarChart alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - screenWidth/2, self.view.bounds.size.height/2 - 120, SCREEN_WIDTH, 200.0)];
  self.weeklyBarChart.backgroundColor = [UIColor clearColor];
  
  self.weeklyBarChart.yChartLabelWidth = 20.0;
  self.weeklyBarChart.chartMarginLeft = 30.0;
  self.weeklyBarChart.chartMarginRight = 10.0;
  self.weeklyBarChart.chartMarginTop = 5.0;
  self.weeklyBarChart.chartMarginBottom = 10.0;
  
  self.weeklyBarChart.labelTextColor = [UIColor whiteColor];
  
  self.weeklyBarChart.labelMarginTop = 5.0;
  self.weeklyBarChart.showChartBorder = YES;
  [self.weeklyBarChart setXLabels:xLabels];
  [self.weeklyBarChart setYValues:weekValues];
  //[self.barChart setStrokeColors:@[PNBlue,PNGreen,PNRed,PNGreen,PNGreen,PNGreen,PNRed]];
  [self.weeklyBarChart setStrokeColor:[UIColor colorWithRed:0.51 green:0.80 blue:0.80 alpha:1.0]];
  self.weeklyBarChart.isGradientShow = NO;
  self.weeklyBarChart.isShowNumbers = NO;
  NSMutableDictionary *pomodoroPlans = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroPlans"] mutableCopy];
  self.weeklyBarChart.dottedLineValue = [pomodoroPlans[@"weekly"] intValue];
  
  [self.weeklyBarChart strokeChart];
  
  [self.view addSubview:self.weeklyBarChart];
  
  _finishedThisWeek= [weekValues lastObject];
}

- (IBAction)didClickOnClose:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeDailyWeekly:(UISegmentedControl *)sender {
  NSMutableDictionary *pomodoroPlans = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"PomodoroPlans"] mutableCopy];
  if(sender.selectedSegmentIndex == 0){
    self.barChart.hidden = NO;
    self.weeklyBarChart.hidden = YES;
    self.label1.text = [NSString stringWithFormat:@"Daily Plan: %@", pomodoroPlans[@"daily"]];
    self.label2.text = [NSString stringWithFormat:@"Finished Today: %@", _finishedToday];
  }
  else if(sender.selectedSegmentIndex == 1){
    self.barChart.hidden = YES;
    self.weeklyBarChart.hidden = NO;
    self.label1.text = [NSString stringWithFormat:@"Weekly Plan: %@", pomodoroPlans[@"weekly"]];
    self.label2.text = [NSString stringWithFormat:@"Finished This Week: %@", _finishedThisWeek];
  }
}

@end
