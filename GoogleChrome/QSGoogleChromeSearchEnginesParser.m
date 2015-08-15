//
//  QSGoogleChromeSearchesParser.m
//  GoogleChrome
//
//  Created by Andreas Johansson on 2012-05-01.
//  Copyright (c) 2012 stdin.se. All rights reserved.
//

#import "QSGoogleChromeSearchEnginesParser.h"

@implementation QSGoogleChromeSearchEnginesParser


/*
 Creates catalog objects for the web searches
 */
- (NSArray *)objectsFromPath:(NSString *)path withSettings:(NSDictionary *)settings {
    return [self allSearchesFromDB:path];
}


/*
 Creates QS web search objects from Chrome's web searches
 */
- (NSArray *)allSearchesFromDB:(NSString *)path {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];
    
    FMDatabase *db = [QSGoogleChromeDatabaseManager openDatabase:[path stringByStandardizingPath]];
    
    if (!db) {
        return objects;
    }
    
    FMResultSet *rs = [db executeQuery:@"select short_name, keyword, url from keywords"];
    
	if ([db hadError]) {
		NSLog(@"Error while reading Chrome search engines. Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		return objects;
	}
    
    QSObject *obj;
    
    while ([rs next]) {
        obj = [QSObject URLObjectWithURL:[self convertSearchEngineURL:[rs stringForColumn:@"url"]]
                                   title:[rs stringForColumn:@"short_name"]];
        [obj setLabel:[rs stringForColumn:@"short_name"]];
        [obj setName:[rs stringForColumn:@"keyword"]];
        [objects addObject:obj];
    }
    
    [rs close];
    [db close];
    
    return objects;
}


/*
 Converts a search engine url to a Quicksilver search url
 */
- (NSString *)convertSearchEngineURL:(NSString *)url {
    NSString *converted = [url stringByReplacingOccurrencesOfString:@"{searchTerms}" withString:@"***"];
    converted = [converted stringByReplacingOccurrencesOfString:@"{inputEncoding}" withString:@"UTF-8"];
    converted = [converted stringByReplacingOccurrencesOfString:@"{google:baseURL}" withString:@"http://www.google.com/"];
    return [converted stringByReplacingOccurrencesOfRegex:@"\\{.*?\\}" withString:@""];
}


@end
