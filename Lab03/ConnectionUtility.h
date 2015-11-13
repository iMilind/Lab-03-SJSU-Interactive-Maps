//
//  ConnectionUtility.h
//  Lab03
//
//  Created by Milind Mahajan on 11/1/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectionUtility : NSObject

+ (void)getDataFrom:(NSURL *)url onCompletion:(void (^) (NSDictionary *response, NSError *error))onCompletion;

@end