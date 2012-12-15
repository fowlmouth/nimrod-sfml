## You need classlib on your path 
#https://gist.github.com/3815893
import csfml, classlib, csfml_colors, os, math
randomize()

import unsigned
proc `*`(a: TColor, b: uint8): TColor =
  result.r = a.r * b
  result.g = a.g * b
  result.b = a.b * b
  result.a = a.a * b
proc addAlpha(a: TColor; alpha: uint8): TColor =
  result = color(a.r, a.g, a.b, a.a + alpha)
proc subAlpha(a: TColor; alpha: uint8): TColor =
  result = color(a.r, a.g, a.b, a.a - alpha)
  
proc `div`(a: TColor; b: uint8): TColor =
  result.r = a.r div b
  result.g = a.g div b
  result.b = a.b div b
  result.a = a.a div b
proc `/`(a: TColor; b: uint8): TColor{.inline.} =
  return (a div b)

proc random*(some: TSlice[float]): float = random(some.b - some.a) + some.a

classimpl ParticleDef, PParticleDef:
  var velocity: float
  var sprite: PSprite
  var lifetime_r: TSlice[float]
  #var color: TColor
  
  proc free*() =
    self.sprite.destroy()
  
  proc `lifetime=`*(val: float) =
    self.lifetime_r.a = val
    self.lifetime_r.b = val
  proc `lifetime=`*(val: TSlice[float]) = self.lifetime_r = val
  
  proc init(self: var PParticleDef; sprite: PSprite; lifetime: TSlice[float];
       velocity: float) =
    self.sprite = sprite
    self.lifetime = lifetime
    self.velocity = velocity
  
  proc copy*(): PParticleDef =
    new(result, free)
    init(result, self.sprite.copy(), self.lifetime_r, self.velocity)
  proc newParticleDef*(fn: string; lifetime = 5.2 .. 10.0): PParticleDef =
    new(result, free)
    var img = newImage(fn)
    var tex = newTexture(img)
    var sprite = newSprite()
    img.destroy()
    sprite.setTexture tex, true
    init(result, sprite, lifetime, 1.4)
  
  proc `color=`*(color: TColor) =
    self.sprite.setColor color
  proc lifetime*(): float = random(self.lifetime_r)
  

proc floor(a: TVector2f): TVector2f =
  result.x = a.x.floor
  result.y = a.y.floor
  
classimpl Particle, PParticle:
  var position: TVector2f
  var velocity: TVector2f
  #var color: TColor
  var sprite: PSprite
  var lifetime: float = 1.0
  
  proc free() =
    self.sprite.destroy()
  
  proc newParticle*(pdef: PParticleDef; pos: TVector2f): PParticle {.constructor.} =
    new result, free
    result.position = pos
    let angle = (random(2048) / 2_048) * 360.0 * PI / 180.0
    result.velocity.x = cos(angle) * pdef.velocity
    result.velocity.y = sin(angle) * pdef.velocity
    result.sprite = pdef.sprite.copy()
    result.lifetime = pdef.lifetime
  proc newParticle*(pos, velocity: TVector2f; sprite: PSprite; 
      lifetime: float): PParticle {.cdecl, constructor.} =
    new(result, free)
    result.position = pos
    result.velocity = velocity
    result.sprite = sprite
    result.lifetime = lifetime
  
  proc update*(dt: float): bool =
    self.lifetime -= dt
    if self.lifetime < 0.0:
      return true
    self.position += self.velocity * dt
    self.sprite.setposition self.position.floor()
    #self.sprite.setcolor self.sprite.getColor.addAlpha(1)

when false:
  proc instanceAt*(self: PParticleDef; pos: TVector2f): PParticle =
    result = newParticle(
      pos, vec2f(cos(angle), sin(angle)) * self.velocity, self.sprite.copy(),
      self.lifetime)

classimpl ParticleSystem, PParticleSystem:
  var
    sprite: PSprite
    position: TVector2f = vec2f(100, 100)
    color: TColor
    particles: seq[PParticle] = @[]
    emissionRate: float
    emissionDelay: float
    pDef: PParticleDef
   
  proc getPosition*(): TVector2f {.inline.} = return self.position
  proc setPosition*(val: TVector2f){.inline.} = 
    self.position = val
    self.sprite.setPosition(val)
  
  proc setColor*(val: TColor){.inline.} = 
    self.color = val
    self.sprite.setColor val
  proc getColor*(): TColor {.inline.} = return self.color
  
  proc setScale*(factor: TVector2f) {.inline.} =
    self.sprite.setScale factor
  
  
  proc update*(dt: float) =
    var i = 0
    while i <= high(self.particles):
      if self.particles[i].update(dt):
        self.particles.del i
      else:
        inc i
  proc fuel*(particles: int) =
    for i in 0..particles:
      self.particles.add(newParticle(self.pdef, self.position)) #self.pDef.instanceAT(self.position))
  
  proc draw*(window: PRenderWindow; self: PParticleSystem) =
    for p in self.particles:
      window.draw(p.sprite)
  
  discard """proc newParticleSystem*(file: string; color: TColor): PParticleSystem =
    if not existsFile(file):
      quit "File does not exist: "&file
    var 
      img = newImage(file)
      tex = newTexture(img)
    img.destroy()
    new(result)
    result.sprite = newSprite()
    result.sprite.setTexture tex, true
    result.setColor color
    result.emissionRate = 0.25
    result.particles = @[]"""
  
  proc free() =
    destroy(self.sprite)
  proc newParticleSystem*(p: PParticleDef): PParticleSystem =
    new(result, free)
    result.particles = @[]
    result.emissionRate = 0.25
    result.pdef = p
    result.sprite = p.sprite.copy()
    

proc last*[A](s: seq[A]): A =
  return s[high(s)]
proc `last=`*[A](s: seq[A]; val: A) =
  s[high(s)] = val

when isMainModule:
  const
    ScreenW = 800
    ScreenH = 600
  let
    colors = [Red, Green, Blue]

  var 
    window = newRenderWindow(videoMode(screenW, ScreenH, 32), "noise", sfDefaultStyle)
    event: TEvent
    pdef = newParticleDef("pixel.png", 0.688558 .. 9.373748)
    clock = newClock()
    fuelRate = 350
    fueling = true
    view = window.getDefaultView.copy()
    guiFont = newFont("LiberationMono-Regular.ttf")
    debugText = newText("yo.", guiFont, 20)
    pss: seq[PParticleSystem] = @[]
  
  pdef.velocity = 80.46
  pss.add(newParticleSystem(pdef))
  pss.last.set_position vec2f(screenw / 2, screenh / 2)
  pss.last.set_scale vec2f(4.0, 4.0)
  
  pdef = pdef.copy()
  pdef.color = Blue
  pss.add(newParticleSystem(pdef))
  pss.last.set_position vec2f(random(ScreenW), random(ScreenH))
  
  pdef = pdef.copy()
  pdef.color = Red
  pss.add(newParticleSystem(pdef))
  pss.last.set_position vec2f(random(ScreenW), random(ScreenH))
  

  window.set_framerate_limit 60

  while window.isOpen:
    let dt = clock.restart.asMilliseconds() / 1000
    while window.pollEvent(event):
      case event.kind
      of evtclosed:
        window.close()
      of evtkeypressed:
        case event.key.code
        of keySpace:
          fueling = not fueling
        of keyUp:
          var p = pdef.copy()
          p.color = colors[random(colors.len)]
          pss.add(newParticleSystem(p))
          pss.last.set_position vec2f(random(ScreenW), random(ScreenH))
        of keyDown:
          if pss.len > 0:
            pss.delete random(len(pss))
        of keyG:
          Gc_fullcollect()
        else:
          nil
      of evtmousewheelmoved:
        case event.mouseWheel.delta
        of 1: ## UP
          view.zoom(0.9)
        else: ## DOWN
          view.zoom(1.1)
      else:
        nil
        #echo event.kind
    
    if fueling:
      for i in pss:
        i.fuel(int(fuelRate.float * dt))
    
    for i in pss:
      i.update dt
    debugtext.setstring($(1.0 / dt) &"\n"& $fueling)
    window.clear Black
    window.setView view
    
    for i in pss:
      window.draw i
    
    window.draw debugText
    
    window.display
