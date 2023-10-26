local function log(msg)
    reaper.ShowConsoleMsg(tostring(msg) .. "\n")
end

local function getTrackByName(name)
    local numTracks = reaper.GetNumTracks()
    for i = 0, numTracks - 1 do
        local track = reaper.GetTrack(0, i)
        local _, trackName = reaper.GetTrackName(track)
        if trackName == name then
            return track
        end
    end
    return nil
end

local function updateReaperTrackName(trackName, newName)
    local track = getTrackByName(trackName)
    if track then
        reaper.GetSetMediaTrackInfo_String(track, "P_NAME", newName, true)
        log("Updated Reaper track name to: " .. newName)
    end
end

local function updateMIDIEventTrackName(trackName, newName)
    log("Checking track: " .. trackName)
    local track = getTrackByName(trackName) or getTrackByName(newName) -- Look for both potential track names
    if track then
        local item = reaper.GetTrackMediaItem(track, 0)
        local take = reaper.GetActiveTake(item)
        if take and reaper.TakeIsMIDI(take) then
            local _, numEvents = reaper.MIDI_CountEvts(take)
            for evtIdx = 0, numEvents - 1 do
                local _, selected, muted, ppqPos, evtType, evtMsg = reaper.MIDI_GetTextSysexEvt(take, evtIdx)
                if evtMsg and evtMsg == "PART " .. newName then
                    local trackNameType = 0x03 -- This is the subtype for Track Name meta events
                    reaper.MIDI_SetTextSysexEvt(take, evtIdx, selected, muted, ppqPos, trackNameType, newName, true)
                    log("Updated track name event to: " .. newName)
                    break
                end
            end
        end
    else
        log(trackName .. " not found.")
    end
end

reaper.Undo_BeginBlock()

updateReaperTrackName("PART HARM1", "HARM1")
updateMIDIEventTrackName("PART HARM1", "HARM1")

updateReaperTrackName("PART HARM2", "HARM2")
updateMIDIEventTrackName("PART HARM2", "HARM2")

updateReaperTrackName("PART HARM3", "HARM3")
updateMIDIEventTrackName("PART HARM3", "HARM3")

reaper.Undo_EndBlock("Update Track Names", -1)

