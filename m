From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 18/20] vfio: VFIO_IOMMU_GET_FAULT_EVENTS
Date: Tue, 18 Sep 2018 16:24:55 +0200
Message-ID: <20180918142457.3325-19-eric.auger@redhat.com>
References: <20180918142457.3325-1-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71A8D4A1FE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 10:27:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fENBrIz2pMJO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Sep 2018 10:27:01 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 763F04A0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Sep 2018 10:27:01 -0400 (EDT)
In-Reply-To: <20180918142457.3325-1-eric.auger@redhat.com>
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
Cc: tianyu.lan@intel.com, marc.zyngier@arm.com, ashok.raj@intel.com
List-Id: kvmarm@lists.cs.columbia.edu

Introduce an IOTCL that allows the userspace to consume fault
events that may have occurred. The userspace buffer gets filled
by pending faults, if any. The number of filled faults is
reported to the userspace. Read faults are removed from the kfifo.
the kernel does not expect any response from the userspace.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

the fault_lock may not be needed as kfifo documentation says:
"Note that with only one concurrent reader and one concurrent
writer, you don't need extra locking to use these macro."
---
 drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/vfio.h       | 10 ++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index e52cbeb479c3..917bb8f9c9ae 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1769,7 +1769,7 @@ vfio_iommu_fault_handler(struct iommu_fault_event *event, void *data)
 		eventfd_signal(iommu->fault_ctx, 1);
 out:
 	mutex_unlock(&iommu->fault_lock);
-	return 0;
+	return ret;
 }
 
 static inline int
@@ -1981,6 +1981,37 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 			return -EINVAL;
 
 		return vfio_iommu_set_fault_eventfd(iommu, &ustruct);
+	} else if (cmd == VFIO_IOMMU_GET_FAULT_EVENTS) {
+		struct vfio_iommu_type1_get_fault_events ustruct;
+		size_t buf_size, len, elem_size;
+		int copied, max_events, ret;
+
+		minsz = offsetofend(struct vfio_iommu_type1_get_fault_events,
+				    reserved);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz || ustruct.flags)
+			return -EINVAL;
+
+		elem_size = sizeof(struct iommu_fault);
+		buf_size = ustruct.argsz - minsz;
+		max_events = buf_size / elem_size;
+		len = max_events * elem_size;
+
+		mutex_lock(&iommu->fault_lock);
+
+		ret = kfifo_to_user(&iommu->fault_fifo,
+				    (void __user *)(arg + minsz), len, &copied);
+
+		mutex_unlock(&iommu->fault_lock);
+		if (ret)
+			return ret;
+
+		ustruct.count = copied / elem_size;
+
+		return copy_to_user((void __user *)arg, &ustruct, minsz);
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0d62598c818a..5b9165b7db8d 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -703,6 +703,16 @@ struct vfio_iommu_type1_set_fault_eventfd {
 };
 #define VFIO_IOMMU_SET_FAULT_EVENTFD      _IO(VFIO_TYPE, VFIO_BASE + 25)
 
+struct vfio_iommu_type1_get_fault_events {
+	__u32	argsz;
+	__u32   flags;
+	__u32	count; /* number of faults returned */
+	__u32   reserved;
+	struct iommu_fault events[];
+};
+
+#define VFIO_IOMMU_GET_FAULT_EVENTS	_IO(VFIO_TYPE, VFIO_BASE + 26)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.17.1
