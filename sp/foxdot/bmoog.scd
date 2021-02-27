SynthDef.new(\bmoog,
{|bus, bmf, bmq, bmm|
  var osc;
  osc = In.ar(bus, 2);
  osc = BMoog.ar(osc, bmf, bmq, bmm);
  ReplaceOut.ar(bus, osc)
}).add;
