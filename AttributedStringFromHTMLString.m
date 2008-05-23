//
//  AttributedStringFromHTMLString.m
//  OPML Reader
//
//  Created by 潤 on 08/05/24.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AttributedStringFromHTMLString.h"


@implementation AttributedStringFromHTMLString

+ (Class)transformedValueClass { return [NSAttributedString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

+ (NSDictionary *)attributes
{
    static NSDictionary *attrs = nil;
    if (!attrs){
        attrs = [[NSDictionary alloc] initWithObjectsAndKeys:
                 [NSFont fontWithName:@"Hiragino Kaku Gothic ProN W6" size:11.0], NSFontAttributeName,
                 [NSNumber numberWithFloat:12.0], NSTopMarginDocumentAttribute,
                 [NSNumber numberWithFloat:12.0], NSLeftMarginDocumentAttribute,
                 [NSNumber numberWithFloat:12.0], NSRightMarginDocumentAttribute,
                 nil];
    }
    return attrs;
}
- (id)transformedValue:(NSString *)html
{
    NSData *htmlData = [html dataUsingEncoding:NSUTF16StringEncoding
                          allowLossyConversion:YES];
    NSMutableAttributedString *as = [[[NSMutableAttributedString alloc]
                                      initWithHTML:htmlData documentAttributes:nil]
                                     autorelease];
    [as addAttributes:[[self class] attributes] range:NSMakeRange(0, [as length])];
    return as;
}

@end
