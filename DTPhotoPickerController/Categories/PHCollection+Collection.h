//
//  PHCollection+Collection.h
//
//  Created by Darktt on 14/11/4.
//  Copyright (c) 2014 Darktt Personal Company. All rights reserved.
//

#import <Photos/PHCollection.h>

@interface PHCollection (Collection)

// Fetch create by user collections.
+ (PHFetchResult *)fetchTopLevelUserCollectionsWithName:(NSString *)name;

@end
