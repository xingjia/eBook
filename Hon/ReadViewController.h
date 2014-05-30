//
//  ReadViewController.h
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) CGRect textFrame;

@property (strong, nonatomic) UIBarButtonItem *addBMBtn;

@property (nonatomic) NSInteger startingPageIndex;

@end
