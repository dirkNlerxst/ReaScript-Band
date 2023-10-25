# ReaScript-Band
ReaScripts for automating Rock Band Customs. These are intended to aid with the authoring process and are not meant as a full replacement to authoring. You may still need to go in to make your own changes to ensure accuracy and finer artistic details are preserved.

Full Disclosure: these scripts are being written by ChatGPT but I am trying my best to vet them and ensure the logic is sound. If you notice any problems please let me know. I know a little bit Lua but am not a strong coder by any means. If efficiency or logic can be improved upon, please fork and make a pull request :)

While all scripts are built to have UNDO functionality, it may be wise to backup your MIDI/RPP data before using.

#TBRB-to-RB-Scripts 

These are scripts to automate the process of converting songs from The Beatles: Rock Band to Rock Band 2 format.

  •Ringo.lua: This takes all the drum animations from the RINGO track and moves them to the PART DRUMS track, and then delete the RINGO track. 
  
  •PaulBASS.lua: This takes the left hand fret positions from PAUL and moves it to PART BASS, and then delete the PAUL track.
    
  •GeorgeGTR.lua: This takes the left hand fret positions from GEORGE and moves it to PART GUITAR. Next, it converts C/D/A chords to [map HandMap_C/D/A], and any other chords to [map HandMap_AllChords]. If there is a 1/4 note gap between chords, it will create a text event named [map HandMap_Default] a 1/16 note after the last chord. Finally it deletes the GEORGE track.
  
  •JohnGTR.lua: See GeorgeGTR.lua<br>
