//
//  ViewController.m
//  ZOOM
//
//  Created by WeShape_Design01 on 16/5/20.
//  Copyright © 2016年 Weshape3D. All rights reserved.
//
#define KSCRW   [UIScreen mainScreen].bounds.size.width
#define KSCRH   [UIScreen mainScreen].bounds.size.height
#define NavH    (KSCRH>=812 ? 88.:64.)

#import "MainViewController.h"
#import <HTTPServer.h>
#import <WebKit/WebKit.h>
#import "AppDelegate.h"

@interface MainViewController ()
<
WKNavigationDelegate
>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) BOOL loadHttpSuc;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.1 green:0.14 blue:0.19 alpha:1];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"LocalHttp" style:UIBarButtonItemStylePlain target:self action:@selector(loadLocalHttpServer)]];
    
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}


- (BOOL)loadLocalHttpServer{
    
    AppDelegate *appd = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *port = appd.port;
    if (nil == port) {
        XLLog(@">>> Error:端口不存在");
        return NO;
    }
    NSString *str = [NSString stringWithFormat:@"http://localhost:%@", port];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.webView loadRequest:request];

    return YES;
}

- (NSString *)urlStr{
    if (nil == _urlStr) {
        _urlStr = @"https://cn.bing.com/";
    }
    return _urlStr;
}

- (WKWebView *)webView{
    if (nil == _webView) {
        
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        //初始化偏好设置属性：preferences
        config.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        config.preferences.minimumFontSize = 10;
        //是否支持JavaScript
        config.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavH, KSCRW, KSCRH-NavH) configuration:config];
        _webView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_webView];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"Did Start Load");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"Did Finish Load");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Did Fail Load With Error:\n%@",error);
}



- (void)dealloc{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
