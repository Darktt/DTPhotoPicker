//
//  DTPhotoPickerController.h
//
//  Created by Darktt on 16/6/3.
//  Copyright © 2016 Darktt. All rights reserved.
//

@import Photos;

NS_ASSUME_NONNULL_BEGIN
@interface DTPhotoPreviewController : UIViewController

@property (assign) PHAssetMediaType mediaType;
@property (assign) PHAssetSourceType sourceType;

+ (instancetype)photoPreviewController;

@end
NS_ASSUME_NONNULL_END