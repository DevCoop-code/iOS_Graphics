//
//  ViewController.m
//  DrawTriangle
//
//  Created by HanGyo Jeong on 10/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import "ViewController.h"

typedef struct {
    GLfloat Position[3];
} VertexPoint;

@interface ViewController (){
    GLuint vertexBuffer_;
    
    BaseEffect *shader_;
}

@end

@implementation ViewController

- (void)setupVertexBuffer{
    const static VertexPoint vertices[] = {
        {{-1.0, -1.0, 0}},
        {{1.0, -1.0, 0}},
        {{  0,  0, 0}}
    };
    /*
     [glGenBuffers(n, buffers)]
     generate buffer object names
     returns n buffer object names in buffers
     */
    glGenBuffers(1, &vertexBuffer_);
    
    /*
     [glBindBuffer]
     binds a buffer object to the specified buffer binding point
     - GL_ARRAY_BUFFER
     Vertex Attributes
     */
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer_);
    
    /*
     [glBufferData]
     creates and initializes a buffer object's data store
     While creating the new storage, any pre-existing data store is deleted
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)setupShader{
    shader_ = [[BaseEffect alloc] initWithVertexShader:@"SimpleVertex.glsl"
                                        fragmentShader:@"SimpleFragment.glsl"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *glView = (GLKView*)self.view;
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:glView.context];
    
    [self setupShader];
    [self setupVertexBuffer];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    /*
     specify clear values for the color buffers
     */
    glClearColor(0, 100.4/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [shader_ prepareToDraw];
    
    /*
     [glEnableVertexAttribArray]
     enable the generic vertex attribute array specified by index
     index에 의해 지정된 일반적인 정점 속성을 적재하기 위해 사용
     Ex] index
     0 : position
     1 : normal vector(법선)
     2 : Texture Coordination 1
     3 : Texture Coordination 2
     */
    glEnableVertexAttribArray(VertexAttribPosition);
    
    /*
     [glVertexAttribPointer]
     정점 배열을 지정
     ** 정점 배열 : 각 정점에 속성 데이터를 지정하고 어플리케이션의 주소 공간에 저장되는 버퍼
     
     - Parameter
     index : 일반적인 정점 속성 인덱스를 지정
     size : 인덱스에 의해 참조된 정점 속성에 대한 정점 배열로 지정된 구성 요소의 수 유호값 1-4
     type: 데이터 타입
     normalized : 부동 소수점으로 변환될 때, 비부동형 데이터 형식 타입이 정규화 되어야 할 지 표시
     stride : 크기로 지정된 정점 속성의 구성 요소들이 각 정점에 대해 순차적으로 저장
     ptr : 정점 속성 데이터를 포함한 버퍼에 대한 포인터
     */
    glVertexAttribPointer(VertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(VertexPoint), (const GLvoid *)offsetof(VertexPoint, Position));
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer_);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glDisableVertexAttribArray(VertexAttribPosition);
}

@end
