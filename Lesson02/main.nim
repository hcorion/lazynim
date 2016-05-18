import sdl2

var
  win: WindowPtr
  ren: RendererPtr
  tex: TexturePtr
  surface: SurfacePtr
  helloWorld: SurfacePtr

proc initialization(): bool =
  var success: bool = true
  discard sdl2.init(INIT_EVERYTHING)

  var screenWidth: cint = 640
  var screenHeight: cint = 640
  win = createWindow("SDL Tutorial", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, screenWidth, screenHeight, SDL_WINDOW_SHOWN)
  if win == nil:
    echo ("Window could not be created! SDL Error: ", getError())
    success = false
  else:
    surface = getSurface(win)
  return success
proc loadMedia(): bool =
  var success: bool = true
  helloWorld = loadBMP("hello_world.bmp")
  if helloWorld == nil:
    echo ("Unable to load image! Error: ", getError())
    success = false
  return success
proc close(): bool =
  freeSurface(helloWorld)
  helloWorld = nil

  destroyWindow(win)
  win = nil

  sdl2.quit()

#discard init(INIT_EVERYTHING)
if initialization() == false:
  echo "Failed to initialize!"
else :
  if loadMedia() == false:
    echo "Failed to load media!"
  else:
    blitSurface(helloWorld, nil, surface, nil)
    discard updateSurface(win)
    delay(2000)

discard close()
