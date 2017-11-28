//
//  BGLogation.h
//  locationdemo
//
//  Created by yebaojia on 16/2/24.
//  Copyright © 2016年 mjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface BGLogation : NSObject<CLLocationManagerDelegate>
- (void)startLocation ;
+(CLLocationManager *)shareBGLocation;
@end
