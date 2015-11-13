//
//  ConnectionUtility.m
//  Lab03
//
//  Created by Milind Mahajan on 11/1/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

#import "ConnectionUtility.h"

@implementation ConnectionUtility


+ (void)getDataFrom:(NSURL *)url onCompletion:(void (^) (NSDictionary *response, NSError *error))onCompletion {
	
	NSURLSession *session = [NSURLSession sharedSession];
	
	[[session dataTaskWithURL:url
			completionHandler:^(NSData *data,
								NSURLResponse *response,
								NSError *error) {
				
				if (error) {
					
					onCompletion(nil, error);
				} else {
					
					NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

					onCompletion(responseDictionary, nil);
				}
			}] resume];
}


@end