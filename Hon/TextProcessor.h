//
//  PageSplitter.h
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextProcessor : NSObject

@property (strong, nonatomic) NSMutableArray *pageStartIndex;

@property (strong, nonatomic) NSMutableArray *ChapterTitleIndex;

- (NSMutableArray *) getContentForEachPage: (NSMutableArray * ) chapterArray withFrameSize: (CGSize)frameSize fontSize:(CGFloat) fontSize;

- (NSInteger) getPageOfTextIndex: (NSInteger) index;

@end
