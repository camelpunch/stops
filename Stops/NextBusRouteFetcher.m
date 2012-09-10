#import "NextBusRouteFetcher.h"
#import "DirectionRecipient.h"
#import "Direction.h"
#import "Stop.h"

@implementation NextBusRouteFetcher
{
    BOOL theParseFinished;
    Direction *theCurrentDirection;
    NSMutableDictionary *theStopNames;
    NSMutableArray *theStops;
}
@synthesize delegate;

- (void)fetchRoute:(NSString *)aRoute
{
    [self resetParser];
    
    NSURL *url = [NSURL URLWithString:[@"http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=sf-muni&r=" stringByAppendingString:aRoute]];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser parse];
}

- (void)fetchStopsForDirection:(Direction *)aDirection
{
    if (theParseFinished) {
        NSMutableArray *filteredStops = [[NSMutableArray alloc] init];
        for (Stop *stop in theStops) {
            if ([stop.direction isEqual:aDirection]) {
                [filteredStops addObject:stop];
            }
        }
        [self.delegate addStops:filteredStops];
    }
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"stop"] && [attributeDict objectForKey:@"title"]) {
        [theStopNames setObject:[attributeDict objectForKey:@"title"]
                         forKey:[attributeDict objectForKey:@"tag"]];
    } else if ([elementName isEqualToString:@"stop"]) {
        NSString *stopTag = [attributeDict objectForKey:@"tag"];
        [theStops addObject:[[Stop alloc] initWithName:[theStopNames objectForKey:stopTag]
                                             direction:theCurrentDirection
                                                   tag:stopTag]];
    } else if ([elementName isEqualToString:@"direction"]) {
        Direction *direction = [Direction directionNamed:[attributeDict objectForKey:@"title"]];
        theCurrentDirection = direction;
        [self.delegate addDirection:direction];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"route"]) {
        theParseFinished = YES;
    }
}

#pragma mark private

- (void)resetParser
{
    theParseFinished = NO;
    theStopNames = [[NSMutableDictionary alloc] init];
    theStops = [[NSMutableArray alloc] init];
    theCurrentDirection = nil;
}

@end
