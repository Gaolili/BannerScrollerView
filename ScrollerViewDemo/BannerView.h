

#import <UIKit/UIKit.h>

@interface BannerView : UIView
-(instancetype)initWithFrame:(CGRect)frame animation:(BOOL)animation isURLImage:(BOOL)isURLImage;
@property (nonatomic,strong)NSArray * imageArr;
@end
