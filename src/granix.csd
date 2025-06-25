<Cabbage> bounds(0, 0, 0, 0)
form caption("GRANIX") size(1400, 1000), pluginId("gin2"), colour(0, 10, 160, 100)

; File path selection button
filebutton bounds(12, 14, 85, 42), text("Open File", "Open File"),  channel("filename"), shape("ellipse")

; Granulator ON/OFF switch
checkbox   bounds(138, 14, 98, 42), channel("onoff"), text("ON/OFF"), , fontColour:0(255, 255, 255, 255)

; Playback rate control (speed and direction)
vslider bounds(662, 450, 114, 491), channel("ratePlay"), range(-2, 2, 1, 1, 0.001), text("RATE PLAY"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Scrubber for position control relative to current position
vslider bounds(804, 450, 114, 491), channel("scrab"), range(0, 1, 0, 1, 0.001), text("SCRAB"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Play/Stop transport control
checkbox   bounds(288, 14, 113, 42), channel("PlayStop"), text("Play/Stop"), , fontColour:0(255, 255, 255, 255)

; WAVEFORM DISPLAY - beg is start position, len is length
soundfiler bounds(4, 76, 1391, 209), channel("beg","len"), identChannel("filer1"), colour(0, 255, 255, 255), fontColour(160, 160, 160, 255)

; Grain reading frequency (pitch control)
vslider bounds(28, 450, 114, 491), channel("Freq"), range(-2, 2, 1, 1, 0.001), text("FREQ"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Grain density - number of grains per second
vslider bounds(154, 450, 114, 491) channel("Dens") range(1, 1000, 1, 1, 0.001),text("Dens"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)
vslider bounds(274, 450, 114, 491) channel("DensRand") range(0, 1, 0, 1, 0.001),text("DensRand"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Grain duration controls
vslider bounds(400, 450, 114, 491) channel("Dur") range(1, 1000, 10, 1, 1) text("DUR"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)
vslider bounds(532, 448, 114, 491) channel("DurRand") range(0, 1, 0, 1, 0.001) text("DUR-RAND"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Envelope shape control (attack/decay ratio)
rslider bounds(402, 306, 108, 85) channel("EnvForm") range(0.001, 0.999, 0.5, 1, 0.001) text("ENVFORM"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Input amplitude control
rslider bounds(28, 304, 111, 86) channel("ampIN_grain") range(0, 1, 0.5, 1, 0.01) text("AMP IN"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Ambisonics Azimuth control (-180° to +180°)
rslider bounds(156, 304, 112, 87), channel("kazi"), range(-180, 180, 0, 1, 0.001), text("AZIMUTH"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

; Ambisonics Elevation percentage control (0% to 100%)
rslider bounds(280, 304, 108, 87), channel("kelev"), range(0, 1, 0, 1, 0.001), text("% ELEVETION"), trackerColour(0, 255, 255, 255), textColour(255, 255, 255, 255)

</Cabbage>

<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d 
</CsOptions>

<CsInstruments>
; Initialize global variables
ksmps = 32      ; Audio samples per control period
nchnls = 4      ; 4-channel output for AmbiX (W, Y, Z, X)
0dbfs = 1       ; Full scale = 1.0

seed 0          ; Initialize random seed

; =============================================================================
; AMBIX FIRST-ORDER ENCODER OPCODE
; Converts mono signal + spherical coordinates to AmbiX format
; Input: audio signal, azimuth (degrees), elevation (degrees)
; Output: W, Y, Z, X channels
; =============================================================================
opcode AmbixFra, aaaa, akk
    
    aSig, kazi, kelev xin

    ; Mathematical constants
    iPi = 4 * taninv(1)
    
    ; Convert degrees to radians
    kElevRad = (kelev / 180) * iPi
    kAziRad = (kazi / 180) * iPi

    ; AmbiX First Order encoding:
    a0 = aSig                                ; W: Omnidirectional component
    a1 = aSig * sin(kAziRad) * cos(kElevRad) ; Y: Left-Right (figure-8, left=pos, right=neg)
    a2 = aSig * sin(kElevRad)                ; Z: Up-Down (figure-8, up=pos, down=neg)
    a3 = aSig * cos(kAziRad) * cos(kElevRad) ; X: Front-Back (figure-8, front=pos, back=neg)

    xout a0, a1, a2, a3

endop

; =============================================================================
; INSTRUMENT 100 - MAIN CONTROLLER
; Handles GUI parameters and coordinates other instruments
; =============================================================================
instr 100

    ; FILE PATH MANAGEMENT
    gSfilepath  cabbageGetValue "filename"  ; Get selected file path
    
    ; WAVEFORM DISPLAY CONTROLS
    gkBeg       cabbageGetValue "beg"       ; Start position in samples
    gkEnd       cabbageGetValue "len"       ; End position in samples
    gkScrab     cabbageGetValue "scrab"     ; Scrubber amount (position variation)
    
    ; TRANSPORT CONTROLS
    gkOnOff     cabbageGetValue "onoff"     ; Granulator ON/OFF
    gkPlayStop  cabbageGetValue "PlayStop"  ; Transport play/stop
    gkRatePlay  cabbageGetValue "ratePlay"  ; Playback rate (speed/direction)
    
    ; GRANULATION PARAMETERS
    gkFreq      cabbageGetValue "Freq"      ; Grain frequency (pitch)
    gkDens      cabbageGetValue "Dens"      ; Grain density (grains per second)
    gkDensRand  cabbageGetValue "DensRand"  ; Density randomization amount
    gkDur0      cabbageGetValue "Dur"       ; Grain duration (milliseconds)
    gkDurRand   cabbageGetValue "DurRand"   ; Duration randomization amount
    gkEnvForm   cabbageGetValue "EnvForm"   ; Envelope shape (attack/decay ratio)
    
    ; AMBISONICS PARAMETERS
    gkkazi      cabbageGetValue "kazi"      ; Azimuth angle
    gkkelev     cabbageGetValue "kelev"     ; Elevation percentage
    
    ; AMPLITUDE CONTROL
    gkampIN_grain cabbageGetValue "ampIN_grain" ; Input amplitude
    
    ; TRIGGER FILE LOADING when path changes
    prints gSfilepath
    if changed:k(gSfilepath)==1 then       
        event "i",99,0,0                   ; Call instrument 99 to load file
    endif
    
    ; GRANULATOR ON/OFF CONTROL
    ; Trigger instrument 1 when granulator is turned on
    ktrig trigger gkOnOff,0.5,0           ; Detect ON trigger
    schedkwhen ktrig,0,0,1,0,-1           ; Start instrument 1 (infinite duration)
 
endin

; =============================================================================
; INSTRUMENT 99 - FILE LOADER
; Loads audio file into memory table and sets up waveform display
; =============================================================================
instr 99

    ; CALCULATE NUMBER OF CHANNELS in source file
    gichans    filenchnls    gSfilepath           
    cabbageSetValue "nch", gichans
 
    ; LOAD FILE INTO MONO TABLE (channel 1 only)
    ; Syntax: ftgen ifn, itime, isize, igen, filename, iskip, iformat, ichn
    gitable    ftgen    1,0,0,1,gSfilepath,0,0,1    ; Load as mono (channel 1)
 
    ; GET TABLE LENGTH in samples        
    gifilelen = nsamp(gitable)
 
    ; CALCULATE DURATION in seconds	
    giDurata = gifilelen / sr
  
    ; CALCULATE PHASE INCREMENT for sample-accurate reading
    giphasfreq	= sr / (ftlen(gitable))
 
    ; UPDATE WAVEFORM DISPLAY
    Smessage sprintfk "file(%s)", gSfilepath
    chnset Smessage, "filer1"   
 
endin

; =============================================================================
; INSTRUMENT 1 - PLAYBACK ENGINE & GRAIN SCHEDULER
; Manages transport, generates grain triggers, updates playhead position
; =============================================================================
instr 1

    ; AUTO-SHUTDOWN when granulator is turned off
    if gkOnOff==0 then
        turnoff
    endif

    ; =============================================================================
    ; GRAIN DENSITY & DURATION MANAGEMENT with randomization
    ; =============================================================================
    
    ; DENSITY RANDOMIZATION
    ; Generate random variation around base density
    kDensRand randomh   (-gkDens / 2) * gkDensRand,  (gkDens / 2) * gkDensRand, gkDens
    kDens = gkDens + kDensRand          ; Apply random variation
    gkDensElev = kDens / 100            ; Scale for elevation calculation
    kTrig metro kDens                   ; Generate grain triggers at density rate
    
    ; DURATION PROCESSING & RANDOMIZATION
    gkDur1 = gkDur0 / 1000              ; Convert milliseconds to seconds
    kDurRand randomh   (-gkDur1 / 2) * gkDurRand,  (gkDur1 / 2) * gkDurRand, gkDens
    gkDur = gkDur1 + kDurRand           ; Apply random duration variation
    
    ; SCHEDULE GRAIN GENERATION
    schedkwhen kTrig, 0, 0, 2, 0, gkDur ; Trigger instrument 2 for each grain

    ; =============================================================================
    ; TRANSPORT CONTROL with phasor-based playhead
    ; =============================================================================
    
    ; RESTART phasor when play state or start position changes
    if changed(gkPlayStop, gkBeg) = 1 then
        reinit RESTART
    endif
        
    RESTART:
    ; MAIN PLAYHEAD PHASOR
    ; Advances from 0 to 1 based on playback rate and play/stop state
    gkndx phasor giphasfreq * gkRatePlay * gkPlayStop, 0
    
    ; SCRUBBER RANDOMIZATION
    ; Creates position variation around current playhead
    gkScrab randomh -1*gkScrab, 1*gkScrab, kDens
    
    ; CALCULATE ABSOLUTE SAMPLE POSITION
    gkPOS = gkBeg + (gkScrab + gkndx) * gifilelen
    
    ; WRAP POSITION to stay within file bounds
    if(gkPOS >= gifilelen) then
        gkPOS = gkPOS - gifilelen
    endif
    
    ; =============================================================================
    ; WAVEFORM DISPLAY UPDATE
    ; =============================================================================
    
    ; Update playhead cursor position in GUI
    Smessage sprintfk "scrubberPosition(%d)",gkPOS
    chnset Smessage, "filer1"

endin

; =============================================================================
; INSTRUMENT 2 - GRAIN GENERATOR with Ambisonics Spatialization
; Creates individual grains with dynamic spatial positioning
; =============================================================================
instr 2
 
    ; CALCULATE START PHASE for this grain based on current playhead position
    iPhase = i(gkPOS) / gifilelen       ; Normalize to 0-1 range
    
    ; =============================================================================
    ; GRAIN SYNTHESIS
    ; =============================================================================
    
    ; PITCH CALCULATION
    aPitch = giphasfreq * i(gkFreq)     ; Set grain reading frequency
    aFreq = aPitch
    
    ; GRAIN PLAYBACK
    ; Use phasor to read through the audio table at specified frequency
    andx phasor aFreq, iPhase           ; Sample index (0-1) with starting phase
    aSig tablei andx, gitable, 1        ; Read from audio table with interpolation
    
    ; =============================================================================
    ; GRAIN ENVELOPE (Triangular with adjustable attack/decay ratio)
    ; =============================================================================
    
    iRatio = i(gkEnvForm)               ; Get envelope shape control
    iDurA = (i(gkDur) / 2) * iRatio     ; Attack duration
    iDurB = (i(gkDur) / 2) * (1 - iRatio) ; Decay duration
    aEnv linseg 0, iDurA, 1, iDurB, 0   ; Triangular envelope
    
    ; APPLY ENVELOPE and amplitude control
    aOut = aSig * aEnv * i(gkampIN_grain)
    
    ; =============================================================================
    ; AMBISONICS SPATIALIZATION
    ; =============================================================================
    
    ; DYNAMIC AZIMUTH CALCULATION
    ; Combines user-set azimuth with file position for rotating effect
    kaziout = gkkazi + (iPhase) * 360   ; User azimuth + position-based rotation
    
    ; DYNAMIC ELEVATION CALCULATION  
    ; Creates random elevation influenced by grain density and user control
    kelev = (rnd(180) - 90) * i(gkDensElev) * i(gkkelev) ; Range: -90° to +90°
    
    ; ENCODE TO AMBIX FORMAT
    a0, a1, a2, a3 AmbixFra aOut, kaziout, kelev
    
    ; OUTPUT 4-channel AmbiX: W, Y, Z, X
    out a0, a1, a2, a3

endin

</CsInstruments>

<CsScore>
; Run Csound for extended time (approximately 7000 years)
f0 z

; Start main controller instrument and run indefinitely
i100 0 -1 
</CsScore>

</CsoundSynthesizer>
