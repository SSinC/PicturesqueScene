//
//  CityCollectionViewController.m
//  PicturesqueScene
//
//  Created by Sara on 5/20/14.
//  Copyright (c) 2014 Stan. All rights reserved.
//

#import "CityCollectionViewController.h"
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
    [self performSelector:@selector(delayButtonClick:) withObject:nil afterDelay:0.2];

    
}

- (void)delayButtonClick :(id)sender
{
    [_delegate  ButtonClicked:sender ];
    _iconHighLighted = NO;
}
@end

@interface CityCollectionViewController ()
{
    UIImageView*        _titieIcon;
    UILabel*            _titleLabel;
    UIView *            _line;
    UICollectionView*   _collectionView;
}
@end

@implementation CityCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)init
{
    self = [super init];
    
    if (self) {
        //todo
        self.view.layer.cornerRadius = self.view.frame.size.width/4.f;
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
        
        _titieIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city_icon.png"]];
        _titieIcon.frame = CGRectMake(122.0f, 24.0f, 22.0f, 22.0f);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_titleLabel setText:@"城市管理"];
     //   CGSize sz = [_titleLabel.text sizeWithAttributes:@{NSFontAttributeName:labelTitle.font}];
      //  _titleLabel.frame = CGRectMake(cityIcon.frame.origin.x + cityIcon.frame.size.width + 5.0, 24, sz.width,sz.height );
        [_titleLabel setTextColor:[UIColor whiteColor]];
        //    [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _line = [[UIView alloc]initWithFrame:CGRectMake(18, 68, self.view.frame.size.width - 36, 1)];
        _line.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    }
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



#pragma mark - collection view delefate



@end
