$NetBSD$

--- src/VBox/Main/cbinding/VBoxCAPI_v3_0.h.orig	2016-03-04 19:29:35.000000000 +0000
+++ src/VBox/Main/cbinding/VBoxCAPI_v3_0.h
@@ -1371,7 +1371,8 @@ enum CIMOSType
     CIMOSType_CIMOS_Linux_2_6_x = 99,
     CIMOSType_CIMOS_Linux_2_6_x_64 = 100,
     CIMOSType_CIMOS_Linux_64 = 101,
-    CIMOSType_CIMOS_Other_64 = 102
+    CIMOSType_CIMOS_Other_64 = 102,
+    CIMOSType_CIMOS_NetBSD_64 = 78,
 };
 /* End of enum CIMOSType Declaration */
 
