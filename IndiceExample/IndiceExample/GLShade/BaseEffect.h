//
//  BaseEffect.h
//  IndiceExample
//
//  Created by HanGyo Jeong on 11/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface BaseEffect : NSObject

- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader;

- (void)prepareToDraw;

@end
