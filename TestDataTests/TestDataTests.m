//
//  TestDataTests.m
//  TestDataTests
//
//
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface TestDataTests : XCTestCase<DataDownLoaderProtocol>
{
    XCTestExpectation *expectation;
    ViewController *vc;
}
@property (nonatomic,strong) ViewController *vc;
@end

@implementation TestDataTests
@synthesize vc;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nav = [storyboard instantiateInitialViewController];
    XCTAssertNotNil(nav,@"navigationcontroller is present");
    id obj = nav.viewControllers.lastObject;
    self.vc = obj;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)downloadedData:(NSData*)data withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    [expectation fulfill];
    XCTAssertNotNil(data);
   [self checkingResultData:data];
}

-(void)checkingResultData:(NSData*)data
{
    NSMutableArray *arrproducts = [NSMutableArray array];
    __block NSInteger countOfProducts  = 0;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSError *error;
        id jsonresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves  error:&error];
        XCTAssertNotNil(jsonresult, "data should not be nil");
        XCTAssertNil(error, "error should be nil");
        if(error == nil)
        {
            if([jsonresult isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dict = (NSDictionary*)jsonresult;
                if([dict objectForKey:@"promotions"] != nil && [[dict objectForKey:@"promotions"] isKindOfClass:[NSArray class]]){
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[dict objectForKey:@"promotions"]];
                    for (NSDictionary *obj in arr) {
                        Products *prd      = [Products new];
                        [prd setProduct:obj];
                        [arrproducts addObject:prd];
                    }
                    countOfProducts = [[dict objectForKey:@"promotions"] count];
                    XCTAssertEqual([arrproducts count],countOfProducts, @"Equal size downloaded and saved");
                }
                [self.vc.tableView reloadData];
            }
        }
    });
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.vc.tableView cellForRowAtIndexPath:indexPath];
    NSString *expectedReuseIdentifier = [NSString stringWithFormat:@"%ld/%ld",(long)indexPath.section,(long)indexPath.row];
    XCTAssertTrue([cell.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Table does not create reusable cells");
}

#pragma mark - UITableView tests


- (void)testThatTableViewHasDataSource
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource)], @"Table datasource needs to be implemented");
    XCTAssertNotNil(self.vc.tableView.dataSource, @"Table datasource cannot be nil");

}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate)], @"Table datasource cannot be nil");

    XCTAssertNotNil(self.vc.tableView.delegate, @"Table delegate cannot be nil");
}

- (void)testTableViewNumberOfRowsInSection
{
    NSInteger expectedRows = [self.vc.arrProducts count];
    XCTAssertTrue([self.vc tableView:self.vc.tableView numberOfRowsInSection:0]==expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.vc tableView:self.vc.tableView numberOfRowsInSection:0], (long)expectedRows);
}

- (void)testTableViewHeightForRowAtIndexPath
{
    CGFloat expectedHeight = 88.0;
    CGFloat actualHeight = self.vc.tableView.rowHeight;
    XCTAssertEqual(expectedHeight, actualHeight, @"Cell should have %f height, but they have %f", expectedHeight, actualHeight);
}



-(void)failWithError:(NSError*)error withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    [expectation fulfill];

}

-(void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssertNotNil(self.vc);
    [self.vc performSelectorOnMainThread:@selector(viewDidLoad) withObject:nil waitUntilDone:YES];
    XCTAssertNotNil(vc,@"viewcontroller not instansiated");
    XCTAssertNotNil(vc.arrProducts,@"array not instansiated");
    XCTAssertNotNil(vc.tableView,@"tableview not instansiated");
    expectation = [self expectationWithDescription:@"HTTP request"];
    [self.vc downloadData:@"http://www.petesalvo.com/products.json" delegate:self];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            XCTFail(@"timeout error: %@", error);
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
