# ReaScript-Band
ReaScripts for automating Rock Band Customs. These are intended to aid with the authoring process and are not meant as a full replacement to authoring. You may still need to go in to make your own changes to ensure accuracy and finer artistic details are preserved.

Full Disclosure: these scripts are being written by ChatGPT but I am trying my best to vet them and ensure the logic is sound. If you notice any problems please let me know. I know a little bit of Lua but am not a strong coder by any means. If efficiency or logic can be improved upon, please fork and make a pull request :)

While all scripts are built to have UNDO functionality, it may be wise to backup your MIDI/RPP data before using.

# INSTALLATION & USAGE

Add .lua files to your ReaScripts folder (you can find this by going to Options > Show REAPER resource path in explorer/finder). Then under Actions > Show Actions List > New Action > Load ReaScript. The scripts should then show up in the Action List, find it and press Run. You can also assign it to a shortcut from here, or build a custom action under New Action... > New Custom Action and assigning a handful of scripts to one action.

# TBRB-to-RB-Scripts 

These are scripts to automate the process of converting songs from The Beatles: Rock Band to Rock Band 2 format.

IMPORATANT: Your tracks MUST be named correctly or these will fail: 

&nbsp;"PART DRUMS" "PART BASS" "PART GUITAR" 

&nbsp;"RINGO" "PAUL" "GEORGE" "JOHN" 

&nbsp;"PART HARM1" "PART HARM2" "PART HARM3"

If it fails to find the track, make sure your tracks are named correctly.

  •Ringo.lua:<br>
    1. Moves drum animation from RINGO to PART DRUMS<br>
    2. Deletes RINGO track.<br> 
  
  •PaulBASS.lua:<br>
    &nbsp;1. Moves left hand fret positions from PAUL to PART BASS.<br>
    &nbsp;2. Adds [map StrumMap_Pick]<br>
    &nbsp;3, Deletes PAUL track.<br>
    
  •GeorgeGTR.lua & JohnGTR.lua:<br>
    &nbsp;1. Moves left hand fret positions from GEORGE/JOHN and moves it to PART GUITAR.<br>
    &nbsp;2. Converts C/D/A midi note chords to [map HandMap_C/D/A], and other chords to [map HandMap_AllChords].<br> 
    &nbsp;3. If a 1/4 note gap between chords exists, creates a text event named [map HandMap_Default] a 1/16 note after the last chord.<br>
    &nbsp;4. Deletes the GEORGE/JOHN track.<br>

  •Part2Harms.lua:<br>
    &nbsp;1. Renames Reaper tracks from "PART HARM1/2/3" to "HARM1/2/3".<br>
    &nbsp;1. Renames midi track name from "PART HARM1/2/3" to "HARM1/2/3".<br>
    &nbsp;Notes:<br>
      &nbsp;&nbsp;-If your Reaper tracks are already named "HARM1/2/3", it will just rename the MIDI track names.<br> 
      &nbsp;&nbsp;-Due to the way the lua script handles the MIDI rename it won't explicitly say "Undo MIDI track rename", but undoing twice should undo the MIDI track rename, and the Reaper track rename.<br>
