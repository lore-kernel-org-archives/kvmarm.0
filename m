From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 06/13] vfio: VFIO_IOMMU_BIND_MSI
Date: Thu, 23 Aug 2018 14:17:29 +0200
Message-ID: <1535026656-8450-7-git-send-email-eric.auger__5700.24818084693$1535038713$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50C914A230
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id APBL60-FMFZR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:18:05 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 899A74A22F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:18:05 -0400 (EDT)
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

This patch adds the VFIO_IOMMU_BIND_MSI ioctl which aims at
passing the guest MSI binding to the host.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 31 +++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  7 +++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 973bb4d..2962cb9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1696,6 +1696,24 @@ static int do_tlb_inv_fn(struct device *dev, void *data)
 	return iommu_tlb_invalidate(task->domain, dev, &ustruct->info);
 }
 
+static int
+vfio_iommu_bind_guest_msi(struct vfio_iommu *iommu,
+			  struct vfio_iommu_type1_guest_msi_binding *ustruct)
+{
+	struct vfio_domain *d;
+	int ret;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_bind_guest_msi(d->domain, &ustruct->binding);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+
 static int vfio_iommu_dispatch_task(struct vfio_iommu *iommu, void *data,
 				    int (*fn)(struct device *, void *))
 {
@@ -1822,6 +1840,19 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return vfio_iommu_dispatch_task(iommu, (u8 *)&ustruct,
 						do_tlb_inv_fn);
+	} else if (cmd == VFIO_IOMMU_BIND_MSI) {
+		struct vfio_iommu_type1_guest_msi_binding ustruct;
+
+		minsz = offsetofend(struct vfio_iommu_type1_guest_msi_binding,
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
index b59f9fc..b7a9943 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -680,6 +680,13 @@ struct vfio_iommu_type1_tlb_invalidate {
 };
 #define VFIO_IOMMU_TLB_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 23)
 
+struct vfio_iommu_type1_guest_msi_binding {
+	__u32   argsz;
+	__u32   flags;
+	struct iommu_guest_msi_binding binding;
+};
+#define VFIO_IOMMU_BIND_MSI      _IO(VFIO_TYPE, VFIO_BASE + 24)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.5.5
