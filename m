Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA1FC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 09:29:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DF72923339
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 09:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF72923339
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 522E34B3EA;
	Thu,  7 Jan 2021 04:29:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JwBquLzcy5re; Thu,  7 Jan 2021 04:29:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 25C7D4B3D9;
	Thu,  7 Jan 2021 04:29:44 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8067C4B3D8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 04:29:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0TJRum-kiteM for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 04:29:42 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 086584B3C7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 04:29:41 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DBLWv36XKz15nXd;
 Thu,  7 Jan 2021 17:28:43 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 7 Jan 2021 17:29:31 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, Alex Williamson <alex.williamson@redhat.com>, 
 Kirti Wankhede <kwankhede@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [PATCH 3/5] vfio/iommu_type1: Populate dirty bitmap when attach group
Date: Thu, 7 Jan 2021 17:28:59 +0800
Message-ID: <20210107092901.19712-4-zhukeqian1@huawei.com>
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

Attach an iommu backend group will potentially access all dma
ranges. We should traverse all dma ranges to mark dirty.

Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 29c8702c3b6e..26b7eb2a5cfc 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -255,6 +255,17 @@ static void vfio_dma_populate_bitmap(struct vfio_iommu *iommu,
 		vfio_dma_populate_bitmap_full(dma, pgsize);
 }
 
+static void vfio_iommu_populate_bitmap(struct vfio_iommu *iommu)
+{
+	struct rb_node *n;
+	struct vfio_dma *dma;
+
+	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
+		dma = rb_entry(n, struct vfio_dma, node);
+		vfio_dma_populate_bitmap(iommu, dma);
+	}
+}
+
 static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu)
 {
 	struct rb_node *n;
@@ -2190,7 +2201,12 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 * demotes the iommu scope until it declares itself dirty tracking
 	 * capable via the page pinning interface.
 	 */
-	iommu->pinned_page_dirty_scope = false;
+	if (iommu->pinned_page_dirty_scope) {
+		iommu->pinned_page_dirty_scope = false;
+		if (iommu->dirty_page_tracking)
+			vfio_iommu_populate_bitmap(iommu);
+	}
+
 	mutex_unlock(&iommu->lock);
 	vfio_iommu_resv_free(&group_resv_regions);
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
