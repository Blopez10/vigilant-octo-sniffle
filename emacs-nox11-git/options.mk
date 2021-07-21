# $NetBSD$

### Set options
PKG_OPTIONS_VAR=			PKG_OPTIONS.emacs
PKG_SUPPORTED_OPTIONS=			gnutls jansson
PKG_SUGGESTED_OPTIONS=			gnutls jansson

.include "../../mk/bsd.options.mk"

###
### Support gnutls
###
.if !empty(PKG_OPTIONS:Mgnutls)
.include "../../security/gnutls/buildlink3.mk"
.include "../../security/p11-kit/buildlink3.mk"
.else
CONFIGURE_ARGS+=	--without-gnutls
.endif

###
### Support jansson (JSON library)
###
.  if !empty(PKG_OPTIONS:Mjansson)
.include "../../textproc/jansson/buildlink3.mk"
.  else
CONFIGURE_ARGS+=	--without-json
.  endif
