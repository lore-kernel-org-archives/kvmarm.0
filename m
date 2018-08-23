From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 04/13] vfio: VFIO_IOMMU_BIND_GUEST_STAGE
Date: Thu, 23 Aug 2018 14:17:27 +0200
Message-ID: <1535026656-8450-5-git-send-email-eric.auger__22872.3368760713$1535038714$gmane$org@redhat.com>
References: <1535026656-8450-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3439E4A1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N3AOvHeXTlWs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 08:17:56 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CE024A210
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 08:17:56 -0400 (EDT)
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

This patch adds VFIO_IOMMU_BIND_GUEST_STAGE ioctl which aims at
passing the virtual iommu guest configuration to the VFIO driver
downto to the iommu subsystem.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

for SMMUV3 S1 config data passing the device parameter is not needed.
---
 drivers/vfio/vfio_iommu_type1.c | 56 +++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       |  8 ++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index d9fd318..83c7f96 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1673,6 +1673,48 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
 	return ret;
 }
 
+struct vfio_iommu_task {
+	struct iommu_domain *domain;
+	void *payload;
+};
+
+static int bind_guest_stage_fn(struct device *dev, void *data)
+{
+	struct vfio_iommu_type1_bind_guest_stage *ustruct;
+	struct vfio_iommu_task *task = data;
+
+	ustruct = task->payload;
+	return iommu_bind_guest_stage(task->domain, dev, &ustruct->config);
+}
+
+static int vfio_iommu_dispatch_task(struct vfio_iommu *iommu, void *data,
+				    int (*fn)(struct device *, void *))
+{
+	int ret = 0;
+	struct vfio_domain *d;
+	struct vfio_group *g;
+	struct vfio_iommu_task task;
+
+	task.payload = data;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		list_for_each_entry(g, &d->group_list, next) {
+			if (g->iommu_group != NULL) {
+				task.domain = d->domain;
+				ret = iommu_group_for_each_dev(
+					g->iommu_group, &task, fn);
+				if (ret != 0)
+					break;
+			}
+		}
+	}
+
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1743,6 +1785,20 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		return copy_to_user((void __user *)arg, &unmap, minsz) ?
 			-EFAULT : 0;
+	} else if (cmd == VFIO_IOMMU_BIND_GUEST_STAGE) {
+		struct vfio_iommu_type1_bind_guest_stage ustruct;
+
+		minsz = offsetofend(struct vfio_iommu_type1_bind_guest_stage,
+				    config);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		return vfio_iommu_dispatch_task(iommu, (u8 *)&ustruct,
+						bind_guest_stage_fn);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 1aa7b82..a5801ed 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -665,6 +666,13 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+struct vfio_iommu_type1_bind_guest_stage {
+	__u32	argsz;
+	__u32	flags;
+	struct iommu_guest_stage_config config;
+};
+#define VFIO_IOMMU_BIND_GUEST_STAGE	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.5.5
