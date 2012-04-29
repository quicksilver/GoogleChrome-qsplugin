//
//  QSGoogleChromeObjectSource.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeObjectSource.h"

@implementation QSGoogleChromeObjectSource


/*
 Always rescan the catalog entries provided by this object source
 */
- (BOOL)indexIsValidFromDate:(NSDate *)indexDate forEntry:(NSDictionary *)theEntry {
	return NO;
}


/*
 Provides catalog entries for the current open web pages object
 */
- (NSArray *)objectsForEntry:(NSDictionary *)theEntry {
    if ([[theEntry objectForKey:@"ID"] isEqualToString:@"QSPresetGoogleChromeOpenPages"]) {
		return [NSArray arrayWithObject:[self createOpenPagesObject]];
	}
    return nil;
}



/*
 Loads right arrow children for the Chrome app, the open web pages proxy object
 and the folders in the bookmarks.
 */
- (BOOL) loadChildrenForObject:(QSObject *)object {
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
    
    if ([[object primaryType] isEqualToString:NSFilenamesPboardType]) {
        // Open web pages
        [children addObject:[self createOpenPagesObject]];
        
        // The root bookmark folders
        QSGoogleChromeBookmarksParser *bookmarksParser = [[[QSGoogleChromeBookmarksParser alloc] init] autorelease];
        [children addObjectsFromArray:[bookmarksParser loadBookmarksFrom:kQSGoogleChromeBookmarksFile deep:NO]];
        
        // History
        QSObject *history = [QSObject objectWithName:kQSGoogleChromeHistoryName];
        
        [history setPrimaryType:kQSGoogleChromeHistory];
        [history setObject:kQSGoogleChromeHistoryName forType:kQSGoogleChromeHistory];
        [children addObject:history];
        
        [object setChildren:children];
        return YES;
        
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeOpenWebPages]) {
        if (QSAppIsRunning(kQSGoogleChromeBundle)) {
            // Add urls from all open tabs
            GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:kQSGoogleChromeBundle];
            
            for (GoogleChromeWindow *window in [chrome windows]) {
                for (GoogleChromeTab *tab in [window tabs]) {
                    [children addObject:[QSObject URLObjectWithURL:tab.URL title:tab.title]];
                }
            }
            
            [object setChildren:children];
            return YES;
        } else {
            NSBeep();
        }
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeBookmarkFolder]) {
        // Add child folders and urls
        NSDictionary *folder = [object objectForType:kQSGoogleChromeBookmarkFolder];
        QSGoogleChromeBookmarksParser *parser = [[[QSGoogleChromeBookmarksParser alloc] init] autorelease];
        
        [children addObjectsFromArray:[parser createObjectsForChildren:folder]];
        [object setChildren:children];
        
        return YES;
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeHistory]) {
        // History entries
        QSGoogleChromeHistoryParser *parser = [[[QSGoogleChromeHistoryParser alloc] init] autorelease];
        
        [children addObjectsFromArray:[parser allHistoryEntriesFromDB:kQSGoogleChromeHistoryFile]];
        [object setChildren:children];
        
        return YES;
    }
    
    return NO;
}


/*
 Sets the icons for the open pages proxy and the bookmark folders
 */
- (void)setQuickIconForObject:(QSObject *)object {
    NSString *type = [object primaryType];
    if ([type isEqualToString:kQSGoogleChromeOpenWebPages]) {
        [object setIcon:[QSResourceManager imageNamed:kQSGoogleChromeBundle]];
    } else if ([type isEqualToString:kQSGoogleChromeBookmarkFolder]) {
        [object setIcon:[QSResourceManager imageNamed:@"ChromeFolder"]]; 
    } else if ([type isEqualToString:kQSGoogleChromeHistory]) {
        [object setIcon:[QSResourceManager imageNamed:@"ChromeFolder"]]; 
    }
}


/*
 All objects handled by this source have children
 */
- (BOOL)objectHasChildren:(QSObject *)object {
    NSString *type = [object primaryType];
    if ([type isEqualToString:kQSGoogleChromeOpenWebPages]) {
        return QSAppIsRunning(kQSGoogleChromeBundle);
    }
    return YES;
}


/*
 Sets the details for the open pages proxy and the bookmark folders
 */
- (NSString *)detailsOfObject:(QSObject *)object {
    NSString *type = [object primaryType];
    if ([type isEqualToString:kQSGoogleChromeOpenWebPages]) {
        return @"URLs from all open windows and tabs";
    } else if ([type isEqualToString:kQSGoogleChromeBookmarkFolder]) {
        // Count the number of children the folder has
        NSDictionary *folder = [object objectForType:kQSGoogleChromeBookmarkFolder];
        NSArray *children = [folder objectForKey:@"children"];
        
        int nChildren = [children count];
        return [NSString stringWithFormat:@"%d item%@", nChildren, ESS(nChildren)]; 
    }
    
    return nil;
}


/*
 Creates the QS object for the current open web pages
 */
- (QSObject *)createOpenPagesObject {
    QSObject *object = [QSObject objectWithName:kQSGoogleChromeOpenWebPagesName];
    
    [object setPrimaryType:kQSGoogleChromeOpenWebPages];
    [object setObject:kQSGoogleChromeOpenWebPagesName forType:kQSGoogleChromeOpenWebPages];
    
    return object;
}


@end
