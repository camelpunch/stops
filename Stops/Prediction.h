#import <Foundation/Foundation.h>

@interface Prediction : NSObject

+ (id)predictionWithDate:(NSDate *)aDate;

@property (strong, nonatomic) NSDate *date;

@end
