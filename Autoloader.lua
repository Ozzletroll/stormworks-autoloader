--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "3x3")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)

        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

-- Target Angle Input = ch 1
-- Load HE Keypress = ch 2
-- Load AP Keypress = ch 3
-- Loader Loaded = ch 4
-- Main battery feed = ch 5
-- AP feed = ch 6
-- HE feed = ch 7
-- Breach open/close = ch 8
-- Loader track speed = ch 9
-- Loader arm rotation = ch 10
-- Loader main connected = ch 11
-- Loader HE connected = ch 12
-- Loader AP connected = ch 13
-- Cannon Loaded = ch 14
-- Cannon Belt Loaded = ch 15

Counter = 0
Wait = 0

function onTick()
	TurretAngle = input.getNumber(1)
	HEKeyPress = input.getBool(2)
	APKeyPress = input.getBool(3)
	LoaderLoaded = input.getBool(4)
    LoaderMainConnected = input.getBool(11)
    LoaderHEConnected = input.getBool(12)
    LoaderAPConnected = input.getBool(13)
    CannonLoaded = input.getBool(14)
    CannonBeltLoaded = input.getBool(15)

    Wait = Wait + 1

    if APKeyPress == true and Counter == 0 then
        LoadAP1() 
    end
    
    if Counter == 1 and LoaderAPConnected == true then
        LoadAP2()
    end

    if Counter == 2 and LoaderMainConnected == true then
        LoadAP3()
    end

    if Counter == 3 and CannonBeltLoaded == true then
        LoadAP4()
    end

    if Counter == 4 and Wait > 60 then
        LoadAP5()
    end

end



-- Load AP round into main cannon
function LoadAP1()
    output.setBool(8,true) -- Open cannon breech
    output.setNumber(10,0) -- Reset loader arm rotation
    output.setNumber(9,-1) -- Move feeder arm to reserve position
    output.setBool(6,true) -- Feed AP belt on
    Counter = 1
end

function LoadAP2()
    output.setNumber(9,1) -- Move feeder arm to breech position
    output.setNumber(10,TurretAngle) -- Rotate feeder arm to current barrel position
    Counter = 2
end

function LoadAP3()
    output.setBool(6,false) -- Feed AP belt off

    output.setBool(5,true) -- Feed main belt
    Counter = 3
end

function LoadAP4()
    output.setBool(6,false) -- Feed AP belt off
    Wait = 0
    Counter = 4
    
end

function LoadAP5()
    output.setBool(5,false) -- Feed main belt off
    output.setBool(8,false) -- Close cannon breech
    Counter = 5
end
 


-- output.setBool(6,false) -- Feed AP belt off
-- output.setNumber(9,1) -- Move feeder arm to breech position


-- output.setBool(8,false) -- Close cannon breech
-- output.setBool(6,false) -- Feed AP belt
-- output.setNumber(9,1) -- Move feeder arm to breech position
-- output.setBool(5,true) -- Feed main belt

   




