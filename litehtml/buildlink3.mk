# $NetBSD$

BUILDLINK_TREE+=	litehtml

.if !defined(LITEHTML_BUILDLINK3_MK)
LITEHTML_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.litehtml+=	litehtml>=0.4.0.20170407
BUILDLINK_PKGSRCDIR.litehtml?=		../../wip/litehtml
BUILDLINK_DEPMETHOD.litehtml?=		build
.endif	# LITEHTML_BUILDLINK3_MK

BUILDLINK_TREE+=	-litehtml