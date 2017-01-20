//
//  CFunction.m
//  ConvenientFunction
//
//  Created by YLCHUN on 16/9/15.
//  Copyright © 2016年 ylchun. All rights reserved.
//

#import "CFunction.h"
#import <Foundation/Foundation.h>
#import<libkern/OSAtomic.h>

#pragma mark - private function
dispatch_queue_t currentThreadQueue(){
    dispatch_queue_t currentThreadQueue;
    NSThread*currentThread = [NSThread currentThread];
    if (currentThread.isMainThread) {
        currentThreadQueue = dispatch_get_main_queue();
    }else{
        int PRIORITY = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        switch (currentThread.qualityOfService) {
            case NSQualityOfServiceUserInteractive:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_HIGH;
                break;
            case NSQualityOfServiceUserInitiated:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_HIGH;
                break;
            case NSQualityOfServiceUtility:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_LOW;
                break;
            case NSQualityOfServiceBackground:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_BACKGROUND;
                break;
            case NSQualityOfServiceDefault:
                PRIORITY = DISPATCH_QUEUE_PRIORITY_DEFAULT;
                break;
            default:
                break;
        }
        currentThreadQueue = dispatch_get_global_queue(PRIORITY, 0);
    }
    return currentThreadQueue;
}

#pragma mark - public function

void mainDo(id obj, void (^doCode)(void)){
    BOOL binding = (obj != nil);
    __weak id wObj = obj;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ((!binding || (binding && wObj)) && doCode) {
            doCode();
        }
    });
};

void globalDo(id obj, int PRIORITY, void (^doCode)(void)){
    BOOL binding = (obj != nil);
    __weak id wObj = obj;
    dispatch_async(dispatch_get_global_queue(PRIORITY, 0), ^{
        if ((!binding || (binding && wObj)) && doCode) {
            doCode();
        }
    });
};

void tryDo(void (^tryCode)(void), void (^catchCode)(const char*exception), void (^finallyCode)(void)){
    if (tryCode) {
        @try {
            tryCode();
        }
        @catch (NSException *exception) {
            if (catchCode) {
                const char* exceptionStr = [[NSString stringWithFormat:@"%@",exception] UTF8String];
                catchCode(exceptionStr);
            }
        }
        @finally {
            if (finallyCode) {
                finallyCode();
            }
        }
    }
}



static dispatch_queue_t doCodeDelay_Queue;
void doCodeDelay(id obj, NSTimeInterval time,void (^doCode)(void)){
    BOOL binding = (obj != nil);
    __weak id wObj = obj;
    dispatch_queue_t doCode_Queue = currentThreadQueue();
    if (!doCodeDelay_Queue) {
        doCodeDelay_Queue = dispatch_queue_create("com.doCodeDelay.thread", DISPATCH_QUEUE_CONCURRENT);
    }
    dispatch_async(doCodeDelay_Queue, ^{
        [NSThread sleepForTimeInterval:time];
        dispatch_async(doCode_Queue, ^{
            if ((!binding || (binding && wObj)) && doCode) {
                doCode();
            }
        });
    });
}

void codeTime(void(^code)(void(^dot)(const char *tips)),void(^end)(double endTime),void(^dotDo)(const char *tips,double dotTime)){
    if (code) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        void(^dot)(const char *tips) = ^(const char *tips){
            CFAbsoluteTime dotTime = CFAbsoluteTimeGetCurrent()-startTime;;
            if (dotDo) {
                dotDo(tips,dotTime);
            }
        };
        code(dot);
        CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent()-startTime;;
        if (end) {
            end(endTime);
        }
    }
}

void timerCode(id obj, int count, float interval, void (^doCode)(int dot)){
    timerCodePlus(obj, count, interval, ^(int dot, void (^inte)(int i)) {
        if (doCode) {
            doCode(dot);
        }
    });
}


void timerCodePlus(id obj, int count, float interval, void (^doCode)(int dot , void(^inte)(int i))){
    if (interval>0){
        dispatch_queue_t doCode_Queue = currentThreadQueue();
        BOOL binding = (obj != nil);
        __weak id wObj = obj;
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, DISPATCH_TARGET_QUEUE_DEFAULT);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0);
        void(^inte)(int i) = ^(int i){
            if (i<0) {
                dispatch_source_cancel(timer);
            }else if (i == 0){
                dispatch_suspend(timer);
            }else{
                dispatch_resume(timer);
            }
        };
        if (count>0) {
            __block int32_t timeOutCount = count;
            dispatch_source_set_event_handler(timer, ^{
                OSAtomicDecrement32(&timeOutCount);
                if ((!binding || (binding && wObj)) && doCode) {
                    dispatch_async(doCode_Queue, ^{
                        doCode(timeOutCount, inte);
                    });
                }else{
                    dispatch_source_cancel(timer);
                }
                if (timeOutCount == 0) {
                    dispatch_source_cancel(timer);
                }
            });
        }else{
            dispatch_source_set_event_handler(timer, ^{
                if ((!binding || (binding && wObj)) && doCode) {
                    dispatch_async(doCode_Queue, ^{
                        doCode(count, inte);
                    });
                }else{
                    dispatch_source_cancel(timer);
                }
            });
        }
        
        dispatch_source_set_cancel_handler(timer, ^{
        });
        dispatch_resume(timer);
    }
}



