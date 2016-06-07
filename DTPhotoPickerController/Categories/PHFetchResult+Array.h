//
//  PHFetchResult+Array.h
//  DTPhotoBrowser
//
//  Created by EdenLi on 2015/3/31.
//  Copyright (c) 2015年 Darktt. All rights reserved.
//

#import <Photos/Photos.h>

typedef void (^PHFetchResultEnumeratorBlock) (id obj, NSUInteger idx, BOOL *stop);

@interface PHFetchResult (Array)

- (NSArray *)convertToArray;

- (NSArray *)convertToArrayWithMediaType:(PHAssetMediaType)mediaType;

@end
