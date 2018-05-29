-----------------------------------------------------------------------------------------
--
-- scene1.lua
--
-- Created By Gillian Gonzales	
-- Created On May 15 2018
--
-- This file will show a level
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local physics = require( "physics" )
local json = require( "json" )
local tiled = require ( "com.ponywolf.ponytiled")

local scene = composer.newScene()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	physics.start()
	physics.setGravity(0, 50)

    local filename = "assets/maps/level0.json"
    local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ))
    map = tiled.new( mapData, "assets/maps")

    local character = display.newImage("./assets/sprites/enemies/spikeBall1.png")  
    character.x = 768
    character.y = 0
    character.id = "the character"
    physics.addBody( character, "dynamic", { 
        friction = 0.5, 
        bounce = 0.3 
        } )


    --sceneGroup:insert( map )
    sceneGroup:insert( character )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        


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