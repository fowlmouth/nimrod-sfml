discard """
A simple program to test your joystick/gamepad

Copyright (C) 2012 Fowlmouth

Permission is hereby granted, free of charge, to any person obtaining a copy of 
this software and associated documentation files (the "Software"), to deal in 
the Software without restriction, including without limitation the rights to 
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"""
import csfml, csfml_colors, strutils
type
  PJoystick = ref object
    axes: array[TJoystickAxis, AxisVisualRepresentation]
  AxisVisualRepresentation = ref object
    bg: PRectangleShape
    txt: PText
var
  window = newRenderWindow(videoMode(800, 600, 32), "joystick test", sfDefaultStyle)
  messages: seq[PText] = @[]
  guiFont = newFont("LiberationMono-Regular.ttf")
  messagesVisible = 10
  event: csfml.TEvent
  joysticks: seq[PJoystick] = @[]

window.setFramerateLimit 60

proc ff*(f: float; precision = 2): string =
  return formatFloat(f, ffDecimal, precision)

proc addMsg*(text: string) = 
  messages.add(
    newText(text, guiFont, 16)) 

block:
  var 
    startY = float(messagesVisible * 20)
    pos = vec2f(0.0, startY)
  for i in 0..3:
    if joystickIsConnected(0):
      var js: PJoystick
      new(js)
      for a in TJoystickAxis:
        var ax: AxisVisualRepresentation
        new(ax)
        ax.bg  = newRectangleShape()
        ax.bg.setSize(vec2f(180, 20))
        ax.bg.setFillColor(Gray)
        ax.bg.setPosition(pos)
        ax.txt = newText("", guiFont, 16)
        ax.txt.setPosition(pos)
        ax.txt.setColor(black)
        js.axes[a] = ax 
        pos.y += 20
      
      joysticks.add js
      addMsg "JS"&($i)&" is connected"
      pos.y  = startY
      pos.x += 210

while window.isOpen():
  while window.pollEvent(event):
    case event.kind
    of EvtClosed:
      window.close()
    of EvtKeyPressed:
      if event.key.code == KeyEscape:
        window.close()
    of EvtJoystickConnected:
      addMsg("Joystick connected: "& $(event.joystickConnect.joystickID))
    of EvtJoystickButtonPressed:
      addMsg("Joy button pressed: $1:$2".format(
        event.joystickButton.joystickID, event.joystickButton.button))
    of EvtJoystickButtonReleased:
      addMsg("Joy button released: $1:$2".format(
        event.joystickButton.joystickID, event.joystickButton.button))
    of EvtJoystickMoved:
      #addMsg("Joystick move $1:$2:$3".format(
      #  event.joystickMove.joystickID, event.joystickMove.axis, event.joystickMove.position))
      var vr = joysticks[event.joystickMove.joystickID].axes[event.joystickMove.axis]
      vr.txt.setString($event.joystickMove.axis &": "& ff(event.joystickMove.position))
    else:
      #addMsg("Unknown event: "& $event.kind)
  
  var pos = vec2f(0, 0)
  for m in countdown(len(messages) - 1, max(0, len(messages) - messagesVisible)):
    messages[m].setPosition(pos)
    pos.y += 20
  
  if len(messages) > messagesVisible:
    ## destroy old messages
    for i in 0..(len(messages) - messagesVisible - 1):
      messages[0].destroy()
      messages.delete 0
  
  window.clear Black
  for m in items(messages):
    window.draw m
  
  for js in items(joysticks):
    for ax in items(js.axes):
      window.draw ax.bg
      window.draw ax.txt
    
  window.display()

