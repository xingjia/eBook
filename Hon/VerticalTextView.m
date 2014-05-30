//
//  VierticalTextView.m
//  Hon
//
//  Created by Zhang Xingjia on 20/02/2014.
//  Copyright (c) 2014 Zhang Xingjia. All rights reserved.
//

#import "VerticalTextView.h"
#import "TextProcessor.h"
#import "AppDelegate.h"

@implementation VerticalTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setOpaque:NO];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.font = [UIFont fontWithName:@"HiraMinProN-W3" size:self.textFontSize];
    NSInteger col = 0;
    NSInteger row = 0;
    CGPoint pos;
    NSString *sample = @"何";
    CGFloat lineSpacing = self.textFontSize;
    CGSize sampleSize = [sample sizeWithFont:self.font  constrainedToSize:CGSizeMake(self.frame.size.width, 999) lineBreakMode:(NSLineBreakByCharWrapping)];
    
    NSInteger maxRow = floor(self.frame.size.height / sampleSize.height) - 1;

    //create buffer for symbols that appear at the end
    CGFloat bufferedTextSize = self.frame.size.height / maxRow;
    CGFloat stretchedTextSize = self.frame.size.height / (maxRow -1);
    CGFloat lineFontSize = bufferedTextSize;
    NSInteger lineMaxRow = maxRow;
    //prepare to rotate puncuation symbols to fit vertical texts
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform rotate90 = CGAffineTransformMakeRotation(90*M_PI/180);
    CGAffineTransform translate3 = CGAffineTransformMakeTranslation(self.textFontSize/2,-self.textFontSize/2);
    CGAffineTransform translate1;
    CGAffineTransform translate2;
    
    if(self.nightMode == NO)
        [[UIColor blackColor]set];
    else
        [[UIColor lightTextColor]set];
    
    
    for (int i = 0; i < [self.texts length]; i++){
       //change to a new line
        if(row > lineMaxRow -1){
            row = 0;
            col ++;
        }
        
    
        if (row == 0 && i+maxRow < [self.texts length] && [[self.texts substringWithRange:NSMakeRange(i, maxRow)] rangeOfString:@"\n"].location == NSNotFound){
            //squeezed line
            if ([[self.texts substringWithRange:NSMakeRange(i+maxRow, 1)] rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound){
                if(i+maxRow+1 < [self.texts length]&&[[self.texts substringWithRange:NSMakeRange(i+maxRow+1, 1)] rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound)
                {
                    lineFontSize = stretchedTextSize;
                    lineMaxRow = maxRow - 1;
                }else{
                    lineFontSize = self.textFontSize;
                    lineMaxRow = maxRow + 1;
                }
            }else{
                lineFontSize = bufferedTextSize;
                lineMaxRow = maxRow;
            }
            NSString *firstCharNextLine = [self.texts substringWithRange:NSMakeRange(i+maxRow, 1)];
        }

        
        pos = CGPointMake(self.frame.size.width - (col+1)*(sampleSize.width+lineSpacing), row*lineFontSize);
        
        translate1 = CGAffineTransformMakeTranslation(pos.x+self.textFontSize/2, pos.y+lineFontSize/2);
        translate2 = CGAffineTransformMakeTranslation(-pos.x-self.textFontSize/2,-pos.y-lineFontSize/2);
        
        //decide the position for the next char
        if ([self.texts characterAtIndex:i] == '\n'){
            if(row != 0){
                col ++;
                row = 0;
            }
        }
        else {
            row ++;
        }
        
        if([[self.texts substringWithRange:NSMakeRange(i, 1)] rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]].location != NSNotFound){
            //draw punctuation symbols
            if([[self.texts substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"、"] || [[self.texts substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"。"] ){
                CGContextSaveGState(context);
                CGContextConcatCTM(context, translate3);
                [[self.texts substringWithRange:NSMakeRange(i, 1)] drawAtPoint:pos withFont:self.font];
                CGContextRestoreGState(UIGraphicsGetCurrentContext());
                continue;
            }
            CGContextSaveGState(context);
            CGContextConcatCTM(context, translate1);
            CGContextConcatCTM(context, rotate90);
            CGContextConcatCTM(context, translate2);
            //CGContextConcatCTM(context, translate2);
            [[self.texts substringWithRange:NSMakeRange(i, 1)] drawAtPoint:pos withFont:self.font];
            CGContextRestoreGState(UIGraphicsGetCurrentContext());
        }else{
            //draw normal text
            [[self.texts substringWithRange:NSMakeRange(i, 1)] drawAtPoint:pos withFont:self.font];
        }
    }
}


@end
