//
//  SMMDownloadHandler.m
//  TestHtmlCSSJS
//
//  Created by Apple on 5/17/16.
//  Copyright © 2016 Apple. All rights reserved.
//

#import "SMMOperationHandler.h"
#import "PPCDefine.h"

#define DownloadQueue @"downloadQueue"
@interface SMMOperationHandler()<NSURLConnectionDataDelegate>
@property (nonatomic, assign) NSInteger urlCount;
@property (nonatomic, assign) NSInteger downloadCount;
@property (nonatomic, strong) NSString *version;//当前下载的文件类型版本号，如：1.6.3等
@property (nonatomic, strong) NSString *key;//当前下载的文件类型目录名Key，如：js/html等
@property (nonatomic, strong) NSURL *fileUrl;//下载文件url
@end
@implementation SMMOperationHandler

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _urlCount = 0;
        _downloadCount = 0;
    }
    return self;
}

#pragma mark - Public Methods
- (void)getFileDictionaryWithUrl:(NSURL *)url version:(NSString *)version key:(NSString *)key
{
    _version = version;
    _key = key;
    
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    NSDictionary *fileDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    [self transformWithDic:fileDic];
    
}

#pragma mark - Private Methods
//  根据字典获取下载文件名和下载地址
- (void)transformWithDic:(NSDictionary *)dic
{
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         _urlCount++;
         [self getPathsAndFileNameWithUrl:[NSString stringWithFormat:@"%@/%@", DownloadUrl, key]];
     }];
}

//  根据url获取下载地址、目录结构、文件名
- (void)getPathsAndFileNameWithUrl:(NSString *)url
{
    NSMutableArray *paths = [[NSMutableArray alloc]init];
    BOOL canAdd = NO;
    for (NSString *string in [url pathComponents])
    {
        if (canAdd)
        {
            [paths addObject:string];
        }
        else if ([string isEqualToString:HtmlDocument])
        {
            canAdd = YES;
        }
    }
    NSString *fileName = [paths lastObject];
    
    [self downloadFileWithUrl:url paths:paths fileName:fileName];
}

//  根据下载地址、目录结构、文件名创建文件
- (void)downloadFileWithUrl:(NSString *)url paths:(NSArray *)paths fileName:(NSString *)fileName
{
    NSURLRequest *request =  [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    void (^downloadOperation)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error)
    {
        __weak typeof(self) weakSelf = self;
        if (error)
        {
            NSLog(@"error = %@, url: %@",error.localizedDescription, url);
            
            if (_delegate && [_delegate respondsToSelector:@selector(downloadFailWithOperationHandler:fileUrl:version:key:)])
            {
                [_delegate downloadFailWithOperationHandler:weakSelf fileUrl:_fileUrl version:_version key:_key];
            }
        }
        else
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //  location是下载的临时文件目录
            NSArray *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            //  根目录
            NSString *documentsPath = [docs objectAtIndex:0];
            NSLog(@"document: %@", documentsPath);
            
            //  AppHtml目录
            NSString *appHtmlDocumentPath = [documentsPath stringByAppendingPathComponent:HtmlDocument];
            
            
            //  判断AppHtml目录是否存在
            if (![fileManager fileExistsAtPath:appHtmlDocumentPath])
            {
                BOOL createdAppHtmlDocument = [[NSFileManager defaultManager] createDirectoryAtPath:appHtmlDocumentPath
                                                                        withIntermediateDirectories:YES
                                                                                         attributes:nil
                                                                                              error:nil];
                NSAssert(createdAppHtmlDocument,@"创建AppHtml目录失败");
            }
            //  递归创建目录
            [weakSelf createDocumentsWithCurrentDocument:appHtmlDocumentPath paths:[paths mutableCopy] fileName:fileName location:location];
        }
        
    };
    
    NSURLSessionDownloadTask *downLoad = [session downloadTaskWithRequest:request completionHandler:downloadOperation];
    [downLoad resume];
}

//  递归创建目录
- (void)createDocumentsWithCurrentDocument:(NSString *)currentDocument paths:(NSMutableArray *)paths fileName:(NSString *)fileName location:(NSURL *)location
{
    //  判断中间目录是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (paths.count == 1)
    {
        NSString *filePath = [currentDocument stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
        NSURL *toURL = [NSURL fileURLWithPath:filePath];
        
        
        if ([fileManager fileExistsAtPath:[toURL path] isDirectory:NULL])
        {
            [fileManager removeItemAtURL:toURL error:NULL];
        }
        BOOL isSuccess = [fileManager moveItemAtURL:location toURL:toURL error:NULL];
        if (isSuccess)
        {
            NSLog(@"%@文件创建成功", fileName);
            _downloadCount++;
        }
        else
        {
            NSLog(@"%@文件创建失败", fileName);
        }
        
        if (_downloadCount == _urlCount)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(operationHandler:version:key:)])
            {
                [_delegate operationHandler:self version:_version key:_key];
            }
        }
        return;
    }
    else
    {
        NSString *typeDocumentPath = [currentDocument stringByAppendingPathComponent:[paths objectAtIndex:0]];
        if (![fileManager fileExistsAtPath:typeDocumentPath])
        {
            BOOL createdMiddleDocument = [[NSFileManager defaultManager] createDirectoryAtPath:typeDocumentPath
                                                                   withIntermediateDirectories:YES
                                                                                    attributes:nil
                                                                                         error:nil];
            NSAssert(createdMiddleDocument,@"创建中间目录失败");
        }
        [paths removeObjectAtIndex:0];
        [self createDocumentsWithCurrentDocument:typeDocumentPath paths:paths fileName:fileName location:location];
    }
}
@end
