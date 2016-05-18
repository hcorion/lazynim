import sdl2

var
  win: WindowPtr
  ren: RendererPtr
  tex: TexturePtr
  surface: SurfacePtr
  xOut: SurfacePtr

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
    surface = getSurface(win)
  return success


proc loadMedia(): bool =
  var success: bool = true
  xOut = loadBMP("x.bmp")
  if xOut == nil:
    echo ("Unable to load image! Error: ", getError())
    success = false
  return success
proc close(): bool =
  freeSurface(xOut)
  xOut = nil

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

    while (quit == false):
      while (pollEvent(event)):
        case event.kind
        of QuitEvent:
          quit = true
        else:
          blitSurface(xOut, nil, surface, nil)
          discard updateSurface(win)

discard close()
