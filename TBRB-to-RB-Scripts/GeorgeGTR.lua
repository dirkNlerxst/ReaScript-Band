reaper.Undo_BeginBlock()

-- Function to log messages to the REAPER console
function log(msg)
    reaper.ShowConsoleMsg(tostring(msg) .. "\n")
end

-- Function to get the track index by its name
function getTrackIndexByName(trackName)
    for i = 0, reaper.CountTracks(0) - 1 do
        local track = reaper.GetTrack(0, i)
        local _, name = reaper.GetSetMediaTrackInfo_String(track, "P_NAME", "", false)
        if name == trackName then
            return i
        end
    end
    return nil
end

local georgeTrackIndex = getTrackIndexByName("GEORGE")
local partGuitarTrackIndex = getTrackIndexByName("PART GUITAR")

if not georgeTrackIndex or not partGuitarTrackIndex then
    log("Error: Couldn't find the tracks.")
    return
end

local georgeTrack = reaper.GetTrack(0, georgeTrackIndex)
local partGuitarTrack = reaper.GetTrack(0, partGuitarTrackIndex)

local georgeTake = reaper.GetTake(reaper.GetTrackMediaItem(georgeTrack, 0), 0)
local partGuitarTake = reaper.GetTake(reaper.GetTrackMediaItem(partGuitarTrack, 0), 0)

if not georgeTake or not partGuitarTake then
    log("Error: Couldn't find the takes for the tracks.")
    return
end

local _, noteCount, _, _ = reaper.MIDI_CountEvts(georgeTake)
log("Number of events in GEORGE: " .. noteCount)

local lastNoteEndPPQ = 0

-- First pass to identify gaps between MIDI notes 60 to 69
for i = 0, noteCount - 1 do
    local _, _, _, startppq, endppq, _, pitch, _ = reaper.MIDI_GetNote(georgeTake, i)

    if pitch >= 60 and pitch <= 69 then
        if startppq - lastNoteEndPPQ > (480*2) then  -- Assuming 480 PPQs per quarter note, so 480*2 for a whole note
            reaper.MIDI_InsertTextSysexEvt(partGuitarTake, false, false, lastNoteEndPPQ + (480/16), 1, "[map HandMap_Default]")
        end
        lastNoteEndPPQ = endppq
    end
end

-- Second pass for conversion and copying
for i = noteCount - 1, 0, -1 do
    local _, _, _, startppq, endppq, _, pitch, velocity = reaper.MIDI_GetNote(georgeTake, i)

    -- Convert specific MIDI notes to their corresponding text events
    local textEvent = nil
    if pitch == 60 then
        textEvent = "[map HandMap_Chord_C]"
    elseif pitch == 62 then
        textEvent = "[map HandMap_Chord_D]"
    elseif pitch == 64 or pitch == 67 then
        textEvent = "[map HandMap_AllChords]"
    elseif pitch == 69 then
        textEvent = "[map HandMap_Chord_A]"
    end

    if textEvent then
        reaper.MIDI_InsertTextSysexEvt(partGuitarTake, false, false, startppq, 1, textEvent)
        reaper.MIDI_DeleteNote(georgeTake, i)
    elseif pitch >= 41 and pitch <= 57 then
        reaper.MIDI_InsertNote(partGuitarTake, false, false, startppq, endppq, 0, pitch, velocity, true)
        reaper.MIDI_DeleteNote(georgeTake, i)
    end
end

reaper.MIDI_Sort(partGuitarTake)
log("Sorted events in PART GUITAR")

reaper.DeleteTrack(georgeTrack)
log("Deleted GEORGE track")

reaper.Undo_EndBlock("Convert MIDI notes from GEORGE to Text Events in PART GUITAR and copy MIDI notes 41-57", -1)
