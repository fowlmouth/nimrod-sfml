## You need classlib on your path 
#https://gist.github.com/3815893
import sfml, classlib, sfml_colors, os, math
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

classimpl ParticleDef, PParticleDef:
  var lifetime: float
  var velocity: float
  var sprite: PSprite
  var color: TColor
  
  proc free*() =
    self.sprite.destroy()
  
  proc init(self: var PParticleDef; sprite: PSprite; lifetime: float) =
    self.sprite = sprite
    self.lifetime = lifetime
    self.velocity = 1.40
  
  proc copy*(): PParticleDef =
    new(result, free)
    init(result, self.sprite, self.lifetime)
  proc newParticleDef*(fn: string; lifetime = 1.0): PParticleDef =
    new(result, free)
    var img = newImage(fn)
    var tex = newTexture(img)
    var sprite = newSprite()
    img.destroy()
    sprite.setTexture tex, true
    init(result, sprite, lifetime)
  

proc floor(a: TVector2f): TVector2f =
  result.x = a.x.floor
  result.y = a.y.floor
  
classimpl Particle, PParticle:
  var position: TVector2f
  var velocity: TVector2f
  var color: TColor
  var sprite: PSprite
  var lifetime: float = 1.0
  
  proc free() =
    self.sprite.destroy()
    
  proc newParticle*(pos, velocity: TVector2f; color: TColor; sprite: PSprite; 
      lifetime: float): PParticle {.cdecl, constructor.} =
    new(result, free)
    result.position = pos
    result.velocity = velocity
    result.sprite = sprite
    result.color = color
    result.sprite.setColor color
    result.lifetime = lifetime
    
  
  proc update*(dt: float): bool =
    self.lifetime -= dt
    if self.lifetime < 0.0:
      return true
    self.position += self.velocity * dt
    self.sprite.setposition self.position.floor()
    #self.sprite.setcolor self.sprite.getColor.addAlpha(1)


proc instanceAt*(self: PParticleDef; pos: TVector2f): PParticle =
  let angle = (random(2048) / 2_048) * 360.0 * PI / 180.0
  result = newParticle(
    pos, vec2f(cos(angle), sin(angle)) * self.velocity, 
    Green, self.sprite.copy(),
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
      self.particles.add(self.pDef.instanceAT(self.position))
  
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
    

when isMainModule:
  const
    ScreenW = 800
    ScreenH = 600

  var 
    window = newRenderWindow(videoMode(screenW, ScreenH, 32), "noise", sfDefaultStyle)
    event: TEvent
    pdef = newParticleDef("pixel.png", 7.688558)
    ps = newParticleSystem(pdef)
    clock = newClock()
    fuelRate = 350
    fueling = true
    view = window.getDefaultView.copy()
    guiFont = newFont("LiberationMono-Regular.ttf")
    debugText = newText("yo.", guiFont, 20)
  
  pdef.velocity = 80.46
  ps.set_position vec2f(screenw / 2, screenh / 2)
  ps.set_scale vec2f(4.0, 4.0)

  window.set_framerate_limit 60
  ps.fuel 400

  while window.isOpen:
    let dt = clock.restart.asMilliseconds() / 1000
    while window.pollEvent(event):
      case event.kind
      of evtclosed:
        window.close()
      of evtkeypressed:
        if event.key.code == keySpace:
          fueling = not fueling
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
      ps.fuel(int(fuelRate.float * dt))
      
    ps.update dt
    debugtext.setstring($(1.0 / dt) &"\n"& $fueling)
    window.clear Black
    window.setView view
    
    window.draw ps
    
    window.draw debugText
    
    window.display
