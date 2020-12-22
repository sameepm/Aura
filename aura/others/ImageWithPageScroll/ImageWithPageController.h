//
//  ImageWithPageController.h
//  Aura
//
//  Created by Apple on 28/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareMoodViewController;
@interface ImageWithPageController : UIViewController < UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
      BOOL pageControlBeingUsed;
    IBOutlet UIButton *btnShare;
    int scrollpage;
    __weak IBOutlet UIPageControl *pageController;
    __weak IBOutlet UIScrollView *scrlView;
   
    UIImageView *imgView;
    ShareMoodViewController *shareVC;
}
@property(nonatomic,strong) NSArray *arrayData ;
@property(nonatomic)BOOL isComeFromDash;
@property(nonatomic,strong) NSString * scrollToPage;
- (IBAction)onCloseButton:(id)sender;
- (IBAction)shareWithFriends:(id)sender;

@end
