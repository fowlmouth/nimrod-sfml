import sfml, math, strutils

proc vec2i*(x, y: int): TVector2i =
  result.x = x.cint
  result.y = y.cint
proc vec2f*(x, y: float): TVector2f =
  result.x = x.cfloat
  result.y = y.cfloat

proc `+`*(a, b: TVector2f): TVector2f {.inline.} =
  result.x = a.x + b.x
  result.y = a.y + b.y
proc `-`*(a: TVector2f): TVector2f {.inline.} =
  result.x = -a.x
  result.y = -a.y
proc `-`*(a, b: TVector2f): TVector2f {.inline.}=
  result.x = a.x - b.x
  result.y = a.y - b.y
proc `*`*(a: TVector2f, b: cfloat): TVector2f {.inline.} =
  result.x = a.x * b
  result.y = a.y * b
proc `*`*(a, b: TVector2f): TVector2f {.inline.} =
  result.x = a.x * b.x
  result.y = a.y * b.y
proc `/`*(a: TVector2f, b: cfloat): TVector2f {.inline.} =
  result.x = a.x / b
  result.y = a.y / b
proc `+=` *(a: var TVector2f, b: TVector2f) {.inline, noSideEffect.} =
  a = a + b
proc `-=` *(a: var TVector2f, b: TVector2f) {.inline, noSideEffect.} =
  a = a - b
proc `*=` *(a: var TVector2f, b: float) {.inline, noSideEffect.} =
  a = a * b
proc `*=` *(a: var TVector2f, b: TVector2f) {.inline, noSideEffect.} =
  a = a * b
proc `/=` *(a: var TVector2f, b: float) {.inline, noSideEffect.} =
  a = a / b
proc `<` *(a, b: TVector2f): bool {.inline, noSideEffect.} =
  return a.x < b.x or (a.x == b.x and a.y < b.y)
proc `<=` *(a, b: TVector2f): bool {.inline, noSideEffect.} =
  return a.x <= b.x and a.y <= b.y
proc `==` *(a, b: TVector2f): bool {.inline, noSideEffect.} =
  return a.x == b.x and a.y == b.y
proc length*(a: TVector2f): float {.inline.} =
  return sqrt(pow(a.x, 2.0) + pow(a.y, 2.0))
proc lengthSq*(a: TVector2f): float {.inline.} =
  return pow(a.x, 2.0) + pow(a.y, 2.0)
proc distanceSq*(a, b: TVector2f): float {.inline.} =
  return pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2.0)
proc distance*(a, b: TVector2f): float {.inline.} =
  return sqrt(pow(a.x - b.x, 2.0) + pow(a.y - b.y, 2.0))
proc permul*(a, b: TVector2f): TVector2f =
  result.x = a.x * b.x
  result.y = a.y * b.y
proc rotate*(a: TVector2f, phi: float): TVector2f =
  var c = cos(phi)
  var s = sin(phi)
  result.x = a.x * c - a.y * s
  result.y = a.x * s + a.y * c
proc perpendicular(a: TVector2f): TVector2f =
  result.x = -a.x
  result.y =  a.y
proc cross(a, b: TVector2f): float =
  return a.x * b.y - a.y * b.x
