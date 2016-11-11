//
//  WebContentViewController.m
//  FeedApp
//
//  Created by TechLoverr on 18/09/16.
//
//

#import "LLHeaderLabel.h"
#import "WebContentViewController.h"

@interface WebContentViewController ()
@property(weak, nonatomic) IBOutlet LLHeaderLabel *lblTitle;
@property(weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebContentViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  _lblTitle.text = _titleString;
    
    if ([_titleString isEqualToString:@"Privacy Policy"]) {
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"privacypolicy" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
        
    }else{
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"terms" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [_webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    }
}
- (IBAction)backPressed:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
