SynthDef.new(\ripples,
{|bus, ripples, rlpq, rdrive|
var osc;
osc = In.ar(bus, 2);
osc = MiRipples.ar(osc, ripples, rlpq, rdrive);
ReplaceOut.ar(bus, osc)}).add;
