
#import "ADCAlertView.h"

#define AVAnimationDuration 0.4f
#define AVAlertViewWidth 270.0f
//#define AVButtonHeight 44.0f
#define AVMarginInnerView 10.0f
#define AVSeparatorEachEle 10.0f

@interface ADCAlertView ()

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *message;
@property (nonatomic, strong) NSString  *cancelButtonTitle;
@property (nonatomic, strong) NSString  *confirmButtonTitle;

@property (nonatomic) BOOL inMainWindow;
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, copy) ADCAlertViewHandler handler;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *innerView;

@end

@implementation ADCAlertView

+ (void)dismissAllADCAlertView
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *win in windows){
        NSArray *subviews = [win subviews];
        NSUInteger count = [subviews count];
        if (count == 0)
            continue;
        else if (count == 1){
            if ([subviews[0] isKindOfClass:[ADCAlertView class]])
                [win removeFromSuperview];
        }else{
            for(UIView *view in subviews){
                if([view isKindOfClass:[ADCAlertView class]])
                   [view removeFromSuperview];
            }
        }
    }
}

#pragma mark - Initializers

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    return [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:nil andViewInMainWindow:NO];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle andViewInMainWindow:(BOOL)inMainWindow
{
    return [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:nil andViewInMainWindow:inMainWindow];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTitle
{
    return [self initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle confirmButtonTitle:confirmButtonTitle andViewInMainWindow:NO];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle confirmButtonTitle:(NSString *)confirmButtonTittle andViewInMainWindow:(BOOL)inMainWindow
{
    if (!(self = [super init])) return nil;
    
    self.title = title;
    self.message = message;
    self.cancelButtonTitle = cancelButtonTitle;
    self.confirmButtonTitle = confirmButtonTittle;
    self.inMainWindow = inMainWindow;
    
    [self setup];
    
    return self;
}

#pragma mark - Private Methods

- (void)setup
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIWindow *keyWindow;
    
    // setup AlertWindow
    if(self.inMainWindow)
    {
        keyWindow = [[UIApplication sharedApplication] keyWindow];
    }else{
        keyWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        keyWindow.windowLevel = UIWindowLevelAlert;
        keyWindow.backgroundColor = [UIColor clearColor];
    }
    self.window = keyWindow;
    
    self.frame = keyWindow.bounds;
    
    // Set up our subviews
    self.backgroundView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    self.backgroundView.alpha = 0.0f;
    [self addSubview:self.backgroundView];
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AVAlertViewWidth, 100)];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 7.0f;
    self.alertView.layer.masksToBounds = YES;
    self.alertView.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    [self.alertView setTag:1];
    
    // Configure AlertView
    //self.alertView.bounds = CGRectMake(0, 0, AVAlertViewWidth, AVButtonHeight * 3);
    //self.alertView.center = self.center;
    self.alertView.alpha = 0.f;
    
    

    
    
    self.innerView = [[UIView alloc] initWithFrame:self.alertView.frame];
    [self.innerView setBackgroundColor:[UIColor clearColor]];
    [self.innerView setTag:2];
    
    [self.alertView addSubview:self.innerView];
    [self addSubview:self.alertView];
    
    
    
    self.alertView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:200]];
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:200]];

    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:30]];
//    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.alertView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:30]];
    
    
    // Add Title
    [self.innerView addSubview:[self returnUIForTitle]];
    
    // Add Messsage
    [self.innerView addSubview:[self returnUIForMessage]];
    
    // Add Button
    [self.innerView addSubview:[self returnUIForButton]];
    
    // Add layer to AlertView
    [self.alertView.layer addSublayer:[self subLayerLine]];
    
    // Resize all subviews
    [self AMResizeViews];
    
}

#pragma mark - Public Methods

- (void)show {
    
    [self.window addSubview:self];//addSubview keeps a strong pointer
    [self.window makeKeyAndVisible];
    
    // Animate in the background blind
    [UIView animateWithDuration:AVAnimationDuration animations:^{
        self.backgroundView.alpha = 1.0f;
        self.alertView.alpha = 1.0f;
    }];
}

- (void)dismiss
{
    [self dismissWithDuration:AVAnimationDuration];
}

- (void)dismissWithDuration:(CGFloat)duration
{
    // Animate out our background blind
    [UIView animateWithDuration:duration animations:^{
        self.backgroundView.alpha = 0.0f;
        self.alertView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        // Very important!
        //self.alertWindow = nil;
        
    }];
    
    // Call our completion handler
    if (self.handler) {
        self.handler(self);
    }
}

#pragma mark - UI stuff

- (CALayer *)subLayerLine
{
    CGRect lastFrame = [self frameForLastSettedView];
    
    CGFloat posYLine = lastFrame.origin.y;
    posYLine += AVSeparatorEachEle;
    
    CALayer *keylineLayer = [CALayer layer];
    keylineLayer.backgroundColor = [[UIColor colorWithWhite:0.0f alpha:0.29f] CGColor];
    keylineLayer.frame = CGRectMake(
                                    0,
                                    posYLine,
                                    AVAlertViewWidth,
                                    0.5f);
    return keylineLayer;
}

- (UIView *)returnUIForTitle
{
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, (AVAlertViewWidth-AVMarginInnerView*2), 44.0f)];
    titleLabel.text             = self.title;
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.textColor        = [UIColor blackColor];
    titleLabel.font             = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.lineBreakMode    = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines    = 0;
    
    titleLabel.frame            = [self adjustLabelFrame:titleLabel];
    
    return titleLabel;
}

- (UIView *)returnUIForMessage
{
    CGRect lastFrame            = [self frameForLastSettedView];
    UILabel *messageLabel       = [[UILabel alloc] initWithFrame:CGRectMake(lastFrame.origin.x,
                                                                            lastFrame.origin.y + lastFrame.size.height + AVSeparatorEachEle,
                                                                            (AVAlertViewWidth-AVMarginInnerView*2),
                                                                            44.0f)];
    
    messageLabel.text               = self.message;
    messageLabel.backgroundColor    = [UIColor clearColor];
    messageLabel.textColor          = [UIColor blackColor];
    messageLabel.font               = [UIFont systemFontOfSize:15];
    messageLabel.textAlignment      = NSTextAlignmentCenter;
    messageLabel.lineBreakMode      = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines      = 0;
    
    messageLabel.frame = [self adjustLabelFrame:messageLabel];
    
    return messageLabel;
}

- (UIView *)returnUIForButton
{
    CGRect lastFrame = [self frameForLastSettedView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:button.titleLabel.font.pointSize];
    [button setBackgroundColor:[UIColor whiteColor]];
    button.frame = CGRectMake(
                              0 - AVMarginInnerView,
                              lastFrame.origin.y + lastFrame.size.height + AVSeparatorEachEle,
                              AVAlertViewWidth,
                              44.f);
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGRect )adjustLabelFrame: (UILabel *)label
{
    //Calculate the expected size based on the font and linebreak mode of your label
    // FLT_MAX here simply means no constraint in height
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          label.font, NSFontAttributeName,
                                          label.textColor, NSForegroundColorAttributeName,
                                          nil];
    
    CGRect text_size = [label.text boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributesDictionary
                                                context:nil];
    
    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, text_size.size.height);
}

- (CGRect)frameForLastSettedView
{
    CGRect frame;
    NSArray *subviews = [self.innerView subviews];
    if([subviews count] > 0){
        UIView *t_View = [subviews objectAtIndex:[subviews count]-1];
        frame = CGRectMake(t_View.frame.origin.x,
                           t_View.frame.origin.y,
                           t_View.frame.size.width,
                           t_View.frame.size.height);
    }
    return frame;
}

- (void)AMResizeViews
{
    CGFloat totalHeight = 0.0f;
    
    // GET ALL SUBVIEWS (height)
    for(UIView *i_views in [self.innerView subviews]){
        totalHeight += i_views.frame.size.height;
    }
    
    // ADD separatorEachEle to totalHeight value
    totalHeight+=AVSeparatorEachEle;
    
    if(totalHeight>0){
        // Finally, calculate frame of AlertView
        [self.alertView setFrame:CGRectMake(
                                            self.alertView.frame.origin.x,
                                            self.alertView.frame.origin.y,
                                            self.alertView.frame.size.width,
                                            totalHeight + AVMarginInnerView*2
                                            )];
        
    }
    
    [self.innerView setFrame:CGRectMake(
                                         0 + AVMarginInnerView,
                                         0 + AVMarginInnerView,
                                         self.alertView.frame.size.width - AVMarginInnerView*2,
                                         self.alertView.frame.size.height - AVMarginInnerView*2
                                         )];
    
}

@end
