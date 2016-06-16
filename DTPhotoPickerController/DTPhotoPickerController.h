//
//  DTPhotoPickerController.h
//
//  Created by Darktt on 16/6/3.
//  Copyright © 2016 Darktt. All rights reserved.
//

@import Photos;

NS_ASSUME_NONNULL_BEGIN
@class DTPhotoPickerController;
@protocol DTPhotoPickerControllerDelegate <UINavigationControllerDelegate>

@optional
- (void)picker:(DTPhotoPickerController *)picker didPickedImages:(NSArray<UIImage *> *)images;
- (void)picker:(DTPhotoPickerController *)picker didPickedVideoPaths:(NSArray<NSString *> *)videoPaths;

@end

@interface DTPhotoPickerController : UINavigationController

@property (assign) PHAssetMediaType mediaType;
@property (assign) PHAssetSourceType sourceType;
@property (assign) CGSize fetchedLimitSize;
@property (assign) NSUInteger numberOfAssetsFetched;
@property (assign, nonatomic, nullable) id<DTPhotoPickerControllerDelegate> delegate;

+ (instancetype)photoPickerControllerWithDelegate:(nullable id<DTPhotoPickerControllerDelegate>)delegate;
- (instancetype)initWithDelegate:(nullable id<DTPhotoPickerControllerDelegate>)delegate;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_UNAVAILABLE;
- (instancetype)initWithNavigationBarClass:(nullable Class)navigationBarClass toolbarClass:(nullable Class)toolbarClass NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end
NS_ASSUME_NONNULL_END