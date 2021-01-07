Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08814C433E0
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 09:29:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79C1F23355
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 09:29:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79C1F23355
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1679D4B3D3;
	Thu,  7 Jan 2021 04:29:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g8VKkawqJStW; Thu,  7 Jan 2021 04:29:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57AA44B3E6;
	Thu,  7 Jan 2021 04:29:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE25C4B3D0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 04:29:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SK8+LQxa8wYb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 04:29:42 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D90E4B3C8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 04:29:42 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DBLWb5xgWzMGSd;
 Thu,  7 Jan 2021 17:28:27 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 7 Jan 2021 17:29:29 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, Alex Williamson <alex.williamson@redhat.com>, 
 Kirti Wankhede <kwankhede@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [PATCH 1/5] vfio/iommu_type1: Fixes vfio_dma_populate_bitmap to avoid
 dirty lose
Date: Thu, 7 Jan 2021 17:28:57 +0800
Message-ID: <20210107092901.19712-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210107092901.19712-1-zhukeqian1@huawei.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Joerg Roedel <joro@8bytes.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, Alexios Zavras <alexios.zavras@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
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

Defer checking whether vfio_dma is of fully-dirty in update_user_bitmap
is easy to lose dirty log. For example, after promoting pinned_scope of
vfio_iommu, vfio_dma is not considered as fully-dirty, then we may lose
dirty log that occurs before vfio_iommu is promoted.

The key point is that pinned-dirty is not a real dirty tracking way, it
can't continuously track dirty pages, but just restrict dirty scope. It
is essentially the same as fully-dirty. Fully-dirty is of full-scope and
pinned-dirty is of pinned-scope.

So we must mark pinned-dirty or fully-dirty after we start dirty tracking
or clear dirty bitmap, to ensure that dirty log is marked right away.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index bceda5e8baaa..b0a26e8e0adf 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -224,7 +224,7 @@ static void vfio_dma_bitmap_free(struct vfio_dma *dma)
 	dma->bitmap = NULL;
 }
 
-static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
+static void vfio_dma_populate_bitmap_pinned(struct vfio_dma *dma, size_t pgsize)
 {
 	struct rb_node *p;
 	unsigned long pgshift = __ffs(pgsize);
@@ -236,6 +236,25 @@ static void vfio_dma_populate_bitmap(struct vfio_dma *dma, size_t pgsize)
 	}
 }
 
+static void vfio_dma_populate_bitmap_full(struct vfio_dma *dma, size_t pgsize)
+{
+	unsigned long pgshift = __ffs(pgsize);
+	unsigned long nbits = dma->size >> pgshift;
+
+	bitmap_set(dma->bitmap, 0, nbits);
+}
+
+static void vfio_dma_populate_bitmap(struct vfio_iommu *iommu,
+				     struct vfio_dma *dma)
+{
+	size_t pgsize = (size_t)1 << __ffs(iommu->pgsize_bitmap);
+
+	if (iommu->pinned_page_dirty_scope)
+		vfio_dma_populate_bitmap_pinned(dma, pgsize);
+	else if (dma->iommu_mapped)
+		vfio_dma_populate_bitmap_full(dma, pgsize);
+}
+
 static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
 {
 	struct rb_node *n;
@@ -257,7 +276,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
 			}
 			return ret;
 		}
-		vfio_dma_populate_bitmap(dma, pgsize);
+		vfio_dma_populate_bitmap(iommu, dma);
 	}
 	return 0;
 }
@@ -987,13 +1006,6 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	unsigned long shift = bit_offset % BITS_PER_LONG;
 	unsigned long leftover;
 
-	/*
-	 * mark all pages dirty if any IOMMU capable device is not able
-	 * to report dirty pages and all pages are pinned and mapped.
-	 */
-	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
-		bitmap_set(dma->bitmap, 0, nbits);
-
 	if (shift) {
 		bitmap_shift_left(dma->bitmap, dma->bitmap, shift,
 				  nbits + shift);
@@ -1019,7 +1031,6 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	struct vfio_dma *dma;
 	struct rb_node *n;
 	unsigned long pgshift = __ffs(iommu->pgsize_bitmap);
-	size_t pgsize = (size_t)1 << pgshift;
 	int ret;
 
 	/*
@@ -1055,7 +1066,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 		 * pages which are marked dirty by vfio_dma_rw()
 		 */
 		bitmap_clear(dma->bitmap, 0, dma->size >> pgshift);
-		vfio_dma_populate_bitmap(dma, pgsize);
+		vfio_dma_populate_bitmap(iommu, dma);
 	}
 	return 0;
 }
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
