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
    NSMutableArray *_directionButtons;
    CGRect _directionButtonDimensions;
}
@synthesize findButton;
@synthesize routeField;
@synthesize spinner;

- (id)initWithFetcher:(DirectionsFetcher *)fetcher
directionButtonDimensions:(CGRect)directionButtonDimensions
{
    self = [super init];
    if (self) {
        _fetcher = fetcher;
        _directionButtons = [[NSMutableArray alloc] init];
        _directionButtonDimensions = directionButtonDimensions;
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
    for (UIButton *button in _directionButtons) {
        [button removeFromSuperview];
    }
    _directionButtons = [[NSMutableArray alloc] init];
    [_fetcher fetchDirectionsForRouteName:self.routeField.text];
}

- (void)addDirection:(Direction *)direction
{
    [self.spinner stopAnimating];
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

    [_directionButtons addObject:newButton];

    [newButton setFrame:CGRectMake(_directionButtonDimensions.origin.x,
                                   self.currentButtonYOffset,
                                   _directionButtonDimensions.size.width,
                                   _directionButtonDimensions.size.height)];
    [newButton setTitle:direction.name forState:UIControlStateNormal];
    [self.view addSubview:newButton];
}

#pragma mark private

- (CGFloat)currentButtonYOffset
{
    return _directionButtonDimensions.origin.y +
    (_directionButtonDimensions.size.height * (_directionButtons.count - 1)) +
    (_directionButtons.count > 1 ? 1 : 0);
}

@end
