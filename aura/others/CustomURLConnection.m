//
//  CustomURLConnection.m
//  PrimeHangout
//
//  Created by nikhil on 11/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomURLConnection.h"


@implementation CustomURLConnection

@synthesize tag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate startImmediately:(BOOL)startImmediately tag:(NSString*)urlTag {
	self = [super initWithRequest:request delegate:delegate startImmediately:startImmediately];
	
	if (self) {
		self.tag = urlTag;
	}
	return self;
}

//- (void)dealloc {
//	[tag release];
//	[super dealloc];
//}

@end
