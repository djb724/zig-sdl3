const std = @import("std");
const builtin = @import("builtin");
const filesystem = @import("filesystem.zig");
const video = @import("video.zig");

const SDL_Storage = opaque {};
pub const Storage = *SDL_Storage;
pub const StorageInterface = extern struct {
    version: u32 = @sizeOf(StorageInterface),
    close: ?*const fn (userdata: ?*anyopaque) callconv(.c) bool = null,
    ready: ?*const fn (userdata: ?*anyopaque) callconv(.c) bool = null,
    enumerate: ?*const fn (userdata: ?*anyopaque, path: [*:0]const u8, callback: filesystem.EnumerateDirectoryCallback, callback_userdata: ?*anyopaque) callconv(.c) bool = null,
    info: ?*const fn (userdata: ?*anyopaque, path: [*:0]const u8, info: ?*filesystem.PathInfo) callconv(.c) bool = null,
    read_file: ?*const fn (userdata: ?*anyopaque, path: [*:0]const u8, destination: *anyopaque, length: u64) callconv(.c) bool = null,
    write_file: ?*const fn (userdata: ?*anyopaque, path: [*:0]const u8, source: *const anyopaque, length: u64) callconv(.c) bool = null,
    mkdir: ?*const fn (userdata: ?*anyopaque, path: [*:0]const u8) callconv(.c) bool = null,
    remove: ?*const fn (userdata: ?*anyopaque, path: [*:0]const u8) callconv(.c) bool = null,
    rename: ?*const fn (userdata: ?*anyopaque, oldpath: [*:0]const u8, newpath: [*:0]const u8) callconv(.c) bool = null,
    copy: ?*const fn (userdata: ?*anyopaque, oldpath: [*:0]const u8, newpath: [*:0]const u8) callconv(.c) bool = null,
    space_remaining: ?*const fn (userdata: ?*anyopaque) callconv(.c) u64 = null,
};
comptime {
    const expected: usize = if (builtin.target.ptrBitWidth() == 64) 96 else 48;
    if (@sizeOf(StorageInterface) != expected) @compileError("unexpected size for StorageInterface");
}

extern fn SDL_free(mem: ?*anyopaque) callconv(.c) void;
extern fn SDL_OpenTitleStorage(override: ?[*:0]const u8, props: video.PropertiesId) callconv(.c) ?Storage;
extern fn SDL_OpenUserStorage(org: [*:0]const u8, app: [*:0]const u8, props: video.PropertiesId) callconv(.c) ?Storage;
extern fn SDL_OpenFileStorage(path: ?[*:0]const u8) callconv(.c) ?Storage;
extern fn SDL_OpenStorage(iface: *const StorageInterface, userdata: ?*anyopaque) callconv(.c) ?Storage;
extern fn SDL_CloseStorage(storage: Storage) callconv(.c) bool;
extern fn SDL_StorageReady(storage: Storage) callconv(.c) bool;
extern fn SDL_GetStorageFileSize(storage: Storage, path: [*:0]const u8, length: *u64) callconv(.c) bool;
extern fn SDL_ReadStorageFile(storage: Storage, path: [*:0]const u8, destination: ?*anyopaque, length: u64) callconv(.c) bool;
extern fn SDL_WriteStorageFile(storage: Storage, path: [*:0]const u8, source: ?*const anyopaque, length: u64) callconv(.c) bool;
extern fn SDL_CreateStorageDirectory(storage: Storage, path: [*:0]const u8) callconv(.c) bool;
extern fn SDL_EnumerateStorageDirectory(storage: Storage, path: ?[*:0]const u8, callback: filesystem.EnumerateDirectoryCallback, userdata: ?*anyopaque) callconv(.c) bool;
extern fn SDL_RemoveStoragePath(storage: Storage, path: [*:0]const u8) callconv(.c) bool;
extern fn SDL_RenameStoragePath(storage: Storage, oldpath: [*:0]const u8, newpath: [*:0]const u8) callconv(.c) bool;
extern fn SDL_CopyStorageFile(storage: Storage, oldpath: [*:0]const u8, newpath: [*:0]const u8) callconv(.c) bool;
extern fn SDL_GetStoragePathInfo(storage: Storage, path: [*:0]const u8, info: ?*filesystem.PathInfo) callconv(.c) bool;
extern fn SDL_GetStorageSpaceRemaining(storage: Storage) callconv(.c) u64;
extern fn SDL_GlobStorageDirectory(storage: Storage, path: ?[*:0]const u8, pattern: ?[*:0]const u8, flags: filesystem.GlobFlags, count: ?*c_int) callconv(.c) ?[*][*:0]u8;

pub inline fn openTitleStorage(override: ?[*:0]const u8, props: video.PropertiesId) !Storage {
    return SDL_OpenTitleStorage(override, props) orelse error.SDLError;
}
pub inline fn openUserStorage(org: [*:0]const u8, app: [*:0]const u8, props: video.PropertiesId) !Storage {
    return SDL_OpenUserStorage(org, app, props) orelse error.SDLError;
}
pub inline fn openFileStorage(path: ?[*:0]const u8) !Storage {
    return SDL_OpenFileStorage(path) orelse error.SDLError;
}
pub inline fn openStorage(iface: *const StorageInterface, userdata: ?*anyopaque) !Storage {
    return SDL_OpenStorage(iface, userdata) orelse error.SDLError;
}
pub inline fn closeStorage(storage: Storage) !void {
    if (!SDL_CloseStorage(storage)) return error.SDLError;
}
pub const storageReady = SDL_StorageReady;
pub inline fn getStorageFileSize(storage: Storage, path: [*:0]const u8) !u64 {
    var length: u64 = 0;
    if (!SDL_GetStorageFileSize(storage, path, &length)) return error.SDLError;
    return length;
}
pub inline fn readStorageFile(storage: Storage, path: [*:0]const u8, destination: []u8) !void {
    if (!SDL_ReadStorageFile(storage, path, destination.ptr, destination.len)) return error.SDLError;
}
pub inline fn writeStorageFile(storage: Storage, path: [*:0]const u8, source: []const u8) !void {
    if (!SDL_WriteStorageFile(storage, path, source.ptr, source.len)) return error.SDLError;
}
pub inline fn createStorageDirectory(storage: Storage, path: [*:0]const u8) !void {
    if (!SDL_CreateStorageDirectory(storage, path)) return error.SDLError;
}
pub inline fn enumerateStorageDirectory(storage: Storage, path: ?[*:0]const u8, callback: filesystem.EnumerateDirectoryCallback, userdata: ?*anyopaque) !void {
    if (!SDL_EnumerateStorageDirectory(storage, path, callback, userdata)) return error.SDLError;
}
pub inline fn removeStoragePath(storage: Storage, path: [*:0]const u8) !void {
    if (!SDL_RemoveStoragePath(storage, path)) return error.SDLError;
}
pub inline fn renameStoragePath(storage: Storage, oldpath: [*:0]const u8, newpath: [*:0]const u8) !void {
    if (!SDL_RenameStoragePath(storage, oldpath, newpath)) return error.SDLError;
}
pub inline fn copyStorageFile(storage: Storage, oldpath: [*:0]const u8, newpath: [*:0]const u8) !void {
    if (!SDL_CopyStorageFile(storage, oldpath, newpath)) return error.SDLError;
}
pub inline fn getStoragePathInfo(storage: Storage, path: [*:0]const u8) !filesystem.PathInfo {
    var info: filesystem.PathInfo = undefined;
    if (!SDL_GetStoragePathInfo(storage, path, &info)) return error.SDLError;
    return info;
}
pub inline fn storagePathExists(storage: Storage, path: [*:0]const u8) bool {
    return SDL_GetStoragePathInfo(storage, path, null);
}
pub const getStorageSpaceRemaining = SDL_GetStorageSpaceRemaining;
pub inline fn globStorageDirectory(allocator: std.mem.Allocator, storage: Storage, path: ?[*:0]const u8, pattern: ?[*:0]const u8, flags: filesystem.GlobFlags) ![][:0]u8 {
    var count: c_int = 0;
    const paths = SDL_GlobStorageDirectory(storage, path, pattern, flags, &count) orelse return error.SDLError;
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
