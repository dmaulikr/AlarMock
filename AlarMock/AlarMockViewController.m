//
//  ViewController.m
//  AlarMock
//
//  Created by Ben Bueltmann on 8/22/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import "AlarMockViewController.h"
#import "TableViewCell.h"

@interface AlarMockViewController() <UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

#pragma mark View Life Cycle

@implementation AlarMockViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.localNotifications = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"localNotificationsData"]];
    [self.tableView reloadData];
}

#pragma mark Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.localNotifications.count;
}

#pragma mark Table View Delegate Methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //cell.delegate = self;
    
    [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    NSData *data = [self.localNotifications objectAtIndex:indexPath.row];
    UILocalNotification *localNotification = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    [dateFormatter setDateFormat:@"h:mm a"];
    NSString *timeString = [dateFormatter stringFromDate:localNotification.fireDate];
    cell.textLabel.text = timeString;
    
//    cell.switcheroo = [[UISwitch alloc] initWithFrame:CGRectZero];
//    [cell.switcheroo addTarget:self
//                   action:@selector(changeSwitch:)
//         forControlEvents:UIControlEventValueChanged];
//
//    [self.view addSubview:cell.switcheroo];
//    if([switcheroo isOn]) {
//        [[UIApplication sharedApplication] scheduleLocalNotification:[self.localNotifications objectAtIndex:indexPath.row]];
//    } else{
//        [[UIApplication sharedApplication] cancelLocalNotification:[self.localNotifications objectAtIndex:indexPath.row]];
//    }
//    cell.accessoryView = switcheroo;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"localNotificationsData"];
    [self.localNotifications removeObjectAtIndex:indexPath.row];

    [self.tableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark Other Methods

- (IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        
        [self.editButton setTitle:@"Edit"];
        self.addButton.enabled = YES;
    }
    else {
        [self.editButton setTitle:@"Done"];
        self.addButton.enabled = NO;
        
        [self.tableView setEditing:YES animated:YES];
    }
}

-(IBAction)unwindToAlarmMockViewController:(UIStoryboardSegue *)unwindSegue
{
    
}
- (IBAction)onSubmitJoke:(id)sender
{
    PFObject *joke = [PFObject objectWithClassName:@"UserJokes"];
    joke[@"joke"] = self.textField.text;
    [joke saveInBackground];
    self.textField.text = @"";
    self.textField.placeholder = self.textField.placeholder;
}

-(IBAction)unwindToAddAlarmViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
