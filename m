From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 1/5] VFIO: platform: add reset_list and register/unregister functions
Date: Thu,  7 May 2015 16:27:19 +0200
Message-ID: <1431008843-28411-2-git-send-email-eric.auger@linaro.org>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org, agraf@suse.de, Bharat.Bhushan@freescale.com
List-Id: kvmarm@lists.cs.columbia.edu

vfio_platform_common now stores a lists of available reset functions.
Two functions are exposed to register/unregister a reset function. A
reset function is paired with a compat string.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_common.c  | 63 +++++++++++++++++++++++++++
 drivers/vfio/platform/vfio_platform_private.h | 13 ++++++
 2 files changed, 76 insertions(+)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index abcff7a..edbf24c 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -23,6 +23,9 @@
 
 #include "vfio_platform_private.h"
 
+struct list_head reset_list;
+LIST_HEAD(reset_list);
+
 static DEFINE_MUTEX(driver_lock);
 
 static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
@@ -511,6 +514,13 @@ EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
 struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
 {
 	struct vfio_platform_device *vdev;
+	struct vfio_platform_reset_node *iter, *tmp;
+
+	list_for_each_entry_safe(iter, tmp, &reset_list, link) {
+		list_del(&iter->link);
+		kfree(iter->compat);
+		kfree(iter);
+	}
 
 	vdev = vfio_del_group_dev(dev);
 	if (vdev)
@@ -519,3 +529,56 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
 	return vdev;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
+
+int vfio_platform_register_reset(char *compat, struct module *reset_owner,
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
index 5d31e04..da2d60b 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -69,6 +69,15 @@ struct vfio_platform_device {
 	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
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
@@ -82,4 +91,8 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
 					unsigned start, unsigned count,
 					void *data);
 
+extern int vfio_platform_register_reset(char *compat, struct module *owner,
+					vfio_platform_reset_fn_t reset);
+extern int vfio_platform_unregister_reset(char *compat);
+
 #endif /* VFIO_PLATFORM_PRIVATE_H */
-- 
1.9.1

