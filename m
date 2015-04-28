From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 2/3] qdev: check callback takes Object **target as third
 argument
Date: Tue, 28 Apr 2015 10:18:02 +0100
Message-ID: <1430212683-10984-3-git-send-email-eric.auger@linaro.org>
References: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FCB24EC90
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xW99OX5EtQtf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Apr 2015 05:09:46 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB51C4ECA0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 05:09:45 -0400 (EDT)
Received: by widdi4 with SMTP id di4so131750188wid.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Apr 2015 02:18:11 -0700 (PDT)
In-Reply-To: <1430212683-10984-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, qemu-devel@nongnu.org, pbonzini@redhat.com, peter.crosthwaite@xilinx.com
Cc: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Check callback now takes as third argument an Object **. In
object_set_link_property, we pass the property child as argument.
We also assign the *child before the check call so that enhanced
check can be performed in the callback. In case the check fails,
the old value is restored and ref count is left unchanged.

This typically makes possible to do checks both on the *child
content (for instance a qemu_irq) and also perform some actions/
checks on its container, which was not possible before.

This is typically useful for starting irqfd setup in vfio platform
use case.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 hw/core/qdev-properties.c    |  2 +-
 include/hw/qdev-properties.h |  2 +-
 include/qom/object.h         |  7 +++----
 qom/object.c                 | 15 +++++++++------
 4 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/hw/core/qdev-properties.c b/hw/core/qdev-properties.c
index 570d5f0..a42f9d4 100644
--- a/hw/core/qdev-properties.c
+++ b/hw/core/qdev-properties.c
@@ -22,7 +22,7 @@ void qdev_prop_set_after_realize(DeviceState *dev, const char *name,
 }
 
 void qdev_prop_allow_set_link_before_realize(Object *obj, const char *name,
-                                             Object *val, Error **errp)
+                                             Object **target, Error **errp)
 {
     DeviceState *dev = DEVICE(obj);
 
diff --git a/include/hw/qdev-properties.h b/include/hw/qdev-properties.h
index d67dad5..b2868be 100644
--- a/include/hw/qdev-properties.h
+++ b/include/hw/qdev-properties.h
@@ -213,6 +213,6 @@ void qdev_prop_set_after_realize(DeviceState *dev, const char *name,
  * object_property_add_link().
  */
 void qdev_prop_allow_set_link_before_realize(Object *obj, const char *name,
-                                             Object *val, Error **errp);
+                                             Object **target, Error **errp);
 
 #endif
diff --git a/include/qom/object.h b/include/qom/object.h
index 4687fa1..0a7daff 100644
--- a/include/qom/object.h
+++ b/include/qom/object.h
@@ -34,7 +34,7 @@ typedef struct InterfaceClass InterfaceClass;
 typedef struct InterfaceInfo InterfaceInfo;
 
 typedef void (*object_property_set_link_t)(Object *, const char *,
-                                           Object *, Error **);
+                                           Object **, Error **);
 
 #define TYPE_OBJECT "object"
 
@@ -1136,7 +1136,7 @@ typedef enum {
  * an error.
  */
 void object_property_allow_set_link(Object *, const char *,
-                                    Object *, Error **);
+                                    Object **, Error **);
 
 /**
  * object_property_add_link:
@@ -1168,8 +1168,7 @@ void object_property_allow_set_link(Object *, const char *,
  */
 void object_property_add_link(Object *obj, const char *name,
                               const char *type, Object **child,
-                              void (*check)(Object *obj, const char *name,
-                                            Object *val, Error **errp),
+                              object_property_set_link_t check,
                               ObjectPropertyLinkFlags flags,
                               Error **errp);
 
diff --git a/qom/object.c b/qom/object.c
index b8dff43..cc9ed87 100644
--- a/qom/object.c
+++ b/qom/object.c
@@ -1112,14 +1112,14 @@ out:
 }
 
 void object_property_allow_set_link(Object *obj, const char *name,
-                                    Object *val, Error **errp)
+                                    Object **target, Error **errp)
 {
     /* Allow the link to be set, always */
 }
 
 typedef struct {
     Object **child;
-    void (*check)(Object *, const char *, Object *, Error **);
+    void (*check)(Object *, const char *, Object **, Error **);
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
 
@@ -1233,7 +1236,7 @@ static void object_release_link_property(Object *obj, const char *name,
 void object_property_add_link(Object *obj, const char *name,
                               const char *type, Object **child,
                               void (*check)(Object *, const char *,
-                                            Object *, Error **),
+                                            Object **, Error **),
                               ObjectPropertyLinkFlags flags,
                               Error **errp)
 {
-- 
1.8.3.2
