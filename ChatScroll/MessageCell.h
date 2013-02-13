//
//  MessageCell.h
//  ChatScroll
//
//  Created by Eric Wing on 2/11/13.
//
//

#import <UIKit/UIKit.h>

@interface MessageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextView *messageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
