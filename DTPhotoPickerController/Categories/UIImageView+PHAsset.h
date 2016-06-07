//
//  UIImageView+PHAsset.h
//  DTPhotoPickerController
//
//  Created by EdenLi on 2016/6/6.
//  Copyright © 2016年 Darktt. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@class PHAsset;
@interface UIImageView (PHAsset)

- (void)setImageWithAsset:(PHAsset *)asset forImageSize:(CGSize)imageSize;

@end
NS_ASSUME_NONNULL_END
