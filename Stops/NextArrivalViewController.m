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
    CGFloat _buttonWidth;
    CGFloat _buttonHeight;
    CGFloat _buttonStartX;
    CGFloat _buttonStartY;
    CGFloat _buttonYPadding;
}
@synthesize findButton;
@synthesize routeField;
@synthesize spinner;

- (id)initWithFetcher:(DirectionsFetcher *)fetcher
directionButtonDimensions:(CGRect)directionButtonDimensions
directionButtonYPadding:(CGFloat)directionButtonYPadding
{
    self = [super init];
    if (self) {
        _fetcher = fetcher;
        _directionButtons = [[NSMutableArray alloc] init];
        _buttonStartX = CGRectGetMinX(directionButtonDimensions);
        _buttonStartY = CGRectGetMinY(directionButtonDimensions);
        _buttonWidth = CGRectGetWidth(directionButtonDimensions);
        _buttonHeight = CGRectGetHeight(directionButtonDimensions);
        _buttonYPadding = directionButtonYPadding;
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

    [newButton setFrame:CGRectMake(_buttonStartX,
                                   self.currentButtonYOffset,
                                   _buttonWidth,
                                   _buttonHeight)];
    [newButton setTitle:direction.name forState:UIControlStateNormal];
    [self.view addSubview:newButton];
}

#pragma mark private

- (CGFloat)currentButtonYOffset
{
    if (_directionButtons.count == 1) {
        return _buttonStartY;
    }
    return _buttonStartY + (_buttonHeight * (_directionButtons.count - 1)) + _buttonYPadding;
}

@end
