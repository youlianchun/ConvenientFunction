//
//  CFunction.h
//  ConvenientFunction
//
//  Created by YLCHUN on 16/9/15.
//  Copyright © 2016年 ylchun. All rights reserved.
//
#import <Foundation/Foundation.h>

/*!
 *  主线程执行
 *
 *  @param obj     绑定对象，nil为不绑定（绑定对象一旦释放将不执行代码块）
 *  @param ^doCode 代码块
 */
FOUNDATION_EXPORT void mainDo(id obj, void (^doCode)(void));

/*!
 *  子线程执行代码块
 *
 *  @param obj      绑定对象，nil为不绑定（绑定对象一旦释放将不执行代码块）
 *  @param PRIORITY 优先级 2|高; 0|一般; －2|低;
 *  @param ^doCode  代码块
 */
FOUNDATION_EXPORT void globalDo(id obj, int PRIORITY, void (^doCode)(void));

/*!
 *  异常捕获
 *
 *  @param ^tryCode     可能异常代码块
 *  @param ^finallyCode 异常捕获完结束代码块
 */
FOUNDATION_EXPORT void tryDo(void (^tryCode)(void),void (^finallyCode)(NSException *exception));

/*!
 *  代码块延迟执行（代码块执行的所在线程类型取决于函数调用时的线程类型）
 *
 *  @param obj     绑定对象，nil为不绑定（绑定对象一旦释放将不执行代码块）
 *  @param time    延迟时间（秒）
 *  @param ^doCode 延迟执行代码块
 */
FOUNDATION_EXPORT void doCodeDelay(id obj, double time,void (^doCode)(void));

/*!
 *  代码块执行耗时（秒）
 *
 *  @param ^code  耗时计算代码块（代码块那诶有block时候，在block内打上 dot("") 可在dotDo返回耗时）
 *  @param ^end   代码开始到结束块耗时（不含代码块内block）
 *  @param ^dotDo 代码开始到块 dot(@"") 点耗时
 */
FOUNDATION_EXPORT void codeTime(void(^code)(void(^dot)(NSString *tips)), void(^end)(double endTime), void(^dotDo)(NSString *tips,double dotTime));

/*!
 *  计时器（代码块执行的所在线程类型取决于函数调用时的线程类型）
 *
 *  @param obj      绑定对象，nil为不绑定（绑定对象一旦释放将不执行代码块）
 *  @param count    即时次数，>0 时候计时器会自动终止
 *  @param interval 时间间隔
 *  @param ^doCode  倒计时执行
 */
FOUNDATION_EXPORT void timerCode(id obj, int count, float interval, void (^doCode)(int dot));

/*!
 *  计时器（代码块执行的所在线程类型取决于函数调用时的线程类型）
 *
 *  @param obj      绑定对象，nil为不绑定（绑定对象一旦释放将不执行代码块）
 *  @param count    即时次数，>0 时候计时器会自动终止
 *  @param interval 时间间隔
 *  @param ^doCode  实时计数，count>0 时为倒计时递减，count<=0 为0，inte(-1)|停止; inte(0)|暂停; inte(1)|恢复;
 */
FOUNDATION_EXPORT void timerCodePlus(id obj, int count, float interval, void (^doCode)(int dot, void(^inte)(int i)));


/*!
 *  App是否在跟踪模式下启动(代码调试模)
 *
 *  @return true 被跟踪
 */
FOUNDATION_EXPORT bool appIsBeingTraced(void);


