import sdl2, sdl2.image

var
  win: WindowPtr
  surface: SurfacePtr
  PNGSurface: SurfacePtr
  screenWidth: cint = 640
  screenHeight: cint = 480

proc initialization(): bool =
  var success: bool = true
  discard sdl2.init(INIT_EVERYTHING)

  win = createWindow("SDL Tutorial", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, screenWidth, screenHeight, SDL_WINDOW_SHOWN)
  if win == nil:
    echo ("Window could not be created! SDL Error: ", getError())
    success = false
  else:
    var imgFlags: cint = IMG_INIT_PNG
    if image.init(imgFlags) == 0:
      echo ("SDL_image could not initialize! SDL_image Error: ", getError())
      success = false
    else:
      surface = getSurface(win)
  return success


proc loadSurface(path: string): SurfacePtr =
  var optimizedSurface: SurfacePtr
  var loadedSurface: SurfacePtr = image.load(path)
  if loadedSurface == nil:
    echo ("Unable to load image! Error: ", getError())
  else:
    optimizedSurface = convertSurface(loadedSurface, surface.format, 0)
    if optimizedSurface == nil:
      echo ("Unable to optimize image! SDL Error: ", getError())
    freeSurface(loadedSurface)
  return optimizedSurface



proc loadMedia(): bool =
  var success: bool = true
  PNGSurface = loadSurface("loaded.png")
  if PNGSurface == nil:
    echo ("Unable to load PNG image! Error: ", getError())
    success = false
  return success


proc close(): bool =
  freeSurface(PNGSurface)

  destroyWindow(win)

  sdl2.quit()
  image.quit()


if initialization() == false:
  echo "Failed to initialize!"
else :
  if loadMedia() == false:
    echo "Failed to load media!"
  else:
    var quit: bool = false
    var event = sdl2.defaultEvent

    while (quit == false):
      while (pollEvent(event)):
        case event.kind
        of QuitEvent:
          quit = true
        else:
          blitSurface(PNGSurface, nil, surface, nil)
          #var stretchRect: Rect
          #stretchRect.x = 0;
          #stretchRect.y = 0;
          #stretchRect.w = screenWidth
          #stretchRect.h = screenHeight
          #var stretchRectPtr: ptr Rect = stretchRect
          #blitScaled(stretchedSurface, nil, surface, addr stretchRect)
          discard updateSurface(win)

discard close()
