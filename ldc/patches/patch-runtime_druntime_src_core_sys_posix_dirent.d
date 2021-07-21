$NetBSD$

Stolen from https://github.com/nrTQgc/druntime/tree/netbsd

--- runtime/druntime/src/core/sys/posix/dirent.d.orig	2016-02-13 20:02:16.000000000 +0000
+++ runtime/druntime/src/core/sys/posix/dirent.d
@@ -142,6 +142,36 @@ else version( FreeBSD )
 
     dirent* readdir(DIR*);
 }
+else version( NetBSD )
+{
+    enum
+    {
+        DT_UNKNOWN  = 0,
+        DT_FIFO     = 1,
+        DT_CHR      = 2,
+        DT_DIR      = 4,
+        DT_BLK      = 6,
+        DT_REG      = 8,
+        DT_LNK      = 10,
+        DT_SOCK     = 12,
+        DT_WHT      = 14
+    }
+
+
+    struct dirent
+    {
+        ulong      d_fileno;
+        ushort    d_reclen;
+        ushort    d_namlen;
+        ubyte     d_type;
+        char[512] d_name;
+    }
+
+    alias void* DIR;
+
+    dirent* __readdir30(DIR*);
+    alias __readdir30 readdir;
+}
 else version (Solaris)
 {
     struct dirent
@@ -205,11 +235,20 @@ else
     static assert(false, "Unsupported platform");
 }
 
+version( NetBSD )
+{
+    DIR*    __opendir30(in char*);
+    alias __opendir30 opendir;
+}
+else
+{
+    DIR*    opendir(in char*);
+}
 int     closedir(DIR*);
-DIR*    opendir(in char*);
 //dirent* readdir(DIR*);
 void    rewinddir(DIR*);
 
+
 //
 // Thread-Safe Functions (TSF)
 //
@@ -237,6 +276,12 @@ else version( FreeBSD )
 {
     int readdir_r(DIR*, dirent*, dirent**);
 }
+else version( NetBSD )
+{
+    int __readdir_r30(DIR*, dirent*, dirent**);
+    alias __readdir_r30 readdir_r;
+}
+
 else version (Solaris)
 {
     static if (__USE_LARGEFILE64)
@@ -276,6 +321,11 @@ else version( FreeBSD )
     void   seekdir(DIR*, c_long);
     c_long telldir(DIR*);
 }
+else version( NetBSD )
+{
+    void   seekdir(DIR*, c_long);
+    c_long telldir(DIR*);
+}
 else version (OSX)
 {
 }
