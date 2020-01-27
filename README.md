# Arcane server

This repository is both the source code and the API server of my [Arcane module](https://github.com/AriaSalvatrice/AriaVCVModules/) for VCV Rack. If you don't already know what that is, this README will not make any sense.

Here's how the fortune server works: every day, at 11:50 UTC, a scheduled [Azure Pipeline](/azure-pipelines.yml) runs [arcane.coffee](/arcane.coffee), and commits its output to `/v1/YYYY-MM-DD.json`. It's run 10 minutes before the module will attempt to fetch the new fortune, to account for desynchronized clocks, and to give the pipeline the time to execute (it should take less than a minute).    
Yeah, kind of an off-label usage of Pipelines, but I don't imagine Bill Gates gives a damn.

Why are the predictions done at that hour? It's arbitrary. No matter what I choose, it won't please every single timezone. 

While the API is versioned just in case, I do not expect to do a v2 unless v1 has a serious drawback. Adding more fields would make the game less, not more interesting. Working within its constrained framework is the whole point.

You are welcome to query the API from your own programs, and to interpret it similarly or differently from Arcane. You are not required to follow the same Tarot theme to make use of the API, but if you do, consider following the conventions of the Tarot of Marseilles for consistency.

I mean, I call it an API cuz it sounds really all super serious professional engineering like, but it's really just a buncha random numbers shoved into a public directory on github, so you do whatever, who gives a damn.

If the API fails to produce a new oracle for the day, first remember that UTC has no concept of daylight saving time, and that Azure might be running a bit late. After you have double-checked it's at least past 2:00 PM UTC, if there's no new JSON generated, bark at me here: <woof@aria.dog>

## Informal API definition

### Arcana

Integer between `0` and `21`, representing a major arcana of the tarot of Marseilles. Note that it's spelled in English in the json.

In Arcane, `0` stands for _the Fool_. `8` stands for _Justice_, and `11` for _Strength_, unlike the Rider-Waite-Smith Tarot which swaps the position of both cards.


### PatternB, PatternC, PatternD, PatternE

Unsigned 16-bit integer between 0 and 65535, to be interpreted as a 16 bit pattern. 

For example, `14325` stands for `0011011111110101`, and can be interpreted as a sequence of gates. 

There is no "PatternA", as the letters stand for the names of suits in the Tarot of Marseilles: Bâtons, Coupes, Deniers, and Épées.


### Scale

Unsigned 12-bit integer between `0` and `4095`, representing the notes of the scale in binary, starting from C. 

Thus, the C major scale would  be represented as `2773`, for `101011010101` or `C D E F G A B`, and the B minor scale would be represented as `1717`, for `011010110101`. 

Note that this is different from the more common way of encoding scales in binary, where any minor scale would be encoded as `2906`, and information about the first scale degree would be provided separately. In Arcane, the root note is not defined unambiguously (the user may decide to use the **NotePattern** to determine the first scale degree if they wish).

The scales will be comprised of 5, 6, 7, or 8 notes. Scales that are common in popular western music are more likely to be chosen. Refer to the source for details.


### NotePattern

Array of 8 integers from `0` to `11`, representing a series of notes. `C` stands for 0, `C#` for 1, and so on.

The array will start with every nome from the scale, in a random order. If the scale is shorter than 8 notes, it will be padded at the end with up to 3 different repeated notes to make a pattern of 8 notes.

Thus, the C major pentatonic scale, comprised of `C D E G A`, or the integers `0 2 4 7 9`, might result in the following series: `4 0 9 7 2 2 4 9`. Arcane would output the last three one octave higher, but the JSON doesn't.

### BPM

Integer between `60` and `180` BPM. Values between `90` and `150` are twice as likely to be drawn.

### Wish

Integer between `0` and `3`, representing whether I wish you:

- `0` = luck
- `1` = love
- `2` = health
- `3` = prosperity