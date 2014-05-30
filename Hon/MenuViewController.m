//
//  MenuViewController.m
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "ECSlidingViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) NSArray *menu;

@property (nonatomic, strong) UINavigationController *transitionsNavigationController;

@property (nonatomic, strong) AppDelegate *delegate;
@end

@implementation MenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //set up the gesture recognizer for go back to the top view.
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    [self.slidingViewController.underLeftViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    if(self.delegate.currentTexts)
        self.menu = [NSArray arrayWithObjects:@"Read", @"TOC", @"Bookmark",@"Library", @"Settings",nil];
    else
        self.menu = [NSArray arrayWithObjects:@"Library", @"Settings",nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return @"   本のAPP";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   
    if ([self.menu[indexPath.row] isEqualToString: @"Read"]){
        cell.textLabel.text =  @"読　む";
        cell.imageView.image = [UIImage imageNamed:@"read.png"];
    }
    if ([self.menu[indexPath.row] isEqualToString: @"TOC"]){
        cell.textLabel.text = @"目　次";
        cell.imageView.image = [UIImage imageNamed:@"TOC.png"];
    }
    if ([self.menu[indexPath.row] isEqualToString: @"Bookmark"]){
        cell.textLabel.text = @"ブックマーク";
        cell.imageView.image = [UIImage imageNamed:@"bookmark.png"];
    }
    if ([self.menu[indexPath.row] isEqualToString: @"Library"]){
        cell.textLabel.text = @"文　庫";
        cell.imageView.image = [UIImage imageNamed:@"library.png"];
    }
    if ([self.menu[indexPath.row] isEqualToString: @"Settings"]){
        cell.textLabel.text = @"設　定";
        cell.imageView.image = [UIImage imageNamed:@"settings.png"];
    }
    
    return cell;
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *segueIdentifier =[NSString stringWithFormat:@"%@Segue", self.menu[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:segueIdentifier sender:self];
    

}




@end
