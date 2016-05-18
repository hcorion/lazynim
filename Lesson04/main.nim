import sdl2

var
  win: WindowPtr
  ren: RendererPtr
  tex: TexturePtr
  screenSurface: SurfacePtr
  keyPress: SurfacePtr
  currentSurface: SurfacePtr

#type
#  KeyPressSurfaces {.pure.} = enum
#    keyPressDefault ="", keyPressUp = "", keyPressDown = "", keyPressLeft = "", keyPressRight = "", keyPresTotal = ""
var
  keyPressDefault: SurfacePtr
  keyPressUp: SurfacePtr
  keyPressDown: SurfacePtr
  keyPressLeft: SurfacePtr
  keyPressRight: SurfacePtr
  keyPresTotal: SurfacePtr

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

  keyPressDefault = loadSurface("press.bmp")
  if keyPressDefault == nil:
    echo "Failed to load default image!"
    success = false

  keyPressUp = loadSurface("up.bmp")
  if keyPressUp == nil:
    echo "Failed to load up image!"
    success = false

  keyPressDown = loadSurface("down.bmp")
  if keyPressDown == nil:
    echo "Failed to load down image!"
    success = false

  keyPressLeft = loadSurface("left.bmp")
  if keyPressLeft == nil:
    echo "Failed to load left image!"
    success = false

  keyPressRight = loadSurface("right.bmp")
  if keyPressRight == nil:
    echo "Failed to load right image!"
    success = false
  #keyPress = loadBMP("press.bmp")
  #if keyPress == nil:
  #  echo ("Unable to load image! Error: ", getError())
  #  success = false
  return success


proc close(): bool =
  freeSurface(keyPressDefault)
  freeSurface(keyPressUp)
  freeSurface(keyPressDown)
  freeSurface(keyPressLeft)
  freeSurface(keyPressRight)
  #keyPress = nil
  keyPressDefault = nil
  keyPressUp = nil
  keyPressDown = nil
  keyPressLeft = nil
  keyPressRight = nil

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
    currentSurface = keyPressDefault
    while (quit == false):
      while (pollEvent(event)):
        case event.kind
        of QuitEvent:
          quit = true
        of sdl2.EventType.KeyDown:
          case event.key.keysym.sym
          of SDLK_UP:
            echo "Left"
          else: discard
        else:
          blitSurface(keyPress, nil, screenSurface, nil)
          discard updateSurface(win)

discard close()
