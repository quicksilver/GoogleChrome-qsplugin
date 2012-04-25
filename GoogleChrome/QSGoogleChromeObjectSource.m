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
 Loads right arrow children for the Chrome app, the open web pages proxy object
 and the folders in the bookmarks.
 */
- (BOOL) loadChildrenForObject:(QSObject *)object {
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
    
    if ([[object primaryType] isEqualToString:NSFilenamesPboardType]) {
        QSObject *child;
        
        // Open web pages
        child = [QSObject objectWithName:@"Open Web Pages (Chrome)"];
        
        [child setPrimaryType:kQSGoogleChromeOpenWebPages];
        [child setObject:@"Open Web Pages (Chrome)" forType:kQSGoogleChromeOpenWebPages];
        
        [children addObject:child];
        
        // The root bookmark folders
        QSGoogleChromeBookmarksParser *parser = [[[QSGoogleChromeBookmarksParser alloc] init] autorelease];
        [children addObjectsFromArray:[parser bookmarks]];

        [object setChildren:children];
        return YES;
        
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeOpenWebPages]) {
        // Add urls from all open tabs
        GoogleChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:kQSGoogleChromeBundle];
        
        for (GoogleChromeWindow *window in [chrome windows]) {
            for (GoogleChromeTab *tab in [window tabs]) {
                [children addObject:[QSObject URLObjectWithURL:tab.URL title:tab.title]];
            }
        }
        
        [object setChildren:children];
        return YES;
    } else if ([[object primaryType] isEqualToString:kQSGoogleChromeBookmarkFolder]) {
        // Add child folders and urls
        NSDictionary *folder = [object objectForType:kQSGoogleChromeBookmarkFolder];
        QSGoogleChromeBookmarksParser *parser = [[[QSGoogleChromeBookmarksParser alloc] init] autorelease];
        NSDictionary *bookmark;
        NSString *type;
        
        for (bookmark in [folder objectForKey:@"children"]) {
            type = [bookmark objectForKey:@"type"];
            
            if ([type isEqualToString:@"folder"]) {
                [children addObject:[parser createFolderObject:bookmark]];
            } else if ([type isEqualToString:@"url"]) {
                [children addObject:[QSObject
                                     URLObjectWithURL:[bookmark objectForKey:@"url"]
                                     title:[bookmark objectForKey:@"name"]]];
            }
        }
        
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
        [object setIcon:[QSResourceManager imageNamed:@"GenericFolderIcon"]]; 
    }
}


/*
 All objects handled by this source have children
 */
- (BOOL)objectHasChildren:(QSObject *)object {
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


@end
