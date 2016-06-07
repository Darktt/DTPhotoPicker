//
//  PHImageManager+ImageManager.m
//  DTPhotoBrowser
//
//  Created by Darktt on 2015/3/30.
//  Copyright (c) 2015 Darktt. All rights reserved.
//

#import "PHImageManager+ImageManager.h"

@implementation PHImageManager (ImageManager)

- (void)thumbnailImageWithAsset:(PHAsset *)asset imageSize:(CGSize)size result:(PHImageManagerFetchImageResult)resultHandler
{
    PHImageContentMode contentMode = PHImageContentModeAspectFill;
    
    CGFloat minimumSide = MIN(asset.pixelWidth, asset.pixelHeight);
    CGRect square = CGRectMake(0, 0, minimumSide, minimumSide);
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    [requestOptions setSynchronous:YES];
    [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [requestOptions setResizeMode:PHImageRequestOptionsResizeModeExact];
    [requestOptions setNormalizedCropRect:square];
    
    void (^_resultHandler) (UIImage *, NSDictionary *) = ^(UIImage *result, NSDictionary *info) {
        NSError *error = info[PHImageErrorKey];
        
        if (error != nil) {
            NSLog(@"Request image error: %@", error);
        }
        
        if (resultHandler != nil) resultHandler(result);
    };
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset targetSize:size contentMode:contentMode options:requestOptions resultHandler:_resultHandler];
    [requestOptions release];
}

- (PHImageRequestID)imageWithAsset:(PHAsset *)asset limitSize:(CGSize)size result:(PHImageManagerFetchImageResult)resultHandler
{
    PHImageContentMode contentMode = PHImageContentModeAspectFit;
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    [requestOptions setSynchronous:NO];
    [requestOptions setVersion:PHImageRequestOptionsVersionCurrent];
    [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    [requestOptions setResizeMode:PHImageRequestOptionsResizeModeFast];
    [requestOptions setNetworkAccessAllowed:YES];
    
    void (^_resultHandler) (UIImage *, NSDictionary *) = ^(UIImage *result, NSDictionary *info) {
        NSError *error = info[PHImageErrorKey];
        
        if (error != nil) {
            NSLog(@"Request image error: %@", error);
        }
        
        if (resultHandler == nil) return;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            resultHandler(result);
        }];
    };
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    PHImageRequestID requestID = [imageManager requestImageForAsset:asset targetSize:size contentMode:contentMode options:requestOptions resultHandler:_resultHandler];
    [requestOptions release];
    
    return requestID;
}

@end
