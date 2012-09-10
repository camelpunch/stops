#import "NextBusPredictor.h"
#import "PredictionRecipient.h"
#import "Prediction.h"
#import "Stop.h"

@implementation NextBusPredictor
{
    BOOL theParseFinished;
    NSURL *theBaseURL;
}
@synthesize delegate;

+ (id)predictorWithBaseURL:(NSURL *)aURL
{
    return [[NextBusPredictor alloc] initWithBaseURL:aURL];
}

- (id)initWithBaseURL:(NSURL *)aURL
{
    self = [super init];
    if (self) {
        theBaseURL = aURL;
    }
    return self;
}

- (void)predictArrivalOnRoute:(NSString *)aRouteName
                       atStop:(Stop *)aStop
{
    [self resetParser];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=sf-muni&r=%@&s=%@", aRouteName, aStop.tag]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"prediction"]) {
        double epochTime = [[attributeDict objectForKey:@"epochTime"] doubleValue] / 1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:epochTime];
        Prediction *prediction = [Prediction predictionWithDate:date];
        [self.delegate receivePrediction:prediction];
    }
}

#pragma mark private

- (void)resetParser
{
    theParseFinished = NO;
}

@end
