//
//  BaseEffect.m
//  DrawTriangle
//
//  Created by HanGyo Jeong on 10/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEffect.h"

@implementation BaseEffect{
    GLuint _programHandle;
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:nil];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    /*
     [glCreateShader]
     Creates a shader object
     
     shaderType : GL_COMPUTE_SHADER, GL_VERTEX_SHADER, GL_TESS_CONTROL_SHADER, GL_TESS_EVALUATION_SHADER, GL_GEOMETRY_SHADER, or GL_FRAGMENT_SHADER
     */
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    
    /*
     [glShaderSource]
     Replaces the source code in a shader object
     Any source code previously stored in the shader object is completely replaced
     */
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    /*
     [glCompileShader]
     Compiles a shader object
     */
    glCompileShader(shaderHandle);
    
    /*
     [glGetShaderiv]
     return a parameter from a shader object
     */
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

- (void)compileVertexShader:(NSString *)vertexShader
             fragmentShader:(NSString *)fragmentShader{
    
    GLuint vertexShaderName = [self compileShader:vertexShader
                                         withType:GL_VERTEX_SHADER];
    GLuint fragmentShaderName = [self compileShader:fragmentShader
                                           withType:GL_FRAGMENT_SHADER];
    
    /*
     [glCreateProgram]
     Creates a program object
     
     ** program object - program object is an object to which shader objects can be attached.
     */
    _programHandle = glCreateProgram();
    
    /*
     [glAttachShader]
     Attaches a shader object to a program object
     */
    glAttachShader(_programHandle, vertexShaderName);
    glAttachShader(_programHandle, fragmentShaderName);
    
    /*
     [glBindAttribLocation]
     used to associate a user-defined attribute variable in the program object specified by program
     */
    glBindAttribLocation(_programHandle, VertexAttribPosition, "a_Position");
    
    /*
     [glLinkProgram]
     Links a program object
     */
    glLinkProgram(_programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
}

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:
(NSString *)fragmentShader {
    if ((self = [super init])) {
        [self compileVertexShader:vertexShader fragmentShader:fragmentShader];
    }
    return self;
}

- (void)prepareToDraw {
    /*
     [glUseProgram]
     Installs a program object as part of current rendering state
     */
    glUseProgram(_programHandle);
}
@end
