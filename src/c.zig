pub const c_impl = @cImport({
    // Zig 0.16 no longer auto-adds sub-framework -F paths, so build.zig adds
    // them explicitly. That exposes headers Zig's translate-c cannot handle.
    // Skip all sub-frameworks unused by a hotkey daemon; use a shim for any
    // types that needed frameworks require (e.g. CTFontRef used by HIToolbox).
    @cInclude("carbon_shim.h");

    // CoreText: multiple headers have _Nonnull on array params, and
    // SFNTLayoutTypes.h may crash translate-c.
    // Shim above provides CTFontRef / CTFontDescriptorRef used by HIToolbox.
    @cDefine("__CORETEXT__", "1");

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

    // HIToolbox umbrella includes CarbonEvents.h (635 KB), Appearance.h (182 KB),
    // Controls.h (169 KB), HIDataBrowser.h (164 KB), etc. — together they exceed
    // translate-c's stack budget and cause a SIGBUS crash.  Skip the umbrella and
    // pull in only the three sub-headers skhd.zig actually needs.
    @cDefine("__HITOOLBOX__", "1");

    // HIServices umbrella pulls in extra headers we don't need; skip it and
    // include AXUIElement.h and Processes.h directly below.
    @cDefine("__HISERVICES__", "1");

    @cInclude("Carbon/Carbon.h");

    // HIToolbox sub-headers (included after Carbon.h so ApplicationServices
    // and CarbonCore guards are already set, preventing re-inclusion).
    @cInclude("HIToolbox/CarbonEventsCore.h"); // EventTypeSpec, EventHandlerRef, Install*
    @cInclude("HIToolbox/Events.h");           // kVK_*, UCKeyTranslate, LMGetKbdType
    @cInclude("HIToolbox/TextInputSources.h"); // TISCopy*, TISGetInputSourceProperty

    // HIServices sub-headers
    @cInclude("HIServices/AXUIElement.h"); // AXIsProcessTrusted
    @cInclude("HIServices/Processes.h");   // GetFrontProcess, ProcessSerialNumber

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
