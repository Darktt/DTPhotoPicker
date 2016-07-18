//
//  DTPhotoPickerController.m
//  DTPhotoPickerController
//
//  Created by Darktt on 16/6/3.
//  Copyright © 2016 Darktt. All rights reserved.
//

#import "DTPhotoPreviewController.h"
#import "PHImageManager+ImageManager.h"
#import "UIImageView+PHAsset.h"

#import "DTPhotoPreviewCell.h"
#import "DTPhotoPickerController.h"

CGSize CGSizeApplyScale(CGSize size, CGFloat scale) {
    
    CGFloat width = size.width * scale;
    CGFloat height = size.height * scale;
    
    return CGSizeMake(width, height);
}

@interface DTPhotoPreviewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) CGSize cellSize;

@property (retain, nonatomic) PHFetchResult *assets;
@property (retain, nonatomic) NSMutableArray<PHAsset *> *selectedAssets;
@property (readonly) DTPhotoPickerController *pickerViewController;

@end

@implementation DTPhotoPreviewController

+ (instancetype)photoPreviewController
{
    DTPhotoPreviewController *photoPreview = [DTPhotoPreviewController new];
    
    return [photoPreview autorelease];
}

#pragma mark Instance Method -
#pragma mark View Live Cycle

- (instancetype)init
{
    self = [super init];
    if (self == nil) return nil;
    
    NSMutableArray<PHAsset *> *selectedAssets = [NSMutableArray arrayWithCapacity:0];
    [self setSelectedAssets:selectedAssets];
    
    [self setCellSize:CGSizeZero];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *title = NSLocalizedString(@"Photo Picker", @"");
    [self setTitle:title];
    
    if (self.popoverPresentationController == nil) {
        NSString *dismissTitle = NSLocalizedString(@"Dissmiss", @"");
        UIBarButtonItem *barbuttonItem = [[UIBarButtonItem alloc] initWithTitle:dismissTitle style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction:)];
        
        [self.navigationItem setLeftBarButtonItem:barbuttonItem];
        [barbuttonItem release];
    }
    
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout new] autorelease];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        Class cellClass = [DTPhotoPreviewCell class];
        NSString *cellIdentifier = [DTPhotoPreviewCell cellIdentifier];
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:cellIdentifier];
        [collectionView setBackgroundColor:nil];
        [collectionView setAllowsSelection:YES];
        [collectionView setAllowsMultipleSelection:YES];
        [collectionView setDataSource:self];
        [collectionView setDelegate:self];
        
        UIColor *backgroundColor = [UIColor whiteColor];
        
        [self setCollectionView:collectionView];
        [self.view addSubview:collectionView];
        [self.view setBackgroundColor:backgroundColor];
        
        [collectionView release];
    }
    
    void (^handler) (PHAuthorizationStatus) = ^(PHAuthorizationStatus status) {
        
        if (status != PHAuthorizationStatusAuthorized) {
            
            [self.collectionView setHidden:YES];
            return;
        }
        
        [self fetchAssets];
    };
    
    [self checkAuthorization:handler];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect frame = self.view.bounds;
    [self.collectionView setFrame:frame];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationNone;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)dealloc
{
    [self setAssets:nil];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Override Property

- (DTPhotoPickerController *)pickerViewController
{
    return (DTPhotoPickerController *)self.navigationController;
}

#pragma mark - Actions

- (void)dismissAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)applySelectionAction:(UIBarButtonItem *)sender
{
    [sender setEnabled:NO];
    
    if (self.mediaType == PHAssetMediaTypeImage) {
        
        [self startFetchImages];
        
        return;
    }
    
    [self startFetchVideoPaths];
}

#pragma mark - Private Methods

- (void)checkAuthorization:(void (^) (PHAuthorizationStatus status))handler
{
    void (^requestHandler) (PHAuthorizationStatus) = ^(PHAuthorizationStatus status) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            handler(status);
        }];
    };
    
    [PHPhotoLibrary requestAuthorization:requestHandler];
}

- (void)fetchAssets
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.mediaType == %i", self.mediaType];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES];
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions new] autorelease];
    [fetchOptions setPredicate:predicate];
    [fetchOptions setSortDescriptors:@[sortDescriptor]];
    [fetchOptions setIncludeAssetSourceTypes:self.sourceType];
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    [self setAssets:fetchResult];
    
    [self.collectionView reloadData];
}

- (void)updateSelectedItemWithCount:(NSInteger)count
{
    if (count <= 0) {
        
        [self.navigationItem setRightBarButtonItem:nil];
        return;
    }
    
    NSString *format = NSLocalizedString(@"Selected(%zd)", @"");
    NSString *selectedTitle = [NSString stringWithFormat:format, count];
    UIBarButtonItem *selectedItem = [[UIBarButtonItem alloc] initWithTitle:selectedTitle style:UIBarButtonItemStyleDone target:self action:@selector(applySelectionAction:)];
    
    [self.navigationItem setRightBarButtonItem:selectedItem];
    [selectedItem release];
}

- (CGSize)imageLimitSizeForAsset:(PHAsset *)asset
{
    CGFloat maximumSide = MAX(asset.pixelWidth, asset.pixelHeight);
    CGFloat maximumFetchedSide = MAX(self.fetchedLimitSize.width, self.fetchedLimitSize.height);
    CGSize imageSize = CGSizeZero;
    
    if (maximumSide > maximumFetchedSide) {
        imageSize = self.fetchedLimitSize;
    } else {
        imageSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    }
    
    return imageSize;
}

- (void)startFetchImages
{
    NSMutableArray<UIImage *> *fetchedImages = [NSMutableArray arrayWithCapacity:0];
    
    [self fetchImagesWithIndex:0 assets:self.selectedAssets collector:fetchedImages];
}

- (void)fetchImagesWithIndex:(NSInteger)index assets:(NSArray<PHAsset *> *)assets collector:(NSMutableArray<UIImage *> *)imageCollector
{
    if (index == assets.count) {
        
        DTPhotoPickerController *pickerViewController = self.pickerViewController;
        BOOL responds = [pickerViewController.delegate respondsToSelector:@selector(picker:didPickedImages:)];
        
        if (responds) {
            [pickerViewController.delegate picker:pickerViewController didPickedImages:imageCollector];
        }
        
        return;
    }
    
    PHAsset *asset = assets[index];
    
    void (^result) (UIImage *) = ^(UIImage *image) {
        
        if (image != nil) {
            [imageCollector addObject:image];
        }
        
        NSInteger nextIndex = index + 1;
        [self fetchImagesWithIndex:nextIndex assets:assets collector:imageCollector];
    };
    
    [self fetchImageWithAsset:asset result:result];
}

- (void)fetchImageWithAsset:(PHAsset *)asset result:(void (^) (UIImage *image))result
{
    CGSize imageSize = [self imageLimitSizeForAsset:asset];
    
    UICollectionView *collectionView = self.collectionView;
    
    PHAssetImageProgressHandler progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        
        if (error) {
            NSLog(@"Process image from asset error, reason: %@", error.localizedDescription);
            return;
        }
        
        NSInteger index = [self.assets indexOfObject:asset];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
        DTPhotoPreviewCell *cell = (DTPhotoPreviewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        // Update progress when cell exist.
        if (cell != nil) {
            [cell setShowsDownloadProgress:YES];
            [cell setProgress:progress];
        }
        
        NSLog(@"Progress: %.0f", progress * 100.0f);
        NSLog(@"Info: %@", info);
    };
    
    PHImageManagerFetchImageResultHandler resultHandler = ^(UIImage *image, NSError *error) {
        
        if (error) {
            
            NSLog(@"Fetch image from asset error, reason: %@", error.localizedDescription);
            result(nil);
            return;
        }
        
        result(image);
    };
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager imageWithAsset:asset limitSize:imageSize progressHandler:progressHandler result:resultHandler];
}

- (void)startFetchVideoPaths
{
    NSMutableArray<NSString *> *fetchedVideoPaths = [NSMutableArray arrayWithCapacity:0];
    
    [self fetchVideoPathsWithIndex:0 assets:self.selectedAssets collector:fetchedVideoPaths];
}

- (void)fetchVideoPathsWithIndex:(NSInteger)index assets:(NSArray<PHAsset *> *)assets collector:(NSMutableArray<NSString *> *)videoPathCollector
{
    if (index == assets.count) {
        
        DTPhotoPickerController *pickerViewController = self.pickerViewController;
        BOOL responds = [pickerViewController.delegate respondsToSelector:@selector(picker:didPickedVideoPaths:)];
        
        if (responds) {
            [pickerViewController.delegate picker:pickerViewController didPickedVideoPaths:videoPathCollector];
        }
        
        return;
    }
    
    PHAsset *asset = assets[index];
    
    void (^result) (NSString *) = ^(NSString *path) {
        
        if (path != nil) {
            [videoPathCollector addObject:path];
        }
        
        NSInteger nextIndex = index + 1;
        [self fetchVideoPathsWithIndex:nextIndex assets:self.selectedAssets collector:videoPathCollector];
    };
    
    [self fetchVideoPathForAsset:asset result:result];
}

- (void)fetchVideoPathForAsset:(PHAsset *)asset result:(void (^) (NSString *path))result
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [DTPhotoPreviewCell cellIdentifier];
    NSInteger index = indexPath.item;
    PHAsset *asset = self.assets[index];
    BOOL selected = [self.selectedAssets containsObject:asset];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize imageSize = CGSizeApplyScale(self.cellSize, scale);
    
    DTPhotoPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView setImageWithAsset:asset forImageSize:imageSize];
    [cell setSelected:selected];
    
    if (selected) {
        index = [self.selectedAssets indexOfObject:asset] + 1;
        
        [cell setSelectionCount:index];
        
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedAssets.count == self.numberOfAssetsFetched) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        return;
    }
    
    NSInteger index = indexPath.item;
    PHAsset *asset = self.assets[index];
    
    [self.selectedAssets addObject:asset];
    
    NSInteger count = self.selectedAssets.count;
    [self updateSelectedItemWithCount:count];
    
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    PHAsset *asset = self.assets[index];
    
    if ([self.selectedAssets containsObject:asset]) {
        [self.selectedAssets removeObject:asset];
    }
    
    NSInteger count = self.selectedAssets.count;
    [self updateSelectedItemWithCount:count];
    
    [collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!CGSizeEqualToSize(self.cellSize, CGSizeZero)) {
        
        return self.cellSize;
    }
    
    CGRect frame = collectionView.bounds;
    CGSize size = frame.size;
    
    CGFloat width = (size.width - 2.0f) / 3.0f;
    CGSize cellSize = CGSizeMake(width, width);
    
    [self setCellSize:cellSize];
    
    return cellSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

@end
