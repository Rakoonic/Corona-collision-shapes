
------------------------------------------------------------

local collisions = require( "collisions" )
local ui         = require("ui")

------------------------------------------------------------

local bg          = display.newImage( "bg.jpg" )
local collisionMode, shape1, shape2
local buttonGroup = display.newGroup()
local shape1, shape2
local hitTest

------------------------------------------------------------

function buttonRelease( params )
	
	-- Hide buttons
	buttonGroup.isVisible = false
	
	-- Create collision test
	setCollisionTest( params.target.label )
	
end

------------------------------------------------------------

function setCollisionTest( collisionData )

	-- Set up the mode
	collisionMode = collisionData[ 1 ]
	
	-- Create the shapes
	shape2             = display.newImage( collisionData[ 3 ] .. ".png" )
	shape2.x, shape2.y = 160, 240

	shape1             = display.newImage( collisionData[ 2 ] .. ".png" )
	shape1.x, shape1.y = 160, 160

	Runtime:addEventListener( "touch", shapeMove )
	
end

function shapeMove( event )

	local phase  = event.phase
	if phase == "began" then
		display.getCurrentStage():setFocus( self, event.id )
		shape1.isFocus = true
	elseif shape1.isFocus then
		if phase == "moved" then

			-- Move the shape
			shape1.x = event.x
			shape1.y = event.y
			
			-- Do the collision test
			local collision = false
			if     collisionMode == "pointInRect" then              collision = collisions.pointInRect( shape1.x, shape1.y, shape2.x - 63, shape2.y - 63, 127, 127 )
			elseif collisionMode == "pointInCircle" then            collision = collisions.pointInCircle( shape1.x, shape1.y, shape2.x, shape2.y, 63 )
			elseif collisionMode == "pointInDiamond" then           collision = collisions.pointInDiamond( shape1.x, shape1.y, shape2.x, shape2.y, 63 )
			elseif collisionMode == "rectInRect" then               collision = collisions.rectInRect( shape1.x - 31, shape1.y - 31, 63, 63, shape2.x - 63, shape2.y - 63, 127, 127 )
			elseif collisionMode == "circleInCircle" then           collision = collisions.circleInCircle( shape1.x, shape1.y, 31, shape2.x, shape2.y, 63 )
			elseif collisionMode == "diamondInDiamond" then         collision = collisions.diamondInDiamond( shape1.x, shape1.y, 31, shape2.x, shape2.y, 63 )
			elseif collisionMode == "intersectRects" then           collision = collisions.intersectRects( shape1.x - 31, shape1.y - 31, 63, 63, shape2.x - 63, shape2.y - 63, 127, 127)
			elseif collisionMode == "intersectCircles" then         collision = collisions.intersectCircles( shape1.x, shape1.y, 31, shape2.x, shape2.y, 63 )
			elseif collisionMode == "intersectDiamonds" then        collision = collisions.intersectDiamonds( shape1.x, shape1.y, 31, shape2.x, shape2.y, 63 )
			elseif collisionMode == "intersectRectWithCircle" then  collision = collisions.intersectRectWithCircle( shape1.x - 31, shape1.y - 31, 63, 63, shape2.x, shape2.y, 63 )
			elseif collisionMode == "intersectRectWithDiamond" then collision = collisions.intersectRectWithDiamond( shape1.x - 31, shape1.y - 31, 63, 63, shape2.x, shape2.y, 63 )
			end			
			
			if collision == false then hitTest:setText( collisionMode .. " - false" )
			else                       hitTest:setText( collisionMode .. " - true" ) ; end
		elseif phase == "ended" then
			display.getCurrentStage():setFocus( self, nil )
			shape1.isFocus = false
		end
	end
	
end

------------------------------------------------------------

-- Buttons
local buttons = {
		{ "pointInRect",              "point",         "rect" },  
		{ "pointInCircle",            "point",         "circle" },  
		{ "pointInDiamond",           "point",         "diamond" },  
		{ "rectInRect",               "rect-small",    "rect" },  
		{ "circleInCircle",           "circle-small",  "circle" },  
		{ "diamondInDiamond",         "diamond-small", "diamond" },  
		{ "intersectRects",           "rect-small",    "rect" },  
		{ "intersectCircles",         "circle-small",  "circle" },  
		{ "intersectDiamonds",        "diamond-small", "diamond" },  
		{ "intersectRectWithCircle",  "rect-small",    "circle" },  
		{ "intersectRectWithDiamond", "rect-small",    "diamond" },  
}
for i, v in ipairs( buttons ) do
	local button = ui.newButton{
		default   = "buttonGray.png",
		over      = "buttonGrayOver.png",
		onRelease = buttonRelease,
		text      = v[ 1 ],
		emboss    = true,
		size      = 10
	}
	button.label = v
	buttonGroup:insert( button )
	button.x     = ( i - 1 ) % 2 * 160 + 80 ; button.y = math.floor( ( i - 1 ) / 2 ) * 60 + 60
end

-- Hit test output
hitTest = ui.newLabel{
	bounds    = { 10, 55, 300, 40 },
	text      = "",
	textColor = { 255, 204, 102, 255 },
	size      = 14,
	align     = "center"
}
hitTest.y = 380

------------------------------------------------------------

--[[
print( "pointInRect", collision.pointInRect( 0, 0, -5, -5, 10, 10 ) )
print( "pointInCircle", collision.pointInCircle( 0, 0, 0, 0, 5 ) )
print( "pointInDiamond", collision.pointInDiamond( 0, 0, 0, 0, 5 ) )

print( "rectInRect", collision.rectInRect( 0, 0, 5, 5, 0, 0, 10, 10 ) )
print( "circleInCircle", collision.circleInCircle( 0, 0, 15, 0, 0, 10 ) )
print( "diamondInDiamond", collision.diamondInDiamond( 0, 0, 15, 0, 0, 10 ) )

print( "intersectRects", collision.intersectRects( 0, 0, 5, 5, 2, 2, 5, 5 ) )
print( "intersectCircles", collision.intersectCircles( 0, 0, 5, 2, 0, 5 ) )
print( "intersectDiamonds", collision.intersectDiamonds( 0, 0, 5, 2, 0, 5 ) )

print( "intersectRectWithCircle", collision.intersectRectWithCircle( 0, 0, 5, 5, 10, -1, 5 ) )
print( "intersectRectWithDiamond", collision.intersectRectWithDiamond( 0, 0, 5, 5, 10, -1, 5 ) )
--]]

------------------------------------------------------------
