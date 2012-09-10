#import "FakePredictionRecipient.h"

@implementation FakePredictionRecipient

- (void)expectPrediction:(Prediction *)aPrediction
{
    
}

- (void)receivePrediction:(Prediction *)aPrediction
{
    self.receivedPrediction = aPrediction;
}

@end
