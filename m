From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 1/4] vfio: platform: add capability to register a reset
 function
Date: Sun, 18 Oct 2015 18:00:12 +0200
Message-ID: <1445184015-24414-2-git-send-email-eric.auger@linaro.org>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C06A41280
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sIWZe-RnLOoq for <kvmarm@lists.cs.columbia.edu>;
 Sun, 18 Oct 2015 11:58:16 -0400 (EDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A90B4130A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 11:58:15 -0400 (EDT)
Received: by wikq8 with SMTP id q8so20935089wik.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 18 Oct 2015 09:00:42 -0700 (PDT)
In-Reply-To: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
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
 drivers/vfio/platform/vfio_platform_common.c  | 55 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h | 14 +++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index e43efb5..d36afc9 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -23,6 +23,8 @@
 
 #include "vfio_platform_private.h"
 
+struct list_head reset_list;
+LIST_HEAD(reset_list);
 static DEFINE_MUTEX(driver_lock);
 
 static const struct vfio_platform_reset_combo reset_lookup_table[] = {
@@ -573,3 +575,56 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
 	return vdev;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
+
+int vfio_platform_register_reset(struct module *reset_owner, char *compat,
+				 vfio_platform_reset_fn_t reset)
+{
+	struct vfio_platform_reset_node *node, *iter;
+	bool found = false;
+
+	list_for_each_entry(iter, &reset_list, link) {
+		if (!strcmp(iter->compat, compat)) {
+			found = true;
+			break;
+		}
+	}
+	if (found)
+		return -EINVAL;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	node->compat = kstrdup(compat, GFP_KERNEL);
+	if (!node->compat)
+		return -ENOMEM;
+
+	node->owner = reset_owner;
+	node->reset = reset;
+
+	list_add(&node->link, &reset_list);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_platform_register_reset);
+
+int vfio_platform_unregister_reset(char *compat)
+{
+	struct vfio_platform_reset_node *iter;
+	bool found = false;
+
+	list_for_each_entry(iter, &reset_list, link) {
+		if (!strcmp(iter->compat, compat)) {
+			found = true;
+			break;
+		}
+	}
+	if (!found)
+		return -EINVAL;
+
+	list_del(&iter->link);
+	kfree(iter->compat);
+	kfree(iter);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
+
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 1c9b3d5..17323f0 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -76,6 +76,15 @@ struct vfio_platform_reset_combo {
 	const char *module_name;
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
 extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 				      struct device *dev);
 extern struct vfio_platform_device *vfio_platform_remove_common
@@ -89,4 +98,9 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 					unsigned start, unsigned count,
 					void *data);
 
+extern int vfio_platform_register_reset(struct module *owner,
+					char *compat,
+					vfio_platform_reset_fn_t reset);
+extern int vfio_platform_unregister_reset(char *compat);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
1.9.1
