//
//  UnknownViewController.h
//  Recycode
//
//  Created by Angel Genov on 11/25/13.
//  Copyright (c) 2013 recycode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnknownViewController : UIViewController
- (void)takePicture;
@property(copy,nonatomic) NSString * barCode;
@property(copy,nonatomic) NSData * pictureData;
@property(assign,nonatomic) BOOL picture;
@end

