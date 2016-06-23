import sdl2, sdl2.image

var
  win: WindowPtr
  #surface: SurfacePtr
  #PNGSurface: SurfacePtr
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


proc close(): bool =
  destroyTexture(texture)
  destroyRenderer(renderer)
  destroyWindow(win)

  image.quit()
  sdl2.quit()


if initialization() == false:
  echo "Failed to initialize!"
else :
  var quit: bool = false
  var event = sdl2.defaultEvent
  while (quit == false):
    while (pollEvent(event)):
      case event.kind
      of QuitEvent:
        quit = true
      else:
        #Clear screen
        setDrawColor(renderer, 0xFF, 0xFF, 0xFF, 0xFF)
        clear(renderer)

        #Render red filled quad
        var redRect: Rect = (x:cint(screenWidth/4), y:cint(screenHeight/4),
        w:cint(screenWidth/2), h:cint(screenHeight/2))
        setDrawColor(renderer, 0xFF, 0x00, 0x00, 0xFF)
        fillRect(renderer, addr(redRect))

        #Render red filled quad
        var outlineRect: Rect = (x:cint(screenWidth/6), y:cint(screenHeight/6),
        w:cint(screenWidth * 2 / 3), h:cint(screenHeight * 2/3))
        setDrawColor(renderer, 0x00, 0xFF, 0x00, 0xFF)
        drawRect(renderer, outlineRect)

        #Draw blue horizontal line
        setDrawColor(renderer, 0x00, 0x00, 0xFF, 0xFF)
        drawLine(renderer, 0, cint(screenHeight/2), screenWidth, cint(screenHeight/2))

        #Draw vertical line of yellow dots
        setDrawColor(renderer, 0xFF, 0xFF, 0x00, 0xFF)
        var i: int = 0
        while i < screenHeight:
          i += 4
          drawPoint(renderer, cint(screenWidth/2), cint(i))


        #copy(renderer, texture, nil, nil)
        present(renderer)

discard close()
