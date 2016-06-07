//
//  DTPhotoPickerController.m
//
//  Created by Darktt on 16/6/3.
//  Copyright © 2016 Darktt. All rights reserved.
//

#import "DTPhotoPickerController.h"

#import "DTPhotoPreviewController.h"

@interface DTPhotoPickerController ()

@property (assign, nonatomic) DTPhotoPreviewController *photoPreviewController;

@end

@implementation DTPhotoPickerController

+ (instancetype)photoPickerControllerWithDelegate:(id<DTPhotoPickerControllerDelegate>)delegate
{
    DTPhotoPickerController *photoPickController = [[DTPhotoPickerController alloc] initWithDelegate:delegate];
    
    return [photoPickController autorelease];
}

#pragma mark Instance Method -

- (instancetype)initWithDelegate:(id<DTPhotoPickerControllerDelegate>)delegate
{
    self = [super initWithNavigationBarClass:[UINavigationBar class] toolbarClass:[UIToolbar class]];
    if (self == nil) return nil;
    
    DTPhotoPreviewController *photoPreviewController = [DTPhotoPreviewController photoPreviewController];
    [photoPreviewController setMediaType:PHAssetMediaTypeImage];
    [photoPreviewController setSourceType:PHAssetSourceTypeUserLibrary];
    
    [self setViewControllers:@[photoPreviewController]];
    [self setPhotoPreviewController:photoPreviewController];
    
    return self;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    
    if (self == nil) return nil;
    
    return self;
}

#pragma mark - Override Property

- (void)setMediaType:(PHAssetMediaType)mediaType
{
    [self.photoPreviewController setMediaType:mediaType];
}

- (PHAssetMediaType)mediaType
{
    return self.photoPreviewController.mediaType;
}

- (void)setSourceType:(PHAssetSourceType)sourceType
{
    [self.photoPreviewController setSourceType:sourceType];
}

- (PHAssetSourceType)sourceType
{
    return self.photoPreviewController.sourceType;
}

@end
