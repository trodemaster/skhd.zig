pub const c_impl = @cImport({
    // Zig 0.16 no longer auto-adds sub-framework -F paths, so build.zig adds
    // them explicitly. That exposes headers Zig's translate-c cannot handle.
    // Skip problematic sub-frameworks; include a shim for forward declarations
    // that HIToolbox needs (e.g. CTFontRef) before the skips take effect.
    @cInclude("carbon_shim.h");

    // CoreText: CTFont.h / CTFrame.h / CTRun.h use _Nonnull on array params.
    // Shim above provides CTFontRef / CTFontDescriptorRef used by HIToolbox.
    @cDefine("__CTFONT__", "1");
    @cDefine("__CTFRAME__", "1");
    @cDefine("__CTRUN__", "1");
    @cDefine("__CTRUBYANNOTATION__", "1");

    // These frameworks are unused by skhd.zig; skip their often-broken headers.
    @cDefine("__METADATA_METADATA__", "1"); // MDItem.h has Obj-C blocks
    @cDefine("__ATS__", "1");              // ATS_UNAVAILABLE issues
    @cDefine("__IMAGEIO__", "1");          // CGImageAnimation blocks
    @cDefine("__DISKSPACERECOVERY__", "1"); // blocks typedef
    @cDefine("__HELP__", "1");             // CFURLRef issues
    @cDefine("__SPEECHRECOGNITION__", "1"); // not needed
    @cDefine("__XPC_H__", "1");            // uuid_t nullability issues

    @cInclude("Carbon/Carbon.h");
    @cInclude("objc/objc.h");
    @cInclude("objc/runtime.h");
    @cInclude("unistd.h");
    @cInclude("sys/types.h");
    @cInclude("sys/wait.h");
    @cInclude("fcntl.h");
    @cInclude("IOKit/hidsystem/ev_keymap.h");
});

// Additional declarations (module-level, not inside c_impl)
pub extern fn NSApplicationLoad() void;
