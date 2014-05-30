//
//  VerticalTextView.h
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface VerticalTextView : UIView

@property (strong, nonatomic) AppDelegate *delegate;

@property (strong, nonatomic) NSString *texts;

@property (strong, nonatomic) UIFont *font;

@property (nonatomic) CGFloat textFontSize;

@property (nonatomic) BOOL nightMode;


@end
