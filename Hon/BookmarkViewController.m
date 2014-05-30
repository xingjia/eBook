//
//  BookmarkViewController.m
//  Hon
//
//  Created by Zhang Xingjia on 21/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "BookmarkViewController.h"
#import "AppDelegate.h"
#import "ECSlidingViewController.h"

@interface BookmarkViewController ()

@property (strong, nonatomic) NSMutableArray *bookmarks;

@property (strong, nonatomic) NSMutableArray *bookmarkDates;

@property (strong, nonatomic) NSMutableArray *displayedBMDates;

@property (strong, nonatomic) NSMutableArray *displayedBMs;

@property (strong, nonatomic) NSMutableArray *bookmarkTitles;

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) AppDelegate *delegate;

@end

@implementation BookmarkViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.bookmarks = [NSMutableArray arrayWithArray: [self.defaults arrayForKey:@"bookmarks"]];
    self.bookmarkDates = [NSMutableArray arrayWithArray: [self.defaults arrayForKey:@"bookmarkDates"]];
    self.displayedBMDates = [NSMutableArray array];
    self.displayedBMs = [NSMutableArray array];
    self.bookmarkTitles = [NSMutableArray arrayWithArray: [self.defaults arrayForKey:@"bookmarkTitles"]];
    for (int i = 0; i < self.bookmarks.count; i++)
    {
        if ([self.bookmarkTitles[i] isEqualToString: self.delegate.currentTitle]){
            [self.displayedBMs addObject:self.bookmarks[i]];
            [self.displayedBMDates addObject:self.bookmarkDates[i]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.displayedBMs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.displayedBMs[indexPath.row];
    cell.detailTextLabel.text = self.displayedBMDates[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.delegate.lastReadTitle setObject:self.displayedBMs[indexPath.row] forKey:self.delegate.currentTitle];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ECSlidingViewController *newSVController = [self.storyboard instantiateViewControllerWithIdentifier:@"SlidingViewController"];
    newSVController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadNavigationController"];
    [self.navigationController presentViewController:newSVController animated:NO completion:nil];


}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger removeIndex = [self.bookmarkDates indexOfObject: [self.displayedBMDates objectAtIndex:indexPath.row]];
        [self.bookmarks removeObjectAtIndex:removeIndex];
        [self.bookmarkDates removeObjectAtIndex:removeIndex];
        [self.bookmarkTitles removeObjectAtIndex:removeIndex];
        
        [self.displayedBMs removeObjectAtIndex:indexPath.row];
        [self.displayedBMDates removeObjectAtIndex:indexPath.row];
        [self.defaults setObject:self.bookmarks forKey:@"bookmarks"];
        [self.defaults setObject:self.bookmarkDates forKey:@"bookmarkDates"];
        [self.defaults setObject:self.bookmarkTitles forKey:@"bookmarkTitles"];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
@end
