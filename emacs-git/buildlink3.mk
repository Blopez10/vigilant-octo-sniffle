# $NetBSD$

BUILDLINK_TREE+=	emacs27

.if !defined(EMACS_BUILDLINK3_MK)
EMACS_BUILDLINK3_MK:=

.include "../../mk/bsd.prefs.mk"
.include "../../${EMACS_BASE:Uwip/emacs-git}/modules.mk"
BUILDLINK_API_DEPENDS.emacs27+=	${_EMACS_REQD}
BUILDLINK_PKGSRCDIR.emacs27?=	${_EMACS_PKGDIR}

BUILDLINK_CONTENTS_FILTER.emacs27=	${EGREP} '.*\.el$$|.*\.elc$$'
.endif # EMACS_BUILDLINK3_MK

BUILDLINK_TREE+=	-emacs27
