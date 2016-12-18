//
//  SettingsTableViewController.m
//  Pomodoro Timer
//
//  Created by ivan on 16/12/1.
//  Copyright © 2016年 ivan. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) UIColor *themeColor;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation SettingsTableViewController

NSMutableDictionary * theTable;

- (void)viewDidLoad {
  [super viewDidLoad];
  theTable = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:_userDefaultsKey] mutableCopy];
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenWidth = screenRect.size.width;
  CGFloat screenHeight = screenRect.size.height;
  _closeBtn.center = CGPointMake(self.view.bounds.size.width/2 + screenWidth/2 - 30, self.view.bounds.size.height/2 - screenHeight/2 + 42);
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 0, .5)];
  //self.tableView.tableFooterView.backgroundColor = [UIColor whiteColor];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cellData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"Cell"];
    
    [cell setBackgroundColor:_themeColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [ UIFont fontWithName: @"Arial" size: 15.0 ];
    NSString * value = [[_cellData objectAtIndex:indexPath.row] componentsSeparatedByString: @" "][0];
    if([theTable[_key] isEqualToString: value]){
//      UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//      [accessoryView setImage:[UIImage imageNamed:@"check.png"]];
      [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
  }
  
  cell.textLabel.text = [_cellData objectAtIndex:indexPath.row];

  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  NSArray *cells = [tableView visibleCells];
  for(int i = 0; i < [cells count]; i++){
    [cells[i] setAccessoryType:UITableViewCellAccessoryNone];
  }
  
  [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
  theTable[_key] = [[_cellData objectAtIndex:indexPath.row] componentsSeparatedByString: @" "][0];
  [[NSUserDefaults standardUserDefaults] setObject:theTable forKey:_userDefaultsKey];
}

- (IBAction)backBtnClicked:(id)sender {
  self.presentingViewController.view.layer.cornerRadius = 0.0;

  CGRect newFrame = self.presentingViewController.view.frame;
  newFrame.size = CGSizeMake(23.0, 50.0);
  self.presentingViewController.view.frame = newFrame;
  
  [self dismissViewControllerAnimated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
