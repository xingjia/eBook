//
//  TOCViewController.m
//  Hon
//
//  Created by Zhang Xingjia on 21/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "TOCViewController.h"
#import "AppDelegate.h"
#import "ECSlidingViewController.h"


@interface TOCViewController ()

@property (nonatomic, strong) AppDelegate *delegate;

@property (nonatomic, strong) NSMutableArray *chapterTitles;

@end

@implementation TOCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.chapterTitles = [NSMutableArray array];

    for (int i = [self.delegate.chapterTitleIndex count] -1; i > 0; i--){
        if([self.delegate.chapterTitleIndex[i] integerValue] != -1){
            [self.chapterTitles addObject: [NSString stringWithFormat:@"第%d章", [self.delegate.chapterTitleIndex[i] integerValue]+1]];
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
    return [self.chapterTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"simpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [self.chapterTitles objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.delegate.lastReadTitle setObject: [self.delegate.currentTexts substringWithRange: NSMakeRange([self.delegate.pageStartIndex[[self.delegate.chapterTitleIndex indexOfObject:[NSNumber numberWithInt:indexPath.row]]] integerValue], 30)] forKey:self.delegate.currentTitle];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ECSlidingViewController *newSVController = [self.storyboard instantiateViewControllerWithIdentifier:@"SlidingViewController"];
    newSVController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReadNavigationController"];
    [self.navigationController presentViewController:newSVController animated:NO completion:nil];
}

- (IBAction)DragToMenu:(id)sender {
    NSString *segueIdentifier = @"unwindToMenuViewController";
    [self performSegueWithIdentifier:segueIdentifier sender:self];
}

@end
