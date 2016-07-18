//
//  DTProgressView.h
//
//  Created by Darktt on 2016/6/14.
//  Copyright © 2016年 Darktt. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef void (^DTProgressDidCompleteHandler) (void);

NS_AVAILABLE_IOS(8.0)
@interface DTProgressView : UIView

@property (assign) CGFloat progress;
@property (assign) BOOL showsText;
@property (copy) DTProgressDidCompleteHandler completeHandler;

/**
 *    Blur effect style for background.
 */
@property (assign, nonatomic) UIBlurEffectStyle blurEffectStyle;

+ (instancetype)progressWithFrame:(CGRect)frame;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (void)setHidden:(BOOL)hidden animation:(BOOL)animation;

@end
NS_ASSUME_NONNULL_END