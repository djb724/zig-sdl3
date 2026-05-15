const pixels = @import("pixels.zig");

pub const PropertiesId = u32;
pub const AppResult = enum(c_int) {
    cont = 0,
    success = 1,
    failure = 2,
};
pub const InitFlags = packed struct(u32) {
    _b0: u4 = 0,
    /// implies .events
    audio: bool = false,
    /// implies .events, should be initialized on the main thread
    video: bool = false,
    _b6: u3 = 0,
    /// implies .events
    joystick: bool = false,
    _b10: u2 = 0,
    haptic: bool = false,
    /// implies .joystick
    gamepad: bool = false,
    events: bool = false,
    /// implies .events
    sensor: bool = false,
    /// implies .events
    camera: bool = false,
    _reserved: u15 = 0,
    pub fn toInt(self: InitFlags) u32 {
        return @bitCast(self);
    }
};
pub const HintPriority = enum(c_int) {
    default = 0,
    normal = 1,
    override = 2,
};
pub const PropertyType = enum(c_int) {
    invalid = 0,
    pointer = 1,
    string = 2,
    number = 3,
    float = 4,
    boolean = 5,
};
pub const LogCategory = enum(c_int) {
    application,
    @"error",
    assert,
    system,
    audio,
    video,
    render,
    input,
    @"test",
    gpu,
    reserved2,
    reserved3,
    reserved4,
    reserved5,
    reserved6,
    reserved7,
    reserved8,
    reserved9,
    reserved10,
    custom,
};
pub const LogPriority = enum(c_int) {
    invalid,
    trace,
    verbose,
    debug,
    info,
    warn,
    @"error",
    critical,
    count,
};

pub const AssertState = enum(c_int) {
    retry,
    @"break",
    abort,
    ignore,
    always_ignore,
};

// ============================================================
// Structs
// ============================================================

pub const AssertData = extern struct {
    always_ignore: bool,
    trigger_count: u32,
    condition: [*:0]const u8,
    filename: [*:0]const u8,
    linenum: i32,
    function: [*:0]const u8,
    next: ?*const AssertData,
};

// ============================================================
// Callback types
// ============================================================

pub const MainFunc = *const fn (argc: i32, argv: [*][*:0]u8) callconv(.c) i32;
pub const AppInitFunc = *const fn (appstate: ?*?*anyopaque, argc: i32, argv: ?[*][*:0]u8) callconv(.c) AppResult;
pub const AppIterateFunc = *const fn (appstate: ?*anyopaque) callconv(.c) AppResult;
// event parameter will be *Event once the events module is defined
pub const AppEventFunc = *const fn (appstate: ?*anyopaque, event: *anyopaque) callconv(.c) AppResult;
pub const AppQuitFunc = *const fn (appstate: ?*anyopaque, result: AppResult) callconv(.c) void;
pub const MainThreadCallback = *const fn (userdata: ?*anyopaque) callconv(.c) void;
pub const HintCallback = *const fn (userdata: ?*anyopaque, name: [*:0]const u8, old_value: ?[*:0]const u8, new_value: ?[*:0]const u8) callconv(.c) void;
pub const CleanupPropertyCallback = *const fn (userdata: ?*anyopaque, value: ?*anyopaque) callconv(.c) void;
pub const EnumeratePropertiesCallback = *const fn (userdata: ?*anyopaque, props: PropertiesId, name: [*:0]const u8) callconv(.c) void;
pub const LogOutputFunction = *const fn (userdata: ?*anyopaque, category: i32, priority: LogPriority, message: [*:0]const u8) callconv(.c) void;
pub const AssertionHandler = *const fn (data: *const AssertData, userdata: ?*anyopaque) callconv(.c) AssertState;

// ============================================================
// Extern functions — CategoryMain
// ============================================================

extern fn SDL_EnterAppMainCallbacks(argc: i32, argv: [*][*:0]u8, appinit: AppInitFunc, appiter: AppIterateFunc, appevent: AppEventFunc, appquit: AppQuitFunc) i32;
extern fn SDL_RunApp(argc: i32, argv: [*][*:0]u8, main_function: MainFunc, reserved: ?*anyopaque) i32;
extern fn SDL_SetMainReady() void;
extern fn SDL_RegisterApp(name: ?[*:0]const u8, style: u32, h_inst: ?*anyopaque) bool;
extern fn SDL_UnregisterApp() void;
extern fn SDL_GDKSuspendComplete() void;

// ============================================================
// Extern functions — CategoryInit
// ============================================================

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

// ============================================================
// Extern functions — CategoryHints
// ============================================================

extern fn SDL_SetHint(name: [*:0]const u8, value: [*:0]const u8) bool;
extern fn SDL_SetHintWithPriority(name: [*:0]const u8, value: [*:0]const u8, priority: HintPriority) bool;
extern fn SDL_GetHint(name: [*:0]const u8) ?[*:0]const u8;
extern fn SDL_GetHintBoolean(name: [*:0]const u8, default_value: bool) bool;
extern fn SDL_ResetHint(name: [*:0]const u8) bool;
extern fn SDL_ResetHints() void;
extern fn SDL_AddHintCallback(name: [*:0]const u8, callback: HintCallback, userdata: ?*anyopaque) bool;
extern fn SDL_RemoveHintCallback(name: [*:0]const u8, callback: HintCallback, userdata: ?*anyopaque) void;

// ============================================================
// Extern functions — CategoryProperties
// ============================================================

extern fn SDL_GetGlobalProperties() PropertiesId;
extern fn SDL_CreateProperties() PropertiesId;
extern fn SDL_CopyProperties(src: PropertiesId, dst: PropertiesId) bool;
extern fn SDL_LockProperties(props: PropertiesId) bool;
extern fn SDL_UnlockProperties(props: PropertiesId) void;
extern fn SDL_SetPointerPropertyWithCleanup(props: PropertiesId, name: [*:0]const u8, value: ?*anyopaque, cleanup: ?CleanupPropertyCallback, userdata: ?*anyopaque) bool;
extern fn SDL_SetPointerProperty(props: PropertiesId, name: [*:0]const u8, value: ?*anyopaque) bool;
extern fn SDL_SetStringProperty(props: PropertiesId, name: [*:0]const u8, value: ?[*:0]const u8) bool;
extern fn SDL_SetNumberProperty(props: PropertiesId, name: [*:0]const u8, value: i64) bool;
extern fn SDL_SetFloatProperty(props: PropertiesId, name: [*:0]const u8, value: f32) bool;
extern fn SDL_SetBooleanProperty(props: PropertiesId, name: [*:0]const u8, value: bool) bool;
extern fn SDL_HasProperty(props: PropertiesId, name: [*:0]const u8) bool;
extern fn SDL_GetPropertyType(props: PropertiesId, name: [*:0]const u8) PropertyType;
extern fn SDL_GetPointerProperty(props: PropertiesId, name: [*:0]const u8, default_value: ?*anyopaque) ?*anyopaque;
extern fn SDL_GetStringProperty(props: PropertiesId, name: [*:0]const u8, default_value: ?[*:0]const u8) ?[*:0]const u8;
extern fn SDL_GetNumberProperty(props: PropertiesId, name: [*:0]const u8, default_value: i64) i64;
extern fn SDL_GetFloatProperty(props: PropertiesId, name: [*:0]const u8, default_value: f32) f32;
extern fn SDL_GetBooleanProperty(props: PropertiesId, name: [*:0]const u8, default_value: bool) bool;
extern fn SDL_ClearProperty(props: PropertiesId, name: [*:0]const u8) bool;
extern fn SDL_EnumerateProperties(props: PropertiesId, callback: EnumeratePropertiesCallback, userdata: ?*anyopaque) bool;
extern fn SDL_DestroyProperties(props: PropertiesId) void;

extern fn SDL_GetError() [*:0]const u8;
extern fn SDL_SetError(fmt: [*:0]const u8, ...) bool;
extern fn SDL_OutOfMemory() bool;
extern fn SDL_ClearError() bool;

extern fn SDL_Log(fmt: [*:0]const u8, ...) void;
extern fn SDL_LogTrace(category: i32, fmt: [*:0]const u8, ...) void;
extern fn SDL_LogVerbose(category: i32, fmt: [*:0]const u8, ...) void;
extern fn SDL_LogDebug(category: i32, fmt: [*:0]const u8, ...) void;
extern fn SDL_LogInfo(category: i32, fmt: [*:0]const u8, ...) void;
extern fn SDL_LogWarn(category: i32, fmt: [*:0]const u8, ...) void;
extern fn SDL_LogError(category: i32, fmt: [*:0]const u8, ...) void;
extern fn SDL_LogCritical(category: i32, fmt: [*:0]const u8, ...) void;
extern fn SDL_LogMessage(category: i32, priority: LogPriority, fmt: [*:0]const u8, ...) void;
extern fn SDL_GetDefaultLogOutputFunction() LogOutputFunction;
extern fn SDL_GetLogOutputFunction(callback: *LogOutputFunction, userdata: *?*anyopaque) void;
extern fn SDL_SetLogOutputFunction(callback: LogOutputFunction, userdata: ?*anyopaque) void;
extern fn SDL_GetLogPriority(category: i32) LogPriority;
extern fn SDL_SetLogPriority(category: i32, priority: LogPriority) void;
extern fn SDL_SetLogPriorities(priority: LogPriority) void;
extern fn SDL_ResetLogPriorities() void;
extern fn SDL_SetLogPriorityPrefix(priority: LogPriority, prefix: ?[*:0]const u8) bool;

extern fn SDL_ReportAssertion(data: *AssertData, func: [*:0]const u8, file: [*:0]const u8, line: i32) AssertState;
extern fn SDL_SetAssertionHandler(handler: ?AssertionHandler, userdata: ?*anyopaque) void;
extern fn SDL_GetDefaultAssertionHandler() AssertionHandler;
extern fn SDL_GetAssertionHandler(puserdata: ?*?*anyopaque) AssertionHandler;
extern fn SDL_GetAssertionReport() ?*const AssertData;
extern fn SDL_ResetAssertionReport() void;

extern fn SDL_GetVersion() i32;
extern fn SDL_GetRevision() [*:0]const u8;

pub const enterAppMainCallbacks = SDL_EnterAppMainCallbacks;
pub const runApp = SDL_RunApp;
pub const setMainReady = SDL_SetMainReady;
pub const registerApp = SDL_RegisterApp;
pub const unregisterApp = SDL_UnregisterApp;
pub const gdkSuspendComplete = SDL_GDKSuspendComplete;
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
pub const setHint = SDL_SetHint;
pub const setHintWithPriority = SDL_SetHintWithPriority;
pub const getHint = SDL_GetHint;
pub const getHintBoolean = SDL_GetHintBoolean;
pub const resetHint = SDL_ResetHint;
pub const resetHints = SDL_ResetHints;
pub const addHintCallback = SDL_AddHintCallback;
pub const removeHintCallback = SDL_RemoveHintCallback;
pub const getGlobalProperties = SDL_GetGlobalProperties;
pub const createProperties = SDL_CreateProperties;
pub const copyProperties = SDL_CopyProperties;
pub const lockProperties = SDL_LockProperties;
pub const unlockProperties = SDL_UnlockProperties;
pub const setPointerPropertyWithCleanup = SDL_SetPointerPropertyWithCleanup;
pub const setPointerProperty = SDL_SetPointerProperty;
pub const setStringProperty = SDL_SetStringProperty;
pub const setNumberProperty = SDL_SetNumberProperty;
pub const setFloatProperty = SDL_SetFloatProperty;
pub const setBooleanProperty = SDL_SetBooleanProperty;
pub const hasProperty = SDL_HasProperty;
pub const getPropertyType = SDL_GetPropertyType;
pub const getPointerProperty = SDL_GetPointerProperty;
pub const getStringProperty = SDL_GetStringProperty;
pub const getNumberProperty = SDL_GetNumberProperty;
pub const getFloatProperty = SDL_GetFloatProperty;
pub const getBooleanProperty = SDL_GetBooleanProperty;
pub const clearProperty = SDL_ClearProperty;
pub const enumerateProperties = SDL_EnumerateProperties;
pub const destroyProperties = SDL_DestroyProperties;
pub const getError = SDL_GetError;
pub const setError = SDL_SetError;
pub const outOfMemory = SDL_OutOfMemory;
pub const clearError = SDL_ClearError;
pub const log = SDL_Log;
pub const logTrace = SDL_LogTrace;
pub const logVerbose = SDL_LogVerbose;
pub const logDebug = SDL_LogDebug;
pub const logInfo = SDL_LogInfo;
pub const logWarn = SDL_LogWarn;
pub const logError = SDL_LogError;
pub const logCritical = SDL_LogCritical;
pub const logMessage = SDL_LogMessage;
pub const getDefaultLogOutputFunction = SDL_GetDefaultLogOutputFunction;
pub const getLogOutputFunction = SDL_GetLogOutputFunction;
pub const setLogOutputFunction = SDL_SetLogOutputFunction;
pub const getLogPriority = SDL_GetLogPriority;
pub const setLogPriority = SDL_SetLogPriority;
pub const setLogPriorities = SDL_SetLogPriorities;
pub const resetLogPriorities = SDL_ResetLogPriorities;
pub const setLogPriorityPrefix = SDL_SetLogPriorityPrefix;
pub const reportAssertion = SDL_ReportAssertion;
pub const setAssertionHandler = SDL_SetAssertionHandler;
pub const getDefaultAssertionHandler = SDL_GetDefaultAssertionHandler;
pub const getAssertionHandler = SDL_GetAssertionHandler;
pub const getAssertionReport = SDL_GetAssertionReport;
pub const resetAssertionReport = SDL_ResetAssertionReport;
pub const getVersion = SDL_GetVersion;
pub const getRevision = SDL_GetRevision;
const std = @import("std");

const SDL_Point = extern struct {
    x: i32,
    y: i32,
};
const SDL_FPoint = extern struct {
    x: f32,
    y: f32,
};
const SDL_Rect = extern struct {
    x: i32,
    y: i32,
    w: i32,
    h: i32,
};
const SDL_FRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,
};
fn SDL_RectToFRect(rect: *const SDL_Rect, frect: *SDL_FRect) void {
    frect.x = @floatFromInt(rect.x);
    frect.y = @floatFromInt(rect.y);
    frect.w = @floatFromInt(rect.w);
    frect.h = @floatFromInt(rect.h);
}
fn SDL_PointInRect(p: *const SDL_Point, r: *const SDL_Rect) bool {
    return p.x >= r.x and p.x < r.x + r.w and p.y >= r.y and p.y < r.y + r.h;
}
fn SDL_RectEmpty(r: *const SDL_Rect) bool {
    return r.w <= 0 or r.h <= 0;
}
fn SDL_RectsEqual(a: *const SDL_Rect, b: *const SDL_Rect) bool {
    return a.x == b.x and a.y == b.y and a.w == b.w and a.h == b.h;
}
extern fn SDL_HasRectIntersection(A: *const SDL_Rect, B: *const SDL_Rect) bool;
extern fn SDL_GetRectIntersection(A: *const SDL_Rect, B: *const SDL_Rect, result: *SDL_Rect) bool;
extern fn SDL_GetRectUnion(A: *const SDL_Rect, B: *const SDL_Rect, result: *SDL_Rect) bool;
extern fn SDL_GetRectEnclosingPoints(points: [*]const SDL_Point, count: i32, clip: ?*const SDL_Rect, result: *SDL_Rect) bool;
extern fn SDL_GetRectAndLineIntersection(rect: *const SDL_Rect, X1: *i32, Y1: *i32, X2: *i32, Y2: *i32) bool;
fn SDL_PointInRectFloat(p: *const SDL_FPoint, r: *const SDL_FRect) bool {
    return p.x >= r.x and p.x <= r.x + r.w and p.y >= r.y and p.y <= r.y + r.h;
}
fn SDL_RectEmptyFloat(r: *const SDL_FRect) bool {
    return r.w < 0.0 or r.h < 0.0;
}
fn SDL_RectsEqualEpsilon(a: *const SDL_FRect, b: *const SDL_FRect, epsilon: f32) bool {
    return @abs(a.x - b.x) <= epsilon and @abs(a.y - b.y) <= epsilon and @abs(a.w - b.w) <= epsilon and @abs(a.h - b.h) <= epsilon;
}
fn SDL_RectsEqualFloat(a: *const SDL_FRect, b: *const SDL_FRect) bool {
    return SDL_RectsEqualEpsilon(a, b, std.math.floatEps(f32));
}
extern fn SDL_HasRectIntersectionFloat(A: *const SDL_FRect, B: *const SDL_FRect) bool;
extern fn SDL_GetRectIntersectionFloat(A: *const SDL_FRect, B: *const SDL_FRect, result: *SDL_FRect) bool;
extern fn SDL_GetRectUnionFloat(A: *const SDL_FRect, B: *const SDL_FRect, result: *SDL_FRect) bool;
extern fn SDL_GetRectEnclosingPointsFloat(points: [*]const SDL_FPoint, count: i32, clip: ?*const SDL_FRect, result: *SDL_FRect) bool;
extern fn SDL_GetRectAndLineIntersectionFloat(rect: *const SDL_FRect, X1: *f32, Y1: *f32, X2: *f32, Y2: *f32) bool;

pub const Point = SDL_Point;
pub const FPoint = SDL_FPoint;
pub const Rect = SDL_Rect;
pub const FRect = SDL_FRect;

pub const rectToFRect = SDL_RectToFRect;
pub const pointInRect = SDL_PointInRect;
pub const rectEmpty = SDL_RectEmpty;
pub const rectsEqual = SDL_RectsEqual;
pub const hasRectIntersection = SDL_HasRectIntersection;
pub const getRectIntersection = SDL_GetRectIntersection;
pub const getRectUnion = SDL_GetRectUnion;
pub const getRectEnclosingPoints = SDL_GetRectEnclosingPoints;
pub const getRectAndLineIntersection = SDL_GetRectAndLineIntersection;
pub const pointInRectFloat = SDL_PointInRectFloat;
pub const rectEmptyFloat = SDL_RectEmptyFloat;
pub const rectsEqualEpsilon = SDL_RectsEqualEpsilon;
pub const rectsEqualFloat = SDL_RectsEqualFloat;
pub const hasRectIntersectionFloat = SDL_HasRectIntersectionFloat;
pub const getRectIntersectionFloat = SDL_GetRectIntersectionFloat;
pub const getRectUnionFloat = SDL_GetRectUnionFloat;
pub const getRectEnclosingPointsFloat = SDL_GetRectEnclosingPointsFloat;
pub const getRectAndLineIntersectionFloat = SDL_GetRectAndLineIntersectionFloat;
// # CategoryVideo

pub const DisplayId = u32;
pub const WindowId = u32;

pub const PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER = "SDL.video.wayland.wl_display";

pub const SystemTheme = enum(u32) {
    unknown,
    light,
    dark,
};
pub const DisplayModeData = opaque {};
pub const DisplayMode = extern struct {
    /// the display this mode is associated with
    displayId: DisplayId,
    /// pixel format
    format: u32, // TODO SDL_PixelFormat
    /// width
    w: u32,
    /// height
    h: u32,
    /// scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels)
    pixel_density: f32,
    /// refresh_rate (or 0.0 if unspecified)
    refresh_rate: f32,
    /// precise refresh rate numerator (or 0 if unspecified)
    refresh_rate_numerator: c_int,
    /// precise refresh rate denominator
    refresh_rate_denominator: c_int,
    /// opaque private field
    internal: ?*DisplayModeData,
};

/// Display orientation values; the way a display is rotated.
pub const DisplayOrientation = enum(u32) {
    unknown,
    /// landscape mode, with the right side up relative to portrait mode
    landscape,
    /// landscape mode, with the left side up relative to portrait mode
    landscape_flipped,
    /// portrait mode
    portrait,
    /// portrait mode, upside-down
    portrait_flipped,
};

/// The struct used as an opaque handle to a window.
const SDL_Window = opaque {};
/// Handle to an SDL Window
pub const Window = ?*SDL_Window;

pub const WindowFlags = packed struct(u64) {
    /// window is in fullscreen mode
    sdl_window_fullscreen: bool = false,           // 0x0000000000000001
    /// window is usable with OpenGL context
    sdl_window_opengl: bool = false,               // 0x0000000000000002
    /// window is occluded
    sdl_window_occluded: bool = false,             // 0x0000000000000004
    /// window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; showWindow() is required for it to become visible
    sdl_window_hidden: bool = false,               // 0x0000000000000008
    /// no window decoration
    sdl_window_borderless: bool = false,           // 0x0000000000000010
    /// window can be resized
    sdl_window_resizable: bool = false,            // 0x0000000000000020
    /// window is minimized
    sdl_window_minimized: bool = false,            // 0x0000000000000040
    /// window is maximized
    sdl_window_maximized: bool = false,            // 0x0000000000000080
    /// window has grabbed mouse input
    sdl_window_mouse_grabbed: bool = false,        // 0x0000000000000100
    /// window has input focus
    sdl_window_input_focus: bool = false,          // 0x0000000000000200
    /// window has mouse focus
    sdl_window_mouse_focus: bool = false,          // 0x0000000000000400
    /// window not created by SDL
    sdl_window_external: bool = false,             // 0x0000000000000800
    /// window is modal
    sdl_window_modal: bool = false,                // 0x0000000000001000
    /// window uses high pixel density back buffer if possible
    sdl_window_high_pixel_density: bool = false,   // 0x0000000000002000
    /// window has mouse captured (unrelated to MOUSE_GRABBED)
    sdl_window_mouse_capture: bool = false,        // 0x0000000000004000
    /// window has relative mode enabled
    sdl_window_mouse_relative_mode: bool = false,  // 0x0000000000008000
    /// window should always be above others
    sdl_window_always_on_top: bool = false,        // 0x0000000000010000
    /// window should be treated as a utility window, not showing in the task bar and window list
    sdl_window_utility: bool = false,              // 0x0000000000020000
    /// window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window
    sdl_window_tooltip: bool = false,              // 0x0000000000040000
    /// window should be treated as a popup menu, requires a parent window
    sdl_window_popup_menu: bool = false,           // 0x0000000000080000
    /// window has grabbed keyboard input
    sdl_window_keyboard_grabbed: bool = false,     // 0x0000000000100000
    /// window is in fill-document mode (Emscripten only), since SDL 3.4.0
    sdl_window_fill_document: bool = false,        // 0x0000000000200000
    _b22: u6 = 0,
    /// window usable for Vulkan surface
    sdl_window_vulkan: bool = false,               // 0x0000000010000000
    /// window usable for Metal view
    sdl_window_metal: bool = false,                // 0x0000000020000000
    /// window with transparent buffer
    sdl_window_transparent: bool = false,          // 0x0000000040000000
    /// window should not be focusable
    sdl_window_not_focusable: bool = false,        // 0x0000000080000000
    _reserved: u32 = 0,
};

// TODO: expose functions for these macros 

// #define SDL_WINDOWPOS_UNDEFINED_DISPLAY(X)  (SDL_WINDOWPOS_UNDEFINED_MASK|(X))
// #define SDL_WINDOWPOS_UNDEFINED         SDL_WINDOWPOS_UNDEFINED_DISPLAY(0)
// #define SDL_WINDOWPOS_ISUNDEFINED(X)    (((X)&0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK)
// #define SDL_WINDOWPOS_CENTERED_MASK    0x2FFF0000u
// #define SDL_WINDOWPOS_CENTERED_DISPLAY(X)  (SDL_WINDOWPOS_CENTERED_MASK|(X))
// #define SDL_WINDOWPOS_CENTERED         SDL_WINDOWPOS_CENTERED_DISPLAY(0)
// #define SDL_WINDOWPOS_ISCENTERED(X)    \
//             (((X)&0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK)

pub const FlashOperation = enum(c_int) {
    /// Cancel any window flash state
    cancel,
    /// Flash the window briefly to get attention
    briefly,
    /// Flash the window until it gets focus
    until_focused,
};
pub const ProgressState = enum(i32) {
    invalid = -1,
    none = 0,
    indeterminate,
    normal,
    paused,
    @"error",
};

const SDL_GLContext = opaque {};
const SDL_EGLDisplay = opaque {};
const SDL_EGLConfig = opaque {};
const SDL_EGLSurface = opaque {};

/// Handle to an opaqge SDL_GLContext;
pub const GLContext = ?*SDL_GLContext;
/// Handle to an opaqge SDL_EGLDisplay;
pub const EGLDisplay = ?*SDL_EGLDisplay;
/// Handle to an opaqge SDL_EGLConfig;
pub const EGLConfig = ?*SDL_EGLConfig;
/// Handle to an opaqge SDL_EGLSurface;
pub const EGLSurface = ?*SDL_EGLSurface;
/// An EGL attribute, used when creating an EGL context.
pub const EGLAttrib = isize;
/// An EGL integer attribute, used when creating an EGL surface.
pub const EGLInt = c_int;

pub const EGLAttribArrayCallback = *const fn (userdata: ?*anyopaque) callconv(.c) EGLAttrib;
pub const EGLIntArrayCallback = *const fn (userdata: ?*anyopaque, display: EGLDisplay, config: EGLConfig) callconv(.c) EGLInt;
pub const GLAttr = enum(c_int) {
    /// the minimum number of bits for the red channel of the color buffer; defaults to 8.
    red_size,
    /// the minimum number of bits for the green channel of the color buffer; defaults to 8.
    green_size,
    /// the minimum number of bits for the blue channel of the color buffer; defaults to 8.
    blue_size,
    /// the minimum number of bits for the alpha channel of the color buffer; defaults to 8.
    alpha_size,
    /// the minimum number of bits for frame buffer size; defaults to 0.
    buffer_size,
    /// whether the output is single or double buffered; defaults to double buffering on.
    doublebuffer,
    /// the minimum number of bits in the depth buffer; defaults to 16.
    depth_size,
    /// the minimum number of bits in the stencil buffer; defaults to 0.
    stencil_size,
    /// the minimum number of bits for the red channel of the accumulation buffer; defaults to 0.
    accum_red_size,
    /// the minimum number of bits for the green channel of the accumulation buffer; defaults to 0.
    accum_green_size,
    /// the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0.
    accum_blue_size,
    /// the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0.
    accum_alpha_size,
    /// whether the output is stereo 3D; defaults to off.
    stereo,
    /// the number of buffers used for multisample anti-aliasing; defaults to 0.
    multisamplebuffers,
    /// the number of samples used around the current pixel used for multisample anti-aliasing.
    multisamplesamples,
    /// set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either.
    accelerated_visual,
    /// not used (deprecated).
    retained_backing,
    /// OpenGL context major version.
    context_major_version,
    /// OpenGL context minor version.
    context_minor_version,
    /// some combination of 0 or more of elements of the SDL_GLContextFlag enumeration; defaults to 0.
    context_flags,
    /// type of GL context (Core, Compatibility, ES). See SDL_GLProfile; default value depends on platform.
    context_profile_mask,
    /// OpenGL context sharing; defaults to 0.
    share_with_current_context,
    /// requests sRGB capable visual; defaults to 0.
    framebuffer_srgb_capable,
    /// sets context the release behavior. See SDL_GLContextReleaseFlag; defaults to FLUSH.
    context_release_behavior,
    /// set context reset notification. See SDL_GLContextResetNotification; defaults to NO_NOTIFICATION.
    context_reset_notification,
    context_no_error,
    floatbuffers,
    egl_platform
};

/// Possible values to be set for the SDL_GL_CONTEXT_PROFILE_MASK attribute.
pub const GLProfile = packed struct(u32) {
    /// Opengl Core Profile context
    core: bool = false,
    /// Opengl Compatibility Profile context
    compatibility: bool = false,
    /// GLX_CONTEXT_ES2_PROFILE_BIT_EXT
    es: bool = false,
    _reserved: u29 = 0,
    pub fn toInt(self: GLProfile) u32 {
        return @bitCast(self);
    }
};
pub const GLContextFlag = packed struct(u32) {
    debug: bool = false,
    forward_compatible: bool = false,
    robust_access: bool = false,
    reset_isolation: bool = false,
    _reserved: u28 = 0,
    pub fn toInt(self: GLContextFlag) u32 {
        return @bitCast(self);
    }
};
pub const GLContextReleaseFlag = enum(u32) {
    none,
    flush
};
pub const GLContextResetNotification = enum(u32) {
    no_notification,
    lose_context,
};

//////////////////////
// Function prototypes
//////////////////////

extern fn SDL_GetNumVideoDrivers() callconv(.c) c_int;
extern fn SDL_GetVideoDriver(index: c_int) callconv(.c) [*:0]const u8;
extern fn SDL_GetCurrentVideoDriver() callconv(.c) [*:0]const u8;
extern fn SDL_GetSystemTheme() callconv(.c) SystemTheme;
extern fn SDL_GetDisplays(count: ?*c_int) callconv(.c) [*c]DisplayId;
extern fn SDL_GetPrimaryDisplay() callconv(.c) DisplayId;
extern fn SDL_GetDisplayProperties(displayId: DisplayId) callconv(.c) PropertiesId;

pub const PROP_DISPLAY_HDR_ENABLED_BOOLEAN: [*:0]const u8 = "SDL.display.HDR_enabled";
pub const PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER: [*:0]const u8 = "SDL.display.KMSDRM.panel_orientation";
pub const PROP_DISPLAY_WAYLAND_WL_OUTPUT_POINTER: [*:0]const u8 = "SDL.display.wayland.wl_output";
pub const PROP_DISPLAY_WINDOWS_HMONITOR_POINTER: [*:0]const u8 = "SDL.display.windows.hmonitor";

extern fn SDL_GetDisplayName(displayId: DisplayId) callconv(.c) [*:0]const u8;
extern fn SDL_GetDisplayBounds(displayId: DisplayId, rect: ?*Rect) callconv(.c) bool;
extern fn SDL_GetDisplayUsableBounds(displayId: DisplayId, rect: ?*Rect) callconv(.c) bool;
extern fn SDL_GetNaturalDisplayOrientation(displayId: DisplayId) callconv(.c) DisplayOrientation;
extern fn SDL_GetCurrentDisplayOrientation(displayId: DisplayId) callconv(.c) DisplayOrientation;
extern fn SDL_GetDisplayContentScale(displayId: DisplayId) callconv(.c) f32;
extern fn SDL_GetFullscreenDisplayModes(displayId: DisplayId, count: ?*c_int) callconv(.c) ?*?*DisplayMode;
extern fn SDL_GetClosestFullscreenDisplayMode(
    displayId: DisplayId,
    w: c_int,
    h: c_int,
    refresh_rate: f32,
    include_high_density_modes: bool,
    closest: ?*DisplayMode
) callconv(.c) bool;
extern fn SDL_GetDesktopDisplayMode(displayId: DisplayId) callconv(.c) ?*DisplayMode;
extern fn SDL_GetCurrentDisplayMode(displayId: DisplayId) callconv(.c) ?*DisplayMode;
extern fn SDL_GetDisplayForPoint(point: Point) callconv(.c) DisplayId;
extern fn SDL_GetDisplayForRect(rect: Rect) callconv(.c) DisplayId;
extern fn SDL_GetDisplayForWindow(window: Window) callconv(.c) DisplayId;
extern fn SDL_GetWindowPixelDensity(window: Window) callconv(.c) f32;
extern fn SDL_GetWindowDisplayScale(window: Window) callconv(.c) f32;
extern fn SDL_SetWindowFullscreenMode(window: Window, mode: ?*DisplayMode) callconv(.c) bool;
extern fn SDL_GetWindowFullscreenMode(window: Window) callconv(.c) ?*DisplayMode;
extern fn SDL_GetWindowICCProfile(window: Window, size: ?*usize) callconv(.c) ?*anyopaque;
extern fn SDL_GetWindowPixelFormat(window: Window) callconv(.c) u32; // SDL_PixelFormat
extern fn SDL_GetWindows(count: ?*c_int) callconv(.c) ?[*]Window;
extern fn SDL_CreateWindow(
    title: [*:0]const u8,
    w: c_int,
    h: c_int,
    flags: WindowFlags
) callconv(.c) Window;
extern fn SDL_CreatePopupWindow(
    parent: Window, 
    offset_x: c_int,
    offset_y: c_int,
    w: c_int,
    h: c_int,
    flags: WindowFlags,
) callconv(.c) Window;

extern fn SDL_CreateWindowWithProperties(props: u32) callconv(.c) Window;

pub const PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN: [*:0]const u8 = "SDL.window.create.always_on_top";
pub const PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN: [*:0]const u8 = "SDL.window.create.borderless";
pub const PROP_WINDOW_CREATE_CONSTRAIN_POPUP_BOOLEAN: [*:0]const u8 = "SDL.window.create.constrain_popup";
pub const PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN: [*:0]const u8 = "SDL.window.create.focusable";
pub const PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN: [*:0]const u8 = "SDL.window.create.external_graphics_context";
pub const PROP_WINDOW_CREATE_FLAGS_NUMBER: [*:0]const u8 = "SDL.window.create.flags";
pub const PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN: [*:0]const u8 = "SDL.window.create.fullscreen";
pub const PROP_WINDOW_CREATE_HEIGHT_NUMBER: [*:0]const u8 = "SDL.window.create.height";
pub const PROP_WINDOW_CREATE_HIDDEN_BOOLEAN: [*:0]const u8 = "SDL.window.create.hidden";
pub const PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN: [*:0]const u8 = "SDL.window.create.high_pixel_density";
pub const PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN: [*:0]const u8 = "SDL.window.create.maximized";
pub const PROP_WINDOW_CREATE_MENU_BOOLEAN: [*:0]const u8 = "SDL.window.create.menu";
pub const PROP_WINDOW_CREATE_METAL_BOOLEAN: [*:0]const u8 = "SDL.window.create.metal";
pub const PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN: [*:0]const u8 = "SDL.window.create.minimized";
pub const PROP_WINDOW_CREATE_MODAL_BOOLEAN: [*:0]const u8 = "SDL.window.create.modal";
pub const PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN: [*:0]const u8 = "SDL.window.create.mouse_grabbed";
pub const PROP_WINDOW_CREATE_OPENGL_BOOLEAN: [*:0]const u8 = "SDL.window.create.opengl";
pub const PROP_WINDOW_CREATE_PARENT_POINTER: [*:0]const u8 = "SDL.window.create.parent";
pub const PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN: [*:0]const u8 = "SDL.window.create.resizable";
pub const PROP_WINDOW_CREATE_TITLE_STRING: [*:0]const u8 = "SDL.window.create.title";
pub const PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN: [*:0]const u8 = "SDL.window.create.transparent";
pub const PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN: [*:0]const u8 = "SDL.window.create.tooltip";
pub const PROP_WINDOW_CREATE_UTILITY_BOOLEAN: [*:0]const u8 = "SDL.window.create.utility";
pub const PROP_WINDOW_CREATE_VULKAN_BOOLEAN: [*:0]const u8 = "SDL.window.create.vulkan";
pub const PROP_WINDOW_CREATE_WIDTH_NUMBER: [*:0]const u8 = "SDL.window.create.width";
pub const PROP_WINDOW_CREATE_X_NUMBER: [*:0]const u8 = "SDL.window.create.x";
pub const PROP_WINDOW_CREATE_Y_NUMBER: [*:0]const u8 = "SDL.window.create.y";
pub const PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER: [*:0]const u8 = "SDL.window.create.cocoa.window";
pub const PROP_WINDOW_CREATE_COCOA_VIEW_POINTER: [*:0]const u8 = "SDL.window.create.cocoa.view";
pub const PROP_WINDOW_CREATE_WINDOWSCENE_POINTER: [*:0]const u8 = "SDL.window.create.uikit.windowscene";
pub const PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN: [*:0]const u8 = "SDL.window.create.wayland.surface_role_custom";
pub const PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN: [*:0]const u8 = "SDL.window.create.wayland.create_egl_window";
pub const PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER: [*:0]const u8 = "SDL.window.create.wayland.wl_surface";
pub const PROP_WINDOW_CREATE_WIN32_HWND_POINTER: [*:0]const u8 = "SDL.window.create.win32.hwnd";
pub const PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER: [*:0]const u8 = "SDL.window.create.win32.pixel_format_hwnd";
pub const PROP_WINDOW_CREATE_X11_WINDOW_NUMBER: [*:0]const u8 = "SDL.window.create.x11.window";
pub const PROP_WINDOW_CREATE_EMSCRIPTEN_CANVAS_ID_STRING: [*:0]const u8 = "SDL.window.create.emscripten.canvas_id";
pub const PROP_WINDOW_CREATE_EMSCRIPTEN_KEYBOARD_ELEMENT_STRING: [*:0]const u8 = "SDL.window.create.emscripten.keyboard_element";

extern fn SDL_GetWindowID(window: Window) callconv(.c) WindowId;
extern fn SDL_GetWindowFromID(id: WindowId) callconv(.c) Window;
extern fn SDL_GetWindowParent(window: Window) callconv(.c) Window;
extern fn SDL_GetWindowProperties(window: Window) callconv(.c) PropertiesId;

pub const PROP_WINDOW_SHAPE_POINTER: [*:0]const u8 = "SDL.window.shape";
pub const PROP_WINDOW_HDR_ENABLED_BOOLEAN: [*:0]const u8 = "SDL.window.HDR_enabled";
pub const PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT: [*:0]const u8 = "SDL.window.SDR_white_level";
pub const PROP_WINDOW_HDR_HEADROOM_FLOAT: [*:0]const u8 = "SDL.window.HDR_headroom";
pub const PROP_WINDOW_ANDROID_WINDOW_POINTER: [*:0]const u8 = "SDL.window.android.window";
pub const PROP_WINDOW_ANDROID_SURFACE_POINTER: [*:0]const u8 = "SDL.window.android.surface";
pub const PROP_WINDOW_UIKIT_WINDOW_POINTER: [*:0]const u8 = "SDL.window.uikit.window";
pub const PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER: [*:0]const u8 = "SDL.window.uikit.metal_view_tag";
pub const PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER: [*:0]const u8 = "SDL.window.uikit.opengl.framebuffer";
pub const PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER: [*:0]const u8 = "SDL.window.uikit.opengl.renderbuffer";
pub const PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER: [*:0]const u8 = "SDL.window.uikit.opengl.resolve_framebuffer";
pub const PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER: [*:0]const u8 = "SDL.window.kmsdrm.dev_index";
pub const PROP_WINDOW_KMSDRM_DRM_FD_NUMBER: [*:0]const u8 = "SDL.window.kmsdrm.drm_fd";
pub const PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER: [*:0]const u8 = "SDL.window.kmsdrm.gbm_dev";
pub const PROP_WINDOW_COCOA_WINDOW_POINTER: [*:0]const u8 = "SDL.window.cocoa.window";
pub const PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER: [*:0]const u8 = "SDL.window.cocoa.metal_view_tag";
pub const PROP_WINDOW_OPENVR_OVERLAY_ID_NUMBER: [*:0]const u8 = "SDL.window.openvr.overlay_id";
pub const PROP_WINDOW_QNX_WINDOW_POINTER: [*:0]const u8 = "SDL.window.qnx.window";
pub const PROP_WINDOW_QNX_SURFACE_POINTER: [*:0]const u8 = "SDL.window.qnx.surface";
pub const PROP_WINDOW_VIVANTE_DISPLAY_POINTER: [*:0]const u8 = "SDL.window.vivante.display";
pub const PROP_WINDOW_VIVANTE_WINDOW_POINTER: [*:0]const u8 = "SDL.window.vivante.window";
pub const PROP_WINDOW_VIVANTE_SURFACE_POINTER: [*:0]const u8 = "SDL.window.vivante.surface";
pub const PROP_WINDOW_WIN32_HWND_POINTER: [*:0]const u8 = "SDL.window.win32.hwnd";
pub const PROP_WINDOW_WIN32_HDC_POINTER: [*:0]const u8 = "SDL.window.win32.hdc";
pub const PROP_WINDOW_WIN32_INSTANCE_POINTER: [*:0]const u8 = "SDL.window.win32.instance";
pub const PROP_WINDOW_WAYLAND_DISPLAY_POINTER: [*:0]const u8 = "SDL.window.wayland.display";
pub const PROP_WINDOW_WAYLAND_SURFACE_POINTER: [*:0]const u8 = "SDL.window.wayland.surface";
pub const PROP_WINDOW_WAYLAND_VIEWPORT_POINTER: [*:0]const u8 = "SDL.window.wayland.viewport";
pub const PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER: [*:0]const u8 = "SDL.window.wayland.egl_window";
pub const PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER: [*:0]const u8 = "SDL.window.wayland.xdg_surface";
pub const PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER: [*:0]const u8 = "SDL.window.wayland.xdg_toplevel";
pub const PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING: [*:0]const u8 = "SDL.window.wayland.xdg_toplevel_export_handle";
pub const PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER: [*:0]const u8 = "SDL.window.wayland.xdg_popup";
pub const PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER: [*:0]const u8 = "SDL.window.wayland.xdg_positioner";
pub const PROP_WINDOW_X11_DISPLAY_POINTER: [*:0]const u8 = "SDL.window.x11.display";
pub const PROP_WINDOW_X11_SCREEN_NUMBER: [*:0]const u8 = "SDL.window.x11.screen";
pub const PROP_WINDOW_X11_WINDOW_NUMBER: [*:0]const u8 = "SDL.window.x11.window";
pub const PROP_WINDOW_EMSCRIPTEN_CANVAS_ID_STRING: [*:0]const u8 = "SDL.window.emscripten.canvas_id";
pub const PROP_WINDOW_EMSCRIPTEN_KEYBOARD_ELEMENT_STRING: [*:0]const u8 = "SDL.window.emscripten.keyboard_element";

extern fn SDL_GetWindowFlags(window: Window) callconv(.c) WindowFlags;
extern fn SDL_SetWindowTitle(window: Window, title: [*:0]const u8) callconv(.c) bool;
extern fn SDL_GetWindowTitle(window: Window) callconv(.c) [*:0]const u8;
extern fn SDL_SetWindowIcon(window: Window, icon: ?*anyopaque) callconv(.c) bool; // SDL_Surface
extern fn SDL_SetWindowPosition(window: Window, x: c_int, y: c_int) callconv(.c) bool;
extern fn SDL_GetWindowPosition(window: Window, x: ?*c_int, y: ?*c_int) callconv(.c) bool;
extern fn SDL_SetWindowSize(window: Window, w: c_int, h: c_int) callconv(.c) bool;
extern fn SDL_GetWindowSize(window: Window, w: ?*c_int, h: ?*c_int) callconv(.c) bool;
extern fn SDL_GetWindowSafeArea(window: Window, rect: ?*Rect) callconv(.c) bool;
extern fn SDL_SetWindowAspectRatio(window: Window, min_aspect: f32, max_aspect: f32) callconv(.c) bool;
extern fn SDL_GetWindowAspectRatio(window: Window, min_aspect: ?*f32, max_aspect: ?*f32) callconv(.c) bool;
extern fn SDL_GetWindowBordersSize(window: Window, top: ?*c_int, left: ?*c_int, bottom: ?*c_int, right: ?*c_int) callconv(.c) bool;
extern fn SDL_GetWindowSizeInPixels(window: Window, w: ?*c_int, h: ?*c_int) callconv(.c) bool;
extern fn SDL_SetWindowMinimumSize(window: Window, min_w: c_int, min_h: c_int) callconv(.c) bool;
extern fn SDL_GetWindowMinimumSize(window: Window, w: ?*c_int, h: ?*c_int) callconv(.c) bool;
extern fn SDL_SetWindowMaximumSize(window: Window, max_w: c_int, max_h: c_int) callconv(.c) bool;
extern fn SDL_GetWindowMaximumSize(window: Window, w: ?*c_int, h: ?*c_int) callconv(.c) bool;
extern fn SDL_SetWindowBordered(window: Window, bordered: bool) callconv(.c) bool;
extern fn SDL_SetWindowResizable(window: Window, resizable: bool) callconv(.c) bool;
extern fn SDL_SetWindowAlwaysOnTop(window: Window, on_top: bool) callconv(.c) bool;
extern fn SDL_SetWindowFillDocument(window: Window, fill: bool) callconv(.c) bool;
extern fn SDL_ShowWindow(window: Window) callconv(.c) bool;
extern fn SDL_HideWindow(window: Window) callconv(.c) bool;
extern fn SDL_RaiseWindow(window: Window) callconv(.c) bool;
extern fn SDL_MaximizeWindow(window: Window) callconv(.c) bool;
extern fn SDL_MinimizeWindow(window: Window) callconv(.c) bool;
extern fn SDL_RestoreWindow(window: Window) callconv(.c) bool;
extern fn SDL_SetWindowFullscreen(window: Window, fullscreen: bool) callconv(.c) bool;
extern fn SDL_SyncWindow(window: Window) callconv(.c) bool;
extern fn SDL_WindowHasSurface(window: Window) callconv(.c) bool;
extern fn SDL_GetWindowSurface(window: Window) callconv(.c) ?*anyopaque; // SDL_Surface
extern fn SDL_SetWindowSurfaceVSync(window: Window, vsync: c_int) callconv(.c) bool;
pub const WINDOW_SURFACE_VSYNC_DISABLED: c_int = 0;
pub const WINDOW_SURFACE_VSYNC_ADAPTIVE: c_int = -1;
extern fn SDL_GetWindowSurfaceVSync(window: Window, vsync: ?*c_int) callconv(.c) bool;
extern fn SDL_UpdateWindowSurface(window: Window) callconv(.c) bool;
extern fn SDL_UpdateWindowSurfaceRects(window: Window, rects: [*]const Rect, numrects: c_int) callconv(.c) bool;
extern fn SDL_DestroyWindowSurface(window: Window) callconv(.c) bool;
extern fn SDL_SetWindowKeyboardGrab(window: Window, grabbed: bool) callconv(.c) bool;
extern fn SDL_SetWindowMouseGrab(window: Window, grabbed: bool) callconv(.c) bool;
extern fn SDL_GetWindowKeyboardGrab(window: Window) callconv(.c) bool;
extern fn SDL_GetWindowMouseGrab(window: Window) callconv(.c) bool;
extern fn SDL_GetGrabbedWindow() callconv(.c) Window;
extern fn SDL_SetWindowMouseRect(window: Window, rect: ?*const Rect) callconv(.c) bool;
extern fn SDL_GetWindowMouseRect(window: Window) callconv(.c) ?*const Rect;
extern fn SDL_SetWindowOpacity(window: Window, opacity: f32) callconv(.c) bool;
extern fn SDL_GetWindowOpacity(window: Window) callconv(.c) f32;
extern fn SDL_SetWindowParent(window: Window, parent: Window) callconv(.c) bool;
extern fn SDL_SetWindowModal(window: Window, modal: bool) callconv(.c) bool;
extern fn SDL_SetWindowFocusable(window: Window, focusable: bool) callconv(.c) bool;
extern fn SDL_ShowWindowSystemMenu(window: Window, x: c_int, y: c_int) callconv(.c) bool;
pub const HitTestResult = enum(c_int) {
    // Region is normal. No special properties.
    normal,
    // Region can drag entire window.
    draggable,
    // Region is the resizable top-left corner border.
    resize_topleft,
    // Region is the resizable top border.
    resize_top,
    // Region is the resizable top-right corner border.
    resize_topright,
    // Region is the resizable right border.
    resize_right,
    // Region is the resizable bottom-right corner border.
    resize_bottomright,
    // Region is the resizable bottom border.
    resize_bottom,
    // Region is the resizable bottom-left corner border.
    resize_bottomleft,
    // Region is the resizable left border.
    resize_left,
};
pub const HitTest = *const fn (win: Window, area: ?*const Point, data: ?*anyopaque) callconv(.c) HitTestResult;
extern fn SDL_SetWindowHitTest(window: Window, callback: ?HitTest, callback_data: ?*anyopaque) callconv(.c) bool;
extern fn SDL_SetWindowShape(window: Window, shape: ?*anyopaque) callconv(.c) bool; // SDL_Surface
extern fn SDL_FlashWindow(window: Window, operation: FlashOperation) callconv(.c) bool;
extern fn SDL_SetWindowProgressState(window: Window, state: ProgressState) callconv(.c) bool;
extern fn SDL_GetWindowProgressState(window: Window) callconv(.c) ProgressState;
extern fn SDL_SetWindowProgressValue(window: Window, value: f32) callconv(.c) bool;
extern fn SDL_GetWindowProgressValue(window: Window) callconv(.c) f32;
extern fn SDL_DestroyWindow(window: Window) callconv(.c) void;
extern fn SDL_ScreenSaverEnabled() callconv(.c) bool;
extern fn SDL_EnableScreenSaver() callconv(.c) bool;
extern fn SDL_DisableScreenSaver() callconv(.c) bool;
extern fn SDL_GL_LoadLibrary(path: ?[*:0]const u8) callconv(.c) bool;
extern fn SDL_GL_GetProcAddress(proc: [*:0]const u8) callconv(.c) ?*anyopaque;
extern fn SDL_EGL_GetProcAddress(proc: [*:0]const u8) callconv(.c) ?*const fn () callconv(.c) void;
extern fn SDL_GL_UnloadLibrary() callconv(.c) void;
extern fn SDL_GL_ExtensionSupported(extension: [*:0]const u8) callconv(.c) bool;
extern fn SDL_GL_ResetAttributes() callconv(.c) void;
extern fn SDL_GL_SetAttribute(attr: GLAttr, value: c_int) callconv(.c) bool;
extern fn SDL_GL_GetAttribute(attr: GLAttr, value: ?*c_int) callconv(.c) bool;
extern fn SDL_GL_CreateContext(window: Window) callconv(.c) GLContext;
extern fn SDL_GL_MakeCurrent(window: Window, context: GLContext) callconv(.c) bool;
extern fn SDL_GL_GetCurrentWindow() callconv(.c) Window;
extern fn SDL_GL_GetCurrentContext() callconv(.c) GLContext;
extern fn SDL_EGL_GetCurrentDisplay() callconv(.c) EGLDisplay;
extern fn SDL_EGL_GetCurrentConfig() callconv(.c) EGLConfig;
extern fn SDL_EGL_GetWindowSurface(window: Window) callconv(.c) EGLSurface;
extern fn SDL_EGL_SetAttributeCallbacks(
    platformAttribCallback: ?EGLAttribArrayCallback,
    surfaceAttribCallback: ?EGLIntArrayCallback,
    contextAttribCallback: ?EGLIntArrayCallback,
    userdata: ?*anyopaque,
) callconv(.c) void;
extern fn SDL_GL_SetSwapInterval(interval: c_int) callconv(.c) bool;
extern fn SDL_GL_GetSwapInterval(interval: ?*c_int) callconv(.c) bool;
extern fn SDL_GL_SwapWindow(window: Window) callconv(.c) bool;
extern fn SDL_GL_DestroyContext(context: GLContext) callconv(.c) bool;

pub const getNumVideoDrivers = SDL_GetNumVideoDrivers;
pub const getVideoDriver = SDL_GetVideoDriver;
pub const getCurrentVideoDriver = SDL_GetCurrentVideoDriver;
pub const getSystemTheme = SDL_GetSystemTheme;
pub const getDisplays = SDL_GetDisplays;
pub const getPrimaryDisplay = SDL_GetPrimaryDisplay;
pub const getDisplayProperties = SDL_GetDisplayProperties;
pub const getDisplayName = SDL_GetDisplayName;
pub const getDisplayBounds = SDL_GetDisplayBounds;
pub const getDisplayUsableBounds = SDL_GetDisplayUsableBounds;
pub const getNaturalDisplayOrientation = SDL_GetNaturalDisplayOrientation;
pub const getCurrentDisplayOrientation = SDL_GetCurrentDisplayOrientation;
pub const getDisplayContentScale = SDL_GetDisplayContentScale;
pub const getFullscreenDisplayModes = SDL_GetFullscreenDisplayModes;
pub const getClosestFullscreenDisplayMode = SDL_GetClosestFullscreenDisplayMode;
pub const getDesktopDisplayMode = SDL_GetDesktopDisplayMode;
pub const getCurrentDisplayMode = SDL_GetCurrentDisplayMode;
pub const getDisplayForPoint = SDL_GetDisplayForPoint;
pub const getDisplayForRect = SDL_GetDisplayForRect;
pub const getDisplayForWindow = SDL_GetDisplayForWindow;
pub const getWindowPixelDensity = SDL_GetWindowPixelDensity;
pub const getWindowDisplayScale = SDL_GetWindowDisplayScale;
pub const setWindowFullscreenMode = SDL_SetWindowFullscreenMode;
pub const getWindowFullscreenMode = SDL_GetWindowFullscreenMode;
pub const getWindowICCProfile = SDL_GetWindowICCProfile;
pub const getWindowPixelFormat = SDL_GetWindowPixelFormat;
pub const getWindows = SDL_GetWindows;
pub const createWindow = SDL_CreateWindow;
pub const createPopupWindow = SDL_CreatePopupWindow;
pub const createWindowWithProperties = SDL_CreateWindowWithProperties;
pub const getWindowId = SDL_GetWindowID;
pub const getWindowFromId = SDL_GetWindowFromID;
pub const getWindowParent = SDL_GetWindowParent;
pub const getWindowProperties = SDL_GetWindowProperties;
pub const getWindowFlags = SDL_GetWindowFlags;
pub const setWindowTitle = SDL_SetWindowTitle;
pub const getWindowTitle = SDL_GetWindowTitle;
pub const setWindowIcon = SDL_SetWindowIcon;
pub const setWindowPosition = SDL_SetWindowPosition;
pub const getWindowPosition = SDL_GetWindowPosition;
pub const setWindowSize = SDL_SetWindowSize;
pub const getWindowSize = SDL_GetWindowSize;
pub const getWindowSafeArea = SDL_GetWindowSafeArea;
pub const setWindowAspectRatio = SDL_SetWindowAspectRatio;
pub const getWindowAspectRatio = SDL_GetWindowAspectRatio;
pub const getWindowBordersSize = SDL_GetWindowBordersSize;
pub const getWindowSizeInPixels = SDL_GetWindowSizeInPixels;
pub const setWindowMinimumSize = SDL_SetWindowMinimumSize;
pub const getWindowMinimumSize = SDL_GetWindowMinimumSize;
pub const setWindowMaximumSize = SDL_SetWindowMaximumSize;
pub const getWindowMaximumSize = SDL_GetWindowMaximumSize;
pub const setWindowBordered = SDL_SetWindowBordered;
pub const setWindowResizable = SDL_SetWindowResizable;
pub const setWindowAlwaysOnTop = SDL_SetWindowAlwaysOnTop;
pub const setWindowFillDocument = SDL_SetWindowFillDocument;
pub const showWindow = SDL_ShowWindow;
pub const hideWindow = SDL_HideWindow;
pub const raiseWindow = SDL_RaiseWindow;
pub const maximizeWindow = SDL_MaximizeWindow;
pub const minimizeWindow = SDL_MinimizeWindow;
pub const restoreWindow = SDL_RestoreWindow;
pub const setWindowFullscreen = SDL_SetWindowFullscreen;
pub const syncWindow = SDL_SyncWindow;
pub const windowHasSurface = SDL_WindowHasSurface;
pub const getWindowSurface = SDL_GetWindowSurface;
pub const setWindowSurfaceVSync = SDL_SetWindowSurfaceVSync;
pub const getWindowSurfaceVSync = SDL_GetWindowSurfaceVSync;
pub const updateWindowSurface = SDL_UpdateWindowSurface;
pub const updateWindowSurfaceRects = SDL_UpdateWindowSurfaceRects;
pub const destroyWindowSurface = SDL_DestroyWindowSurface;
pub const setWindowKeyboardGrab = SDL_SetWindowKeyboardGrab;
pub const setWindowMouseGrab = SDL_SetWindowMouseGrab;
pub const getWindowKeyboardGrab = SDL_GetWindowKeyboardGrab;
pub const getWindowMouseGrab = SDL_GetWindowMouseGrab;
pub const getGrabbedWindow = SDL_GetGrabbedWindow;
pub const setWindowMouseRect = SDL_SetWindowMouseRect;
pub const getWindowMouseRect = SDL_GetWindowMouseRect;
pub const setWindowOpacity = SDL_SetWindowOpacity;
pub const getWindowOpacity = SDL_GetWindowOpacity;
pub const setWindowParent = SDL_SetWindowParent;
pub const setWindowModal = SDL_SetWindowModal;
pub const setWindowFocusable = SDL_SetWindowFocusable;
pub const showWindowSystemMenu = SDL_ShowWindowSystemMenu;
pub const setWindowHitTest = SDL_SetWindowHitTest;
pub const setWindowShape = SDL_SetWindowShape;
pub const flashWindow = SDL_FlashWindow;
pub const setWindowProgressState = SDL_SetWindowProgressState;
pub const getWindowProgressState = SDL_GetWindowProgressState;
pub const setWindowProgressValue = SDL_SetWindowProgressValue;
pub const getWindowProgressValue = SDL_GetWindowProgressValue;
pub const destroyWindow = SDL_DestroyWindow;
pub const screenSaverEnabled = SDL_ScreenSaverEnabled;
pub const enableScreenSaver = SDL_EnableScreenSaver;
pub const disableScreenSaver = SDL_DisableScreenSaver;
pub const glLoadLibrary = SDL_GL_LoadLibrary;
pub const glGetProcAddress = SDL_GL_GetProcAddress;
pub const eglGetProcAddress = SDL_EGL_GetProcAddress;
pub const glUnloadLibrary = SDL_GL_UnloadLibrary;
pub const glExtensionSupported = SDL_GL_ExtensionSupported;
pub const glResetAttributes = SDL_GL_ResetAttributes;
pub const glSetAttribute = SDL_GL_SetAttribute;
pub const glGetAttribute = SDL_GL_GetAttribute;
pub const glCreateContext = SDL_GL_CreateContext;
pub const glMakeCurrent = SDL_GL_MakeCurrent;
pub const glGetCurrentWindow = SDL_GL_GetCurrentWindow;
pub const glGetCurrentContext = SDL_GL_GetCurrentContext;
pub const eglGetCurrentDisplay = SDL_EGL_GetCurrentDisplay;
pub const eglGetCurrentConfig = SDL_EGL_GetCurrentConfig;
pub const eglGetWindowSurface = SDL_EGL_GetWindowSurface;
pub const eglSetAttributeCallbacks = SDL_EGL_SetAttributeCallbacks;
pub const glSetSwapInterval = SDL_GL_SetSwapInterval;
pub const glGetSwapInterval = SDL_GL_GetSwapInterval;
pub const glSwapWindow = SDL_GL_SwapWindow;

// pixels

pub const ALPHA_OPAQUE: c_int = 255;
pub const ALPHA_OPAQUE_FLOAT: f32 = 1.0;
pub const ALPHA_TRANSPARENT: c_int = 0;
pub const ALPHA_TRANSPARENT_FLOAT: f32 = 0.0;

pub const PixelFormat = pixels.PixelFormat;
pub const ColorSpace = pixels.ColorSpace;
pub const Color = pixels.Color;
pub const FColor = pixels.SDL_FColor;
/// a handle to an SDL_Palette struct
pub const Palette = *pixels.SDL_Palette;
pub const PixelFormatDetails = pixels.SDL_PixelFormatDetails;

pub const GetPixelFormatName = pixels.SDL_GetPixelFormatName;
pub const GetMasksForPixelFormat = pixels.SDL_GetMasksForPixelFormat;
pub const GetPixelFormatForMasks = pixels.SDL_GetPixelFormatForMasks;
pub const GetPixelFormatDetails = pixels.SDL_GetPixelFormatDetails;
pub const CreatePalette = pixels.SDL_CreatePalette;
pub const SetPaletteColors = pixels.SDL_SetPaletteColors;
pub const DestroyPalette = pixels.SDL_DestroyPalette;
pub const MapRGB = pixels.SDL_MapRGB;
pub const MapRGBA = pixels.SDL_MapRGBA;
pub const GetRGB = pixels.SDL_GetRGB;
pub const GetRGBA = pixels.SDL_GetRGBA;

// video

pub const SurfaceFlags = packed struct(u32) {
    preallocated: bool = false,
    lock_needed: bool = false,
    locked: bool = false,
    simd_aligned: bool = false,
    _reserved: u28 = 0,
    pub fn toInt(self: SurfaceFlags) u32 {
        return @bitCast(self);
    }
};
pub const glDestroyContext = SDL_GL_DestroyContext;
pub inline fn mustLock(s: *Surface) bool {
    return s.flags.lock_needed;
}
pub const ScaleMode = enum(c_int) {
    invalid = -1,
    nearest = 0,
    // linear filtering
    linear = 1,
    // nearest pixel sampling with improved scaling for pixel art, available since SDL 3.4.0
    pixel_art = 2,
};
pub const FlipMode = enum(c_int) {
    // Do not flip
    none = 0,
    // flip horizontally
    horizontal = 1,
    // flip vertically
    vertical = 2,
    // flip horizontally and vertically (not a diagonal flip)
    horizontal_and_vertical = 3,
};
const SDL_IOStream = opaque {};
pub const IoStream = *SDL_IOStream;
pub const Surface = extern struct {
    // read-only
    flags: SurfaceFlags,
    // read-only
    format: PixelFormat,
    // read-only
    w: i32,
    // read-only
    h: i32,
    // distance in bytes between rows of pixels, read-only
    pitch: i32,
    // writeable if non-NULL
    pixels: ?*anyopaque,
    // application reference count, used when freeing surface
    refcount: i32,
    reserved: ?*anyopaque,
};
pub const PROP_SURFACE_SDR_WHITE_POINT_FLOAT: [*:0]const u8 = "SDL.surface.SDR_white_point";
pub const PROP_SURFACE_HDR_HEADROOM_FLOAT: [*:0]const u8 = "SDL.surface.HDR_headroom";
pub const PROP_SURFACE_TONEMAP_OPERATOR_STRING: [*:0]const u8 = "SDL.surface.tonemap";
pub const PROP_SURFACE_HOTSPOT_X_NUMBER: [*:0]const u8 = "SDL.surface.hotspot.x";
pub const PROP_SURFACE_HOTSPOT_Y_NUMBER: [*:0]const u8 = "SDL.surface.hotspot.y";
pub const PROP_SURFACE_ROTATION_FLOAT: [*:0]const u8 = "SDL.surface.rotation";

extern fn SDL_CreateSurface(width: i32, height: i32, format: PixelFormat) callconv(.c) ?*Surface;
extern fn SDL_CreateSurfaceFrom(width: i32, height: i32, format: PixelFormat, pixels: ?*anyopaque, pitch: i32) callconv(.c) ?*Surface;
// it is safe to pass null
extern fn SDL_DestroySurface(surface: ?*Surface) callconv(.c) void;
extern fn SDL_GetSurfaceProperties(surface: *Surface) callconv(.c) PropertiesId;
extern fn SDL_SetSurfaceColorspace(surface: *Surface, colorspace: Colorspace) callconv(.c) bool;
// returns unknown colorspace if surface is null
extern fn SDL_GetSurfaceColorspace(surface: ?*Surface) callconv(.c) Colorspace;
extern fn SDL_CreateSurfacePalette(surface: *Surface) callconv(.c) ?*Palette;
extern fn SDL_SetSurfacePalette(surface: *Surface, palette: *Palette) callconv(.c) bool;
extern fn SDL_GetSurfacePalette(surface: *Surface) callconv(.c) ?*Palette;
extern fn SDL_AddSurfaceAlternateImage(surface: *Surface, image: *Surface) callconv(.c) bool;
extern fn SDL_SurfaceHasAlternateImages(surface: *Surface) callconv(.c) bool;
extern fn SDL_GetSurfaceImages(surface: *Surface, count: ?*i32) callconv(.c) ?[*]?*Surface;
extern fn SDL_RemoveSurfaceAlternateImages(surface: *Surface) callconv(.c) void;
extern fn SDL_LockSurface(surface: *Surface) callconv(.c) bool;
extern fn SDL_UnlockSurface(surface: *Surface) callconv(.c) void;
extern fn SDL_LoadSurface_IO(src: IoStream, closeio: bool) callconv(.c) ?*Surface;
extern fn SDL_LoadSurface(file: [*:0]const u8) callconv(.c) ?*Surface;
extern fn SDL_LoadBMP_IO(src: IoStream, closeio: bool) callconv(.c) ?*Surface;
extern fn SDL_LoadBMP(file: [*:0]const u8) callconv(.c) ?*Surface;
extern fn SDL_SaveBMP_IO(surface: *Surface, dst: IoStream, closeio: bool) callconv(.c) bool;
extern fn SDL_SaveBMP(surface: *Surface, file: [*:0]const u8) callconv(.c) bool;
extern fn SDL_LoadPNG_IO(src: IoStream, closeio: bool) callconv(.c) ?*Surface;
extern fn SDL_LoadPNG(file: [*:0]const u8) callconv(.c) ?*Surface;
extern fn SDL_SavePNG_IO(surface: *Surface, dst: IoStream, closeio: bool) callconv(.c) bool;
extern fn SDL_SavePNG(surface: *Surface, file: [*:0]const u8) callconv(.c) bool;
extern fn SDL_LoadJPG_IO(src: IoStream, closeio: bool) callconv(.c) ?*Surface;
extern fn SDL_LoadJPG(file: [*:0]const u8) callconv(.c) ?*Surface;
extern fn SDL_SetSurfaceRLE(surface: *Surface, enabled: bool) callconv(.c) bool;
// it is safe to pass null
extern fn SDL_SurfaceHasRLE(surface: ?*Surface) callconv(.c) bool;
extern fn SDL_SetSurfaceColorKey(surface: *Surface, enabled: bool, key: u32) callconv(.c) bool;
// it is safe to pass null
extern fn SDL_SurfaceHasColorKey(surface: ?*Surface) callconv(.c) bool;
extern fn SDL_GetSurfaceColorKey(surface: *Surface, key: *u32) callconv(.c) bool;
extern fn SDL_SetSurfaceColorMod(surface: *Surface, r: u8, g: u8, b: u8) callconv(.c) bool;
extern fn SDL_GetSurfaceColorMod(surface: *Surface, r: *u8, g: *u8, b: *u8) callconv(.c) bool;
extern fn SDL_SetSurfaceAlphaMod(surface: *Surface, alpha: u8) callconv(.c) bool;
extern fn SDL_GetSurfaceAlphaMod(surface: *Surface, alpha: *u8) callconv(.c) bool;
extern fn SDL_SetSurfaceBlendMode(surface: *Surface, blend_mode: BlendMode) callconv(.c) bool;
extern fn SDL_GetSurfaceBlendMode(surface: *Surface, blend_mode: *BlendMode) callconv(.c) bool;
extern fn SDL_SetSurfaceClipRect(surface: *Surface, rect: ?*const Rect) callconv(.c) bool;
extern fn SDL_GetSurfaceClipRect(surface: *Surface, rect: *Rect) callconv(.c) bool;
extern fn SDL_FlipSurface(surface: *Surface, flip: FlipMode) callconv(.c) bool;
extern fn SDL_RotateSurface(surface: *Surface, angle: f32) callconv(.c) ?*Surface;
extern fn SDL_DuplicateSurface(surface: *Surface) callconv(.c) ?*Surface;
extern fn SDL_ScaleSurface(surface: *Surface, width: i32, height: i32, scale_mode: ScaleMode) callconv(.c) ?*Surface;
extern fn SDL_ConvertSurface(surface: *Surface, format: PixelFormat) callconv(.c) ?*Surface;
extern fn SDL_ConvertSurfaceAndColorspace(surface: *Surface, format: PixelFormat, palette: ?*Palette, colorspace: Colorspace, props: PropertiesId) callconv(.c) ?*Surface;
extern fn SDL_ConvertPixels(width: i32, height: i32, src_format: PixelFormat, src: ?*const anyopaque, src_pitch: i32, dst_format: PixelFormat, dst: ?*anyopaque, dst_pitch: i32) callconv(.c) bool;
extern fn SDL_ConvertPixelsAndColorspace(width: i32, height: i32, src_format: PixelFormat, src_colorspace: Colorspace, src_properties: PropertiesId, src: ?*const anyopaque, src_pitch: i32, dst_format: PixelFormat, dst_colorspace: Colorspace, dst_properties: PropertiesId, dst: ?*anyopaque, dst_pitch: i32) callconv(.c) bool;
extern fn SDL_PremultiplyAlpha(width: i32, height: i32, src_format: PixelFormat, src: ?*const anyopaque, src_pitch: i32, dst_format: PixelFormat, dst: ?*anyopaque, dst_pitch: i32, linear: bool) callconv(.c) bool;
extern fn SDL_PremultiplySurfaceAlpha(surface: *Surface, linear: bool) callconv(.c) bool;
extern fn SDL_ClearSurface(surface: *Surface, r: f32, g: f32, b: f32, a: f32) callconv(.c) bool;
extern fn SDL_FillSurfaceRect(dst: *Surface, rect: ?*const Rect, color: u32) callconv(.c) bool;
extern fn SDL_FillSurfaceRects(dst: *Surface, rects: [*]const Rect, count: i32, color: u32) callconv(.c) bool;
extern fn SDL_BlitSurface(src: *Surface, srcrect: ?*const Rect, dst: *Surface, dstrect: ?*const Rect) callconv(.c) bool;
// input rects must not be null and must already be clipped
extern fn SDL_BlitSurfaceUnchecked(src: *Surface, srcrect: *const Rect, dst: *Surface, dstrect: *const Rect) callconv(.c) bool;
extern fn SDL_BlitSurfaceScaled(src: *Surface, srcrect: ?*const Rect, dst: *Surface, dstrect: ?*const Rect, scale_mode: ScaleMode) callconv(.c) bool;
// input rects must not be null and must already be clipped
extern fn SDL_BlitSurfaceUncheckedScaled(src: *Surface, srcrect: *const Rect, dst: *Surface, dstrect: *const Rect, scale_mode: ScaleMode) callconv(.c) bool;
extern fn SDL_StretchSurface(src: *Surface, srcrect: ?*const Rect, dst: *Surface, dstrect: ?*const Rect, scale_mode: ScaleMode) callconv(.c) bool;
extern fn SDL_BlitSurfaceTiled(src: *Surface, srcrect: ?*const Rect, dst: *Surface, dstrect: ?*const Rect) callconv(.c) bool;
extern fn SDL_BlitSurfaceTiledWithScale(src: *Surface, srcrect: ?*const Rect, scale: f32, scale_mode: ScaleMode, dst: *Surface, dstrect: ?*const Rect) callconv(.c) bool;
extern fn SDL_BlitSurface9Grid(src: *Surface, srcrect: ?*const Rect, left_width: i32, right_width: i32, top_height: i32, bottom_height: i32, scale: f32, scale_mode: ScaleMode, dst: *Surface, dstrect: ?*const Rect) callconv(.c) bool;
extern fn SDL_MapSurfaceRGB(surface: *Surface, r: u8, g: u8, b: u8) callconv(.c) u32;
extern fn SDL_MapSurfaceRGBA(surface: *Surface, r: u8, g: u8, b: u8, a: u8) callconv(.c) u32;
extern fn SDL_ReadSurfacePixel(surface: *Surface, x: i32, y: i32, r: ?*u8, g: ?*u8, b: ?*u8, a: ?*u8) callconv(.c) bool;
extern fn SDL_ReadSurfacePixelFloat(surface: *Surface, x: i32, y: i32, r: ?*f32, g: ?*f32, b: ?*f32, a: ?*f32) callconv(.c) bool;
extern fn SDL_WriteSurfacePixel(surface: *Surface, x: i32, y: i32, r: u8, g: u8, b: u8, a: u8) callconv(.c) bool;
extern fn SDL_WriteSurfacePixelFloat(surface: *Surface, x: i32, y: i32, r: f32, g: f32, b: f32, a: f32) callconv(.c) bool;

pub const createSurface = SDL_CreateSurface;
pub const createSurfaceFrom = SDL_CreateSurfaceFrom;
pub const destroySurface = SDL_DestroySurface;
pub const getSurfaceProperties = SDL_GetSurfaceProperties;
pub const setSurfaceColorspace = SDL_SetSurfaceColorspace;
pub const getSurfaceColorspace = SDL_GetSurfaceColorspace;
pub const createSurfacePalette = SDL_CreateSurfacePalette;
pub const setSurfacePalette = SDL_SetSurfacePalette;
pub const getSurfacePalette = SDL_GetSurfacePalette;
pub const addSurfaceAlternateImage = SDL_AddSurfaceAlternateImage;
pub const surfaceHasAlternateImages = SDL_SurfaceHasAlternateImages;
pub const getSurfaceImages = SDL_GetSurfaceImages;
pub const removeSurfaceAlternateImages = SDL_RemoveSurfaceAlternateImages;
pub const lockSurface = SDL_LockSurface;
pub const unlockSurface = SDL_UnlockSurface;
pub const loadSurfaceIo = SDL_LoadSurface_IO;
pub const loadSurface = SDL_LoadSurface;
pub const loadBmpIo = SDL_LoadBMP_IO;
pub const loadBmp = SDL_LoadBMP;
pub const saveBmpIo = SDL_SaveBMP_IO;
pub const saveBmp = SDL_SaveBMP;
pub const loadPngIo = SDL_LoadPNG_IO;
pub const loadPng = SDL_LoadPNG;
pub const savePngIo = SDL_SavePNG_IO;
pub const savePng = SDL_SavePNG;
pub const loadJpgIo = SDL_LoadJPG_IO;
pub const loadJpg = SDL_LoadJPG;
pub const setSurfaceRle = SDL_SetSurfaceRLE;
pub const surfaceHasRle = SDL_SurfaceHasRLE;
pub const setSurfaceColorKey = SDL_SetSurfaceColorKey;
pub const surfaceHasColorKey = SDL_SurfaceHasColorKey;
pub const getSurfaceColorKey = SDL_GetSurfaceColorKey;
pub const setSurfaceColorMod = SDL_SetSurfaceColorMod;
pub const getSurfaceColorMod = SDL_GetSurfaceColorMod;
pub const setSurfaceAlphaMod = SDL_SetSurfaceAlphaMod;
pub const getSurfaceAlphaMod = SDL_GetSurfaceAlphaMod;
pub const setSurfaceBlendMode = SDL_SetSurfaceBlendMode;
pub const getSurfaceBlendMode = SDL_GetSurfaceBlendMode;
pub const setSurfaceClipRect = SDL_SetSurfaceClipRect;
pub const getSurfaceClipRect = SDL_GetSurfaceClipRect;
pub const flipSurface = SDL_FlipSurface;
pub const rotateSurface = SDL_RotateSurface;
pub const duplicateSurface = SDL_DuplicateSurface;
pub const scaleSurface = SDL_ScaleSurface;
pub const convertSurface = SDL_ConvertSurface;
pub const convertSurfaceAndColorspace = SDL_ConvertSurfaceAndColorspace;
pub const convertPixels = SDL_ConvertPixels;
pub const convertPixelsAndColorspace = SDL_ConvertPixelsAndColorspace;
pub const premultiplyAlpha = SDL_PremultiplyAlpha;
pub const premultiplySurfaceAlpha = SDL_PremultiplySurfaceAlpha;
pub const clearSurface = SDL_ClearSurface;
pub const fillSurfaceRect = SDL_FillSurfaceRect;
pub const fillSurfaceRects = SDL_FillSurfaceRects;
pub const blitSurface = SDL_BlitSurface;
pub const blitSurfaceUnchecked = SDL_BlitSurfaceUnchecked;
pub const blitSurfaceScaled = SDL_BlitSurfaceScaled;
pub const blitSurfaceUncheckedScaled = SDL_BlitSurfaceUncheckedScaled;
pub const stretchSurface = SDL_StretchSurface;
pub const blitSurfaceTiled = SDL_BlitSurfaceTiled;
pub const blitSurfaceTiledWithScale = SDL_BlitSurfaceTiledWithScale;
pub const blitSurface9Grid = SDL_BlitSurface9Grid;
pub const mapSurfaceRgb = SDL_MapSurfaceRGB;
pub const mapSurfaceRgba = SDL_MapSurfaceRGBA;
pub const readSurfacePixel = SDL_ReadSurfacePixel;
pub const readSurfacePixelFloat = SDL_ReadSurfacePixelFloat;
pub const writeSurfacePixel = SDL_WriteSurfacePixel;
pub const writeSurfacePixelFloat = SDL_WriteSurfacePixelFloat;
