# $Thinkum$

BUILDLINK_TREE+=	lttng-ust

.ifndef LTTNG_UST_BUILDLINK3_MK
LTTNG_UST_BUILDLINK3_MK:=	# Defined

## first version introduced for this pkg under wip was 2.11.0

BUILDLINK_API_DEPENDS.lttng-ust+=	lttng-ust>=2.11.0
BUILDLINK_ABI_DEPENDS.lttng-ust+=	lttng-ust>=2.11.0
BUILDLINK_PKGSRCDIR.lttng-ust?=		../../wip/lttng-ust

.include "../../devel/userspace-rcu/buildlink3.mk"

.endif # LTTNG_UST_BUILDLINK3_MK

BUILDLINK_TREE+=	-lttng-ust
