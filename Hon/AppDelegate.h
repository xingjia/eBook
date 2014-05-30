//
//  AppDelegate.h
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSArray *libraryContents;

@property (strong, nonatomic) NSString *currentTexts;

@property (strong, nonatomic) NSString *currentTitle;

@property (nonatomic) BOOL nightMode;

@property (nonatomic) CGFloat textFontSize;

@property (nonatomic) NSUInteger currentPageIndex;

@property (strong, nonatomic) NSMutableArray *pageStartIndex;

@property (strong, nonatomic) NSMutableArray *chapterTitleIndex;

@property (strong, nonatomic) NSMutableDictionary *lastReadTitle;

@end
