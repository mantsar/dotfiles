SynthDef.new(\mu,
{|bus, mu, mbypass|
  var osc;
  osc = In.ar(bus, 2);
  osc = MiMu.ar(osc, mu, mbypass);
  ReplaceOut.ar(bus, osc)
}).add;
