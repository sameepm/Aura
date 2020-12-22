//
//  InternetAvailabiltyClass.h
//  Aura
//
//  Created by necixy on 28/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InternetAvailabiltyClass : UIViewController
- (IBAction)onButton:(id)sender;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+(BOOL)checkInternetAvailablity;

@end
