//
//  TestDataUITests.m
//  TestDataUITests
//
//
//

#import <XCTest/XCTest.h>

@interface TestDataUITests : XCTestCase

@end

@implementation TestDataUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    if([app.tables[@"listtable"].cells count])
    {
    XCUIElement *listtableTable = [app.tables[@"listtable"].cells elementBoundByIndex:0];
    [listtableTable tap];
        
    
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElement *getReadyForSummerDaysStaticText = tablesQuery.staticTexts[@"GET READY FOR SUMMER DAYS"];
    [getReadyForSummerDaysStaticText tap];
    }
    
    
    
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
