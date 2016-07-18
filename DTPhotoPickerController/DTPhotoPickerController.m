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
@dynamic delegate;

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
    
    CGSize fetchSize = CGSizeMake(3000.0f, 3000.0f);
    
    DTPhotoPreviewController *photoPreviewController = [DTPhotoPreviewController photoPreviewController];
    [photoPreviewController setMediaType:PHAssetMediaTypeImage];
    [photoPreviewController setSourceType:PHAssetSourceTypeUserLibrary];
    [photoPreviewController setFetchedLimitSize:fetchSize];
    [photoPreviewController setNumberOfAssetsFetched:1];
    
    [self setViewControllers:@[photoPreviewController]];
    [self setPhotoPreviewController:photoPreviewController];
    [self setDelegate:delegate];
    
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

- (void)setFetchedLimitSize:(CGSize)fetchedLimitSize
{
    [self.photoPreviewController setFetchedLimitSize:fetchedLimitSize];
}

- (CGSize)fetchedLimitSize
{
    return self.photoPreviewController.fetchedLimitSize;
}

- (void)setNumberOfAssetsFetched:(NSUInteger)numberOfAssetsFetched
{
    [self.photoPreviewController setNumberOfAssetsFetched:numberOfAssetsFetched];
}

- (NSUInteger)numberOfAssetsFetched
{
    return self.photoPreviewController.numberOfAssetsFetched;
}

- (void)setTintColor:(UIColor *)tintColor
{
    [self.navigationBar setTintColor:tintColor];
    [self.photoPreviewController setTintColor:tintColor];
}

- (UIColor *)tintColor
{
    return self.photoPreviewController.tintColor;
}

@end
