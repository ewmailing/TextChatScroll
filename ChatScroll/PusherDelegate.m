//
//  PusherDelegate.m
//  ChatScroll
//
//  Created by Eric Wing on 3/9/13.
//
//

#import "PusherDelegate.h"
#import "PTPusher.h"
#import "PTPusherErrors.h"
#import "PTPusherEvent.h"
#import "PTPusherChannel.h"

@implementation PusherDelegate

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@", [error localizedDescription]);

}
- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
	NSLog(@"%@", NSStringFromSelector(_cmd));

}
- (void)pusher:(PTPusher *)pusher connectionDidDisconnect:(PTPusherConnection *)connection
{
	NSLog(@"%@", NSStringFromSelector(_cmd));

}



- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@", [error localizedDescription]);

}


- (void)pusher:(PTPusher *)pusher connectionWillReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
}

- (void)pusher:(PTPusher *)pusher willAuthorizeChannelWithRequest:(NSMutableURLRequest *)request
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@", request);

}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@", [channel name]);

	
}

- (void)pusher:(PTPusher *)pusher didUnsubscribeFromChannel:(PTPusherChannel *)channel
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	
}
- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@", [error localizedDescription]);

	
	
}
- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSLog(@"%@", [errorEvent message]);

}


@end
