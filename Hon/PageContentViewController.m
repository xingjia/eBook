//
//  PageContentViewController.m
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "PageContentViewController.h"
#import "VerticalTextView.h"
#import "AppDelegate.h"

@interface PageContentViewController ()

@property (strong, nonatomic) AppDelegate *delegate;

@end

@implementation PageContentViewController

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
    
    self.titleFrame =CGRectMake(self.view.frame.size.width/2-self.textFontSize*3, 80, self.textFontSize*5, self.view.frame.size.height-80*2);
    
    VerticalTextView *textLabel;
    if([self.delegate.chapterTitleIndex[self.pageIndex] integerValue]!= -1){
        textLabel = [[VerticalTextView alloc] initWithFrame:self.titleFrame];
        textLabel.textFontSize = self.textFontSize + 2.0;
    }
    else{
        textLabel = [[VerticalTextView alloc] initWithFrame:self.textFrame];
        textLabel.textFontSize = self.textFontSize;
    }
    if (self.nightMode == YES)
        self.view.backgroundColor = [UIColor blackColor];
    
    textLabel.nightMode = self.nightMode;

    //for chapterTitles, add a perfix "chapter number X"
    textLabel.texts = ([self.delegate.chapterTitleIndex[self.pageIndex] integerValue]!= -1) ? [NSString stringWithFormat:@"第%d章\n%@", [self.delegate.chapterTitleIndex[self.pageIndex] integerValue]+1, self.texts] : self.texts;
    [self.view addSubview: textLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
