pub const InitFlags = packed struct(u32) {
    _b0: u4 = 0,
    // implies .events
    audio: bool = false,
    // implies .events, should be initialized on the main thread
    video: bool = false,
    _b6: u3 = 0,
    // implies .events
    joystick: bool = false,
    _b10: u2 = 0,
    haptic: bool = false,
    // implies .joystick
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

pub const AppResult = enum(c_int) {
    // requests that the app continue from the main callbacks
    cont = 0,
    // requests termination with success from the main callbacks
    success = 1,
    // requests termination with error from the main callbacks
    failure = 2,
};

pub const MainThreadCallback = *const fn (userdata: ?*anyopaque) callconv(.c) void;
pub const AppInitFunc = *const fn (appstate: ?*?*anyopaque, argc: c_int, argv: ?[*][*:0]u8) callconv(.c) AppResult;
pub const AppIterateFunc = *const fn (appstate: ?*anyopaque) callconv(.c) AppResult;
// event parameter type will be updated when the events module is implemented
pub const AppEventFunc = *const fn (appstate: ?*anyopaque, event: *anyopaque) callconv(.c) AppResult;
pub const AppQuitFunc = *const fn (appstate: ?*anyopaque, result: AppResult) callconv(.c) void;

extern fn SDL_Init(flags: InitFlags) bool;
extern fn SDL_InitSubSystem(flags: InitFlags) bool;
extern fn SDL_Quit() void;
extern fn SDL_QuitSubSystem(flags: InitFlags) void;
extern fn SDL_WasInit(flags: InitFlags) InitFlags;
extern fn SDL_IsMainThread() bool;
extern fn SDL_RunOnMainThread(callback: MainThreadCallback, userdata: ?*anyopaque, wait_complete: bool) bool;
extern fn SDL_SetAppMetadata(appname: ?[*:0]const u8, appversion: ?[*:0]const u8, appidentifier: ?[*:0]const u8) bool;
extern fn SDL_SetAppMetadataProperty(name: [*:0]const u8, value: ?[*:0]const u8) bool;
extern fn SDL_GetAppMetadataProperty(name: [*:0]const u8) ?[*:0]const u8;

pub const init = SDL_Init;
pub const initSubSystem = SDL_InitSubSystem;
pub const quit = SDL_Quit;
pub const quitSubSystem = SDL_QuitSubSystem;
pub const wasInit = SDL_WasInit;
pub const isMainThread = SDL_IsMainThread;
pub const runOnMainThread = SDL_RunOnMainThread;
pub const setAppMetadata = SDL_SetAppMetadata;
pub const setAppMetadataProperty = SDL_SetAppMetadataProperty;
pub const getAppMetadataProperty = SDL_GetAppMetadataProperty;
