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

	NSOperationQueue *operationQueue;
    IBOutlet NSWindow *manageOpmlSheet;
    IBOutlet NSTextField *opmlURLField;
    
    IBOutlet NSArrayController *entriesController;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSManagedObjectModel *)managedObjectModel;
- (NSManagedObjectContext *)managedObjectContext;

- (IBAction)saveAction:sender;

- (IBAction)openOPMLFrom:(id)sender;
- (IBAction)manageOPML:(id)sender;
- (IBAction)addOPML:(id)sender;
- (IBAction)cancelManageOPML:(id)sender;
- (IBAction)openEntry:(id)sender;

- (NSOperationQueue *)operationQueue;

@end
