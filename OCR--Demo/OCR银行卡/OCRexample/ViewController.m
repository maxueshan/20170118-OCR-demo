//
//  ViewController.m
//  demo4bank
//
//  Created by kubo on 2016/11/9.
//  Copyright © 2016年 kubo. All rights reserved.
//

#import "ViewController.h"
#import<QuartzCore/QuartzCore.h>

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#define IS_IPHONE       ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define SMALL_SCREEN    ([UIScreen mainScreen].bounds.size.width - 320 < 1)
#define LARGE_SCREEN    (abs((int)[UIScreen mainScreen].bounds.size.width - 414) < 1)

#define UIColorFromRGBA(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.2]

#define STATUS_BAR_HEIGHT 20
#define NAV_BAR_HIGHT  44

#define LEFT_MARGIN     (SMALL_SCREEN ? 20 : 40)
#define RIGHT_MARGIN    (SMALL_SCREEN ? 20 : 40)

#define RECO_BUTTON_WIDTH              (SCREEN_WIDTH/5)
#define RECO_BUTTON_HEIGHT             (RECO_BUTTON_WIDTH)
#define RECO_BUTTON_LABEL_HEIGHT       (30)
#define RECO_BUTTON_MARGIN_VER         (10)
#define RECO_BUTTON_LABEL_MARGIN       (RECO_BUTTON_WIDTH)

#define LEFTVIEW_WIDTH                  (LARGE_SCREEN ? 65 : 60)

@interface ViewController () <UITextFieldDelegate>
{
    UIView *btnBackground;
    UILabel *btnLabel;
    UIButton *recoBtn;
    
    UIImageView * cardImageView;
    UIImageView *fullImageView;
    
    UIView *infoBackground;
    
    UIView * cardNumView;
    UITextField *cardNumValue;
    
    UITextField * bankNameValue;
    UITextField * cardNameValue;
    UITextField * cardTypeValue;
    UITextField * validValue;
    
    UIButton *okBtn;
}
@end

@implementation ViewController
@synthesize BANKInfo;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //关闭scrollView自动调整
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *customNavi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    customNavi.backgroundColor = UIColorFromRGBA(0x1e82d2,1);
    UILabel *customTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    customTitle.backgroundColor = [UIColor clearColor];
    [customTitle setTextColor:[UIColor whiteColor]];
    [customTitle setText:@"银行卡识别"];
    [customTitle setTextAlignment:NSTextAlignmentCenter];
    customTitle.font = [UIFont boldSystemFontOfSize:20];
    [customNavi addSubview:customTitle];
    [self.view addSubview:customNavi];
    
    [self createUI];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}

- (void) hideKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)createUI
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat borderWidth = scale > 0.0 ? 1.0 / scale : 1.0;
    CGFloat labelHeight = IS_IPHONE ? 30 : 60;
    if (LARGE_SCREEN) {
        labelHeight = 40;
    }
    CGFloat labelMarginVer = IS_IPHONE ? 10 : 25;
    if (LARGE_SCREEN) {
        labelMarginVer = 15;
    }
    
    UIScrollView * scr = [[UIScrollView alloc] initWithFrame:CGRectMake(0,STATUS_BAR_HEIGHT+NAV_BAR_HIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [scr setBackgroundColor:UIColorFromRGBA(0xf3f3f3,1)];
    [self.view addSubview: scr];
    
    /*for dismiss keyboard*/
    UIView *backView = [[UIView alloc] initWithFrame:scr.frame];
    [backView setBackgroundColor:[UIColor clearColor]];
    [scr addSubview:backView];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGr.cancelsTouchesInView = NO;
    [backView addGestureRecognizer:tapGr];
    
    UILabel *lbl;
    CALayer *border;
    float lastY = 10;
    float localWidth = SCREEN_WIDTH-LEFT_MARGIN-RIGHT_MARGIN;
    
    /*信息*/
    infoBackground = [[UIView alloc]initWithFrame:CGRectMake(0, lastY, SCREEN_WIDTH, 0)];
    infoBackground.backgroundColor = [UIColor whiteColor];
    [scr addSubview:infoBackground];
    CGRect infoFrame;
    float lastInfoY = 0;
    /*提示文字+识别按钮*/
    btnBackground = [[UIView alloc]initWithFrame:CGRectMake(LEFT_MARGIN, lastInfoY, localWidth, RECO_BUTTON_HEIGHT+RECO_BUTTON_MARGIN_VER+RECO_BUTTON_LABEL_HEIGHT)];
    btnBackground.backgroundColor = [UIColor clearColor];
    [infoBackground addSubview:btnBackground];
#pragma mark  --启动按钮
    //按钮
    recoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, RECO_BUTTON_MARGIN_VER, RECO_BUTTON_WIDTH, RECO_BUTTON_HEIGHT)];
    [recoBtn setBackgroundColor:[UIColor redColor]];
    [recoBtn setBackgroundImage:[UIImage imageNamed:@"BankBtn"] forState:UIControlStateNormal];
    [recoBtn addTarget:self action:@selector(launchCameraView:) forControlEvents:UIControlEventTouchUpInside];
    recoBtn.center = CGPointMake(btnBackground.frame.size.width/2, recoBtn.center.y);
    [btnBackground addSubview:recoBtn];
    //提示文字
    btnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, btnBackground.frame.size.width, RECO_BUTTON_LABEL_HEIGHT)];
    btnLabel.textAlignment = NSTextAlignmentCenter;
    if (LARGE_SCREEN) {
        btnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0];
    } else {
        btnLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];
    }
    btnLabel.text = @"点击图片识别银行卡";
    btnLabel.textColor = UIColorFromRGBA(0x999999,1);
    btnLabel.center = CGPointMake(btnBackground.frame.size.width/2, btnBackground.frame.size.height-RECO_BUTTON_LABEL_HEIGHT/2);
    [btnBackground addSubview:btnLabel];
    
    lastInfoY += btnBackground.frame.size.height + 10;
    infoFrame = btnBackground.frame;
    infoFrame.size.height = lastInfoY;
    btnBackground.frame = infoFrame;
    //银行卡号
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //        lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  卡号";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //卡号分隔线
    border = [CALayer layer];
    border.frame = CGRectMake(LEFTVIEW_WIDTH*7/8, labelHeight/4, borderWidth, labelHeight/2);
    border.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:border];
    
    cardNumValue = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastInfoY, localWidth, labelHeight)];
    cardNumValue.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    cardNumValue.layer.borderWidth = borderWidth;
    cardNumValue.delegate = self;
    cardNumValue.leftViewMode = UITextFieldViewModeAlways;
    cardNumValue.leftView = lbl;
    cardNumValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cardNumValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        cardNumValue.backgroundColor = [UIColor greenColor];
    [infoBackground addSubview:cardNumValue];
    
    lastInfoY += cardNumValue.frame.size.height+labelMarginVer;
    infoFrame = infoBackground.frame;
    infoFrame.size.height = lastInfoY;
    infoBackground.frame = infoFrame;
    //银行名称
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //        lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  银行";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //银行分隔线
    border = [CALayer layer];
    border.frame = CGRectMake(LEFTVIEW_WIDTH*7/8, labelHeight/4, borderWidth, labelHeight/2);
    border.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:border];
    
    bankNameValue = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastInfoY, localWidth, labelHeight)];
    bankNameValue.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    bankNameValue.layer.borderWidth = borderWidth;
    bankNameValue.delegate = self;
    bankNameValue.leftViewMode = UITextFieldViewModeAlways;
    bankNameValue.leftView = lbl;
    bankNameValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    bankNameValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        bankNameValue.backgroundColor = [UIColor greenColor];
    [infoBackground addSubview:bankNameValue];
    
    lastInfoY += bankNameValue.frame.size.height+labelMarginVer;
    infoFrame = infoBackground.frame;
    infoFrame.size.height = lastInfoY;
    infoBackground.frame = infoFrame;
    //卡名称
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //        lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  名称";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //名称分隔线
    border = [CALayer layer];
    border.frame = CGRectMake(LEFTVIEW_WIDTH*7/8, labelHeight/4, borderWidth, labelHeight/2);
    border.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:border];
    
    cardNameValue = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastInfoY, localWidth, labelHeight)];
    cardNameValue.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    cardNameValue.layer.borderWidth = borderWidth;
    cardNameValue.delegate = self;
    cardNameValue.leftViewMode = UITextFieldViewModeAlways;
    cardNameValue.leftView = lbl;
    cardNameValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cardNameValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        cardNameValue.backgroundColor = [UIColor greenColor];
    [infoBackground addSubview:cardNameValue];
    
    lastInfoY += cardNameValue.frame.size.height+labelMarginVer;
    infoFrame = infoBackground.frame;
    infoFrame.size.height = lastInfoY;
    infoBackground.frame = infoFrame;
    //卡类型
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //        lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  类型";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //类型分隔线
    border = [CALayer layer];
    border.frame = CGRectMake(LEFTVIEW_WIDTH*7/8, labelHeight/4, borderWidth, labelHeight/2);
    border.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:border];
    
    cardTypeValue = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastInfoY, localWidth, labelHeight)];
    cardTypeValue.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    cardTypeValue.layer.borderWidth = borderWidth;
    cardTypeValue.delegate = self;
    cardTypeValue.leftViewMode = UITextFieldViewModeAlways;
    cardTypeValue.leftView = lbl;
    cardTypeValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cardTypeValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        cardTypeValue.backgroundColor = [UIColor greenColor];
    [infoBackground addSubview:cardTypeValue];
    
    lastInfoY += cardTypeValue.frame.size.height+labelMarginVer;
    infoFrame = infoBackground.frame;
    infoFrame.size.height = lastInfoY;
    infoBackground.frame = infoFrame;
    //有效期
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LEFTVIEW_WIDTH, labelHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    //        lbl.backgroundColor = [UIColor blueColor];
    lbl.textColor = UIColorFromRGBA(0x1e82d2,1);
    lbl.text = @"  日期";
    if (LARGE_SCREEN) {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:17.0];
    } else {
        lbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0];
    }
    //日期分隔线
    border = [CALayer layer];
    border.frame = CGRectMake(LEFTVIEW_WIDTH*7/8, labelHeight/4, borderWidth, labelHeight/2);
    border.backgroundColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    [lbl.layer addSublayer:border];
    
    validValue = [[UITextField alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastInfoY, localWidth, labelHeight)];
    validValue.layer.borderColor = UIColorFromRGBA(0xd1d2d3,1).CGColor;
    validValue.layer.borderWidth = borderWidth;
    validValue.delegate = self;
    validValue.leftViewMode = UITextFieldViewModeAlways;
    validValue.leftView = lbl;
    validValue.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    validValue.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //        cardTypeValue.backgroundColor = [UIColor greenColor];
    [infoBackground addSubview:validValue];
    
    lastInfoY += validValue.frame.size.height+labelMarginVer;
    infoFrame = infoBackground.frame;
    infoFrame.size.height = lastInfoY;
    infoBackground.frame = infoFrame;
    
    //卡号截图
    cardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_MARGIN, lastInfoY, localWidth, localWidth * 0.2)];
    cardImageView.backgroundColor = [UIColor clearColor];
    [infoBackground addSubview:cardImageView];
    
    lastInfoY += localWidth * 0.2+10;
    infoFrame = infoBackground.frame;
    infoFrame.size.height = lastInfoY;
    infoBackground.frame = infoFrame;
    
    /*dismiss keyboard*/
    UITapGestureRecognizer *tapGrInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGrInfo.cancelsTouchesInView = NO;
    [infoBackground addGestureRecognizer:tapGrInfo];
    
    if (SMALL_SCREEN) {
        lastY += infoBackground.frame.size.height + 20;
    } else {
        lastY += infoBackground.frame.size.height + 40;
    }
    
    okBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/10, lastY, SCREEN_WIDTH*4/10, labelHeight*1.2)];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"okBtn_disable_bg"] forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    okBtn.userInteractionEnabled = NO;
    
    [scr addSubview:okBtn];
    lastY += okBtn.frame.size.height + 20;
    
    scr.contentSize = CGSizeMake(SCREEN_WIDTH, lastY+150);
    
    for (UIView *subView in self.view.subviews) {
        for (id controll in subView.subviews)
        {
            if ([controll isKindOfClass:[UITextField class]])
            {
                [controll setBackgroundColor:[UIColor whiteColor]];
                [controll setDelegate:self];
                [controll setAdjustsFontSizeToFitWidth:YES];
                [controll setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            }
        }
    }
}

- (void)okBtnClick:(id)sender
{
    NSLog(@"okBtn clicked");
}

- (void)launchCameraView:(UIButton *)sender
{
    EXOCRBankRecoManager *manager = [EXOCRBankRecoManager sharedManager:self];
    
    //自定制
    //    [manager setSpaceWithBANKCardNum:NO];
    //    [manager setDisplayLogo:NO];
    //    [manager setEnablePhotoRec:NO];
    //    [manager setScanFrameColorRGB:0xff0000 andAlpha:0.5];
    //    [manager setScanTextColorRGB:0xff0000];
    //    [manager setScanTips:@"test123"];
    //    [manager setScanTipsFontName:@"CourierNewPS-BoldMT" andFontSize:34.0f];
    
//    __weak typeof(self) weakSelf = self;
    [manager recoBankFromStreamOnCompleted:^(int statusCode, EXOCRBankCardInfo *bankInfo) {
        NSLog(@"Completed");
        NSLog(@"%@", [bankInfo toString]);
        self.BANKInfo = bankInfo;
        [self loadData];
        [self enableDone];
    } OnCanceled:^(int statusCode) {
        NSLog(@"Canceled");
    } OnFailed:^(int statusCode, UIImage *failImg) {
        NSLog(@"Failed");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"识别失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
}

-(void)enableDone
{
    //    btnLabel.text = @"请核对卡号信息，确认无误";
    [okBtn setBackgroundImage:[UIImage imageNamed:@"okBtn_enable_bg"] forState:UIControlStateNormal];
    okBtn.userInteractionEnabled = YES;
}

-(void)loadData
{
    if (BANKInfo.bankName != nil) {
        bankNameValue.text = BANKInfo.bankName;
    }
    
    if (BANKInfo.cardName != nil) {
        cardNameValue.text = BANKInfo.cardName;
    }
    
    if (BANKInfo.cardType != nil) {
        cardTypeValue.text = BANKInfo.cardType;
    }
    
    if (BANKInfo.validDate != nil) {
        validValue.text = BANKInfo.validDate;
    }
    
    if (BANKInfo.cardNumImg != nil) {
        cardImageView.image = BANKInfo.cardNumImg;
        cardImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    if (BANKInfo.cardNum != nil) {
        cardNumValue.text = BANKInfo.cardNum;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
#pragma mark - UINavigationController中statusBar改白色
@implementation UINavigationController(statusBarStyle)
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    
}
@end
