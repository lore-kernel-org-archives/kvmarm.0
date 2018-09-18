From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 06/20] vfio: VFIO_IOMMU_BIND_MSI
Date: Tue, 18 Sep 2018 16:24:43 +0200
Message-ID: <20180918142457.3325-7-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org, alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com, yi.l.liu@linux.intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: tianyu.lan@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com, christoffer.dall@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds the VFIO_IOMMU_BIND_MSI ioctl which aims at
passing the guest MSI binding to the host.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
---
 drivers/vfio/vfio_iommu_type1.c | 31 +++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  7 +++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 14529233f774..2ffd46c26dc3 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1704,6 +1704,24 @@ vfio_cache_invalidate(struct vfio_iommu *iommu,
 	return ret;
 }
 
+static int
+vfio_iommu_bind_guest_msi(struct vfio_iommu *iommu,
+			  struct vfio_iommu_type1_bind_guest_msi *ustruct)
+{
+	struct vfio_domain *d;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_bind_guest_msi(d->domain, &ustruct->binding);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static int
 vfio_bind_pasid_table(struct vfio_iommu *iommu,
 		      struct vfio_iommu_type1_bind_pasid_table *ustruct)
@@ -1818,6 +1836,19 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			return -EINVAL;
 
 		return vfio_cache_invalidate(iommu, &ustruct);
+	} else if (cmd == VFIO_IOMMU_BIND_MSI) {
+		struct vfio_iommu_type1_bind_guest_msi ustruct;
+
+		minsz = offsetofend(struct vfio_iommu_type1_bind_guest_msi,
+				    binding);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		return vfio_iommu_bind_guest_msi(iommu, &ustruct);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 2a38d0bca0ca..6fb5e944e73c 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -680,6 +680,13 @@ struct vfio_iommu_type1_cache_invalidate {
 };
 #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 23)
 
+struct vfio_iommu_type1_bind_guest_msi {
+	__u32   argsz;
+	__u32   flags;
+	struct iommu_guest_msi_binding binding;
+};
+#define VFIO_IOMMU_BIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 24)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.17.1
