import sdl2

var
  win: WindowPtr
  ren: RendererPtr
  tex: TexturePtr
  screenSurface: SurfacePtr
  #keyPress: SurfacePtr
  currentSurface: SurfacePtr

#type
#  KeyPressSurfaces {.pure.} = enum
#    keyPressDefault ="", keyPressUp = "", keyPressDown = "", keyPressLeft = "", keyPressRight = "", keyPresTotal = ""
#var
#  keyPressDefault: SurfacePtr
#  keyPressUp: SurfacePtr
#  keyPressDown: SurfacePtr
#  keyPressLeft: SurfacePtr
#  keyPressRight: SurfacePtr
#  keyPresTotal: SurfacePtr

type
  keyPressEnum = enum
    kpDefault, kpUp, kpDown, kpLeft, kpRight, kpTotal
var
  keyPress = newSeq[SurfacePtr](ord(kpTotal))

proc initialization(): bool =
  var success: bool = true
  discard sdl2.init(INIT_EVERYTHING)

  var screenWidth: cint = 640
  var screenHeight: cint = 480
  win = createWindow("SDL Tutorial", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, screenWidth, screenHeight, SDL_WINDOW_SHOWN)
  if win == nil:
    echo ("Window could not be created! SDL Error: ", getError())
    success = false
  else:
    screenSurface = getSurface(win)
  return success

proc loadSurface(path: string): SurfacePtr =
  var loadedSurface: SurfacePtr = loadBMP(path)
  if loadedSurface == nil:
    echo "Unable to load image! Error: ", getError()
  return loadedSurface



proc loadMedia(): bool =
  var success: bool = true

  keyPress[ord(kpDefault)] = loadSurface("press.bmp")
  if keyPress[ord(kpDefault)] == nil:
    echo "Failed to load default image!"
    success = false

  keyPress[ord(kpUp)] = loadSurface("up.bmp")
  if keyPress[ord(kpUp)] == nil:
    echo "Failed to load up image!"
    success = false

  keyPress[ord(kpDown)] = loadSurface("down.bmp")
  if keyPress[ord(kpDown)] == nil:
    echo "Failed to load down image!"
    success = false

  keyPress[ord(kpLeft)] = loadSurface("left.bmp")
  if keyPress[ord(kpLeft)] == nil:
    echo "Failed to load left image!"
    success = false

  keyPress[ord(kpRight)] = loadSurface("right.bmp")
  if keyPress[ord(kpRight)] == nil:
    echo "Failed to load right image!"
    success = false
  #keyPress = loadBMP("press.bmp")
  #if keyPress == nil:
  #  echo ("Unable to load image! Error: ", getError())
  #  success = false
  return success


proc close(): bool =

  for i, v in keyPress:
    freeSurface(keyPress[i])
    keyPress[i] = nil

  destroyWindow(win)
  win = nil

  sdl2.quit()



if initialization() == false:
  echo "Failed to initialize!"
else :
  if loadMedia() == false:
    echo "Failed to load media!"
  else:
    var quit: bool = false
    var event = sdl2.defaultEvent
    currentSurface = keyPress[ord(kpDefault)]
    while (quit == false):
      while (pollEvent(event)):
        case event.kind
        of QuitEvent:
          quit = true
        of sdl2.EventType.KeyDown:
          case event.key.keysym.sym
          #You can find the number that represents the keycode here: https://wiki.libsdl.org/SDLKeycodeLookup
          of 1073741906:
            currentSurface = keyPress[ord(kpUp)]
          of 1073741905:
            currentSurface = keyPress[ord(kpDown)]
          of 1073741904:
            currentSurface = keyPress[ord(kpLeft)]
          of 1073741903:
            currentSurface = keyPress[ord(kpRight)]
          else: discard
        else:
          blitSurface(currentSurface, nil, screenSurface, nil)
          discard updateSurface(win)

discard close()
