// Forward declarations for CoreText types used by HIToolbox headers.
// Included before Carbon/Carbon.h so that CTFont.h and other problematic
// CoreText headers can be skipped without losing the type definitions
// that HIToolbox depends on.
typedef const struct __CTFont *CTFontRef;
typedef const struct __CTFontDescriptor *CTFontDescriptorRef;
