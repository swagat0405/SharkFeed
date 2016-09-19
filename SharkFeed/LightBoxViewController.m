//
//  LightBoxViewController.m
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/16/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import "LightBoxViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/Photos.h>
#import "SharkPhoto.h"
#import "SharkFeedServiceLibrary.h"
#import "PhotoInfo.h"
#import "UnwindLightBoxSegue.h"

@interface LightBoxViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *sharkImageView;
@property (weak, nonatomic) IBOutlet UIView *photoInfoView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *photoInfoLabel;
@property (nonatomic, strong) PhotoInfo *currentPhotoInfo;
@property (nonatomic, strong) UIImage *displayedImage;
@property (weak, nonatomic) IBOutlet UIButton *shareImageButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *originalImageLoadingIndicator;
@property BOOL isInfoViewShowing;
@end

UITapGestureRecognizer *doubleTapGesture;
UITapGestureRecognizer *singleTapGesture;
UIPinchGestureRecognizer *pinchGesture;
typedef void(^setImageFromDataCompletionHandler)(UIImage *sharkImage);

@implementation LightBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addGesturesForPhotoNavigation];
    [self addGesturesForZoomAndPinch];
    [self addGesturesForInfoViewDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchImageForLightBox];
}

#pragma mark <Gesture Recognizer Methods>

- (void)addGesturesForPhotoNavigation {
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showNextPhoto)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showPreviousPhoto)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGesture];

}

- (void)addGesturesForZoomAndPinch {
    
    doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapToScaleImage)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.imageScrollView addGestureRecognizer:doubleTapGesture];
    
    pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapToScaleImage)];
    [self.imageScrollView addGestureRecognizer:pinchGesture];

}

- (void)addGesturesForInfoViewDisplay {
    
    singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showInfoView)];
    singleTapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGesture];
    self.isInfoViewShowing = FALSE;
}

#pragma mark <Image Setup>
- (void)imageForQuality:(SharkPhotoQuality)photoQuality withCompletionHandler:(setImageFromDataCompletionHandler)completionHandler{

    if ([self.originalImageLoadingIndicator isHidden]) {
        [self.originalImageLoadingIndicator setHidden:NO];
        [self.originalImageLoadingIndicator startAnimating];
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SharkPhoto *currentPhoto = self.photosArray[self.currentPhotoIndex.row];
        NSURL *url = [currentPhoto fetchPhotoURLWithQuality:photoQuality];
        NSData *photoData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(image);
        });
        
    });
}

- (void)setInfoViewForCurrentPhoto{
    
    SharkPhoto *currentPhoto = self.photosArray[self.currentPhotoIndex.row];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[self.currentPhotoInfo.getTitle dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(0, attrStr.length)];
    self.photoInfoLabel.text = currentPhoto.title;

}

- (void)fetchImageForLightBox {
    
    [self imageForQuality:SharkPhotoThumbnail withCompletionHandler:^(UIImage *sharkImage) {
        self.sharkImageView.image = sharkImage;
    }];
    
    [self imageForQuality:SharkPhotoOriginal withCompletionHandler:^(UIImage *sharkImage) {
        self.sharkImageView.image = sharkImage;
        if ([self.originalImageLoadingIndicator isAnimating]) {
            [self.originalImageLoadingIndicator stopAnimating];
        }
    }];

    [self setInfoViewForCurrentPhoto];
}

#pragma mark <Gesture Recognizer callbacks>

- (void)showInfoView {
    
    if (!self.isInfoViewShowing) {
        [self.closeButton setHidden:NO];
        [self.shareImageButton setHidden:NO];
        [self.photoInfoView setHidden:NO];
        [self.view bringSubviewToFront:self.closeButton];
        [self.view bringSubviewToFront:self.shareImageButton];
        [self.view bringSubviewToFront:self.photoInfoView];
    }
    else {
        [self.closeButton setHidden:YES];
        [self.shareImageButton setHidden:YES];
        [self.photoInfoView setHidden:YES];
        [self.view sendSubviewToBack:self.closeButton];
        [self.view sendSubviewToBack:self.shareImageButton];
        [self.view sendSubviewToBack:self.photoInfoView];
    }
    self.isInfoViewShowing = !self.isInfoViewShowing;
}

- (void)showNextPhoto {
    
    self.currentPhotoIndex = [NSIndexPath indexPathForRow:  (self.currentPhotoIndex.row+1)==self.photosArray.count ? 0 :(self.currentPhotoIndex.row+1) inSection:self.currentPhotoIndex.section];
    [self fetchImageForLightBox];
}

- (void)showPreviousPhoto {
    
    self.currentPhotoIndex = [NSIndexPath indexPathForRow:(self.currentPhotoIndex.row-1)<0 ? (self.photosArray.count-1) : (self.currentPhotoIndex.row-1) inSection:self.currentPhotoIndex.section];
    [self fetchImageForLightBox];
}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.sharkImageView;
}

- (void)doubleTapToScaleImage {
    
    if (self.imageScrollView.zoomScale > self.imageScrollView.minimumZoomScale)
    {
        [self.imageScrollView setZoomScale:self.imageScrollView.minimumZoomScale animated:YES];
    }
    else
    {
        [self.imageScrollView setZoomScale:self.imageScrollView.maximumZoomScale animated:YES];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"unwindLightBoxSegue"]) {
        ((UnwindLightBoxSegue *)segue).destinationViewFrame = self.selectedCellFrame;
        ((UnwindLightBoxSegue *)segue).imageView = self.sharkImageView;
    }
}

- (IBAction)shareImage:(id)sender {
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[self.sharkImageView.image] applicationActivities:nil];
    [activityController setExcludedActivityTypes:@[UIActivityTypeCopyToPasteboard, UIActivityTypePrint, UIActivityTypeAssignToContact]];
    activityController.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *presentationController = activityController.popoverPresentationController;
    activityController.preferredContentSize = CGSizeMake(500, 100);
    presentationController.sourceView = self.shareImageButton;
    presentationController.sourceRect = self.shareImageButton.bounds;
    [presentationController setPermittedArrowDirections:UIPopoverArrowDirectionAny];
    
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)downloadImage:(id)sender {

    if ([PHPhotoLibrary authorizationStatus]!=PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self saveImage];
        }];
    }
    else {
        [self saveImage];
    }
}

- (void)saveImage {
    
    [self.originalImageLoadingIndicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = self.sharkImageView.image;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            __unused PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                UIAlertController *successAlert = [UIAlertController alertControllerWithTitle:@"Image Saved To Photos" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [successAlert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.originalImageLoadingIndicator isAnimating]) {
                        [self.originalImageLoadingIndicator stopAnimating];
                    }
                    [self showViewController:successAlert sender:nil];
                });
            }
            else {
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Unable to save Photo" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [errorAlert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.originalImageLoadingIndicator isAnimating]) {
                        [self.originalImageLoadingIndicator stopAnimating];
                    }
                    [self showViewController:errorAlert sender:nil];
                });
            }
        }];
    });
}

- (IBAction)openImageInFlickr:(id)sender {
    
    if ([[UIApplication sharedApplication]canOpenURL:[self.photosArray[self.currentPhotoIndex.row] fetchPhotoURLWithQuality:SharkPhotoOriginal]]) {
        [[UIApplication sharedApplication]openURL:[self.photosArray[self.currentPhotoIndex.row] fetchPhotoURLWithQuality:SharkPhotoOriginal]];
    }
}

@end
