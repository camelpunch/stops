#import "DirectionsFetcher.h"
#import "DirectionRecipient.h"
#import "Direction.h"

@implementation DirectionsFetcher
@synthesize delegate;

- (void)fetchDirectionsForRouteName:(NSString *)route
{
    NSURL *url = [NSURL URLWithString:[@"http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=sf-muni&r=" stringByAppendingString:route]];
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
    if ([elementName isEqualToString:@"direction"]) {
        NSString *directionName = [attributeDict objectForKey:@"title"];
        Direction *direction = [[Direction alloc] initWithName:directionName];
        [self.delegate addDirection:direction];
    }
}

@end
