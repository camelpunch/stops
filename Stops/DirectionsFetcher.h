#import <Foundation/Foundation.h>
#import "HTTPRequester.h"

@protocol DirectionRecipient;
@class HTTP;

@interface DirectionsFetcher : NSObject<NSXMLParserDelegate>

@property (weak, nonatomic) id<DirectionRecipient> delegate;
- (void)fetchDirectionsForRouteName:(NSString *)route;

@end
