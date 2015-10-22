From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 6/6] vfio: platform: move get/put reset at open/release
Date: Thu, 22 Oct 2015 11:42:02 +0200
Message-ID: <1445506922-6005-7-git-send-email-eric.auger@linaro.org>
References: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7D4041300
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 05:39:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Mnxa6OAzvYCX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Oct 2015 05:39:40 -0400 (EDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
 [209.85.212.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D56B440FF5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 05:39:40 -0400 (EDT)
Received: by wijp11 with SMTP id p11so23072305wij.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Oct 2015 02:42:18 -0700 (PDT)
In-Reply-To: <1445506922-6005-1-git-send-email-eric.auger@linaro.org>
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

Currently reset lookup is done on probe. This introduces a
race with new registration mechanism in the case where the
vfio-platform driver is bound to the device before its module
is loaded: on the load, the probe happens which triggers the
reset module load which itself attempts to get the symbol for
the registration function (vfio_platform_register_reset). The
symbol is not yet available hence the lookup fails. In case we
do the lookup in the first open we are sure the vfio-platform
module is loaded and vfio_platform_register_reset is available.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/platform/vfio_platform_common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 95b8294..5ebae8c 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -155,6 +155,7 @@ static void vfio_platform_release(void *device_data)
 			vdev->reset(vdev);
 		vfio_platform_regions_cleanup(vdev);
 		vfio_platform_irq_cleanup(vdev);
+		vfio_platform_put_reset(vdev);
 	}
 
 	mutex_unlock(&driver_lock);
@@ -181,6 +182,8 @@ static int vfio_platform_open(void *device_data)
 		if (ret)
 			goto err_irq;
 
+		vfio_platform_get_reset(vdev);
+
 		if (vdev->reset)
 			vdev->reset(vdev);
 	}
@@ -570,8 +573,6 @@ int vfio_platform_probe_common(struct vfio_platform_device *vdev,
 		return ret;
 	}
 
-	vfio_platform_get_reset(vdev);
-
 	mutex_init(&vdev->igate);
 
 	return 0;
@@ -585,7 +586,6 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
 	vdev = vfio_del_group_dev(dev);
 
 	if (vdev) {
-		vfio_platform_put_reset(vdev);
 		iommu_group_put(dev->iommu_group);
 	}
 
-- 
1.9.1
