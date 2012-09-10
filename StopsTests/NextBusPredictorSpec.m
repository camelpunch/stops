#import "Kiwi.h"
#import <OCMockObject.h>
#import "NextBusPredictor.h"
#import "PredictionRecipient.h"
#import "FakePredictionRecipient.h"
#import "Stop.h"
#import "Direction.h"

SPEC_BEGIN(NextBusPredictorSpec)

describe(@"NextBus predictor", ^{
    describe(@"a valid request", ^{
        it(@"calls the delegate with a prediction for a route and stop", ^{
            FakePredictionRecipient *recipient = [[FakePredictionRecipient alloc] init];
            NextBusPredictor *predictor = [[NextBusPredictor alloc] init];
            predictor.delegate = recipient;
            
            Direction *outbound = [Direction directionNamed:@"Outbound"];
            Stop *judsonAndGennessee = [[Stop alloc] initWithName:@"Judson and Gennessee"
                                                        direction:outbound
                                                              tag:@"5171"];
            
            NSDate *tenHoursFromNow = [NSDate dateWithTimeIntervalSinceNow:(60 * 60 * 10)];
            NSDate *now = [NSDate date];
            
            [predictor predictArrivalOnRoute:@"43" atStop:judsonAndGennessee];
            [[expectFutureValue(recipient.receivedPrediction) shouldEventually] beKindOfClass:[Prediction class]];
            [[expectFutureValue(recipient.receivedPrediction.date) shouldEventually] beBetween:now and:tenHoursFromNow];
        });
    });
    
    describe(@"an invalid request", ^{
        it(@"does not call the delegate with a prediction", ^{
            FakePredictionRecipient *recipient = [[FakePredictionRecipient alloc] init];
            NextBusPredictor *predictor = [[NextBusPredictor alloc] init];
            predictor.delegate = recipient;
            
            Direction *nowhere = [Direction directionNamed:@"Going nowhere"];
            Stop *invalidStop = [[Stop alloc] initWithName:@"Blah blah blah"
                                                 direction:nowhere
                                                       tag:@"234123412341234"];
            
            [predictor predictArrivalOnRoute:@"234234" atStop:invalidStop];
            [[expectFutureValue(recipient.receivedPrediction) shouldEventually] beNil];
        });
    });
});

SPEC_END
