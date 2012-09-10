#import "Prediction.h"

@implementation Prediction

+ (id)predictionWithDate:(NSDate *)aDate
{
    return [[Prediction alloc] initWithDate:aDate];
}

- (id)initWithDate:(NSDate *)aDate
{
    self = [super init];
    if (self) {
        _date = aDate;
    }
    return self;
}

@end
