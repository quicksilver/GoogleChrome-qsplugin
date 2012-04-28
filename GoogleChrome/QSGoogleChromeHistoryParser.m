//
//  QSGoogleChromeHistoryParser.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-04-28.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeHistoryParser.h"

@implementation QSGoogleChromeHistoryParser


- (BOOL)validParserForPath:(NSString *)path {
    return [[path lastPathComponent] isEqualToString:@"History"];
}


- (NSArray *)objectsFromPath:(NSString *)path withSettings:(NSDictionary *)settings {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    
    FMDatabase *db = [QSGoogleChromeDatabaseManager openDatabase:path];
    
    if (!db) {
        return objects;
    }
    
    FMResultSet *rs = [db executeQuery:@"select id, url, title from urls order by visit_count desc"];
    
	if ([db hadError]) {
		NSLog(@"Error while reading Chrome history database. Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		return objects;
	}
    
    while ([rs next]) {
        [objects addObject:[QSObject URLObjectWithURL:[rs stringForColumn:@"url"]
                                                title:[rs stringForColumn:@"title"]]];
    }
    
    [rs close];
    [db close];
    
    return objects;
}


@end
