//
//  TextHistoryDelegate.m
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import "TextHistoryDelegate.h"
#import "MessageCell.h"

#import "WEPopoverController.h"
#import "WEPopoverContainerView.h"
#import "ImagePickerViewController.h"
#import "PopOverDelegate.h"

@interface TextHistoryDelegate ()
@property (nonatomic, retain) WEPopoverController* menuPopoverController;
@property (nonatomic, retain) PopOverDelegate* popOverDelegate;

@end
@implementation TextHistoryDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	//    return recipeImages.count;
	// I'm confused; the order is backwards from what I thought it would be.
	if(section == 0)
	{
		return 1;
	}
	else if(section == 1)
	{
		return 2;
	}
	else
	{
		return 0;
	}
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"indexPath: %@, %d", indexPath, [indexPath indexAtPosition:1]);
    static NSString *identifier = @"MessageCell";
    static NSString *identifierend = @"MessageCellEnd";
    
	//   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UICollectionViewCell* cell;
	if([indexPath indexAtPosition:1] == 1)
	{
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierend forIndexPath:indexPath];
		MessageCell* message_cell = (MessageCell*)cell;
		UIImageView* image_view = [message_cell imageView];
		image_view.image = [UIImage imageNamed:@"hamburger.jpg"];
		
		[image_view setUserInteractionEnabled:YES];
		UITapGestureRecognizer* single_tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
		[single_tap setNumberOfTapsRequired:1];
		[image_view addGestureRecognizer:single_tap];
	}
	else
	{
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
		MessageCell* message_cell = (MessageCell*)cell;
		UIImageView* image_view = [message_cell imageView];
		image_view.image = [UIImage imageNamed:@"egg_benedict.jpg"];
		
		[image_view setUserInteractionEnabled:YES];
		UITapGestureRecognizer* single_tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
		[single_tap setNumberOfTapsRequired:1];
		[image_view addGestureRecognizer:single_tap];
		
	}
	
    /*
	 UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
	 recipeImageView.image = [UIImage imageNamed:[recipeImages objectAtIndex:indexPath.row]];
	 //    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
	 */
	
    return cell;
}



-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    NSLog(@"image click");
	[self onPlusPress:[recognizer view]];
}

#if 1
- (IBAction) onPlusPress:(id)the_sender
{
	//	[UIView setAnimationDuration:1.0];
	//  someview.transform = CGAffineTransformMakeRotation(angle);
	//    [UIView commitAnimations]
	CGRect plus_button_rect = [the_sender frame];
//		plus_button_rect = CGRectMake(20, 498, 30, 30);
	/*
	 CGRect plus_button_rect = [[self plusButton] frame];
	 CGFloat button_angle;
	 if([self isPlusMenuActive] == NO)
	 {
	 button_angle = M_PI/4;
	 [self setPlusMenuActive:YES];
	 
	 }
	 else
	 {
	 button_angle = 0.0;
	 [self setPlusMenuActive:NO];
	 
	 }
	 
	 [UIView animateWithDuration:.25
	 delay:0
	 options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction)
	 animations:^{
	 [[self plusButton] setTransform:CGAffineTransformMakeRotation(button_angle)];
	 }
	 completion:^(BOOL finished) { }
	 ];
	 */
	
	
	if (!self.menuPopoverController)
	{
		
		
		self.popOverDelegate = [[PopOverDelegate alloc] init];
		ImagePickerViewController* image_view_controller = [[ImagePickerViewController alloc] init];
//		[[image_view_controller view] setBounds:CGRectMake(0, 0, 220, 220)];
		[image_view_controller setCollectionViewDelegate:image_view_controller];
		//		[self presentModalViewController:image_view_controller animated:YES];
		//		return;
		self.menuPopoverController = [[WEPopoverController alloc] initWithContentViewController:image_view_controller];
		
		self.menuPopoverController.delegate = self.popOverDelegate;
		
		self.popOverDelegate.menuPopoverController = self.menuPopoverController;
		self.popOverDelegate.myCanvasView = self.myCanvasView;
		

		[image_view_controller setContentSizeForViewInPopover:CGSizeMake(320, 110)];
		//		self.menuPopoverController.passthroughViews = [NSArray arrayWithObject:self.navigationController.navigationBar];
		
		/*
		 NSArray *segmentedItems = [NSArray arrayWithObjects:@"Bookmarks", @"Recents", @"Contacts", nil];
		 UISegmentedControl *ctrl = [[UISegmentedControl alloc] initWithItems:segmentedItems];
		 ctrl.segmentedControlStyle = UISegmentedControlStyleBar;
		 ctrl.selectedSegmentIndex = 0;
		 
		 UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:ctrl];
		 ctrl.frame = CGRectMake(0.0f, 5.0f, 320.0f, 30.0f);
		 
		 NSArray *theToolbarItems = [NSArray arrayWithObjects:item, nil];
		 [image_view_controller setToolbarItems:theToolbarItems];
		 //	[ctrl release];
		 //	[item release];
		 */
		
		/*
		 [self.menuPopoverController presentPopoverFromBarButtonItem:the_sender
		 permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
		 animated:YES];
		 */
		[self.menuPopoverController presentPopoverFromRect:plus_button_rect
													inView:the_sender
//													inView:self.myCanvasView
								  permittedArrowDirections:(UIPopoverArrowDirectionDown|UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight)
//								  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown|
//															UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight)
												  animated:YES];
		
	} else {
		[self.menuPopoverController dismissPopoverAnimated:YES];
		[self.popOverDelegate cleanupMenuPopover];
		self.popOverDelegate = nil;
		self.menuPopoverController = nil;
	}
	
	
	
}
#endif




@end
