--------------------------------------------------------------
-- GENERAL COLLISION ROUTINES --------------------------------

local class    = {}

local mathAbs = math.abs

function class.pointInRect( pointX, pointY, left, top, width, height )
	if pointX >= left and pointX <= left + width and pointY >= top and pointY <= top + height then return true
	else                                                                                           return false ; end
end
function class.pointInCircle( pointX, pointY, centerX, centerY, radius )
	local dX, dY = pointX - centerX, pointY - centerY
	if dX * dX + dY * dY <= radius * radius then return true
	else                                         return false ; end
end
function class.pointInDiamond( pointX, pointY, centerX, centerY, radius )
	if mathAbs( pointX - centerX ) + mathAbs( pointY - centerY ) <= radius then return true
	else                                                                        return false ; end
end
function class.rectInRect( left1, top1, width1, height1, left2, top2, width2, height2 )
	if left1 >= left2 and left1 + width1 <= left2 + width2 and top1 >= top2 and top1 + height1 <= top2 + height2 then return true
	else                                                                                                              return false ; end
end
function class.circleInCircle( centerX1, centerY1, radius1, centerX2, centerY2, radius2 )
	if radius1 > radius2 then return false ; end
	local dX, dY, radii = centerX1 - centerX2, centerY1 - centerY2, radius2 - radius1
	if dX * dX + dY * dY <= radii * radii then return true
	else                                       return false ; end
end
function class.diamondInDiamond( centerX1, centerY1, radius1, centerX2, centerY2, radius2 )
	if radius1 > radius2 then return false ; end
		if mathAbs( centerX1 - centerX2 ) + mathAbs( centerY1 - centerY2 ) <= radius2 - radius1 then return true
	else                                                                                             return false ; end
end
function class.intersectRects( left1, top1, width1, height1, left2, top2, width2, height2 )
	if left1 + width1 >= left2 and left1 <= left2 + width2 and top1 + height1 >= top2 and top1 <= top2 + height2 then return true
	else                                                                                                              return false ; end
end
function class.intersectCircles( centerX1, centerY1, radius1, centerX2, centerY2, radius2 )
	local dX, dY, radii = centerX1 - centerX2, centerY1 - centerY2, radius1 + radius2
	if dX * dX + dY * dY <= radii * radii then return true
	else                                       return false ; end
end
function class.intersectDiamonds( centerX1, centerY1, radius1, centerX2, centerY2, radius2 )
	if mathAbs( centerX1 - centerX2 ) + mathAbs( centerY1 - centerY2 ) <= radius1 + radius2 then return true
	else                                                                                   return false ; end
end
function class.intersectRectWithCircle( left, top, width, height, centerX, centerY, radius )
	
	-- Are you within the rectangular extensions?
	if left <= centerX and left + width >= centerX then
		if top + height >= centerY - radius and top <= centerY + radius then return true
		else                                                                 return false ; end
	elseif top <= centerY and top + height >= centerY then
		if left + width >= centerX - radius and left <= centerX + radius then return true
		else                                                                  return false ; end
	else

		-- Curved bits - split into the 4 corner checks
		if left < centerX then
			if top < centerY then return class.pointInCircle( left + width, top + height, centerX, centerY, radius )
			else                  return class.pointInCircle( left + width, top, centerX, centerY, radius ) ; end
		else
			if top < centerY then return class.pointInCircle( left, top + height, centerX, centerY, radius )
			else                  return class.pointInCircle( left, top, centerX, centerY, radius ) ; end
		end
	end
		
end
function class.intersectRectWithDiamond( left, top, width, height, centerX, centerY, radius )
	
	-- Are you within the rectangular extensions?
	if left <= centerX and left + width >= centerX then
		if top + height >= centerY - radius and top <= centerY + radius then return true
		else                                                                 return false ; end
	elseif top <= centerY and top + height >= centerY then
		if left + width >= centerX - radius and left <= centerX + radius then return true
		else                                                                  return false ; end
	else
	
		-- Diagonal bits - split into the 4 corner checks
		if left < centerX then
			if top < centerY then return class.pointInDiamond( left + width, top + height, centerX, centerY, radius )
			else                  return class.pointInDiamond( left + width, top, centerX, centerY, radius ) ; end
		else
			if top < centerY then return class.pointInDiamond( left, top + height, centerX, centerY, radius )
			else                  return class.pointInDiamond( left, top, centerX, centerY, radius ) ; end
		end
	end
	
end

--------------------------------------------------------------
--------------------------------------------------------------

return class