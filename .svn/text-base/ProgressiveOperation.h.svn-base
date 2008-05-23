//
//  ProgressiveOperation.h
//  NicoVideoPlayer
//
//  Created by banjun on 08/03/04.
//  Copyright 2008 banjun. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ProgressiveOperation : NSOperation {
    NSString *operationTitle;
    NSString *currentDescription;
    BOOL indeterminate;
    double progress;
    
    id target;
    SEL action;
    id context;
}
- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title target:(id)target selector:(SEL)sel object:(id)obj; // first arg of selector is self.

@property (retain, readwrite) NSString *operationTitle;
@property (retain, readwrite) NSString *currentDescription;
@property (assign, readwrite) BOOL indeterminate;
@property (assign, readwrite) double progress;

@end
