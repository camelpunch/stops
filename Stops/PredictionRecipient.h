#import <Foundation/Foundation.h>
#import "Prediction.h"

@protocol PredictionRecipient <NSObject>

- (void)receivePrediction:(Prediction *)aPrediction;

@end
