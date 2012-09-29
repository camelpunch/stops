#import "NextArrivalViewController.h"
#import "NextBusRouteFetcher.h"
#import "Direction.h"
#import "StopsActivityIndicatorView.h"
#import "Stop.h"
#import "ActivityDelegate.h"
#import "Predictor.h"
#import <UIKit/UIKit.h>

@implementation NextArrivalViewController
{
    NextBusRouteFetcher *theRouteFetcher;
    id<Predictor> thePredictor;
    NSDateFormatter *theDateFormatter;
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
@synthesize routeField;
@synthesize activityDelegate;

- (id)initWithRouteFetcher:(NextBusRouteFetcher *)aRouteFetcher
                 predictor:(id<Predictor>)aPredictor
{
    self = [super init];
    if (self) {
        theRouteFetcher = aRouteFetcher;
        thePredictor = aPredictor;
        theDateFormatter = [[NSDateFormatter alloc] init];
        theCurrentDirection = nil;
        theDirectionButtons = [[NSMutableArray alloc] init];
        theDirections = [[NSMutableArray alloc] init];
        theStops = [[NSArray alloc] init];
        CGRect directionButtonDimensions = CGRectMake(10, 60, 300, 40);
        theButtonStartX = CGRectGetMinX(directionButtonDimensions);
        theButtonStartY = CGRectGetMinY(directionButtonDimensions);
        theButtonWidth = CGRectGetWidth(directionButtonDimensions);
        theButtonHeight = CGRectGetHeight(directionButtonDimensions);
        theButtonYPadding = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self createRouteField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.routeField becomeFirstResponder];
}

- (void)addDirection:(Direction *)direction
{
    [self createButtonForDirection:direction];
    [self.activityDelegate activityStoppedOnView:self.view];
}

- (void)addStops:(NSArray *)stops
{
    theStops = stops;
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    [self.view addSubview:picker];
    [self.activityDelegate activityStoppedOnView:self.view];
}

#pragma mark pickerview delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    NSMutableArray *stopsForDirection = [[NSMutableArray alloc] init];
    for (Stop *stop in theStops) {
        if ([stop.direction isEqual:theCurrentDirection]) {
            [stopsForDirection addObject:stop];
        }
    }
    return [stopsForDirection count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    Stop *stop = [theStops objectAtIndex:row];
    return stop.name;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    [thePredictor predictArrivalOnRoute:self.routeField.text
                                 atStop:[theStops objectAtIndex:row]];
}

#pragma mark PredictionRecipient

- (void)receivePrediction:(Prediction *)aPrediction
{
    theDateFormatter.dateFormat = @"h:mma";
    self.nextArrivalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 320, 100)];
    [self.nextArrivalTimeLabel setBackgroundColor:[UIColor redColor]];
    self.nextArrivalTimeLabel.accessibilityLabel = @"Arrival Time";
    self.nextArrivalTimeLabel.text = [theDateFormatter stringFromDate:aPrediction.date];
    [self.view addSubview:self.nextArrivalTimeLabel];
}

#pragma mark private

#pragma mark clicks

- (void)directionButtonClicked:(UIButton *)aButton
{
    [self.activityDelegate activityStartedOnView:self.view];
    NSUInteger index = [theDirectionButtons indexOfObject:aButton];
    theCurrentDirection = [theDirections objectAtIndex:index];
    [theRouteFetcher fetchStopsForDirection:theCurrentDirection];
}

# pragma mark subview management

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
                  action:@selector(directionButtonClicked:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newButton];
}

- (CGFloat)currentButtonYOffset
{
    if (theDirectionButtons.count == 1) {
        return theButtonStartY;
    }
    return theButtonStartY + (theButtonHeight * (theDirectionButtons.count - 1)) + theButtonYPadding;
}

- (void)createRouteField
{
    self.routeField = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.routeField.placeholder = @"Route Name";
    self.routeField.accessibilityLabel = @"Enter Route";
    self.routeField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.routeField.keyboardType = UIKeyboardTypeDefault;
    self.routeField.delegate = self;
    [self.view addSubview:self.routeField];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [self.activityDelegate activityStartedOnView:self.view];
    [self removeDirectionButtons];
    [theRouteFetcher fetchRoute:self.routeField.text];
}

@end
