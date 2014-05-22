//
//  CityCollectionViewController.m
//  PicturesqueScene
//
//  Created by Sara on 5/20/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import "CityCollectionViewController.h"

@implementation CityCollectionViewDataItem
- (id)initWithCityName:(NSString *)city enable:(BOOL)enable
{
    self = [super init];
    if (self) {
        _enable = enable;
        _city = city;
    }
    return self;
}
@end


@interface CityCollectionViewCell()
{
    UIButton*       _iconButton;
    UILabel*        _titleLabel;
    
    BOOL            _isios7Later;
    BOOL            _iconHighLighted;
}
@end

@implementation CityCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = YES;
        _enable = NO;
        _isios7Later = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO;
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.backgroundColor = [UIColor clearColor];
        [_iconButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [_iconButton addTarget:self action:@selector(_onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor whiteColor];
        
        
        
        [self addSubview:_iconButton];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setEnable:(BOOL)enable
{
    if (_enable == enable) {
        return;
    }
    _enable = enable;
    [_iconButton setImage:_enable ? [UIImage imageNamed:@"delete.png.png" ] : [UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    [_titleLabel setText:_title];
}
- (void)layoutSubviews
{
    CGRect rc = self.bounds;
    CGRect rcIcon,rcTitle;
    
    CGSize textsz = _isios7Later ? [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}] : [_titleLabel.text sizeWithFont:_titleLabel.font];
    
    rcIcon = CGRectMake(10, (rc.size.height - 24)/2 , 24, 24);
    rcTitle = CGRectMake(rcIcon.origin.x + rcIcon.size.width + 10, (rc.size.height - textsz.height)/2, textsz.width, textsz.height);
    
    _iconButton.frame = rcIcon;
    _titleLabel.frame = rcTitle;
}

- (void)_onButtonClicked :(id)sender
{
    if (_iconHighLighted) {
        return;
    }
    NSLog(@"CityIconClickDelegate  ButtonClicked ");
    
    _iconHighLighted = YES;
    [self performSelector:@selector(delayButtonClick:) withObject:nil afterDelay:0.2];
    
    
}
- (void)delayButtonClick :(id)sender
{
    [_delegate  ButtonClicked:sender ];
    _iconHighLighted = NO;
}
@end



NSString *reuseId = @"collectionViewCellReuseId";

@interface CityCollectionViewController ()
{
    UIImageView*        _titieIcon;
    UILabel*            _titleLabel;
    UIView *            _line;
    //UICollectionView*   _collectionView;
    cityCollectoinView *      _cityCollectionview;
    
}
@end


@implementation CityCollectionViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  _contentView = [[UIView alloc]initWithFrame:self.view.frame];
    self.view.layer.cornerRadius = 343/4.f;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
    _titieIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_icon.png"]];
    _titieIcon.frame = CGRectMake(122.0f, 24.0f, 22.0f, 22.0f);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18.0];
    _titleLabel.text = @"城市管理";
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize sz = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
    _titleLabel.frame = CGRectMake(_titieIcon.frame.origin.x + _titieIcon.frame.size.width + 5.0, 24, sz.width,sz.height );
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(18, 68, self.view.frame.size.width - 36, 1)];
    _line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(134,24); //24 + 10 +100
    _cityCollectionview = [[cityCollectoinView alloc] initWithFrame:CGRectMake(10, _line.frame.origin.y + _line.frame.size.height + 10 , 300, 200) collectionViewLayout:flowLayout];
    
    
    [self.view addSubview:_titieIcon];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_line];
    [self.view addSubview:_cityCollectionview];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - CityIconClickDelegate

- (void) ButtonClicked :(id)sender;
{
    NSLog(@"CityIconClickDelegate  ButtonClicked ");
    
    //todo
    //add city to show
}
@end


@implementation cityCollectoinView
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.backgroundColor = [UIColor grayColor];
        
        [self registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
        self.alwaysBounceHorizontal = YES;
        self.dataSource = self;
        self.delegate = self;
        
        _dataArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}


#pragma mark - collection view datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.title = @"杭州";
    return cell;
}

#pragma mark - collection view delefate
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"didHighlightItemAtIndexPath");
    
}



@end


#if 0
@interface CityCollectionViewCell()
{
    UIButton*       _iconButton;
    UILabel*        _titleLabel;
    
    BOOL            _isios7Later;
    BOOL            _iconHighLighted;
}
@end

@implementation CityCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _enable = NO;
        _isios7Later = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO;
        
        _iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconButton.backgroundColor = [UIColor clearColor];
        [_iconButton setImage:[UIImage imageNamed:@"删除1.png"] forState:UIControlStateNormal];
        [_iconButton addTarget:self action:@selector(_onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0f];
        _titleLabel.textColor = [UIColor whiteColor];
     
        [self addSubview:_iconButton];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setEnable:(BOOL)enable
{
    if (_enable == enable) {
        return;
    }
    _enable = enable;
    [_iconButton setImage:_enable ? [UIImage imageNamed:@"添加1.png" ] : [UIImage imageNamed:@"删除1.png"] forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    [_titleLabel setText:_title];
}
- (void)layoutSubviews
{
    CGRect rc = self.bounds;
    CGRect rcIcon,rcTitle;
    
    CGSize textsz = _isios7Later ? [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}] : [_titleLabel.text sizeWithFont:_titleLabel.font];

    rcIcon = CGRectMake(10, (rc.size.height - 24)/2 , 24, 24);
    rcTitle = CGRectMake(rcIcon.origin.x + rcIcon.size.width + 10, (rc.size.height - textsz.height)/2, textsz.width, textsz.height);
    
    _iconButton.frame = rcIcon;
    _titleLabel.frame = rcTitle;
}

- (void)_onButtonClicked :(id)sender
{
    if (_iconHighLighted) {
        return;
    }
    _iconHighLighted = YES;
   // [self performSelector:@selector(delayButtonClick:) withObject:nil afterDelay:0.2];

    
}

- (void)delayButtonClick :(id)sender
{
    [_delegate  ButtonClicked:sender ];
    _iconHighLighted = NO;
}
@end

NSString *reuseId = @"collectionViewCellReuseId";

@interface CityCollectionViewController ()
{
    UIImageView*        _titieIcon;
    UILabel*            _titleLabel;
    UIView *            _line;
    UICollectionView*   _collectionView;
    cityCollectoinView *      _cityCollectionview;
   
}
@end


@implementation CityCollectionViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

//- (void)loadView
//{
////    [super loadView];
//    _contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
//    self.view = _contentView;
//    
//    self.view.layer.cornerRadius = 343/4.f;
//    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
//    
//    _titieIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_icon.png"]];
//    _titieIcon.frame = CGRectMake(122.0f, 24.0f, 22.0f, 22.0f);
//    
//    _titleLabel = [[UILabel alloc] init];
//    _titleLabel.font = [UIFont systemFontOfSize:18.0];
//    [_titleLabel setText:@"城市管理"];
//    CGSize sz = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
//    _titleLabel.frame = CGRectMake(_titieIcon.frame.origin.x + _titieIcon.frame.size.width + 5.0, 24, sz.width,sz.height );
//    [_titleLabel setTextColor:[UIColor whiteColor]];
//    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
//    _titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    _line = [[UIView alloc]initWithFrame:CGRectMake(18, 68, self.view.frame.size.width - 36, 1)];
//    _line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
//    
//    
//    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//    flowLayout.itemSize=CGSizeMake(100,20);
//    
//    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, _line.frame.origin.y + _line.frame.size.height + 10 , 300, 300)  collectionViewLayout:flowLayout];
//    _collectionView.dataSource = self;
//    _collectionView.delegate = self;
//    _collectionView.backgroundColor = [UIColor grayColor];
//    
//    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseId];
//    
//    _collectionView.alwaysBounceHorizontal = YES;
//    
//    
//    [_contentView addSubview:_titieIcon];
//    [_contentView addSubview:_titleLabel];
//    [_contentView addSubview:_line];
//    [_contentView addSubview:_collectionView];
//
//    
//	self.view = _contentView;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     _contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = _contentView;

    self.view.layer.cornerRadius = 343/4.f;
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    
    _titieIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_icon.png"]];
    _titieIcon.frame = CGRectMake(122.0f, 24.0f, 22.0f, 22.0f);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:18.0];
    [_titleLabel setText:@"城市管理"];
    CGSize sz = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:_titleLabel.font}];
     _titleLabel.frame = CGRectMake(_titieIcon.frame.origin.x + _titieIcon.frame.size.width + 5.0, 24, sz.width,sz.height );
    [_titleLabel setTextColor:[UIColor whiteColor]];
    //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _line = [[UIView alloc]initWithFrame:CGRectMake(18, 68, self.view.frame.size.width - 36, 1)];
    _line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    
//    double delayInSeconds = 5.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^{
//        [self lazyLoad];
//    });
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(100,20);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, _line.frame.origin.y + _line.frame.size.height + 10 , 300, 300)  collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor grayColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseId];

    _collectionView.alwaysBounceHorizontal = YES;
    
    
//    _cityCollectionview = [[cityCollectoinView alloc]initWithFrame:CGRectMake(10, _line.frame.origin.y + _line.frame.size.height + 10 , 300, 200) collectionViewLayout:flowLayout];
    
//    [self.view addSubview:_contentView];
    
    [self.view addSubview:_titieIcon];
    [self.view addSubview:_titleLabel];
    [self.view addSubview:_line];
    [self.view addSubview:_collectionView];
    
    NSLog(@"dataSource:%@",_collectionView.dataSource);
    NSLog(@"delegate:%@",_collectionView.delegate);

   // [self.view addSubview:_cityCollectionview];
    

}

- (void)lazyLoad
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize=CGSizeMake(100,20);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, _line.frame.origin.y + _line.frame.size.height + 10 , 300, 300)  collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor grayColor];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseId];
    
    _collectionView.alwaysBounceHorizontal = YES;
    
    [self.view addSubview:_collectionView];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"_collectionView:%@",_collectionView);

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - collection view datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    NSLog(@"numberOfItemsInSection");
    NSLog(@"_collectionView:%@",_collectionView);

    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"cellForItemAtIndexPath");
    NSLog(@"_collectionView:%@",_collectionView);

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor greenColor];
    //cell.title = @"test cell";
    return cell;
}

#pragma mark - collection view delefate
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"didHighlightItemAtIndexPath");

}

#pragma mark - CityIconClickDelegate

- (void) ButtonClicked :(id)sender;
{
    
}
@end

@implementation cityCollectoinView
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
//        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
//        flowLayout.itemSize=CGSizeMake(20,20);
//        
//        self.collectionViewLayout = flowLayout;
        self.backgroundColor = [UIColor grayColor];
        
        [self registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:reuseId];
        
        self.alwaysBounceHorizontal = YES;

        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
       
    CityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor greenColor];
    cell.title = @"test cell";
    return cell;
}

#pragma mark - collection view delefate
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"didHighlightItemAtIndexPath");
    
}



@end
#endif