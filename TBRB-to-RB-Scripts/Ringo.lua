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

local ringoTrackIndex = getTrackIndexByName("RINGO")
local partDrumsTrackIndex = getTrackIndexByName("PART DRUMS")

if not ringoTrackIndex or not partDrumsTrackIndex then
    log("Error: Couldn't find the tracks.")
    return
end

local ringoTrack = reaper.GetTrack(0, ringoTrackIndex)
local partDrumsTrack = reaper.GetTrack(0, partDrumsTrackIndex)

local ringoTake = reaper.GetTake(reaper.GetTrackMediaItem(ringoTrack, 0), 0)
local partDrumsTake = reaper.GetTake(reaper.GetTrackMediaItem(partDrumsTrack, 0), 0)

if not ringoTake or not partDrumsTake then
    log("Error: Couldn't find the takes for the tracks.")
    return
end

local _, noteCount, _, _ = reaper.MIDI_CountEvts(ringoTake)
log("Number of events in RINGO: " .. noteCount)

for i = noteCount - 1, 0, -1 do
    local _, _, _, startppq, endppq, _, pitch, velocity = reaper.MIDI_GetNote(ringoTake, i)
    
    if pitch == 23 then
        pitch = 24
    end
    
    reaper.MIDI_InsertNote(partDrumsTake, false, false, startppq, endppq, 0, pitch, velocity, true)
    reaper.MIDI_DeleteNote(ringoTake, i)
end

reaper.MIDI_Sort(partDrumsTake)
log("Sorted events in PART DRUMS")

reaper.DeleteTrack(ringoTrack)
log("Deleted RINGO track")

reaper.Undo_EndBlock("Move MIDI notes from RINGO to PART DRUMS", -1)
log("Undo block ended")

