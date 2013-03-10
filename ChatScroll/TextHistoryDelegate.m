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

#import "PTPusherChannel.h"

#import <objc/runtime.h>
static NSString * kAssociatedMessageCellForSubmitButton = @"kAssociatedMessageCellForSubmitButton";
static NSString * kAssociatedEntityForEditButton = @"kAssociatedEntityForEditButton";

@interface TextHistoryDelegate ()
@property (nonatomic, retain) WEPopoverController* menuPopoverController;
@property (nonatomic, retain) PopOverDelegate* popOverDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) NSInteger messageOrderCounter;

@end
@implementation TextHistoryDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	//    return recipeImages.count;
	// I'm confused; the order is backwards from what I thought it would be.
	if(section == 1)
	{
		return 1;
	}
	else if(section == 0)
	{
//		return 2;
//		return [[self.fetchedResultsController sections] count];
		// Only storing one section which contains all history messages.
		/*
		NSArray* sections = [self.fetchedResultsController sections];
		if(nil == sections || 0 == [sections count])
		{
			return 0;
		}

		id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
		NSUInteger number_of_objects = [sectionInfo numberOfObjects];
		 */
		NSUInteger number_of_objects = [self.fetchedResultsController.fetchedObjects count];
		return number_of_objects;

	}
	else
	{
		return 0;
	}
}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 2;
}

- (IBAction) onEndCellSubmit:(id)the_sender
{
	
	NSLog(@"%@", NSStringFromSelector(_cmd));
	MessageCell* message_cell = (MessageCell *)objc_getAssociatedObject(the_sender, &kAssociatedMessageCellForSubmitButton);
	
	UITextView* text_view = [message_cell messageView];
	NSString* message_body = [text_view text];
	[text_view setText:message_body];
	
	[self insertNewObject:the_sender messageBody:message_body messageOrder:[self messageOrderCounter]];
	[self setMessageOrderCounter:[self messageOrderCounter]+1];
	
	[[self chatPusherChannel] triggerEventNamed:@"AddMessage" data:message_body];

	
}
- (IBAction) onHistoryCellSubmit:(id)the_sender
{
	NSLog(@"%@", NSStringFromSelector(_cmd));
	NSManagedObject* managed_object = (NSManagedObject *)objc_getAssociatedObject(the_sender, &kAssociatedEntityForEditButton);

	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	[context deleteObject:managed_object];
	
	
}

- (void)configureCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
	MessageCell* message_cell = (MessageCell*)cell;
	UITextView* text_view = [message_cell messageView];
	NSString* message_body = (NSString*)[object valueForKey:@"messageBody"];
	[text_view setText:message_body];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	NSLog(@"indexPath: %@, %d", indexPath, [indexPath indexAtPosition:1]);
    static NSString *identifier = @"MessageCell";
    static NSString *identifierend = @"MessageCellEnd";

	NSInteger section = [indexPath section];
	NSInteger row = [indexPath row];
	NSLog(@"indexPath: section:%d, row:%d", section, row);

	
	//   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
	UICollectionViewCell* cell;
	if(section == 1)
	{
		cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierend forIndexPath:indexPath];
		MessageCell* message_cell = (MessageCell*)cell;
		UIImageView* image_view = [message_cell imageView];
		image_view.image = [UIImage imageNamed:@"hamburger.jpg"];
		
		[image_view setUserInteractionEnabled:YES];
		UITapGestureRecognizer* single_tap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
		[single_tap setNumberOfTapsRequired:1];
		[image_view addGestureRecognizer:single_tap];
		
		UIButton* submit_button = [message_cell submitButton];
		[submit_button addTarget:self action:@selector(onEndCellSubmit:) forControlEvents:UIControlEventTouchUpInside];

		// I need to get the message text to set on the managed object in the callback.
		// This is kind of ugly, but all the solutions kind of suck since the above doesn't let me pass userdata.
		// Don't retain because there would be a retain cycle since the cell already holds the button.
		objc_setAssociatedObject(submit_button, &kAssociatedMessageCellForSubmitButton, message_cell,
								  OBJC_ASSOCIATION_ASSIGN);

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

		UIButton* submit_button = [message_cell submitButton];
		[submit_button addTarget:self action:@selector(onHistoryCellSubmit:) forControlEvents:UIControlEventTouchUpInside];
		
		[self configureCell:message_cell atIndexPath:indexPath];
		

		NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
		objc_setAssociatedObject(submit_button, &kAssociatedEntityForEditButton, object,
								 OBJC_ASSOCIATION_RETAIN);

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



#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SPMessageItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"messageOrder" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![_fetchedResultsController performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
	NSManagedObject* object = [[_fetchedResultsController fetchedObjects] lastObject];
	NSNumber* number = [object valueForKey:@"messageOrder"];
	[self setMessageOrderCounter:[number integerValue]+1];

	
	
    return _fetchedResultsController;
}



- (void)insertNewObject:(id)sender messageBody:(NSString*)message_body messageOrder:(NSInteger)message_order
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:message_body forKey:@"messageBody"];
    [newManagedObject setValue:[NSNumber numberWithInteger:message_order] forKey:@"messageOrder"];
//    [newManagedObject setValue:[NSNumber numberWithInteger:1] forKey:@"messageOrder"];
	NSLog(@"New managed object, %@", newManagedObject);

	 // Save the context.
	 NSError *error = nil;
	 if (![context save:&error]) {
	 // Replace this implementation with code to handle the error appropriately.
	 // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	 abort();
	 }

	
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
//    [self.collectionView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{

    switch(type) {
        case NSFetchedResultsChangeInsert:
//            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
//            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UICollectionView *collectionView = self.collectionView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
//            [collectionView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
//            [collectionView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[collectionView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
//            [collectionView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [collectionView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [self.collectionView endUpdates];
	
	self.fetchedResultsController = nil;
	[[self collectionView] reloadData];

}


@end
