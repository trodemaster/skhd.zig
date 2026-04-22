pub const c_impl = @cImport({
    // Skip sub-frameworks that Zig 0.16 can now resolve but cannot translate:
    // Metadata/MDItem.h has Obj-C blocks syntax; ATS has ATS_UNAVAILABLE attribute issues.
    @cDefine("__METADATA_METADATA__", "1");
    @cDefine("__ATS__", "1");
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
