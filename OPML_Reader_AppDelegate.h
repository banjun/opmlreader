//
//  OPML_Reader_AppDelegate.h
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface OPML_Reader_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;

	NSArray *opmls;
	NSOperationQueue *operationQueue;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

- (IBAction)openOPMLFrom:(id)sender;

- (NSOperationQueue *)operationQueue;

@property (retain,readonly) NSArray *opmls;

@end
