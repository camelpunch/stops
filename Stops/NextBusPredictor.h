#import "Predictor.h"

@interface NextBusPredictor : NSObject<Predictor,NSXMLParserDelegate>

+ (id)predictorWithBaseURL:(NSURL *)aURL;

@end
