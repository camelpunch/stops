#import <Foundation/Foundation.h>

@protocol DirectionRecipient;

@interface DirectionsFetcher : NSObject<NSXMLParserDelegate>

@property (weak, nonatomic) id<DirectionRecipient> delegate;
- (void)fetchDirectionsForRouteName:(NSString *)route;

@end
