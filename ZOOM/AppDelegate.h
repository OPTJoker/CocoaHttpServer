//
//  AppDelegate.h
//  ZOOM
//
//  Created by WeShape_Design01 on 16/5/20.
//  Copyright © 2016年 Weshape3D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) HTTPServer *localHttpServer;

@property (nonatomic,copy) NSString *port;

@end

