//
//  ViewController.m
//  TaskOPTI
//
//  Created by Radu Nitescu  on 30/10/2020.
//

/// Description:
// Fetches the content from the TARGERT_URL and displays it in a WebKit.
// An Alert Box is presented if the fetched content is different than the expected content.


#import "ViewController.h"
#import <Webkit/Webkit.h>
#import <CommonCrypto/CommonDigest.h>

#define TARGET_URL "https://www.opti.ro/test-melian.html"

@interface ViewController ()

@end

@implementation ViewController

WKWebView *webView;

- (NSString *)doSha256: (NSData *)dataIn {
    NSMutableData *macOut = [NSMutableData dataWithLength: CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(dataIn.bytes, (unsigned int)dataIn.length, macOut.mutableBytes);
    return [macOut base64EncodedStringWithOptions: 0];
}


- (NSData*)fetchContent
{
    NSURL *url = [NSURL URLWithString: @TARGET_URL];
    return [NSData dataWithContentsOfURL: url];
}


- (NSString*)convertToUTF8String: (NSData*) data
{
    return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}


- (void)showContentChangedAlert
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Changed Content"
                                   message: @"Website content was changed!"
                                   preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction* defaultAction = [
                                    UIAlertAction actionWithTitle: @"OK"
                                    style: UIAlertActionStyleDefault
                                    handler: ^(UIAlertAction * action) {}
                                    ];

    [alert addAction: defaultAction];
    [self presentViewController: alert animated:NO completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    webView = [[WKWebView alloc] initWithFrame: self.view.bounds];
    [self.view addSubview: webView];
}


-(void)viewDidAppear:(BOOL)animated {
    NSData* data = [self fetchContent];
    
    if (data != nil) {
        NSString* newContentHash = [self doSha256: data];
        [webView loadHTMLString: [self convertToUTF8String: data] baseURL: nil];
        if (![newContentHash isEqualToString: @"9tCdHDE2khOmf0+yrJrp4QS048BRN2Y74fpqMJ/5B5Q="]) {
            [self showContentChangedAlert];
        }
    } else {
        [self showContentChangedAlert];
    }
}

@end
