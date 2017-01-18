//
//  EXOCRBankRecoManager.h
//  ExBankCardSDK
//
//  Created by kubo on 16/9/2.
//  Copyright © 2016年 kubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXOCRBankCardInfo.h"

/**
 *	@brief 银行卡识别回调CompletedBankBlock, CanceledBlock, FailedBlock
 *
 *	@discussion 用来设定异步调用的回调
 */
typedef void (^CompletedBankBlock)(int statusCode, EXOCRBankCardInfo *bankInfo);
typedef void (^CanceledBlock)(int statusCode);
typedef void (^FailedBlock)(int statusCode, UIImage *recoImg);

@interface EXOCRBankRecoManager : NSObject
/**
 *	@brief 获取EXOCRBankRecoManager实例化对象
 *  @return EXOCRBankRecoManager对象
 */
+(instancetype)sharedManager:(UIViewController *)vc;

/**
 * @brief 调用银行卡扫描识别
 * @param completedBlock - 识别完成回调，获取识别结果EXOCRBankCardInfo对象
 * @param canceledBlock - 识别取消回调
 * @param failedBlock - 识别失败回调
 */
-(void)recoBankFromStreamOnCompleted:(CompletedBankBlock)completedBlock
                          OnCanceled:(CanceledBlock)canceledBlock
                            OnFailed:(FailedBlock)failedBlock;
/**
 * @brief 静态图片识别方法
 * @param image - 待识别静态图像
 * @param completedBlock - 识别成功回调，获取识别结果EXOCRBankCardInfo对象
 * @param failedBlock - 识别失败回调
 */
-(void)recoBankFromStillImage:(UIImage *)image
                  OnCompleted:(CompletedBankBlock)completedBlock
                     OnFailed:(FailedBlock)failedBlock;

/**
 * @brief 结果设置，银行卡号是否包含空格
 * @param bSpace - 默认为YES
 */
-(void)setSpaceWithBANKCardNum:(BOOL)bSpace;

/**
 * @brief 扫描页设置，是否显示logo
 * @param bDisplayLogo - 默认为YES
 */
-(void)setDisplayLogo:(BOOL)bDisplayLogo;

/**
 * @brief 扫描页设置，是否开启本地相册识别
 * @param bEnablePhotoRec - 默认为YES
 */
-(void)setEnablePhotoRec:(BOOL)bEnablePhotoRec;

/**
 * @brief 扫描页设置，扫描框颜色
 * @param rgbColor - rgb颜色值(例:0xffffff)
 * @param alpha - 透明度(例：0.8f, 0-1之间)
 */
-(void)setScanFrameColorRGB:(long)rgbColor andAlpha:(float)alpha;

/**
 * @brief 扫描页设置，扫描字体颜色
 * @param rgbColor - rgb颜色值(例:0xffffff)
 */
-(void)setScanTextColorRGB:(long)rgbColor;

/**
 * @brief 扫描页设置，扫描提示文字
 * @param tipStr - 提示文字
 */
-(void)setScanTips:(NSString *)tipStr;

/**
 * @brief 扫描页设置，扫描提示文字字体名称及字体大小
 * @param fontName - 字体名称
 * @param fontSize - 字体大小
 */
-(void)setScanTipsFontName:(NSString *)fontName andFontSize:(float)fontSize;

/**
 *	@brief 获取sdk版本号
 *  @return sdk版本号
 */
+(NSString *)getSDKVersion;

/**
 *	@brief 获取识别核心版本号
 *  @return 识别核心版本号
 */
+(NSString *)getKernelVersion;
@end
