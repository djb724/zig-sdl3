const std = @import("std");
const sdl = @import("root.zig");

pub fn main(init: std.process.Init) void {
    _ = init;
    sdl.init(.{
        .audio = true,
        .video = true,
    }) catch {
        std.debug.print("Init failed.\n", .{});
        return;
    };
    defer sdl.quit();

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
