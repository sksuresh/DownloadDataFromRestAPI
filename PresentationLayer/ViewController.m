//
//  ViewController.m
//

//

#import "ViewController.h"
#import "MBProgressHUD.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize  arrProducts;

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    arrProducts = [NSMutableArray array];
//    [NSThread detachNewThreadSelector:@selector(startDownload) toTarget:self withObject:nil];
    [self.view setAccessibilityLabel:@"listtable"];
    [self.view setAccessibilityIdentifier:@"listtable"];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self startDownload:[NSString stringWithFormat:@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@",textField.text]];
    [textField resignFirstResponder];
    return true;
}

-(void)startDownload:(NSString*)str
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [self downloadData:str delegate:self];

}
/*
  Method for downloading data
 */
-(void)downloadData:(NSString*)urlStr delegate:(id)current
{
    DataDownLoader *d = [DataDownLoader new];
    d.dataDelegate = current;
    [d downloadDataWithRequest:[NSURL URLWithString:urlStr] andRequest:NULL];
}



/*
   Protcol methods
 */
-(void)downloadedData:(NSData*)data withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

    NSError *error;
            id jsonresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves  error:&error];
    NSLog(@"%@",jsonresult);
    if(error == nil)
                {
                    if([jsonresult isKindOfClass:[NSArray class]])
                                    {
                                        @try {
                                             NSArray *arr = (NSArray*)jsonresult;
                                             NSDictionary *dicts = [arr lastObject];
                                             NSArray *arrList = [[[dicts objectForKey:@"lfs"] lastObject] objectForKey:@"vars"];
                                            NSLog(@"%@",[arrList description]);
                                            [self.arrProducts addObjectsFromArray:arrList];
                                        }
                                        @catch(NSException *exp)
                                        {
                                            NSLog(@"exception in parsing %@",[exp description]);
                                        }
                                        @finally
                                        {
                                            [self.tableView reloadData];
                                        }
                                    }
                }
}

-(void)failWithError:(NSError*)error withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alrt = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
          UIAlertAction *done = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
              NSLog(@"done clicked");
                [self dismissViewControllerAnimated:alrt completion:^{
                  NSLog(@"alertviewcontroller closed");
                    }];
           }];
         [alrt addAction:done];
           [self presentViewController:alrt animated:YES completion:^{
           
       }];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

   
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrProducts count];
}

/*
  Table DataSource Methods for loading cells on table view
 */
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
    }
    [cell setAccessibilityLabel:@"listcell"];
    @try {
        NSDictionary *prd = [self.arrProducts objectAtIndex:indexPath.row];
        cell.textLabel.text =  [prd objectForKey:@"lf"];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"final called");
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
