~synthdef_factor = {|key, wrap, scope=nil|
	var dict_base;
	dict_base = (
// Environments ---------------------------------------------------------------
	(("" ++ key).asSymbol):{|sig, env, bus, out=0, o=0, j=0, pan=0, a=1|
		Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a)},
	(("0f" ++ key).asSymbol):{|sig, env, bus, out=0, pan=0, amp=1|
		ReplaceOut.ar(bus, Pan2.ar(sig, pan) * env * amp)},
	(("s" ++ key).asSymbol):{|sig, env, bus, out=0, pan=0|
		OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels, pan, env))}
	);
	if (scope.notNil) {
		["", "0f", "s"][(Set[0,1,2] - scope.asArray.asSet).asArray].do {|v|
			dict_base[(v ++ key).asSymbol] = nil;
		}
	};
	dict_base.keysValuesDo {|key_base, out_func|
		key_base = key_base.asString;
		// Envelopes --------------------------------------------------------------
		(
		// Sustained
		"":{|atk=0.01, sustain=1, curve=(-4), gate=1, da=2|
			EnvGen.kr(Env.asr(atk, 1, sustain-atk-0.01, curve:curve), gate:gate, doneAction:da)},
		// Standard
		"ep":{|atk=0.01, sustain=1, sus=1, curve=(-4)|
			EnvGen.kr(Env.perc(atk, sustain-atk, curve:curve), doneAction:2)},
		"0ep":{|atk=0, sus=1, curve=(-4)|
			EnvGen.kr(Env.perc(atk, sus-atk, curve:curve), doneAction:0)}
		).keysValuesDo {|key_env, env_func|
			var fx, key=nil;
			if (key_base[0] == $0) { 
				if (key_env[0] == $0) { 
					key = key_base[1..] ++ key_env[1..];
					fx = {|bus, freq| In.kr(bus, 1)};
				}
			} {
				if (key_env[0] != $0) { 
					key = key_base ++ key_env;
					fx = {|bus, freq| freq};
				}
			};
			if (key.notNil) { 
			// Synth ----------------------------------------------------------------
			SynthDef(key.asSymbol, {|freq=440, bus=0, begin=0, offset|
				var sig, env = SynthDef.wrap(env_func);
				freq = SynthDef.wrap(fx, prependArgs:[bus, freq]);
				sig = SynthDef.wrap(wrap, prependArgs:[sig, freq, begin, env]);
				SynthDef.wrap(out_func, prependArgs:[sig, env, bus]);
			}).add;
		}
	} 
}
};

// Synths ---------------------------------------------------------------------

SynthDef(\kalimba, {|out=0, o=0, j=0, freq=440, atk=0.01, sustain=15, curve=(-4), gate=1, pan=0, a=1|
	var sig, env = EnvGen.ar(Env.asr(atk, 1, sustain * Rand(3.0, 4.0), curve:curve), gate:gate, doneAction: 2);
	sig = VarSaw.ar(freq);
	sig = HPF.ar(LPF.ar(sig, 380), 120);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan, a) * env);
}).add;

SynthDef(\pad, {
	|out=0, o=0, j=0, freq=440, diss=0.01, atk=0.01, sustain=15, curve=(-4), gate=1, pan=0, a=1|
  var env, sig, fmod, rqmod;
  env = EnvGen.ar(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction:2);
  freq = {freq * LFNoise2.ar(1, mul:diss, add:1)}!12;
  sig = LFSaw.ar(freq);
  fmod = SinOsc.kr(1/12).range(1, 2);
  rqmod = LFNoise2.kr(1/8).range(0.1, 1.0);
  sig = RLPF.ar(sig, freq * fmod, rqmod) * env;
	Out.ar(Select.kr(j > 0, [o, out]), Splay.ar(sig, 1, center:pan) * a);
}).add; 

~synthdef_factor.value(\chicago, {|sig, freq, begin, env|
	var freq_a;
	freq_a = [freq, freq+1, freq-1, freq*3/2, freq*1/2];
	sig = SawDPW.ar(freq_a, begin) + VarSaw.ar(freq_a, begin);
	sig;
});

~synthdef_factor.value(\reed, {|sig, freq, begin, env, disintegration=0.99,
	ftremolo=1, tremolo=0.05, lo=2000, hi=2442, rq=0.1, fdb=1200, db=3|
	sig = Pulse.ar((Rand(-0.03, 0.05) + freq.cpsmidi).midicps, 0.48 + LFNoise1.kr(0.06, 0.1));
	sig = Disintegrator.ar(sig, 0.5, disintegration);
	sig = sig * LFNoise2.kr(ftremolo, mul:tremolo, add:1);
	sig = sig + BPF.ar(sig, env.linexp(0, 1, lo, hi), rq);
	sig = BHiShelf.ar(sig, fdb, 1, db);
	sig;
});

SynthDef(\acid, {
	|out=0, o=0, j=0, freq=1000, width=0.05, cut=4000, rq=0.8, atk=0.02, 
	sustain=15, rel=0.3, curve=\lin, gate=1, pan=0, a=1|
	var sig, env;
	env = EnvGen.kr(Env.linen(atk, sustain, rel, curve:curve), gate, doneAction:2);
	sig = Pulse.ar(freq, width);
	sig = RLPF.ar(sig, cut, rq);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan, a) * env);
}).add;

SynthDef(\pluck, {
	|out=0, o=0, j=0, freq=440, diss=0.01, dampen=0.5, ftrig=0, atk=0.01, sustain=15, curve=(-4), gate=1, pan=0, a=1|
	var sig, delay, env = EnvGen.kr(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction:2);
	delay = {freq.reciprocal * LFNoise2.ar(1, mul:diss, add:1)};
	sig = Pluck.ar(BrownNoise.ar, Impulse.kr(ftrig), 0.1, delay, sustain, coef:dampen) * env;
	Out.ar(Select.kr(j > 0, [o, out]), Splay.ar(sig, 1, center:pan) * a);
}).add;

// http://www.fredrikolofsson.com/f0blog/?q=node/442
SynthDef(\frederik, {
	|out=0, o=0, j=0, t_trig=1, freq=200, atk=0.005, sustain=0.5, curve=(-3), pmod_amp=0.5, pan=0, a=1|
	var sig, pmod, env = EnvGen.kr(
		Env.perc(atk, sustain, curve:curve),
		gate:t_trig
	);
	pmod = LFSaw.ar(
		freq * 2.pow(TIRand.kr(1.0, 3.0, t_trig)), // TIRand generates integer
		0,
		env * pmod_amp // largest modulation at the beginning
	);
	sig = SinOsc.ar(freq, pmod); // phase modulation makes sound more metalic
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

// FM

SynthDef(\fm, {
	|out=0, o=0, j=0, freq=440, atk=0.01, sustain=15, curve=(-4), 
	cr=1, mr=1, ind=1, ind_mul=5, gate=1, pan=0, a=1, limit=1|
	var sig, mod, mod_env, env=EnvGen.kr(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction: 2);
	mod_env = EnvGen.ar(Env([ind, ind * ind_mul, ind], [atk, sustain], curve));
	mod = SinOsc.ar(freq * mr, mul:freq * mr * mod_env);
	sig = SinOsc.ar(freq * cr + mod);
	sig = LeakDC.ar(sig);
	// sig = Limiter.ar(sig, limit) * limit.reciprocal * 2;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

// https://github.com/alikthename/Musical-Design-in-Supercollider/blob/master/fm_Nmods-1car.sc
SynthDef(\fm3, {|out=0, o=0, j=0, gate=1, freq=100, cr=1, mr1=2, mr2=2, mr3=4, 
	ind1=1, ind2=0.6, ind3=0.3, ind_mul=0.7, atk=0.015, sustain=4, curve=(-4), 
	coef=0.8, mid_eq_ratio=5, mid_eq_db=0.025, rq=3.5, a=1|
	var sig, env, mod1, mod2, mod3;
	env = EnvGen.kr(
		Env.perc(Rand(0.8, 1.2) * atk, sustain, curve:curve),
		// https://scsynth.org/t/failure-in-server-n-set-node-5862-not-found/482
		// because of the event assumes it should be used to finish the note, so it tries setting “gate” to zero on a Synth node that is already completed and freed
		// gate:gate,
		doneAction:2
	) * ind_mul;
	env = env * PinkNoise.ar(1!2).range(0.1, 1).lag(0.01).range(0.9, 1);
	freq = freq.clip(1, 19999);
	mod1 = SinOsc.ar(
		freq * mr1 + {Rand(-3, 3)}!2,
		mul:freq * ind1 * env.pow(0.8)
	);
	mod2 = SinOsc.ar(
		freq * mr2 + {Rand(-3,3)}!2,
		mul:freq * ind2 * env.pow(1.4)
	);
	mod3 = SinOsc.ar(
		freq * mr3 + {Rand(-3,3)}!2,
		mul:freq * ind3 * env.pow(2.5)
	);
	sig = SinOsc.ar(
		freq * cr
		+ [mod1, mod2, mod3].sum 
		+ LFTri.ar(env.pow(0.5) * LFNoise1.kr(0.3).range(1, 5), Rand(0, 2pi), mul:env.pow(0.2) * freq * 0.005)
		+ WhiteNoise.ar(freq/8!2).lag(0.001) 
	);
	sig = HPF.ar(sig * env.pow(0.5), freq);
	sig = MidEQ.ar(sig, (freq * mid_eq_ratio).clip(1, 19999), rq:env.pow(0.5) + 0.1, db:mid_eq_db.ampdb);
	sig = OnePole.ar(sig, coef);
	sig = LeakDC.ar(sig);
	// linen removes clicks on low frequencies
	Out.ar(Select.kr(j > 0, [o, out]), sig * Env.linen(atk*1.2, 0, sustain).ar * a);
}).add;

// https://sccode.org/1-57S
SynthDef(\fmbell, {|out=0, o=0, j=0, freq=440, atk=0.01, sustain=15, curve=(-4), gate=1, pan=0, a=1|
	var sig, env = EnvGen.kr(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction:2);
	freq = freq * EnvGen.kr(Env([1, 1.002, 0.998, 1],[0.1, 0.8]));
	sig = SinOsc.ar(freq + 0.13);
	sig = SinOsc.ar(
		(sig * freq * [1, 0.9998, 2.6629, 0.9991, 2.6656, 1]) + [0, 1, 2.04, 2.14, -2, 1.84],
		{Rand(0, 2pi)}!6
	);
	sig = Mix(sig);
	sig = LeakDC.ar(sig);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

// Granular && FM

SynthDef(\gran, {|out=0, o=0, j=0, freq=440, sustain=1, gate=1, pan=0, a=1|
	var sig, env = EnvGen.ar(Env.sine(sustain), gate:gate, doneAction:2);
	sig = FSinOsc.ar(freq);
	OffsetOut.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

// https://github.com/alikthename/Musical-Design-in-Supercollider/blob/master/sin_pulsar.sc
SynthDef(\sin_pulsar, {
	|out=0, o=0, j=0, freq=440, sustain=1, t_trig=1, pan=0, a=1, 
	formant_a=2, formant_b=6, overlap_a=2, overlap_b=2, pregain=0.3|
	var sig_a, sig_b, sig, env, f_, reverb;
	f_ = freq.clip(50, 1500);
	env = EnvGen.kr(Env.perc(f_.linlin( 50, 1500, 0.1, 0.02), sustain * Rand(1,7)), t_trig);
	env = env * PinkNoise.ar(1!2).range(0.1, 1).lag(0.02);
	sig = GrainSin.ar(1, 
		Impulse.ar(freq), 
		1.5  * ( 0.05 + env.pow(0.5) ) * SinOsc.ar(env * 6, {Rand(0, 6.28)}.dup).range(0.87,1.15) / freq,
		freq * SinOsc.ar(env * 8, {Rand(0, 6.28)}.dup).range(0.9,Rand(1,1.5)),
		pan: PinkNoise.ar(0.5!2), 
	);
	sig_a = GrainSin.ar(1, 
		Impulse.ar(freq), 
		overlap_a * ( 0.05 + env.pow(0.5) ) * SinOsc.ar(env * 6, {Rand(0, 6.28)}.dup).range(0.87,1.15) / freq, 
		formant_a  * SinOsc.ar(7 * env, {Rand(0, 6.28)}.dup).range(0.9,1.1) * freq,
		pan: PinkNoise.ar(0.5!2),
	);
	sig_b = GrainSin.ar(1, 
		Impulse.ar(freq + Rand(-3,3)), 
		overlap_b * ( 0.05 + env.pow(0.5) ) * SinOsc.ar(env * 6, {Rand(0, 6.28)}.dup).range(0.87,1.15) / freq,
		formant_b * SinOsc.ar(env * 8, {Rand(0, 6.28)}.dup).range(0.9,Rand(1,1.5)) * freq,
		pan: PinkNoise.ar(0.5!2), 
	);
	sig = Mix([
		sig * ( pregain * env ).pow(0.7),
		sig_a * ( pregain * env ).pow(f_.linlin( 50, 1500, 1.1, 1.5)),
		sig_b * ( pregain * env ).pow(f_.linlin( 50, 1500, 1.5, 2.5)),
	]);
	sig = LeakDC.ar(sig);
	// reverb = sig;	
	// 4.do {|i|
	// 	reverb = AllpassC.ar(reverb, 0.04, LFNoise1.kr(0.2!2).range(0.01,0.02))
	// };
	// sig = sig * Rand(0.1, 0.6) + reverb; 	
	// DetectSilence.ar(sig, doneAction:da);
	FreeSelf.kr(DetectSilence.ar(sig + Impulse.ar(0)).product);
	Out.ar(out, sig)
}).add; 

// Bass/Beat alike

(
dklank:{|rel, da=2, t_trig=1, atk=0.01, sustain=15, curve=(-4)|
EnvGen.kr(Env.perc(atk, rel, curve:curve), gate:t_trig, doneAction:da)},
dklankes:{|rel, da=2, t_trig=1, sustain=15|
	EnvGen.kr(Env.sine(rel), gate:t_trig, doneAction:da)}, 
).keysValuesDo {|key, env_func|
	SynthDef(key, {
		|out=0, o=0, j=0, noise=1, rel=0.2, f=100, flo=420, fhi=780, pan=0, a=1|
		var sig = Select.ar(noise, [BrownNoise.ar(1), WhiteNoise.ar(1)]);
		sig = DynKlank.ar(`[
			[f*ExpRand(0.97, 1.02), 8*f*ExpRand(0.97, 1.02), 13*f*ExpRand(0.97, 1.02)],
			[0.4, 1, 0.5].normalizeSum,
			[rel, rel*0.1, rel*0.12] // ring times
		], 
		sig);
		sig = HPF.ar(LPF.ar(sig, fhi), flo);
		sig = sig * SynthDef.wrap(env_func, prependArgs:[rel]);
		Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
	}).add
};

(
b:{|rel, t_trig, da=2, atk=0.01, sustain=15, curve=(-4)|
	EnvGen.kr(Env.perc(atk, rel, curve:curve), gate:t_trig, doneAction:da)},
bes:{|rel, t_trig, da=2, sustain=15|
	EnvGen.kr(Env.sine(rel), gate:t_trig, doneAction:da)}, 
).keysValuesDo {|key, env_func|
	SynthDef(key, {
		|out=0, o=0, j=0, t_trig=1, f=500, fbase=50, rel=0.5, swatk=0.005, swrel=0.1, pan=0, a=1|
		var sig = SinOsc.ar(
			EnvGen.kr(
				Env([f, f-fbase*0.275+fbase, fbase], [swatk, swrel]),
				gate:t_trig
			)
		);
		sig = sig * SynthDef.wrap(env_func, prependArgs:[rel, t_trig]);
		Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
	}).add
};

(
sn0:{|rel, t_trig, da=2, atk=0.01, sustain=15, curve=(-4)|
EnvGen.kr(Env.perc(atk, rel, curve:curve), gate:t_trig, doneAction:da)},
sn0es:{|rel, t_trig, da=2, sustain=15|
	EnvGen.kr(Env.sine(rel), gate:t_trig, doneAction:da)}, 
).keysValuesDo {|key, env_func|
	SynthDef(key, {|out=0, o=0, j=0, t_trig=1, f=2000, noise=1, rq=3, rel=0.2, pan=0, a=1|
		var sig;
		sig = Select.ar(noise, [BrownNoise.ar(1), WhiteNoise.ar(1)]);
		sig = BPF.ar(sig, f, rq);
		sig = sig * SynthDef.wrap(env_func, prependArgs:[rel, t_trig]);
		Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
	}).add
};

// https://blog.rumblesan.com/post/53271713518/drum-sounds-in-supercollider-part-1
SynthDef(\sn1, {|out=0, o=0, j=0, f=60, bass_mul=1, flpf=1500, bass_rel=1, 
	sn_mul=1, sn_rel=0.02, coef=0.9, atk=0.01, curve=(-4), pan=0, a=1|
	var sig, bass, sn;
	bass = SinOsc.ar(f) * Line.kr(1, 0, bass_rel, doneAction:2) * bass_mul;
	sn = LPF.ar(OnePole.ar(BrownNoise.ar(1), coef:coef), flpf) * Line.kr(1, 0, sn_rel) * sn_mul; 
	sig = XFade2.ar(sn, bass, Env.perc(atk, bass_rel, curve:curve).range(-1, 1).ar);
	// sig = LeakDC.ar(sig);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

(
hat:{|rel, t_trig, da=2, atk=0.01, sustain=15, curve=(-4)|
Line.kr(1, 0, rel, doneAction:da)},
hatep:{|rel, t_trig, da=2, atk=0.01, sustain=15, curve=(-4)|
EnvGen.kr(Env.perc(atk, rel, curve:curve), gate:t_trig, doneAction:da)},
hates:{|rel, t_trig, da=2, sustain=15|
	EnvGen.kr(Env.sine(rel), gate:t_trig, doneAction:da)}, 
).keysValuesDo {|key, env_func|
	SynthDef(key, {|out=0, o=0, j=0, t_trig=1, noise=1, flo=2000, fhi=6000, rel=0.3, pan=0, a=1|
		var sig;
		sig = Select.ar(noise, [BrownNoise.ar(1), WhiteNoise.ar(1)]);
		sig = HPF.ar(LPF.ar(sig, fhi), flo);
		sig = sig * SynthDef.wrap(env_func, prependArgs:[rel, t_trig]);
		Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
	}).add
};

// https://blog.rumblesan.com/post/53271713909/drum-sounds-in-supercollider-part-2
SynthDef(\psn, {
	|out=0, o=0, j=0, f=100, noise=1, flo=500, fmid=1500, rq=1, pulse_rel=1, sn_mul=1, sn_rel=0.6, pan=0, a=1|
	var sig, pulse, sn;
	pulse = Pulse.ar(f) * Line.ar(1, 0, pulse_rel, doneAction:2);
	pulse = LPF.ar(pulse, Line.ar(1000, 30, pulse_rel));
	sn = Select.ar(noise, [BrownNoise.ar(sn_mul), WhiteNoise.ar(sn_mul)]);
	sn = BPF.ar(HPF.ar(sn, flo), fmid, rq) * Line.ar(1, 0, sn_rel);
	sig = pulse + sn;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

// A clap is like snare chorus
SynthDef(\cp0, {|out=0, o=0, j=0, f=100, noise=1, rel=0.6, flo=1500, fhi=7500, pan=0, a=1|
	var sig, env = Line.kr(1, 0, rel+0.07, doneAction: 2);
	sig = Select.ar(noise, [BrownNoise.ar(1), WhiteNoise.ar(1)]);
	sig = BPF.ar(LPF.ar(sig, fhi), flo);
	sig = sig * EnvGen.kr(
		Env(
			[0, 0, 1, 0],
			[0.01 * (0..6), 0, rel] // delay imitation
		)
	);
	sig = Mix(sig);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

// http://sccode.org/1-57f
SynthDef(\neurosn, {|out=0, o=0, j=0, f=100, rel=0.6, flo=300, fhi=7500, pan=0, a=1|
	var sig;
	// a percussive click to give it some attack
	sig = LPF.ar(HPF.ar(WhiteNoise.ar(1), flo), fhi) * Env.linen(0.001, 0.01, 0.001).ar;
	// sine sweep body. very important!
	sig = sig + (SinOsc.ar(Env([400, 196, 160], [0.04, rel], \exp).ar) * Env.perc(0.04, 0.2).ar * 2).tanh;
	// sound of snare coils rattling
	sig = sig + (HPF.ar(
		BPeakEQ.ar(WhiteNoise.ar, 4000, 0.5, 3),
		300
	) * EnvGen.ar(Env.perc(0.05, rel).delay(0.01), doneAction:2) * 0.7);
	// another sound sweep to improve the attack, optional
	sig = sig + (SinOsc.ar(XLine.kr(3000, 1500, 0.01)) * Env.perc(0.001, 0.02).ar);
	// distortion helps glue everything together and acts as a compressor
	sig = (sig * 1.4).tanh;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

// https://www.local-guru.net/blog/2018/2/10/SuperCollider-drumsample-generator
SynthDef(\bd, {|out=0, o=0, j=0, noise=1, rel=0.3, sn_fhi=100, sn_flo=10, 
	sn_mul=0.8, sn_sw_rel=0.02, b_fhi=110, b_flo=1, b_sw_rel=0.1, pan=0, a=1|
	var sig, sn, bass, env = Line.kr(0.9, 0, rel, doneAction:2);
	sn = Select.ar(noise, [BrownNoise.ar(1), WhiteNoise.ar(1)]);
	sn = BBandPass.ar(sn, Line.kr(sn_fhi, sn_flo, sn_sw_rel)) * Line.kr(1, 0, sn_sw_rel) * sn_mul;
	bass = SinOsc.ar(Line.kr(b_fhi, b_flo, b_sw_rel));
	sig = sn + bass;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

SynthDef(\cp, {
	|out=0, o=0, j=0, f=2000, noise=1, lo=0.001, hi=0.1, rel=0.1, curve=\exp, pan=0, a=1|
	var sig, env = Env([0, 0, 1, 0], [{Rand(lo, hi)}.dup(15), 0.001, rel], curve).kr;
	Line.kr(0, 1, hi + rel + 0.001, doneAction:2); // dummy env
	env = Mix(env);
	sig = Select.ar(noise, [BrownNoise.ar(1), PinkNoise.ar(1)]);
	sig = BHiPass.ar(sig, 2000);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

SynthDef(\cr, {
	|out=0, o=0, j=0, noise=1, f=1000, flo=100, fhi=2784, 
	atk=0.01, rel=0.6, sn_rel=0.01, sn_mul=0.7, pan=0, a=1|
	var sig, env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	sig = Mix.fill(12, {|i| Pulse.ar(Rand(flo, fhi))}) * 0.1;
	// sig = BHiPass4.ar(sig, f);
	sig = MoogFF.ar(sig, f, 3.9);
	sig = sig + (
		Select.ar(
			noise,
			[BrownNoise.ar(1), PinkNoise.ar(1)]
		) * Env.perc(atk, sn_rel, sn_mul).kr
	);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

SynthDef(\ding, {|out=0, o=0, j=0, flo=100, fhi=2784, noise=1, 
	atk=0.01, rel=0.6, sn_rel=0.01, sn_mul=0.7, pan=0, a=1|
	var sig, env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	sig = Mix.fill(7, {|i| SinOsc.ar(Rand(flo, fhi))}) * 0.2;
	sig = sig + (Select.ar(
		noise,
		[BrownNoise.ar(1), PinkNoise.ar(1)]
	) * Env.perc(atk, sn_rel, sn_mul).kr);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

SynthDef(\hh, {|out=0, o=0, j=0, noise=1, f=10000, rq=0.2, atk=0.01, rel=0.6, pan=0, a=1|
	var sig, env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	sig = Select.ar(noise, [BrownNoise.ar(1), PinkNoise.ar(1)]);
	sig = BBandPass.ar(sig, f, rq);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

SynthDef(\sn, {
	|out=0, o=0, j=0, noise=1, b_sw_hi=6000, b_sw_lo=60, b_mul=0.7, 
	curve=\exp, b_rel=0.11, sn_mul=0.8, sn_rel=0.3, pan=0, a=1|
	var sn, bass, sig;
	bass = SinOsc.ar(
		Env([b_sw_hi, 410, b_sw_lo], [0.005, 0.01], curve).kr
	) * Env.perc(0.001, b_rel, b_mul).kr;
	sn = Select.ar(noise, [BrownNoise.ar(1), PinkNoise.ar(1)]);
	sn = sn * EnvGen.kr(Env.perc(0.01, sn_rel, sn_mul), doneAction:2);
	sig = sn + bass;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

SynthDef(\tom, {
	|out=0, o=0, j=0, noise=1, b_sw_hi=300, b_sw_lo=60, b_mul=0.7, b_rel=0.11, 
	sn_mul=1, sn_rel=0.3, lag=0.001, gain=3, f=3000, pregain=1, diss=0.01, pan=0, a=1|
	var sn, bass, sig;
	bass = SinOsc.ar(
		Env.perc(0.01, b_rel, (b_sw_hi - b_sw_lo) * {LFNoise1.ar(10, mul:diss, add:1)}!3).kr;
	) * Env.perc(0.001, b_rel, b_mul).kr;
	sn = Select.ar(noise, [BrownNoise.ar(1), PinkNoise.ar(1)]);
	sn = sn * EnvGen.kr(Env.perc(0.01, sn_rel, sn_mul), doneAction:2);
	sig = sn + bass;
	sig = MoogFF.ar(sig, f, gain);
	sig = sig.lag(lag);
	sig = (sig*pregain).softclip;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

SynthDef(\dc, {|out=0, o=0, j=0, noise=0, f=5000, rq=1, ftrig=0, decay=0.2, pan=0, a=1|
	var sig;
	sig = Select.ar(noise, [BrownNoise.ar(1), PinkNoise.ar(1)]);
	sig = Decay2.ar(Impulse.ar(ftrig), 0.01, decay, sig);
	sig = RLPF.ar(sig, f, rq:rq);
	DetectSilence.ar(sig, doneAction:2);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

// Buffers/samples ------------------------------------------------------------

// Assumes every sample is 44100 rate
// mono or stero
(1..2).do {|numChannels|
	// various envelopes
	(
	bp:{|atk=0, sustain=15, rel=0, curve=\lin, da=2|
		EnvGen.kr(Env.linen(atk, sustain, curve:curve), gate: 1, doneAction: da)},
	bpes:{|sustain=15, da=2|
		EnvGen.kr(Env.sine(sustain), gate: 1, doneAction: da)}, 
	bpet:{|sustain=15, da=2|
		EnvGen.kr(Env.triangle(sustain), gate: 1, doneAction: da)}, 
	bpep:{|atk=0, sustain=15, curve=(-4), da=2|
		EnvGen.kr(Env.perc(atk, sustain, curve:curve), gate: 1, doneAction: da)}
	).keysValuesDo { |key, env_func|
		if (numChannels == 2) {
			key = (key ++ 2).asSymbol;
		};
		SynthDef(key, {|out=0, o=0, j=0, buf=0, rate=1, a=1, pan=0, pos=0, tfreq=0|
			var sig;
			sig = PlayBuf.ar(
				numChannels,
				buf,
				rate * BufRateScale.kr(buf),
				Impulse.kr(tfreq),
				startPos: pos * BufDur.kr(buf) * SampleRate.ir
			);
			sig = sig * SynthDef.wrap(env_func) * a;
			Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan))
		}).add
	}
};

SynthDef(\bg, {|out=0, o=0, j=0, atk=0.01, sustain=15, rel=0.1, curve=\lin, gate=1, 
	pan=0, a=1, sync=1, tfreq=20, gdur=0.1, gdur_rand=0, buf=0, rate=1, 
	pos=0, pos_speed=1, pos_rand=0, genv=(-1), pan_freq=0.1, pan_rand=0|
	var sig, env, dens;
	env = EnvGen.kr(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction: 2);
	dens = Select.ar(sync, [Dust.ar(tfreq), Impulse.ar(tfreq)]);
	gdur = gdur + LFNoise1.kr(100, mul:gdur_rand);
	pos = Phasor.ar(
		0,
		pos_speed * BufRateScale.kr(buf),
		pos*BufSamples.kr(buf),
		BufSamples.kr(buf) - 1
	);
	pos = pos + LFNoise1.kr(100).bipolar(pos_rand * SampleRate.ir);
	pos = pos / BufSamples.kr(buf);
	pan = pan + LFNoise1.kr(pan_freq).bipolar(pan_rand);
	sig = GrainBuf.ar(2, dens, gdur, buf, rate, pos, 2, pan, genv);
	Out.ar(Select.kr(j > 0, [o, out]), sig * env * a);
}).add;

// https://www.youtube.com/watch?v=WLV4Rx6YhSY
SynthDef(\lfd, {|out=0, o=0, j=0, f=5000, atk=0.01, rel=0.1, curve=(-4), pan=0, a=1|
	var sig, env;
	env = EnvGen.kr(Env.perc(atk, rel, curve:curve), doneAction:2);
	sig = LFNoise2.ar(f) * env;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

SynthDef(\cd, {|out=0, o=0, j=0, c=1.5, f=5000, atk=0.01, rel=0.1, curve=(-4), pan=0, a=1|
	var sig, env;
	env = EnvGen.kr(Env.perc(atk, rel, curve:curve), doneAction:2);
	sig = Crackle.ar(c) * env;
	sig = LPF.ar(sig, f);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

SynthDef(\cd1, {|out=0, o=0, j=0, c=3.8, f=5000, atk=0.01, rel=0.1, curve=(-4), pan=0, a=1|
	var sig, env;
	env = EnvGen.kr(Env.perc(atk, rel, curve:curve), doneAction:2);
	sig = Logistic.ar(c, f) * env;
	sig = MoogFF.ar(sig, f, gain:3.9);
	sig = sig * LFNoise1.ar(f).lag(0.001);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

// http://www.mcld.co.uk/cymbalsynthesis/
SynthDef(\cy, {|out=0, o=0, j=0, n=99, f=300, atk=0.5, rel=5, curve=(-4), decay=1, pan=0, a=1|
	var sig, sig_low, sig_hi, thwack, freqs, env;
	sig_low = LPF.ar(
		WhiteNoise.ar(0.1),
		EnvGen.ar(Env.perc(atk, rel), doneAction:2) * 20000 + 10
	);
	sig_hi = HPF.ar(
		WhiteNoise.ar(0.1),
		10001 - (Env.perc(atk*2, rel*0.6).ar * 10000)
	) * Env.perc(atk*2, rel*0.4, 0.25).ar;
	thwack = Env.perc(0.001, 0.001, 1).ar;
	// freqs = {exprand(f, 20000)}.dup(100); // a bug
	// sadly not possible to modulate array argument
	freqs = {ExpRand(f, 20000)}.dup(100);
	sig = Ringz.ar(
		sig_low + sig_hi + thwack,
		freqs,
		decay
	).mean;
	sig = sig + (sig_low * 2) + thwack;
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * a);
}).add;

// Physical models ------------------------------------------------------------

SynthDef(\piano, {|out=0, o=0, j=0, freq=440, atk=0.01, sustain=15, rel=0.1, curve=\lin, gate=1, pan=0, a=1|
	var sig, env = EnvGen.kr(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction: 2);
	sig = OteyPiano.ar(freq);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

// https://doc.sccode.org/Classes/StkInst.html
// "VoicForm", "FMVoices", "Clarinet", "BlowHole", "Saxofony" ...
SynthDef(\bow, {
	|out=0, o=0, j=0, f=220, atk=0.01, sustain=15, curve=\lin, gate=1, pan=0, a=1, 
	bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128|
	var sig, env = EnvGen.kr(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction:2);
	sig = StkInst.ar(Stk.at("Bowed"), f, gate, onamp:a, offamp:0.5, 
	args:[ 2, bowpressure, 4, bowposition, 11, vibfreq, 1, vibgain, 128, loudness ]);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

SynthDef(\voice, {|out=0, o=0, j=0, freq=100, atk=0.01, sustain=15, curve=\lin, 
	gate=1, pan=0, a=1, be=0.5, bi=0.5, bo=0.5, bu=0.5 bright=0|
	var sig, va = Vowel(\a, \bass), ve = Vowel(\e, \tenor), vi = Vowel(\i, \counterTenor),
	vo = Vowel(\o, \alto), vu = Vowel(\u, \soprano),
	env = EnvGen.kr(Env.asr(atk, 1, sustain, curve:curve), gate:gate, doneAction:2);
	sig =  Formants.ar(
		freq, va .blend(ve, be).blend(vi, bi).blend(vo, bo).blend(vu, bu).brightenExp(bright, 1) 
	); 
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan) * env * a);
}).add;

// https://github.com/musikinformatik/SuperDirt/blob/develop/library/default-synths-extra.scd
SynthDef(\supermandolin, {|out=0, o=0, j=0, freq=440, sustain=1, curve=(-3), accelerate=0, detune=0.2, pan=0, a=1|
	var sig, env, pitch;
	env = EnvGen.ar(
		Env.linen(0.002, 0.996, 0.002, curve:curve),
		timeScale:sustain, // durations of segments are multiplied by this value
		doneAction:2
	);
	sig = Decay.ar(
		Impulse.ar(0, 0, 0.1),
		freq/440 * 0.1
	) * WhiteNoise.ar(1);
	pitch = freq * Line.kr(1, 1+accelerate, sustain); // Similar to sweep
	sig = CombL.ar(sig, 0.05, pitch.reciprocal*(1-(detune/100)), sustain)
	+ CombL.ar(sig, 0.05, pitch.reciprocal*(1+(detune/100)), sustain);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, pan, a) * env);
}).add;

// Effects --------------------------------------------------------------------

SynthDef(\chorus, {
	|out=0, o=0, j=0, in=0, f=1, delay=0.1, phase_step=0.1, delay_depth=0.001, 
	wet=0.4, sustain=15, curve=\lin, gate=1, pan=0, a=1|
	var sig, mod, n=12, env=EnvGen.kr(Env.cutoff(sustain*10, curve:curve), gate:gate, doneAction: 2);
	sig = In.ar(in, 2);
	mod = Array.fill(n, {|i|
		LFPar.ar(f * Rand(0.99, 1.01), phase_step * i, mul:delay_depth, add:delay);
	}); 
	sig = XFade2.ar(
		sig, 
		Mix(DelayC.ar(sig, mod*4, mod)), 
		wet.linlin(0, 1, -1, 1),
		env
	);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

SynthDef(\distort, {
	|out=0, o=0, j=0, in=0, pregain=10, wet=0.5, sustain=15, curve=\lin, gate=1, a=1|
	var sig, env=EnvGen.kr(Env.cutoff(sustain, curve:curve), gate:gate, doneAction: 2);
	sig = In.ar(in, 2);
	sig = XFade2.ar(sig, (sig * pregain).distort, wet.linlin(0, 1, -1, 1), env);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

SynthDef(\echo, {
	|out=0, o=0, j=0, in=0, delay=0.2, decay=2, wet=1, depth=1, sustain=15, curve=\lin, gate=1, a=1|
	var sig, maxdelay=delay+0.01, env=EnvGen.kr(Env.cutoff(sustain*10, curve:curve), gate:gate, doneAction: 2);
	sig = In.ar(in, 2);
	sig = XFade2.ar(
		sig, 
		CombL.ar(sig, maxdelay, delay, decay, mul:1, add:sig), 
		// [delay1, delay2]
		wet.linlin(0, 1, -1, 1),
		env
	);
	// sig = Clip.ar(sig*depth, -1, 1); // similar to distort. Should use independently
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

SynthDef(\wah, {
	|out=0, o=0, j=0, in=0, wet=1, f=1, sustain=15, curve=\lin, lo=200, hi=8000, rq=0.1, gate=1, a=1|
	var sig, env=EnvGen.kr(Env.cutoff(sustain, curve:curve), gate:gate, doneAction: 2);
	sig = In.ar(in, 2);
	sig = XFade2.ar(
		sig, 
		RLPF.ar(sig, LinExp.kr(LFNoise2.kr(f), -1, 1, lo, hi), rq), // adding .sofclip makes like 2 effects in one
		wet.linlin(0, 1, -1, 1),
		env
	);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

SynthDef(\tremolo, {
	|out=0, o=0, j=0, in=0, f=10, depth=1, wet=1, sustain=15, curve=\lin, gate=1, a=1|
	var sig, env=EnvGen.kr(Env.cutoff(sustain, curve:curve), gate:gate, doneAction: 2);
	sig = In.ar(in, 2);
	sig = XFade2.ar(
		sig, 
		sig * SinOsc.ar(f, mul:depth).range(0, 1), 
		wet.linlin(0, 1, -1, 1),
		env
	);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

SynthDef(\moog, {
	|out=0, o=0, j=0, in=0, f=2000, gain=2, wet=1, atk=0.01, sustain=15, curve=\lin, gate=1, a=1|
   var sig, env=EnvGen.kr(Env.cutoff(sustain, curve:curve), gate:gate, doneAction: 2);
   sig = In.ar(in, 2);
	 sig = XFade2.ar(
		 sig, 
		 MoogFF.ar(sig, f, gain), 
		 wet.linlin(0, 1, -1, 1),
		 env
	 );
	 Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

SynthDef(\reverb, {
	|out=0, o=0, j=0, in=0, mix=0.33, room=0.5, damp=0.5, wet=1, sustain=15, curve=\lin, gate=1, a=1|
	 var sig, env=EnvGen.kr(Env.cutoff(sustain*10, curve:curve), gate:gate, doneAction: 2);
	 sig = In.ar(in, 2);
	 sig = XFade2.ar(
		 sig, 
		 FreeVerb.ar(sig, mix, room, damp), 
		 wet.linlin(0, 1, -1, 1), 
		 env
	 );
	 Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

// https://github.com/alikthename/Musical-Design-in-Supercollider/blob/master/fm_pulsar.sc
SynthDef(\reverb1, {
	|out=0, o=0, j=0, in=0, sustain=15, curve=\lin, gate=1, a=1|
	var dry, sig, env, n=8;
	env = EnvGen.kr(
		Env.cutoff(sustain*10, curve:curve),
		gate:gate,
		doneAction: 2
	);
	dry = In.ar(in, 2);
	sig = dry;
	n.collect {|i|
		sig = AllpassC.ar(
			sig, 
			0.2,
			LFNoise1.kr(0.03!2).range(0.01, 0.02 * (i+1)),
			decaytime: (n / 2 -i).abs + 0.1
			// i+1 
		).tanh
	}.mean;
	sig = Mix([ 
		in * LFNoise1.kr(3).range(0,1),
		sig * 0.5
	]);
	sig = LeakDC.ar(sig);
	Out.ar(Select.kr(j > 0, [o, out]), Pan2.ar(sig, 0, a));
}).add;

SynthDef(\crush, {
	|out=0, o=0, j=0, in=0, rate=1, bits=6, wet=1, sustain=15, curve=\lin, gate=1, a=1|
	var sig, env=EnvGen.kr(Env.cutoff(sustain, curve:curve), gate:gate, doneAction: 2);
	sig = In.ar(in, 2);
	sig = XFade2.ar(
		sig, 
		Decimator.ar(sig, SampleRate.ir * rate, bits), // SmoothDecimator pops at the beginning
		wet.linlin(0, 1, -1, 1),
		env
	);
	Out.ar(Select.kr(j > 0, [o, out]), sig);
}).add;
