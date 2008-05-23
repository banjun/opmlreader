//
//  ProgressiveOperation.m
//  NicoVideoPlayer
//
//  Created by banjun on 08/03/04.
//  Copyright 2008 banjun. All rights reserved.
//

#import "ProgressiveOperation.h"


@implementation ProgressiveOperation

@synthesize operationTitle, currentDescription, indeterminate, progress;

- (id)init
{
    return [self initWithTitle:[NSString stringWithFormat:@"operation %@", [self description]]];
}
- (id)initWithTitle:(NSString *)title
{
    if (self = [super init]){
        self.operationTitle = title;
        self.currentDescription = @"";
        self.progress = 0.0;
        self.indeterminate = YES;
    }
    return self;
}
- (id)initWithTitle:(NSString *)title target:(id)aTarget selector:(SEL)sel object:(id)obj
{
//    NSMethodSignature *ms = [target methodSignatureForSelector:sel];
//    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:ms];
//    [inv setTarget:target];
//    [inv setSelector:sel];
//    [inv setArgument:&self atIndex:2];
//    if (obj) [inv setArgument:&obj atIndex:3];
//    if (self = [super initWithInvocation:inv]){
    /*
     * NSInvocationOperation won't release arguments when finished???.
     */
    if (self = [super init]){
        self.operationTitle = title;
        self.currentDescription = @"";
        self.progress = 0.0;
        self.indeterminate = YES;
        
        target = [aTarget retain];
        action = sel;
        context = [obj retain];
    }
    return self;    
}
- (void)dealloc
{
    // NSLog(@"dealloc %@ (%@)", self, operationTitle);
    self.operationTitle = nil;
    self.currentDescription = nil;
    
    [target release];
    [context release];
    
    [super dealloc];
}


- (void)setProgress:(double)value
{
    self.indeterminate = (value < 0.0);
    progress = value;
}

- (void)main
{
    if (target){
        if (!context) [target performSelector:action withObject:self];
        if (context) [target performSelector:action withObject:self withObject:context];
        return;
    }
    // this is a sample implementation.
    // subclasses should override this method and do not call this implementation.
    
    int ttl = rand()%30;
    int count = 0;
    
    self.indeterminate = YES;
    self.currentDescription = @"preparing demo...";
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    self.progress = 0.0;
    self.indeterminate = NO;
    self.currentDescription = @"operating demo...";
    
    int i;
    for (i = 0; i < ttl; ++i){
        [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];        
        ++count;
        self.progress = (double)100.0*count/ttl;
    }
}

@end
