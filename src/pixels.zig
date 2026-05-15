//! # CategoryPixels
//!
//! SDL offers facilities for pixel management.
//!
//! Largely these facilities deal with pixel _format_: what does this set of
//! bits represent?
//!
//! If you mostly want to think of a pixel as some combination of red, green,
//! blue, and maybe alpha intensities, this is all pretty straightforward, and
//! in many cases, is enough information to build a perfectly fine game.
//!
//! However, the actual definition of a pixel is more complex than that:
//!
//! Pixels are a representation of a color in a particular color space.
//!
//! The first characteristic of a color space is the color type. SDL
//! understands two different color types, RGB and YCbCr, or in SDL also
//! referred to as YUV.
//!
//! RGB colors consist of red, green, and blue channels of color that are added
//! together to represent the colors we see on the screen.
//!
//! https://en.wikipedia.org/wiki/RGB_color_model
//!
//! YCbCr colors represent colors as a Y luma brightness component and red and
//! blue chroma color offsets. This color representation takes advantage of the
//! fact that the human eye is more sensitive to brightness than the color in
//! an image. The Cb and Cr components are often compressed and have lower
//! resolution than the luma component.
//!
//! https://en.wikipedia.org/wiki/YCbCr
//!
//! When the color information in YCbCr is compressed, the Y pixels are left at
//! full resolution and each Cr and Cb pixel represents an average of the color
//! information in a block of Y pixels. The chroma location determines where in
//! that block of pixels the color information is coming from.
//!
//! The color range defines how much of the pixel to use when converting a
//! pixel into a color on the display. When the full color range is used, the
//! entire numeric range of the pixel bits is significant. When narrow color
//! range is used, for historical reasons, the pixel uses only a portion of the
//! numeric range to represent colors.
//!
//! The color primaries and white point are a definition of the colors in the
//! color space relative to the standard XYZ color space.
//!
//! https://en.wikipedia.org/wiki/CIE_1931_color_space
//!
//! The transfer characteristic, or opto-electrical transfer function (OETF),
//! is the way a color is converted from mathematically linear space into a
//! non-linear output signals.
//!
//! https://en.wikipedia.org/wiki/Rec._709#Transfer_characteristics
//!
//! The matrix coefficients are used to convert between YCbCr and RGB colors.

pub const PixelType = enum(u4) {
    unknown,
    index1,
    index4,
    index8,
    packed8,
    packed16,
    packed32,
    array_u8,
    array_u16,
    array_u32,
    array_f16,
    array_f32,
    // at the end for compatibility with sdl2-compat
    index2,
};
pub const BitmapOrder = enum(u4) {
    none,
    @"4321",
    @"1234",
};
pub const PackedOrder = enum(u4) {
    none,
    xrgb,
    rgbx,
    argb,
    rgba,
    xbgr,
    bgrx,
    abgr,
    bgra,
};
pub const ArrayOrder = enum(u4) {
    none,
    rgb,
    rgba,
    argb,
    bgr,
    bgra,
    abgr,
};
pub const PackedLayout = enum(u4) {
    none,
    @"332",
    @"4444",
    @"1555",
    @"5551",
    @"565",
    @"8888",
    @"2101010",
    @"1010102",
};
pub const PixelFlag = enum(u4) {
    four_cc = 0,
    non_four_cc = 1,
};

pub const PixelFormatFourCC = packed struct(u32) {
    abcd: [4]u8,
    const yv12: PixelFormatFourCC = @bitCast(0x32315659);
    const iyuv: PixelFormatFourCC = @bitCast(0x56555949);
    const yuy2: PixelFormatFourCC = @bitCast(0x32595559);
    const uyvy: PixelFormatFourCC = @bitCast(0x59565955);
    const yvyu: PixelFormatFourCC = @bitCast(0x55595659);
    const nv12: PixelFormatFourCC = @bitCast(0x3231564e);
    const nv21: PixelFormatFourCC = @bitCast(0x3132564e);
    const p010: PixelFormatFourCC = @bitCast(0x30313050);
    const external_oes: PixelFormatFourCC = @bitCast(0x2053454f);
    const mjpg: PixelFormatFourCC = @bitCast(0x47504a4d);
};
pub const PixelFormatNonFourCC = packed struct(u32) {
    bytes: u8,
    bits: u8,
    layout: PackedLayout,
    order: union {
        bitmap_order: BitmapOrder,
        packed_order: PackedOrder,
        array_order: ArrayOrder,
    },
    @"type": PixelType,
    // specifies that this is non-FourCC
    flag: PixelFlag = .non_four_cc,

    const unknown: PixelFormatNonFourCC = @bitCast(0);
    const index1lsb: PixelFormatNonFourCC = @bitCast(0x11100100);
    const index1msb: PixelFormatNonFourCC = @bitCast(0x11200100);
    const index2lsb: PixelFormatNonFourCC = @bitCast(0x1c100200);
    const index2msb: PixelFormatNonFourCC = @bitCast(0x1c200200);
    const index4lsb: PixelFormatNonFourCC = @bitCast(0x12100400);
    const index4msb: PixelFormatNonFourCC = @bitCast(0x12200400);
    const index8: PixelFormatNonFourCC = @bitCast(0x13000801);
    const rgb332: PixelFormatNonFourCC = @bitCast(0x14110801);
    const xrgb4444: PixelFormatNonFourCC = @bitCast(0x15120c02);
    const xbgr4444: PixelFormatNonFourCC = @bitCast(0x15520c02);
    const xrgb1555: PixelFormatNonFourCC = @bitCast(0x15130f02);
    const xbgr1555: PixelFormatNonFourCC = @bitCast(0x15530f02);
    const argb4444: PixelFormatNonFourCC = @bitCast(0x15321002);
    const rgba4444: PixelFormatNonFourCC = @bitCast(0x15421002);
    const abgr4444: PixelFormatNonFourCC = @bitCast(0x15721002);
    const bgra4444: PixelFormatNonFourCC = @bitCast(0x15821002);
    const argb1555: PixelFormatNonFourCC = @bitCast(0x15331002);
    const rgba5551: PixelFormatNonFourCC = @bitCast(0x15441002);
    const abgr1555: PixelFormatNonFourCC = @bitCast(0x15731002);
    const bgra5551: PixelFormatNonFourCC = @bitCast(0x15841002);
    const rgb565: PixelFormatNonFourCC = @bitCast(0x15151002);
    const bgr565: PixelFormatNonFourCC = @bitCast(0x15551002);
    const rgb24: PixelFormatNonFourCC = @bitCast(0x17101803);
    const bgr24: PixelFormatNonFourCC = @bitCast(0x17401803);
    const xrgb8888: PixelFormatNonFourCC = @bitCast(0x16161804);
    const rgbx8888: PixelFormatNonFourCC = @bitCast(0x16261804);
    const xbgr8888: PixelFormatNonFourCC = @bitCast(0x16561804);
    const bgrx8888: PixelFormatNonFourCC = @bitCast(0x16661804);
    const argb8888: PixelFormatNonFourCC = @bitCast(0x16362004);
    const rgba8888: PixelFormatNonFourCC = @bitCast(0x16462004);
    const abgr8888: PixelFormatNonFourCC = @bitCast(0x16762004);
    const bgra8888: PixelFormatNonFourCC = @bitCast(0x16862004);
    const xrgb2101010: PixelFormatNonFourCC = @bitCast(0x16172004);
    const xbgr2101010: PixelFormatNonFourCC = @bitCast(0x16572004);
    const argb2101010: PixelFormatNonFourCC = @bitCast(0x16372004);
    const abgr2101010: PixelFormatNonFourCC = @bitCast(0x16772004);
    const rgb48: PixelFormatNonFourCC = @bitCast(0x18103006);
    const bgr48: PixelFormatNonFourCC = @bitCast(0x18403006);
    const rgba64: PixelFormatNonFourCC = @bitCast(0x18204008);
    const argb64: PixelFormatNonFourCC = @bitCast(0x18304008);
    const bgra64: PixelFormatNonFourCC = @bitCast(0x18504008);
    const abgr64: PixelFormatNonFourCC = @bitCast(0x18604008);
    const rgb48_float: PixelFormatNonFourCC = @bitCast(0x1a103006);
    const bgr48_float: PixelFormatNonFourCC = @bitCast(0x1a403006);
    const rgba64_float: PixelFormatNonFourCC = @bitCast(0x1a204008);
    const argb64_float: PixelFormatNonFourCC = @bitCast(0x1a304008);
    const bgra64_float: PixelFormatNonFourCC = @bitCast(0x1a504008);
    const abgr64_float: PixelFormatNonFourCC = @bitCast(0x1a604008);
    const rgb96_float: PixelFormatNonFourCC = @bitCast(0x1b10600c);
    const bgr96_float: PixelFormatNonFourCC = @bitCast(0x1b40600c);
    const rgba128_float: PixelFormatNonFourCC = @bitCast(0x1b208010);
    const argb128_float: PixelFormatNonFourCC = @bitCast(0x1b308010);
    const bgra128_float: PixelFormatNonFourCC = @bitCast(0x1b508010);
    const abgr128_float: PixelFormatNonFourCC = @bitCast(0x1b608010);
};

/// Pixel format.
///
/// SDL's pixel formats have the following naming convention:
///
/// - Names with a list of components and a single bit count, such as RGB24 and
///   ABGR32, define a platform-independent encoding into bytes in the order
///   specified. For example, in RGB24 data, each pixel is encoded in 3 bytes
///   (red, green, blue) in that order, and in ABGR32 data, each pixel is
///   encoded in 4 bytes (alpha, blue, green, red) in that order. Use these
///   names if the property of a format that is important to you is the order
///   of the bytes in memory or on disk.
/// - Names with a bit count per component, such as ARGB8888 and XRGB1555, are
///   "packed" into an appropriately-sized integer in the platform's native
///   endianness. For example, ARGB8888 is a sequence of 32-bit integers; in
///   each integer, the most significant bits are alpha, and the least
///   significant bits are blue. On a little-endian CPU such as x86, the least
///   significant bits of each integer are arranged first in memory, but on a
///   big-endian CPU such as s390x, the most significant bits are arranged
///   first. Use these names if the property of a format that is important to
///   you is the meaning of each bit position within a native-endianness
///   integer.
/// - In indexed formats such as INDEX4LSB, each pixel is represented by
///   encoding an index into the palette into the indicated number of bits,
///   with multiple pixels packed into each byte if appropriate. In LSB
///   formats, the first (leftmost) pixel is stored in the least-significant
///   bits of the byte; in MSB formats, it's stored in the most-significant
///   bits. INDEX8 does not need LSB/MSB variants, because each pixel exactly
///   fills one byte.
///
/// The 32-bit byte-array encodings such as RGBA32 are aliases for the
/// appropriate 8888 encoding for the current platform. For example, RGBA32 is
/// an alias for ABGR8888 on little-endian CPUs like x86, or an alias for
/// RGBA8888 on big-endian CPUs.
pub const PixelFormat = union {
    four_cc: PixelFormatFourCC,
    non_four_cc: PixelFormatNonFourCC,

    pub fn toInt(self: PixelFormat) u32 {
        return @bitCast(self);
    }
    pub inline fn isFourCC(self: PixelFormat) bool {
        const format: u32 = @bitCast(self);
        return (format & 0xF0000000) == 0x10000000;
    }
    pub inline fn bytesPerPixel(self: PixelFormat) u32 {
        if (self.isFourCC()) {
            const four_cc: PixelFormatFourCC = @bitCast(self);
            if ((four_cc == PixelFormatFourCC.yuy2) or
                (four_cc == PixelFormatFourCC.uyvy) or
                (four_cc == PixelFormatFourCC.yvyu) or
                (four_cc == PixelFormatFourCC.p010)) {
                return 2;
            } else {
                return 1;
            }
        } else {
            const non_four_cc: PixelFormatNonFourCC = @bitCast(self);
            return non_four_cc.bytes;
        }
    }
    pub inline fn isIndexed(self: PixelFormat) bool {
        if (self.isFourCC()) return false;
        const format: PixelFormatNonFourCC = @bitCast(self);
        return format.@"type" == .index1 or format.@"type" == .index2 or format.@"type" == .index4 or format.@"type" == .index8;
    }
    pub inline fn isPacked(self: PixelFormat) bool {
        if (self.isFourCC()) return false;
        const format: PixelFormatNonFourCC = @bitCast(self);
        return format.@"type" == .packed8 or format.@"type" == .packed16 or format.@"type" == .packed32;
    }
    pub inline fn isArray(self: PixelFormat) bool {
        if (self.isFourCC()) return false;
        const format: PixelFormatNonFourCC = @bitCast(self);
        return format.@"type" == .array_u8 or format.@"type" == .array_u16 or format.@"type" == .array_u32 or
            format.@"type" == .array_f16 or format.@"type" == .array_f32;
    }
    pub inline fn is10Bit(self: PixelFormat) bool {
        if (self.isFourCC()) return false;
        const format: PixelFormatNonFourCC = @bitCast(self);
        return format.@"type" == .packed32 and format.layout == .@"2101010";
    }
    pub inline fn isFloat(self: PixelFormat) bool {
        if (self.isFourCC()) return false;
        const format: PixelFormatNonFourCC = @bitCast(self);
        return format.@"type" == .array_f16 or format.@"type" == .array_f32;
    }
    pub inline fn isAlpha(self: PixelFormat) bool {
        if (self.isFourCC()) return false;
        const format: PixelFormatNonFourCC = @bitCast(self);
        if (self.isPacked()) {
            return format.order.packed_order == PackedOrder.argb or format.order.packed_order == PackedOrder.rgba or
                format.order.packed_order == PackedOrder.abgr or format.order.packed_order == PackedOrder.bgra;
        } else if (self.isArray()) {
            return format.order.array_order == ArrayOrder.argb or format.order.array_order == ArrayOrder.rgba or 
                format.order.array_order == ArrayOrder.abgr or format.order.array_order == ArrayOrder.bgra;
        }
        return false;
    }

    const unknown: PixelFormat = @bitCast(0);

    const yv12: PixelFormat = .{ .four_cc = PixelFormatFourCC.yv12 };
    const iyuv: PixelFormat = .{ .four_cc = PixelFormatFourCC.iyuv };
    const yuy2: PixelFormat = .{ .four_cc = PixelFormatFourCC.yuy2 };
    const uyvy: PixelFormat = .{ .four_cc = PixelFormatFourCC.uyvy };
    const yvyu: PixelFormat = .{ .four_cc = PixelFormatFourCC.yvyu };
    const nv12: PixelFormat = .{ .four_cc = PixelFormatFourCC.nv12 };
    const nv21: PixelFormat = .{ .four_cc = PixelFormatFourCC.nv21 };
    const p010: PixelFormat = .{ .four_cc = PixelFormatFourCC.p010 };
    const external_oes: PixelFormat = .{ .four_cc = PixelFormatFourCC.external_oes };
    const mjpg: PixelFormat = .{ .four_cc = PixelFormatFourCC.mjpg };

    const index1lsb: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.index1lsb };
    const index1msb: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.index1msb };
    const index2lsb: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.index2lsb };
    const index2msb: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.index2msb };
    const index4lsb: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.index4lsb };
    const index4msb: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.index4msb };
    const index8: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.index8 };
    const rgb332: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgb332 };
    const xrgb4444: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xrgb4444 };
    const xbgr4444: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xbgr4444 };
    const xrgb1555: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xrgb1555 };
    const xbgr1555: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xbgr1555 };
    const argb4444: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.argb4444 };
    const rgba4444: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgba4444 };
    const abgr4444: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.abgr4444 };
    const bgra4444: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgra4444 };
    const argb1555: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.argb1555 };
    const rgba5551: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgba5551 };
    const abgr1555: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.abgr1555 };
    const bgra5551: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgra5551 };
    const rgb565: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgb565 };
    const bgr565: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgr565 };
    const rgb24: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgb24 };
    const bgr24: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgr24 };
    const xrgb8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xrgb8888 };
    const rgbx8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgbx8888 };
    const xbgr8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xbgr8888 };
    const bgrx8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgrx8888 };
    const argb8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.argb8888 };
    const rgba8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgba8888 };
    const abgr8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.abgr8888 };
    const bgra8888: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgra8888 };
    const xrgb2101010: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xrgb2101010 };
    const xbgr2101010: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.xbgr2101010 };
    const argb2101010: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.argb2101010 };
    const abgr2101010: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.abgr2101010 };
    const rgb48: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgb48 };
    const bgr48: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgr48 };
    const rgba64: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgba64 };
    const argb64: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.argb64 };
    const bgra64: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgra64 };
    const abgr64: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.abgr64 };
    const rgb48_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgb48_float };
    const bgr48_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgr48_float };
    const rgba64_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgba64_float };
    const argb64_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.argb64_float };
    const bgra64_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgra64_float };
    const abgr64_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.abgr64_float };
    const rgb96_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgb96_float };
    const bgr96_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgr96_float };
    const rgba128_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.rgba128_float };
    const argb128_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.argb128_float };
    const bgra128_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.bgra128_float };
    const abgr128_float: PixelFormat = .{ .non_four_cc = PixelFormatNonFourCC.abgr128_float };
};

// TODO: add these
// #if SDL_BYTEORDER == SDL_BIG_ENDIAN
// SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_RGBA8888,
// SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_ARGB8888,
// SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_BGRA8888,
// SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_ABGR8888,
// SDL_PIXELFORMAT_RGBX32 = SDL_PIXELFORMAT_RGBX8888,
// SDL_PIXELFORMAT_XRGB32 = SDL_PIXELFORMAT_XRGB8888,
// SDL_PIXELFORMAT_BGRX32 = SDL_PIXELFORMAT_BGRX8888,
// SDL_PIXELFORMAT_XBGR32 = SDL_PIXELFORMAT_XBGR8888
// #else
// SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_ABGR8888,
// SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_BGRA8888,
// SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_ARGB8888,
// SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_RGBA8888,
// SDL_PIXELFORMAT_RGBX32 = SDL_PIXELFORMAT_XBGR8888,
// SDL_PIXELFORMAT_XRGB32 = SDL_PIXELFORMAT_BGRX8888,
// SDL_PIXELFORMAT_BGRX32 = SDL_PIXELFORMAT_XRGB8888,
// SDL_PIXELFORMAT_XBGR32 = SDL_PIXELFORMAT_RGBX8888
// #endif

pub const ColorType = enum(u4) {
    unknown,
    rgb,
    ycbcr,
};
pub const ColorRange = enum(u4) {
    unknown,
    limited,
    full,
};
pub const ColorPrimaries = enum(u5) {
    unknown = 0,
    bt709 = 1,
    unspecified = 2,
    bt470m = 4,
    bt470bg = 5,
    bt601 = 6,
    smpte240 = 7,
    generic_film = 8,
    bt2020 = 9,
    xyz = 10,
    smpte431 = 11,
    smpte432 = 12,
    ebu3213 = 22,
    custom = 31
};
pub const TransferCharacteristics = enum(u5) {
    unknown = 0,
    bt709 = 1,
    unspecified = 2,
    gamma22 = 4,
    gamma28 = 5,
    bt601 = 6,
    smpte240 = 7,
    linear = 8,
    log100 = 9,
    log100_sqrt10 = 10,
    iec61966 = 11,
    bt1361 = 12,
    srgb = 13,
    bt2020_10bit = 14,
    bt2020_12bit = 15,
    pq = 16,
    smpte428 = 17,
    hlg = 18,
    custom = 31
};
pub const MatrixCoefficients = enum(u5) {
    identity = 0,
    bt709 = 1,
    unspecified = 2,
    fcc = 4,
    bt470bg = 5,
    bt601 = 6,
    smpte240 = 7,
    ycgco = 8,
    bt2020_ncl = 9,
    bt2020_cl = 10,
    smpte2085 = 11,
    chroma_derived_ncl = 12,
    chroma_derived_cl = 13,
    ictcp = 14,
    custom = 31
};
pub const ChromaLocation = enum(u4) {
    none,
    left,
    center,
    top_left,
};
/// packed struct representing the ColorSpace enum contents
pub const ColorSpace = packed struct(u32) {
    matrix: MatrixCoefficients,
    transfer: TransferCharacteristics,
    primaries: ColorPrimaries,
    _reserved: u5 = 0,
    chroma: ChromaLocation,
    range: ColorRange,
    @"type": ColorType,

    const unknown: ColorSpace = @bitCast(0);
    const srgb: ColorSpace = .{
        .@"type" = .rgb,
        .range = .full,
        .primaries = .bt709,
        .transfer = .srgb,
        .matrix = .identity,
        .chroma = .none,
    };
    const srgb_linear: ColorSpace = .{
        .@"type" = .rgb,
        .range = .full,
        .primaries = .bt709,
        .transfer = .linear,
        .matrix = .identity,
        .chroma = .none,
    };
    const hdr10: ColorSpace = .{
        .@"type" = .rgb,
        .range = .full,
        .primaries = .bt2020,
        .transfer = .pq,
        .matrix = .identity,
        .chroma = .none,
    };
    const jpeg: ColorSpace = .{
        .@"type" = .ycbcr,
        .range = .full,
        .primaries = .bt709,
        .transfer = .bt601,
        .matrix = .bt601,
        .chroma = .none
    };
    const bt601_limited: ColorSpace = .{
        .@"type" = .ycbcr,
        .range = .limited,
        .primaries = .bt601,
        .transfer = .bt601,
        .matrix = .bt601,
        .chroma = .left,
    };
    const bt601_full: ColorSpace = .{
        .@"type" = .ycbcr,
        .range = .full,
        .primaries = .bt601,
        .transfer = .bt601,
        .matrix = .bt601,
        .chroma = .left,
    };
    const bt709_limited: ColorSpace = .{
        .@"type" = .ycbcr,
        .range = .limited,
        .primaries = .bt709,
        .transfer = .bt709,
        .matrix = .bt709,
        .chroma = .left,
    };
    const bt709_full: ColorSpace = .{
        .@"type" = .ycbcr,
        .range = .full,
        .primaries = .bt709,
        .transfer = .bt709,
        .matrix = .bt709,
        .chroma = .left,
    };
    const bt2020_limited: ColorSpace = .{
        .@"type" = .ycbcr,
        .range = .limited,
        .primaries = .bt2020,
        .transfer = .pq,
        .matrix = .bt2020_ncl,
        .chroma = .left,
    };
    const bt2020_full: ColorSpace = .{
        .@"type" = .ycbcr,
        .range = .full,
        .primaries = .bt2020,
        .transfer = .pq,
        .matrix = .bt2020_ncl,
        .chroma = .left,
    };
    const rgb_default = ColorSpace.srgb;
    const yuv_default = ColorSpace.bt601_limited;

    pub inline fn isMatrixBt601(cspace: ColorSpace) bool {
        return cspace.matrix == .bt601 or cspace.matrix == .bt470bg;
    }
    pub inline fn isMatrixBt709(cspace: ColorSpace) bool {
        return cspace.matrix == .bt709;
    }
    pub inline fn isMatrixBt2020Ncl(cspace: ColorSpace) bool {
        return cspace.matrix == .bt2020_ncl;
    }
    pub inline fn isLimitedRange(cspace: ColorSpace) bool {
        return cspace.range != .full;
    }
    pub inline fn isFullRange(cspace: ColorSpace) bool {
        return cspace.range == .full;
    }
};

pub const Color = packed struct(u32) {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};
pub const SDL_FColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
pub const SDL_Palette = extern struct {
    ncolors: c_int,
    colors: [*]Color,
    version: u32,
    refcount: c_int,
};
pub const SDL_PixelFormatDetails = extern struct {
    format: PixelFormat,
    bits_per_pixel: u8,
    bytes_per_pixel: u8,
    padding: [2]u8,
    r_mask: u32,
    g_mask: u32,
    b_mask: u32,
    a_mask: u32,
    r_bits: u8,
    g_bits: u8,
    b_bits: u8,
    a_bits: u8,
    r_shift: u8,
    g_shift: u8,
    b_shift: u8,
    a_shift: u8,
};

pub extern fn SDL_GetPixelFormatName(format: PixelFormat) [*:0]const u8;
pub extern fn SDL_GetMasksForPixelFormat(format: PixelFormat, bpp: ?*c_int, r_mask: ?*u32, g_mask: ?*u32, b_mask: ?*u32, a_mask: ?*u32) bool;
pub extern fn SDL_GetPixelFormatForMasks(bpp: c_int, r_mask: u32, g_mask: u32, b_mask: u32, a_mask: u32) PixelFormat; 
pub extern fn SDL_GetPixelFormatDetails(format: PixelFormat) ?*const SDL_PixelFormatDetails;
pub extern fn SDL_CreatePalette(ncolors: c_int) ?*SDL_Palette;
pub extern fn SDL_SetPaletteColors(palette: ?*SDL_Palette, colors: [*]const Color, first_color: c_int, ncolors: c_int) bool;
pub extern fn SDL_DestroyPalette(palette: ?*SDL_Palette) void;
pub extern fn SDL_MapRGB(format: ?*const SDL_PixelFormatDetails, palette: ?*const SDL_Palette, r: u8, g: u8, b: u8) u32;
pub extern fn SDL_MapRGBA(format: ?*const SDL_PixelFormatDetails, palette: ?*const SDL_Palette, r: u8, g: u8, b: u8, a: u8) u32;
pub extern fn SDL_GetRGB(pixel_value: u32, format: ?*const SDL_PixelFormatDetails, palette: ?*const SDL_Palette, r: ?*u8, g: ?*u8, b: ?*u8) void;
pub extern fn SDL_GetRGBA(pixel_value: u32, format: ?*const SDL_PixelFormatDetails, palette: ?*const SDL_Palette, r: ?*u8, g: ?*u8, b: ?*u8, a: ?*u8) void;
