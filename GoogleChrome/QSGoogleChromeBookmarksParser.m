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
 Load bookmarks from Chrome's JSON bookmarks file
 */
- (NSArray *)bookmarks {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[kQSGoogleChromeBookmarksFile stringByStandardizingPath]];
    NSDictionary *roots = [[jsonData objectFromJSONData] objectForKey:@"roots"];
    
    NSString *key;
    NSDictionary *bookmark;
    NSArray *bookmarkChildren;
    
    for (key in roots) {
        bookmark = [roots objectForKey:key];
        bookmarkChildren = [bookmark objectForKey:@"children"];
        
        // Only add non-empty roots
        if ([bookmarkChildren count] > 0) {
            [array addObject:[self createFolderObject:bookmark]];
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


@end
