import
  sfml
const
  Lib = "libcsfml-audio.so.2.0"
type
  PMusic* = ptr TMusic
  TMusic* {.pure, final.} = object
  PSound* = ptr TSound
  TSound* {.pure, final.} = object
  PSoundBuffer* = ptr TSoundBuffer
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
proc setLoop*(music: PMusic, loop: bool) {.
  cdecl, importc: "sfMusic_setLoop", dynlib: Lib.}
proc getLoop*(music: PMusic): bool {.
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
proc setRelativeToListener*(music: PMusic, relative: bool) {.
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
proc isRelativeToListener*(music: PMusic): bool {.
  cdecl, importc: "sfMusic_isRelativeToListener", dynlib: Lib.}
proc getMinDistance*(music: PMusic): cfloat {.
  cdecl, importc: "sfMusic_isRelativeToListener", dynlib: Lib.}
proc getAttenuation*(music: PMusic): cfloat {.
  cdecl, importc: "sfMusic_isRelativeToListener", dynlib: Lib.}

#/ \brief Create a new sound
proc newSound*(): PSound{.
  cdecl, importc: "sfSound_create", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Create a new sound by copying an existing one
#/
#/ \param sound Sound to copy
#/
#/ \return A new sfSound object which is a copy of \a sound
#/
#//////////////////////////////////////////////////////////
proc copy*(sound: PSound): PSound{.
  cdecl, importc: "sfSound_copy", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Destroy a sound
proc destroy*(sound: PSound){.
  cdecl, importc: "sfSound_destroy", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Start or resume playing a sound
#/
#/ This function starts the sound if it was stopped, resumes
#/ it if it was paused, and restarts it from beginning if it
#/ was it already playing.
#/ This function uses its own thread so that it doesn't block
#/ the rest of the program while the sound is played.
proc play*(sound: PSound){.
  cdecl, importc: "sfSound_play", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ This function pauses the sound if it was playing,
#/ otherwise (sound already paused or stopped) it has no effect.
proc pause*(sound: PSound){.
  cdecl, importc: "sfSound_pause", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ This function stops the sound if it was playing or paused,
#/ and does nothing if it was already stopped.
#/ It also resets the playing position (unlike sfSound_pause).
proc stop*(sound: PSound){.
  cdecl, importc: "sfSound_stop", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ It is important to note that the sound buffer is not copied,
#/ thus the sfSoundBuffer object must remain alive as long
#/ as it is attached to the sound.
proc setBuffer*(sound: PSound; buffer: PSoundBuffer){.
  cdecl, importc: "sfSound_setBuffer", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the audio buffer attached to a sound
proc sfSound_getBuffer*(sound: PSound): PSoundBuffer{.
  cdecl, importc: "sfSound_getBuffer", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set whether or not a sound should loop after reaching the end
#/
#/ If set, the sound will restart from beginning after
#/ reaching the end and so on, until it is stopped or
#/ sfSound_setLoop(sound, sfFalse) is called.
#/ The default looping state for sounds is false.
proc sfSound_setLoop*(sound: PSound; loop: bool){.
  cdecl, importc: "sfSound_setLoop", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Tell whether or not a soud is in loop mode
proc getLoop*(sound: PSound): bool {.
  cdecl, importc: "sfSound_getLoop", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the current status of a sound (stopped, paused, playing)
proc getStatus*(sound: PSound): TSoundStatus{.
  cdecl, importc: "sfSound_getStatus", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set the pitch of a sound
#/
#/ The pitch represents the perceived fundamental frequency
#/ of a sound; thus you can make a sound more acute or grave
#/ by changing its pitch. A side effect of changing the pitch
#/ is to modify the playing speed of the sound as well.
#/ The default value for the pitch is 1.
proc setPitch*(sound: PSound; pitch: cfloat){.
  cdecl, importc: "sfSound_setPitch", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set the volume of a sound
#/
#/ The volume is a value between 0 (mute) and 100 (full volume).
#/ The default value for the volume is 100.
proc setVolume*(sound: PSound; volume: cfloat){.
  cdecl, importc: "sfSound_setVolume", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set the 3D position of a sound in the audio scene
#/
#/ Only sounds with one channel (mono sounds) can be
#/ spatialized.
#/ The default position of a sound is (0, 0, 0).
proc setPosition*(sound: PSound; position: TVector3f){.
  cdecl, importc: "sfSound_setPosition", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Make the sound's position relative to the listener or absolute
#/
#/ Making a sound relative to the listener will ensure that it will always
#/ be played the same way regardless the position of the listener.
#/ This can be useful for non-spatialized sounds, sounds that are
#/ produced by the listener, or sounds attached to it.
#/ The default value is false (position is absolute).
proc setRelativeToListener*(sound: PSound; relative: bool){.
  cdecl, importc: "sfSound_setRelativeToListener", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set the minimum distance of a sound
#/
#/ The "minimum distance" of a sound is the maximum
#/ distance at which it is heard at its maximum volume. Further
#/ than the minimum distance, it will start to fade out according
#/ to its attenuation factor. A value of 0 ("inside the head
#/ of the listener") is an invalid value and is forbidden.
#/ The default value of the minimum distance is 1.
proc setMinDistance*(sound: PSound; distance: cfloat){.
  cdecl, importc: "sfSound_setMinDistance", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set the attenuation factor of a sound
#/
#/ The attenuation is a multiplicative factor which makes
#/ the sound more or less loud according to its distance
#/ from the listener. An attenuation of 0 will produce a
#/ non-attenuated sound, i.e. its volume will always be the same
#/ whether it is heard from near or from far. On the other hand,
#/ an attenuation value such as 100 will make the sound fade out
#/ very quickly as it gets further from the listener.
#/ The default value of the attenuation is 1.
proc setAttenuation*(sound: PSound; attenuation: cfloat){.
  cdecl, importc: "sfSound_setAttenuation", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Change the current playing position of a sound
#/
#/ The playing position can be changed when the sound is
#/ either paused or playing.
proc setPlayingOffset*(sound: PSound; timeOffset: sfml.TTime){.
  cdecl, importc: "sfSound_setPlayingOffset", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the pitch of a sound
proc getPitch*(sound: PSound): cfloat{.
  cdecl, importc: "sfSound_getPitch", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the volume of a sound
proc getVolume*(sound: PSound): cfloat{.
  cdecl, importc: "sfSound_getVolume", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the 3D position of a sound in the audio scene
proc getPosition*(sound: PSound): TVector3f{.
  cdecl, importc: "sfSound_getPosition", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Tell whether a sound's position is relative to the
#/        listener or is absolute
proc isRelativeToListener*(sound: PSound): bool{.
  cdecl, importc: "sfSound_isRelativeToListener", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the minimum distance of a sound
proc getMinDistance*(sound: PSound): cfloat{.
  cdecl, importc: "sfSound_getMinDistance", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the attenuation factor of a sound
proc getAttenuation*(sound: PSound): cfloat{.
  cdecl, importc: "sfSound_getAttenuation", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the current playing position of a sound
proc getPlayingOffset*(sound: PSound): TTime{.
  cdecl, importc: "sfSound_getPlayingOffset", dynlib: Lib.}

#//////////////////////////////////////////////////////////
# Headers
#//////////////////////////////////////////////////////////
#//////////////////////////////////////////////////////////
#/ \brief Create a new sound buffer and load it from a file
#/
#/ Here is a complete list of all the supported audio formats:
#/ ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
#/ w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
#/
#/ \param filename Path of the sound file to load
#/
#/ \return A new sfSoundBuffer object (NULL if failed)
#/
#//////////////////////////////////////////////////////////
proc newSoundBuffer*(filename: cstring): PSoundBuffer{.
  cdecl, importc: "sfSoundBuffer_createFromFile", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Create a new sound buffer and load it from a file in memory
#/
#/ Here is a complete list of all the supported audio formats:
#/ ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
#/ w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
#/
#/ \param data        Pointer to the file data in memory
#/ \param sizeInBytes Size of the data to load, in bytes
#/
#/ \return A new sfSoundBuffer object (NULL if failed)
#/
#//////////////////////////////////////////////////////////
proc newSoundBuffer*(data: pointer; sizeInBytes: cint): PSoundBuffer{.
  cdecl, importc: "sfSoundBuffer_createFromMemory", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Create a new sound buffer and load it from a custom stream
#/
#/ Here is a complete list of all the supported audio formats:
#/ ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
#/ w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
#/
#/ \param stream Source stream to read from
#/
#/ \return A new sfSoundBuffer object (NULL if failed)
#/
#//////////////////////////////////////////////////////////
proc newSoundBuffer*(stream: PInputStream): PSoundBuffer{.
  cdecl, importc: "sfSoundBuffer_createFromStream", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Create a new sound buffer and load it from an array of samples in memory
#/
#/ The assumed format of the audio samples is 16 bits signed integer
#/ (sfInt16).
#/
#/ \param samples      Pointer to the array of samples in memory
#/ \param sampleCount  Number of samples in the array
#/ \param channelCount Number of channels (1 = mono, 2 = stereo, ...)
#/ \param sampleRate   Sample rate (number of samples to play per second)
#/
#/ \return A new sfSoundBuffer object (NULL if failed)
#/
#//////////////////////////////////////////////////////////
proc createFromSamples*(samples: ptr int16; sampleCount: cuint; 
                         channelCount: cuint; sampleRate: cuint): PSoundBuffer{.
  cdecl, importc: "sfSoundBuffer_createFromSamples", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Create a new sound buffer by copying an existing one
#/
#/ \param soundBuffer Sound buffer to copy
#/
#/ \return A new sfSoundBuffer object which is a copy of \a soundBuffer
#/
#//////////////////////////////////////////////////////////
proc copy*(soundBuffer: PSoundBuffer): PSoundBuffer{.
  cdecl, importc: "sfSoundBuffer_copy", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Destroy a sound buffer
#/
#/ \param soundBuffer Sound buffer to destroy
#/
#//////////////////////////////////////////////////////////
proc destroy*(soundBuffer: PSoundBuffer){.
  cdecl, importc: "sfSoundBuffer_destroy", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Save a sound buffer to an audio file
#/
#/ Here is a complete list of all the supported audio formats:
#/ ogg, wav, flac, aiff, au, raw, paf, svx, nist, voc, ircam,
#/ w64, mat4, mat5 pvf, htk, sds, avr, sd2, caf, wve, mpc2k, rf64.
#/
#/ \param soundBuffer Sound buffer object
#/ \param filename    Path of the sound file to write
#/
#/ \return sfTrue if saving succeeded, sfFalse if it failed
#/
#//////////////////////////////////////////////////////////
proc saveToFile*(soundBuffer: PSoundBuffer; filename: cstring): bool {.
  cdecl, importc: "sfSoundBuffer_saveToFile", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the array of audio samples stored in a sound buffer
#/
#/ The format of the returned samples is 16 bits signed integer
#/ (sfInt16). The total number of samples in this array
#/ is given by the sfSoundBuffer_getSampleCount function.
#/
#/ \param soundBuffer Sound buffer object
#/
#/ \return Read-only pointer to the array of sound samples
#/
#//////////////////////////////////////////////////////////
proc sfSoundBuffer_getSamples*(soundBuffer: PSoundBuffer): ptr Int16{.
  cdecl, importc: "sfSoundBuffer_getSamples", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the number of samples stored in a sound buffer
#/
#/ The array of samples can be accessed with the
#/ sfSoundBuffer_getSamples function.
proc getSampleCount*(soundBuffer: PSoundBuffer): cint{.
  cdecl, importc: "sfSoundBuffer_getSampleCount", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the sample rate of a sound buffer
#/
#/ The sample rate is the number of samples played per second.
#/ The higher, the better the quality (for example, 44100
#/ samples/s is CD quality).
proc getSampleRate*(soundBuffer: PSoundBuffer): cuint{.
  cdecl, importc: "sfSoundBuffer_getSampleRate", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the number of channels used by a sound buffer
#/
#/ If the sound is mono then the number of channels will
#/ be 1, 2 for stereo, etc.
proc getChannelCount*(soundBuffer: PSoundBuffer): cuint{.
  cdecl, importc: "sfSoundBuffer_getChannelCount", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the total duration of a sound buffer
#/
#/ \param soundBuffer Sound buffer object
#/
#/ \return Sound duration
#/
#//////////////////////////////////////////////////////////
proc getDuration*(soundBuffer: PSoundBuffer): TTime{.
  cdecl, importc: "sfSoundBuffer_getDuration", dynlib: Lib.}

#//////////////////////////////////////////////////////////
#/ \brief Change the global volume of all the sounds and musics
#/
#/ The volume is a number between 0 and 100; it is combined with
#/ the individual volume of each sound / music.
#/ The default value for the volume is 100 (maximum).
#/
#/ \param volume New global volume, in the range [0, 100]
#/
#//////////////////////////////////////////////////////////
proc listenerSetGlobalVolume*(volume: cfloat){.
  cdecl, importc: "sfListener_setGlobalVolume", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the current value of the global volume
#/
#/ \return Current global volume, in the range [0, 100]
#/
#//////////////////////////////////////////////////////////
proc listenerGetGlobalVolume*(): cfloat{.
  cdecl, importc: "sfListener_getGlobalVolume", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set the position of the listener in the scene
#/
#/ The default listener's position is (0, 0, 0).
#/
#/ \param position New position of the listener
#/
#//////////////////////////////////////////////////////////
proc listenerSetPosition*(position: TVector3f){.
  cdecl, importc: "sfListener_setPosition", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the current position of the listener in the scene
#/
#/ \return The listener's position
#/
#//////////////////////////////////////////////////////////
proc listenerGetPosition*(): TVector3f{.
  cdecl, importc: "sfListener_getPosition", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Set the orientation of the listener in the scene
#/
#/ The orientation defines the 3D axes of the listener
#/ (left, up, front) in the scene. The orientation vector
#/ doesn't have to be normalized.
#/ The default listener's orientation is (0, 0, -1).
#/
#/ \param position New direction of the listener
#/
#//////////////////////////////////////////////////////////
proc listenerSetDirection*(orientation: TVector3f){.
  cdecl, importc: "sfListener_setDirection", dynlib: Lib.}
#//////////////////////////////////////////////////////////
#/ \brief Get the current orientation of the listener in the scene
#/
#/ \return The listener's direction
#/
#//////////////////////////////////////////////////////////
proc listenerGetDirection*(): TVector3f{.
  cdecl, importc: "sfListener_getDirection", dynlib: Lib.}



