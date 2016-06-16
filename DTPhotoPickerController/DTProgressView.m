//
//  DTProgressView.m
//
//  Created by Darktt on 2016/6/14.
//  Copyright © 2016年 Darktt. All rights reserved.
//

#import "DTProgressView.h"

#pragma mark - DTInnerProgressView

@interface DTInnerProgressView : UIView
{
    @private
    CAShapeLayer *_shapeLayer;
}

@property (nonatomic, assign) CGFloat progress;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGLineCap lineCapStyle;
@property (assign, nonatomic) CGFloat radius;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end

@implementation DTInnerProgressView

- (instancetype)init
{
    self = [super init];
    if (self == nil) return nil;
    
    UIColor *backgroundColor = [UIColor clearColor];
    [self setBackgroundColor:backgroundColor];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupLayer];
}

#pragma mark - Public Method

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    _progress = progress;
    
    [self updateLayerWithAnimated:animated];
}

#pragma mark - Override Property

- (void)setProgress:(CGFloat)progress
{
    [self setProgress:progress animated:NO];
}

#pragma mark - Private Methods

- (CGPathRef)progressPath
{
    CGRect rect = self.bounds;
    
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = self.radius;
    CGFloat startAngle = - M_PI_2; // 90 degrees
    CGFloat endAngle = (2.0f * M_PI) + startAngle;
    
    // Draw progress
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    return progressPath.CGPath;
}

- (NSString *)lineCap
{
    CGLineCap lineCapStyle = self.lineCapStyle;
    NSString *lineCap = nil;
    
    switch (lineCapStyle) {
        case kCGLineCapButt:
            lineCap = @"butt";
            break;
            
        case kCGLineCapRound:
            lineCap = @"round";
            break;
            
        case kCGLineCapSquare:
            lineCap = @"square";
            break;
            
        default:
            lineCap = @"round";
            break;
    }
    
    return lineCap;
}

- (void)setupLayer
{
    if (_shapeLayer == nil) {
        _shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_shapeLayer];
    }
    
    CGPathRef path = [self progressPath];
    CGFloat lineWidth = self.lineWidth;
    NSString *lineCap = [self lineCap];
    UIColor *tintColor = [UIColor whiteColor];
    
    [_shapeLayer setPath:path];
    [_shapeLayer setFillColor:nil];
    [_shapeLayer setStrokeColor:tintColor.CGColor];
    [_shapeLayer setLineWidth:lineWidth];
    [_shapeLayer setLineCap:lineCap];
    [_shapeLayer setFrame:self.bounds];
    [_shapeLayer setFillRule:kCAFillRuleEvenOdd];
    [_shapeLayer setStrokeEnd:self.progress];
}

- (void)updateLayerWithAnimated:(BOOL)animated
{
    if (!animated) {
        
        [_shapeLayer setStrokeEnd:self.progress];
        
        return;
    }
    
    CGFloat fromProgress = _shapeLayer.strokeEnd;
    CGFloat toProgress = self.progress;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [animation setFromValue:@(fromProgress)];
    [animation setToValue:@(toProgress)];
    [animation setByValue:@(toProgress)];
    [animation setDuration:0.25f];
    [animation setRemovedOnCompletion:NO];
    [animation setDelegate:self];
    
    [_shapeLayer addAnimation:animation forKey:@"animation"];
}

#pragma mark - Delegate Methods -

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag) {
        return;
    }
    
    [_shapeLayer setStrokeEnd:self.progress];
    [_shapeLayer removeAllAnimations];
}

@end

#pragma mark - DTProgressView

@interface DTProgressView ()

@property (assign, nonatomic) UIVisualEffectView *backgroundView;
@property (assign, nonatomic) DTInnerProgressView *innerProgressView;
@property (assign, nonatomic) UILabel *percentageLabel;

@end

@implementation DTProgressView

+ (instancetype)progressWithFrame:(CGRect)frame
{
    DTProgressView *progressView = [[DTProgressView alloc] initWithFrame:frame];
    
    return [progressView autorelease];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    [self setupProperties];
    [self setupSubviews];
    [self setupKVO];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    [self.backgroundView setFrame:bounds];
    [self.innerProgressView setFrame:bounds];
}

- (void)dealloc
{
    [self removeKVO];
    
    [super dealloc];
}

#pragma mark - Public Methods

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (progress < 0.0f) {
        progress = 0.0;
    }
    
    if (progress > 1.0f) {
        progress = 1.0f;
    }
    
    [self.innerProgressView setProgress:progress animated:animated];
    
    NSString *percentage = [NSString stringWithFormat:@"%.0f%%", progress * 100];
    
    [self.percentageLabel setText:percentage];
    
    if (progress >= 1.0f) {
        
        if (self.completeHandler != nil) self.completeHandler();
    }
}

- (void)setHidden:(BOOL)hidden animation:(BOOL)animation
{
    if (self.hidden == hidden) {
        return;
    }
    
    if (!animation) {
        
        [self setHidden:hidden];
        
        return;
    }
    
    void (^animations) (void) = nil;
    void (^completion) (BOOL) = nil;
    
    if (hidden) {
        
        animations = ^{
            [self setAlpha:0.0f];
        };
        
        completion = ^(BOOL finish) {
            [self setAlpha:1.0f];
            [self setHidden:YES];
        };
    } else {
        
        [self setAlpha:0.0f];
        [self setHidden:NO];
        
        animations = ^{
            [self setAlpha:1.0f];
        };
    }
    
    [UIView animateWithDuration:0.25f animations:animations completion:completion];
}

#pragma mark - Override Property

- (void)setShowsText:(BOOL)showsText
{
    [self.percentageLabel setHidden:!showsText];
}

- (BOOL)showsText
{
    return !self.percentageLabel.hidden;
}

#pragma mark - Private Methods

- (void)setupProperties
{
    [self setProgress:0.0f];
    [self setShowsText:NO];
    [self setBlurEffectStyle:UIBlurEffectStyleLight];
    [self setTintColor:nil];
    [self setBackgroundColor:nil];
}

- (UIBlurEffect *)blurEffect
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
    
    return blurEffect;
}

- (void)setupSubviews
{
    CGRect frame = self.bounds;
    
    UILabel *percentageLabel = [[UILabel alloc] initWithFrame:frame];
    [percentageLabel setText:@"0%"];
    [percentageLabel setTextAlignment:NSTextAlignmentCenter];
    [percentageLabel setHidden:YES];
    
    DTInnerProgressView *innerProgressView = [[DTInnerProgressView alloc] initWithFrame:frame];
    [innerProgressView setLineWidth:5.0f];
    [innerProgressView setLineCapStyle:kCGLineCapRound];
    [innerProgressView setRadius:40.0f];
    
    UIBlurEffect *blurEffect = [self blurEffect];
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    [vibrancyView setFrame:frame];
    [vibrancyView.contentView addSubview:percentageLabel];
    [vibrancyView.contentView addSubview:innerProgressView];
    
    [self setPercentageLabel:percentageLabel];
    [self setInnerProgressView:innerProgressView];
    
    [percentageLabel release];
    [innerProgressView release];
    
    UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [backgroundView setFrame:frame];
    [backgroundView.contentView addSubview:vibrancyView];
    [vibrancyView release];
    
    [self setBackgroundView:backgroundView];
    [self addSubview:backgroundView];
    [backgroundView release];
}

- (void)updateVisualEffect
{
    UIBlurEffect *blurEffect = [self blurEffect];
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyView = self.backgroundView.contentView.subviews.firstObject;
    [vibrancyView setEffect:vibrancyEffect];
    
    [self.backgroundView setEffect:blurEffect];
}

- (void)setupKVO
{
    [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"blurEffectStyle" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO
{
    [self removeObserver:self forKeyPath:@"progress" context:nil];
    [self removeObserver:self forKeyPath:@"blurEffectStyle" context:nil];
}

#pragma mark - Key Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    // Fix the progress range is 0 to 1.
    if ([keyPath isEqualToString:@"progress"]) {
        [self.innerProgressView setProgress:self.progress];
        
        if (self.progress >= 1.0f) {
            
            if (self.completeHandler != nil) self.completeHandler();
        }
    }
    
    if (![keyPath isEqualToString:@"blurEffectStyle"]) {
        return;
    }
    
    void (^animations) (void) = ^{
        [self updateVisualEffect];
    };
    
    [UIView animateWithDuration:0.25f animations:animations];
}

@end
