//
//  ReadViewController.m
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "ReadViewController.h"
#import "AppDelegate.h"
#import "TextProcessor.h"
#import "PageContentViewController.h"
#import "ECSlidingViewController.h"

@interface ReadViewController ()

@property (nonatomic, strong) AppDelegate *delegate;

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) TextProcessor *processor;

@property (nonatomic,strong) NSMutableArray *contentsOfPage;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *AddBMBtn;

@end

@implementation ReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Initiate classes to be used
    self.delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    self.defaults = [NSUserDefaults standardUserDefaults];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.processor = [[TextProcessor alloc]init];
    
    self.textFrame = CGRectMake(20, 20, self.view.frame.size.width-40, self.view.frame.size.height-40);
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.rightBarButtonItem = self.addBMBtn;
    
    //use the utility class to split the texts
    self.contentsOfPage = [self.processor getContentForEachPage: self.delegate.currentTexts withFrameSize: self.textFrame.size fontSize: self.delegate.textFontSize];
    self.delegate.pageStartIndex = [NSMutableArray arrayWithArray:self.processor.pageStartIndex];
    self.delegate.chapterTitleIndex = [NSMutableArray arrayWithArray:self.processor.ChapterTitleIndex];
    
    NSInteger startingPageNumber;

    //set the page view controller
    if ([self.delegate.lastReadTitle objectForKey:self.delegate.currentTitle]){
        NSInteger startingPageIndex = [self.delegate.currentTexts rangeOfString:[self.delegate.lastReadTitle objectForKey:self.delegate.currentTitle]].location;
        startingPageNumber = [self.processor getPageOfTextIndex:startingPageIndex];
    }
    else
        startingPageNumber = [self.contentsOfPage count] -1;
    
    NSLog(@"staringPageIndex:%d", self.startingPageIndex);
    PageContentViewController *startingViewController = [self viewControllerAtIndex:startingPageNumber];

    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:YES completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if (index == 0 || index == NSNotFound)
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}


- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController *) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

// generate pageContentView with corresponding texts

- (PageContentViewController *) viewControllerAtIndex: (NSUInteger) index{
    if(index == NSNotFound || index > [self.contentsOfPage count] -1)
        return nil;
    
    PageContentViewController *page = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    page.texts = self.contentsOfPage[index];
    page.pageIndex = index;
    page.textFrame = self.textFrame;
    page.textFontSize = self.delegate.textFontSize;
    page.nightMode = self.delegate.nightMode;
    [self.delegate.lastReadTitle setObject:self.contentsOfPage[index] forKey:self.delegate.currentTitle];
    self.delegate.currentPageIndex = index;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    return page;
}

- (IBAction)tapToShowNavigationBar:(id)sender {
    if(self.navigationController.navigationBar.hidden == NO){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }

}

- (IBAction)tapToAddBookmark:(id)sender {
    NSMutableArray *bookmarks = [NSMutableArray arrayWithArray:[ self.defaults objectForKey:@"bookmarks"]];
    
    [bookmarks insertObject:[self.delegate.currentTexts substringWithRange: NSMakeRange([self.delegate.pageStartIndex[self.delegate.currentPageIndex] integerValue], 30)] atIndex:0];
    
    NSMutableArray *bookmarkTitles = [NSMutableArray arrayWithArray:[self.defaults objectForKey:@"bookmarkTitles"]];
    [bookmarkTitles insertObject:self.delegate.currentTitle atIndex:0];
    
    NSMutableArray *bookmarkDates = [NSMutableArray arrayWithArray:[self.defaults objectForKey:@"bookmarkDates"]];
    
    
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateString = [outputFormatter stringFromDate:now];
    [bookmarkDates insertObject:dateString atIndex:0];
    
    [self.defaults setObject:bookmarks forKey:@"bookmarks"];
    [self.defaults setObject:bookmarkDates forKey:@"bookmarkDates"];
    [self.defaults setObject:bookmarkTitles forKey:@"bookmarkTitles"];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

@end
