import sdl2, sdl2.image

proc memcpy(destination: ptr void, source: pointer, num: int) {.importc: "memcpy", varargs,
                                  header: "<stdio.h>".}

var
  win: WindowPtr
  #surface: SurfacePtr
  #PNGSurface: SurfacePtr
  renderer: RendererPtr
  texture: TexturePtr
  screenWidth: cint = 640
  screenHeight: cint = 480

type
  Dot = object
    width, height, velocity: int
    PosX, PosY, VelX, VelY: float
  LTexture = object
    texture: TexturePtr
    width, height: int
    pitch: cint
    pixels: ptr void


var dot: Dot
dot = Dot(width: 20, height: 20,
velocity: 640,
PosX: 0.0, PosY: 0.0, VelX: 0.0, VelY: 0.0)

var lTexture: LTexture
lTexture = LTexture(texture: nil,
width: 0, height: 0, pitch: 0,
pixels: nil)

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


proc loadFromFile(path: string): bool =
  var newTexture: TexturePtr
  var loadedSurface: SurfacePtr = image.load(path)
  if loadedSurface == nil:
    echo ("Unable to load image! SDL_image Error:", getError())
  else:
    var formattedSurface: SurfacePtr = convertSurfaceFormat(loadedSurface, SDL_PIXELFORMAT_RGBA8888, 0)
    if formattedSurface == nil:
      echo ("Unable to convert loaded surface to display format!")
    else:
      newTexture = createTexture(renderer, SDL_PIXELFORMAT_RGBA8888, SDL_TEXTUREACCESS_STREAMING, formattedSurface.w, formattedSurface.h)
      if newTexture == nil:
        echo ("Unable to create blank texture! SDL Error:", getError())
      else:
        setTextureBlendMode( newTexture, BlendMode_Blend)

        #lock texture for manipulation
        lockTexture(newTexture, addr(formattedSurface.clip_rect), cast[ptr pointer](lTexture.pixels), addr(lTexture.pitch))

        memcpy(lTexture.pixels, formattedSurface.pixels, formattedSurface.pitch * formattedSurface.h)

        lTexture.width = formattedSurface.w
        lTexture.height = formattedSurface.h

        var newpixels: ptr uint32 = cast[ptr uint32](lTexture.pixels)
        var pixelCount: int = (int)(lTexture.pitch / 4) * lTexture.height

        var colorKey: uint32 = mapRGB(formattedSurface.format, 0, 0xFF, 0xFF)
        var transparent: uint32 = mapRGBA(formattedSurface.format, 0x00, 0xFF, 0xFF, 0x00)

        for i in 0..pixelCount:
          if newpixels == addr(colorKey):
            newpixels = addr(transparent)
        unlockTexture(newTexture)
        lTexture.pixels = nil
      freeSurface(formattedSurface)
    freeSurface(loadedSurface)
  lTexture.texture = newTexture
  return lTexture.texture != nil

proc loadMedia(): bool =
  var success: bool = true
  if loadFromFile("dot.bmp") == false:
    echo("Failed to load dot texture!")
    success = false

  success = true


proc close(): bool =
  destroyTexture(texture)
  destroyRenderer(renderer)
  destroyWindow(win)

  image.quit()
  sdl2.quit()


if initialization() == false:
  echo "Failed to initialize!"
else :
  discard(loadMedia())
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
