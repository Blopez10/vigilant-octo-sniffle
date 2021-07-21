$NetBSD$

--- tests/tlb_flush2.c.orig	2019-11-20 22:52:24.000000000 +0000
+++ tests/tlb_flush2.c
@@ -10,7 +10,12 @@
 #include <sys/syscall.h>
 #include <stdio.h>
 
+#if defined(__NetBSD__)
+#include <lwp.h>
+#define gettid()  (long int)_lwp_self()
+#else
 #define gettid()  syscall(SYS_gettid)
+#endif
 #define MEMORYSIZE (1 * 1024 * 1024)
 
 char *testcase_description = "TLB flush of anonymous memory private mapping";
