//
//  PHFetchResult+Array.m
//  DTPhotoBrowser
//
//  Created by EdenLi on 2015/3/31.
//  Copyright (c) 2015年 Darktt. All rights reserved.
//

#import "PHFetchResult+Array.h"

@implementation PHFetchResult (Array)

- (NSArray *)convertToArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    
    PHFetchResultEnumeratorBlock enumeratorBlock = ^(id obj, NSUInteger idx, BOOL *stop) {
        [array addObject:obj];
    };
    
    [self enumerateObjectsUsingBlock:enumeratorBlock];
    
    return array;
}

- (NSArray *)convertToArrayWithMediaType:(PHAssetMediaType)mediaType
{
    NSUInteger count = [self countOfAssetsWithMediaType:mediaType];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    
    PHFetchResultEnumeratorBlock enumeratorBlock = ^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
        if (asset.mediaType != mediaType) {
            return;
        }
        
        [array addObject:asset];
    };
    
    [self enumerateObjectsUsingBlock:enumeratorBlock];
    
    return array;
}

@end
