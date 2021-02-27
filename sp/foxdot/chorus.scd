SynthDef.new(\chorus,
{|bus, fch, wch|
  var osc, mod, n=12;
  osc = In.ar(bus, 2);
  mod = {|i| LFPar.ar(fch * Rand(0.99, 1.01), 0.1 * i, mul:0.001, add:0.01)}!12;
  // wch is buggy because I need to always define in Tidal pattern
  osc = XFade2.ar(osc, Mix(DelayC.ar(osc, mod*4, mod)), wch.linlin(0,1,-1,1));
  ReplaceOut.ar(bus, osc)
}).add;
