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
    return [self loadBookmarksFrom:path deep:YES withBundle:[settings objectForKey:@"sourceBundle"]];
}


/*
 Load bookmarks the given path
 */
- (NSArray *)loadBookmarksFrom:(NSString *)path deep:(BOOL)deep withBundle:(NSString *)bundle {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:[path stringByStandardizingPath]];
	NSError *error = nil;
	NSDictionary *bookmarks = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
	if (!bookmarks) {
		NSLog(@"Error reading bookmarks: %@", error);
		return array;
	}
    NSDictionary *roots = [bookmarks objectForKey:@"roots"];
    
    NSString *key;
    NSDictionary *bookmark;
    NSArray *bookmarkChildren;
    
    for (key in roots) {
        bookmark = [roots objectForKey:key];

        // Only handle proper sub objects
        if ([bookmark isKindOfClass:[NSDictionary class]]) {
            bookmarkChildren = [bookmark objectForKey:@"children"];

            // Only add non-empty roots
            if ([bookmarkChildren count] > 0) {
                QSObject *folder = [self createFolderObject:bookmark withBundle:bundle];

                if (folder != nil) {
                    [array addObject:folder];

                    if (deep) {
                        [array addObjectsFromArray:[self createObjectsForChildren:bookmark deep:deep withBundle:bundle]];
                    }
                }
            }
        }
    }
    
    return array;
}


/*
 Creates a Quicksilver object for a bookmarks folder
 */
- (QSObject *)createFolderObject:(NSDictionary *)bookmark withBundle:(NSString *)bundle {
    NSString *bookmarkName = [bookmark objectForKey:@"name"];
    NSString *bookmarkId   = [bookmark objectForKey:@"id"];

    if (bookmarkId == nil || bookmarkName == nil) {
        return nil;
    }

    QSObject *folder = [QSObject objectWithName:bookmarkName];
    
    [folder setIdentifier:bookmarkId];
    
    [folder setPrimaryType:kQSGoogleChromeBookmarkFolder];
    [folder setObject:bookmark forType:kQSGoogleChromeBookmarkFolder];
    [folder setObject:@"" forMeta:kQSObjectDefaultAction];
    
    if (bundle) {
        [folder setObject:bundle forType:kQSGoogleChromeURL];
    }

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
- (NSArray *)createObjectsForChildren:(NSDictionary *)bookmarkFolder deep:(BOOL)deep withBundle:(NSString *)bundle {
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:1];
    
    NSDictionary *child;
    NSString *type;
    
    for (child in [bookmarkFolder objectForKey:@"children"]) {
        type = [child objectForKey:@"type"];
        
        if ([type isEqualToString:@"folder"]) {
            QSObject *folder = [self createFolderObject:child withBundle:bundle];

            if (folder != nil) {
                [children addObject:folder];

                if (deep) {
                    [children addObjectsFromArray:[self createObjectsForChildren:child deep:deep withBundle:bundle]];
                }
            }
        } else if ([type isEqualToString:@"url"]) {
            NSString *bookmarkName = [child objectForKey:@"name"];
            NSString *bookmarkURL  = [child objectForKey:@"url"];

            if (bookmarkName != nil && bookmarkURL != nil) {
                QSObject *bookmark = [QSObject
                                      URLObjectWithURL:bookmarkURL
                                      title:bookmarkName];
                [bookmark setLabel:bookmarkName];
                [bookmark setName:[NSString stringWithFormat:@"%@ in %@",
                                   bookmarkName,
                                   [bookmarkFolder objectForKey:@"name"]]];

                if (bundle) {
                    [bookmark setObject:bundle forType:kQSGoogleChromeURL];
                }

                [children addObject:bookmark];
            }
        }
    }
    
    return children;
}



@end
