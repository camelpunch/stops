#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"
#import "Direction.h"
#import "StopsActivityIndicatorView.h"
#import "RouteField.h"
#import "MainSubmitButton.h"

#define FIRST_DIRECTION_BUTTON_Y_OFFSET (200.0f)
#define DIRECTION_BUTTON_X_OFFSET (0.0f)
#define DIRECTION_BUTTON_HEIGHT (50.0f)
#define DIRECTION_BUTTON_WIDTH (330.0f)

@interface NextArrivalViewController ()

@end

@implementation NextArrivalViewController
{
    DirectionsFetcher *_fetcher;
    int _directionsCount;
}
@synthesize findButton;
@synthesize routeField;
@synthesize spinner;

- (id)initWithFetcher:(DirectionsFetcher *)fetcher
{
    self = [super init];
    if (self) {
        _fetcher = fetcher;
        _directionsCount = 0;
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
    [_fetcher fetchDirectionsForRouteName:self.routeField.text];
}

- (void)addDirection:(Direction *)direction
{
    _directionsCount++;
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newButton setFrame:CGRectMake(DIRECTION_BUTTON_X_OFFSET,
                                   self.currentButtonYOffset,
                                   DIRECTION_BUTTON_WIDTH,
                                   DIRECTION_BUTTON_HEIGHT)];
    [newButton setTitle:direction.name forState:UIControlStateNormal];
    [self.view addSubview:newButton];
}

#pragma mark private

- (CGFloat)currentButtonYOffset
{
    return FIRST_DIRECTION_BUTTON_Y_OFFSET +
    (DIRECTION_BUTTON_HEIGHT * _directionsCount) +
    (_directionsCount > 1 ? 1 : 0);
}

@end
