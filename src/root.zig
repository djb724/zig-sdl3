pub const init_ = @import("init.zig");
pub const pixels = @import("pixels.zig");
pub const rect = @import("rect.zig");
pub const video = @import("video.zig");

// init

pub const AppResult = init_.AppResult;
pub const MainThreadCallback = init_.MainThreadCallback;
pub const InitFlags = init_.InitFlags;
pub const AppEventFunc = init_.AppEventFunc;
pub const AppInitFunc = init_.AppInitFunc;
pub const AppIterateFunc = init_.AppIterateFunc;
pub const AppQuitFunc = init_.AppQuitFunc;
pub const init = init_.init;
pub const initSubSystem = init_.initSubSystem;
pub const quit = init_.quit;
pub const quitSubSystem = init_.quitSubSystem;
pub const wasInit = init_.wasInit;
pub const isMainThread = init_.isMainThread;
pub const runOnMainThread = init_.runOnMainThread;
pub const setAppMetadata = init_.setAppMetadata;

// pixels

pub const ALPHA_OPAQUE: c_int = 255;
pub const ALPHA_OPAQUE_FLOAT: f32 = 1.0;
pub const ALPHA_TRANSPARENT: c_int = 0;
pub const ALPHA_TRANSPARENT_FLOAT: f32 = 0.0;

pub const PixelFormat = pixels.PixelFormat;
pub const Colorspace = pixels.Colorspace;
pub const Color = pixels.Color;
pub const FColor = pixels.FColor;
/// a handle to an SDL_Palette struct
pub const Palette = pixels.Palette;
pub const PixelFormatDetails = pixels.PixelFormatDetails;

pub const getPixelFormatName = pixels.SDL_GetPixelFormatName;
pub const getMasksForPixelFormat = pixels.getMasksForPixelFormat;
pub const getPixelFormatForMasks = pixels.SDL_GetPixelFormatForMasks;
pub const getPixelFormatDetails = pixels.getPixelFormatDetails;
pub const createPalette = pixels.createPalette;
pub const setPaletteColors = pixels.setPaletteColors;
pub const destroyPalette = pixels.SDL_DestroyPalette;
pub const mapRGB = pixels.SDL_MapRGB;
pub const mapRGBA = pixels.SDL_MapRGBA;
pub const getRGB = pixels.SDL_GetRGB;
pub const getRGBA = pixels.SDL_GetRGBA;

// rect

pub const Point = rect.Point;
pub const FPoint = rect.FPoint;
pub const Rect = rect.Rect;
pub const FRect = rect.FRect;
pub const Line = rect.Line;
pub const FLine = rect.FLine;
pub const rectToFRect = rect.rectToFRect;
pub const pointInRect = rect.pointInRect;
pub const rectEmpty = rect.rectEmpty;
pub const rectsEqual = rect.rectsEqual;
pub const hasRectIntersection = rect.hasRectIntersection;
pub const getRectIntersection = rect.getRectIntersection;
pub const getRectUnion = rect.getRectUnion;
pub const getRectEnclosingPoints = rect.getRectEnclosingPoints;
pub const getRectAndLineIntersection = rect.getRectAndLineIntersection;
pub const pointInRectFloat = rect.pointInRectFloat;
pub const rectEmptyFloat = rect.rectEmptyFloat;
pub const rectsEqualEpsilon = rect.rectsEqualEpsilon;
pub const rectsEqualFloat = rect.rectsEqualFloat;
pub const hasRectIntersectionFloat = rect.hasRectIntersectionFloat;
pub const getRectIntersectionFloat = rect.getRectIntersectionFloat;
pub const getRectUnionFloat = rect.getRectUnionFloat;
pub const getRectEnclosingPointsFloat = rect.getRectEnclosingPointsFloat;
pub const getRectAndLineIntersectionFloat = rect.getRectAndLineIntersectionFloat;

// video

pub const DisplayId = video.DisplayId;
pub const WindowId = video.WindowId;
pub const PropertiesId = video.PropertiesId;
pub const SystemTheme = video.SystemTheme;
pub const DisplayMode = video.DisplayMode;
pub const DisplayOrientation = video.DisplayOrientation;
pub const Window = video.Window;
pub const WindowFlags = video.WindowFlags;
pub const WindowPosition = video.WindowPosition;
pub const FlashOperation = video.FlashOperation;
pub const ProgressState = video.ProgressState;
pub const Size = video.Size;
pub const Position = video.Position;
pub const BorderSize = video.BorderSize;
pub const AspectRatio = video.AspectRatio;
pub const DisplayList = video.DisplayList;
pub const DisplayModeList = video.DisplayModeList;
pub const WindowList = video.WindowList;

pub const getSystemTheme = video.getSystemTheme;
pub const getDisplays = video.getDisplays;
pub const getPrimaryDisplay = video.getPrimaryDisplay;
pub const getDisplayProperties = video.getDisplayProperties;
pub const getDisplayName = video.getDisplayName;
pub const getDisplayBounds = video.getDisplayBounds;
pub const getDisplayUsableBounds = video.getDisplayUsableBounds;
pub const getNaturalDisplayOrientation = video.getNaturalDisplayOrientation;
pub const getCurrentDisplayOrientation = video.getCurrentDisplayOrientation;
pub const getDisplayContentScale = video.getDisplayContentScale;
pub const getFullscreenDisplayModes = video.getFullscreenDisplayModes;
pub const getClosestFullscreenDisplayMode = video.getClosestFullscreenDisplayMode;
pub const getDesktopDisplayMode = video.getDesktopDisplayMode;
pub const getCurrentDisplayMode = video.getCurrentDisplayMode;
pub const getDisplayForPoint = video.getDisplayForPoint;
pub const getDisplayForRect = video.getDisplayForRect;
pub const getDisplayForWindow = video.getDisplayForWindow;
pub const getWindowPixelDensity = video.getWindowPixelDensity;
pub const getWindowDisplayScale = video.getWindowDisplayScale;
pub const setWindowFullscreenMode = video.setWindowFullscreenMode;
pub const getWindowFullscreenMode = video.getWindowFullscreenMode;
pub const getWindowPixelFormat = video.getWindowPixelFormat;
pub const getWindows = video.getWindows;
pub const createWindow = video.createWindow;
pub const createPopupWindow = video.createPopupWindow;
pub const getWindowId = video.getWindowId;
pub const getWindowFromId = video.getWindowFromId;
pub const getWindowParent = video.getWindowParent;
pub const getWindowProperties = video.getWindowProperties;
pub const getWindowFlags = video.getWindowFlags;
pub const setWindowTitle = video.setWindowTitle;
pub const getWindowTitle = video.getWindowTitle;
pub const setWindowPosition = video.setWindowPosition;
pub const getWindowPosition = video.getWindowPosition;
pub const setWindowSize = video.setWindowSize;
pub const getWindowSize = video.getWindowSize;
pub const getWindowSafeArea = video.getWindowSafeArea;
pub const setWindowAspectRatio = video.setWindowAspectRatio;
pub const getWindowAspectRatio = video.getWindowAspectRatio;
pub const getWindowBordersSize = video.getWindowBordersSize;
pub const getWindowSizeInPixels = video.getWindowSizeInPixels;
pub const setWindowMinimumSize = video.setWindowMinimumSize;
pub const getWindowMinimumSize = video.getWindowMinimumSize;
pub const setWindowMaximumSize = video.setWindowMaximumSize;
pub const getWindowMaximumSize = video.getWindowMaximumSize;
pub const setWindowBordered = video.setWindowBordered;
pub const setWindowResizable = video.setWindowResizable;
pub const setWindowAlwaysOnTop = video.setWindowAlwaysOnTop;
pub const setWindowFillDocument = video.setWindowFillDocument;
pub const showWindow = video.showWindow;
pub const hideWindow = video.hideWindow;
pub const raiseWindow = video.raiseWindow;
pub const maximizeWindow = video.maximizeWindow;
pub const minimizeWindow = video.minimizeWindow;
pub const restoreWindow = video.restoreWindow;
pub const setWindowFullscreen = video.setWindowFullscreen;
pub const syncWindow = video.syncWindow;
pub const setWindowKeyboardGrab = video.setWindowKeyboardGrab;
pub const setWindowMouseGrab = video.setWindowMouseGrab;
pub const getWindowKeyboardGrab = video.getWindowKeyboardGrab;
pub const getWindowMouseGrab = video.getWindowMouseGrab;
pub const getGrabbedWindow = video.getGrabbedWindow;
pub const setWindowMouseRect = video.setWindowMouseRect;
pub const getWindowMouseRect = video.getWindowMouseRect;
pub const setWindowOpacity = video.setWindowOpacity;
pub const getWindowOpacity = video.getWindowOpacity;
pub const setWindowParent = video.setWindowParent;
pub const setWindowModal = video.setWindowModal;
pub const setWindowFocusable = video.setWindowFocusable;
pub const showWindowSystemMenu = video.showWindowSystemMenu;
pub const flashWindow = video.flashWindow;
pub const setWindowProgressState = video.setWindowProgressState;
pub const getWindowProgressState = video.getWindowProgressState;
pub const setWindowProgressValue = video.setWindowProgressValue;
pub const getWindowProgressValue = video.getWindowProgressValue;
pub const destroyWindow = video.destroyWindow;

