//
//  PHImageManager+ImageManager.h
//  DTPhotoBrowser
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

@import Photos;

NS_ASSUME_NONNULL_BEGIN
typedef void (^PHImageManagerFetchImageResult) (UIImage *image);

@interface PHImageManager (ImageManager)

- (void)thumbnailImageWithAsset:(PHAsset *)asset imageSize:(CGSize)size result:(PHImageManagerFetchImageResult)resultHandler;

- (PHImageRequestID)imageWithAsset:(PHAsset *)asset limitSize:(CGSize)size result:(PHImageManagerFetchImageResult)resultHandler;

@end
NS_ASSUME_NONNULL_END