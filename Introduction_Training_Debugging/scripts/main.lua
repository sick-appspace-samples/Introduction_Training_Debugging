local myViewHandle = View.create()
local myViewImageDecorationHandle = View.ImageDecoration.create()

local myMaxImages = 4   -- Maximum number of loaded images
local myInterval = 5   -- Interval between displayed images in [s]

local myLoadedImages = {}   -- Table with the loaded images
for i = 1, myMaxImages, 1 do
  myLoadedImages[ i ] = Object.load( "resources/" .. i .. ".JSON" )
end

local myCurrImage = 0   -- Counter for the currently displayed image
local myCurrIntervalStep = 0   -- Counter for the 

local myInfoTimer = Timer.create()
myInfoTimer:setExpirationTime( 1000 )
myInfoTimer:setPeriodic( true )

--- Display information in console while display interval is running.
local function printInfo()
  print( "Wait " .. myInterval - myCurrIntervalStep .. "s before next image will be displayed ..." )
  myCurrIntervalStep = myCurrIntervalStep + 1
end

--- Display the next loaded image.
local function handleOnExpired()
  myInfoTimer:stop()
  -- Increase the counter:
  myCurrImage = myCurrImage + 1
  -- Reset the counter:
  if ( myCurrImage > myMaxImages ) then
    myCurrImage = 1
  end
  print( "Will display image 'resources/" .. myCurrImage .. ".JSON' ..." )
  myViewHandle:addHeightmap( myLoadedImages[ myCurrImage ], myViewImageDecorationHandle, { "Reflectance" } )
  myViewHandle:present( "ASSURED" )
  myCurrIntervalStep = 0
  printInfo()
  myInfoTimer:start()
end

local myTimer = Timer.create()
myTimer:setExpirationTime( myInterval * 1000 )
myTimer:setPeriodic( true )
myTimer:register( "OnExpired", handleOnExpired )
myInfoTimer:register( "OnExpired", printInfo )

local function main()
  print( "Ready to rumble ..." )
  -- Immediately display the first loaded image:
  handleOnExpired()
  -- Start the timer for displaying images periodically:
  myTimer:start()
end
Script.register( "Engine.OnStarted", main )
