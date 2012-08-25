#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"

@interface NextArrivalViewController ()

@end

@implementation NextArrivalViewController
{
    DirectionsFetcher *_fetcher;
}
@synthesize findButton;
@synthesize routeField;
@synthesize spinner;

- (id)initWithFetcher:(DirectionsFetcher *)fetcher
{
    self = [super init];
    if (self) {
        _fetcher = fetcher;
    }
    return self;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    [self.view addSubview:self.spinner];
    
    // field
    self.routeField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 200, 40)];
    self.routeField.borderStyle = UITextBorderStyleRoundedRect;
    self.routeField.font = [UIFont systemFontOfSize:15];
    self.routeField.placeholder = @"Enter Route #";
    self.routeField.accessibilityLabel = @"Enter Route";
    self.routeField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.routeField.keyboardType = UIKeyboardTypeNumberPad;
    self.routeField.returnKeyType = UIReturnKeySearch;
    self.routeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.routeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.routeField.delegate = self;
    [self.view addSubview:self.routeField];

    // button
    self.findButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.findButton setFrame:CGRectMake(50, 140, 200, 80)];
    [self.findButton setTitle:@"Find"
                     forState:UIControlStateNormal];
    [self.findButton addTarget:self
                        action:@selector(findButtonClicked)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.findButton];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)findButtonClicked
{
    [self.view endEditing:NO];
    [self.spinner startAnimating];
    [_fetcher fetchDirectionsForRoute:self.routeField.text];
}

@end
