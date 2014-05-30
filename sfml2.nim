# SFML C++ wrapper, made possible by clibpp (babel install clibpp)

when not defined(CPP):
  {.error: "SFML is a C++ library, please compile in CPP mode or use the CSFML wrapper".}

import clibpp

{.passl: "-lsfml-graphics -lsfml-window -lsfml-system".}
const
  graphics_h = "<SFML/Graphics.hpp>"
  window_h = "<SFML/Window.hpp>"
  system_h = "<SFML/System.hpp>"

proc sf (ident:string): string = "sf::"& ident

var
  Style_Default* {.importc:"sf::Style::Default", header:graphics_h.}: uint32

#type VideoMode* {.importc:"sf::VideoMode",header:window_h.} = object
#    VideoMode(unsigned int modeWidth, unsigned int modeHeight, unsigned int modeBitsPerPixel = 32);
class(VideoMode, importc: sf"VideoMode", header:window_h):
  ##
proc newVideoMode* (W,H: cuint; bpp = 32.cuint): VideoMode {.importc:sf"VideoMode",header:window_h.} 

type EventType*{.pure.} = enum
  Closed,                # ///< The window requested to be closed (no data)
  Resized,               # ///< The window was resized (data in event.size)
  LostFocus,             # ///< The window lost the focus (no data)
  GainedFocus,           # ///< The window gained the focus (no data)
  TextEntered,           # ///< A character was entered (data in event.text)
  KeyPressed,            # ///< A key was pressed (data in event.key)
  KeyReleased,           # ///< A key was released (data in event.key)
  MouseWheelMoved,       # ///< The mouse wheel was scrolled (data in event.mouseWheel)
  MouseButtonPressed,    # ///< A mouse button was pressed (data in event.mouseButton)
  MouseButtonReleased,   # ///< A mouse button was released (data in event.mouseButton)
  MouseMoved,            # ///< The mouse cursor moved (data in event.mouseMove)
  MouseEntered,          # ///< The mouse cursor entered the area of the window (no data)
  MouseLeft,             # ///< The mouse cursor left the area of the window (no data)
  JoystickButtonPressed, # ///< A joystick button was pressed (data in event.joystickButton)
  JoystickButtonReleased,# ///< A joystick button was released (data in event.joystickButton)
  JoystickMoved,         # ///< The joystick moved along an axis (data in event.joystickMove)
  JoystickConnected,     # ///< A joystick was connected (data in event.joystickConnect)
  JoystickDisconnected   # ///< A joystick was disconnected (data in event.joystickConnect)


class(Event, importc: sf"Event", header:window_h) do:
  ##
  var kind* {.importc:"type".}: EventType

class(Color, importc:sf"Color", header:graphics_h):
  ##
proc newColor* (r,g,b:uint8,a=255'u8): Color {.importc: sf"Color",header: graphics_h.}



class(Vector2f, importc:sf"Vector2f",header:system_h):
  discard
proc vec2f* (x,y: float): Vector2f {.importc:sf"Vector2f", header:system_h.}



class(CircleShape, importc:sf"CircleShape", header:graphics_h):
  #proc setFillColor* (color:Color) 
  ##
proc newCircleShape* (radius: float): CircleShape {.importc:"sf::CircleShape", header:graphics_h.}


class(RectangleShape, importc:sf"RectangleShape", header:graphics_h):
  proc setSize* (size: Vector2f)
  proc getSize* : ptr Vector2f


type Drawable = CircleShape | RectangleShape #| ...
proc setFillColor* (D:Drawable; color:Color) {.importcpp,header:graphics_h.}


class(RenderWindow, importc: sf"RenderWindow", header: window_h) do:
  proc create* (mode:VideoMode; title:cstring; style:uint32)
  proc isOpen* : bool
  proc close* 
  proc clear* 
  proc display*
  proc pollEvent* (dest: Event): bool
  
  proc draw* (obj: Drawable)

# proc delete* [A](some: var A) = {.emit: "delete `some`;".} 

when isMainModule:

  proc main =
    var w{.noInit.}: RenderWindow
    w.create(newVideoMode(800,600,32), "foo", StyleDefault)
    let 
      shape = newCircleShape(100.0)
    shape.setFillColor newColor(0,255,0)
    
    var shape2{.noInit.}: RectangleShape
    shape2.setSize vec2f(40,20)
    shape2.setFillColor newColor(255,0,0)
    
    while w.isOpen:
      var event{.noinit.}: Event
      while w.pollEvent(event):
        if event.kind == EventType.Closed:
          w.close
      
      w.clear
      w.draw shape
      w.draw shape2
      w.display

  main()  

