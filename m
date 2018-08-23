From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 05/13] vfio: VFIO_IOMMU_TLB_INVALIDATE
Date: Thu, 23 Aug 2018 14:17:28 +0200
Message-ID: <1535026656-8450-6-git-send-email-eric.auger__6919.81139029867$1535038714$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EB014A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kGbYIlK3T01q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:18:00 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9FFA04A22C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:00 -0400 (EDT)
In-Reply-To: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jean-philippe.brucker@arm.com,
 jacob.jun.pan@linux.intel.com, yi.l.liu"@linux.intel.com, will.deacon@arm.com, robin.murphy@arm.com
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

From: "Liu, Yi L" <yi.l.liu@linux.intel.com>

This patch adds the VFIO_IOMMU_TLB_INVALIDATE ioctl with aims
at propagating stage1 IOMMU TLB invalidations from guest to host.

In the case of SVM virtualization on VT-d, host IOMMU driver has
no knowledge of caching structure updates unless the guest
invalidation activities are passed down to the host. So a new
IOCTL is needed to propagate the guest cache invalidation through
VFIO.

Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

For SMMUv3 invalidations, the device parameter is not needed
---
 drivers/vfio/vfio_iommu_type1.c | 23 +++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  7 +++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 83c7f96..973bb4d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1687,6 +1687,15 @@ static int bind_guest_stage_fn(struct device *dev, void *data)
 	return iommu_bind_guest_stage(task->domain, dev, &ustruct->config);
 }
 
+static int do_tlb_inv_fn(struct device *dev, void *data)
+{
+	struct vfio_iommu_type1_tlb_invalidate *ustruct;
+	struct vfio_iommu_task *task = data;
+
+	ustruct = task->payload;
+	return iommu_tlb_invalidate(task->domain, dev, &ustruct->info);
+}
+
 static int vfio_iommu_dispatch_task(struct vfio_iommu *iommu, void *data,
 				    int (*fn)(struct device *, void *))
 {
@@ -1799,6 +1808,20 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return vfio_iommu_dispatch_task(iommu, (u8 *)&ustruct,
 						bind_guest_stage_fn);
+	} else if (cmd == VFIO_IOMMU_TLB_INVALIDATE) {
+		struct vfio_iommu_type1_tlb_invalidate ustruct;
+
+		minsz = offsetofend(struct vfio_iommu_type1_tlb_invalidate,
+				    info);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		return vfio_iommu_dispatch_task(iommu, (u8 *)&ustruct,
+						do_tlb_inv_fn);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index a5801ed..b59f9fc 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -673,6 +673,13 @@ struct vfio_iommu_type1_bind_guest_stage {
 };
 #define VFIO_IOMMU_BIND_GUEST_STAGE	_IO(VFIO_TYPE, VFIO_BASE + 22)
 
+struct vfio_iommu_type1_tlb_invalidate {
+	__u32   argsz;
+	__u32   flags;
+	struct iommu_tlb_invalidate_info info;
+};
+#define VFIO_IOMMU_TLB_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 23)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.5.5
