From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v5 5/7] vfio: platform: add compat in vfio_platform_device
Date: Wed, 28 Oct 2015 13:02:36 +0000
Message-ID: <1446037358-2079-6-git-send-email-eric.auger@linaro.org>
References: <1446037358-2079-1-git-send-email-eric.auger@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446037358-2079-1-git-send-email-eric.auger@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Let's retrieve the compatibility string on probe and store it
in the vfio_platform_device struct

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v2 -> v3:
- populate compat after vdev check
---
 drivers/vfio/platform/vfio_platform_common.c  | 15 ++++++++-------
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 3b7e52c..f2d41a0 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -41,16 +41,11 @@ static const struct vfio_platform_reset_combo reset_lookup_table[] = {
 static void vfio_platform_get_reset(struct vfio_platform_device *vdev,
 				    struct device *dev)
 {
-	const char *compat;
 	int (*reset)(struct vfio_platform_device *);
-	int ret, i;
-
-	ret = device_property_read_string(dev, "compatible", &compat);
-	if (ret)
-		return;
+	int i;
 
 	for (i = 0 ; i < ARRAY_SIZE(reset_lookup_table); i++) {
-		if (!strcmp(reset_lookup_table[i].compat, compat)) {
+		if (!strcmp(reset_lookup_table[i].compat, vdev->compat)) {
 			request_module(reset_lookup_table[i].module_name);
 			reset = __symbol_get(
 				reset_lookup_table[i].reset_function_name);
@@ -544,6 +539,12 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 	if (!vdev)
 		return -EINVAL;
 
+	ret = device_property_read_string(dev, "compatible", &vdev->compat);
+	if (ret) {
+		pr_err("VFIO: cannot retrieve compat for %s\n", vdev->name);
+		return -EINVAL;
+	}
+
 	group = iommu_group_get(dev);
 	if (!group) {
 		pr_err("VFIO: No IOMMU group for device %s\n", vdev->name);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index fd262be..415310f 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -57,6 +57,7 @@ struct vfio_platform_device {
 	int				refcnt;
 	struct mutex			igate;
 	struct module			*parent_module;
+	const char			*compat;
 
 	/*
 	 * These fields should be filled by the bus specific binder
-- 
1.9.1
