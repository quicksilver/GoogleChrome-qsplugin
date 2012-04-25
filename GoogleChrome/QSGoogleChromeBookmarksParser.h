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

- (NSArray *)bookmarks;
- (QSObject *)createFolderObject:(NSDictionary *)bookmark;

@end
