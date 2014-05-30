//
//  LibraryViewController.m
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "LibraryViewController.h"
#import "ReadViewController.h"
#import "ECSlidingViewController.h"
#import "AppDelegate.h"

@interface LibraryViewController ()

@property (nonatomic, strong) AppDelegate *delegate;

@property (nonatomic, strong) NSString *bookTitle;
@end

@implementation LibraryViewController

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
	// Do any additional setup after loading the view.
    self.delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.delegate.libraryContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    self.bookTitle = [self.delegate.libraryContents[indexPath.row] stringByDeletingPathExtension];
    cell.textLabel.text =  self.bookTitle;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *bookPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.delegate.libraryContents[indexPath.row]];
    self.delegate.currentTexts = [NSString stringWithContentsOfFile:bookPath encoding:NSUTF8StringEncoding error:nil];
    self.bookTitle = [self.delegate.libraryContents[indexPath.row] stringByDeletingPathExtension];
    self.delegate.currentTitle = self.bookTitle;
    
    ECSlidingViewController *newSVController = [self.storyboard instantiateViewControllerWithIdentifier:@"SlidingViewController"];
     newSVController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadNavigationController"];
    [self.navigationController presentViewController:newSVController animated:NO completion:nil];
}


@end
