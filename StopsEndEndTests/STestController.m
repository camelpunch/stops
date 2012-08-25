#import "STestController.h"
#import "KIFTestScenario+SAdditions.h"

@implementation STestController

- (void)initializeScenarios;
{
    [self addScenario:[KIFTestScenario scenarioToGetArrivalTimeForStop]];
    // Add additional scenarios you want to test here
}

@end
