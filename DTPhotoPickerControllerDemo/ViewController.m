//
//  ViewController.m
//  DTPhotoPickerController
//
//  Created by EdenLi on 2016/6/3.
//  Copyright © 2016年 Darktt. All rights reserved.
//

#import "ViewController.h"

#import "DTPhotoPickerController.h"

@interface ViewController () <DTPhotoPickerControllerDelegate>

- (IBAction)pickPhotoAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickPhotoAction:(id)sender
{
    DTPhotoPickerController *photoPickerController = [DTPhotoPickerController photoPickerControllerWithDelegate:self];
    [photoPickerController setMediaType:PHAssetMediaTypeImage];
    [photoPickerController setSourceType:PHAssetSourceTypeUserLibrary];
    [photoPickerController setNumberOfAssetsFetched:4];
    
    [self presentViewController:photoPickerController animated:YES completion:nil];
}

- (void)picker:(DTPhotoPickerController *)picker didPickedImages:(NSArray<UIImage *> *)images
{
    NSLog(@"Images: %@", images);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
