# OpenGL example using SFML

import csfml
import csfml_colors
import opengl
import glu

# Initialize SFML

var contextSettings = newContextSettings(32, 0, 0, 0, 0)
var window = newRenderWindow(videoMode(640, 480, 32), "SFML Example", sfDefaultStyle, addr(contextSettings))
window.setFramerateLimit(60)

# Initialize OpenGL
loadExtensions()
glClearColor(0.0, 0.0, 0.0, 1.0)                  # Set background color to black and opaque
glClearDepth(1.0)                                 # Set background depth to farthest
glEnable(GL_DEPTH_TEST)                           # Enable depth testing for z-culling
glDepthFunc(GL_LEQUAL)                            # Set the type of depth-test
glShadeModel(GL_SMOOTH)                           # Enable smooth shading
glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST) # Nice perspective corrections

proc reshape() =
  # TODO: use real width and height instead of constant values
  glViewport(0, 0, 640, 480)                        # Set the viewport to cover the new window
  glMatrixMode(GL_PROJECTION)                       # To operate on the Projection matrix
  glLoadIdentity()                                  # Reset
  gluPerspective(45.0, 640 / 480, 0.1, 100.0)       # Enable perspective projection with fovy, aspect, zNear and zFar

proc render() =
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT) # Clear color and depth buffers
  glMatrixMode(GL_MODELVIEW)                          # To operate on model-view matrix
  glLoadIdentity()                 # Reset the model-view matrix
  glTranslatef(1.5, 0.0, -7.0)     # Move right and into the screen
   
  # Render a cube consisting of 6 quads
  # Each quad consists of 2 triangles
  # Each triangle consists of 3 vertices
  
  glBegin(GL_TRIANGLES)        # Begin drawing of triangles
  
  # Top face (y = 1.0f)
  glColor3f(0.0, 1.0, 0.0)     # Green
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0,  1.0)
  glVertex3f( 1.0, 1.0, -1.0)
  glVertex3f(-1.0, 1.0,  1.0)

  # Bottom face (y = -1.0f)
  glColor3f(1.0, 0.5, 0.0)     # Orange
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f( 1.0, -1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Front face  (z = 1.0f)
  glColor3f(1.0, 0.0, 0.0)     # Red
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)
  glVertex3f( 1.0, -1.0, 1.0)
  glVertex3f( 1.0,  1.0, 1.0)
  glVertex3f(-1.0, -1.0, 1.0)

  # Back face (z = -1.0f)
  glColor3f(1.0, 1.0, 0.0)     # Yellow
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f( 1.0,  1.0, -1.0)
  glVertex3f( 1.0, -1.0, -1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  
  # Left face (x = -1.0f)
  glColor3f(0.0, 0.0, 1.0)     # Blue
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0,  1.0, -1.0)
  glVertex3f(-1.0, -1.0, -1.0)
  glVertex3f(-1.0, -1.0,  1.0)
  glVertex3f(-1.0,  1.0,  1.0)
  glVertex3f(-1.0, -1.0, -1.0)

  # Right face (x = 1.0f)
  glColor3f(1.0, 0.0, 1.0)    # Magenta
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0,  1.0,  1.0)
  glVertex3f(1.0, -1.0,  1.0)
  glVertex3f(1.0, -1.0, -1.0)
  glVertex3f(1.0,  1.0, -1.0)
  glVertex3f(1.0, -1.0,  1.0)
  
  glEnd()  # End of drawing
  
  window.display() # Swap the front and back frame buffers (double buffering)

# Main loop

var 
  evt: TEvent
  runGame = true

while runGame:
  while window.pollEvent(evt):
    case evt.kind
    of evtclosed:
      runGame = false
    of evtresized:
      reshape()
    else: discard
  render()
  
window.close()

