//
//  ViewController.h
//  FetchDataTest
//
//  Created by KiranChavadi on 09/02/16.
//  Copyright © 2016 KiranChavadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDownLoader.h"

@interface ViewController : UITableViewController<DataDownLoaderProtocol,UITextFieldDelegate>
{
    NSMutableArray *arrProducts;
}
@property (nonatomic, strong) NSMutableArray *arrProducts;
-(void)downloadData:(NSString*)urlStr delegate:(id)current;

@end

