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
@property (assign) CGSize fetchedLimitSize;
@property (assign) NSUInteger numberOfAssetsFetched;
@property (retain, nonatomic) UIColor *tintColor;

+ (instancetype)photoPreviewController;

@end
NS_ASSUME_NONNULL_END