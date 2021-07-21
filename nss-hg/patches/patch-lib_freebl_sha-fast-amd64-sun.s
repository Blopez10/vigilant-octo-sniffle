$NetBSD: patch-lib_freebl_sha-fast-amd64-sun.s,v 1.2 2014/10/05 20:12:38 thomasklausner Exp $

Rename global symbol SHA1_Update to avoid namespace collision

--- lib/freebl/sha-fast-amd64-sun.s.orig	2014-09-28 13:54:02.000000000 +0000
+++ lib/freebl/sha-fast-amd64-sun.s
@@ -1680,9 +1680,9 @@ shaCompress:
 .LFE7:
 	.size	shaCompress, .-shaCompress
 	.align 16
-.globl SHA1_Update
-	.type	SHA1_Update, @function
-SHA1_Update:
+.globl NSS_SHA1_Update
+	.type	NSS_SHA1_Update, @function
+NSS_SHA1_Update:
 .LFB5:
 	pushq	%rbp
 .LCFI5:
@@ -1768,7 +1768,7 @@ SHA1_Update:
 	call	shaCompress
 	jmp	.L245
 .LFE5:
-	.size	SHA1_Update, .-SHA1_Update
+	.size	NSS_SHA1_Update, .-NSS_SHA1_Update
 	.section	.rodata
 	.align 32
 	.type	bulk_pad.0, @object
@@ -1870,7 +1870,7 @@ SHA1_End:
 	subl	%r8d, %edx
 	andl	$63, %edx
 	incl	%edx
-	call	SHA1_Update@PLT
+	call	NSS_SHA1_Update@PLT
 	movq	%rbx, %rdi
 	movq	%r12, %rsi
 	shrq	$32, %rdi
@@ -1989,7 +1989,7 @@ SHA1_HashBuf:
 	movl	%r12d, %edx
 	movq	%r13, %rsi
 	movq	%rbx, %rdi
-	call	SHA1_Update@PLT
+	call	NSS_SHA1_Update@PLT
 	leaq	-292(%rbp), %rdx
 	movq	%r14, %rsi
 	movq	%rbx, %rdi
