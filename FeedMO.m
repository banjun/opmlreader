// 
//  FeedMO.m
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "FeedMO.h"
#import "OPGroup.h"
#import "OPML_Reader_AppDelegate.h"
#import "ProgressiveOperation.h"
#import <PubSub/PubSub.h>


@interface FeedMO ()
- (void)loadFeed;
@end


@implementation FeedMO 

@dynamic title;
@dynamic urlString;
@dynamic htmlUrlString;
@dynamic dateModified;
@dynamic group;
@dynamic entries;

+ (FeedMO *)insertWithXMLElement:(NSXMLElement *)element moc:(NSManagedObjectContext *)moc
{
	FeedMO *mo = [NSEntityDescription insertNewObjectForEntityForName:@"Feed"
														  inManagedObjectContext:moc];
	
	
	mo.title = [[element attributeForName:@"title"] stringValue];
	mo.urlString = [[element attributeForName:@"xmlUrl"] stringValue];
	mo.htmlUrlString = [[element attributeForName:@"htmlUrl"] stringValue];
	
	[mo loadFeed];
	
	return mo;
}

- (void)loadFeed
{
	psfeed = [[PSFeed alloc] initWithURL:[NSURL URLWithString:self.urlString]];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(feedRefreshingNotification:)
												 name:PSFeedRefreshingNotification
											   object:psfeed];
    
    [psfeed refresh:nil];
}

- (void)deallc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:PSFeedRefreshingNotification object:psfeed];
	[psfeed release], psfeed = nil;
	[super dealloc];
}


- (void)updateEntries:(ProgressiveOperation *)op
{
    NSMutableSet *tmpSet = [NSMutableSet set];
	for (PSEntry *e in [psfeed entries]){
		NSManagedObject *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
															   inManagedObjectContext:[self managedObjectContext]];
		
		[entry setValue:e.title forKey:@"title"];
        [entry setValue:[e.alternateURL absoluteString] forKey:@"urlString"];
		[entry setValue:e.content.plainTextString forKey:@"entryDescription"];
		[entry setValue:e.dateForDisplay forKey:@"datePosted"];
		[entry setValue:e.content.HTMLString forKey:@"HTMLDescription"];
		
        [tmpSet addObject:entry];
	}
    [self performSelectorOnMainThread:@selector(relateEntries:) withObject:tmpSet waitUntilDone:YES];
}
- (void)relateEntries:(NSMutableSet *)tmpSet
{
    self.entries = [NSSet setWithSet:tmpSet];
    [tmpSet unionSet:self.group.entries];
    self.group.entries = [NSSet setWithSet:tmpSet];
}

- (void)feedRefreshingNotification:(NSNotification *)notif
{
	if (psfeed.refreshing) return;
    
    ProgressiveOperation *op = [[[ProgressiveOperation alloc]
                                 initWithTitle:@"reading entry" target:self
                                 selector:@selector(updateEntries:) object:nil]
                                autorelease];
    [[[NSApp delegate] operationQueue] addOperation:op];
}


@end
