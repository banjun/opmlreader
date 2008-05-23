//
//  FeedMO.h
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OPGroup, PSFeed;

@interface FeedMO :  NSManagedObject  
{
	PSFeed *psfeed;
}

+ (FeedMO *)insertWithXMLElement:(NSXMLElement *)element moc:(NSManagedObjectContext *)moc;

@property (retain) NSString * title;
@property (retain) NSString * urlString;
@property (retain) NSString * htmlUrlString;
@property (retain) NSDate * dateModified;
@property (retain) OPGroup * group;
@property (retain) NSSet* entries;

@end

@interface FeedMO (CoreDataGeneratedAccessors)
- (void)addEntriesObject:(NSManagedObject *)value;
- (void)removeEntriesObject:(NSManagedObject *)value;
- (void)addEntries:(NSSet *)value;
- (void)removeEntries:(NSSet *)value;

@end

