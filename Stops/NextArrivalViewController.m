#import "NextArrivalViewController.h"
#import "DirectionsFetcher.h"

@interface NextArrivalViewController ()

@end

@implementation NextArrivalViewController
{
    DirectionsFetcher *_fetcher;
}
@synthesize findButton;

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
	// Do any additional setup after loading the view.
    self.findButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.findButton setFrame:CGRectMake(50, 300, 200, 80)];
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
    NSLog(@"Clicked!");
    [_fetcher fetchDirectionsForRoute:@"22"];
}

@end
