//
//  ChatPusher.m
//  ChatScroll
//
//  Created by Eric Wing on 3/10/13.
//
//

#import "ChatPusher.h"
#import "PTPusher.h"
#import "PusherDelegate.h"

@interface ChatPusher ()
@property(strong, nonatomic) PTPusher* pusherClient;
@property(strong, nonatomic) PusherDelegate* pusherDelegate;

@end

@implementation ChatPusher

+ (id) sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance = nil;
    dispatch_once(&once, ^
	{
        sharedInstance = [[ChatPusher alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
	self = [super init];
	if(nil != self)
	{
		
		_pusherDelegate = [[PusherDelegate alloc] init];
		// Probably should turn on encryption for shipping?
		_pusherClient = [PTPusher pusherWithKey:@"c469725779f600fe938d" delegate:_pusherDelegate encrypted:NO];
		_pusherClient.authorizationURL = [NSURL URLWithString:@"http://httpbin.org/basic-auth/:user/:passwd"];

		
		[_pusherClient connect];

		
	}
	return self;
}

- (PTPusher*) pusherInstance
{
	return [self pusherClient];
}

@end
