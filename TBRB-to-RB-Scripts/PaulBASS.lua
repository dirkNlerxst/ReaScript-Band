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

local paulTrackIndex = getTrackIndexByName("PAUL")
local partBassTrackIndex = getTrackIndexByName("PART BASS")

if not paulTrackIndex or not partBassTrackIndex then
    log("Error: Couldn't find the tracks.")
    return
end

local paulTrack = reaper.GetTrack(0, paulTrackIndex)
local partBassTrack = reaper.GetTrack(0, partBassTrackIndex)

local paulTake = reaper.GetTake(reaper.GetTrackMediaItem(paulTrack, 0), 0)
local partBassTake = reaper.GetTake(reaper.GetTrackMediaItem(partBassTrack, 0), 0)

if not paulTake or not partBassTake then
    log("Error: Couldn't find the takes for the tracks.")
    return
end

local _, noteCount, _, _ = reaper.MIDI_CountEvts(paulTake)
log("Number of events in PAUL: " .. noteCount)

-- Copying MIDI notes between 41 and 57 from "PAUL" to "PART BASS" and deleting them from "PAUL"
for i = noteCount - 1, 0, -1 do
    local _, _, _, startppq, endppq, _, pitch, velocity = reaper.MIDI_GetNote(paulTake, i)
    if pitch >= 41 and pitch <= 57 then
        reaper.MIDI_InsertNote(partBassTake, false, false, startppq, endppq, 0, pitch, velocity, true)
        reaper.MIDI_DeleteNote(paulTake, i)
    end
end

-- Inserting the text event "[map StrumMap_Pick]" to "PART BASS"
reaper.MIDI_InsertTextSysexEvt(partBassTake, false, false, 0, 1, "[map StrumMap_Pick]")

reaper.MIDI_Sort(partBassTake)
log("Sorted events in PART BASS")

reaper.DeleteTrack(paulTrack)
log("Deleted PAUL track")

reaper.Undo_EndBlock("Move MIDI notes from PAUL to PART BASS and add Text Event", -1)
log("Undo block ended")

