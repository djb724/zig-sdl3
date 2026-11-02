# zig-sdl3

Simple DirectMedia Layer (SDL) is a cross-platform library designed to expose low-level access to window management, audio, controlls, and graphics systems. Often used for games, video software, emulators, and more.

You can find the original documentation [here](https://wiki.libsdl.org/SDL3/FrontPage).

Their official repo can be found [here](https://github.com/libsdl-org/SDL/tree/main).

## Installation

Fetch the dependency:

```sh
zig fetch --save git+https://github.com/djb724/zig-sdl3.git
```

In your build.zig:

```zig
pub fn build(b: *std.Build) void {
    ...
    const sdl3_dep = b.dependency("zig_sdl3", .{
        .target = target,
        .optimize = optimize,
    });
    const sdl3 = sdl3_dep.module("zig_sdl3");
    const exe = b.addExecutable(.{
        .name = "my_app",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "sdl3", .module = sdl3 },
            },
        }),
    });
    b.installArtifact(exe);
}
```

## What are you doing?

SDL3 is a C library. The goal is to provide seamless zig bindings to allow faster, less error-prone development by leveraging zig's language features. Also provide idiomatic naming conventions without the SDL_prefix.

- Datatypes and structs will become `PascalCase` without the `SDL_` prefix. I.e. ```SDL_Window``` will become ```sdl.Window```.
- Enums will be implemented as zig enums with the same internal values in `snake_case` without the `SDL_` prefix.

### Functions

Functions will become `camelCase` with out the `SDL_` prefix. I.e. ```SDL_CreateWindow(...)``` will become ```sdl.createWindow(...)```.

If a function can fail, this library will return an error union with the original return type and `error.SDLError`. Note that `sdl.getError()` can still be used to get the error message afterward.

If a function allocates memory, it will take an allocator as a parameter. I.e.:

```zig
const windows: []Window = try sdl.getWindows(allocator);
defer allocator.free(windows);
```

### Bitflags

Bitflags will be implemented as packed structs of booleans. I.e.

```c
const SDL_InitFlags flags = SDL_INIT_AUDIO | SDL_INIT_CAMERA;
```

can be expressed as: 

```zig
const flags: sdl.InitFlags = .{ audio = true, camera = true };
```

### Macros

Constants defined via macros will be exposed as constant variables in `UPPER_SNAKE_CASE`.

Several low-level data types are implemented as packed structs or packed unions in c through macros i.e. ```SDL_PixelFormat```. These have been implemented natively as packed structs with
member functions to expose related functionalities.

## Other features or changes planned

- expose functions that can fail as ones that return zig error unions rather than returning false/null on error
- (maybe) expose proxy types that contain a member handle. I.e. ```SDL_GetWindowSurface(window)``` can be called as:
```zig 
const window: WindowProxy = .create(...);
window.show();
window.getSurface();
```

## Contributing

This project is still in its infancy and I plan to be actively working on it. If you would like to contribute, feel free to make a pull request AFTER you have read this README and the rest of the code base for guidelines.

If you have any issues or spot any bugs, feel free to open an issue but make sure this is an issue with the bindings library and not an issue with SDL itself.
