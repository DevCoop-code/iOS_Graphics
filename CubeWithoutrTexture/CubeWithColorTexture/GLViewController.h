//
//  ViewController.h
//  CubeWithColorTexture
//
//  Created by HanGyo Jeong on 24/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface GLViewController : GLKViewController

@property(nonatomic, assign) GLuint shaderProgram;
@property(nonatomic, assign) GLKMatrix4 modelViewMatrix;
@property(nonatomic, assign) GLKMatrix4 projectionMatrix;

@property(nonatomic, assign) GLKVector3 position;
@property(nonatomic) float rotationX;
@property(nonatomic) float rotationY;
@property(nonatomic) float rotationZ;
@property(nonatomic) float scale;

typedef struct {
    GLfloat Position[3];
    GLfloat Color[4];
}BaseVertex;
@end

