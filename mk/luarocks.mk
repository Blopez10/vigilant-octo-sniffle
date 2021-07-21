# $NetBSD: luarocks.mk,v 1.1 2015/05/18 01:49:54 krytarowski Exp $
#
# XXXX This file is work-in-progress it doesn't work
# XXXX It's cloned from ruby gems and it will be adapted for Lua rockspec
# XXXX https://luarocks.org/
#
# XXXX Ideas:
# XXXX o) autogenerate as much as possible from rockspec
# XXXX o) package lua-rocks and make use of `luarocks make --local'
#
# This Makefile fragment is intended to be included by packages that build
# and install Luarocks modules.
#
# Package-settable variables:
#
# OVERRIDE_ROCKSPEC
#	Fix version of depending rock or modify files in rockspec.
#
#	(1) Specify as rock and dependency pattern as usual pkgsrc's one.
#
#		Example:
#		    When rockspec contains "json~>1.4.7" as runtime dependency
#		    (i.e. json>=1.4.7<1.5) and if you want to relax it to
#		    "json>=1.4.6" then use:
#
#			OVERRIDE_ROCKSPEC+= json>=1.4.6
#
#		    If you want to change depending gem to "json_pure>=1.4.6"
#		    then use:
#
#			OVERRIDE_ROCKSPEC+= json:json_pure>=1.4.6
#
#		    You can also remove dependency:
#
#			OVERRIDE_ROCKSPEC+= json:
#
#	(2) Modify instance of gemspec.
#
#		Example:
#			Rename gem's name to "foo" (setting instance @name):
#
#			OVERRIDE_ROCKSPEC+= :name=foo
#
#		Example:
#			Remove files (a.rb and b.rb) from 'files':
#
#			OVERRIDE_ROCKSPEC+= :files a.rb= b.rb=
#
#		Example:
#			Add a file (exec.rb) to 'executables':
#
#			OVERRIDE_ROCKSPEC+= :executables exec.rb
#
#		Example:
#			Rename a file (from 'ruby' to 'ruby193') in 'files':
#
#			OVERRIDE_ROCKSPEC+= :files ruby=ruby193
#
#	Note: Because of limited parser, argumetns for (1) must preceed to (2).
#
#	Default: (empty)
#
# GEM_PATH
#	Set GEM_PATH; search path for rubygems
#
#	Default: ${PREFIX}/${GEM_HOME}
#
# BUILD_TARGET
#	The Rakefile target that creates a local gem if using the
#	``rake'' GEM_BUILD method.
#
#	Default: gem
#
# GEM_BUILD
#	The method used to build the local gem.
#
#	Possible: gemspec, rake
#	Default: gemspec
#
# GEM_CLEANBUILD
#	A list of shell globs representing files to remove from the
#	gem installed in the installation root.  The file is removed
#	if the path matches the glob and is not in ${WRKSRC}.  The
#	default is "ext/*"
#
#	Example:
#
#	    GEM_CLEANBUILD=	*.o *.${RUBY_DLEXT} mkmf.log
#
# GEM_CLEANBUILD_EXTENSIONS
#	A list of shell globs representing files under ${RUBY_EXTSDIR}.
#	These files will be additionaly removed from the gem installed in
#	the installation root.
#
# ROCKSPEC_NAME
#	The name of the gem to install.  The default value is ${DISTNAME}.
#
# ROCKSPEC_SPECFILE
#	The path to the gemspec file to use when building a gem using
#       the ``gemspec'' GEM_BUILD method.  It defaults to
#	${WRKDIR}/${DISTNAME}.gemspec.
#
# RUBYGEM_OPTIONS
#	Optional parameter to pass to gem on install stage.
#
#
# Variables defined in this file:
#
# GEM_DOCDIR
#	The relative path from PREFIX to the directory in the local gem
#	repository that holds the documentation for the installed gem.
#
# GEM_LIBDIR
#	The relative path from PREFIX to the directory in the local gem
#	repository that holds the contents of the installed gem.
#
# GEM_EXTSDIR
#	"extensions" directory under ${GEM_HOME}.  It is generated by
#	rubygems 2.2 and later.
#	In PLIST file, it will be replace to "${GEM_HOME}/extensions" or
#	"@comment ..." depends on the version of rubygems.
#
# RUBYGEM
#	The path to the rubygems ``gem'' script.
#
.if !defined(_LUAROCKS_MK)
_LUAROCKS_MK=	# defined

# replace interpeter bin default
REPLACE_RUBY_DIRS?=	bin
REPLACE_RUBY_PAT?=	*

# Default to using rake to build the local gem from the unpacked files.
GEM_BUILD?=	gemspec

OVERRIDE_GEMSPEC?=	# default is empty

.if !empty(OVERRIDE_GEMSPEC)
UPDATE_GEMSPEC=		../../lang/ruby/files/update-gemspec.rb
.endif

.if ${GEM_BUILD} == "rake"
USE_RAKE?=		YES
.endif

# Include this early in case some of its target are needed
.include "../../lang/ruby/modules.mk"

# Build and run-time dependencies for Ruby prior to 1.9.
#
# We need rubygems>=1.1.0 to actually build the package, but the
# resulting installed gem can run with older versions of rubygems.
#
# If we're using rake to build the local gem, then include it as a
# build tool.
#
.include "../../lang/ruby/gem-vars.mk"

CATEGORIES+=	ruby
MASTER_SITES?=	${MASTER_SITE_RUBYGEMS}

EXTRACT_SUFX?=	.gem
DISTFILES?=	${DISTNAME}${EXTRACT_SUFX}

# If any of the DISTFILES are gems, then skip the normal do-extract actions
# and extract them ourselves in gem-extract.
#
.if !empty(DISTFILES:M*.gem)
EXTRACT_ONLY?=	# empty
.endif

# Directory for the Gem to install
GEM_NAME?=	${DISTNAME}
GEM_CACHEDIR=	${GEM_HOME}/cache
GEM_DOCDIR=	${GEM_HOME}/doc/${GEM_NAME}
GEM_LIBDIR=	${GEM_HOME}/gems/${GEM_NAME}

GEM_BUILDINFO_DIR=	${GEM_HOME}/build_info

# Installed gems have wrapper scripts that call the right interpreter,
# regardless of the #! line at the head of a script, so we can skip
# the interpreter path check for gems.  ANd it is also true for files'
# permission.
#
CHECK_INTERPRETER_SKIP+=	${GEM_LIBDIR}/*
CHECK_PERMS_SKIP+=		${GEM_LIBDIR}/*

# PLIST support
PLIST_SUBST+=		GEM_NAME=${GEM_NAME}
PLIST_SUBST+=		GEM_LIBDIR=${GEM_LIBDIR}
PLIST_SUBST+=		GEM_DOCDIR=${GEM_DOCDIR}

# Add indirect support for print-PLIST
_RUBY_PRINT_PLIST_GEM=	/${GEM_NAME}\.info$$/ \
			{ gsub(/${GEM_NAME}\.info/, "$${GEM_NAME}.info"); }
_RUBY_PRINT_PLIST_GEM+=	/${GEM_NAME}\.(gem|gemspec)$$/ \
			{ gsub(/${GEM_NAME}\.gem/, "$${GEM_NAME}.gem"); }
_RUBY_PRINT_PLIST_GEM+=	/${GEM_NAME:S/./[.]/g}[.](gem|gemspec)$$/ \
	{ gsub(/${PKGVERSION_NOREV:S|/|\\/|g}[.]gem/, "$${PKGVERSION}.gem"); }
.if !empty(GEM_EXTSDIR)
_RUBY_PRINT_PLIST_GEM+=	/^${GEM_EXTSDIR:S|/|\\/|g}/ \
		{ gsub(/${GEM_EXTSDIR:S|/|\\/|g}/, "$${GEM_EXTSDIR}"); \
			print; next; }
.endif
_RUBY_PRINT_PLIST_GEM+=	/^${GEM_LIBDIR:S|/|\\/|g}/ \
	{ gsub(/${GEM_LIBDIR:S|/|\\/|g}/, "$${GEM_LIBDIR}"); print; next; }
_RUBY_PRINT_PLIST_GEM+=	/^${GEM_DOCDIR:S|/|\\/|g}/ \
			{ next; }
_RUBY_PRINT_PLIST_GEM+=	/^${GEM_HOME:S|/|\\/|g}/ \
			{ gsub(/${GEM_HOME:S|/|\\/|g}/, "$${GEM_HOME}"); \
			print; next; }
_RUBY_PRINT_PLIST_GEM+=	/^${RUBY_GEM_BASE:S|/|\\/|g}/ \
		{ gsub(/${RUBY_GEM_BASE:S|/|\\/|g}/, "$${RUBY_GEM_BASE}"); \
			print; next; }

.include "../../lang/ruby/gem-extract.mk"

###
### gem-build
###
### The gem-build target builds a new local gem from the extracted gem's
### contents.  The new gem as created as ${WRKSRC}/${GEM_NAME}.gem.
### The local gem is then installed into a special build root under
### ${WRKDIR} (${RUBYGEM_INSTALL_ROOT}), possibly compiling any extensions.
###
LUAROCK_SPECFILE?=		${WRKDIR}/${DISTNAME}.rockspec

.PHONY: gem-build
do-build: _gem-pre-build gem-build

_gem-pre-build:
.if !empty(OVERRIDE_GEMSPEC)
	@${STEP_MSG} Override gemspec dependency
	@${RUBY} ${.CURDIR}/${UPDATE_GEMSPEC} ${WRKDIR}/${GEM_NAME}.gemspec \
		${OVERRIDE_GEMSPEC:Q}
.endif
	@${STEP_MSG} "Removing backup files of patch before build"
	@find ${WRKSRC} -name \*.orig -exec rm {} \;

gem-build: _gem-${GEM_BUILD}-build

.PHONY: _gem-gemspec-build
_gem-gemspec-build:
	${RUN} cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${RUBYGEM_ENV} \
		${RUBYGEM} build ${GEM_SPECFILE}
	${RUN} ${TEST} -f ${WRKSRC}/${GEM_NAME}.gem || \
		${FAIL_MSG} "Build of ${GEM_NAME}.gem failed."

BUILD_TARGET?=	gem

.PHONY: _gem-rake-build
_gem-rake-build:
	${RUN} cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${RAKE} ${BUILD_TARGET}
	${RUN} cd ${WRKSRC} && rm -f ${GEM_NAME}.gem
	${RUN} cd ${WRKSRC} && find . -name ${GEM_NAME}.gem -print | \
	while read file; do \
		ln -fs "$$file" ${GEM_NAME}.gem; \
		exit 0; \
	done

RUBYGEM_INSTALL_ROOT=	${WRKDIR}/.inst
_RUBYGEM_OPTIONS=	--no-update-sources	# don't cache the gem index
_RUBYGEM_OPTIONS+=	--install-dir ${PREFIX}/${GEM_HOME}
_RUBYGEM_OPTIONS+=	${RUBYGEM_INSTALL_ROOT_OPTION}
_RUBYGEM_OPTIONS+=	--ignore-dependencies
_RUBYGEM_OPTIONS+=	--local ${WRKSRC}/${GEM_NAME}.gem
.if !empty(RUBY_BUILD_RI:M[nN][oO])
_RUBYGEM_OPTIONS+=	--no-ri
.endif
.if !empty(RUBY_BUILD_RDOC:M[nN][oO])
_RUBYGEM_OPTIONS+=	--no-rdoc
.endif
.if !empty(CONFIGURE_ARGS) || !empty(RUBY_EXTCONF_ARGS)
_RUBYGEM_OPTIONS+=	--
.if !empty(RUBY_EXTCONF_ARGS)
_RUBYGEM_OPTIONS+=	${RUBY_EXTCONF_ARGS}
.endif
.if !empty(CONFIGURE_ARGS)
_RUBYGEM_OPTIONS+=	--build-args ${CONFIGURE_ARGS}
.endif
.endif

RUBYGEM_INSTALL_ROOT_OPTION=	--install-root ${RUBYGEM_INSTALL_ROOT}

.PHONY: _gem-build-install-root
_gem-build-install-root:
	@${STEP_MSG} "Installing gem into installation root"
	${RUN} ${SETENV} ${MAKE_ENV} ${RUBYGEM_ENV} \
		${RUBYGEM} install --backtrace ${RUBYGEM_OPTIONS} ${_RUBYGEM_OPTIONS}

# The ``gem'' command doesn't exit with a non-zero result even if the
# install of the gem failed, so we do the check and return the proper exit
# code ourselves.
#
.PHONY: _gem-build-install-root-check
_gem-build-install-root-check:
	${RUN} ${TEST} -f ${RUBYGEM_INSTALL_ROOT}${PREFIX}/${GEM_CACHEDIR}/${GEM_NAME}.gem || \
		${FAIL_MSG} "Installing ${GEM_NAME}.gem into installation root failed."

.if !empty(GEM_CLEANBUILD) || !empty(GEM_CLEANBUILD_EXTENSIONS)
.PHONY: _gem-build-cleanbuild
_gem-build-cleanbuild:
	@${STEP_MSG} "Cleaning intermediate gem build files"
.if !empty(GEM_CLEANBUILD)
	${RUN} cd ${RUBYGEM_INSTALL_ROOT}${PREFIX}/${GEM_LIBDIR} &&	\
	find . -print | sort -r |					\
	while read file; do						\
		case $$file in						\
		${GEM_CLEANBUILD:@.p.@./${.p.}) ;;@}			\
		*)	continue ;;					\
		esac;							\
		if [ -e ${WRKSRC:Q}"/$$file" ]; then			\
			continue;					\
		elif [ -d "$$file" ]; then				\
			rfile=`echo $$file | ${SED} -e 's|^\./||'`;	\
			${ECHO} "rmdir "${GEM_NAME}"/$$rfile";		\
			rmdir $$file;					\
		elif [ -f "$$file" ]; then				\
			rfile=`echo $$file | ${SED} -e 's|^\./||'`;	\
			${ECHO} "rm "${GEM_NAME}"/$$rfile";		\
			rm -f $$file;					\
		fi;							\
	done
.endif
.if !empty(GEM_EXTSDIR) && !empty(GEM_CLEANBUILD_EXTENSIONS)
	${RUN} \
	if test ! -d ${RUBYGEM_INSTALL_ROOT}${PREFIX}/${GEM_EXTSDIR}; then \
		:; \
	else \
		cd ${RUBYGEM_INSTALL_ROOT}${PREFIX}/${GEM_EXTSDIR} && \
		for f in ${GEM_CLEANBUILD_EXTENSIONS}; do \
			echo "rm -f $$f"; \
			rm -f $$f; \
		done; \
	fi
.endif
.endif

###
### gem-install
###
### The gem-install target installs the gem in ${_RUBY_INSTALL_ROOT} into
### the actual gem repository.
###
GENERATE_PLIST+=	${RUBYGEM_GENERATE_PLIST}
RUBYGEM_GENERATE_PLIST=	\
	${ECHO} "@comment The following lines are automatically generated." && \
	( cd ${RUBYGEM_INSTALL_ROOT}${PREFIX} && test -d ${GEM_DOCDIR} && \
	  ${FIND} ${GEM_DOCDIR} \! -type d -print | ${SORT} ) || true;

_GEM_INSTALL_TARGETS=	_gem-build-install-root
_GEM_INSTALL_TARGETS+=	_gem-build-install-root-check
.if !empty(GEM_CLEANBUILD)
_GEM_INSTALL_TARGETS+=	_gem-build-cleanbuild
.endif
_GEM_INSTALL_TARGETS+=	_gem-install

.ORDER: ${_GEM_INSTALL_TARGETS}

USE_TOOLS+=	pax

do-install: ${_GEM_INSTALL_TARGETS}

.PHONY: _gem-install
_gem-install:
	@${STEP_MSG} "gem install"
	${RUN} cd ${RUBYGEM_INSTALL_ROOT}${PREFIX} && \
		pax -rwpp . ${DESTDIR}${PREFIX}

.endif
