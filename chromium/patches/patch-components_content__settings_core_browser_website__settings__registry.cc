$NetBSD$

--- components/content_settings/core/browser/website_settings_registry.cc.orig	2017-02-02 02:02:52.000000000 +0000
+++ components/content_settings/core/browser/website_settings_registry.cc
@@ -88,6 +88,9 @@ const WebsiteSettingsInfo* WebsiteSettin
   // doesn't allow the settings to be managed in the same way. See
   // crbug.com/642184.
   sync_status = WebsiteSettingsInfo::UNSYNCABLE;
+#elif defined(OS_BSD)
+  if (!(platform & PLATFORM_BSD))
+    return nullptr;
 #else
 #error "Unsupported platform"
 #endif
