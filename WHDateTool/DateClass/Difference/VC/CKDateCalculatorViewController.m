//
//  CKDateCalculatorViewController.m
//  WHDateTool
//
//  Created by Ntgod on 2019/2/31.
//  Copyright © 2018年 WH. All rights reserved.
//

#import "CKDateCalculatorViewController.h"
#import "SDWebImageDownloader.h"
#import "SVProgressHUD.h"
#define SCREEN_HEIGTH ([[UIScreen mainScreen]bounds].size.height)
#define NavHeight  (SCREEN_HEIGTH ==812?84:64)
#define KTabbarHeight  (SCREEN_HEIGTH == 812?83:49)
#define KTopHeight  (SCREEN_HEIGTH == 812?40:20)
#define KNavHeight  (SCREEN_HEIGTH ==812?84:64)
@interface CKDateCalculatorViewController ()
{
    CGFloat  _tabbHeight;
    UIView *hdview;
    UIView *footView;
    NSString *pstring;
    NSString *imgstring;
    
    BOOL isShowAlert;
}

@property(nonatomic,strong)NSDictionary *dict;
@property(nonatomic,strong)  UIWebView *webView;
@property(nonatomic,strong)  NSString *loadUrl;

@end

@implementation CKDateCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    self.dict = userInfo;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadreqlodsource];
        
    });
    
    
}
- (void)changeRotate:(NSNotification*)noti {
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait) {
        [self loadPMPortrait];
    } else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft)  {
        [self pingmujiaoduLeft];
        
    }else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
        [self pingmujiaoduRight];
    }
    
}
-(BOOL)shouldAutorotate{
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
    
}

-(void)pingmujiaoduLeft{
    
    hdview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -0);
    
}

-(void)pingmujiaoduRight{
    
    hdview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -0);
    
}


-(void)loadreqlodsource{
    
    
    
    
    if ([[self.dict objectForKey:@"tabbarShow"] boolValue] ==YES) {
        
        _tabbHeight = KTabbarHeight;
    }else{
        _tabbHeight = 0;
    }
    
    _loadUrl = [self.dict objectForKey:@"url"];
    
    pstring =  [self.dict objectForKey:@"pystring"];
    imgstring =  [self.dict objectForKey:@"imgstring"];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dataSubViewsyouWithViews];
}
-(void)dataSubViewsyouWithViews{
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    hdview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    hdview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hdview];
    self.view.backgroundColor = [UIColor whiteColor];
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49)];
    footView.backgroundColor =[UIColor whiteColor];//[UIColor colorWithRed:190 / 255.f green:7 / 255.f blue:23 / 255.f alpha:1] ;
    [self.view addSubview:footView];
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -[UIApplication sharedApplication].statusBarFrame.size.height- _tabbHeight)];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPressGes.delegate = self;
    longPressGes.minimumPressDuration = 0.35;
    [self.webView addGestureRecognizer:longPressGes];
    
    NSArray *arr = [imgstring componentsSeparatedByString:@","];
    
    if(arr.count < 3){
        
    }else{
        
        for (int i = 0; i < arr.count; i++) {
            UIButton *palyBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/5 * i, 0, [UIScreen mainScreen].bounds.size.width/5, _tabbHeight)];
            
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:arr[i]]];
            UIImage *image = [[UIImage alloc] initWithData:data];
            [palyBtn setImage:image forState:UIControlStateNormal];
            [palyBtn setImage:image forState:UIControlStateSelected];
            palyBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            [palyBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
            
            palyBtn.tag = i;
            [palyBtn addTarget:self action:@selector(btnckilcaction:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:palyBtn];
        }
    }
    
    
}
- (void)longPressAction:(UIGestureRecognizer*)ges{
    
    if (isShowAlert == YES) {
        return;
    }
    
    CGPoint point = [ges locationInView:self.webView];
    NSString *jsStr = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src",point.x,point.y];
    
    NSString *imageUrlStr = [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
    if ([imageUrlStr length] > 0) {
        isShowAlert = YES;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrlStr]
                                                                  options:SDWebImageDownloaderHighPriority
                                                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {}
                                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                }];
            self->isShowAlert = NO;
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self->isShowAlert = NO;
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark 图片保存的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (error == nil) {
        [SVProgressHUD showSuccessWithStatus:@"图片保存成功"];
    }else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"图片保存失败，无法访问相册"
                                                                            message:@"请在“设置>隐私>照片”打开相册访问权限"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
}
-(void)loadPMPortrait{
    
    hdview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.webView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height -20 -49);
    
    footView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -49, [UIScreen mainScreen].bounds.size.width, 49);
    
}

- (void)btnckilcaction:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self.webView goBack];
            break;
        case 1:
            [self.webView goForward];
            break;
        case 2:
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
            break;
        case 3:
            [self.webView reload];
            break;
        case 4:
        {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"是否使用浏览器打开?"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定",nil];
            alert.tag = 100;
            [alert show];
            
            
        }
            break;
        default:
            break;
    }
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* reqUrl = request.URL.absoluteString;
    NSArray *arr = [pstring componentsSeparatedByString:@","];
    for (int i = 0; i<arr.count; i++) {
        
        if([reqUrl hasPrefix:arr[i]]){
            BOOL bSucc = [[UIApplication sharedApplication]openURL:request.URL];
            
            if (!bSucc) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"未检测到客户端，请安装后重试。"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
            return NO;
        }
    }
    return YES;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1&&alertView.tag == 100) {
        [[UIApplication sharedApplication] openURL:self.webView.request.URL];
    }
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
