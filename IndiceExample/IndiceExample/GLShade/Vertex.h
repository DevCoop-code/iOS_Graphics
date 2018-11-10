//
//  Vertex.h
//  IndiceExample
//
//  Created by HanGyo Jeong on 11/11/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#ifndef Vertex_h
#define Vertex_h
typedef enum {
    VertexAttribPosition = 0,
    VertexAttribColor
} VertexAttributes;

typedef struct {
    GLfloat Position[3];
    GLfloat Color[4];
} Vertex;

#endif /* Vertex_h */
