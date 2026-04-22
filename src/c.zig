pub const c_impl = @cImport({
    // -----------------------------------------------------------------------
    // Umbrella guards — skip the giant umbrella headers that cause translate-c
    // to crash with SIGBUS (stack overflow from deep recursive includes).
    // We include only the specific sub-headers skhd.zig actually needs.
    // -----------------------------------------------------------------------

    // Skip the top-level Carbon umbrella (delegates to CoreServices + AppServices).
    @cDefine("__CARBON__", "1");

    // Skip CoreServices umbrella — it includes CarbonCore, which includes
    // Files.h (412 KB), Components.h (58 KB), Aliases.h (39 KB), etc.
    @cDefine("__CORESERVICES__", "1");

    // Skip ApplicationServices umbrella — it pulls in ATS, ImageIO, ColorSync,
    // CoreText, HIServices, etc.  We include CoreGraphics directly below.
    @cDefine("__APPLICATIONSERVICES__", "1");

    // Skip the CarbonCore umbrella (Files.h 412 KB alone crashes translate-c).
    // We include UnicodeUtilities.h directly for UCKeyTranslate.
    @cDefine("__CARBONCORE__", "1");

    // Skip the HIToolbox umbrella — CarbonEvents.h (635 KB), Appearance.h (182 KB),
    // Controls.h (169 KB), HIDataBrowser.h (164 KB) alone exceed translate-c's
    // stack budget.  Include only the three needed sub-headers below.
    @cDefine("__HITOOLBOX__", "1");

    // Skip HIServices umbrella and the two problem headers.
    // Their API surface is shimmed in carbon_shim.h.
    @cDefine("__HISERVICES__", "1");
    @cDefine("__AXUIELEMENT__", "1");
    @cDefine("__PROCESSES__", "1");

    // Additional sub-framework guards from earlier iterations (kept for safety).
    @cDefine("__CORETEXT__", "1");          // _Nonnull on arrays, SFNTLayoutTypes crash
    @cDefine("__ATS__", "1");               // deprecated font API
    @cDefine("__IMAGEIO__", "1");           // blocks typedef
    @cDefine("__QD__", "1");               // ancient QuickDraw
    @cDefine("__PRINTCORE__", "1");
    @cDefine("__SPEECHSYNTHESIS__", "1");
    @cDefine("__METADATA_METADATA__", "1"); // Obj-C blocks in MDItem.h
    @cDefine("__DISKSPACERECOVERY__", "1");
    @cDefine("__HELP__", "1");
    @cDefine("__SPEECHRECOGNITION__", "1");
    @cDefine("__OPENSCRIPTING__", "1");
    @cDefine("__COMMONPANELS__", "1");
    @cDefine("__SECURITYHI__", "1");
    @cDefine("__XPC_H__", "1");

    // -----------------------------------------------------------------------
    // Direct includes — smallest to largest, in dependency order.
    // -----------------------------------------------------------------------

    // CoreFoundation: CF types, MacTypes (OSStatus, Boolean, UniChar,
    // ProcessSerialNumber, CFStringRef, …).  Must come first.
    @cInclude("CoreFoundation/CoreFoundation.h");

    // CoreGraphics: CGEvent*, CGEventFlags, CGPoint, CGRect, …
    @cInclude("CoreGraphics/CoreGraphics.h");

    // FSEvents: FSEventStream*.  Only depends on CoreFoundation/CFRunLoop.h.
    @cInclude("FSEvents/FSEvents.h");

    // CarbonCore: UCKeyTranslate, UCKeyboardLayout, kUCKeyActionDisplay, etc.
    // Deps: MacTypes (done), MacLocales (12 KB), TextCommon (53 KB), MixedMode (23 KB).
    @cInclude("CarbonCore/UnicodeUtilities.h");

    // carbon_shim.h: CTFontRef/CTFontDescriptorRef forward declarations +
    // AXIsProcessTrusted / GetFrontProcess / CopyProcessName extern decls.
    // Included after CoreFoundation so MacTypes types are defined.
    @cInclude("carbon_shim.h");

    // HIToolbox sub-headers (umbrella skipped above).
    // ApplicationServices is blocked; all prerequisite types are already included.
    @cInclude("HIToolbox/CarbonEventsCore.h"); // EventTypeSpec, EventHandlerRef, Install*
    @cInclude("HIToolbox/Events.h");           // kVK_*, LMGetKbdType
    @cInclude("HIToolbox/TextInputSources.h"); // TISCopy*, TISGetInputSourceProperty

    // ObjC runtime
    @cInclude("objc/objc.h");
    @cInclude("objc/runtime.h");

    // POSIX
    @cInclude("unistd.h");
    @cInclude("sys/types.h");
    @cInclude("sys/wait.h");
    @cInclude("fcntl.h");

    // IOKit key codes (NX_KEYTYPE_*)
    @cInclude("IOKit/hidsystem/ev_keymap.h");
});

// Additional declarations (module-level, not inside c_impl)
pub extern fn NSApplicationLoad() void;
