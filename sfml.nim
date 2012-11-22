import unsigned

when not defined(CPP):
  {.error: "SFML is a C++ library, please compile in CPP mode or use the CSFML wrapper".}

{.link: "/usr/lib/libsfml-window.so".}
{.link: "/usr/lib/libsfml-graphics.so".}
{.link: "/usr/lib/libsfml-system.so".}

const
  sf_h = "<SFML/Graphics.hpp>"

template sfml_header*(): stmt {.immediate, dirty.} =
  {.emit: """
#include <SFML/Graphics.hpp>
using namespace sf;
""".}

sfml_header()

{.deadCodeElim: on.}
type
  TWindow* {.pure, bycopy, inheritable, header: sf_h, importc: "sf::Window".} = object
  TRenderWindow* {.pure, bycopy, header: sf_h, importc: "sf::RenderWindow".} = object of TWindow
  
  TView* {.pure, bycopy, header: sf_h, importc: "sf::View".} = object
  
  ## Fake types to deal with multiple inheritance (:
  TDrawable* = TSprite | TShape | TText
  TTransformable* = TSprite | TShape | TText
  TShape* = TRectangleShape | TCircleShape | TConvexShape
  
  ## This works for sf::String until there's a reason to wrap it
  TString* = cstring
  
  TRenderStates* {.pure, bycopy, header: sf_h, importc: "sf::RenderStates".} = object
    blendMode*: TBlendMode
    transform*: TTransform
    texture*: PTexture
    shader*: PShader
  
  TBlendMode* {.size: sizeof(cint).} = enum
    BlendAlpha, BlendAdd, BlendMultiply, BlendNone
  TTransform* {.pure, bycopy, header: sf_h, importc: "sf::Transform".} = object
    matrix*: array[0 .. <16, float32]
  
  PTexture* = ptr TTexture
  TTexture* {.pure, bycopy, header: sf_h, importc: "sf::Texture".} = object ## inherits GLresource
  
  PShader* = ptr TShader
  TShader* {.pure, bycopy, header: sf_h, importc: "sf::Shader".} = object 
  
  TImage* {.pure, bycopy, header: sf_h, importc: "sf::Image".} = object
  
  TFont* {.pure, bycopy, header: sf_h, importc: "sf::Font".} = object
  TGlyph* {.pure, bycopy, header: sf_h, importc: "sf::Glyph".} = object
  
  TSprite* {.pure, bycopy, header: sf_h, importc: "sf::Sprite".} = object
  TRectangleShape* {.pure, bycopy, header: sf_h, importc: "sf::RectangleShape".} = object
  TCircleShape* {.pure, bycopy, header: sf_h, importc: "sf::CircleShape".} = object
  TConvexShape* {.pure, bycopy, header: sf_h, importc: "sf::ConvexShape".} = object
  TText* {.pure, bycopy, header: sf_h, importc: "sf::Text".} = object ## inherits drawable, transformable
  
  TTextStyle* {.size: sizeof(cint), importc: "sf::Text::Style".} = enum
    TextRegular = 0, TextBold = 1 shl 0,
    TextItalic = 1 shl 1, TextUnderlines = 1 shl 2
  
  TCoordinateType* {.size: sizeof(cint).} = enum
    CoordNormalized, CoordPixels
  
  TContextSettings* {.bycopy, pure, header: sf_h, importc: "sf::ContextSettings".} = object
    depthBits*, stencilBit*, antiAliasing*, majorVersion*, minorVersion*: cint
  
  TVideoMode* {.pure, header: sf_h, importc: "sf::VideoMode".} = object
    width*, height*, bitsPerPixel*: cint
  
  TColor* {.pure, header: sf_h, importc: "sf::Color".} = object
    r*, g*, b*, a*: uint8
  
  TEventType* {.size: sizeof(cint).} = enum
    EvtClosed,                 ## The window requested to be closed (no data)
    EvtResized,                ## The window was resized (data in event.size)
    EvtLostFocus,              ## The window lost the focus (no data)
    EvtGainedFocus,            ## The window gained the focus (no data)
    EvtTextEntered,            ## A character was entered (data in event.text)
    EvtKeyPressed,             ## A key was pressed (data in event.key)
    EvtKeyReleased,            ## A key was released (data in event.key)
    EvtMouseWheelMoved,        ## The mouse wheel was scrolled (data in event.mouseWheel)
    EvtMouseButtonPressed,     ## A mouse button was pressed (data in event.mouseButton)
    EvtMouseButtonReleased,    ## A mouse button was released (data in event.mouseButton)
    EvtMouseMoved,             ## The mouse cursor moved (data in event.mouseMove)
    EvtMouseEntered,           ## The mouse cursor entered the area of the window (no data)
    EvtMouseLeft,              ## The mouse cursor left the area of the window (no data)
    EvtJoystickButtonPressed,  ## A joystick button was pressed (data in event.joystickButton)
    EvtJoystickButtonReleased, ## A joystick button was released (data in event.joystickButton)
    EvtJoystickMoved,          ## The joystick moved along an axis (data in event.joystickMove)
    EvtJoystickConnected,      ## A joystick was connected (data in event.joystickConnect)
    EvtJoystickDisconnected,   ## A joystick was disconnected (data in event.joystickConnect)
    EvtCount                   ## Keep last -- the total number of event types
  
  TEvent* {.bycopy, pure, header: sf_h, importc: "sf::Event".} = object
    case kind*{.importc: "type".}: TEventType
    of EvtResized:
      size*: TSizeEvent
    of EvtKeyPressed, EvtKeyReleased:
      key*: TKeyEvent
    of EvtTextEntered:
      text*: TTextEvent
    of EvtMouseWheelMoved:
      mouseWheel*: TMouseWheelEvent
    of EvtMouseButtonPressed, EvtMouseButtonReleased:
      mouseButton*: TMouseButtonEvent
    of EvtMouseMoved:
      mouseMove*: TMouseMoveEvent
    of EvtJoystickButtonPressed, EvtJoystickButtonReleased:
      joystickButton*: TJoystickButtonEvent
    of EvtJoystickMoved:
      joystickMove*: TJoystickMoveEvent
    of EvtJoystickConnected, EvtJoystickDisconnected:
      joystickConnect*: TJoystickConnectEvent
    else:
      nil
  
  TSizeEvent* {.pure, header: sf_h, importc: "sf::Event::SizeEvent".} = object
    width*, height*: uint32
  TKeyEvent* {.pure, header: sf_h, importc: "sf::Event::KeyEvent".} = object
    code*: TKeyCode
    alt*, control*, shift*, system*: bool
  TTextEvent* {.pure, header: sf_h, importc: "sf::Event::TextEvent".} = object
    unicode*: uint32
  TMouseMoveEvent* {.pure, header: sf_h, importc: "sf::Event::MouseMoveEvent".} = object
    x*, y*: int32
  TMouseButtonEvent* {.pure, header: sf_h, importc: "sf::Event::MouseButtonEvent".} = object
    button*: TMouseButton
    x*, y*: int32
  TMouseWheelEvent* {.pure, header: sf_h, importc: "sf::Event::MouseWheelEvent".} = object
    delta*: int32
    x*, y*: int32
  TJoystickConnectEvent* {.pure, header: sf_h, importc: "sf::Event::JoystickConnectEvent".}=object
    joystickId*: int32
  TJoystickMoveEvent* {.pure, header: sf_h, importc: "sf::Event::JoystickMoveEvent".} = object
    joystickId*: int32
    axis*: TJoystickAxis
    position*: float32
  TJoystickButtonEvent* {.pure, header: sf_h, importc: "sf::Event::JoystickButtonEvent".} = object
    joystickId*: int32
    button*: int32
  
  TJoystickAxis*{.size: sizeof(cint).} = enum
    JoystickX, JoystickY, JoystickZ, JoystickR, JoystickU, JoystickV,
    JoystickPovX, JoystickPovY
  
  TMouseButton*{.size: sizeof(cint).} = enum
    MouseLeft, MouseRight, MouseMiddle, MouseXButton1, MouseXButton2, MouseButtonCount
  
  TKeyCode*{.size: sizeof(cint).} = enum 
    KeyUnknown = - 1, KeyA, KeyB, KeyC, KeyD, KeyE,
    KeyF, KeyG, KeyH, KeyI, KeyJ, KeyK, KeyL, KeyM,                 #/< The M key
    KeyN, KeyO, KeyP, KeyQ, KeyR, KeyS, KeyT, KeyU,                 #/< The U key
    KeyV, KeyW, KeyX, KeyY, KeyZ, KeyNum0, KeyNum1,              #/< The 1 key
    KeyNum2, KeyNum3, KeyNum4, KeyNum5, KeyNum6,              #/< The 6 key
    KeyNum7, KeyNum8, KeyNum9, KeyEscape, KeyLControl,          #/< The left Control key
    KeyLShift, KeyLAlt, KeyLSystem, KeyRControl,          #/< The right Control key
    KeyRShift, KeyRAlt, KeyRSystem, KeyMenu,              #/< The Menu key
    KeyLBracket, KeyRBracket, KeySemiColon, KeyComma,             #/< The , key
    KeyPeriod, KeyQuote, KeySlash, KeyBackSlash,         #/< The \ key
    KeyTilde, KeyEqual, KeyDash, KeySpace, KeyReturn,            #/< The Return key
    KeyBack, KeyTab, KeyPageUp, KeyPageDown, KeyEnd,               #/< The End key
    KeyHome, KeyInsert, KeyDelete, KeyAdd, KeySubtract,          #/< -
    KeyMultiply, KeyDivide, KeyLeft, KeyRight, KeyUp,                #/< Up arrow
    KeyDown, KeyNumpad0, KeyNumpad1, KeyNumpad2,           #/< The numpad 2 key
    KeyNumpad3,           #/< The numpad 3 key
    KeyNumpad4,           #/< The numpad 4 key
    KeyNumpad5,           #/< The numpad 5 key
    KeyNumpad6,           #/< The numpad 6 key
    KeyNumpad7,           #/< The numpad 7 key
    KeyNumpad8,           #/< The numpad 8 key
    KeyNumpad9,           #/< The numpad 9 key
    KeyF1,                #/< The F1 key
    KeyF2,                #/< The F2 key
    KeyF3,                #/< The F3 key
    KeyF4,                #/< The F4 key
    KeyF5,                #/< The F5 key
    KeyF6,                #/< The F6 key
    KeyF7,                #/< The F7 key
    KeyF8,                #/< The F8 key
    KeyF9,                #/< The F8 key
    KeyF10,               #/< The F10 key
    KeyF11,               #/< The F11 key
    KeyF12,               #/< The F12 key
    KeyF13,               #/< The F13 key
    KeyF14,               #/< The F14 key
    KeyF15,               #/< The F15 key
    KeyPause,             #/< The Pause key
    KeyCount              #/< Keep last -- the total number of keyboard keys
  
  TVector2i* {.pure, header: sf_h, importc: "sf::Vector2i".} = object
    x*, y*: int32
  TVector2f* {.pure, header: sf_h, importc: "sf::Vector2f".} = object
    x*, y*: float32
  
  
  TIntRect* {.pure, header: sf_h, importc: "sf::IntRect".} = tuple[left, top, width, height: int32]
  TFloatRect* = tuple[left, top, width, height: float32]

when defined(Linux):
  type TWindowHandle* = culong
elif defined(Windows):
  type TWindowHandle* = pointer ## HWND__*
elif defined(MacOS): ## is this the right conditional?
  type TWindowHandle* = pointer ## void*

var
  DefaultRenderState* {.nodecl, importc: "sf::RenderStates::Default".}: TRenderStates

const
  sfNone*: cuint         = 0
  sfTitlebar*: cuint     = 1 shl 0
  sfResize*: cuint       = 1 shl 1
  sfClose*: cuint        = 1 shl 2
  sfFullscreen*: cuint   = 1 shl 3
  sfDefaultStyle*: cuint = sfTitlebar or sfResize or sfClose


proc destroy*[A](some: var A) = {.emit: "delete `some`;".}
  ## C++ destructor

## constructors  
proc ContextSettings*(depth = 0'i32, stencil = 0'i32, antiAlias = 0'i32,
  major = 2'i32, minor = 0'i32): TContextSettings {.
  header: sf_h, importc: "sf::ContextSettings".}
proc VideoMode*(width, height, bpp: cint): TVideoMode {.
  header: sf_h, importc: "sf::VideoMode".}
proc Color*(r, g, b: uint8; a = 255'u8): TColor {.
  header: sf_h, importc: "sf::Color".}

proc Vec2f*(x, y: float32): TVector2f = 
  result.x = x
  result.y = y

proc Window*(): TWindow {.
  header: sf_h, importc: "Window".}

proc Window*(mode: TVideoMode; title: cstring; 
  style = sfDefaultStyle; settings = ContextSettings()): TWindow {.
  header: sf_h, importc: "Window".}

proc Texture*(): TTexture {.header: sf_h, importc: "Texture".}
proc Texture*(copy: TTexture): TTexture {.header: sf_h, importc.}

proc Sprite*(texture: TTexture): TSprite {.
  header: sf_h, importc: "Sprite".}
proc Sprite*(texture: TTexture; rectangle: TIntRect): TSprite {.
  header: sf_h, importc: "Sprite".}

proc Text*(): TText {.header: sf_h, importc: "Text".}
#proc Text*(str: TString; font: TFont; characterSize = 30'i32): TText {.header: sf_h, importc: "Text".}

proc RectangleShape*(size = Vec2f(0, 0)): TRectangleShape {.
  header: sf_h, importc: "RectangleShape".}
proc ConvexShape*(pointCount = 0'u32): TConvexShape {.
  header: sf_h, importc: "ConvexShape".}
proc CircleShape*(radius = 0'f32; pointCount = 30'i32): TCircleShape {.
  header: sf_h, importc: "CircleShape".}


proc IntRect*(): TIntRect {.header: sf_h, importc: "IntRect".}
proc IntRect*(left, top, width, height: int32): TIntRect {.
  header: sf_h, importc: "IntRect".}



proc create*(window: TWindow; mode: TVideoMode; title: cstring; 
  style = sfDefaultStyle; settings = ContextSettings()) {.
  header: sf_h, importcpp: "Window::create".}

proc create*(window: TRenderWindow; mode: TVideoMode; title: cstring; 
  style = sfDefaultStyle; settings = ContextSettings()) {.
  header: sf_h, importcpp: "Window::create".}

proc getDesktopMode*(): TVideoMode {.
  header: sf_h, importc: "VideoMode::getDesktopMode".}

proc isKeyPressed*(key: TKeyCode) {.header: sf_h, importc: "sf::Keyboard::isKeyPressed".}
proc isButtonPressed*(button: TMouseButton) {.header: sf_h, importc: "sf::Mouse::isButtonPressed".}

proc getMousePosition*(): TVector2i {.header: sf_h, importc: "sf::Mouse::getPosition".}
proc getMousePosition*(relativeTo: TRenderWindow): TVector2i {.header: sf_h, importc: "sf::Mouse::getPosition".}
proc setMousePosition*(position: TVector2i) {.header: sf_h, importc: "sf::Mouse::setPosition".}
proc setMousePosition*(position: TVector2i; relativeTo: TRenderWindow) {.header: sf_h, importc: "sf::Mouse::setPosition".}

proc joystickIsConnected*(joystick: int32): bool {.header: sf_h, importc: "sf::Joystick::isConnected".}
proc joystickGetButtonCount*(joystick: int32): int32 {.header: sf_h, importc: "sf::Joystick::getButtonCount".}
proc joystickHasAxis*(joystick: int32; axis: TJoystickAxis): bool {.header: sf_h, importc: "sf::Joystick::hasAxis".}
proc joystickIsButtonPressed*(joystick: int32; button: int32): bool {.header: sf_h, importc: "sf::Joystick::isButtonPressed".}
proc joystickGetAxisPosition*(joystick: int32; axis: TJoystickAxis): float32 {.header: sf_h, importc: "sf::Joystick::getAxisPosition".}
proc joystickUpdate*(joystick: int32) {.header: sf_h, importc: "sf::Joystick::update".}

## sf::Window methods

proc close*(window: TRenderWindow) {.importcpp.}
proc isOpen*(window: TRenderWindow): bool {.importcpp.}
proc getSettings*(window: TRenderWindow): var TContextSettings {.importcpp.}
proc pollEvent*(window: TRenderWindow; event: TEvent): bool {.importcpp.}
proc waitEvent*(window: TRenderWindow; event: TEvent): bool {.importcpp.}
proc getPosition*(window: TRenderWindow): TVector2i {.importcpp.}
proc setPosition*(window: TRenderWindow; pos: TVector2i) {.importcpp.}
proc getSize*(window: TRenderWindow): TVector2i {.importcpp.}
proc setSize*(window: TRenderWindow; size: TVector2i) {.importcpp.}
proc setTitle*(window: TRenderWindow; title: cstring) {.importcpp.}
proc setIcon*(window: TRenderWindow; width, height: int32; pixels: ptr uint8) {.importcpp.}
proc setVisible*(window: TRenderWindow; visible: bool){.importcpp.}
proc setVerticalSyncEnabled*(window: TRenderWindow; enabled: bool){.importcpp.}
proc setMouseCursorVisible*(window: TRenderWindow; visible: bool) {.importcpp.}
proc setKeyRepeatEnabled*(window: TRenderWindow; enabled: bool) {.importcpp.}
proc setFramerateLimit*(window: TRenderWindow; limit: int32) {.importcpp.}
proc setJoystickThreshold*(window: TRenderWindow; threshold: range[float32(0) .. float32(100)]) {.importcpp.}
  ## range comes from sfml/window/window.hpp
proc setActive*(window: TRenderWindow; active = true) {.importcpp.}
proc display*(window: TRenderWindow) {.importcpp.}
proc getSystemHandle*(window: TRenderWindow): TWindowHandle {.importcpp.}


## sf::RenderTarget methods
## TODO: duplicate for rendertexture
proc clear*(window: TRenderWindow; color = Color(0, 0, 0, 255)) {.importcpp.}
proc setView*(window: TRenderWindow; view: TView) {.importcpp.}
proc getView*(window: TRenderWindow): var TView {.importcpp.}
proc getDefaultView*(window: TRenderWindow): var TView {.importcpp.}
proc getViewport*(window: TRenderWindow; view: TView): TIntRect {.importcpp.}
proc convertCoords*(window: TRenderWindow; point: TVector2i): TVector2f {.importcpp.}
proc convertCoords*(window: TRenderWindow; point: TVector2i; view: TView): TVector2f {.importcpp.}
proc draw*(window: TRenderWindow; drawable: TDrawable; renderState = DefaultRenderState) {.importcpp.}

## sf::Shape methods
proc setTexture*(shape: TShape; texture: PTexture; resetRect = false) {.importcpp.}
proc setTextureRect*(shape: TShape; rect: TIntRect) {.importcpp.}
proc setFillColor*(shape: TShape; color: TColor) {.importcpp.}
proc setOutlineColor*(shape: TShape; color: TColor) {.importcpp.}
proc setOutlineThickness*(shape: TShape; thickness: float32) {.importcpp.}
proc getTexture*(shape: TShape): PTexture {.importcpp.}
proc getTextureRect*(shape: TShape): var TintRect {.importcpp.}
proc getFillColor*(shape: TShape): var TColor {.importcpp.} 
proc getOutlineColor*(shape: TShape): var TColor {.importcpp.}
proc getOutlineThickness*(shape: TShape): float32 {.importcpp.}
proc getPointCount*(shape: TShape): int32 {.importcpp.}
proc getPoint*(shape: TShape; index: int32): TVector2f {.importcpp.}
proc getLocalBounds*(shape: TShape): TFloatRect {.importcpp.}
proc getGlobalBounds*(shape: TShape): TFloatRect {.importcpp.}


## sf::Transformable
proc setPosition*(transformable: TTransformable; position: TVector2f) {.importcpp.}
proc setPosition*(transformable: TTransformable; x, y: float32) {.importcpp.}
proc setRotation*(transformable: TTransformable; angle: float32) {.importcpp.}
proc setScale*(transformable: TTransformable; scale: TVector2f) {.importcpp.}
proc setScale*(transformable: TTransformable; factorX, factorY: float32) {.importcpp.}
proc setOrigin*(transformable: TTransformable; origin: TVector2f) {.importcpp.}
proc setOrigin*(transformable: TTransformable; x, y: float32) {.importcpp.}
proc getPosition*(transformable: TTransformable): var TVector2f {.importcpp.}
proc getRotation*(transformable: TTransformable): float32 {.importcpp.}
proc getScale*(transformable: TTransformable): var TVector2f {.importcpp.}
proc getOrigin*(transformable: TTransformable): var TVector2f {.importcpp.}
proc move*(transformable: TTransformable; offset: TVector2f) {.importcpp.}
proc move*(transformable: TTransformable; offsetX, offsetY: float32) {.importcpp.}
proc rotate*(transformable: TTransformable; angle: float32) {.importcpp.}
proc scale*(transformable: TTransformable; factorX, factorY: float32) {.importcpp.}
proc scale*(transformable: TTransformable; factor: TVector2f) {.importcpp.}
proc getTransform*(transformable: TTransformable): var TTransform {.importcpp.}
proc getInverseTransform*(transformable: TTransformable): var TTransform {.importcpp.}

## sf::CircleShape
proc setRadius*(shape: TCircleShape; radius: float32) {.importcpp.}
proc getRadius*(shape: TCircleShape): float32 {.importcpp.}
proc setPointCount*(shape: TCircleShape; count: int32) {.importcpp.}
#proc getPointCount*(

## sf::RectangleShape
proc setSize*(shape: TRectangleShape; size: TVector2f) {.importcpp.}
proc getSize*(shape: TRectangleShape): var TVector2f {.importcpp.}

## sf::ConvexShape
proc setPointCount*(shape: TConvexShape; count: range[2'i32 .. high(int32)]) {.importcpp.}
#proc getPointCount*(shape: TConvexShape): int32
proc setPoint*(shape: TConvexShape; index: int32; point: TVector2f) {.importcpp.}
#proc getPoint*(shape: TConvexShape): TVector2f{.importcpp.}


## sf::Sprite
## TODO see which of these i can upstream to TDrawable or TTransformable
proc setTexture*(sprite: TSprite; texture: TTexture; resetRect = false){.importcpp.}
proc setTextureRect*(sprite: TSprite; rectangle: TIntRect) {.importcpp.}
proc setColor*(sprite: TSprite; color: TColor) {.importcpp.}
proc getTexture*(sprite: TSprite): PTexture {.importcpp.}
proc getTextureRect*(sprite: TSprite): TIntRect {.importcpp.}
proc getColor*(sprite: TSprite): TColor {.importcpp.}
proc getLocalBounds*(sprite: TSprite): TFloatRect {.importcpp.}
proc getGlobalBounds*(sprite: TSprite){.importcpp.}


## sf::Texture
proc create*(tex: TTexture; width, height: int32): bool {.importcpp.}
proc loadFromFile*(tex: TTexture; filename: cstring; 
  area = IntRect()): bool {.importcpp.}
proc loadFromMemory*(tex: TTexture; data: pointer; size: csize; 
  area = IntRect()): bool {.importcpp.}
#proc loadFromStream*(tex: TTexture; stream: TInputStream; 
#  area = IntRect()): bool {.importcpp.}
proc loadFromImage*(tex: TTexture; image: TImage; area = IntRect()): bool {.
  importcpp.}
proc getSize*(tex: TTexture): TVector2i {.importcpp.}
proc copyToImage*(tex: TTexture): TImage {.importcpp.}
proc update*(tex: TTexture; pixels: ptr uint8) {.importcpp.}
proc update*(tex: TTexture; pixels: ptr uint8; width, height, x, y: int32) {.
  importcpp.}
proc update*(tex: TTexture; image: TImage) {.importcpp.}
proc update*(tex: TTexture; image: TImage; x, y: int32) {.importcpp.}
proc update*(tex: TTexture; window: TWindow) {.importcpp.}
proc update*(tex: TTexture; window: TWindow; x, y: int32) {.importcpp.}
proc bindTexture*(tex: TTexture; coordinateType = CoordNormalized) {.importcpp: "bind".}
proc setSmooth*(tex: TTexture; smooth: bool) {.importcpp.}
proc isSmooth*(tex: TTexture): bool {.importcpp.}
proc setRepeated*(tex: TTexture; repeated: bool) {.importcpp.}
proc isRepeated*(tex: TTexture): bool {.importcpp.}

proc TextureMaximumSize*(): int32 {.importc: "sf::Texture::getMaximumSize".}


## sf::Image (incomplete)
proc create*(image: TImage; width, height: int32; color = Color(0, 0, 0)) {.importcpp.}
proc create*(image: TImage; width, height: int32; pixels: ptr uint8) {.importcpp.}
proc loadFromFile*(image: TImage; filename: cstring): bool {.importcpp.}


## sf::Font
proc loadFromFile*(font: TFont; filename: cstring): bool {.importcpp.}
proc loadFromMemory*(font: TFont; data: pointer; size: csize): bool {.importcpp.}
#proc loadFromStream*(font: TFont; stream: TInputStream): bool {.importcpp.}
proc getGlyph*(font: TFont; characterSize: int32; bold: bool): var TGlyph {.importcpp.}
proc getKerning*(font: TFont; first, second: int32; characterSize: int32): int32 {.importcpp.}
proc getLineSpacing*(font: TFont; characterSize: int32): int32 {.importcpp.}
proc getTexture*(font: TFont; characterSize: int32): var TTexture {.importcpp.}


## sf::Text
#type CPFont* {.importc: "const sf::Font*".} = ptr TFont
type CFont* {.importc: "const sf::Font", pure, bycopy.} = object
proc setString*(text: TText; str: TString) {.importcpp.}
proc setFont*(text: TText; font: TFont) {.importcpp.}
proc setCharacterSize*(text: TText; size: int32) {.importcpp.}
proc setStyle*(text: TText; style: int32|TTextStyle) {.importcpp.}
proc setColor*(text: TText; color: TColor) {.importcpp.}
proc getString*(text: TText): TString {.importcpp.}
proc getFont*(text: TText): ptr CFont {.importcpp.}
proc getCharacterSize*(text: TText): int32 {.importcpp.}
proc getStyle*(text: TText): int32 {.importcpp.}
proc getColor*(text: TText): var TColor {.importcpp.}
proc findCharacterPos*(text: TText; index: csize): TVector2f {.importcpp.}
proc getLocalBounds*(text: TText): TFloatRect {.importcpp.}
proc getGlobalBounds*(text: TText): TFloatRect {.importcpp.}

#converter toInt32*(some: TTextStyle): int32 = (some.int32)





