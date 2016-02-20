//
//  DataDownLoader.m
//  FetchDataTest
//
//  Created by KiranChavadi on 10/02/16.
//  Copyright © 2016 KiranChavadi. All rights reserved.
//

#import "DataDownLoader.h"
#import "AFNetworkReachabilityManager.h"
@implementation DataDownLoader
@synthesize session,tagvalue,datais,dataDelegate;


+ (DataDownLoader *)sharedMySingleton
{
    static dispatch_once_t shared_initialized;
    static DataDownLoader *shared_instance = nil;
    
    dispatch_once(&shared_initialized, ^ {
        shared_instance = [[DataDownLoader alloc] init];
    });
    
    return shared_instance;
}

/*
    Delegate design pattern to get the data from the recieved url and returns to sender
 */
-(void)downloadDataWithRequest:(NSURL*)url andRequest:(NSMutableURLRequest*)request {
NSURLSessionConfiguration *config =    [NSURLSessionConfiguration ephemeralSessionConfiguration];
    config.URLCache = nil;
    config.HTTPShouldSetCookies = NO;
    config.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyNever;
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                       NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        }];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sessionWithConfiguration:config]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if(error == nil)
                                              {
                                                  if(self.dataDelegate != nil && [self.dataDelegate respondsToSelector:@selector(downloadedData:withCurrentDownloaderObject:)])
                                                  {
                                                      [self.dataDelegate  downloadedData:data withCurrentDownloaderObject:self];
                                                  }
                                              }
                                              else{
                                                  if(self.dataDelegate != nil && [self.dataDelegate respondsToSelector:@selector(failWithError:withCurrentDownloaderObject:)])
                                                  {
                                                      [self.dataDelegate  failWithError:error withCurrentDownloaderObject:self];
                                                  }
                                              }

                                          }];
    [downloadTask resume];
    
}

@end
