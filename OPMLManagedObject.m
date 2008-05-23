// 
//  OPMLManagedObject.m
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "OPMLManagedObject.h"
#import "OPGroup.h"


@implementation OPMLManagedObject 

@dynamic title;
@dynamic urlString;
@dynamic groups;


+ (OPMLManagedObject *)insertWithURL:(NSURL *)url moc:(NSManagedObjectContext *)moc
{
	NSError *error = nil;
	NSXMLDocument *opml = [[[NSXMLDocument alloc] initWithContentsOfURL:url
																options:0
																  error:&error] autorelease];
	if (!opml){
		NSLog(@"error in %@\n%@", NSStringFromSelector(_cmd), error);
		return nil;
	}
				 
	OPMLManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:@"OPML"
														  inManagedObjectContext:moc];
	
	mo.title = [[[opml nodesForXPath:@"//head/title" error:nil] lastObject] stringValue];
	mo.urlString = [url absoluteString];
	
	error = nil;
	NSArray *gs = [opml nodesForXPath:@"//body/outline" error:&error];
	for (NSXMLElement *e in gs){
		OPGroup *group = [OPGroup insertWithXMLElement:e moc:moc];
		group.opml = mo;
	}
    
	
	return mo;
}

@end
