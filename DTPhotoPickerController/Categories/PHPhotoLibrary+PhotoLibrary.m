//
//  PHPhotoLibrary+PhotoLibrary.m
//
//  Created by Darktt on 14/11/4.
//  Copyright (c) 2014 Darktt Personal Company. All rights reserved.
//

#import <Photos/Photos.h>
#import "PHPhotoLibrary+PhotoLibrary.h"

#import "PHCollection+Collection.h"

#define UES_PHOTOS_FRAMEWORK

@implementation PHPhotoLibrary (PhotoLibrary)

#pragma mark - Create Collection

- (void)createCollectionWithName:(NSString *)name completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

#pragma mark - Add To Camera Roll

- (void)addImage:(UIImage *)image completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

- (void)addImageAtFileURL:(NSURL *)fileURL completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileURL];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

- (void)addVideoAtFileURL:(NSURL *)fileURL completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

#pragma mark Add To Collection

- (void)addImage:(UIImage *)image toCollectionWithName:(NSString *)collectionName completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    NSAssert(collectionName != nil, @"Collection name can not be nil.");
    
    PHFetchResult *collections = [PHCollection fetchTopLevelUserCollectionsWithName:collectionName];
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        PHAssetCollectionChangeRequest *collectionChangeRequest = nil;
        
        if (collections.count != 0) {
            
            // When album exist, get the album instance.
            PHAssetCollection *collection = (PHAssetCollection *)collections.firstObject;
            collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        } else {
            
            // Album not exist, create new album.
            collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
        }
        
        [collectionChangeRequest addAssets:@[assetChangeRequest.placeholderForCreatedAsset]];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

- (void)addImageAtFileURL:(NSURL *)fileURL toCollectionWithName:(NSString *)collectionName completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    NSAssert(collectionName != nil, @"Collection name can not be nil.");
    
    PHFetchResult *collections = [PHCollection fetchTopLevelUserCollectionsWithName:collectionName];
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:fileURL];
        
        PHAssetCollectionChangeRequest *collectionChangeRequest = nil;
        
        if (collections.count != 0) {
            
            // When album exist, get the album instance.
            PHAssetCollection *collection = (PHAssetCollection *)collections.firstObject;
            collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        } else {
            
            // Album not exist, create new album.
            collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
        }
        
        [collectionChangeRequest addAssets:@[assetChangeRequest.placeholderForCreatedAsset]];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

- (void)addVideoAtFileURL:(NSURL *)fileURL toCollectionWithName:(NSString *)collectionName completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    NSAssert(collectionName != nil, @"Collection name can not be nil.");
    
    PHFetchResult *collections = [PHCollection fetchTopLevelUserCollectionsWithName:collectionName];
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
        
        PHAssetCollectionChangeRequest *collectionChangeRequest = nil;
        
        if (collections.count != 0) {
            
            // When album exist, get the album instance.
            PHAssetCollection *collection = (PHAssetCollection *)collections.firstObject;
            collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        } else {
            
            // Album not exist, create new album.
            collectionChangeRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
        }
        
        [collectionChangeRequest addAssets:@[assetChangeRequest.placeholderForCreatedAsset]];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

#pragma mark - Delete Assets

- (void)deleteAssets:(id<NSFastEnumeration>)assets completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        [PHAssetChangeRequest deleteAssets:assets];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

#pragma mark - Remove Assets From Collection

- (void)removeAssets:(id<NSFastEnumeration>)assets fromCollectionWithName:(NSString *)collectionName completionHandler:(PHPhotoLibraryCompletionHandler)completionHandler failureHandle:(PHPhotoLibraryAccessFailureHandler)failureHandler
{
#ifdef UES_PHOTOS_FRAMEWORK
    
    PHFetchResult *collections = [PHCollection fetchTopLevelUserCollectionsWithName:collectionName];
    
    if (collections.count == 0) {
        NSError *collectionNotFoundError = [NSError errorWithDomain:@"com.darktt.collectionNotFound" code:-999 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"Collection not found.", @"")}];
        
        failureHandler(NO, collectionNotFoundError);
        
        return;
    }
    
    PHPhotoLibraryCompletionHandler changeBlock = ^() {
        PHAssetCollection *collection = (PHAssetCollection *)collections.firstObject;
        PHAssetCollectionChangeRequest *collectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
        
        [collectionChangeRequest removeAssets:assets];
    };
    
    PHPhotoLibraryAccessFailureHandler _completionHandler = ^(BOOL success, NSError *error) {
        if (!success) {
            failureHandler(success, error);
            
            return;
        }
        
        completionHandler();
    };
    
    [self performChanges:changeBlock completionHandler:_completionHandler];
    
#endif
}

@end
