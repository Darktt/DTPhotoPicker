//
//  PHImageManager+ImageManager.h
//  DTPhotoBrowser
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

@import Photos;

NS_ASSUME_NONNULL_BEGIN
typedef void (^PHImageManagerFetchImageResultHandler) (UIImage *_Nullable image, NSError *_Nullable error);

@interface PHImageManager (ImageManager)

- (void)thumbnailImageWithAsset:(PHAsset *)asset imageSize:(CGSize)size result:(PHImageManagerFetchImageResultHandler)resultHandler;

- (PHImageRequestID)imageWithAsset:(PHAsset *)asset
                         limitSize:(CGSize)size
                   progressHandler:(nullable PHAssetImageProgressHandler)progressHandler
                            result:(PHImageManagerFetchImageResultHandler)resultHandler;

@end
NS_ASSUME_NONNULL_END