//
//  BaseVertex.h
//  DrawCube
//
//  Created by HanGyo Jeong on 11/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#ifndef BaseVertex_h
#define BaseVertex_h

typedef enum {
    VertexAttribPosition = 0,
    VertexAttribColor = 1
} VertexAttributes;

typedef struct {
    GLfloat Position[3];
    GLfloat Color[4];
} VertexBuffer;

#endif /* BaseVertex_h */
