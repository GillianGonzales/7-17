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

local ninjaBoy = nil
local map = nil
local rightArrow = nil
local jumpButton = nil
local shootButton = nil
local playerBullets = {}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function onRightArrowTouch( event )
    if (event.phase == "began") then
        if ninjaBoy.sequence ~= "run" then
            ninjaBoy.sequence = "run"
            ninjaBoy:setSequence ( "run" )
            ninjaBoy:play()
        end

    elseif (event.phase == "ended") then
        if ninjaBoy.sequence ~= "idle" then
            ninjaBoy.sequence = "idle"
            ninjaBoy:setSequence( "idle" )
            ninjaBoy:play()
        end
    end
    return true
end

local function onJumpButtonTouch( event )
    if (event.phase == "began") then
        if ninjaBoy.sequence ~= "jump" then
            ninjaBoy.sequence = "jump"
            ninjaBoy:setLinearVelocity( 100, -1050)
            ninjaBoy:setSequence ( "jump" )
            ninjaBoy:play()
        end

    elseif (event.phase == "ended") then

    end
    return true
end

local moveNinjaBoy = function ( event )

    if ninjaBoy.sequence == "run" then
        transition.moveBy(ninjaBoy, {
            x = 10,
            y = 0,
            time = 0,
            })
    end

    if ninjaBoy.sequence == "jump" then
        local ninjaBoyVelocityX, ninjaBoyVelocityY = ninjaBoy:getLinearVelocity()

        if ninjaBoyVelocityY == 0 then
            ninjaBoy.sequence = "idle"
            ninjaBoy:setSequence( "idle" )
            ninjaBoy:play()
        end

    end
end


local checkingPlayerBulletsOutOfBounds = function ( event )
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end


local function onShootButtonTouch( event )
    if ( event.phase == "began" ) then
        if ninjaBoy.sequence ~= "throw" then
            ninjaBoy.sequence = "throw"
            ninjaBoy:setSequence ("throw")
            print("hello")
            timer.performWithDelay( 1000, ninjaThrow )
            -- make a bullet appear
            local aSingleBullet = display.newImage( "./assets/sprites/Kunai.png" )
            aSingleBullet.x = ninjaBoy.x
            aSingleBullet.y = ninjaBoy.y
            physics.addBody( aSingleBullet, 'dynamic' )
            -- Make the object a "bullet" type object
            aSingleBullet.isBullet = true
            aSingleBullet.gravityScale = 0
            aSingleBullet.id = "bullet"
            aSingleBullet:setLinearVelocity( 1500, 0 )
            aSingleBullet.isFixedRotation = true

            table.insert(playerBullets,aSingleBullet)
            print("# of bullet: " .. tostring(#playerBullets))
        end
    elseif (event.phase == "ended" ) then

    end
    return true
end
 
local ninjaThrow = function ( event )
    ninjaBoy.sequence = "idle"
    ninjaBoy:setSequence( "idle" )
    ninjaBoy:play()
    print("throw")
end

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
    
    local sheetOptionsIdle = require("assets.spritesheets.ninjaBoy.ninjaBoyIdle")
    local sheetIdleNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyIdle.png", sheetOptionsIdle:getSheet() )

    local sheetOptionsRun = require("assets.spritesheets.ninjaBoy.ninjaBoyRun")
    local sheetRunNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyRun.png", sheetOptionsRun:getSheet() )

    local sheetOptionsJump = require("assets.spritesheets.ninjaBoy.ninjaBoyJump")
    local sheetJumpNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyJump.png", sheetOptionsJump:getSheet() )

    local sheetOptionsThrow = require("assets.spritesheets.ninjaBoy.ninjaBoyThrow")
    local sheetThrowNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyThrow.png", sheetOptionsThrow:getSheet() )

    local sheetOptionsDead = require("assets.spritesheets.ninjaBoy.ninjaBoyDead")
    local sheetDeadNinja = graphics.newImageSheet("./assets/spritesheets/ninjaBoy/ninjaBoyDead.png", sheetOptionsDead:getSheet() )

    local sequence_data = {
        {
            name = "idle",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetIdleNinja
        },
        {
            name = "run",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 0,
            sheet = sheetRunNinja
        },
        {
            name = "jump",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 1,
            sheet = sheetJumpNinja
        },
        {
            name = "throw",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 1,
            sheet = sheetThrowNinja
        },
        {
            name = "dead",
            start = 1,
            count = 10,
            time = 800,
            loopCount = 1,
            sheet = sheetDeadNinja        
    }
    }

    ninjaBoy = display.newSprite( sheetIdleNinja, sequence_data)
    physics.addBody( ninjaBoy, "dynamic", { density = 3, bounce = 0, friction = 1.0 })
    ninjaBoy.isFixedRotation = true
    ninjaBoy.x = display.contentWidth * .5
    ninjaBoy.y = 0 
    ninjaBoy.sequence = "idle"
    ninjaBoy:setSequence("idle")
    ninjaBoy:play()

    rightArrow = display.newImageRect("./assets/sprites/rightButton.png",200,200 )
    rightArrow.x = 200
    rightArrow.y = display.contentHeight - 300

    jumpButton = display.newImageRect("./assets/sprites/jumpButton.png",128,128 )
    jumpButton.x = 400
    jumpButton.y = display.contentHeight - 300

    shootButton = display.newImageRect("./assets/sprites/jumpButton.png",128,128 )
    shootButton.x = 600
    shootButton.y = display.contentHeight - 300

    sceneGroup:insert( map )
    sceneGroup:insert( ninjaBoy ) 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        sceneGroup:insert( shootButton)
        sceneGroup:insert( rightArrow )
        sceneGroup:insert( jumpButton )
        rightArrow:addEventListener("touch",onRightArrowTouch)
        jumpButton:addEventListener("touch",onJumpButtonTouch)
        shootButton:addEventListener("touch",onShootButtonTouch)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        Runtime:addEventListener("enterFrame",checkingPlayerBulletsOutOfBounds)
        Runtime:addEventListener("enterFrame",moveNinjaBoy) 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        rightArrow:addEventListener("touch",onRightArrowTouch)
        jumpButton:addEventListener("touch",onJumpButtonTouch)
        shootButton:addEventListener("touch",onShootButtonTouch)
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:addEventListener("enterFrame",moveNinjaBoy)
        Runtime:addEventListener("enterFrame",checkingPlayerBulletsOutOfBounds)
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