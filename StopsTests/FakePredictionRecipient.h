#import "PredictionRecipient.h"

@interface FakePredictionRecipient : NSObject<PredictionRecipient>

- (void)expectPrediction:(Prediction *)aPrediction;
@property (strong, nonatomic) Prediction *receivedPrediction;

@end
