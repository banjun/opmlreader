//
//  OPMLManagedObject.h
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface OPMLManagedObject :  NSManagedObject  
{
}

+ (OPMLManagedObject *)insertWithURL:(NSURL *)url moc:(NSManagedObjectContext *)moc;

@property (retain) NSString * title;
@property (retain) NSString * urlString;
@property (retain) NSSet* groups;

@end

@interface OPMLManagedObject (CoreDataGeneratedAccessors)
- (void)addGroupsObject:(NSManagedObject *)value;
- (void)removeGroupsObject:(NSManagedObject *)value;
- (void)addGroups:(NSSet *)value;
- (void)removeGroups:(NSSet *)value;

@end

