//
//  SoundViewController.m
//  AlarMock
//
//  Created by Patrick Hogan on 9/3/14.
//  Copyright (c) 2014 AlarMock Industries. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "SoundViewController.h"

#import "AddAlarmViewController.h"
#import "AMRadialGradientLayer.h"
#import "UIFont+AMTheme.h"
#import "UIColor+AMTheme.h"
#import "UIScreen+AMScale.h"
#import "UIColor+AMTheme.h"

@interface SoundViewController () <UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) MPMediaItem *alarmSong;
@property (nonatomic) NSString *notificationSound;
@property (nonatomic) AMRadialGradientLayer *gradientLayer;
@property (nonatomic) NSArray *sounds;

@end

@implementation SoundViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.sounds = @[@"Alert 1", @"Alert 2", @"Alert 3", @"Alert 4"];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {return 4;} else {return 1;}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-  (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];

    [view addSubview:label];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = NO;
        mediaPicker.prompt = @"What would you like stuck in your head?";
        [self presentViewController:mediaPicker animated:YES completion:nil];
    } else {
        self.notificationSound = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundCell"];

    cell.textLabel.textColor = [UIColor am_whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.font = [UIFont am_book22];
        cell.textLabel.text = [self.sounds objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.font = [UIFont am_book16];
        cell.textLabel.text = @"Choose a song from your Library";
    }
    return cell;
}

#pragma mark - Action Handlers

- (IBAction)handleBackButton:(id)sender
{
    [self.delegate soundViewController:self didChooseNotificationSound:self.notificationSound didChooseSong:self.alarmSong];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MPMediaPickerControllerDelegate

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.alarmSong = [mediaItemCollection.items objectAtIndex:0];
        [[[UIAlertView alloc] initWithTitle:@"If you choose a song as your alarm tone, the phone must be locked with Alarm Mock open in the background"
                                    message:nil
                                   delegate:self
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Ok",nil] show];
    }];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
