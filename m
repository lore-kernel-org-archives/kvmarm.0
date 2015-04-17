From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 1/3] VFIO: platform: add reset support
Date: Fri, 17 Apr 2015 15:37:11 +0200
Message-ID: <1429277833-28663-2-git-send-email-eric.auger@linaro.org>
References: <1429277833-28663-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 457324DDC3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 09:32:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s9wBOBpRWXed for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2015 09:32:07 -0400 (EDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
 [209.85.212.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69F934DE27
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 09:32:07 -0400 (EDT)
Received: by widdi4 with SMTP id di4so20869174wid.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2015 06:40:04 -0700 (PDT)
In-Reply-To: <1429277833-28663-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de, b.reynal@virtualopensystems.com
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds support for vfio platform reset. The modality only is
exposed when a specialized VFIO driver populates the reset callback.
For the generic vfio platform/amba driver, the modality is not supported
since the driver is by essence a metadriver and does not know how to
reset the underlying device.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_common.c  | 12 ++++++++++--
 drivers/vfio/platform/vfio_platform_private.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 4113d46..b989ce5 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -100,6 +100,8 @@ static void vfio_platform_release(void *device_data)
 	mutex_lock(&driver_lock);
 
 	if (!(--vdev->refcnt)) {
+		if (vdev->reset)
+			vdev->reset(vdev);
 		vfio_platform_regions_cleanup(vdev);
 		vfio_platform_irq_cleanup(vdev);
 	}
@@ -159,6 +161,8 @@ static long vfio_platform_ioctl(void *device_data,
 		if (info.argsz < minsz)
 			return -EINVAL;
 
+		if (vdev->reset)
+			vdev->flags |= VFIO_DEVICE_FLAGS_RESET;
 		info.flags = vdev->flags;
 		info.num_regions = vdev->num_regions;
 		info.num_irqs = vdev->num_irqs;
@@ -252,8 +256,12 @@ static long vfio_platform_ioctl(void *device_data,
 
 		return ret;
 
-	} else if (cmd == VFIO_DEVICE_RESET)
-		return -EINVAL;
+	} else if (cmd == VFIO_DEVICE_RESET) {
+		if (vdev->reset)
+			return vdev->reset(vdev);
+		else
+			return -ENOTTY;
+	}
 
 	return -ENOTTY;
 }
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 253caa3..0a20028 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -68,6 +68,7 @@ struct vfio_platform_device {
 	struct resource*
 		(*get_resource)(struct vfio_platform_device *vdev, int i);
 	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
+	int	(*reset)(struct vfio_platform_device *vdev);
 };
 
 extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
-- 
1.9.1
