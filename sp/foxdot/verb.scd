SynthDef.new(\verb,
{|bus, verb, vtime, vdamp, vhp, vfreeze, vdiff|
  var osc;
  osc = In.ar(bus, 2);
  osc = MiVerb.ar(osc, vtime, verb, vdamp, vhp, vfreeze, vdiff);
  ReplaceOut.ar(bus, osc)
}).add;
