Return-Path: <SRS0=f0/l=GS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B605C43332
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 09:27:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 31F5923435
	for <kvmarm@archiver.kernel.org>; Fri, 15 Jan 2021 09:27:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31F5923435
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABB324B0F6;
	Fri, 15 Jan 2021 04:27:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vnTLBTdAJwb9; Fri, 15 Jan 2021 04:27:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 614914B19E;
	Fri, 15 Jan 2021 04:27:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4DC4B0ED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 04:27:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lgb5lfch9+CP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2021 04:27:20 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24BFB4B0C2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2021 04:27:19 -0500 (EST)
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DHG503Vc1zl5Kp;
 Fri, 15 Jan 2021 17:25:56 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.498.0; Fri, 15 Jan 2021 17:27:07 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, Alex Williamson <alex.williamson@redhat.com>, 
 Kirti Wankhede <kwankhede@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>
Subject: [PATCH v2 2/2] vfio/iommu_type1: Sanity check pfn_list when remove
 vfio_dma
Date: Fri, 15 Jan 2021 17:26:43 +0800
Message-ID: <20210115092643.728-3-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210115092643.728-1-zhukeqian1@huawei.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
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

vfio_sanity_check_pfn_list() is used to check whether pfn_list of
vfio_dma is empty when remove the external domain, so it makes a
wrong assumption that only external domain will add pfn to dma pfn_list.

Now we apply this check when remove a specific vfio_dma and extract
the notifier check just for external domain.

Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4e82b9a3440f..a9bc15e84a4e 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -958,6 +958,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
+	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list);
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
@@ -2251,23 +2252,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
 	}
 }
 
-static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
-{
-	struct rb_node *n;
-
-	n = rb_first(&iommu->dma_list);
-	for (; n; n = rb_next(n)) {
-		struct vfio_dma *dma;
-
-		dma = rb_entry(n, struct vfio_dma, node);
-
-		if (WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list)))
-			break;
-	}
-	/* mdev vendor driver must unregister notifier */
-	WARN_ON(iommu->notifier.head);
-}
-
 /*
  * Called when a domain is removed in detach. It is possible that
  * the removed domain decided the iova aperture window. Modify the
@@ -2367,7 +2351,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			kfree(group);
 
 			if (list_empty(&iommu->external_domain->group_list)) {
-				vfio_sanity_check_pfn_list(iommu);
+				/* mdev vendor driver must unregister notifier */
+				WARN_ON(iommu->notifier.head);
 
 				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
 					vfio_iommu_unmap_unpin_all(iommu);
@@ -2491,7 +2476,8 @@ static void vfio_iommu_type1_release(void *iommu_data)
 
 	if (iommu->external_domain) {
 		vfio_release_domain(iommu->external_domain, true);
-		vfio_sanity_check_pfn_list(iommu);
+		/* mdev vendor driver must unregister notifier */
+		WARN_ON(iommu->notifier.head);
 		kfree(iommu->external_domain);
 	}
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
