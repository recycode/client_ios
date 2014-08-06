//
//  ProductsCache.m
//  Recycode
//
//  Created by Angel Genov on 1/12/14.
//  Copyright (c) 2014 recycode. All rights reserved.
//

#import "ProductsCache.h"

@interface ProductsCache() {
    NSMutableDictionary * _data;
}

@end

@implementation ProductsCache

+ (ProductsCache*)sharedInstance
{
    static ProductsCache * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentDirectory = [documentDirectories objectAtIndex:0];
        NSString * fileName = [documentDirectory stringByAppendingPathComponent:@"products.dat"];
        
        
        _data = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
        
        if(!_data) {
            _data = [[NSMutableDictionary alloc] init];
        }
    }
    
    return self;
}

- (void)save
{
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    NSString * fileName = [documentDirectory stringByAppendingPathComponent:@"products.dat"];
    
    [NSKeyedArchiver archiveRootObject:_data toFile:fileName];
}

-(int)storeBarcode:(NSString*) barcode Description:(NSString*)desc Brand:(NSString*)brand Code:(NSString*)code Picture:(NSString*)pic
{
    NSString *t = [NSString stringWithFormat:@"%@,%@,%@,%@",desc,brand,code,pic];
    [_data setObject:t forKey:barcode];
    
    return  0;
}

-(NSString*)getBarcode:(NSString*) barcode
{
    return [_data objectForKey:barcode];
}

@end
