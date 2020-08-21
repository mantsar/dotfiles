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

# Synths
chicago = SynthDef("fchicagoep")
