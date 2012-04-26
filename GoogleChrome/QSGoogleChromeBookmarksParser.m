//
//  QSGoogleChromeBookmarksParser.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-25.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeBookmarksParser.h"

@implementation QSGoogleChromeBookmarksParser


/*
 Validates that the path from the file system object source is a bookmarks file
 */
- (BOOL)validParserForPath:(NSString *)path {
    return [[path lastPathComponent] isEqualToString:@"Bookmarks"];
}


/*
 Quicksilver file system object source method.
 */
- (NSArray *)objectsFromPath:(NSString *)path withSettings:(NSDictionary *)settings {
    return [self loadBookmarksFrom:path omitRoots:YES];
}


/*
 Load bookmarks the given path
 */
- (NSArray *)loadBookmarksFrom:(NSString *)path omitRoots:(BOOL)omitRoots {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[path stringByStandardizingPath]];
    NSDictionary *roots = [[jsonData objectFromJSONData] objectForKey:@"roots"];
    
    NSString *key;
    NSDictionary *bookmark;
    NSArray *bookmarkChildren;
    
    for (key in roots) {
        bookmark = [roots objectForKey:key];
        bookmarkChildren = [bookmark objectForKey:@"children"];
        
        // Only add non-empty roots
        if ([bookmarkChildren count] > 0) {
            if (omitRoots) {
                [array addObjectsFromArray:[self createObjectsForChildren:bookmark]];
            } else {
                [array addObject:[self createFolderObject:bookmark]];
            }
        }
    }
    
    return array;
}


/*
 Creates a Quicksilver object for a bookmarks folder
 */
- (QSObject *)createFolderObject:(NSDictionary *)bookmark {
    QSObject *folder= [QSObject objectWithName:[bookmark objectForKey:@"name"]];
    
    [folder setIdentifier:[bookmark objectForKey:@"id"]];
    
    [folder setPrimaryType:kQSGoogleChromeBookmarkFolder];
    [folder setObject:bookmark forType:kQSGoogleChromeBookmarkFolder];
    [folder setObject:@"" forMeta:kQSObjectDefaultAction];
    
    // Load all urls from the children
    NSArray *children = [bookmark objectForKey:@"children"];
    NSMutableArray *urls = [NSMutableArray arrayWithCapacity:1];
    
    for (NSDictionary *child in children) {
        if ([[child objectForKey:@"type"] isEqualToString:@"url"]) {
            [urls addObject:[child objectForKey:@"url"]];
        }
    }
    
    [folder setObject:urls forType:QSURLType];
    
    return folder;
}


/*
 Creates Quicksilver objects for all the children in a
 bookmark folder.
 */
- (NSArray *)createObjectsForChildren:(NSDictionary *)bookmarkFolder {
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
    
    NSDictionary *child;
    NSString *type;
    
    for (child in [bookmarkFolder objectForKey:@"children"]) {
        type = [child objectForKey:@"type"];
        
        if ([type isEqualToString:@"folder"]) {
            [children addObject:[self createFolderObject:child]];
        } else if ([type isEqualToString:@"url"]) {
            [children addObject:[QSObject
                                 URLObjectWithURL:[child objectForKey:@"url"]
                                 title:[child objectForKey:@"name"]]];
        }
    }
    
    return children;
}



@end
