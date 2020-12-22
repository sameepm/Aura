//
//  CustomURLConnection.h
//  PrimeHangout
//
//  Created by nikhil on 11/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomURLConnection : NSURLConnection {
	NSString *tag;
}

@property (nonatomic, retain) NSString *tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSString*)urlTag;

@end