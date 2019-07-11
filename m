Return-Path: <SRS0=dYxC=VI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A21C74A35
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 13:57:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 86561216C4
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jul 2019 13:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86561216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 163144A534;
	Thu, 11 Jul 2019 09:57:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gQlX9ECvPUY5; Thu, 11 Jul 2019 09:57:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F340D4A4E5;
	Thu, 11 Jul 2019 09:56:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A7C04A4FB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 09:56:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oFXaGWv6vS9w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jul 2019 09:56:57 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E7834A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jul 2019 09:56:57 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 7AABF3086268;
 Thu, 11 Jul 2019 13:56:56 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-46.ams2.redhat.com [10.36.116.46])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8FB4860600;
 Thu, 11 Jul 2019 13:56:45 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com,
 iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
 alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
 yi.l.liu@intel.com, jean-philippe.brucker@arm.com, will.deacon@arm.com,
 robin.murphy@arm.com
Subject: [PATCH v9 03/11] vfio: VFIO_IOMMU_SET_MSI_BINDING
Date: Thu, 11 Jul 2019 15:56:17 +0200
Message-Id: <20190711135625.20684-4-eric.auger@redhat.com>
In-Reply-To: <20190711135625.20684-1-eric.auger@redhat.com>
References: <20190711135625.20684-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.49]); Thu, 11 Jul 2019 13:56:56 +0000 (UTC)
Cc: kevin.tian@intel.com, vincent.stehle@arm.com, ashok.raj@intel.com,
 marc.zyngier@arm.com, tina.zhang@intel.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This patch adds the VFIO_IOMMU_SET_MSI_BINDING ioctl which aim
to (un)register the guest MSI binding to the host. This latter
then can use those stage 1 bindings to build a nested stage
binding targeting the physical MSIs.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v8 -> v9:
- merge VFIO_IOMMU_BIND_MSI/VFIO_IOMMU_UNBIND_MSI into a single
  VFIO_IOMMU_SET_MSI_BINDING ioctl
- ioctl id changed

v6 -> v7:
- removed the dev arg

v3 -> v4:
- add UNBIND
- unwind on BIND error

v2 -> v3:
- adapt to new proto of bind_guest_msi
- directly use vfio_iommu_for_each_dev

v1 -> v2:
- s/vfio_iommu_type1_guest_msi_binding/vfio_iommu_type1_bind_guest_msi
---
 drivers/vfio/vfio_iommu_type1.c | 55 +++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h       | 20 ++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 307f059d3080..c858be878590 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -1829,6 +1829,42 @@ static int vfio_cache_inv_fn(struct device *dev, void *data)
 	return iommu_cache_invalidate(dc->domain, dev, &ustruct->info);
 }
 
+static int
+vfio_bind_msi(struct vfio_iommu *iommu,
+	      dma_addr_t giova, phys_addr_t gpa, size_t size)
+{
+	struct vfio_domain *d;
+	int ret = 0;
+
+	mutex_lock(&iommu->lock);
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_bind_guest_msi(d->domain, giova, gpa, size);
+		if (ret)
+			goto unwind;
+	}
+	goto unlock;
+unwind:
+	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next) {
+		iommu_unbind_guest_msi(d->domain, giova);
+	}
+unlock:
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static void
+vfio_unbind_msi(struct vfio_iommu *iommu, dma_addr_t giova)
+{
+	struct vfio_domain *d;
+
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		iommu_unbind_guest_msi(d->domain, giova);
+	}
+	mutex_unlock(&iommu->lock);
+}
+
 static long vfio_iommu_type1_ioctl(void *iommu_data,
 				   unsigned int cmd, unsigned long arg)
 {
@@ -1936,6 +1972,25 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 					    &ustruct);
 		mutex_unlock(&iommu->lock);
 		return ret;
+	} else if (cmd == VFIO_IOMMU_SET_MSI_BINDING) {
+		struct vfio_iommu_type1_set_msi_binding ustruct;
+
+		minsz = offsetofend(struct vfio_iommu_type1_set_msi_binding,
+				    size);
+
+		if (copy_from_user(&ustruct, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (ustruct.argsz < minsz)
+			return -EINVAL;
+
+		if (ustruct.flags == VFIO_IOMMU_UNBIND_MSI)
+			vfio_unbind_msi(iommu, ustruct.iova);
+		else if (ustruct.flags == VFIO_IOMMU_BIND_MSI)
+			return vfio_bind_msi(iommu, ustruct.iova, ustruct.gpa,
+						ustruct.size);
+		else
+			return -EINVAL;
 	}
 
 	return -ENOTTY;
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index b31c25b682c5..deadbd84f2cf 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -795,6 +795,26 @@ struct vfio_iommu_type1_cache_invalidate {
 };
 #define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 23)
 
+/**
+ * VFIO_IOMMU_SET_MSI_BINDING - _IOWR(VFIO_TYPE, VFIO_BASE + 24,
+ *			struct vfio_iommu_type1_set_msi_binding)
+ *
+ * Pass a stage 1 MSI doorbell mapping to the host so that this
+ * latter can build a nested stage2 mapping. Or conversely tear
+ * down a previously bound stage 1 MSI binding.
+ */
+struct vfio_iommu_type1_set_msi_binding {
+	__u32   argsz;
+	__u32   flags;
+#define VFIO_IOMMU_BIND_MSI	(1 << 0)
+#define VFIO_IOMMU_UNBIND_MSI	(1 << 1)
+	__u64	iova;	/* MSI guest IOVA */
+	/* Fields below are used on BIND */
+	__u64	gpa;	/* MSI guest physical address */
+	__u64	size;	/* size of stage1 mapping (bytes) */
+};
+#define VFIO_IOMMU_SET_MSI_BINDING      _IO(VFIO_TYPE, VFIO_BASE + 24)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
