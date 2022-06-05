//
//  ViewController.m
//  iOSToJava
//
//  Created by Mac on 2022/6/5.
//

#import "ViewController.h"
#import "XMDragView.h"
#import "XMFileItem.h"
#import "iOS2Android.h"
#import "MBProgressHUD.h"
#import "ZHBackUp.h"

@interface ViewController()<XMDragViewDelegate>

/**
 *  支持处理的类型，目前仅支持png、jpg、ipa、car文件
 */
@property (nonatomic, copy) NSArray *extensionList;

@property (weak) IBOutlet NSMatrix *chooseTypeControl;
@property (weak) IBOutlet NSMatrix *backupTypeControl;

@property (weak) IBOutlet NSTextField *filed;
@property (unsafe_unretained) IBOutlet NSTextView *txtView;
@property (weak) IBOutlet NSScrollView *txtBg;
@property (weak) IBOutlet NSButton *okBtn;

@property (nonatomic,assign)BOOL isBackUp;
@property (nonatomic,strong)iOS2Android *iOSToAndroid;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBackUp = YES;
    // 支持的扩展名文件
    self.extensionList = @[@"m", @"h",@"txt"];
    self.backupTypeControl.hidden = YES;
}

- (IBAction)okAction:(id)sender {
    self.iOSToAndroid = [iOS2Android new];
    [self.txtView setString:[self.iOSToAndroid begin:self.txtView.string]];
}

#pragma mark - XMDragViewDelegate

/**
 *  处理拖拽文件代理
 */
- (void)dragView:(XMDragView *)dragView didDragItems:(NSArray *)items
{
    [self addPathsWithArray:items];
}

#pragma mark - other
/**
 *  添加拖拽进来的文件
 */
- (void)addPathsWithArray:(NSArray*)path
{
    for (NSString *addItem in path) {
        
        XMFileItem *fileItem = [XMFileItem xmFileItemWithPath:addItem];
        
        // 过滤不支持的文件格式
        if (fileItem.isDirectory) {
            [ZHBackUp backUpProject:fileItem.filePath asyncBlock:^NSString *{
                self.iOSToAndroid = [iOS2Android new];
                [self.iOSToAndroid beginMulu:fileItem.filePath];
                return @"备份目录完成";
            }];
        }else{
            BOOL isExpectExtension = NO;
            NSString *pathExtension = [addItem pathExtension];
            for (NSString *item in self.extensionList) {
                if ([item isEqualToString:pathExtension]) {
                    isExpectExtension = YES;
                    break;
                }
            }
            
            if (!isExpectExtension) {
                [MBProgressHUD showText:@"仅支持.h .m .txt格式文件"];
                continue;
            }
            [ZHBackUp backUpProject:fileItem.filePath asyncBlock:^NSString *{
                self.iOSToAndroid = [iOS2Android new];
                [self.iOSToAndroid beginPath:fileItem.filePath];
                return @"备份文件完成";
            }];
        }
    }
}

#pragma mark - actoin
- (IBAction)takeStyleFrom:(NSMatrix *)sender
{
    NSInteger tag = [[sender selectedCell] tag];
    if (tag == 2) {
        self.txtBg.hidden = NO;
        self.okBtn.hidden = NO;
        self.backupTypeControl.hidden = YES;
    } else {
        self.txtBg.hidden = YES;
        self.okBtn.hidden = YES;
        self.backupTypeControl.hidden = NO;
    }
}
- (IBAction)backUpStyleFrom:(NSMatrix *)sender
{
    NSInteger tag = [[sender selectedCell] tag];
    if (tag == 2) {
        self.isBackUp = YES;
    } else {
        self.isBackUp = NO;
        [MBProgressHUD showText:@"请确定您已经备份工程,否则一旦转换,无法逆转,无法找回,请谨慎操作!"];
    }
}

@end
