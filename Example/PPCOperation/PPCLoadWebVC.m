//
//  PPCLoadWebVC.m
//  PPCOperation
//
//  Created by Apple on 5/30/16.
//  Copyright © 2016 pen. All rights reserved.
//

#import "PPCLoadWebVC.h"
#import "SMMOperationHandler.h"
#import "SMMBaseApiEngine.h"
#import "UIColor+Extension.h"
#import "PPCDefine.h"

@interface PPCLoadWebVC ()
@property (nonatomic, strong) UIWebView *uiWebView;
@end
@implementation PPCLoadWebVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.uiWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_uiWebView];
    
    [self beginLoad];
}

#pragma mark - Private Methods
//  读取html文件
- (void)beginLoad
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    
    //  AppHtml目录
    NSString *appHtmlDocumentPath = [documentsDirectory stringByAppendingPathComponent:HtmlDocument];
    
    NSString *htmlPath = [appHtmlDocumentPath stringByAppendingPathComponent:@"Faxian/index.html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSURL *baseUrl1 = [NSURL fileURLWithPath:[appHtmlDocumentPath stringByAppendingPathComponent:@"Faxian"]];
    [_uiWebView loadHTMLString:htmlCont baseURL:baseUrl1];
}
@end
