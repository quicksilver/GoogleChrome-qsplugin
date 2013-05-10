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


/*
 Creates catalog objects for history
 */
- (NSArray *)objectsFromPath:(NSString *)path withSettings:(NSDictionary *)settings {
    NSString *query = [NSString stringWithFormat:@"select id, url, title "
                        " from urls order by last_visit_time desc limit %d",
                        
                        [[settings objectForKey:@"historySize"] intValue]
                        ];
    return [self createObjectsFromQuery:query inDatabase:path withBundle:[settings objectForKey:@"sourceBundle"]];
}


/*
 All history entries
 */
- (NSArray *)allHistoryEntriesFromDB:(NSString *)path withBundle:(NSString *)bundle {
    return [self createObjectsFromQuery:@"select id, url, title from urls order by last_visit_time desc" inDatabase:path withBundle:bundle];
}


/*
 Generates QS objects from history entries returned by a query
 */
- (NSArray *)createObjectsFromQuery:(NSString *)query inDatabase:(NSString *)path withBundle:(NSString *)bundle {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    
    FMDatabase *db = [QSGoogleChromeDatabaseManager openDatabase:[path stringByStandardizingPath]];
    
    if (!db) {
        return objects;
    }
    
    FMResultSet *rs = [db executeQuery:query];
    
	if ([db hadError]) {
		NSLog(@"Error while reading Chrome history database. Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		return objects;
	}
    
    while ([rs next]) {
        QSObject *object = [QSObject URLObjectWithURL:[rs stringForColumn:@"url"]
                                                title:[rs stringForColumn:@"title"]];

        if (bundle) {
            [object setObject:bundle forType:kQSGoogleChromeURL];
        }

        [objects addObject:object];
    }
    
    [rs close];
    [db close];
    
    return objects;
}


@end
