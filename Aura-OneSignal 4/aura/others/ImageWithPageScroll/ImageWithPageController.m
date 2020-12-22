//
//  ImageWithPageController.m
//  Aura
//
//  Created by Apple on 28/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

#import "ImageWithPageController.h"
#import "AsyncImageView.h"

@interface ImageWithPageController ()
 
@end

@implementation ImageWithPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btnShare.layer.cornerRadius = 5;
    btnShare.layer.masksToBounds = true;

    
      CGRect innerScrollFrame = scrlView.bounds;
    int x = 0 ;
    
    for (int i = 0 ; i < self.arrayData.count; i++) {
        
        if ([UIScreen mainScreen].bounds.size.height >500) {
                   imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320 , self.view.frame.size.height-94)];
        }
        else{
             imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 320 , 386)];
        }
        imgView.tag = i+1;
       // imgView.backgroundColor = [UIColor whiteColor];
        NSString *imgString;
        if (self.isComeFromDash == true) {
            NSDictionary *dict = [self.arrayData objectAtIndex:i];
            imgString = [dict objectForKey:@"data"];
            _scrollToPage = 0;
        }
        else{
             imgString =[NSString stringWithFormat:@"%@", [[self.arrayData objectAtIndex:i] objectForKey:@"picture_thumb"]];
        }
       // imgView.backgroundColor = [UIColor redColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit       ;
        imgView.image = [UIImage imageNamed:@"PlaceholderDown"];
        
        //load the image
        imgView.imageURL = [NSURL URLWithString:imgString];
      
        UIScrollView *pageScrollView = [[UIScrollView alloc] initWithFrame:innerScrollFrame];
        pageScrollView.minimumZoomScale = 1.0f;
        pageScrollView.maximumZoomScale = 2.0f;
        pageScrollView.zoomScale = 1.0f;
        pageScrollView.contentSize = imgView.bounds.size;
        pageScrollView.delegate = self;
    
        pageScrollView.showsHorizontalScrollIndicator = NO;
        pageScrollView.showsVerticalScrollIndicator = NO;
        [pageScrollView addSubview:imgView];
        
        [scrlView addSubview:pageScrollView];
        
        if (i < self.arrayData.count) {
            innerScrollFrame.origin.x += innerScrollFrame.size.width;
        }
              x = x + self.view.frame.size.width ;
      
    }
    scrlView.minimumZoomScale = 1.0;
    scrlView.maximumZoomScale = 5.0;
    UILabel *lblMsg = [[UILabel alloc]initWithFrame:CGRectMake(10, imgView.frame.size.height - 30, 300, 30)];
    lblMsg.text = @"Tap to image for Zoom.";
    lblMsg.textAlignment = NSTextAlignmentCenter;
    lblMsg.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    //[imgView addSubview:lblMsg];
    
    scrlView.delegate = self;
    pageController.numberOfPages = self.arrayData.count;
   
    scrlView.contentSize = CGSizeMake(innerScrollFrame.origin.x -320 +
                                            innerScrollFrame.size.width, scrlView.bounds.size.height);
     [scrlView setContentOffset:CGPointMake([_scrollToPage intValue]*320, 0) animated:YES];
    // Do any additional setup after loading the view from its nib.
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIImageView *imageView = (UIImageView *)[scrlView viewWithTag:(int)pageController.currentPage + 1];
    return imageView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (!pageControlBeingUsed) {
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = scrlView.frame.size.width;
        int page = floor((scrlView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        pageController.currentPage = page;
        
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview
{
    pageControlBeingUsed = NO;
    scrollpage = scrlView.contentOffset.x / scrlView.frame.size.width;

}


- (IBAction)onCloseButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
