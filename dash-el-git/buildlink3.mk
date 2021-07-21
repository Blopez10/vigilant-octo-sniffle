# $Thinkum$

BUILDLINK_TREE+=        dash-el

.if !defined(DASH-EL_BUILDLINK3_MK)
DASH-EL_BUILDLINK3_MK:= 	# Defined

BUILDLINK_API_DEPENDS.dash-el+=	dash-el>=20190928
BUILDLINK_ABI_DEPENDS.dash-el+=	dash-el>=20190928
BUILDLINK_PKGSRCDIR.dash-el?=	../../wip/dash-el-git

EMACS_BUILDLINK?=		# Defined
.include "../../mk/bsd.prefs.mk"
.include "../../${EMACS_BASE:Uwip/emacs-git}/modules.mk"

.endif # DASH-EL_BUILDLINK3_MK

BUILDLINK_TREE+=        -dash-el
