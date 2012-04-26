//
//  QSGoogleChromeBookmarksParser.h
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-25.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import <QSCore/QSCore.h>
#import "JSONKit.h"
#import "QSGoogleChromeDefinitions.h"

@interface QSGoogleChromeBookmarksParser : QSParser

- (NSArray *)loadBookmarksFrom:(NSString *)path omitRoots:(BOOL)omitRoots;
- (QSObject *)createFolderObject:(NSDictionary *)bookmark;
- (NSArray *)createObjectsForChildren:(NSDictionary *)bookmarkFolder;

@end
