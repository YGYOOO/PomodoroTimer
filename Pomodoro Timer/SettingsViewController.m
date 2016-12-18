//
//  SettingsViewController.m
//  Pomodoro Timer
//
//  Created by ivan on 16/11/16.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewController.h"

@interface SettingsViewController()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *settingsTable;
@property (weak, nonatomic) UIColor *themeColor;
@end

@implementation SettingsViewController

NSMutableArray *settings;
NSMutableArray *plans;


#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection: (NSInteger)section{
  if(section == 0) return [settings count];
  return [plans count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath{
  static NSString *cellIdentifier = @"cellID";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                           cellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setBackgroundColor:_themeColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [ UIFont fontWithName: @"Arial" size: 15.0 ];
    UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow.png"]];
    cell.accessoryView = checkmark;
  }
  NSString *stringForCell;
  if (indexPath.section == 0) {
    stringForCell= [settings objectAtIndex:indexPath.row];
    
  }
  else if (indexPath.section == 1){
    stringForCell= [plans objectAtIndex:indexPath.row];
    
  }
  [cell.textLabel setText:stringForCell];
  return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  header.backgroundView.backgroundColor = _themeColor;
  [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection: (NSInteger)section{
  NSString *headerTitle;
  if (section==0) {
    headerTitle = @"Settings";
  }
  else{
    headerTitle = @"Plans";
    
  }
  return headerTitle;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  SettingsTableViewController * settingsTable = [self.storyboard instantiateViewControllerWithIdentifier:@"settingsTable"];
  settingsTable.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  if(indexPath.section == 0){
    switch (indexPath.row) {
      case 0:{
        settingsTable.cellData = [[NSMutableArray alloc]initWithObjects:
                                  @"0.1 min (for testing)", @"10 min", @"15 min", @"20 min", @"25 min", @"30 min", @"35 min", @"40 min", @"45 min", nil];
        settingsTable.key = @"pomodoroTime";
        settingsTable.userDefaultsKey = @"PomodoroSettingsDic";
        break;
      }
      case 1:{
        settingsTable.cellData = [[NSMutableArray alloc]initWithObjects:
                                  @"0.05 min (for testing)", @"1 min", @"2 min", @"3 min", @"5  min", @"7 min", @"10 min", nil];
        settingsTable.key = @"breakTime";
        settingsTable.userDefaultsKey = @"PomodoroSettingsDic";
        break;
      }
      case 2:{
        settingsTable.cellData = [[NSMutableArray alloc]initWithObjects:
                                  @"None", @"Rain", @"Forest", nil];
        settingsTable.key = @"backgroundMusic";
        settingsTable.userDefaultsKey = @"PomodoroSettingsDic";
        break;
      }
      default:
        break;
    }
  }
  else if(indexPath.section == 1){
    switch (indexPath.row) {
      case 0:{
        settingsTable.cellData = [[NSMutableArray alloc]initWithObjects:
                                  @"6 pomodoros", @"8 pomodoros", @"10 pomodoros", @"12 pomodoros", @"14 pomodoros", @"16 pomodoros", @"18 pomodoros", @"20 pomodoros", nil];
        settingsTable.key = @"daily";
        settingsTable.userDefaultsKey = @"PomodoroPlans";
        break;
      }
      case 1:{
        settingsTable.cellData = [[NSMutableArray alloc]initWithObjects:
                                  @"40 pomodoros", @"50 pomodoros", @"55 pomodoros", @"60 pomodoros", @"65 pomodoros", @"70 pomodoros", @"75 pomodoros", @"80 pomodoros", @"85 pomodoros",@"90 pomodoros", @"100 pomodoros", @"110 pomodoros", @"120 pomodoros", nil];
        settingsTable.key = @"weekly";
        settingsTable.userDefaultsKey = @"PomodoroPlans";
        break;
      }
      default:
        break;
    }
  }
  [self presentViewController:settingsTable animated:YES completion:nil];
}

- (IBAction)didClickOnClose:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"do" object:self userInfo:nil];
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  self.view.layer.cornerRadius = self.view.bounds.size.height/2 * 1.2;
  
  settings = [[NSMutableArray alloc]initWithObjects:
              @"length of pomodoro", @"length of break", @"Background Sound" ,nil];
  plans = [[NSMutableArray alloc]initWithObjects:
              @"Daily", @"Weekly", nil];
  
  _themeColor = [UIColor colorWithRed:120.0/255.0 green:170.0/255.0 blue:226.0/255.0 alpha:1];
}

-(void)viewDidLayoutSubviews{

  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  _closeBtn.center = CGPointMake(self.view.bounds.size.width/2 + screenWidth/2 - 30, self.view.bounds.size.height/2 - screenHeight/2 + 42);
//  _settingsTable.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
  CGRect frame = CGRectMake(self.view.bounds.size.width/2 - screenWidth/2, self.view.bounds.size.height/2 - screenHeight/2 + 65, screenWidth, screenHeight - 65);
  _settingsTable.frame = frame;
  _settingsTable.backgroundColor = _themeColor;
  _settingsTable.tintColor = _themeColor;
  _settingsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
}

@end
