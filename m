From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v6 5/8] vfio: platform: add compat in vfio_platform_device
Date: Tue,  3 Nov 2015 18:12:16 +0000
Message-ID: <1446574339-1843-6-git-send-email-eric.auger@linaro.org>
References: <1446574339-1843-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A90498E9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 13:09:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CZhRLzlnKZBe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 13:09:22 -0500 (EST)
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
 [209.85.212.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D119498ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 13:09:22 -0500 (EST)
Received: by wicll6 with SMTP id ll6so75145665wic.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 Nov 2015 10:12:33 -0800 (PST)
In-Reply-To: <1446574339-1843-1-git-send-email-eric.auger@linaro.org>
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
