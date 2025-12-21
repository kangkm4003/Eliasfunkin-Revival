local _CameraMove_amount = 50
local _doCameraMove = false

function onEvent(event, value1, value2, strumTime)
    if event == 'NoteCamMove' then
        if value1 == 'true' then
            _doCameraMove = true
            _CameraMove_amount = value2
        else
            _doCameraMove = false
            _CameraMove_amount = 0
        end
    end
end

function opponentNoteHit(index, noteData, noteType, isSustain)
    if  not isSustain and _doCameraMove then
        local cameraPos = {
            x = getMidpointX('dad') + 150,
            y = getMidpointY('dad') - 100
        }
        cameraPos.x = cameraPos.x + (getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]'))
        cameraPos.y = cameraPos.y + (getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]'))
        if noteData == 0 then
            triggerEvent('Camera Follow Pos', cameraPos.x - _CameraMove_amount, cameraPos.y)
        elseif noteData == 1 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y + _CameraMove_amount)
        elseif noteData == 2 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y - _CameraMove_amount)
        elseif noteData == 3 then
            triggerEvent('Camera Follow Pos', cameraPos.x + _CameraMove_amount, cameraPos.y)
        end
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if  not isSustain and _doCameraMove then
        local cameraPos = {
            x = getMidpointX('boyfriend') - 100,
            y = getMidpointY('boyfriend') - 100
        }
        cameraPos.x = cameraPos.x - (getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]'))
        cameraPos.y = cameraPos.y + (getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]'))
        if noteData == 0 then
            triggerEvent('Camera Follow Pos', cameraPos.x - _CameraMove_amount, cameraPos.y)
        elseif noteData == 1 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y + _CameraMove_amount)
        elseif noteData == 2 then
            triggerEvent('Camera Follow Pos', cameraPos.x, cameraPos.y - _CameraMove_amount)
        elseif noteData == 3 then
            triggerEvent('Camera Follow Pos', cameraPos.x + _CameraMove_amount, cameraPos.y)
        end
    end
end