@class Stop;
@protocol PredictionRecipient;

@protocol Predictor <NSObject>

- (void)predictArrivalOnRoute:(NSString *)aRouteName
                       atStop:(Stop *)aStop;
@property (weak, nonatomic) id<PredictionRecipient> delegate;

@end
