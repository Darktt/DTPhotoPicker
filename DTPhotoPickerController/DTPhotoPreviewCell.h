//
//  DTPhotoPreviewCell.h
//
//  Created by Darktt on 16/6/3.
//  Copyright © 2016 Darktt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface DTPhotoPreviewCell : UICollectionViewCell

@property (readonly) UIImageView *imageView;
@property (retain, nonatomic) UIColor *selectedColor;

+ (NSString *)cellIdentifier;

- (void)setSelectionCount:(NSInteger)count;

@end
NS_ASSUME_NONNULL_END