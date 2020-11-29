// Global settings

// Settings inspired/reflecting Tidal Cycles (SuperDirt) and FoxDot
// Using my own setup functions instead of SuperDirt.start/FoxDot.start

s.options.memSize = 8192 * 128; // increase memory to 512 Mb
s.options.sampleRate = 48000;
s.options.numAudioBusChannels = 1024 * 10;
s.volume.volume = -10; // default volume
s.options.numRGens = 64; // n of seedable random number generators
// from SuperDirt
s.options.numBuffers = 1024 * 256; // 1024 default
s.options.numWireBufs = 256;
s.options.maxNodes = 1024 * 32;
s.options.numOutputBusChannels = 2;
// s.options.numOutputBusChannels = 24;
s.options.numInputBusChannels = 2;
s.latency = 0.3;

~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels

~superdirt_start = {
	s.waitForBoot {
		// ~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
		~dirt.loadSoundFiles; // (path containing a wildcard can be passed in)
		// s.sync; // optionally: wait for samples to be read
		~dirt.start(57120, 0!12);
		// ~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12]);
		(
			~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
			~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
			~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);
		// ------
		~b1 = Bus.audio(s, 2); ~b2 = Bus.audio(s, 2); ~b3 = Bus.audio(s, 2);
		~b4 = Bus.audio(s, 2); ~b5 = Bus.audio(s, 2); ~b6 = Bus.audio(s, 2);
		~b7 = Bus.audio(s, 2); ~b8 = Bus.audio(s, 2); ~b9 = Bus.audio(s, 2);
		~b10 = Bus.audio(s, 2); ~b11 = Bus.audio(s, 2); ~b12 = Bus.audio(s, 2);
		~d = [~d1, ~d2, ~d3, ~d4, ~d5, ~d6, ~d7, ~d8, ~d9, ~d10, ~d11, ~d12];
		~b = [~b1, ~b2, ~b3, ~b4, ~b5, ~b6, ~b7, ~b8, ~b9, ~b10, ~b11, ~b12];
		~dirt_orbit_buses = {
			~d.do { |v, i|
				if (v.outBus == 0) { 
					"--- ~d% inactive \n".postf(i+1);
				} {
					"+++ ~d% active \n".postf(i+1);
				}
			};
			nil
		};
		~toggle_dirt_orbit_bus = {|orbit, bus| 
			if (orbit.outBus == 0) { 
				orbit.outBus = bus;
				"activated\n\n".postln;
			} { 
				orbit.outBus = 0;
				"inactivated\n\n".postln;
			};
			~dirt_orbit_buses.();
		};
		~dMix = {|... d| Mix( d.collect {|v| Ndef(("d" ++ v)).stop; InBus.ar(~b[v-1], 2); } ) };
		~superdirt_midi_start = { ~dirt.soundLibrary.addMIDI(\m1, ~m1) };
		// ~dirt_orbit_filter = { |key, orbit, bus| 
			// orbit.outBus = bus;
			// Ndef(key, { var sig = InBus.ar(bus, 2); sig} ).play;
		// };
		// [~d, ~b].flop.do {|v, i|
			// ~dirt_orbit_filter.(("d" ++ (i+1)).asSymbol, v[0], v[1])
		// };
		// ServerTree.add({12.do {|v, i| Ndef(("d" ++ (i+1)).asSymbol).play } }); 
	};
};

~foxdot_start = {
	s.waitForBoot { 
		OSCFunc(
			{
				arg msg, time, addr, port;
				var fn;
				// Get local filename
				fn = msg[1].asString;
				// Print a message to the user
				("Loading SynthDef from" + fn).postln;
				// Add SynthDef to file
				fn = File(fn, "r");
				fn.readAllString.interpret;
				fn.close;
			},
			'foxdot'
		);
		"Listening for messages from FoxDot".postln;
	};
};

~midi_start = {|outports=4|
	// MIDIClient.disposeClient;
	if (MIDIClient.initialized.not) {
		MIDIClient.init(outports:outports);
		~m1 = MIDIOut(0);
		~m1.latency = 0;
		~m2 = MIDIOut(1);
		~m2.latency = 0;
		~m3 = MIDIOut(2);
		~m3.latency = 0;
		~m4 = MIDIOut(3);
		~m4.latency = 0;
	}
};

// Server functions ----------

~make_toggle_mute = {|state=1| 
	{
		if (state==1) { 
			state = 0; 
			s.volume.mute;
			"muted".postln;
		} { 
			state = 1; 
			s.volume.unmute;
			"unmuted".postln;
		};
	}
};

// Sample/buffer functions ----------

~read_dirt_samples = {
	var buf_n, dirs, res;
	Buffer.freeAll;
	res = Event.new(n:2030);
	dirs = PathName("~/sp/Dirt-Samples").entries;
	dirs.do {|v, i| 
		v.entries.do {|path_name| 
			var buf, dir=path_name.folderName.asSymbol, file=path_name.fullPath;
			buf = Buffer.read(s, file);
			if (res.includesKey(dir)) {res[dir].add(buf)} {res[dir] = List[buf]};
		};
	};
	buf_n = res.values.flat.size;
	"% samples with % keys \n".postf(buf_n, res.keys.size);
	res
};

~read_dirt_samples1 = {|dir|
	var entries = (PathName("~/sp/Dirt-Samples") +/+ dir).entries;
	Routine {
		if (d.isNil) { d = ~read_dirt_samples.value() };
		s.sync;
		d[dir.asSymbol] = entries.collect {|path_name, i| 
			var buf, file = path_name.fullPath;
			i.postln;
			buf = Buffer.read(s, file);
			s.sync;
			if (i%10 == 0) { "\\%: %\n".postf(((i/entries.size)*100).round(1)) };
			buf
		};
		"Loaded %\n".postf(dir);
		s.sync;
		~play_samples.value(dir);
	}.play;
};

~play_samples = {|key=nil| 
	var f = {|key| 
		var dur, nc;
		d[key.asSymbol].do({|v|
			try {
				dur = v.duration;
				nc = v.numChannels;
			} {|error|
				dur = 1;
				nc = 1;
			};
			v.postln;
			if (nc == 2) { Synth(\bp2, [\buf, v]) } { Synth(\bp, [\buf, v])};
			(dur+0.25).wait;
		})
	};
	Task {
		if (key == nil) { 
			d.keysDo {|key| 
				postln("the key ---------------------- : " ++ key);
				f.value(key)
			}
		} {
			f.value(key)
		};
	}.play;
};

// Proxy functions ----------
~ndef_settings = {|key=nil, fadeTime=nil, quant=nil, clock=nil| // , reshaping=nil
	var ndef;
	if (key == nil) {ndef = Ndef(\default).proxyspace} {ndef = Ndef(key)};
	if (ndef.fadeTime != fadeTime && fadeTime != nil) {ndef.fadeTime = fadeTime};
	if (ndef.quant != quant && quant != nil) {ndef.quant = quant};
	if (ndef.clock != clock && clock != nil) {ndef.clock = clock} {ndef.clock = TempoClock.default};
	// if (ndef.reshaping != reshaping) {ndef.reshaping = reshaping};
};

~activate_espgrid = {
	Esp.start;
	TempoClock.default = EspClock.new;
	Ndef(\default).proxyspace.clock = TempoClock.default;
	Ndef(\default).proxyspace.quant = 1;
	Esp.clockAdjust = 0.14; // slide synced tempo/metre forward in time
};

~global_tempo = {|bps|
	var clock = Ndef(\default).proxyspace.clock;
	clock.schedAbs(clock.beats.ceil, {
		var tempo = bps;
		clock.tempo = tempo; 
		Ndef(\g_tempo, tempo); 
		nil;
	})
};

// Pattern functions ----------

~ch_returning_pb = {|base ... d| 
	var pb, src, src_pp_dict, synth_name;
	base = base.asSymbol;
	src = Pdef(base).source;
	src_pp_dict = src.patternpairs.asDict;
	if (src.class == Pmono) { 
		if (d.size.odd) { 
			synth_name = d[0];
			d = d[1..];
		} {
			synth_name = src.synthName;
		};
		d.pairsDo({|k, v| src_pp_dict[k] = v });
		pb = Pmono(synth_name, *src_pp_dict.asPairs)
	} {
		d.pairsDo({|k, v| src_pp_dict[k] = v });
		pb = Pbind(*src_pp_dict.asPairs)
		// Composite pattern takes into account previous patterns lengths and can terminate early... 
		// pb = Pbind(*d) <> Pdef(base);
	};
};

~ch = {|base, key ... d| 
	Pdef((base ++ "_" ++ key).asSymbol, ~ch_returning_pb.(base, *d));
};

~ch0 = {|base| 
	{|key ... d|
		Pdef((base ++ "_" ++ key).asSymbol, ~ch_returning_pb.(base, *d));
	}
};

~ch1 = {|base, key ... d| 
	Pdef(key.asSymbol, ~ch_returning_pb.(base, *d));
};

// its broken and useless for now, because ~ch functions copies by default
~cp = {|base, key ... d| 
	var pb, synth_name, src_pp_dict, src;
	base = base.asSymbol; key = key.asSymbol;
	src = Pdef(base).source;
	pb = case
	{ src.class == Pmono } { 
		src_pp_dict = src.patternpairs.asDict;
		if (d.size.odd) { 
			synth_name = d[0];
			d = d[1..];
		} { 
			synth_name = src.synthName;
		};
		d.pairsDo({|k, v| src_pp_dict[k] = v });
		pb = Pmono(synth_name, *src_pp_dict.asPairs);
	}
	{ src.class == Pbind } { 
		Pbind(*d) <> Pbind(*src.patternpairs);
	} {
		nil;
	};
	if (pb != nil) { 
		Pdef(key, pb);
	} { 
		"Only Pbind/Pmono can be copied"
	}
};

~fx_returning_pfx = {|base ... d|
	var pb, src, pre, bus = Bus.audio(s, 2);
	src = Pdef(base.asSymbol).source;
	if (src.class != Pfx) { 
		if (src.class == Pmono) { 
			pb = Pmono(src.synthName, \o, bus) <> Pmono(src.synthName, *src.patternpairs);
		} { 
			pb = Pbind(\o, bus) <> Pdef(base.asSymbol);
		};
		pb = Pfx(pb, d[0].asSymbol, \in, bus,  *d[1..]);
	} { 
		"Error: cannot chain 2 Pfx. Use ~fx0".postln;
		pb = nil;
	};
	pb
};

~fx = {|base ... d|  
	var pb = ~fx_returning_pfx.(base, *d);
	Pdef((base ++ "_" ++ d[0]).asSymbol, pb);
};

~fx0 = {|base| 
	{| ... d|
		var pb = ~fx_returning_pfx.(base, *d);
		if (pb != nil) { 
			Pdef((base ++ "_" ++ d[0]).asSymbol, pb);
		};
	}
};

~fx1 = {|base, key ... d| 
	var pb = ~fx_returning_pfx.(base, *d);
	if (pb != nil) { 
		Pdef(key.asSymbol, pb);
	};
};

~fxa_returning_pfx = {|base ... d|
	var src, b0, b1, pb = Pdef(base.asSymbol), n = d.size;
	if (pb.source.class != Pfx) { 
		b0 = Bus.audio(s, 2);
		src = Pdef(base.asSymbol).source;
		if (src.class == Pmono) {
			pb = Pmono(src.synthName, \o, b0) <> Pmono(src.synthName, src.patternpairs);
		} { 
			pb = Pbind(\o, b0) <> Pdef(base.asSymbol);
		};
		b1 = Bus.audio(s, 2);
		d[..d.size-2].do {|v, i|
			pb = Pfx(pb, v[0].asSymbol, \in, b0, \o, b1, *v[1..]);
			b0 = b1;
			b1 = Bus.audio(s, 2);
			base = base ++ "_" ++ v[0];
		};
		base = (base ++ "_" ++ d[n-1][0]).asSymbol;
		pb = [base, Pfx(pb, d[n-1][0].asSymbol, \in, b0, *d[n-1][1..])];
	} { 
		"Error: cannot chain starting from Pfx.".postln;
		pb = nil;
	}
};

~fxa = {|base ... d|
	var pb = ~fxa_returning_pfx.(base, *d);
	if (pb != nil) { 
		Pdef(pb[0], pb[1])
	};
};

~fxa0 = {|base| 
	{| ... d|
		var pb = ~fxa_returning_pfx.(base, *d);
		if (pb != nil) { 
			Pdef(pb[0], pb[1])
		}
	}
};

~fxa1 = {|base, key ... d| 
		var pb = ~fxa_returning_pfx.(base, *d);
		if (pb != nil) { 
			Pdef(key.asSymbol, pb[1])
		}
};

~ex_base = {|base, key, o ... d| 
	var bus = Bus.audio(s, 2);
	base = base.asSymbol; key = key.asSymbol;
	if (o != 0) { 
		e[key] = Synth(base, [\in, bus] ++ d.flatten(1) ++ [\o, o], g, \addToHead);
	} { 
		e[key] = Synth(base, [\in, bus] ++ d.flatten(1), g, \addToTail);
	};
	b[key] = bus;
	bus
};

~ex = {|base, key ... d| 
	key = (base ++ "_" ++ key).asSymbol;
	~ex_base.(base, key, 0, *d);
};

~exb = {|base, key, o ... d| 
	key = (base ++ "_" ++ key).asSymbol;
	~ex_base.(base, key, o, *d);
};

~ex0 = {|base| 
	{|key ... d|
		~ex.(base, key, 0, *d);
	}
};

~ex0b = {|base, o| 
	{|key ... d|
		~ex.(base, key, o, *d);
	}
};

~ex1 = {|base, key ... d| 
	~ex_base.(base, key, 0, *d);
};

~ex1b = {|base, key, o ... d| 
	~ex_base.(base, key, o, *d);
};

~pattern_summary = {|pattern, plot=false|
	var v=0, i=0, sum=0, list=List[], stream = pattern.asStream;
	((0..4)*4).do {|i|
		"----- %\n".postf(i);
		4.do { stream.next.postln}
	};
	stream = pattern.asStream;
	{ v.notNil && (i < 1000) }.while {
		v = stream.next;
		if (v.notNil) { sum = sum + v; list.add(v) };
		i = i + 1;
	};
	"### Length: %\n".postf(i-1);
	"### Sum: %\n".postf(sum);
	if (plot) { 
		list = list.flat.asArray;
		if (list.asSet.size == 1) { 
			list.plot(discrete:true)
		} { 
			list.plot
		}
	};
	nil;
};

// Scales/harmony/music-theory functions ----------

{
var nice_ratios = [1/3, 1/4, 1/2, 1, 2, 1/5, 9/10, 4/5, 7/10, 3/5, 2/5, 1/10, 3/10, 2/3, 3/4];
~note_gap_ratios = (0..36).neg.midiratio.collect({|val1|
	var diff;
	diff = 100;
	nice_ratios.do({|val2|
		(val2 - val1).abs;
		if ((val2 - val1).abs < diff) {
			diff = (val2 - val1).abs;
		};
	});
	diff;
}).round(0.001) * 1000;
}.value();

~scale_summary = {|scale|
	var n, t, m, r = scale.ratios.reciprocal.collect(_.round(0.001)), d = scale.degrees;
	case 
	{ scale.name == "Major" } 
		{ "### Description:\nHappy, can be majestic or sentimental when slow.".postln}
	{ scale.name == "Mixolydian" } 
		{ "### Description:\nBluesy rock; can alos be exotic/modal.".postln}
	{ scale.name == "Lydian" } 
		{ "### Description:\nEhernal, dreamy, futuristic.".postln};
	"i: - note - ratio\n".postln;
	r.do({|val, i|
		"%: - % - %\n".postf(i, d[i], val);
	});
	n = "x"!12;
	d.do({|val|
		n[val] = val;
	});
	("\n ~-------------~\n" 
		"(   .'% % %'.  )\n"
		"|  :%        %:  |\n"
		"|  :%        %:  |\n"
		"|  :%        %:  |\n"
		"'. '.. % % %..' .'\n"
		" ~-------------~\n" ).postf(*n[[11, 0, 1, 10, 2, 9, 3, 8, 4, 7, 6, 5]]);
		d = d ++ [12];
		t = (1..(d.size-1)).collect({|i|
			d[i] - d[i-1];
		});
		"### Semitone gaps:\n %, mean: %\n### Clustering:\n".postf(t, t.sum/t.size);
		"i\tσ\t\tbinary.sums".postln;
		(..t.size-3).do({|val, i|
			t = t[..t.size-2].collect({|val, i|
				[val, t[i+1]].flat.sum;
			});
			m = t.sum / t.size;
			"%\t%\t%\n".postf(i, {: (x-m)**2, x <- t }.all.sum.sqrt.round(0.01), t);
		});
		"\n### Distance to nice ratios (does not work for > 12 gaps):".postln;
		(
			"\n5++---66--75--59--79--71--89--63--53---56---84--94--++\n"
			"   |    -   -   -   -   -   -   -   -    -    -   -    |\n"
			"4  ++   -   -   -   -   -   -   -   -    39   41  44  ++\n"
			"   |    -   -   -   -   -   -   -   -    -    -   -    |\n"
			"3  ++   -   -   -   -   -   -   30  30   -    -   -   ++\n"
			"   |    -   -   -   -   -   -   -   -    -    -   -    |\n"
			"2  ++   -   -   -   -   -   -   -   -    -    -   -   ++\n"
			"   |    -   -   -   -   -   -   -   -    -    -   -    |\n"
			"1  ++   -   -   -   6   7   9   -   -    -    -   -   ++\n"
			"   |    1   1   5   -   -   -   -   -    -    -   -    |\n"
			"0  ++---7---5---9---4---6---2---8---11---10---3---1---+\n+"
		).postln;
		nil;
};

~seq_summary = {|a|
	var mean, median, r, r_all = ~note_gap_ratios, g = List[];
	a.do {|v, i| 
		a[i+1..].do {|v1|
			g.add(v1 - a[i])
		}
	};
	r = r_all[g.asArray].sort;
	"### Dissonance: \nn = %\nmean = %\nmedian = %\nsum = %\n".postf(
		r.size, r.mean.round(0.1), r.median.round(0.1), r.sum.round(0.1)
	);
	nil;
};

// Clock functions ------------------

~post_beat = {
	var beat = t.beats.ceil;
	t.sched(t.timeToNextBeat, {(t.beats - beat).postln; 4});
};

// INIT -----------------------------------------------------------------------
s.waitForBoot({
	// a = Ardour(); // Enable Ardour by default
	s.sync;
	Ndef(\g_tempo, 1); // Gloabl tempo for proxies and patterns
	~ndef_settings.value(nil, fadeTime:0.5, quant:1, clock:TempoClock.default);
	// Ndef.defaultReshaping = \elastic;
	// BusPlug.defaultReshaping = \elastic;
	~toggle_mute = ~make_toggle_mute.value();
	e = (); // dict for holding effects
	b = (); // dict for holding buses
	t = TempoClock.default;
	// Steno
	k = Steno.new;
	DiffString.tempFilePath = "~/sp/tmp";
	StageLimiter.activate(2);
	"./synthdef/synth_def.scd".loadRelative; // Synths
	"Setup done".postln;
	d = ~read_dirt_samples.value(); // Samples
});

// Platform.userExtensionDir
// Quarks.gui
// Quarks.install("ArdourOSC");
// Quarks.install("BatLib");
// Quarks.install("Bjorklund");
// Quarks.install("Dirt-Samples");
// Quarks.install("Esp");
// Quarks.install("FoxDot");
// Quarks.install("MathLib");
// Quarks.install("Spectrogram");
// Quarks.install("SuperDirt");
// Quarks.install("Vowel");
// Quarks.install("XML");
// Quarks.install("wslib");
// Quarks.install("Steno");
