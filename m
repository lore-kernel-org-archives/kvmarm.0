From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 2/7] vfio: platform: add capability to register a reset
 function
Date: Fri, 23 Oct 2015 14:37:10 +0200
Message-ID: <1445603835-14506-3-git-send-email-eric.auger@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1A98412FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IEpM9OF6q1pl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 08:34:44 -0400 (EDT)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9BB4D412E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:44 -0400 (EDT)
Received: by wikq8 with SMTP id q8so74965102wik.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 05:37:24 -0700 (PDT)
In-Reply-To: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for subsequent changes in reset function lookup,
lets introduce a dynamic list of reset combos (compat string,
reset module, reset function). The list can be populated/voided with
two new functions, vfio_platform_register/unregister_reset. Those are
not yet used in this patch.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- use goto out to have a single mutex_unlock
- implement vfio_platform_register_reset as a macro (suggested by Arnd)
- move reset_node struct declaration back to vfio_platform_private.h
- vfio_platform_unregister_reset does not return any value anymore

v1 -> v2:
- reset_list becomes static
- vfio_platform_register/unregister_reset take a const char * as compat
- fix node leak
- add reset_lock to protect the reset list manipulation
- move vfio_platform_reset_node declaration in vfio_platform_common.c
---
 drivers/vfio/platform/vfio_platform_common.c  | 26 ++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h | 20 ++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 184e9d2..8eccd30 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -27,6 +27,7 @@
 #define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
 #define DRIVER_DESC     "VFIO platform base module"
 
+static LIST_HEAD(reset_list);
 static DEFINE_MUTEX(driver_lock);
 
 static const struct vfio_platform_reset_combo reset_lookup_table[] = {
@@ -578,6 +579,31 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
 
+int __vfio_platform_register_reset(struct vfio_platform_reset_node *node)
+{
+	mutex_lock(&driver_lock);
+	list_add(&node->link, &reset_list);
+	mutex_unlock(&driver_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__vfio_platform_register_reset);
+
+void vfio_platform_unregister_reset(const char *compat)
+{
+	struct vfio_platform_reset_node *iter, *temp;
+
+	mutex_lock(&driver_lock);
+	list_for_each_entry_safe(iter, temp, &reset_list, link) {
+		if (!strcmp(iter->compat, compat)) {
+			list_del(&iter->link);
+			break;
+		}
+	}
+
+	mutex_unlock(&driver_lock);
+}
+EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
+
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 7128690..277521a 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -71,6 +71,15 @@ struct vfio_platform_device {
 	int	(*reset)(struct vfio_platform_device *vdev);
 };
 
+typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
+
+struct vfio_platform_reset_node {
+	struct list_head link;
+	char *compat;
+	struct module *owner;
+	vfio_platform_reset_fn_t reset;
+};
+
 struct vfio_platform_reset_combo {
 	const char *compat;
 	const char *reset_function_name;
@@ -90,4 +99,15 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 					unsigned start, unsigned count,
 					void *data);
 
+extern int __vfio_platform_register_reset(struct vfio_platform_reset_node *n);
+extern void vfio_platform_unregister_reset(const char *compat);
+
+#define vfio_platform_register_reset(__compat, __reset)		\
+static struct vfio_platform_reset_node __reset ## _node = {	\
+	.owner = THIS_MODULE,					\
+	.compat = __compat,					\
+	.reset = __reset,					\
+};								\
+__vfio_platform_register_reset(&__reset ## _node)
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
1.9.1
