//
//  MYLoadImageOperation.m
//  MYWebImage
//
//  Created by 刘家强 on 16/7/31.
//  Copyright © 2016年 刘家强. All rights reserved.
//

#import "MYLoadImageOperation.h"

@interface MYLoadImageOperation ()

@property (nonatomic, copy) NSString *urlString;

@end

@implementation MYLoadImageOperation

+ (instancetype)operationWithUrlString:(NSString *)urlString {
    
    // 初始化
    MYLoadImageOperation *op = [self new];

    // 给内容赋值
    op.urlString = urlString;
    
    // 返回
    return op;
}

- (void)main {

    // 获取url
    NSURL *url = [NSURL URLWithString:self.urlString];

    // 获取data
    NSData *data = [NSData dataWithContentsOfURL:url];

    // 写入到沙盒中
    [data writeToFile:[self sanBoxWithStr:self.urlString] atomically:YES];
    
    // 获取到UIImage
    self.image = [UIImage imageWithData:data];
    
}

- (NSString *)sanBoxWithStr:(NSString *)str {
    
    // 获取last
    NSString *lastPath = [str lastPathComponent];
    
    // 获取系统缓存路径
    NSString *fristPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    // 拼接并返回
    return [fristPath stringByAppendingPathComponent:lastPath];
}

@end
