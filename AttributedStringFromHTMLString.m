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
- (id)transformedValue:(NSString *)html {
    return [[[NSAttributedString alloc] initWithHTML:[html dataUsingEncoding:NSUTF16StringEncoding
                                                        allowLossyConversion:YES]
                                  documentAttributes:nil] autorelease];
}

@end
