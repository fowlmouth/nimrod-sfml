import
  sfml
const
  Lib = "libcsfml-audio.so.2.0"
type
  PMusic* = ptr TMusic
  TMusic* {.pure, final.} = object
  PSound* = ptr TSound
  TSound* {.pure, final.} = object
  TSoundBuffer* {.pure, final.} = object
  TSoundBufferRecorder* {.pure, final.} = object
  TSoundRecorder* {.pure, final.} = object
  TSoundStream* {.pure, final.} = object
  TSoundStatus* {.size: sizeof(cint).} = enum
    Stopped, Paused, Playing

proc newMusic*(filename: cstring): PMusic {.
  cdecl, importc: "sfMusic_createFromFile", dynlib: Lib.}
proc newMusic*(data: pointer, size: cint): PMusic {.
  cdecl, importc: "sfMusic_createFromMemory", dynlib: Lib.}
proc newMusic*(stream: PInputStream): PMusic {.
  cdecl, importc: "sfMusic_createFromStream", dynlib: Lib.}
proc destroy*(music: PMusic) {.
  cdecl, importc: "sfMusic_destroy", dynlib: Lib.}
proc setLoop*(music: PMusic, loop: TBool) {.
  cdecl, importc: "sfMusic_setLoop", dynlib: Lib.}
proc getLoop*(music: PMusic): TBool {.
  cdecl, importc: "sfMusic_getLoop", dynlib: Lib.}
proc getDuration*(music: PMusic): TTime {.
  cdecl, importc: "sfMusic_getDuration", dynlib: Lib.}
proc play*(music: PMusic) {.
  cdecl, importc: "sfMusic_play", dynlib: Lib.}
proc pause*(music: PMusic) {.
  cdecl, importc: "sfMusic_pause", dynlib: Lib.}
proc stop*(music: PMusic) {.
  cdecl, importc: "sfMusic_stop", dynlib: Lib.}
proc getChannelCount*(music: PMusic): cint {.
  cdecl, importc: "sfMusic_getChannelCount", dynlib: Lib.}
proc getSampleRate*(music: PMusic): cint {.
  cdecl, importc: "sfMusic_getSampleRate", dynlib: Lib.}
proc getStatus*(music: PMusic): TSoundStatus {.
  cdecl, importc: "sfMusic_getStatus", dynlib: Lib.}
proc getPlayingOffset*(music: PMusic): TTime {.
  cdecl, importc: "sfMusic_getPlayingOffset", dynlib: Lib.}
proc setPitch*(music: PMusic, pitch: cfloat) {.
  cdecl, importc: "sfMusic_setPitch", dynlib: Lib.}
proc setVolume*(music: PMusic, volume: float) {.
  cdecl, importc: "sfMusic_setVolume", dynlib: Lib.}
proc setPosition*(music: PMusic, position: TVector3f) {.
  cdecl, importc: "sfMusic_setPosition", dynlib: Lib.}
proc setRelativeToListener*(music: PMusic, relative: TBool) {.
  cdecl, importc: "sfMusic_setRelativeToListener", dynlib: Lib.}
proc setMinDistance*(music: PMusic, distance: cfloat) {.
  cdecl, importc: "sfMusic_setMinDistance", dynlib: Lib.}
proc setAttenuation*(music: PMusic, attenuation: cfloat) {.
  cdecl, importc: "sfMusic_setAttenuation", dynlib: Lib.}
proc setPlayingOffset*(music: PMusic, time: TTime) {.
  cdecl, importc: "sfMusic_setPlayingOffset", dynlib: Lib.}
proc getPitch*(music: PMusic): cfloat {.
  cdecl, importc: "sfMusic_getPitch", dynlib: Lib.}
proc getVolume*(music: PMusic): cfloat {.
  cdecl, importc: "sfMusic_getVolume", dynlib: Lib.}
proc getPosition*(music: PMusic): TVector3f {.
  cdecl, importc: "sfMusic_getPosition", dynlib: Lib.}
proc isRelativeToListener*(music: PMusic): TBool {.
  cdecl, importc: "sfMusic_isRelativeToListener", dynlib: Lib.}
proc getMinDistance*(music: PMusic): cfloat {.
  cdecl, importc: "sfMusic_isRelativeToListener", dynlib: Lib.}
proc getAttenuation*(music: PMusic): cfloat {.
  cdecl, importc: "sfMusic_isRelativeToListener", dynlib: Lib.}


