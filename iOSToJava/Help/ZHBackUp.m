#import "ZHBackUp.h"
#import "MBProgressHUD.h"
#import "ZHFileManager.h"

@implementation ZHBackUp
+ (void)backUpProject:(NSString *)project
           asyncBlock:(NSString * (^)(void))asyncBlock{
    if (project.length <= 0) {
        [MBProgressHUD showText:@"路径为空!"];
        return;
    }
    [MBProgressHUD showText:@"正在备份..."];
    //备份工程
    //有后缀的文件名
    NSString *tempFileName = [ZHFileManager getFileNameFromFilePath:project];
    
    //无后缀的文件名
    NSString *fileName = [ZHFileManager getFileNameNoPathComponentFromFilePath:project];
    
    //获取无文件名的路径
    NSString *newFilePath =
    [project stringByReplacingOccurrencesOfString:tempFileName withString:@""];
    //拿到新的有后缀的文件名
    tempFileName = [tempFileName
                    stringByReplacingOccurrencesOfString:fileName
                    withString:[NSString stringWithFormat:@"%@备份", fileName]];
    
    newFilePath = [newFilePath stringByAppendingPathComponent:tempFileName];
    
    if ([ZHFileManager fileExistsAtPath:newFilePath]) {
        [ZHFileManager removeItemAtPath:newFilePath];
    }
    
    BOOL result = [ZHFileManager copyItemAtPath:project toPath:newFilePath];
    
    if (result) {
        [MBProgressHUD showText:@"备份成功,正在处理注释..."];
    } else {
        [MBProgressHUD showText:@"备份失败!请先关闭工程(XCode)"];
        return;
    }
    if (asyncBlock) { asyncBlock(); }
}
@end
