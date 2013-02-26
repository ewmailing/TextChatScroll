//
//  ViewController.m
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import "ViewController.h"
#import "MessageCell.h"
#import "WEPopoverController.h"
#import "WEPopoverContainerView.h"
#import "ImagePickerViewController.h"

#import "PopOverDelegate.h"
#import "TextHistoryDelegate.h"


@interface ViewController ()
{
//	NSArray *recipeImages;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (assign, nonatomic, getter=isPlusMenuActive) BOOL plusMenuActive;
@property (nonatomic, retain) WEPopoverController* menuPopoverController;
@property (nonatomic, retain) PopOverDelegate* popOverDelegate;
//@property (nonatomic, retain) TextHistoryDelegate* textHistoryDelegate;
// If I don't retain this, it seems to go away immediately.
@property (retain, nonatomic) IBOutlet TextHistoryDelegate *textHistoryDelegate;


@property (weak, nonatomic) IBOutlet UIView* myCanvasView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UINib *cellNib = [UINib nibWithNibName:@"MessageCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MessageCell"];
	UINib *cellNib_end = [UINib nibWithNibName:@"MessageCellEnd" bundle:nil];
	[self.collectionView registerNib:cellNib_end forCellWithReuseIdentifier:@"MessageCellEnd"];
	
	[self.collectionView setAllowsSelection:YES];
	[[self textHistoryDelegate] setMyCanvasView:[self myCanvasView]];
	NSManagedObjectContext* managed_object_context = [self managedObjectContext];
	[[self textHistoryDelegate] setManagedObjectContext:managed_object_context];
	[[self textHistoryDelegate] setCollectionView:self.collectionView];

//	[self setTextHistoryDelegate:[[TextHistoryDelegate alloc] init]];
//	[[self collectionView] setDelegate:[self textHistoryDelegate]];
	
    // Initialize recipe image array
/*
    recipeImages = [NSArray arrayWithObjects:@"angry_birds_cake.jpg", @"creme_brelee.jpg", @"egg_benedict.jpg", @"full_breakfast.jpg", @"green_tea.jpg", @"ham_and_cheese_panini.jpg", @"ham_and_egg_sandwich.jpg", @"hamburger.jpg", @"instant_noodle_with_egg.jpg", @"japanese_noodle_with_pork.jpg", @"mushroom_risotto.jpg", @"noodle_with_bbq_pork.jpg", @"starbucks_coffee.jpg", @"thai_shrimp_cake.jpg", @"vegetable_curry.jpg", @"white_chocolate_donut.jpg", nil];
	
*/
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (void) setCollectionViewDelegate:(id<UICollectionViewDelegate>)the_delegate
{
	[[self collectionView] setDelegate:the_delegate];
	_collectionViewDelegate = the_delegate;
}
 */

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSNumber numberWithInteger:1] forKey:@"messageOrder"];
	NSLog(@"New managed object, %@", newManagedObject);
    /*
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	 */
	
}


- (IBAction) onPlusPress:(id)the_sender
{
	NSLog(@"onPlusPress");
	[self insertNewObject:the_sender];
#if 0
	//	[UIView setAnimationDuration:1.0];
	//  someview.transform = CGAffineTransformMakeRotation(angle);
	//    [UIView commitAnimations]
	CGRect plus_button_rect = [the_sender frame];
//	plus_button_rect = CGRectMake(20, 498, 30, 30);
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
		[image_view_controller setCollectionViewDelegate:image_view_controller];
		//		[self presentModalViewController:image_view_controller animated:YES];
		//		return;
		self.menuPopoverController = [[WEPopoverController alloc] initWithContentViewController:image_view_controller];
		
		self.menuPopoverController.delegate = self.popOverDelegate;
		
		self.popOverDelegate.menuPopoverController = self.menuPopoverController;
		self.popOverDelegate.myCanvasView = self.myCanvasView;
		

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
													inView:self.myCanvasView
								  permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown|
															UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight)
												  animated:YES];
		
	} else {
		[self.menuPopoverController dismissPopoverAnimated:YES];
		[self.popOverDelegate cleanupMenuPopover];
		self.popOverDelegate = nil;
		self.menuPopoverController = nil;
	}
	
#endif
	
}


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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"messageOrder" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

/*

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
*/
@end
