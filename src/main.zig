const std = @import("std");
const sdl = @import("root.zig");

pub fn main(init: std.process.Init) void {
    _ = init;
    const success = sdl.init(.{
        .audio = true,
        .video = true,
    });
    defer sdl.quit();
    if (!success) {
        std.debug.print("Init failed.", .{});
        return;
    }

    const target: sdl.InitFlags = .{
        .audio = true,
        .video = true,
        .events = true,
    };
    const inited = sdl.wasInit(.{});
    if (target != inited) {
        std.debug.print("Not all fields initialized: {x} != {x}\n", .{inited.toInt(), target.toInt()});
        return;
    }

    std.debug.print("Success.\n", .{});
}
