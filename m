From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v13 10/12] qdev: check callback takes the property child as
 third argument
Date: Tue, 28 Apr 2015 17:51:11 +0100
Message-ID: <1430239873-31950-11-git-send-email-eric.auger@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEEA94EE20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u16XukzV6Mlb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 12:43:09 -0400 (EDT)
Received: from mail-wg0-f48.google.com (mail-wg0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 323304EE12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 12:43:07 -0400 (EDT)
Received: by wgin8 with SMTP id n8so902363wgi.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 09:51:34 -0700 (PDT)
In-Reply-To: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, alex.williamson@redhat.com, agraf@suse.de, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: patches@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Check callback now takes as third argument an Object * const*. In
object_set_link_property, we pass the property child as argument.
We also assign the *child before the check call so that enhanced
check can be performed in the callback. In case the check fails,
the old value is restored and ref count is left unchanged.

This typically makes possible to do checks both on the *child
content (for instance a qemu_irq) and also perform some actions/
checks on its container, which was not possible before.

This is for example useful for starting irqfd setup in vfio platform
use case.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- Object ** becomes Object * const*
- rename patch title
---
 hw/core/qdev-properties.c    |  3 ++-
 include/hw/qdev-properties.h |  3 ++-
 include/qom/object.h         |  4 ++--
 qom/object.c                 | 16 +++++++++-------
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/hw/core/qdev-properties.c b/hw/core/qdev-properties.c
index 570d5f0..7e00cd2 100644
--- a/hw/core/qdev-properties.c
+++ b/hw/core/qdev-properties.c
@@ -22,7 +22,8 @@ void qdev_prop_set_after_realize(DeviceState *dev, const char *name,
 }
 
 void qdev_prop_allow_set_link_before_realize(Object *obj, const char *name,
-                                             Object *val, Error **errp)
+                                             Object * const *target,
+                                             Error **errp)
 {
     DeviceState *dev = DEVICE(obj);
 
diff --git a/include/hw/qdev-properties.h b/include/hw/qdev-properties.h
index d67dad5..67ac457 100644
--- a/include/hw/qdev-properties.h
+++ b/include/hw/qdev-properties.h
@@ -213,6 +213,7 @@ void qdev_prop_set_after_realize(DeviceState *dev, const char *name,
  * object_property_add_link().
  */
 void qdev_prop_allow_set_link_before_realize(Object *obj, const char *name,
-                                             Object *val, Error **errp);
+                                             Object * const *target,
+                                             Error **errp);
 
 #endif
diff --git a/include/qom/object.h b/include/qom/object.h
index 95d1a1d..ab60c16 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -34,7 +34,7 @@ typedef struct InterfaceClass InterfaceClass;
 typedef struct InterfaceInfo InterfaceInfo;
 
 typedef void (*LinkPropertySetter)(Object *, const char *,
-                                   Object *, Error **);
+                                  Object * const *, Error **);
 
 #define TYPE_OBJECT "object"
 
@@ -1136,7 +1136,7 @@ typedef enum {
  * an error.
  */
 void object_property_allow_set_link(Object *, const char *,
-                                    Object *, Error **);
+                                    Object * const *, Error **);
 
 /**
  * object_property_add_link:
diff --git a/qom/object.c b/qom/object.c
index b8dff43..ed286e7 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -1112,14 +1112,14 @@ out:
 }
 
 void object_property_allow_set_link(Object *obj, const char *name,
-                                    Object *val, Error **errp)
+                                    Object * const *target, Error **errp)
 {
     /* Allow the link to be set, always */
 }
 
 typedef struct {
     Object **child;
-    void (*check)(Object *, const char *, Object *, Error **);
+    LinkPropertySetter check;
     ObjectPropertyLinkFlags flags;
 } LinkProperty;
 
@@ -1201,14 +1201,17 @@ static void object_set_link_property(Object *obj, Visitor *v, void *opaque,
         return;
     }
 
-    prop->check(obj, name, new_target, &local_err);
+    object_ref(new_target);
+    *child = new_target;
+
+    prop->check(obj, name, child, &local_err);
     if (local_err) {
         error_propagate(errp, local_err);
+        *child = old_target;
+        object_ref(new_target);
         return;
     }
 
-    object_ref(new_target);
-    *child = new_target;
     object_unref(old_target);
 }
 
@@ -1232,8 +1235,7 @@ static void object_release_link_property(Object *obj, const char *name,
 
 void object_property_add_link(Object *obj, const char *name,
                               const char *type, Object **child,
-                              void (*check)(Object *, const char *,
-                                            Object *, Error **),
+                              LinkPropertySetter check,
                               ObjectPropertyLinkFlags flags,
                               Error **errp)
 {
-- 
1.8.3.2
