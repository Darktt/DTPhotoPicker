//
//  DTPhotoPickerController.h
//
//  Created by Darktt on 16/6/3.
//  Copyright © 2016 Darktt. All rights reserved.
//

@import Photos;

NS_ASSUME_NONNULL_BEGIN
@protocol DTPhotoPickerControllerDelegate;
@interface DTPhotoPickerController : UINavigationController

@property (assign) PHAssetMediaType mediaType;
@property (assign) PHAssetSourceType sourceType;

+ (instancetype)photoPickerControllerWithDelegate:(id<DTPhotoPickerControllerDelegate>)delegate;
- (instancetype)initWithDelegate:(id<DTPhotoPickerControllerDelegate>)delegate;

@end

@protocol DTPhotoPickerControllerDelegate <UINavigationControllerDelegate>



@end
NS_ASSUME_NONNULL_END