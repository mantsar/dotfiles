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

Clock.bpm = 60

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
# From Foxdot
piano = SynthDef("piano")
