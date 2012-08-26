#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"
#import "Direction.h"
#import "StopsActivityIndicatorView.h"
#import "RouteField.h"
#import "MainSubmitButton.h"

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
    
    self.spinner = [[StopsActivityIndicatorView alloc] init];
    self.spinner.center = self.view.center;
    [self.view addSubview:self.spinner];
    
    self.routeField = [[RouteField alloc] init];
    self.routeField.delegate = self;
    [self.view addSubview:self.routeField];

    self.findButton = [[MainSubmitButton alloc] init];
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

- (void)addDirection:(Direction *)direction
{
    UIButton *newView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newView setFrame:CGRectMake(0, 0, 100, 100)];
    [newView setTitle:direction.name forState:UIControlStateNormal];
    [self.view addSubview:newView];
}

@end
