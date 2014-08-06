//
//  ProductsCache.h
//  Recycode
//
//  Created by Angel Genov on 1/12/14.
//  Copyright (c) 2014 recycode. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductsCache : NSObject

+ (ProductsCache*)sharedInstance;
-(int)storeBarcode:(NSString*) barcode Description:(NSString*)desc Brand:(NSString*)brand Code:(NSString*)code Picture:(NSString*)pic;
-(NSString*)getBarcode:(NSString*) barcode;
- (void)save;
@end
