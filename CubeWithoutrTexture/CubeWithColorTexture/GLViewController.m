//
//  ViewController.m
//  CubeWithColorTexture
//
//  Created by HanGyo Jeong on 24/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import "GLViewController.h"

@interface GLViewController (){
    GLuint modelViewMatrixUniform_;
    GLuint projectionMatrixUniform_;
    
    unsigned int vertexCount_;
    unsigned int indexCount_;
    
    GLuint vao_;
    GLuint vertexBuffer_;
    GLuint indexBuffer_;
}

@end

const static BaseVertex vertices[] = {
    // Front
    {{ 1.0, -1.0, 1}, { 1, 0, 0, 1}}, //V0
    {{ 1.0,  1.0, 1}, { 1, 0, 0, 1}}, //V1
    {{-1.0,  1.0, 1}, { 0, 1, 0, 1}}, //V2
    {{-1.0, -1.0, 1}, { 0, 1, 0, 1}}, //V3
    
    // Back
    {{-1.0, -1.0, -1}, { 1, 0, 0, 1}}, //V4
    {{-1.0,  1.0, -1}, { 1, 0, 0, 1}}, //V5
    {{ 1.0,  1.0, -1}, { 0, 1, 0, 1}}, //V6
    {{ 1.0, -1.0, -1}, { 0, 1, 0, 1}}  //V7
};

const static GLubyte indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    6, 7, 4,
    // Left
    3, 2, 5,
    5, 4, 3,
    // Right
    7, 6, 1,
    1, 0, 7,
    // Top
    1, 6, 5,
    5, 2, 1,
    // Bottom
    3, 4, 7,
    7, 0, 3
};

@implementation GLViewController

const int VertexAttribPosition = 0;
const int VertexAttribColor = 1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *glView = (GLKView*)self.view;
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    glView.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [EAGLContext setCurrentContext:glView.context];
    
    //Make Program Object which attached shader code
    [self setupScene];
    
    //Make perspective projection matrix
    //https://developer.apple.com/documentation/glkit/1488637-glkmatrix4makeperspective?language=objc
    _projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width/self.view.bounds.size.height, 1, 150);
    
    vertexCount_ = sizeof(vertices) / sizeof(vertices[0]);
    indexCount_ = sizeof(indices) / sizeof(indices[0]);
    
    self.position = GLKVector3Make(0, 0, 0);
    self.rotationX = 0;
    self.rotationY = 0;
    self.rotationZ = 0;
    self.scale = 1.0;
    
    //Generate Vertex Array Object
    glGenVertexArraysOES(1, &vao_);
    glBindVertexArrayOES(vao_);
    
    //Generate Vertex Buffer
    glGenBuffers(1, &vertexBuffer_);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer_);
    glBufferData(GL_ARRAY_BUFFER, sizeof(BaseVertex) * vertexCount_, vertices, GL_STATIC_DRAW);
    
    //Generate Index Buffer
    glGenBuffers(1, &indexBuffer_);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer_);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLubyte) * indexCount_, indices, GL_STATIC_DRAW);
    
    //Enable vertex attributes
    glEnableVertexAttribArray(VertexAttribPosition);
    glVertexAttribPointer(VertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(BaseVertex), (const GLvoid *)offsetof(BaseVertex, Position));
    glEnableVertexAttribArray(VertexAttribColor);
    glVertexAttribPointer(VertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(BaseVertex), (const GLvoid *)offsetof(BaseVertex, Color));
}

- (void)setupScene
{
    NSError *error = nil;
    GLint compileSuccess;
    
    /*
     Make Shader Object
     */
    //Vertex Shader Object
    //Parsing vertex shader string
    NSString *vertexShaderPath = [[NSBundle mainBundle]pathForResource:@"VertexShader.glsl" ofType:nil];
    NSString *vertexShaderString = [NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:&error];
    if(!vertexShaderString){
        NSLog(@"Error loading shader :%@", error.localizedDescription);
    }
    int vertexShaderStringLength = (int)[vertexShaderString length];
    const char* vertexShaderUTF8 = [vertexShaderString UTF8String];
    
    //Create VertexShaderObject
    GLuint vertexShaderObject = glCreateShader(GL_VERTEX_SHADER);
    //Provide vertex shaderSource code to shader object
    glShaderSource(vertexShaderObject, 1, &vertexShaderUTF8, &vertexShaderStringLength);
    //Compile the vertex shader object
    glCompileShader(vertexShaderObject);
    //Check the compile error
    glGetShaderiv(vertexShaderObject, GL_COMPILE_STATUS, &compileSuccess);
    if(compileSuccess == GL_FALSE){
        GLchar messages[255];
        glGetShaderInfoLog(vertexShaderObject, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"compile error message : %@", messageString);
    }
    
    //Fragment Shader Object
    //Parsing fragment shader string
    NSString *fragmentShaderPath = [[NSBundle mainBundle]pathForResource:@"FragmentShader.glsl" ofType:nil];
    NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:&error];
    if(!fragmentShaderString){
        NSLog(@"Error loading shader :%@", error.localizedDescription);
    }
    int fragmentShaderStringLength = (int)[fragmentShaderString length];
    const char* fragmentShaderUTF8 = [fragmentShaderString UTF8String];
    
    //Create FragmentShaderObject
    GLuint fragmentShaderObject = glCreateShader(GL_FRAGMENT_SHADER);
    //Provide vertex shaderSource code to shader object
    glShaderSource(fragmentShaderObject, 1, &fragmentShaderUTF8, &fragmentShaderStringLength);
    //Compile the fragment shader object
    glCompileShader(fragmentShaderObject);
    //Check the compile Error
    glGetShaderiv(fragmentShaderObject, GL_COMPILE_STATUS, &compileSuccess);
    if(compileSuccess == GL_FALSE){
        GLchar messages[255];
        glGetShaderInfoLog(fragmentShaderObject, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"compile error message : %@", messageString);
    }
    
    /*
     Make Program Object
     */
    //Create program object
    _shaderProgram = glCreateProgram();
    //Attach the shader object to progrma object
    glAttachShader(_shaderProgram, vertexShaderObject);
    glAttachShader(_shaderProgram, fragmentShaderObject);
    //Bind shader code Attribute variable to real vertex attribute
    glBindAttribLocation(_shaderProgram, VertexAttribPosition, "a_Position");
    glBindAttribLocation(_shaderProgram, VertexAttribColor, "a_Color");
    //Link the program object
    glLinkProgram(_shaderProgram);
    
    //Get UniformVariable Reference
    modelViewMatrixUniform_ = glGetUniformLocation(_shaderProgram, "u_ModelViewMatrix");
    projectionMatrixUniform_ = glGetUniformLocation(_shaderProgram, "u_ProjectionMatrix");
    
    GLint linkSuccess;
    glGetProgramiv(_shaderProgram, GL_LINK_STATUS, &linkSuccess);
    if(linkSuccess == GL_FALSE){
        GLchar messages[255];
        glGetProgramInfoLog(_shaderProgram, sizeof(messages), 0, messages);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"link error message : %@", messageString);
    }
    
}

#pragma mark - GLKView delegate methods
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0, 100.0/255.0, 50.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    _modelViewMatrix = GLKMatrix4MakeTranslation(0, -1, -5);
    
    glUseProgram(_shaderProgram);
    //Modify the Matrix
    glUniformMatrix4fv(modelViewMatrixUniform_, 1, 0, self.modelViewMatrix.m);
    glUniformMatrix4fv(projectionMatrixUniform_, 1, 0, self.projectionMatrix.m);
    
    glBindVertexArrayOES(vao_);
    glDrawElements(GL_TRIANGLES, indexCount_, GL_UNSIGNED_BYTE, 0);
}

@end
