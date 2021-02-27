#!/usr/bin/env python

from IPython.terminal.prompts import Prompts, Token
import cmd
import os
from FoxDot import *

class MyPrompt(Prompts):
     def in_prompt_tokens(self, cli=None):
         return [(Token, "FoxDot>"),
                 (Token.Prompt, ' ')]
ip = get_ipython()
ip.prompts = MyPrompt(ip)
ip.highlighting_style = "solarized-dark"
ip.colors = "Linux"

# Clock.bpm = 60
# Scale.default = "chromatic"

Clock.bpm = 120
Scale.default = "major"

# Synths
chicago = SynthDef("fchicagoep")
pad = SynthDef("fpadep")
reed = SynthDef("freedep")
fm1 = SynthDef("ffm1ep")
fmx = SynthDef("ffmxep")
fm3 = SynthDef("ffm3ep")
elecount = SynthDef("felecountep")
cof = SynthDef("fcofep")
cr = SynthDef("fcrep")
dpulse = SynthDef("fdpulseep")
wm = SynthDef("fwmep")
codrum = SynthDef("fcodrumep")
hypnogabber = SynthDef("fhypnogabberep")
ring = SynthDef("fringep")
bpfsaw = SynthDef("fbpfsawep")
kmeans = SynthDef("fkmeansep")
sinfb = SynthDef("fsinfbep")
f808bd = SynthDef("f808bd")
f808lt = SynthDef("f808lt")
f808mt = SynthDef("f808mt")
f808ht = SynthDef("f808ht")
# Effects
reverb2 = SynthDef("reverb2")
# From Foxdot
piano = SynthDef("piano")
# Mi-UGens
plaits = SynthDef("fplaitsep")
tides = SynthDef("ftidesep")
omi = SynthDef("fomiep")

fx = FxList.new("ripples", "ripples", {"ripples": 0.3, "rlpq": 0.2, "rdrive": 1}, order=2)
fx.server.loadSynthDef("/home/mantas/sp/foxdot/ripples.scd") # provide name to load

fx = FxList.new("fch", "chorus", {"fch": 1, "wch": 1}, order=2)
fx.server.loadSynthDef("/home/mantas/sp/foxdot/chorus.scd") # provide name to load

fx = FxList.new("bmf", "bmoog", {"bmf": 440, "bmq": 0.2, "bmm": 0}, order=2)
fx.server.loadSynthDef("/home/mantas/sp/foxdot/bmoog.scd") # provide name to load

fx = FxList.new("mu", "mu", {"mu": 1, "mbypass": 0}, order=2)
fx.server.loadSynthDef("/home/mantas/sp/foxdot/mu.scd") # provide name to load

fx = FxList.new("verb", "verb", {"verb": 0.5, "vtime": 0.7, "vdamp": 0.5, "vhp": 0.05, "vfreeze": 0, "vdiff": 0.625}, order=2)
fx.server.loadSynthDef("/home/mantas/sp/foxdot/verb.scd") # provide name to load

Effect.server.setFx(FxList)

# silent event variable
r = None
