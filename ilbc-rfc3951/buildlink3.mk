# $NetBSD: buildlink3.mk,v 1.2 2009/03/20 19:43:43 jsonn Exp $

BUILDLINK_TREE+=	ilbc-rfc3951

.if !defined(ILBC_RFC3951_BUILDLINK3_MK)
ILBC_RFC3951_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ilbc-rfc3951+=	ilbc-rfc3951>=200412
BUILDLINK_PKGSRCDIR.ilbc-rfc3951?=	../../wip/ilbc-rfc3951
.endif # ILBC_RFC3951_BUILDLINK3_MK

BUILDLINK_TREE+=	-ilbc-rfc3951
