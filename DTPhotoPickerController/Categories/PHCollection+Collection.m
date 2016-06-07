//
//  PHCollection+Collection.m
//
//  Created by Darktt on 14/11/4.
//  Copyright (c) 2014 Darktt Personal Company. All rights reserved.
//

#import <Photos/Photos.h>
#import "PHCollection+Collection.h"

#define UES_PHOTOS_FRAMEWORK

@implementation PHCollection (Collection)

+ (PHFetchResult *)fetchTopLevelUserCollectionsWithName:(NSString *)name
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localizedTitle == %@", name];
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    [fetchOptions setPredicate:predicate];
    
    PHFetchResult *collections = [self fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    [fetchOptions release];
    
    return collections;
    
#else
    
    return nil;
    
#endif
}

@end
