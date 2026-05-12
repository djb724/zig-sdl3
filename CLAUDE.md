# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Zig bindings for SDL3. This project is in early development — `build.zig` and `src/` are currently empty stubs.

## Source

The official documentation of the C API can be found here: https://wiki.libsdl.org/SDL3/APIByCategory. Crawl this site for source material. Do not use any information not found in https://wiki.libsdl.org/SDL3.

## Commands

```sh
zig build            # build the library
zig build test       # run tests
zig build test -- --test-filter <name>  # run a single test by name
```

## Architecture

This is a Zig library that wraps SDL3's C API. The expected structure:

- `build.zig` — Zig build script; links against the system SDL3 library (or fetches it via `zig fetch`)
- `src/` — Zig source files providing idiomatic Zig wrappers over SDL3 C bindings

## Style 

Roughly speaking: camelCaseFunctionName, TitleCaseTypeName, snake_case_variable_name. More precisely:

If x is a struct with 0 fields and is never meant to be instantiated then x is considered to be a "namespace" and should be snake_case.
If x is a type or type alias then x should be TitleCase.
If x is callable, and x's return type is type, then x should be TitleCase.
If x is otherwise callable, then x should be camelCase.
Otherwise, x should be snake_case.
Acronyms, initialisms, proper nouns, or any other word that has capitalization rules in written English are subject to naming conventions just like any other word. Even acronyms that are only 2 letters long are subject to these conventions.

File names fall into two categories: types and namespaces. If the file (implicitly a struct) has top level fields, it should be named like any other struct with fields using TitleCase. Otherwise, it should use snake_case. Directory names should be snake_case.

These are general rules of thumb; if it makes sense to do something different, do what makes sense. For example, if there is an established convention such as ENOENT, follow the established convention.

Do not include empty lines inside of structs or other codeblocks. Only use it to break up categorically different blocks.

Avoid using c_int. Use zig's integer types when it is clear which one to use. use c_int only when it is unclear.

## Goal

SDL3 is a C library and your job is to expose all functionality in canonical zig.

You should not use @cImport or translate-c.

For biflags, construct a packed struct that includes each flags as a boolean in its proper position so that it matches the C ABI exactly.
If any comments are at the end of a line, move them to the line immediately above what it refers to.
Also include a toInt function that bitcasts it to the underlying integer size.

for instance SDL has the following bitflags:

``` c
typedef Uint32 SDL_InitFlags;

#define SDL_INIT_AUDIO      0x00000010u /**< `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
#define SDL_INIT_VIDEO      0x00000020u /**< `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS`, should be initialized on the main thread */
#define SDL_INIT_JOYSTICK   0x00000200u /**< `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS` */
#define SDL_INIT_HAPTIC     0x00001000u
#define SDL_INIT_GAMEPAD    0x00002000u /**< `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
#define SDL_INIT_EVENTS     0x00004000u
#define SDL_INIT_SENSOR     0x00008000u /**< `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
#define SDL_INIT_CAMERA     0x00010000u /**< `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */
```

would result in:

``` zig
pub const InitFlags = packed struct(u32) {
    _b0: u4 = 0,
    // implies .events
    audio: bool = false,
    // implies .events, should be initialized in the main thread
    video: bool = false,
    _b6: u3 = 0,
    // implies .events
    joystick: bool = false,
    _b10: u2 = 0,
    haptic: bool = false,
    // implies .events
    gamepad: bool = false,
    events: bool = false,
    // implies .events
    sensor: bool = false,
    // implies .events
    camera: bool = false,
    _reserved: u15 = 0,
    pub fn toInt(self: InitFlags) u32 {
        return @bitCast(self);
    }
};
```

Note the use of padding to ensure that data matches the C ABI. Not all bitflags will use u32 as a size. Some will be u64 or another size.

Include and reexport all functions. For example from the c library:

``` c
bool SDL_Init(SDL_InitFlags flags);
```

would become

``` zig
extern fn SDL_Init(flags: InitFlags) bool;

...

pub const init = SDL_Init;
```

Place all renames with pub const at the bottom of the final file.

