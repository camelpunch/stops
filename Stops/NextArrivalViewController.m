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
    DirectionsFetcher *theFetcher;
    NSMutableArray *theDirectionButtons;
    CGFloat theButtonWidth;
    CGFloat theButtonHeight;
    CGFloat theButtonStartX;
    CGFloat theButtonStartY;
    CGFloat theButtonYPadding;
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
        theFetcher = fetcher;
        theDirectionButtons = [[NSMutableArray alloc] init];
        theButtonStartX = CGRectGetMinX(directionButtonDimensions);
        theButtonStartY = CGRectGetMinY(directionButtonDimensions);
        theButtonWidth = CGRectGetWidth(directionButtonDimensions);
        theButtonHeight = CGRectGetHeight(directionButtonDimensions);
        theButtonYPadding = directionButtonYPadding;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSpinner];
    [self createRouteField];
    [self.routeField becomeFirstResponder];
    [self createFindButton];
}

- (void)findButtonClicked
{
    [self.view endEditing:NO];
    [self.spinner startAnimating];
    [self removeDirectionButtons];
    [theFetcher fetchDirectionsForRouteName:self.routeField.text];
}

- (void)addDirection:(Direction *)direction
{
    [self.spinner stopAnimating];
    [self createDirectionButtonWithDirection:direction];
}

#pragma mark private

- (void)removeDirectionButtons
{
    for (UIButton *button in theDirectionButtons) {
        [button removeFromSuperview];
    }
    [theDirectionButtons removeAllObjects];
}

- (void)createDirectionButtonWithDirection:(Direction *)direction
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [theDirectionButtons addObject:newButton];
    [newButton setFrame:CGRectMake(theButtonStartX,
                                   self.currentButtonYOffset,
                                   theButtonWidth,
                                   theButtonHeight)];
    [newButton setTitle:direction.name forState:UIControlStateNormal];
    [self.view addSubview:newButton];
}

- (void)createSpinner
{
    self.spinner = [[StopsActivityIndicatorView alloc] init];
    self.spinner.center = self.view.center;
    [self.view addSubview:self.spinner];
}

- (void)createRouteField
{
    self.routeField = [[RouteField alloc] init];
    self.routeField.delegate = self;
    [self.view addSubview:self.routeField];
}

- (void)createFindButton
{
    self.findButton = [[MainSubmitButton alloc] init];
    [self.findButton addTarget:self
                        action:@selector(findButtonClicked)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.findButton];
}

- (CGFloat)currentButtonYOffset
{
    if (theDirectionButtons.count == 1) {
        return theButtonStartY;
    }
    return theButtonStartY + (theButtonHeight * (theDirectionButtons.count - 1)) + theButtonYPadding;
}

@end
