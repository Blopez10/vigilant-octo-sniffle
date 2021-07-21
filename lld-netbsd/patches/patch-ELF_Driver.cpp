$NetBSD$

--- ELF/Driver.cpp.orig	2019-03-14 17:35:11.000000000 +0000
+++ ELF/Driver.cpp
@@ -53,6 +53,7 @@
 #include "llvm/Support/LEB128.h"
 #include "llvm/Support/Path.h"
 #include "llvm/Support/TarWriter.h"
+#include "llvm/Support/TargetRegistry.h"
 #include "llvm/Support/TargetSelect.h"
 #include "llvm/Support/raw_ostream.h"
 #include <cstdlib>
@@ -317,6 +318,9 @@ static void checkOptions() {
 
     if (Config->SingleRoRx && !Script->HasSectionsCommand)
       error("-execute-only and -no-rosegment cannot be used together");
+  } else if (Config->TargetTriple.isOSNetBSD()) {
+    // force-disable RO segment on NetBSD due to ld.elf_so limitations
+    Config->SingleRoRx = true;
   }
 }
 
@@ -351,6 +355,7 @@ static bool isKnownZFlag(StringRef S) {
          S == "keep-text-section-prefix" || S == "lazy" || S == "muldefs" ||
          S == "nocombreloc" || S == "nocopyreloc" || S == "nodefaultlib" ||
          S == "nodelete" || S == "nodlopen" || S == "noexecstack" ||
+         S == "nognustack" ||
          S == "nokeep-text-section-prefix" || S == "norelro" || S == "notext" ||
          S == "now" || S == "origin" || S == "relro" || S == "retpolineplt" ||
          S == "rodynamic" || S == "text" || S == "wxneeded" ||
@@ -364,6 +369,56 @@ static void checkZOptions(opt::InputArgL
       error("unknown -z value: " + StringRef(Arg->getValue()));
 }
 
+void LinkerDriver::appendDefaultSearchPaths() {
+  if (Config->TargetTriple.isOSNetBSD()) {
+    // NetBSD driver relies on the linker knowing the default search paths.
+    // Please keep this in sync with clang/lib/Driver/ToolChains/NetBSD.cpp
+    // (NetBSD::NetBSD constructor)
+    switch (Config->TargetTriple.getArch()) {
+    case llvm::Triple::x86:
+      Config->SearchPaths.push_back("=/usr/lib/i386");
+      break;
+    case llvm::Triple::arm:
+    case llvm::Triple::armeb:
+    case llvm::Triple::thumb:
+    case llvm::Triple::thumbeb:
+      switch (Config->TargetTriple.getEnvironment()) {
+      case llvm::Triple::EABI:
+      case llvm::Triple::GNUEABI:
+        Config->SearchPaths.push_back("=/usr/lib/eabi");
+        break;
+      case llvm::Triple::EABIHF:
+      case llvm::Triple::GNUEABIHF:
+        Config->SearchPaths.push_back("=/usr/lib/eabihf");
+        break;
+      default:
+        Config->SearchPaths.push_back("=/usr/lib/oabi");
+        break;
+      }
+      break;
+#if 0 // TODO
+    case llvm::Triple::mips64:
+    case llvm::Triple::mips64el:
+      if (tools::mips::hasMipsAbiArg(Args, "o32"))
+        Config->SearchPaths.push_back("=/usr/lib/o32");
+      else if (tools::mips::hasMipsAbiArg(Args, "64"))
+        Config->SearchPaths.push_back("=/usr/lib/64");
+      break;
+#endif
+    case llvm::Triple::ppc:
+      Config->SearchPaths.push_back("=/usr/lib/powerpc");
+      break;
+    case llvm::Triple::sparc:
+      Config->SearchPaths.push_back("=/usr/lib/sparc");
+      break;
+    default:
+      break;
+    }
+
+    Config->SearchPaths.push_back("=/usr/lib");
+  }
+}
+
 void LinkerDriver::main(ArrayRef<const char *> ArgsArr) {
   ELFOptTable Parser;
   opt::InputArgList Args = Parser.parse(ArgsArr.slice(1));
@@ -378,6 +433,25 @@ void LinkerDriver::main(ArrayRef<const c
     return;
   }
 
+  if (const char *Path = getReproduceOption(Args)) {
+    // Note that --reproduce is a debug option so you can ignore it
+    // if you are trying to understand the whole picture of the code.
+    Expected<std::unique_ptr<TarWriter>> ErrOrWriter =
+        TarWriter::create(Path, path::stem(Path));
+    if (ErrOrWriter) {
+      Tar = std::move(*ErrOrWriter);
+      Tar->append("response.txt", createResponseFile(Args));
+      Tar->append("version.txt", getLLDVersion() + "\n");
+    } else {
+      error("--reproduce: " + toString(ErrOrWriter.takeError()));
+    }
+  }
+
+  initLLVM();
+  setTargetTriple(ArgsArr[0], Args);
+  readConfigs(Args);
+  appendDefaultSearchPaths();
+
   // Handle -v or -version.
   //
   // A note about "compatible with GNU linkers" message: this is a hack for
@@ -393,25 +467,11 @@ void LinkerDriver::main(ArrayRef<const c
   // lot of "configure" scripts out there that are generated by old version
   // of Libtool. We cannot convince every software developer to migrate to
   // the latest version and re-generate scripts. So we have this hack.
-  if (Args.hasArg(OPT_v) || Args.hasArg(OPT_version))
+  if (Args.hasArg(OPT_v) || Args.hasArg(OPT_version)) {
     message(getLLDVersion() + " (compatible with GNU linkers)");
-
-  if (const char *Path = getReproduceOption(Args)) {
-    // Note that --reproduce is a debug option so you can ignore it
-    // if you are trying to understand the whole picture of the code.
-    Expected<std::unique_ptr<TarWriter>> ErrOrWriter =
-        TarWriter::create(Path, path::stem(Path));
-    if (ErrOrWriter) {
-      Tar = std::move(*ErrOrWriter);
-      Tar->append("response.txt", createResponseFile(Args));
-      Tar->append("version.txt", getLLDVersion() + "\n");
-    } else {
-      error("--reproduce: " + toString(ErrOrWriter.takeError()));
-    }
+    message("Target: " + Config->TargetTriple.str());
   }
 
-  readConfigs(Args);
-
   // The behavior of -v or --version is a bit strange, but this is
   // needed for compatibility with GNU linkers.
   if (Args.hasArg(OPT_v) && !Args.hasArg(OPT_INPUT))
@@ -419,7 +479,6 @@ void LinkerDriver::main(ArrayRef<const c
   if (Args.hasArg(OPT_version))
     return;
 
-  initLLVM();
   createFiles(Args);
   if (errorCount())
     return;
@@ -745,6 +804,34 @@ static void parseClangOption(StringRef O
   error(Msg + ": " + StringRef(Err).trim());
 }
 
+void LinkerDriver::setTargetTriple(StringRef argv0, opt::InputArgList &Args) {
+  std::string TargetError;
+
+  // Firstly, see if user specified explicit --target
+  StringRef TargetOpt = Args.getLastArgValue(OPT_target);
+  if (!TargetOpt.empty()) {
+    if (llvm::TargetRegistry::lookupTarget(TargetOpt, TargetError)) {
+      Config->TargetTriple = llvm::Triple(TargetOpt);
+      return;
+    } else
+      error("Unsupported --target=" + TargetOpt + ": " + TargetError);
+  }
+
+  // Secondly, try to get it from program name prefix
+  std::string ProgName = llvm::sys::path::stem(argv0);
+  size_t LastComponent = ProgName.rfind('-');
+  if (LastComponent != std::string::npos) {
+    std::string Prefix = ProgName.substr(0, LastComponent);
+    if (llvm::TargetRegistry::lookupTarget(Prefix, TargetError)) {
+      Config->TargetTriple = llvm::Triple(Prefix);
+      return;
+    }
+  }
+
+  // Finally, use the default target triple
+  Config->TargetTriple = llvm::Triple(getDefaultTargetTriple());
+}
+
 // Initializes Config members by the command line options.
 void LinkerDriver::readConfigs(opt::InputArgList &Args) {
   errorHandler().Verbose = Args.hasArg(OPT_verbose);
@@ -781,7 +868,8 @@ void LinkerDriver::readConfigs(opt::Inpu
   Config->CallGraphProfileSort = Args.hasFlag(
       OPT_call_graph_profile_sort, OPT_no_call_graph_profile_sort, true);
   Config->EnableNewDtags =
-      Args.hasFlag(OPT_enable_new_dtags, OPT_disable_new_dtags, true);
+      Args.hasFlag(OPT_enable_new_dtags, OPT_disable_new_dtags,
+                   !Config->TargetTriple.isOSNetBSD());
   Config->Entry = Args.getLastArgValue(OPT_entry);
   Config->ExecuteOnly =
       Args.hasFlag(OPT_execute_only, OPT_no_execute_only, false);
@@ -875,6 +963,8 @@ void LinkerDriver::readConfigs(opt::Inpu
   Config->ZCopyreloc = getZFlag(Args, "copyreloc", "nocopyreloc", true);
   Config->ZExecstack = getZFlag(Args, "execstack", "noexecstack", false);
   Config->ZGlobal = hasZOption(Args, "global");
+  Config->ZNognustack = hasZOption(Args, "nognustack") ||
+    Config->TargetTriple.isOSNetBSD();
   Config->ZHazardplt = hasZOption(Args, "hazardplt");
   Config->ZInitfirst = hasZOption(Args, "initfirst");
   Config->ZInterpose = hasZOption(Args, "interpose");
@@ -1178,7 +1268,7 @@ void LinkerDriver::inferMachineType() {
 // each target.
 static uint64_t getMaxPageSize(opt::InputArgList &Args) {
   uint64_t Val = args::getZOptionValue(Args, OPT_z, "max-page-size",
-                                       Target->DefaultMaxPageSize);
+                                       lld::elf::Target->DefaultMaxPageSize);
   if (!isPowerOf2_64(Val))
     error("max-page-size: value isn't a power of 2");
   return Val;
