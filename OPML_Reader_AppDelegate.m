//
//  OPML_Reader_AppDelegate.m
//  OPML Reader
//
//  Created by banjun on 08/05/21.
//  Copyright __MyCompanyName__ 2008 . All rights reserved.
//

#import "OPML_Reader_AppDelegate.h"
#import "OPMLManagedObject.h"
#import "FeedMO.h"

@interface OPML_Reader_AppDelegate()
- (void)openOPMLFromURL:(NSURL *)url;
@end


@implementation OPML_Reader_AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [entriesController setSortDescriptors:[NSArray arrayWithObject:
                                           [[[NSSortDescriptor alloc]
                                             initWithKey:@"datePosted"
                                             ascending:NO] autorelease]]];
    for (NSString *opmlURL in [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"OPMLURLs"]){
        [self openOPMLFromURL:[NSURL URLWithString:opmlURL]];
    }
    [NSTimer scheduledTimerWithTimeInterval:5*60
                                     target:self
                                   selector:@selector(refresh:)
                                   userInfo:nil
                                    repeats:YES];
}
- (void)refresh:(NSTimer *)timer
{
    // NSLog(@"refreshing");
    // fixme: todo: opml refresh
    
    // refresh feeds
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Feed" inManagedObjectContext:[self managedObjectContext]]];
    for (FeedMO *mo in [[self managedObjectContext] executeFetchRequest:request error:nil]){
        [mo refresh];
    }
}

- (void)saveOPMLs
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"OPML" inManagedObjectContext:[self managedObjectContext]]];
    NSMutableArray *urls = [NSMutableArray array];
    for (OPMLManagedObject *mo in [[self managedObjectContext] executeFetchRequest:request error:nil]){
        if ([mo isDeleted] || [mo.groups count] == 0) continue;
        [urls addObject:mo.urlString];
    }
    [[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:urls forKey:@"OPMLURLs"];
}

        
- (void)openOPMLFromURL:(NSURL *)url
{
    OPMLManagedObject *mo = [OPMLManagedObject insertWithURL:url
                                                         moc:[self managedObjectContext]];
    if (mo){
        [self saveOPMLs];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender{ return YES; }

#pragma mark -

/**
    Returns the support folder for the application, used to store the Core Data
    store file.  This code uses a folder named "OPML_Reader" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportFolder {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"OPML_Reader"];
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The folder for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
        [fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
    }
    
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"OPML_Reader.xml"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }    

    return persistentStoreCoordinator;
}


/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}


/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender {

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    NSError *error;
    int reply = NSTerminateNow;
	
    [self saveOPMLs];
	return NSTerminateNow; // force quit without save.
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext commitEditing]) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
				
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.

                // Typically, this process should be altered to include application-specific 
                // recovery steps.  

                BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
				
                if (errorResult == YES) {
                    reply = NSTerminateCancel;
                } 

                else {
					
                    int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" , @"Quit anyway", @"Cancel", nil);
                    if (alertReturn == NSAlertAlternateReturn) {
                        reply = NSTerminateCancel;	
                    }
                }
            }
        } 
        
        else {
            reply = NSTerminateCancel;
        }
    }
    
    return reply;
}


/**
    Implementation of dealloc, to release the retained variables.
 */
 
- (void) dealloc {

    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}

# pragma mark -

- (IBAction)openOPMLFrom:(id)sender
{
    [self openOPMLFromURL:[NSURL URLWithString:[sender stringValue]]];
}

- (IBAction)manageOPML:(id)sender
{
    [NSApp beginSheet:manageOpmlSheet
       modalForWindow:window
        modalDelegate:self
       didEndSelector:@selector(manageOPMLDidEnd:returnCode:context:)
          contextInfo:nil];
}
- (IBAction)addOPML:(id)sender
{
    [self openOPMLFrom:opmlURLField];
    [opmlURLField setStringValue:@""];
    [NSApp endSheet:manageOpmlSheet returnCode:NSOKButton];
}
- (IBAction)cancelManageOPML:(id)sender
{
    [opmlURLField setStringValue:@""];
    [NSApp endSheet:manageOpmlSheet returnCode:NSCancelButton];    
}
- (void)manageOPMLDidEnd:(NSWindow *)sheet returnCode:(int)returnCode context:(void *)context
{
    [sheet close];
}

- (IBAction)openEntry:(id)sender
{
    NSURL *url = [NSURL URLWithString:[sender valueForKey:@"urlString"]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}


- (NSOperationQueue *)operationQueue
{
	if (!operationQueue){
		operationQueue = [[NSOperationQueue alloc] init];
		[operationQueue setMaxConcurrentOperationCount:8];
	}
	return operationQueue;
}

#pragma mark -

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (aSelector == @selector(copy:)){
        NSResponder *firstResponder = [window firstResponder];
        return (([firstResponder isEqualTo:groupsView] && [groupsController selectionIndex] != NSNotFound) ||
                ([firstResponder isEqualTo:entriesView] && [entriesController selectionIndex] != NSNotFound));
    }
    return [super respondsToSelector:aSelector];
}
- (IBAction)copy:(id)sender
{
    NSResponder *firstResponder = [window firstResponder];
    NSURL *copiedURL = nil;
    
    if ([firstResponder isEqualTo:groupsView]){
        NSManagedObject *mo = [groupsController selection];
        copiedURL = [NSURL URLWithString:[mo valueForKeyPath:@"opml.urlString"]];
    }
    if ([firstResponder isEqualTo:entriesView]){
        NSManagedObject *mo = [entriesController selection];
        copiedURL = [NSURL URLWithString:[mo valueForKey:@"urlString"]];
    }
    
    if (copiedURL){
        NSPasteboard *pboard = [NSPasteboard generalPasteboard];
        [pboard declareTypes:[NSArray arrayWithObject:NSURLPboardType] owner:nil];
        [copiedURL writeToPasteboard:pboard];
    }
}


@end
