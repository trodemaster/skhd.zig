pub const c_impl = @cImport({
    // Zig 0.16 no longer auto-adds sub-framework -F paths, so build.zig adds
    // them explicitly. That exposes headers Zig's translate-c cannot handle.
    // Skip all sub-frameworks unused by a hotkey daemon; use a shim for any
    // types that needed frameworks require (e.g. CTFontRef used by HIToolbox).
    @cInclude("carbon_shim.h");

    // CoreText specific headers: _Nonnull on array params breaks translate-c.
    // Shim provides CTFontRef / CTFontDescriptorRef used by HIToolbox headers.
    @cDefine("__CTFONT__", "1");
    @cDefine("__CTFRAME__", "1");
    @cDefine("__CTRUN__", "1");
    @cDefine("__CTRUBYANNOTATION__", "1");

    // ApplicationServices sub-frameworks — unused, skip to avoid translate-c issues
    @cDefine("__ATS__", "1");               // deprecated font API
    @cDefine("__IMAGEIO__", "1");           // CGImageAnimation blocks typedef
    @cDefine("__QD__", "1");               // ancient QuickDraw
    @cDefine("__PRINTCORE__", "1");        // printing APIs not needed
    @cDefine("__SPEECHSYNTHESIS__", "1");  // speech not needed

    // CoreServices sub-frameworks — unused
    @cDefine("__METADATA_METADATA__", "1"); // MDItem.h has Obj-C blocks
    @cDefine("__DISKSPACERECOVERY__", "1"); // blocks typedef

    // Carbon sub-frameworks — unused, some crash translate-c
    @cDefine("__HELP__", "1");             // CFURLRef issues in AppleHelp.h
    @cDefine("__SPEECHRECOGNITION__", "1");
    @cDefine("__OPENSCRIPTING__", "1");    // large OSA/AppleScript headers crash translate-c
    @cDefine("__COMMONPANELS__", "1");     // font/color panel APIs not needed
    @cDefine("__SECURITYHI__", "1");       // keychain UI not needed

    // XPC: nullability on uuid_t array params
    @cDefine("__XPC_H__", "1");

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
