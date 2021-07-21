# $NetBSD$

.if !defined(EMACS_GIT_MODULES_MK)
EMACS_GIT_MODULES_MK=	# defined

_EMACS_VERSIONS_ALL+=	emacs27 emacs27nox
_EMACS_PKGDIR_MAP+=	emacs27@../../wip/emacs-git \
			emacs27nox@../../wip/emacs-nox11-git

.include "../../editors/emacs/modules.mk"

.endif	# EMACS_GIT_MODULES_MK
