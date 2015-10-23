From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 7/7] vfio: platform: add dev_info on device reset
Date: Fri, 23 Oct 2015 14:37:15 +0200
Message-ID: <1445603835-14506-8-git-send-email-eric.auger@linaro.org>
References: <1445603835-14506-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A1B141338
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3BnAf46mWeox for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Oct 2015 08:34:53 -0400 (EDT)
Received: from mail-wi0-f176.google.com (mail-wi0-f176.google.com
 [209.85.212.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31C4F41711
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 08:34:53 -0400 (EDT)
Received: by wikq8 with SMTP id q8so74970750wik.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Oct 2015 05:37:33 -0700 (PDT)
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

It might be helpful for the end-user to check the device reset
function was found by the vfio platform reset framework.

Lets store a pointer to the struct device in vfio_platform_device
and trace when the reset function is called or not found.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v3: creation
---
 drivers/vfio/platform/vfio_platform_common.c  | 14 ++++++++++++--
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index de3fb33..207fab6 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -144,8 +144,12 @@ static void vfio_platform_release(void *device_data)
 	mutex_lock(&driver_lock);
 
 	if (!(--vdev->refcnt)) {
-		if (vdev->reset)
+		if (vdev->reset) {
+			dev_info(vdev->device, "reset\n");
 			vdev->reset(vdev);
+		} else {
+			dev_warn(vdev->device, "no reset function found!\n");
+		}
 		vfio_platform_regions_cleanup(vdev);
 		vfio_platform_irq_cleanup(vdev);
 	}
@@ -174,8 +178,12 @@ static int vfio_platform_open(void *device_data)
 		if (ret)
 			goto err_irq;
 
-		if (vdev->reset)
+		if (vdev->reset) {
+			dev_info(vdev->device, "reset\n");
 			vdev->reset(vdev);
+		} else {
+			dev_warn(vdev->device, "no reset function found!\n");
+		}
 	}
 
 	vdev->refcnt++;
@@ -551,6 +559,8 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return -EINVAL;
 	}
 
+	vdev->device = dev;
+
 	group = iommu_group_get(dev);
 	if (!group) {
 		pr_err("VFIO: No IOMMU group for device %s\n", vdev->name);
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index e505c15..ccb99b4 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -59,6 +59,7 @@ struct vfio_platform_device {
 	struct module			*parent_module;
 	const char			*compat;
 	struct module			*reset_module;
+	struct device			*device;
 
 	/*
 	 * These fields should be filled by the bus specific binder
-- 
1.9.1
