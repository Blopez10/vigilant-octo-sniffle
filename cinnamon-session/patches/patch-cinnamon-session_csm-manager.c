$NetBSD$

Fix log-out.

--- cinnamon-session/csm-manager.c.orig	2018-04-19 11:06:26.000000000 +0000
+++ cinnamon-session/csm-manager.c
@@ -957,6 +957,7 @@ maybe_restart_user_bus (CsmManager *mana
         if (!csm_system_is_last_session_for_user (system))
                 return;
 
+#if 0
         reply = g_dbus_connection_call_sync (manager->priv->connection,
                                              "org.freedesktop.systemd1",
                                              "/org/freedesktop/systemd1",
@@ -968,6 +969,7 @@ maybe_restart_user_bus (CsmManager *mana
                                              -1,
                                              NULL,
                                              &error);
+#endif
 
         if (error != NULL) {
                 g_debug ("CsmManager: reloading user bus failed: %s", error->message);
