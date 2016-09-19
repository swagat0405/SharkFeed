//
//  SharkFeedCollectionViewController.m
//  SharkFeed
//
//  Created by Mishra, Swagat on 9/15/16.
//  Copyright © 2016 SM. All rights reserved.
//

#import "SharkFeedCollectionViewController.h"
#import "SharkPhotosCollectionViewCell.h"
#import "SharkFeedServiceLibrary.h"
#import "LightBoxViewController.h"
#import "SharkPhoto.h"
#import "LightBoxSegue.h"
#import "UnwindLightBoxSegue.h"

@interface SharkFeedCollectionViewController ()

@property (nonatomic, strong) NSMutableArray    *photosArray;
@property int pageNumber;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property BOOL isFetchingImages;
@property (nonatomic, strong)UIRefreshControl *refreshControl;
@end

@implementation SharkFeedCollectionViewController

static NSString * const reuseIdentifier = @"SharkImagesCell";
NSIndexPath *selectedImageIndex;

//Lazily instantiate the photosArray object.
- (NSMutableArray *)photosArray {
    
    if (!_photosArray) {
        _photosArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _photosArray;
}

- (UIActivityIndicatorView *)activityIndicator {
    
    if (!_activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = self.view.center;
    }
    return _activityIndicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.collectionView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background"]];
    
    self.pageNumber = 0;
    
    [self customizeNavigationBar];
    
    [self createCustomPullToRefreshControl];
    
    //Display loading indicator for initial data fetch
    if (![self.activityIndicator isAnimating]) {
        [self startLoading];
    }
    [self fetchPhotosFromFlickr];

}

- (void)customizeNavigationBar {
    
    UIView *navigationBarView = [[NSBundle mainBundle]loadNibNamed:@"NavigationBarView" owner:self options:0][0];
    navigationBarView.frame = self.navigationController.navigationBar.bounds;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.titleView = navigationBarView;
}

- (void)fetchPhotosFromFlickr {
    
    self.isFetchingImages = YES;
    self.pageNumber++;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SharkFeedServiceLibrary sharedInstance]fetchPhotosFromFlickrForPage:[NSString stringWithFormat:@"%d",self.pageNumber] completionHandler:^(NSArray *sharkPhotoUrlsArray) {
            [self.photosArray addObjectsFromArray: sharkPhotoUrlsArray];
            self.isFetchingImages = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.activityIndicator isAnimating]) {
                    [self stopLoading];
                }
                if ([self.refreshControl isRefreshing]) {
                    [self.refreshControl endRefreshing];
                }
                [self.collectionView reloadData];
            });
        }];
    });
}

- (void)startLoading {
    [self.collectionView setUserInteractionEnabled:FALSE];
    [self.collectionView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];

}

- (void)stopLoading {
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
    [self.collectionView setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <PullToRefresh>
- (void)createCustomPullToRefreshControl {
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    
    [self.refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.collectionView addSubview:self.refreshControl];
}

- (void)pullToRefresh {
    
    double delay = 2.0;
    dispatch_time_t dismissTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(dismissTime, dispatch_get_main_queue(), ^(void){
        self.pageNumber = 0;
        [self fetchPhotosFromFlickr];
    });
}


#pragma mark <Navigation>

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier]isEqualToString:@"showDetailPhotoSegue"]) {
        
        //Set destination controller params
        LightBoxViewController *lightBoxVC = segue.destinationViewController;
        lightBoxVC.currentPhotoIndex = selectedImageIndex;
        lightBoxVC.photosArray = self.photosArray;
        SharkPhotosCollectionViewCell *selectedCell = (SharkPhotosCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:selectedImageIndex];
        lightBoxVC.selectedCellFrame = selectedCell.frame;
        
        //Set Segue Params
        ((LightBoxSegue *)segue).sourceView = selectedCell;
        ((LightBoxSegue *)segue).imageView = selectedCell.contentView;
    }
}

- (IBAction)unwindFromLightBoxSegue:(UIStoryboardSegue *)segue {
    //For unwinding from segue
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    
    return [[UnwindLightBoxSegue alloc]initWithIdentifier:identifier source:fromViewController destination:toViewController];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SharkPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [(SharkPhoto *)_photosArray[indexPath.row] fetchPhotoURLWithQuality:SharkPhotoThumbnail];
        NSData *photoData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:photoData];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.photosImageView.image = image;
        });

    });
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedImageIndex = indexPath;
    [self performSegueWithIdentifier:@"showDetailPhotoSegue" sender:self];
}

#pragma mark <ScrollView Delegates>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //Fetch data as scroll nears the end of collection
    if (scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height - 500) {
        
        if (!self.isFetchingImages) {
            [self fetchPhotosFromFlickr];
        }
    }
}
@end
