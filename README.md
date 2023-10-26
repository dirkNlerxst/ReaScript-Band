# ReaScript-Band
ReaScripts for automating Rock Band Customs. These are intended to aid with the authoring process and are not meant as a full replacement to authoring. You may still need to go in to make your own changes to ensure accuracy and finer artistic details are preserved.

Full Disclosure: these scripts are being written by ChatGPT but I am trying my best to vet them and ensure the logic is sound. If you notice any problems please let me know. I know a little bit of Lua but am not a strong coder by any means. If efficiency or logic can be improved upon, please fork and make a pull request :)

While all scripts are built to have UNDO functionality, it may be wise to backup your MIDI/RPP data before using.

# INSTALLATION & USAGE

Add .lua files to your ReaScripts folder (you can find this by going to Options > Show REAPER resource path in explorer/finder). Then under Actions > Show Actions List > New Action > Load ReaScript. The scripts should then show up in the Action List, find it and press Run. You can also assign it to a shortcut from here, or build a custom action under New Action... > New Custom Action and assigning a handful of scripts to one action.

# TBRB-to-RB-Scripts 

These are scripts to automate the process of converting songs from The Beatles: Rock Band to Rock Band 2 format.

IMPORATANT: Your tracks MUST be named correctly or these will fail: "PART DRUMS" "PART BASS" "PART GUITAR" "RINGO" "PAUL" "GEORGE" "JOHN" "PART HARM1" "PART HARM2" "PART HARM3". If it fails to find the track, make sure your tracks are named correctly.

  •Ringo.lua: This takes all the drum animations from the RINGO track and moves them to the PART DRUMS track, and then delete the RINGO track. 
  
  •PaulBASS.lua: This takes the left hand fret positions from PAUL and moves it to PART BASS, adds [map StrumMap_Pick], and then delete the PAUL track.
    
  •GeorgeGTR.lua: This takes the left hand fret positions from GEORGE and moves it to PART GUITAR. Next, it converts C/D/A chords to [map HandMap_C/D/A], and any other chords to [map HandMap_AllChords]. If there is a 1/4 note gap between chords, it will create a text event named [map HandMap_Default] a 1/16 note after the last chord. Finally it deletes the GEORGE track.
  
  •JohnGTR.lua: See GeorgeGTR.lua

  •Part2Harms.lua: Renames the reaper track and the midi track of "PART HARM1/2/3" to "HARM1/2/3". If your Reaper tracks are already named "HARM1/2/3", it will just rename the MIDI track names. (Due to the way the lua script handles the MIDI rename it won't explicitly say "Undo MIDI track rename", but undoing twice should undo the MIDI track rename, and the Reaper track rename.)
