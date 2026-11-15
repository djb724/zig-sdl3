const std = @import("std");

pub const Time = i64;
pub const Folder = enum(c_int) {
    home,
    desktop,
    documents,
    downloads,
    music,
    pictures,
    public_share,
    saved_games,
    screenshots,
    templates,
    videos,
    count,
};
pub const PathType = enum(c_int) {
    none,
    file,
    directory,
    other,
};
pub const PathInfo = extern struct {
    type: PathType,
    size: u64,
    create_time: Time,
    modify_time: Time,
    access_time: Time,
};
pub const GlobFlags = packed struct(u32) {
    case_insensitive: bool = false,
    _reserved: u31 = 0,
    pub fn toInt(self: GlobFlags) u32 {
        return @bitCast(self);
    }
};
pub const EnumerationResult = enum(c_int) {
    @"continue",
    success,
    failure,
};
pub const EnumerateDirectoryCallback = *const fn (userdata: ?*anyopaque, dirname: [*:0]const u8, fname: [*:0]const u8) callconv(.c) EnumerationResult;

extern fn SDL_free(mem: ?*anyopaque) callconv(.c) void;
extern fn SDL_GetBasePath() callconv(.c) ?[*:0]const u8;
extern fn SDL_GetPrefPath(org: [*:0]const u8, app: [*:0]const u8) callconv(.c) ?[*:0]u8;
extern fn SDL_GetUserFolder(folder: Folder) callconv(.c) ?[*:0]const u8;
extern fn SDL_CreateDirectory(path: [*:0]const u8) callconv(.c) bool;
extern fn SDL_EnumerateDirectory(path: [*:0]const u8, callback: EnumerateDirectoryCallback, userdata: ?*anyopaque) callconv(.c) bool;
extern fn SDL_RemovePath(path: [*:0]const u8) callconv(.c) bool;
extern fn SDL_RenamePath(oldpath: [*:0]const u8, newpath: [*:0]const u8) callconv(.c) bool;
extern fn SDL_CopyFile(oldpath: [*:0]const u8, newpath: [*:0]const u8) callconv(.c) bool;
extern fn SDL_GetPathInfo(path: [*:0]const u8, info: ?*PathInfo) callconv(.c) bool;
extern fn SDL_GlobDirectory(path: [*:0]const u8, pattern: ?[*:0]const u8, flags: GlobFlags, count: ?*c_int) callconv(.c) ?[*][*:0]u8;
extern fn SDL_GetCurrentDirectory() callconv(.c) ?[*:0]u8;

fn copyString(allocator: std.mem.Allocator, string: ?[*:0]u8) ![:0]u8 {
    const ptr = string orelse return error.SDLError;
    defer SDL_free(ptr);
    return allocator.dupeZ(u8, std.mem.span(ptr));
}
pub inline fn getBasePath() ![*:0]const u8 {
    return SDL_GetBasePath() orelse error.SDLError;
}
pub inline fn getPrefPath(allocator: std.mem.Allocator, org: [*:0]const u8, app: [*:0]const u8) ![:0]u8 {
    return copyString(allocator, SDL_GetPrefPath(org, app));
}
pub inline fn getUserFolder(folder: Folder) ![*:0]const u8 {
    return SDL_GetUserFolder(folder) orelse error.SDLError;
}
pub inline fn createDirectory(path: [*:0]const u8) !void {
    if (!SDL_CreateDirectory(path)) return error.SDLError;
}
pub inline fn enumerateDirectory(path: [*:0]const u8, callback: EnumerateDirectoryCallback, userdata: ?*anyopaque) !void {
    if (!SDL_EnumerateDirectory(path, callback, userdata)) return error.SDLError;
}
pub inline fn removePath(path: [*:0]const u8) !void {
    if (!SDL_RemovePath(path)) return error.SDLError;
}
pub inline fn renamePath(oldpath: [*:0]const u8, newpath: [*:0]const u8) !void {
    if (!SDL_RenamePath(oldpath, newpath)) return error.SDLError;
}
pub inline fn copyFile(oldpath: [*:0]const u8, newpath: [*:0]const u8) !void {
    if (!SDL_CopyFile(oldpath, newpath)) return error.SDLError;
}
pub inline fn getPathInfo(path: [*:0]const u8) !PathInfo {
    var info: PathInfo = undefined;
    if (!SDL_GetPathInfo(path, &info)) return error.SDLError;
    return info;
}
pub inline fn pathExists(path: [*:0]const u8) bool {
    return SDL_GetPathInfo(path, null);
}
pub inline fn globDirectory(allocator: std.mem.Allocator, path: [*:0]const u8, pattern: ?[*:0]const u8, flags: GlobFlags) ![][:0]u8 {
    var count: c_int = 0;
    const paths = SDL_GlobDirectory(path, pattern, flags, &count) orelse return error.SDLError;
    defer SDL_free(@ptrCast(paths));
    const slice = try allocator.alloc([:0]u8, @intCast(count));
    var copied: usize = 0;
    errdefer {
        for (slice[0..copied]) |entry| allocator.free(entry);
        allocator.free(slice);
    }
    for (slice, paths[0..slice.len]) |*entry, src| {
        entry.* = try allocator.dupeZ(u8, std.mem.span(src));
        copied += 1;
    }
    return slice;
}
pub inline fn getCurrentDirectory(allocator: std.mem.Allocator) ![:0]u8 {
    return copyString(allocator, SDL_GetCurrentDirectory());
}
