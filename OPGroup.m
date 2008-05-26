// 
//  OPGroup.m
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OPGroup.h"
#import "OPMLManagedObject.h"
#import "FeedMO.h"

@implementation OPGroup 

@dynamic title;
@dynamic feeds;
@dynamic opml;
// @dynamic entries;

+ (OPGroup *)insertWithXMLElement:(NSXMLElement *)element moc:(NSManagedObjectContext *)moc
{
	OPGroup *mo = [NSEntityDescription insertNewObjectForEntityForName:@"OPGroup"
														  inManagedObjectContext:moc];
	
	
	mo.title = [[element attributeForName:@"title"] stringValue];
	if (!mo.title) mo.title = [[element attributeForName:@"text"] stringValue];
	
	for (NSXMLElement *e in [element children]){
		FeedMO *feed = [FeedMO insertWithXMLElement:e moc:moc];
		feed.group = mo;
	}
	
	return mo;
}

@end
