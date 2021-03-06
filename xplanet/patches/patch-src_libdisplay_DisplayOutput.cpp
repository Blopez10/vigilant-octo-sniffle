$NetBSD$

pick from https://sourceforge.net/p/xplanet/code/208/
fix output bug when num_times is 2

--- src/libdisplay/DisplayOutput.cpp~
+++ src/libdisplay/DisplayOutput.cpp
@@ -51,7 +51,7 @@
     string outputFilename = options->OutputBase();
     int startIndex = options->OutputStartIndex();
     int stopIndex = options->NumTimes() + startIndex - 1;
-    if (stopIndex > 1)
+    if (stopIndex > 0)
     {
         const int digits = (int) (log10((double) stopIndex) + 1);
         char buffer[64];
