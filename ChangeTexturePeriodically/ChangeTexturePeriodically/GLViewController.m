//
//  ViewController.m
//  ChangeTexturePeriodically
//
//  Created by HanGyo Jeong on 24/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import "GLViewController.h"
#import <OpenGLES/ES2/glext.h>

@interface GLViewController (){
    GLuint modelViewMatrixUniform_;
    GLuint projectionMatrixUniform_;
    GLuint textureUniform_;
    
    GLuint vao_;
    GLuint vertexBuffer_;
    GLuint indexBuffer_;
    unsigned int vertexCount_;
    unsigned int indexCount_;
}

@end

typedef struct{
    GLfloat Position[3];
    GLfloat Color[4];
    GLfloat TexCoord[2];
}BaseVertex;

@implementation GLViewController

const int vertexAttributPosition = 0;
const int vertexAttributColor = 1;
const int vertexAttributTexCoord = 2;

const static BaseVertex verteices[] = {
    // Front
    {{ 1, -1,  1}, { 1, 0, 0, 1}, { 1, 0}}, //V0
    {{ 1,  1,  1}, { 0, 1, 0, 1}, { 1, 1}}, //V1
    {{-1,  1,  1}, { 0, 0, 1, 1}, { 0, 1}}, //V2
    {{-1, -1,  1}, { 0, 0, 0, 1}, { 0, 0}}, //V3
    
    // Back
    {{-1, -1, -1}, { 1, 0, 0, 1}, { 1, 0}}, //V4
    {{-1,  1, -1}, { 1, 0, 0, 1}, { 1, 1}}, //V5
    {{ 1,  1, -1}, { 0, 1, 0, 1}, { 0, 1}}, //V6
    {{ 1, -1, -1}, { 0, 1, 0, 1}, { 0, 0}},  //V7
    
    // Left
    {{-1, -1,  1}, { 1, 0, 0, 1}, { 1, 0}}, //V8
    {{-1,  1,  1}, { 0, 1, 0, 1}, { 1, 1}}, //V9
    {{-1,  1, -1}, { 0, 0, 1, 1}, { 0, 1}}, //V10
    {{-1, -1, -1}, { 0, 0, 0, 1}, { 0, 0}}, //V11
    
    // Right
    {{ 1, -1, -1}, { 1, 0, 0, 1}, { 1, 0}}, //V12
    {{ 1,  1, -1}, { 0, 1, 0, 1}, { 1, 1}}, //V13
    {{ 1,  1,  1}, { 0, 0, 1, 1}, { 0, 1}}, //V14
    {{ 1, -1,  1}, { 0, 0, 0, 1}, { 0, 0}},  //V15
    
    // Top
    {{ 1,  1,  1}, { 1, 0, 0, 1}, { 1, 0}}, //V16
    {{ 1,  1, -1}, { 0, 1, 0, 1}, { 1, 1}}, //V17
    {{-1,  1, -1}, { 0, 0, 1, 1}, { 0, 1}}, //V18
    {{-1,  1,  1}, { 0, 0, 0, 1}, { 0, 0}},  //V19
    
    // Bottom
    {{ 1, -1, -1}, { 1, 0, 0, 1}, { 1, 0}}, //V16
    {{ 1, -1,  1}, { 0, 1, 0, 1}, { 1, 1}}, //V17
    {{-1, -1, -1}, { 0, 0, 1, 1}, { 0, 1}}, //V18
    {{-1, -1, -1}, { 0, 0, 0, 1}, { 0, 0}}  //V19
};

const static GLubyte indeices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    6, 7, 4,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};
- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *glView = (GLKView *)self.view;
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    glView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [EAGLContext setCurrentContext:glView.context];
    
    [self setupScene];
    
    self.modelViewMatrix = GLKMatrix4Identity;
    self.projectionMatrix = GLKMatrix4Identity;
    
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width/self.view.bounds.size.height, 1, 150);
    
    vertexCount_ = sizeof(verteices)/sizeof(verteices[0]);
    indexCount_ = sizeof(indeices)/sizeof(indeices[0]);
    
    self.position = GLKVector3Make(0, 0, 0);
    self.rotationX = 0;
    self.rotationY = 0;
    self.rotationZ = 0;
    self.scale = 1.0;
    
    glGenVertexArraysOES(1, &vao_);
    glBindVertexArrayOES(vao_);
    
    glGenBuffers(1, &vertexBuffer_);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer_);
    glBufferData(GL_ARRAY_BUFFER, sizeof(BaseVertex) * vertexCount_, verteices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &indexBuffer_);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer_);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte) * indexCount_, indeices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(vertexAttributPosition);
    glVertexAttribPointer(vertexAttributPosition, 3, GL_FLOAT, GL_FALSE, sizeof(BaseVertex), (const GLvoid *)offsetof(BaseVertex, Position));
    
    glEnableVertexAttribArray(vertexAttributColor);
    glVertexAttribPointer(vertexAttributColor, 4, GL_FLOAT, GL_FALSE, sizeof(BaseVertex), (const GLvoid *)offsetof(BaseVertex, Color));
    
    glEnableVertexAttribArray(vertexAttributTexCoord);
    glVertexAttribPointer(vertexAttributTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(BaseVertex), (const GLvoid *)offsetof(BaseVertex, TexCoord));
    
    //Load Textures
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"wow.jpg" ofType:nil];
    NSDictionary *options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    if ( info == nil ) {
        NSLog(@"Error loading file: %@", error.localizedDescription);
    }else{
        self.texture = info.name;
    }
}

- (void)setupScene {
    GLuint vertexShaderObject;
    GLuint fragmentShaderObject;
    
    NSError *error = nil;
    GLint compileSuccess;
    
    //Vertex Shader
    NSString *vertexShaderPath = [[NSBundle mainBundle]pathForResource:@"VertexShader.glsl" ofType:nil];
    NSString *vertexShaderString = [NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:&error];
    if(!vertexShaderString){
        NSLog(@"vertex shader string Error : %@", error.localizedDescription);
    }
    int vertexShaderLength = (int)[vertexShaderString length];
    const char *vertexShaderUTF8 = [vertexShaderString UTF8String];
    
    vertexShaderObject = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertexShaderObject, 1, &vertexShaderUTF8, &vertexShaderLength);
    glCompileShader(vertexShaderObject);
    
    glGetShaderiv(vertexShaderObject, GL_COMPILE_STATUS, &compileSuccess);
    if(compileSuccess == GL_FALSE){
        GLchar messages[256];
        glGetShaderInfoLog(vertexShaderObject, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"vertex shader compile error : %@", messageString);
    }
    
    //Fragment Shader
    NSString *fragmentShaderPath = [[NSBundle mainBundle]pathForResource:@"FragmentShader.glsl" ofType:nil];
    NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:&error];
    if(!fragmentShaderString){
        NSLog(@"fragment shader string Error : %@", error.localizedDescription);
    }
    int fragmentShaderLength = (int)[fragmentShaderString length];
    const char *fragmentShaderUTF8 = [fragmentShaderString UTF8String];
    
    fragmentShaderObject = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragmentShaderObject, 1, &fragmentShaderUTF8, &fragmentShaderLength);
    glCompileShader(fragmentShaderObject);
    
    glGetShaderiv(fragmentShaderObject, GL_COMPILE_STATUS, &compileSuccess);
    if(compileSuccess == GL_FALSE){
        GLchar messages[256];
        glGetShaderInfoLog(fragmentShaderObject, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"fragmentshader compile error : %@", messageString);
    }
    
    //Make Program Object
    //Create Program Object
    _shaderProgram = glCreateProgram();
    //Attach shader object to program object
    glAttachShader(_shaderProgram, vertexShaderObject);
    glAttachShader(_shaderProgram, fragmentShaderObject);
    
    glBindAttribLocation(_shaderProgram, vertexAttributPosition, "a_Position");
    glBindAttribLocation(_shaderProgram, vertexAttributColor, "a_Color");
    glBindAttribLocation(_shaderProgram, vertexAttributTexCoord, "a_TexCoord");
    
    glLinkProgram(_shaderProgram);
    
    modelViewMatrixUniform_ = glGetUniformLocation(_shaderProgram, "u_ModelViewMatrix");
    projectionMatrixUniform_ = glGetUniformLocation(_shaderProgram, "u_ProjectionMatrix");
    textureUniform_ = glGetUniformLocation(_shaderProgram, "u_Texture");
    
    GLint linkingSuccess;
    glGetProgramiv(_shaderProgram, GL_LINK_STATUS, &linkingSuccess);
    if(linkingSuccess == GL_FALSE){
        GLchar messages[256];
        glGetProgramInfoLog(_shaderProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"link error : %@", messageString);
    }
}

#pragma mark - GLKView delegate methods
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0, 100.0/255.0, 50.0/255.0, 1);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    self.modelViewMatrix = GLKMatrix4MakeTranslation(0, -1, -5);
    
    glUseProgram(_shaderProgram);
    glUniformMatrix4fv(modelViewMatrixUniform_, 1, 0, self.modelViewMatrix.m);
    glUniformMatrix4fv(projectionMatrixUniform_, 1, 0, self.projectionMatrix.m);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.texture);
    glUniform1f(textureUniform_, 1);
    
    glBindVertexArrayOES(vao_);
    glDrawElements(GL_TRIANGLES, indexCount_, GL_UNSIGNED_BYTE, 0);
}
@end
