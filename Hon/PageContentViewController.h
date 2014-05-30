//
//  PageContentViewController.h
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController

@property (nonatomic, strong) NSString *texts;

@property (nonatomic) NSInteger pageIndex;

@property (nonatomic) CGRect textFrame;
@property (nonatomic) CGRect titleFrame;

@property (nonatomic) CGFloat textFontSize;

@property (nonatomic) BOOL nightMode;

@end
