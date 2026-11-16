const std = @import("std");

pub const SDLError = error{
    SDLError,
};

extern fn SDL_SetError(fmt: [*:0]const u8, ...) callconv(.c) bool;
extern fn SDL_SetErrorV(fmt: [*:0]const u8, ap: std.builtin.VaList) callconv(.c) bool;
extern fn SDL_OutOfMemory() callconv(.c) bool;
extern fn SDL_GetError() callconv(.c) [*:0]const u8;
extern fn SDL_ClearError() callconv(.c) bool;

pub const max_error_message_len = 1024;

pub fn setError(comptime fmt: []const u8, args: anytype) SDLError {
    var buf: [max_error_message_len]u8 = undefined;
    var writer: std.Io.Writer = .fixed(buf[0 .. buf.len - 1]);
    writer.print(fmt, args) catch {};
    buf[writer.end] = 0;
    _ = SDL_SetError("%s", @as([*:0]const u8, buf[0..writer.end :0].ptr));
    return error.SDLError;
}
pub const setErrorPrintf = SDL_SetError;
pub inline fn setErrorV(fmt: [*:0]const u8, ap: std.builtin.VaList) SDLError {
    _ = SDL_SetErrorV(fmt, ap);
    return error.SDLError;
}
pub inline fn outOfMemory() SDLError {
    _ = SDL_OutOfMemory();
    return error.SDLError;
}
pub const getError = SDL_GetError;
pub inline fn clearError() void {
    _ = SDL_ClearError();
}
pub inline fn unsupported() SDLError {
    _ = SDL_SetError("That operation is not supported");
    return error.SDLError;
}
pub inline fn invalidParamError(param: [*:0]const u8) SDLError {
    _ = SDL_SetError("Parameter '%s' is invalid", param);
    return error.SDLError;
}
