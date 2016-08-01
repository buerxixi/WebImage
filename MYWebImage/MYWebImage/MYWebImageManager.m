//
//  MYWebImageManager.m
//  MYWebImage
//
//  Created by 刘家强 on 16/7/31..
//  Copyright © 2016年 刘家强. All rights reserved.
//

#import "MYLoadImageOperation.h"
#import "MYWebImageManager.h"

@interface MYWebImageManager ()

@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *imagesDict;
@property (nonatomic, strong) NSMutableDictionary *opDict;

@end

@implementation MYWebImageManager

+ (instancetype)sharedWebImageManager {
    // 静态区
    static id instance;

    // 执行一次方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        // 初始化
        instance = [[self alloc] init];

    });

    // 返回
    return instance;
}

- (void)loadWebImageUrlString:(NSString *)urlString andReturnBlock:(void (^)(UIImage *image))complete {
    // 禁止非法操作(断言)
    NSAssert(complete == nil, @"回调不能为空");

    // 内存警告通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];

    UIImage *image = self.imagesDict[urlString];

    // 判断内存中是否存在
    if (image) {
        complete(image);

        return;
    }

    image = [UIImage imageWithContentsOfFile:[self sanboxPatchWithStr:urlString]];

    if (image) {
        complete(image);

        // 缓存到内存中
        [self.imagesDict setObject:image forKey:urlString];

        return;
    }

    if (!self.opDict[urlString]) {
        // 获取url
        MYLoadImageOperation *op = [MYLoadImageOperation operationWithUrlString:urlString];

        __weak MYLoadImageOperation *weakOP = op;
        [op setCompletionBlock:^{

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (!weakOP.image) {
                    complete(weakOP.image);
                    //        complete(op.image);

                    // 保存到内存
                    [self.imagesDict setObject:weakOP.image forKey:urlString];

                    [self.opDict removeObjectForKey:urlString];
                }
            }];

        }];

        // 3.重复创建操作"op"
        [self.opDict setObject:op forKey:urlString];

        [self.queue addOperation:op];
    }
}

- (NSOperationQueue *)queue {
    // 判断
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (NSMutableDictionary *)imagesDict {
    // 判断
    if (_imagesDict == nil) {
        _imagesDict = [NSMutableDictionary dictionary];
    }
    return _imagesDict;
}

- (NSMutableDictionary *)opDict {
    if (_opDict == nil) {
        _opDict = [NSMutableDictionary dictionary];
    }
    return _opDict;
}

#pragma mark - 内存警告
- (void)memoryWarning {
    //    // 这样遍历很麻烦 可以考虑去 通过字典来存储
    //    for (int i = 0; i < self.appInfo.count; i++) {
    //        self.appInfo[i].image = nil;
    //    }

    [self.imagesDict removeAllObjects];

    [self.opDict removeAllObjects];

    // 取消队列的任务
    [self.queue cancelAllOperations];
}

- (NSString *)sanboxPatchWithStr:(NSString *)str {
    // 获取"/"后面的字符串
    NSString *lastPath = [str lastPathComponent];

    // 获取系统的临时储存路径
    NSString *fristPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true)[0];

    // 拼接
    NSString *path = [fristPath stringByAppendingPathComponent:lastPath];

    return path;
}

// 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
