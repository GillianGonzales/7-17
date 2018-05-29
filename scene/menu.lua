-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-- Created By Gillian Gonzales	
-- Created On May 15 2018
--
-- This file will show the menu
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
 
local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
  local function showScene1( event )

	if ( event.phase == "began" ) then
    	local options = {

    	effect = "fade",

    	time= 500

    	}

    	composer.gotoScene("scene1",options)
	end
	return true 
 end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    local background = display.newRect( 1024, 768, 2048, 1536 )
	background:setFillColor( 1 )
	background.id = "background"
	sceneGroup:insert(background)

	local button = display.newRect( 1024, 768, 600, 200)
	button:setFillColor(0.5)
	button.id = "button"
	sceneGroup:insert(button)

	local buttonText = display.newText( "Button", 1024, 768, native.systemFont, 75)
	buttonText:setFillColor(0)
	buttonText.id = "button text"
	sceneGroup:insert(buttonText)

	local text = display.newText( "Press Button to enter game", 1024, 600, native.systemFont, 75)
	text:setFillColor(0)
	text.id = "text"
	sceneGroup:insert(text)

    button:addEventListener( "touch", showScene1)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-- -----------------------------------------------------------------------------------
 
return scene