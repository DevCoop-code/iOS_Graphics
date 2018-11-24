//
//  BaseEffect.h
//  DrawCube
//
//  Created by HanGyo Jeong on 11/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "BaseVertex.h"

@interface BaseEffect : NSObject

@property(nonatomic, assign) GLuint shaderProgram;
@property(nonatomic, assign) GLKMatrix4 modelViewMatrix;
@property(nonatomic, assign) GLKMatrix4 projectionMatrix;

- (instancetype)initWithVertexShader:(NSString *)vertexShader
                      fragmentShader:(NSString *)fragmentShader;
- (void)prepareToDraw;

@end
