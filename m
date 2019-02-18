From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 09/22] vfio: VFIO_IOMMU_BIND/UNBIND_MSI
Date: Mon, 18 Feb 2019 14:54:50 +0100
Message-ID: <20190218135504.25048-10-eric.auger@redhat.com>
References: <20190218135504.25048-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 874FC4A1FA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 08:56:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KwRwJKx4tUiU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 08:56:39 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99A064A0CC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 08:56:39 -0500 (EST)
In-Reply-To: <20190218135504.25048-1-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com, kevin.tian@intel.com, ashok.raj@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds the VFIO_IOMMU_BIND/UNBIND_MSI ioctl which aim
to pass/withdraw the guest MSI binding to/from the host.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v3 -> v4:
- add UNBIND
- unwind on BIND error

v2 -> v3:
- adapt to new proto of bind_guest_msi
- directly use vfio_iommu_for_each_dev

v1 -> v2:
- s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
---
 drivers/vfio/vfio_iommu_type1.c | 58 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 29 +++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 12a40b9db6aa..66513679081b 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1710,6 +1710,25 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
 	return iommu_cache_invalidate(d, dev, &ustruct->info);
 }
 
+static int vfio_bind_msi_fn(struct device *dev, void *data)
+{
+	struct vfio_iommu_type1_bind_msi *ustruct =
+		(struct vfio_iommu_type1_bind_msi *)data;
+	struct iommu_domain *d = iommu_get_domain_for_dev(dev);
+
+	return iommu_bind_guest_msi(d, dev, ustruct->iova,
+				    ustruct->gpa, ustruct->size);
+}
+
+static int vfio_unbind_msi_fn(struct device *dev, void *data)
+{
+	dma_addr_t *iova = (dma_addr_t *)data;
+	struct iommu_domain *d = iommu_get_domain_for_dev(dev);
+
+	iommu_unbind_guest_msi(d, dev, *iova);
+	return 0;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1814,6 +1833,45 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 					      vfio_cache_inv_fn);
 		mutex_unlock(&iommu->lock);
 		return ret;
+	} else if (cmd == VFIO_IOMMU_BIND_MSI) {
+		struct vfio_iommu_type1_bind_msi ustruct;
+		int ret;
+
+		minsz = offsetofend(struct vfio_iommu_type1_bind_msi,
+				    size);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		mutex_lock(&iommu->lock);
+		ret = vfio_iommu_for_each_dev(iommu, &ustruct,
+					      vfio_bind_msi_fn);
+		if (ret)
+			vfio_iommu_for_each_dev(iommu, &ustruct.iova,
+						vfio_unbind_msi_fn);
+		mutex_unlock(&iommu->lock);
+		return ret;
+	} else if (cmd == VFIO_IOMMU_UNBIND_MSI) {
+		struct vfio_iommu_type1_unbind_msi ustruct;
+		int ret;
+
+		minsz = offsetofend(struct vfio_iommu_type1_unbind_msi,
+				    iova);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		mutex_lock(&iommu->lock);
+		ret = vfio_iommu_for_each_dev(iommu, &ustruct.iova,
+					      vfio_unbind_msi_fn);
+		mutex_unlock(&iommu->lock);
+		return ret;
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 29f0ef2d805d..6763389b6adc 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -789,6 +789,35 @@ struct vfio_iommu_type1_cache_invalidate {
 };
 #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
 
+/**
+ * VFIO_IOMMU_BIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 25,
+ *			struct vfio_iommu_type1_bind_msi)
+ *
+ * Pass a stage 1 MSI doorbell mapping to the host so that this
+ * latter can build a nested stage2 mapping
+ */
+struct vfio_iommu_type1_bind_msi {
+	__u32   argsz;
+	__u32   flags;
+	__u64	iova;
+	__u64	gpa;
+	__u64	size;
+};
+#define VFIO_IOMMU_BIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 25)
+
+/**
+ * VFIO_IOMMU_UNBIND_MSI - _IOWR(VFIO_TYPE, VFIO_BASE + 26,
+ *			struct vfio_iommu_type1_unbind_msi)
+ *
+ * Unregister an MSI mapping
+ */
+struct vfio_iommu_type1_unbind_msi {
+	__u32   argsz;
+	__u32   flags;
+	__u64	iova;
+};
+#define VFIO_IOMMU_UNBIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 26)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.20.1
