//
//  PPCLoadWebVC.m
//  PPCOperation
//
//  Created by Apple on 5/30/16.
//  Copyright © 2016 pen. All rights reserved.
//

#import "PPCLoadWebVC.h"
#import "SMMBaseApiEngine.h"
#import "UIColor+Extension.h"
#import "PPCDefine.h"
#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>


@interface PPCLoadWebVC ()<WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@end
@implementation PPCLoadWebVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wkWebView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_wkWebView];
    
    [self beginLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:_wkWebView];
    [_bridge registerHandler:@"getUrlParams" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data 后台传过来的参数,例如用户名、密码等
        
        NSLog(@"testObjcCallback called: %@", data);
        // responseCallback 给后台的回复
        responseCallback(@"Response from abc");
    }];
}

#pragma mark - Private Methods
//  读取html文件
- (void)beginLoad
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = NSTemporaryDirectory();//[paths firstObject];
    
    //  AppHtml目录
    NSString *appHtmlDocumentPath = [documentsDirectory stringByAppendingPathComponent:HtmlDocument];
    
    NSString *htmlPath = [appHtmlDocumentPath stringByAppendingPathComponent:@"Faxian/index.html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *baseUrl1 = [NSURL fileURLWithPath:[appHtmlDocumentPath stringByAppendingPathComponent:@"Faxian"]];
    
    NSLog(@"html: %@, baseUrl1: %@", htmlPath, baseUrl1);
    [_wkWebView loadHTMLString:htmlCont baseURL:baseUrl1];
}

#pragma mark - WKWebViewNavigation Delegate
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"error: %@", error.description);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSLog(@"load finish");
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"load start");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    NSLog(@"commit");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    NSURLRequest *request = navigationAction.request;
    NSLog(@"request: %@", request.URL);
    self.urlString = request.URL.absoluteString;
    
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}
@end
