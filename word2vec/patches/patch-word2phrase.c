$NetBSD$

Portability fixes.
https://github.com/tmikolov/word2vec/pull/40

--- word2phrase.c.orig	2017-07-16 22:46:08.000000000 +0000
+++ word2phrase.c
@@ -42,7 +42,7 @@ unsigned long long next_random = 1;
 void ReadWord(char *word, FILE *fin, char *eof) {
   int a = 0, ch;
   while (1) {
-    ch = fgetc_unlocked(fin);
+    ch = getc_unlocked(fin);
     if (ch == EOF) {
       *eof = 1;
       break;
@@ -246,7 +246,7 @@ void TrainModel() {
     if (eof) break;
     if (word[0] == '\n') {
       //fprintf(fo, "\n");
-      fputc_unlocked('\n', fo);
+      putc_unlocked('\n', fo);
       continue;
     }
     cn++;
@@ -286,12 +286,12 @@ void TrainModel() {
     next_random = next_random * (unsigned long long)25214903917 + 11;
     //if (next_random & 0x10000) score = 0;
     if (score > threshold) {
-      fputc_unlocked('_', fo);
+      putc_unlocked('_', fo);
       pb = 0;
-    } else fputc_unlocked(' ', fo);
+    } else putc_unlocked(' ', fo);
     a = 0;
     while (word[a]) {
-      fputc_unlocked(word[a], fo);
+      putc_unlocked(word[a], fo);
       a++;
     }
     pa = pb;
