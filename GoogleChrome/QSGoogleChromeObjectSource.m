//
//  QSGoogleChromeObjectSource.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-06.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeObjectSource.h"

@implementation QSGoogleChromeObjectSource


- (NSString *)getAppName { return @"Chrome"; }
- (NSString *)getBundle { return kQSGoogleChromeBundle; }
- (NSString *)getBundleIcon { return @"ChromeIcon"; }
- (NSString *)getProfileDirectory { return @"~/Library/Application Support/Google/Chrome/Default"; }


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
        
        // Search engines
        [children addObject:[self createSearchEnginesObject]];

        // The root bookmark folders
        NSString *bookmarksFile = [NSString stringWithFormat:@"%@/Bookmarks", [self getProfileDirectory]];
        QSGoogleChromeBookmarksParser *bookmarksParser = [[[QSGoogleChromeBookmarksParser alloc] init] autorelease];
        [children addObjectsFromArray:[bookmarksParser loadBookmarksFrom:bookmarksFile deep:NO]];
        
        // History
        QSObject *history = [QSObject objectWithName:@"History"];
        
        [history setPrimaryType:kQSGoogleChromeHistory];
        [history setObject:@"History" forType:kQSGoogleChromeHistory];
        [history setObject:[self getProfileDirectory] forMeta:@"profileDirectory"];
        [children addObject:history];
        
        [object setChildren:children];
        return YES;
        
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeOpenWebPages]) {
        NSString *bundle = [object objectForMeta:@"bundle"];
        
        if (QSAppIsRunning(bundle)) {
            // Add urls from all open tabs
            GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:bundle];
            QSObject *child;
            int tabIndex;
            
            for (GoogleChromeWindow *window in [chrome windows]) {
                tabIndex = 1;
                
                for (GoogleChromeTab *tab in [window tabs]) {
                    child = [QSObject URLObjectWithURL:tab.URL title:tab.title];
                    [child setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      tab, @"tab",
                                      window, @"window",
                                      [NSNumber numberWithInt:tabIndex], @"tabIndex",
                                      nil ]
                             forType:kQSGoogleChromeTab];
                    
                    [children addObject:child];
                    tabIndex++;
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
        
        [children addObjectsFromArray:[parser createObjectsForChildren:folder deep:NO]];
        [object setChildren:children];
        
        return YES;
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeHistory]) {
        // History entries
        NSString *profileDirectory = [object objectForMeta:@"profileDirectory"];
        QSGoogleChromeHistoryParser *parser = [[[QSGoogleChromeHistoryParser alloc] init] autorelease];
        
        [children addObjectsFromArray:[parser allHistoryEntriesFromDB:[NSString stringWithFormat:@"%@/History", profileDirectory]]];
        [object setChildren:children];
        
        return YES;
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeSearchEngines]) {
        // Search engines
        NSString *profileDirectory = [object objectForMeta:@"profileDirectory"];
        QSGoogleChromeSearchEnginesParser *parser = [[[QSGoogleChromeSearchEnginesParser alloc] init] autorelease];
        
        [children addObjectsFromArray:[parser allSearchesFromDB:[NSString stringWithFormat:@"%@/Web Data", profileDirectory]]];
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
    if ([type isEqualToString:kQSGoogleChromeBookmarkFolder]) {
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
    } else if ([type isEqualToString:kQSGoogleChromeSearchEngines]) {
        return @"Search engines, including keywords";
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
    NSString *name = [NSString stringWithFormat:@"Open Web Pages (%@)", [self getAppName]];
    QSObject *object = [QSObject objectWithName:name];
    
    [object setPrimaryType:kQSGoogleChromeOpenWebPages];
    [object setObject:name forType:kQSGoogleChromeOpenWebPages];
    [object setIcon:[QSResourceManager imageNamed:[self getBundleIcon]]];
    [object setObject:[self getBundle] forMeta:@"bundle"];
    
    return object;
}


/*
 Creates the QS object for Chrome's search engines
 */
- (QSObject *)createSearchEnginesObject {
    NSString *name = [NSString stringWithFormat:@"Search Engines (%@)", [self getAppName]];
    QSObject *object = [QSObject objectWithName:name];
    
    [object setPrimaryType:kQSGoogleChromeSearchEngines];
    [object setObject:name forType:kQSGoogleChromeSearchEngines];
    [object setIcon:[QSResourceManager imageNamed:[self getBundleIcon]]];
    [object setObject:[self getProfileDirectory] forMeta:@"profileDirectory"];
    
    return object;
}


@end


@implementation QSGoogleChromeCanaryObjectSource

- (NSString *)getAppName { return @"Chrome Canary"; }
- (NSString *)getBundle { return kQSGoogleChromeCanaryBundle; }
- (NSString *)getBundleIcon { return @"ChromeCanaryIcon"; }
- (NSString *)getProfileDirectory { return @"~/Library/Application Support/Google/Chrome Canary/Default"; }

@end
