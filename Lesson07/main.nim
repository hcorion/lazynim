import sdl2, sdl2.image

var
  win: WindowPtr
  surface: SurfacePtr
  PNGSurface: SurfacePtr
  renderer: RendererPtr
  texture: TexturePtr
  screenWidth: cint = 640
  screenHeight: cint = 480

proc initialization(): bool =
  var success: bool = true

  discard sdl2.init(INIT_EVERYTHING)

  if setHint( "SDL_HINT_RENDER_SCALE_QUALITY", "1") == false:
    echo "Warning! Linear texture filtering not enabled!"

  win = createWindow("SDL Tutorial", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, screenWidth, screenHeight, SDL_WINDOW_SHOWN)
  if win == nil:
    echo ("Window could not be created! SDL Error: ", getError())
    success = false

  else:
    renderer = createRenderer(win, -1, Renderer_Accelerated)
    if renderer == nil:
      echo ("Renderer could not be created! SDL Error: ", getError())
      success = false

    else:
      setDrawColor(renderer, 0xFF, 0xFF, 0xFF, 0xFF)

      var imgFlags: cint = IMG_INIT_PNG
      if image.init(imgFlags) == 0:
        echo ("SDL_image could not initialize! SDL_image Error: ", getError())
        success = false

  return success

proc loadTexture(path: string): TexturePtr =
  var newTexture: TexturePtr

  var loadedSurface: SurfacePtr = image.load(path)
  if loadedSurface == nil:
    echo ("Unable to load image! SDL_image Error:", getError())
  else:
    newTexture = createTextureFromSurface(renderer, loadedSurface)
    if newTexture == nil:
      echo ("Unable to create texture from surface! SDL Error: ", getError())
    freeSurface(loadedSurface)
  return newTexture


proc loadMedia(): bool =
  var success: bool = true

  texture = loadTexture("texture.png")
  if texture == nil:
    echo ("Unable to load texture image! Error: ", getError())
    success = false
  return success


proc close(): bool =
  destroyTexture(texture)
  destroyRenderer(renderer)
  destroyWindow(win)

  image.quit()
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
          clear(renderer)
          copy(renderer, texture, nil, nil)
          present(renderer)

discard close()
