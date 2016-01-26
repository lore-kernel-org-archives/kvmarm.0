From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH 08/10] vfio: introduce vfio_group_require_msi_mapping
Date: Tue, 26 Jan 2016 13:12:46 +0000
Message-ID: <1453813968-2024-9-git-send-email-eric.auger@linaro.org>
References: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A508940B58
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m6YI7KaXiTdT for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 08:08:48 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30890407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 08:08:48 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id b14so129666933wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 05:13:43 -0800 (PST)
In-Reply-To: <1453813968-2024-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, will.deacon@arm.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
List-Id: kvmarm@lists.cs.columbia.edu

This new function enables to know whether msi write transaction
addresses must be mapped.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 drivers/vfio/vfio.c             | 22 ++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c |  8 ++++++++
 include/linux/vfio.h            |  2 ++
 3 files changed, 32 insertions(+)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2760d4c..f3df5a10 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -793,6 +793,28 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 	return NOTIFY_OK;
 }
 
+bool vfio_group_require_msi_mapping(struct vfio_group *group)
+{
+	struct vfio_container *container = group->container;
+	struct vfio_iommu_driver *driver;
+	bool ret;
+
+	down_read(&container->group_lock);
+
+	driver = container->iommu_driver;
+	if (!driver || !driver->ops || !driver->ops->require_msi_mapping) {
+		ret = -EINVAL;
+		goto up;
+	}
+
+	ret = driver->ops->require_msi_mapping(container->iommu_data);
+
+up:
+	up_read(&container->group_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_group_require_msi_mapping);
+
 /**
  * VFIO driver API
  */
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index a79e2a8..2f085d3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1179,6 +1179,13 @@ unlock:
 	return ret;
 }
 
+static bool vfio_iommu_type1_require_msi_mapping(void *iommu_data)
+{
+	struct vfio_iommu *iommu = iommu_data;
+
+	return vfio_domains_require_msi_mapping(iommu);
+}
+
 static void *vfio_iommu_type1_open(unsigned long arg)
 {
 	struct vfio_iommu *iommu;
@@ -1336,6 +1343,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 		vfio_iommu_type1_alloc_map_reserved_iova,
 	.unmap_free_reserved_iova	=
 		vfio_iommu_type1_unmap_free_reserved_iova,
+	.require_msi_mapping		= vfio_iommu_type1_require_msi_mapping,
 };
 
 static int __init vfio_iommu_type1_init(void)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index f7eaf30..3e6cbeb 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -58,6 +58,7 @@ extern void *vfio_del_group_dev(struct device *dev);
 extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
 extern void vfio_device_put(struct vfio_device *device);
 extern void *vfio_device_data(struct vfio_device *device);
+extern bool vfio_group_require_msi_mapping(struct vfio_group *group);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
@@ -85,6 +86,7 @@ struct vfio_iommu_driver_ops {
 	int		(*unmap_free_reserved_iova)(void *iommu_data,
 						    struct iommu_group *group,
 						    dma_addr_t iova);
+	bool		(*require_msi_mapping)(void *iommu_data);
 };
 
 extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
-- 
1.9.1
