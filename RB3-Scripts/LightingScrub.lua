function log(msg)
    reaper.ShowConsoleMsg(tostring(msg) .. "\n")
end

function getTrackByName(name)
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetTrackName(track)
        if trackName == name then return track end
    end
    return nil
end

function ticksToMeasure(ticks)
    local retval, timepos, measurepos, beatpos, bpm, timesig_num, timesig_denom = reaper.GetTempoTimeSigMarker(0, 0)
    local beatsPerMeasure = retval and timesig_num or 4
    local qn = ticks / 480
    local measures = math.floor(qn / beatsPerMeasure) + 1
    local beats = math.floor(qn % beatsPerMeasure) + 1
    local remainingTicks = math.floor(ticks % 480)
    return string.format("%d:%d:%d", measures, beats, remainingTicks)
end

function removeTextEvents()
    local venueTrack = getTrackByName("VENUE")
    if not venueTrack then
        log("Error: VENUE track not found")
        return false
    end

    local item = reaper.GetTrackMediaItem(venueTrack, 0)
    if not item then
        log("Error: No item found in VENUE track")
        return false
    end

    local take = reaper.GetActiveTake(item)
    if not take then
        log("Error: No active take found")
        return false
    end

    -- Mark the MIDI take as having been edited
    reaper.MIDI_DisableSort(take)

    local prefixesToRemove = {
        "[lighting ()]",
        "[lighting (verse)]",
        "[lighting (chorus)]",
        "[lighting (manual_cool)]",
        "[lighting (manual_warm)]",
        "[lighting (dischord)]",
        "[lighting (stomp)]",
        "[lighting (loop_cool)]",
        "[lighting (loop_warm)]",
        "[lighting (harmony)]",
        "[lighting (frenzy)]",
        "[lighting (silhouettes)]",
        "[lighting (silhouettes_spot)]",
        "[lighting (searchlights)]",
        "[lighting (sweep)]",
        "[lighting (strobe_slow)]",
        "[lighting (strobe_fast)]",
        "[lighting (blackout_slow)]",
        "[lighting (blackout_fast)]",
        "[lighting (flare_slow)]",
        "[lighting (flare_fast)]",
        "[lighting (bre)]"
    }

    local _, _, _, textEventCount = reaper.MIDI_CountEvts(take)
    local removedCount = 0
    local logMessages = {}

    for i = textEventCount - 1, 0, -1 do
        local retval, selected, muted, ppqpos, type, msg = reaper.MIDI_GetTextSysexEvt(take, i)
        
        for _, prefix in ipairs(prefixesToRemove) do
            if msg:sub(1, #prefix) == prefix then
                table.insert(logMessages, string.format("%s Removed: %s", ticksToMeasure(ppqpos), msg))
                reaper.MIDI_DeleteTextSysexEvt(take, i)
                removedCount = removedCount + 1
                break
            end
        end
    end

    -- Re-enable sorting and commit the changes
    reaper.MIDI_Sort(take)

    for i = #logMessages, 1, -1 do
        log(logMessages[i])
    end
    log(string.format("\nRemoved %d text events", removedCount))

    -- Mark item as changed
    reaper.MarkTrackItemsDirty(venueTrack, item)
    
    return removedCount > 0
end

-- Main execution
reaper.PreventUIRefresh(1)
reaper.Undo_BeginBlock()

local success = removeTextEvents()

if success then
    reaper.UpdateArrange()
    reaper.Undo_EndBlock("Remove Lighting Events", -1)
else
    reaper.Undo_EndBlock("No Lighting Events Removed", -1)
end
reaper.PreventUIRefresh(-1)
