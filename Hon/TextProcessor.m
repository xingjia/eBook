//
//  PageSplitter.m
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "TextProcessor.h"

@implementation TextProcessor

- (NSArray *)splitTextIntoChapters: (NSString *) booktext
{
    NSArray *chapterContent = [booktext componentsSeparatedByString:@"\n\n"];
    return chapterContent;
}

- (NSArray *) calculateSampleTextLimitWithFrameSize: (CGSize) frameSize fontSize: (CGFloat)fontSize
{
    NSInteger containerWidth = frameSize.width ;
    NSInteger containerHeight = frameSize.height;
    NSString *sample = @"何";
    CGFloat lineSpacing = fontSize;
    CGSize sampleSize = [sample sizeWithFont:[UIFont fontWithName:@"HiraMinProN-W3" size:fontSize] constrainedToSize:CGSizeMake(frameSize.height, 999) lineBreakMode:(NSLineBreakByCharWrapping)];
    
    NSInteger maxRow = floor(containerHeight / sampleSize.height) - 1;
    NSInteger maxCol = floor(containerWidth / (sampleSize.width+lineSpacing));
    NSArray *size = [NSArray arrayWithObjects: [NSNumber numberWithInteger:maxRow],[NSNumber numberWithInteger:maxCol], nil];
    return size;
};

- (NSMutableArray *) getContentForEachPage: (NSString * ) booktext withFrameSize: (CGSize)frameSize fontSize:(CGFloat) fontSize
{
    
    NSArray *chapterContent = [self splitTextIntoChapters:booktext];
    NSArray *sampleTextSize = [self calculateSampleTextLimitWithFrameSize:frameSize fontSize:fontSize];
    NSInteger maxRow = [sampleTextSize[0] integerValue];
    NSInteger maxCol = [sampleTextSize[1] integerValue];
    
    NSMutableArray *PageContents = [NSMutableArray array];
    self.pageStartIndex = [NSMutableArray array];
    self.ChapterTitleIndex = [NSMutableArray array];
    
    NSInteger lastCharIndex = 0;
    NSString *pageContent;
    NSInteger currentIndex = 0;
    NSInteger currentLength;
    NSInteger currentCol;
    NSInteger currentRow;
    BOOL isPunct = NO;
    BOOL isBracket = NO;
    BOOL isDoublePunct = NO;
    
    for (int i = 0; i < [chapterContent count]; i++){
        //for chapter titles
        currentIndex = 0;
        if (i%2 == 0){
            NSString *title = chapterContent[i];
            [PageContents insertObject:title atIndex:0];
            //record the starting index of page content
            int startIndex = [booktext rangeOfString:chapterContent[i]].location;
            [self.pageStartIndex insertObject: [NSNumber numberWithInt:startIndex] atIndex:0];
            [self.ChapterTitleIndex insertObject: [NSNumber numberWithInt:i/2] atIndex:0];
        }
        else{
            while (currentIndex <= [chapterContent[i] length] - 1)
            {
                currentLength = 1;
                lastCharIndex = currentIndex + currentLength - 1;
                currentCol = 0;
                currentRow = 0;
                
                if ([[chapterContent[i] substringWithRange:NSMakeRange(lastCharIndex, 1)] rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound){
                    [PageContents[i-1] stringByAppendingString: [chapterContent[i] substringWithRange:NSMakeRange(lastCharIndex, 1)]];
                    currentIndex++;
                    continue;
                }
                
                while(currentCol < maxCol){
                    
                    if (lastCharIndex == [chapterContent[i] length] - 1)
                        break;
                    
                    
                    //include the current char
                    currentLength ++;
                    lastCharIndex ++;
                    
                    isPunct = [[chapterContent[i] substringWithRange:NSMakeRange(lastCharIndex, 1)] rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound;
                    isBracket = [[chapterContent[i] substringWithRange:NSMakeRange(lastCharIndex, 1)] isEqualToString:@"＜"] || [[chapterContent[i] substringWithRange:NSMakeRange(lastCharIndex, 1)] isEqualToString:@"「"];
                    if (lastCharIndex+1 < [chapterContent[i] length])
                        isDoublePunct = [[chapterContent[i] substringWithRange:NSMakeRange(lastCharIndex, 1)] rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound && [[chapterContent[i] substringWithRange:NSMakeRange(lastCharIndex+1, 1)] rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound;
                    
                    //decide the position for the next char.
                    //double punct means sth like ".>" or ".」"at the beginning of the line. if this is the case, the last char from the last col will be moved here.
                    if (currentRow == 0 && isDoublePunct)
                        currentRow ++;
                    
                    //puncutation marks at the beginning of the line and /n at the beginning of the page are not counted
                    if ((currentCol == 0 && currentRow == 0 && [chapterContent[i] characterAtIndex:lastCharIndex] == '\n')||
                          (currentRow == 0 && isPunct && !isBracket)
                        ){
                        continue;
                    }
                
                    if ([chapterContent[i] characterAtIndex:lastCharIndex] == '\n'&& currentRow != 0){
                        currentCol ++;
                        currentRow = 0;
                    }
                    else {
                        if(currentRow +1 > maxRow - 1){
                            currentRow = 0;
                            currentCol ++;
                        }else{
                            currentRow ++;
                        }
                    }
                    
                }
                pageContent = [chapterContent[i] substringWithRange: NSMakeRange(currentIndex, currentLength)];
                [PageContents insertObject:pageContent atIndex:0];
                int startIndex = [booktext rangeOfString: pageContent].location;
                [self.pageStartIndex insertObject: [NSNumber numberWithInt:startIndex] atIndex:0];
                currentIndex = lastCharIndex+1;
                [self.ChapterTitleIndex insertObject:[NSNumber numberWithInt:-1] atIndex:0];
            }
        }
    }
    return PageContents;
}



- (NSInteger) getPageOfTextIndex: (NSInteger) index;
{
    NSInteger pageNumber;
    
    for(pageNumber = [self.pageStartIndex count] -1; pageNumber >= 0; pageNumber--){
        if (index >= [self.pageStartIndex[pageNumber] integerValue] && pageNumber > 0){
            pageNumber--;
        }
        if (index < [self.pageStartIndex[pageNumber] integerValue]){
            pageNumber++;
            return pageNumber;
        }
    }
    
    if (pageNumber == -1) {pageNumber++;}
    return pageNumber;
}

@end