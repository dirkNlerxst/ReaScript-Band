# ReaScript-Band
ReaScripts for automating Rock Band Customs. These are intended to aid with the authoring process and are not meant as a full replacement to authoring. You may still need to go in to make your own changes to ensure accuracy and finer artistic details are preserved.

Full Disclosure: some of these scripts were aided by Claude.ai, but I am trying my best to vet them and ensure the logic is sound. I am still learning my way around lua. If efficiency or logic can be improved upon, please fork and make a pull request :)

While all scripts are built to have UNDO functionality, it may be wise to backup your MIDI/RPP data before using.

# INSTALLATION & USAGE

Add .lua files to your ReaScripts folder (you can find this by going to Options > Show REAPER resource path in explorer/finder). Then under Actions > Show Actions List > New Action > Load ReaScript. The scripts should then show up in the Action List, find it and press Run. You can also assign it to a shortcut from here, or build a custom action under New Action... > New Custom Action and assigning a handful of scripts to one action.

# TBRB-to-RB-Scripts 

These are scripts to automate the process of converting songs from The Beatles: Rock Band to Rock Band 2 format.

IMPORATANT: Your tracks MUST be named correctly or these will fail: 

&nbsp;&nbsp;&nbsp;&nbsp;"PART DRUMS" "PART BASS" "PART GUITAR" 

&nbsp;&nbsp;&nbsp;&nbsp;"RINGO" "PAUL" "GEORGE" "JOHN" 

&nbsp;&nbsp;&nbsp;&nbsp;"PART HARM1" "PART HARM2" "PART HARM3"

If it fails to find the track, make sure your tracks are named correctly.

  •Ringo.lua:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;1. Moves drum animation from RINGO to PART DRUMS<br>
    &nbsp;&nbsp;&nbsp;&nbsp;2. Deletes RINGO track.<br> 
  
  •PaulBASS.lua:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;1. Moves left hand fret positions from PAUL to PART BASS.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;2. Adds [map StrumMap_Pick]<br>
    &nbsp;&nbsp;&nbsp;&nbsp;3, Deletes PAUL track.<br>
    
  •GeorgeGTR.lua & JohnGTR.lua:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;1. Moves left hand fret positions from GEORGE/JOHN and moves it to PART GUITAR.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;2. Converts C/D/A midi note chords to [map HandMap_C/D/A], and other chords to [map HandMap_AllChords].<br> 
    &nbsp;&nbsp;&nbsp;&nbsp;3. If a 1/4 note gap between chords exists, creates [map HandMap_Default] a 1/16 note after the last chord.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;4. Deletes the GEORGE/JOHN track.<br>

  •Part2Harms.lua:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;1. Renames Reaper tracks from "PART HARM1/2/3" to "HARM1/2/3".<br>
    &nbsp;&nbsp;&nbsp;&nbsp;1. Renames midi track name from "PART HARM1/2/3" to "HARM1/2/3".<br>
    &nbsp;&nbsp;&nbsp;&nbsp;Notes:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-If your Reaper tracks are already named "HARM1/2/3", it will just rename the MIDI track names.<br> 
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-Due to the way the lua script handles the MIDI rename it won't explicitly say "Undo MIDI track rename",<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;but undoing twice should undo the MIDI track rename, and the Reaper track rename.<br>

# RB3-Scripts

  •UpgradeVenueScrub.lua: Removes all post-processing & lighting events except [first], [next], [prev]. This is intended to be used for RB3 Upgrades, as the game reads lighting/post-processing from both the upgrade and the original file, with the exception of the keyframe events.