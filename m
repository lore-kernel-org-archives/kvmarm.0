From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v7 08/23] vfio: VFIO_IOMMU_CACHE_INVALIDATE
Date: Mon,  8 Apr 2019 14:18:56 +0200
Message-ID: <20190408121911.24103-9-eric.auger@redhat.com>
References: <20190408121911.24103-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190408121911.24103-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org, vincent.stehle@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: "Liu, Yi L" <yi.l.liu@linux.intel.com>

When the guest "owns" the stage 1 translation structures,  the host
IOMMU driver has no knowledge of caching structure updates unless
the guest invalidation requests are trapped and passed down to the
host.

This patch adds the VFIO_IOMMU_CACHE_INVALIDATE ioctl with aims
at propagating guest stage1 IOMMU cache invalidations to the host.

Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v6 -> v7:
- Use iommu_capsule struct
- renamed vfio_iommu_for_each_dev into vfio_iommu_lookup_dev
  due to checkpatch error related to for_each_dev suffix

v2 -> v3:
- introduce vfio_iommu_for_each_dev back in this patch

v1 -> v2:
- s/TLB/CACHE
- remove vfio_iommu_task usage
- commit message rewording
---
 drivers/vfio/vfio_iommu_type1.c | 55 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 13 ++++++++
 2 files changed, 68 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 222e9199edbf..4a6b5a360a5e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -113,6 +113,34 @@ struct vfio_regions {
 #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
 					(!list_empty(&iommu->domain_list))
 
+struct domain_capsule {
+	struct iommu_domain *domain;
+	void *data;
+};
+
+/* iommu->lock must be held */
+static int
+vfio_iommu_lookup_dev(struct vfio_iommu *iommu,
+		      int (*fn)(struct device *dev, void *data),
+		      void *data)
+{
+	struct domain_capsule dc = {.data = data};
+	struct vfio_domain *d;
+	struct vfio_group *g;
+	int ret = 0;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		dc.domain = d->domain;
+		list_for_each_entry(g, &d->group_list, next) {
+			ret = iommu_group_for_each_dev(g->iommu_group,
+						       &dc, fn);
+			if (ret)
+				break;
+		}
+	}
+	return ret;
+}
+
 static int put_pfn(unsigned long pfn, int prot);
 
 /*
@@ -1681,6 +1709,15 @@ vfio_attach_pasid_table(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int vfio_cache_inv_fn(struct device *dev, void *data)
+{
+	struct domain_capsule *dc = (struct domain_capsule *)data;
+	struct vfio_iommu_type1_cache_invalidate *ustruct =
+		(struct vfio_iommu_type1_cache_invalidate *)dc->data;
+
+	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1767,6 +1804,24 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 	} else if (cmd == VFIO_IOMMU_DETACH_PASID_TABLE) {
 		vfio_detach_pasid_table(iommu);
 		return 0;
+	} else if (cmd == VFIO_IOMMU_CACHE_INVALIDATE) {
+		struct vfio_iommu_type1_cache_invalidate ustruct;
+		int ret;
+
+		minsz = offsetofend(struct vfio_iommu_type1_cache_invalidate,
+				    info);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		mutex_lock(&iommu->lock);
+		ret = vfio_iommu_lookup_dev(iommu, vfio_cache_inv_fn,
+					    &ustruct);
+		mutex_unlock(&iommu->lock);
+		return ret;
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 06db3247702f..b5325552bae0 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -781,6 +781,19 @@ struct vfio_iommu_type1_attach_pasid_table {
  */
 #define VFIO_IOMMU_DETACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 23)
 
+/**
+ * VFIO_IOMMU_CACHE_INVALIDATE - _IOWR(VFIO_TYPE, VFIO_BASE + 24,
+ *			struct vfio_iommu_type1_cache_invalidate)
+ *
+ * Propagate guest IOMMU cache invalidation to the host.
+ */
+struct vfio_iommu_type1_cache_invalidate {
+	__u32   argsz;
+	__u32   flags;
+	struct iommu_cache_invalidate_info info;
+};
+#define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.20.1
