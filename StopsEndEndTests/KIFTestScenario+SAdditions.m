#import "KIFTestScenario+SAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+SAdditions.h"

@implementation KIFTestScenario (SAdditions)

+ (id)scenarioToGetArrivalTimeForStop
{
    KIFTestScenario *scenario =
    [KIFTestScenario scenarioWithDescription:@"A user can get the arrival time for a stop."];
    
    [scenario addStep:
     [KIFTestStep stepToReset]];
    
    [scenario addStep:
     [KIFTestStep stepToEnterText:@"22"
   intoViewWithAccessibilityLabel:@"Enter Route"]];
    
    [scenario addStep:
     [KIFTestStep stepToTapViewWithAccessibilityLabel:@"Find"]];
    [scenario addStep:
     [KIFTestStep stepToTapViewWithAccessibilityLabel:@"Outbound to Potrero Hill"]];
    [scenario addStep:
     [KIFTestStep stepToSelectPickerViewRowWithTitle:@"Fillmore St & North Point St"]];
    
    [scenario addStep:
     [KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Arrival Time"]];
    
    return scenario;
}

@end
