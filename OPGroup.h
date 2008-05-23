//
//  OPGroup.h
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OPMLManagedObject;

@interface OPGroup :  NSManagedObject  
{
}

+ (OPGroup *)insertWithXMLElement:(NSXMLElement *)element moc:(NSManagedObjectContext *)moc;

@property (retain) NSString * title;
@property (retain) NSSet* feeds;
@property (retain) OPMLManagedObject * opml;

@property (retain, readwrite) NSSet *entries;

@end

@interface OPGroup (CoreDataGeneratedAccessors)
- (void)addFeedsObject:(NSManagedObject *)value;
- (void)removeFeedsObject:(NSManagedObject *)value;
- (void)addFeeds:(NSSet *)value;
- (void)removeFeeds:(NSSet *)value;

@end

