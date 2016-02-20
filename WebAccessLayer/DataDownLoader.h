//
//  DataDownLoader.h
//  FetchDataTest
//
//  Created by KiranChavadi on 10/02/16.
//  Copyright © 2016 KiranChavadi. All rights reserved.
//
/*
    This Class is responsible for creation session based datadownload request and return results to sender Object
 */
#import <Foundation/Foundation.h>
/*
   DataDownLoaderProtocol is a protocol will gives results with success of data download and failure of data download
 */
@class DataDownLoader;
@protocol DataDownLoaderProtocol<NSObject>
-(void)downloadedData:(NSData*)data withCurrentDownloaderObject:(DataDownLoader*)downldr;
-(void)failWithError:(NSError*)error withCurrentDownloaderObject:(DataDownLoader*)downldr;
@end

@interface DataDownLoader : NSObject<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
{
    NSURLSession *session;
    int tagvalue;
    NSMutableData *datais;
    __weak id<DataDownLoaderProtocol> dataDelegate;
}

@property(nonatomic, weak) id<DataDownLoaderProtocol> dataDelegate;
@property(nonatomic, strong) NSURLSession *session;
@property(nonatomic)    int tagvalue;
@property(nonatomic, strong) NSMutableData *datais;
-(void)downloadDataWithRequest:(NSURL*)url andRequest:(NSMutableURLRequest*)request;
+ (DataDownLoader *)sharedMySingleton;
@end
