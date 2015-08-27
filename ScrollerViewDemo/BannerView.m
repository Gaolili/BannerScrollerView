

#import "BannerView.h"


@interface BannerView ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl * _pageControl;
    NSTimer * _timer; //定时器
    BOOL _animation;
    BOOL _isURLImage;
    NSMutableArray * _totalImageArr;
}

@end
@implementation BannerView
-(instancetype)initWithFrame:(CGRect)frame animation:(BOOL)animation isURLImage:(BOOL)isURLImage;
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageArr = [NSArray array];
        _totalImageArr = [NSMutableArray array];
        _animation = animation;
        _isURLImage = isURLImage;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.contentOffset = (animation) ? CGPointMake(CGRectGetWidth(_scrollView.bounds), 0) :CGPointMake(0, 0);
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, CGRectGetHeight(_scrollView.bounds) - 30, CGRectGetWidth(_scrollView.bounds), 30);
        [self addSubview:_pageControl];
        
        if (_animation) {
            [self startTimer];
        }
        
       }
    return self;
}

- (void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    
    [_totalImageArr addObject:[_imageArr lastObject]];
    [_imageArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_totalImageArr addObject:_imageArr[idx]];
    }];
    [_totalImageArr addObject:[_imageArr firstObject]];
    
    NSInteger totalCount = (_animation) ? _totalImageArr.count : _totalImageArr.count - 2;
    
    for (int i=0; i< totalCount; i++) {
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(i *CGRectGetWidth(_scrollView.bounds), 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds))];
        iv.contentMode = UIViewContentModeScaleAspectFill;
       
        if (_isURLImage) {//网络图片
            NSString *path = (_animation) ?_totalImageArr[i] :_totalImageArr[i+1];
            NSURL * url = [NSURL URLWithString:path];
            iv.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
         }else{
            iv.image = (_animation) ?[UIImage imageNamed:_totalImageArr[i]] :[UIImage imageNamed:_totalImageArr[i+1]];
        }
        [_scrollView addSubview:iv];
        
        
    }
    _pageControl.numberOfPages = _totalImageArr.count - 2;
    _pageControl.tintColor = [UIColor greenColor];
    _scrollView.contentSize = CGSizeMake(totalCount * CGRectGetWidth(_scrollView.bounds), 0);
    [self gotoMainButton];
    
}

- (void)gotoMainButton{
    if (!_animation) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(_scrollView.bounds.size.width * (_totalImageArr.count - 2) - 130.0f, CGRectGetWidth(_scrollView.bounds) - 100.0, 60.0f, 30.0f);
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [button setTitle:@"进入" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor yellowColor];
        [_scrollView addSubview:button];
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_animation) {
        CGPoint offset = [_scrollView contentOffset];
        if (offset.x ==0) {
            [_scrollView setContentOffset:CGPointMake((_totalImageArr.count-2)  * CGRectGetWidth(_scrollView.bounds), 0) animated:NO];
        }
        if (offset.x + CGRectGetWidth(_scrollView.bounds) == _scrollView.contentSize.width) {
            [_scrollView setContentOffset:CGPointMake( CGRectGetWidth(_scrollView.bounds), 0) animated:NO];
        }
       
    }
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(_scrollView.bounds);
    _pageControl.currentPage = (_animation) ? page - 1 :page ;

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_animation) {
        CGPoint offset = [_scrollView contentOffset];
        if (offset.x + CGRectGetWidth(_scrollView.bounds) == _scrollView.contentSize.width) {
            _scrollView.contentOffset = CGPointMake( CGRectGetWidth(_scrollView.bounds), 0);
        }
        NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(_scrollView.bounds);
        _pageControl.currentPage = page - 1 ;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_animation) {
        [self stopTimer];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (_animation) {
        [self startTimer];
    }
}

#pragma mark - Timer
- (void)startTimer{
    [self stopTimer];
    if (_timer) {
        [_timer fire];
    }else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(circleImage) userInfo:nil repeats:YES];
    }
}

-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

-(void)circleImage{
   
    CGPoint newOffset = CGPointMake(_scrollView.contentOffset.x + CGRectGetWidth(_scrollView.bounds), 0);
    [_scrollView setContentOffset:newOffset animated:YES];
    
}
@end
