//
//  Building.h
//  Lab03
//
//  Created by Milind Mahajan on 11/5/15.
//  Copyright © 2015 SJSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Building : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *searchStrings;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *tag;

@end