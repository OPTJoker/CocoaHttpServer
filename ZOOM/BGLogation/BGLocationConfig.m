//
//  BGLocationConfig.m
//  ZOOM
//
//  Created by 张雷 on 2017/11/28.
//  Copyright © 2017年 Weshape3D. All rights reserved.
//

#import "BGLocationConfig.h"
#import "BGLogation.h"
#import "BGTask.h"

@interface BGLocationConfig()
@property (strong , nonatomic) BGTask *task;
@property (strong , nonatomic) BGLogation *bgLocation;

@end

@implementation BGLocationConfig

static BGLocationConfig *instance = nil;
+ (instancetype)ShareInstance{
    
    @synchronized(self){
        if (nil == instance) {
            instance = [[super allocWithZone:nil] init]; // 避免死循环
        }
    }
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [BGLocationConfig ShareInstance];
}

- (id)copy
{
    return self;
}

- (id)mutableCopy
{
    return self;
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return self;
}

#pragma mark <后台定位>
/**
 开启后台定位
 */
- (void)BGRunSeting{
    _task = [BGTask shareBGTask];
    if([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusDenied){
        //[SVProgressHUD showImage:nil status:@"请打开:设置->通用->后台应用刷新开启"];
        UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"请开启后台刷新" message:@"开启方式：设置->通用->后台应用刷新开启" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"稍后就开" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        }];
        [alertControler addAction:yesAction];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertControler animated:YES completion:nil];
    }
    else if ([UIApplication sharedApplication].backgroundRefreshStatus == UIBackgroundRefreshStatusRestricted){
        XLLog(@"请打开定位");
    }
    //    else{
    //        self.bgLocation = [[BGLogation alloc]init];
    //    }
    if (nil == self.bgLocation) {
        self.bgLocation = [[BGLogation alloc] init];
    }
    [self.bgLocation startLocation];
    
}

+ (void)starBGLocation{
    [[BGLocationConfig ShareInstance] BGRunSeting];
}
@end
