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
//#import "WKWebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "SMMUriActionEngine.h"

@protocol JSObjcDelegate <JSExport>
- (NSString *)manage:(NSString *)jsStr;
@end
@interface PPCLoadWebVC ()<WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate, JSObjcDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *sourceDocument;
@property (nonatomic, strong) JSContext *context;
//@property (nonatomic, strong) WKWebViewJavascriptBridge *wkbridge;
//@property (nonatomic, strong) WebViewJavascriptBridge *uiBridge;
@end
@implementation PPCLoadWebVC

- (instancetype)initWithFilePath:(NSString *)filePath sourceDocument:(NSString *)sourceDocument
{
    self = [super init];
    if (self)
    {
        self.filePath = filePath;
        self.sourceDocument = sourceDocument;
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.wkWebView = [[WKWebView alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:_wkWebView];
    
    self.uiWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [_uiWebView setDelegate:self];
    [self.view addSubview:_uiWebView];
    
    [self beginLoad];
    
    self.context = [_uiWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"appJs"] = self;
    _context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        NSLog(@"error：%@", exceptionValue);
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.wkbridge = [WKWebViewJavascriptBridge bridgeForWebView:_wkWebView];
//    [_wkbridge registerHandler:@"getUrlParams" handler:^(id data, WVJBResponseCallback responseCallback) {
//        // data 后台传过来的参数,例如用户名、密码等
//        
//        NSLog(@"testObjcCallback called: %@", data);
//        // responseCallback 给后台的回复
//        responseCallback(@"Response from abc");
//    }];
//    self.uiBridge = [WebViewJavascriptBridge bridgeForWebView:_uiWebView];
//    [_uiBridge registerHandler:@"getUrlParams" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"ObjC Echo called with: %@", data);
//        responseCallback(data);
//    }];
//    JSContext *context = [_uiWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    context[@"app"] = self;
}


#pragma mark - Private Methods
//  读取html文件
- (void)beginLoad
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];//[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    
    NSLog(@"paths: %@", paths);
    
    //  AppHtml目录
    NSString *appHtmlDocumentPath = [documentsDirectory stringByAppendingPathComponent:HtmlDocument];
    
    NSString *htmlPath = [appHtmlDocumentPath stringByAppendingPathComponent:@"Faxian/index.html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *baseUrl1 = [NSURL fileURLWithPath:[appHtmlDocumentPath stringByAppendingPathComponent:@"Faxian"]];
    
    NSLog(@"html: %@, baseUrl1: %@", htmlPath, baseUrl1);
    [_uiWebView loadHTMLString:htmlCont baseURL:baseUrl1];
}

//  js调用OC方法
- (NSString *)manage:(NSString *)jsStr
{
    NSLog(@"jsStr=%@", jsStr);
    NSData *jsonData  =[jsStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
    }
    if ([[dic objectForKey:@"action"] isEqualToString:@"webjson"] && _webJson)
    {
        NSData *data = [NSJSONSerialization dataWithJSONObject:_webJson options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    else
    {
        return @"{}";
    }
}

#pragma mark - WKWebViewNavigation Delegate
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
//{
//    NSLog(@"error: %@", error.description);
//}
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//    NSLog(@"load finish");
//}
//
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
//{
//    NSLog(@"load start");
//}
//
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
//{
//    NSLog(@"commit");
//}
//
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
//    
//    NSURLRequest *request = navigationAction.request;
//    NSLog(@"request: %@", request.URL);
//    self.urlString = request.URL.absoluteString;
//    
//    //这句是必须加上的，不然会异常
//    decisionHandler(actionPolicy);
//}

#pragma mark - UIWebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"load start");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"load finish");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[SMMUriActionEngine sharedEngine] handle:request.URL];
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error: %@", error.description);
}
@end
