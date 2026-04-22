// Forward declarations for types whose headers are skipped to keep
// translate-c from stack-overflowing on huge Carbon umbrella headers.

// CoreText types used by HIToolbox sub-headers.
// Skipping the CoreText umbrella (translate-c crashes on SFNTLayoutTypes.h
// and rejects _Nonnull on array params in CTFont.h / CTRun.h).
typedef const struct __CTFont *CTFontRef;
typedef const struct __CTFontDescriptor *CTFontDescriptorRef;

// HIServices — declare only the two symbols skhd.zig actually calls rather
// than including Processes.h (which pulls in Files.h, 412 KB) or
// AXUIElement.h (which re-pulls ApplicationServices and CGRemoteOperation).
// MacTypes.h (via CoreFoundation above) already defines Boolean, OSStatus,
// ProcessSerialNumber, and CFStringRef.
extern Boolean AXIsProcessTrusted(void);
extern OSStatus GetFrontProcess(ProcessSerialNumber *pPSN);
extern OSStatus CopyProcessName(const ProcessSerialNumber *psn, CFStringRef *name);
