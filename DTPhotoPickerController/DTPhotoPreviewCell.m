//
//  DTPhotoPreviewCell.m
//
//  Created by Darktt on 16/6/3.
//  Copyright © 2016 Darktt. All rights reserved.
//

#import "DTPhotoPreviewCell.h"
#import "DTProgressView.h"

@interface DTPhotoPreviewCell ()

@property (assign, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) DTProgressView *progressView;
@property (assign, nonatomic) UIView *selectionView;
@property (assign, nonatomic) UILabel *selectionLabel;

@end

@implementation DTPhotoPreviewCell

+ (NSString *)cellIdentifier
{
    static NSString *const CellIdentifier = @"PhotoPreviewCell";
    
    return CellIdentifier;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    UIColor *selectedColor = [UIColor colorWithRed:0.0f green:122.0f/255.0f blue:1.0f alpha:1.0f];
    [self setSelectedColor:selectedColor];
    [self addObserver:self forKeyPath:@"selectedColor" options:NSKeyValueObservingOptionNew context:nil];
    
    CGRect bounds = self.bounds;
    
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self setImageView:imageView];
        [self.contentView addSubview:imageView];
        [imageView release];
    }
    
    {
        DTProgressView *progressView = [DTProgressView progressWithFrame:bounds];
        [progressView setShowsText:YES];
        [progressView setHidden:YES];
        
        [self setProgressView:progressView];
        [self.contentView addSubview:progressView];
    }
    
    {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        [view setBackgroundColor:nil];
        [view setHidden:YES];
        
        [view.layer setBorderColor:self.selectedColor.CGColor];
        [view.layer setBorderWidth:2.0f];
        [view.layer setMasksToBounds:YES];
        
        [self setSelectionView:view];
        [self.contentView addSubview:view];
        [view release];
    }
    
    {
        UIColor *textColor = [UIColor whiteColor];
        CGRect rect = CGRectMake(0.0f, 0.0f, 25.0f, 25.0f);
        
        UILabel *selectionLabel = [[UILabel alloc] initWithFrame:rect];
        [selectionLabel setTextColor:textColor];
        [selectionLabel setTextAlignment:NSTextAlignmentCenter];
        [selectionLabel setBackgroundColor:self.selectedColor];
        
        [self setSelectionLabel:selectionLabel];
        [self.selectionView addSubview:selectionLabel];
        [selectionLabel release];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    
    [self.imageView setFrame:self.bounds];
    
    CGRect labelFrame = self.selectionLabel.frame;
    CGFloat width = CGRectGetWidth(labelFrame);
    CGFloat height = CGRectGetHeight(labelFrame);
    
    CGFloat maximumSide = MAX(width, height);
    
    labelFrame.size = CGSizeMake(maximumSide, maximumSide);
    labelFrame.origin = (CGPoint) {
        .x = CGRectGetMaxX(bounds) - CGRectGetWidth(labelFrame) - 5.0f,
        .y = 5.0f
    };
    
    [self.selectionLabel setFrame:labelFrame];
    [self.selectionLabel.layer setCornerRadius:maximumSide / 2.0f];
    [self.selectionLabel.layer setMasksToBounds:YES];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"selectedColor"];
    [super dealloc];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setSelected:NO];
    [self setSelectionCount:0];
    [self.imageView setImage:nil];
    [self.progressView setHidden:YES];
    [self.selectionView setHidden:YES];
}

#pragma mark - Public Methods

- (void)setSelectionCount:(NSInteger)count
{
    if (!self.selected) {
        return;
    }
    
    NSString *text = [NSString stringWithFormat:@"%zd", count];
    
    [self.selectionLabel setText:text];
}

#pragma mark - Override Method

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self.selectionView setHidden:!selected];
}

- (void)setShowsDownloadProgress:(BOOL)showsDownloadProgress
{
    [self.progressView setHidden:!showsDownloadProgress animation:YES];
}

- (BOOL)showsDownloadProgress
{
    return !self.progressView.hidden;
}

- (void)setProgress:(CGFloat)progress
{
    [self.progressView setProgress:progress];
}

- (CGFloat)progress
{
    return self.progressView.progress;
}

#pragma mark - Key Value Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:@"selectedColor"]) {
        return;
    }
    
    UIColor *selectedColor = change[NSKeyValueChangeNewKey];
    [self.selectionLabel setBackgroundColor:selectedColor];
    [self.selectionView.layer setBorderColor:selectedColor.CGColor];
}

@end
