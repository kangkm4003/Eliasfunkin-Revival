function onCountdownStarted()
    defaultScaleX = {
        getPropertyFromGroup('opponentStrums', 0, 'scale.x'),
        getPropertyFromGroup('opponentStrums', 1, 'scale.x'),
        getPropertyFromGroup('opponentStrums', 2, 'scale.x'),
        getPropertyFromGroup('opponentStrums', 3, 'scale.x'),

        getPropertyFromGroup('playerStrums', 0, 'scale.x'),
        getPropertyFromGroup('playerStrums', 1, 'scale.x'),
        getPropertyFromGroup('playerStrums', 2, 'scale.x'),
        getPropertyFromGroup('playerStrums', 3, 'scale.x')
    }
end

function opponentNoteHit(index, noteData, noteType, isSustain)
    if not isSustain then
        if noteType == 'NoteBump' or noteType == 'Alt Animation' then
            local y = {
                defaultOpponentStrumY0, 
                defaultOpponentStrumY1, 
                defaultOpponentStrumY2, 
                defaultOpponentStrumY3
            }
            setProperty('opponentStrums.members['..noteData..'].scale.x', defaultScaleX[noteData + 1] + defaultScaleX[noteData + 1] / 4)
            doTweenX('noteBumpScaleTween'..noteData, 'opponentStrums.members['..noteData..'].scale', defaultScaleX[noteData + 1], 0.25, 'sineOut')
            if downscroll then
                setPropertyFromGroup('opponentStrums', noteData, 'y', y[noteData + 1] + 25)
            elseif not downscroll then
                setPropertyFromGroup('opponentStrums', noteData, 'y', y[noteData + 1] - 25)
            end
            noteTweenY('noteBumpTween'..noteData, noteData, y[noteData + 1], 0.25, 'sineOut')
        end
    end
end

function goodNoteHit(index, noteData, noteType, isSustain)
    if not isSustain then
        if noteType == 'NoteBump' or noteType == 'Alt Animation' then
            local y = {
                defaultPlayerStrumY0, 
                defaultPlayerStrumY1, 
                defaultPlayerStrumY2, 
                defaultPlayerStrumY3
            }
            setProperty('playerStrums.members['..noteData..'].scale.x', defaultScaleX[noteData + 4] + defaultScaleX[noteData + 4] / 4)
            doTweenX('noteBumpScaleTween'..noteData + 4, 'playerStrums.members['..noteData..'].scale', defaultScaleX[noteData + 4], 0.25, 'sineOut')
            if downscroll then
                setPropertyFromGroup('playerStrums', noteData, 'y', y[noteData + 1] + 25)
            elseif not downscroll then
                setPropertyFromGroup('playerStrums', noteData, 'y', y[noteData + 1] - 25)
            end
            noteTweenY('noteBumpTween'..noteData + 4, noteData + 4, y[noteData + 1], 0.25, 'sineOut')
        end
    end
end