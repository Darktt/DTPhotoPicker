//
//  UIImageView+PHAsset.m
//  DTPhotoPickerController
//
//  Created by EdenLi on 2016/6/6.
//  Copyright © 2016年 Darktt. All rights reserved.
//

#import "UIImageView+PHAsset.h"
#import "PHImageManager+ImageManager.h"

static NSDateFormatter *kDateFormatter = nil;

@implementation UIImageView (PHAsset)

- (void)setImageWithAsset:(PHAsset *)asset forImageSize:(CGSize)imageSize
{
    NSDate *creationDate = asset.creationDate;
    
    NSString *fileName = [NSString stringWithFormat:@"%.0f.jpg", creationDate.timeIntervalSince1970];
    NSString *savePath = [self cachesPathWithFileName:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExist = [fileManager fileExistsAtPath:savePath];
    
    if (fileExist) {
        UIImage *image = [UIImage imageWithContentsOfFile:savePath];
        [self setImage:image];
        
        return;
    }
    
    PHImageManagerFetchImageResult resultHandler = ^(UIImage *image) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        [data writeToFile:savePath atomically:NO];
        
        image = [UIImage imageWithContentsOfFile:savePath];
        
        [self setImage:image];
    };
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager thumbnailImageWithAsset:asset imageSize:imageSize result:resultHandler];
}

#pragma mark - Private Method

+ (NSDateFormatter *)dateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kDateFormatter = [NSDateFormatter new];
        [kDateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    });
    
    return kDateFormatter;
}

- (NSString *)cachesPathWithFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    NSString *cachesPath = paths.firstObject;
    
    return [cachesPath stringByAppendingPathComponent:fileName];
}

@end
