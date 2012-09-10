#import "Kiwi.h"
#import "Prediction.h"

SPEC_BEGIN(PredictionSpec)

describe(@"a Prediction value", ^{
    it(@"has a date", ^{
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
        Prediction *prediction = [Prediction predictionWithDate:date];
        [[prediction.date should] equal:date];
    });
});

SPEC_END
