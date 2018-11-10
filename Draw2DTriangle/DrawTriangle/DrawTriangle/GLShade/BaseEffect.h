//
//  BaseEffect.h
//  DrawTriangle
//
//  Created by HanGyo Jeong on 10/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "Vertex.h"

@interface BaseEffect : NSObject

@property (nonatomic, assign) GLuint programHandle;

- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader;
- (void)prepareToDraw;

@end
