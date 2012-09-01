#import "NextArrivalViewController.h"
#import "RouteFetcher.h"
#import "Direction.h"
#import "StopsActivityIndicatorView.h"
#import "RouteField.h"
#import "MainSubmitButton.h"
#import "Stop.h"

@interface NextArrivalViewController ()
@end

@implementation NextArrivalViewController
{
    RouteFetcher *theRouteFetcher;
    Direction *theCurrentDirection;
    NSMutableArray *theDirectionButtons;
    NSMutableArray *theDirections;
    CGFloat theButtonWidth;
    CGFloat theButtonHeight;
    CGFloat theButtonStartX;
    CGFloat theButtonStartY;
    CGFloat theButtonYPadding;
    NSArray *theStops;
}
@synthesize findButton;
@synthesize routeField;
@synthesize spinner;

- (id)initWithRouteFetcher:(RouteFetcher *)aRouteFetcher
 directionButtonDimensions:(CGRect)directionButtonDimensions
   directionButtonYPadding:(CGFloat)directionButtonYPadding
{
    self = [super init];
    if (self) {
        theRouteFetcher = aRouteFetcher;
        theCurrentDirection = nil;
        theDirectionButtons = [[NSMutableArray alloc] init];
        theDirections = [[NSMutableArray alloc] init];
        theStops = [[NSArray alloc] init];
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

- (void)addDirection:(Direction *)direction
{
    [self.spinner stopAnimating];
    [self createButtonForDirection:direction];
}

- (void)addStops:(NSArray *)stops
{
    [self.spinner stopAnimating];
    theStops = stops;
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    [self.view addSubview:picker];
}

#pragma mark pickerview delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSMutableArray *stopsForDirection = [[NSMutableArray alloc] init];
    for (Stop *stop in theStops) {
        if ([stop.direction isEqual:theCurrentDirection]) {
            [stopsForDirection addObject:stop];
        }
    }
    return [stopsForDirection count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Stop *stop = [theStops objectAtIndex:row];
    return stop.name;
}

#pragma mark private

- (void)findButtonClicked
{
    [self.view endEditing:NO];
    [self.spinner startAnimating];
    [self removeDirectionButtons];
    [theRouteFetcher fetchRoute:self.routeField.text];
}

- (void)removeDirectionButtons
{
    for (UIButton *button in theDirectionButtons) {
        [button removeFromSuperview];
    }
    [theDirectionButtons removeAllObjects];
}

- (void)createButtonForDirection:(Direction *)aDirection
{
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [newButton setTitle:aDirection.name forState:UIControlStateNormal];

    [theDirectionButtons addObject:newButton];
    [theDirections addObject:aDirection];
    [newButton setFrame:CGRectMake(theButtonStartX,
                                   self.currentButtonYOffset,
                                   theButtonWidth,
                                   theButtonHeight)];
    [newButton addTarget:self
                  action:@selector(fetchStopsForButton:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];
}

- (void)fetchStopsForButton:(UIButton *)aButton
{
    [self.spinner startAnimating];
    NSUInteger index = [theDirectionButtons indexOfObject:aButton];
    theCurrentDirection = [theDirections objectAtIndex:index];
    [theRouteFetcher fetchStopsForDirection:theCurrentDirection];
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
