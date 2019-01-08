From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v3 04/21] vfio: VFIO_IOMMU_SET_PASID_TABLE
Date: Tue,  8 Jan 2019 11:26:16 +0100
Message-ID: <20190108102633.17482-5-eric.auger@redhat.com>
References: <20190108102633.17482-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E7CA4A42F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 05:27:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8+EoLn5wRs1R for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jan 2019 05:27:15 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D3734A42A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jan 2019 05:27:15 -0500 (EST)
In-Reply-To: <20190108102633.17482-1-eric.auger@redhat.com>
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

From: "Liu, Yi L" <yi.l.liu@linux.intel.com>

This patch adds VFIO_IOMMU_SET_PASID_TABLE ioctl which aims at
passing the virtual iommu guest configuration to the VFIO driver
downto to the iommu subsystem.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v2 -> v3:
- s/BIND_PASID_TABLE/SET_PASID_TABLE

v1 -> v2:
- s/BIND_GUEST_STAGE/BIND_PASID_TABLE
- remove the struct device arg
---
 drivers/vfio/vfio_iommu_type1.c | 31 +++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  8 ++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 7651cfb14836..d9dd23f64f00 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1644,6 +1644,24 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	return ret;
 }
 
+static int
+vfio_set_pasid_table(struct vfio_iommu *iommu,
+		      struct vfio_iommu_type1_set_pasid_table *ustruct)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_set_pasid_table(d->domain, &ustruct->config);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1714,6 +1732,19 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+	} else if (cmd == VFIO_IOMMU_SET_PASID_TABLE) {
+		struct vfio_iommu_type1_set_pasid_table ustruct;
+
+		minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table,
+				    config);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		return vfio_set_pasid_table(iommu, &ustruct);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 02bb7ad6e986..0d9f4090c95d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -759,6 +760,13 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+struct vfio_iommu_type1_set_pasid_table {
+	__u32	argsz;
+	__u32	flags;
+	struct iommu_pasid_table_config config;
+};
+#define VFIO_IOMMU_SET_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.17.2
