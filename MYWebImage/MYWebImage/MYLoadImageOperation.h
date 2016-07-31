//
//  MYLoadImageOperation.h
//  MYWebImage
//
//  Created by 刘家强 on 16/7/31.
//  Copyright © 2016年 刘家强. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYLoadImageOperation : NSOperation

@property (nonatomic, strong) UIImage *image;

+ (instancetype)operationWithUrlString:(NSString *)urlString;

@end
