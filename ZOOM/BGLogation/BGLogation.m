//
//  BGLogation.m
//  locationdemo
//
//  Created by yebaojia on 16/2/24.
//  Copyright © 2016年 mjia. All rights reserved.
//

#import "BGLogation.h"
#import "BGTask.h"

@interface BGLogation()
{
    BOOL isCollect;
}
@property (strong , nonatomic) BGTask *bgTask; //后台任务
@property (strong , nonatomic) NSTimer *restarTimer; //重新开启后台任务定时器
@property (strong , nonatomic) NSTimer *closeCollectLocationTimer; //关闭定位定时器 （减少耗电）
@end
@implementation BGLogation
//初始化
-(instancetype)init
{
    if(self == [super init])
    {
        //
        _bgTask = [BGTask shareBGTask];
        isCollect = NO;
        //监听进入后台通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}
+(CLLocationManager *)shareBGLocation
{
    static CLLocationManager *_locationManager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.f){
                [_locationManager requestAlwaysAuthorization];//在后台也可定位
            }
            if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 9.f )
            {
                _locationManager.allowsBackgroundLocationUpdates = YES;
            }
            _locationManager.pausesLocationUpdatesAutomatically = NO;
    });
    return _locationManager;
}

//后台监听方法
-(void)applicationEnterBackground
{
//    XLLog(@"come in background");
//    CLLocationManager *locationManager = [BGLogation shareBGLocation];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
//    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.f) {
//        [locationManager requestAlwaysAuthorization];
//    }
//    [locationManager startUpdatingLocation];
//    [_bgTask beginNewBackgroundTask];
    [self restartLocation];
}
//重启定位服务
-(void)restartLocation
{
    XLLog(@"重新启动定位");
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // 不移动也可以后台刷新回调
    if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.f) {
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
    [self.bgTask beginNewBackgroundTask];
}
//开启服务
- (void)startLocation {
    XLLog(@"开启定位");
    
    if ([CLLocationManager locationServicesEnabled] == NO) {
        XLLog(@"locationServicesEnabled false");
        
//        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You currently have all location services for this device disabled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [servicesDisabledAlert show];
        XLLog(@"请打开定位");
        
    } else {
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            XLLog(@"authorizationStatus failed");
        } else {
            XLLog(@"authorizationStatus authorized");
            CLLocationManager *locationManager = [BGLogation shareBGLocation];
            locationManager.distanceFilter = kCLDistanceFilterNone;
            
            if([[UIDevice currentDevice].systemVersion floatValue]>= 8.f) {
                [locationManager requestAlwaysAuthorization];
            }
            [locationManager startUpdatingLocation];
        }
    }
}

//停止后台定位
-(void)stopLocation
{
    XLLog(@"停止定位");
    isCollect = NO;
    CLLocationManager *locationManager = [BGLogation shareBGLocation];
    [locationManager stopUpdatingLocation];
}
#pragma mark --delegate
//定位回调里执行重启定位和关闭定位
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    XLLog(@"定位收集");
    //如果正在10秒定时收集的时间，不需要执行延时开启和关闭定位
    if (isCollect) {
        return;
    }
    [self performSelector:@selector(restartLocation) withObject:nil afterDelay:120];
    [self performSelector:@selector(stopLocation) withObject:nil afterDelay:10];
    isCollect = YES;//标记正在定位
}
- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
    // XLLog(@"locationManager error:%@",error);
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"请检查网络连接" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        XLLog(@"定位失败，GPS网络有问题");
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请开启后台服务" message:@"应用不可以没有定位，需要在在设置/通用/后台应用刷新开启" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            
        }
            break;
    }
}

@end
