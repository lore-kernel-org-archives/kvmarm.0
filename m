From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 1/7] vfio: platform: introduce vfio-platform-base module
Date: Fri, 23 Oct 2015 14:37:09 +0200
Message-ID: <1445603835-14506-2-git-send-email-eric.auger@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADBA41978
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F1q9HlAlxWau for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 08:34:43 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 54974412C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:43 -0400 (EDT)
Received: by wikq8 with SMTP id q8so74964153wik.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 05:37:23 -0700 (PDT)
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

To prepare for vfio platform reset rework let's build
vfio_platform_common.c and vfio_platform_irq.c in a separate
module from vfio-platform and vfio-amba. This makes possible
to have separate module inits and works around a race between
platform driver init and vfio reset module init: that way we
make sure symbols exported by base are available when vfio-platform
driver gets probed.

The open/release being implemented in the base module, the ref
count is applied to the parent module instead.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>

---

v3: creation
---
 drivers/vfio/platform/Makefile                |  6 ++++--
 drivers/vfio/platform/vfio_amba.c             |  1 +
 drivers/vfio/platform/vfio_platform.c         |  1 +
 drivers/vfio/platform/vfio_platform_common.c  | 13 +++++++++++--
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 5 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
index 9ce8afe..41a6224 100644
--- a/drivers/vfio/platform/Makefile
+++ b/drivers/vfio/platform/Makefile
@@ -1,10 +1,12 @@
-
-vfio-platform-y := vfio_platform.o vfio_platform_common.o vfio_platform_irq.o
+vfio-platform-base-y := vfio_platform_common.o vfio_platform_irq.o
+vfio-platform-y := vfio_platform.o
 
 obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
+obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform-base.o
 obj-$(CONFIG_VFIO_PLATFORM) += reset/
 
 vfio-amba-y := vfio_amba.o
 
 obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
+obj-$(CONFIG_VFIO_AMBA) += vfio-platform-base.o
 obj-$(CONFIG_VFIO_AMBA) += reset/
diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
index ff0331f..a66479b 100644
--- a/drivers/vfio/platform/vfio_amba.c
+++ b/drivers/vfio/platform/vfio_amba.c
@@ -67,6 +67,7 @@ static int vfio_amba_probe(struct amba_device *adev, const struct amba_id *id)
 	vdev->flags = VFIO_DEVICE_FLAGS_AMBA;
 	vdev->get_resource = get_amba_resource;
 	vdev->get_irq = get_amba_irq;
+	vdev->parent_module = THIS_MODULE;
 
 	ret = vfio_platform_probe_common(vdev, &adev->dev);
 	if (ret) {
diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
index cef645c..f1625dc 100644
--- a/drivers/vfio/platform/vfio_platform.c
+++ b/drivers/vfio/platform/vfio_platform.c
@@ -65,6 +65,7 @@ static int vfio_platform_probe(struct platform_device *pdev)
 	vdev->flags = VFIO_DEVICE_FLAGS_PLATFORM;
 	vdev->get_resource = get_platform_resource;
 	vdev->get_irq = get_platform_irq;
+	vdev->parent_module = THIS_MODULE;
 
 	ret = vfio_platform_probe_common(vdev, &pdev->dev);
 	if (ret)
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index e43efb5..184e9d2 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -23,6 +23,10 @@
 
 #include "vfio_platform_private.h"
 
+#define DRIVER_VERSION  "0.10"
+#define DRIVER_AUTHOR   "Antonios Motakis <a.motakis@virtualopensystems.com>"
+#define DRIVER_DESC     "VFIO platform base module"
+
 static DEFINE_MUTEX(driver_lock);
 
 static const struct vfio_platform_reset_combo reset_lookup_table[] = {
@@ -146,7 +150,7 @@ static void vfio_platform_release(void *device_data)
 
 	mutex_unlock(&driver_lock);
 
-	module_put(THIS_MODULE);
+	module_put(vdev->parent_module);
 }
 
 static int vfio_platform_open(void *device_data)
@@ -154,7 +158,7 @@ static int vfio_platform_open(void *device_data)
 	struct vfio_platform_device *vdev = device_data;
 	int ret;
 
-	if (!try_module_get(THIS_MODULE))
+	if (!try_module_get(vdev->parent_module))
 		return -ENODEV;
 
 	mutex_lock(&driver_lock);
@@ -573,3 +577,8 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
 	return vdev;
 }
 EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 1c9b3d5..7128690 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -56,6 +56,7 @@ struct vfio_platform_device {
 	u32				num_irqs;
 	int				refcnt;
 	struct mutex			igate;
+	struct module			*parent_module;
 
 	/*
 	 * These fields should be filled by the bus specific binder
-- 
1.9.1
