Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 710F1C433E6
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 04:44:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E7DF823125
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 04:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7DF823125
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2B64B347;
	Wed,  6 Jan 2021 23:44:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sLTKbz4RzHfD; Wed,  6 Jan 2021 23:44:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C644B370;
	Wed,  6 Jan 2021 23:44:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A31004B362
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 23:44:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jPsgYnRt2I4q for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jan 2021 23:44:38 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AE8E4B33F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jan 2021 23:44:37 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DBDC85hsHzj2pY;
 Thu,  7 Jan 2021 12:43:48 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Thu, 7 Jan 2021 12:44:26 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, Alex Williamson <alex.williamson@redhat.com>, 
 Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 1/6] vfio/iommu_type1: Make an explicit "promote" semantic
Date: Thu, 7 Jan 2021 12:43:56 +0800
Message-ID: <20210107044401.19828-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210107044401.19828-1-zhukeqian1@huawei.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
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

When we want to promote the pinned_page_dirty_scope of vfio_iommu,
we call the "update" function to visit all vfio_group, but when we
want to downgrade this, we can set the flag as false directly.

So we'd better make an explicit "promote" semantic to the "update"
function. BTW, if vfio_iommu already has been promoted, then return
early.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4dedaa9128..334a8240e1da 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -148,7 +148,7 @@ static int put_pfn(unsigned long pfn, int prot);
 static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 					       struct iommu_group *iommu_group);
 
-static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
+static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu);
 /*
  * This code handles mapping and unmapping of user data buffers
  * into DMA'ble space using the IOMMU
@@ -714,7 +714,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
 	if (!group->pinned_page_dirty_scope) {
 		group->pinned_page_dirty_scope = true;
-		update_pinned_page_dirty_scope(iommu);
+		promote_pinned_page_dirty_scope(iommu);
 	}
 
 	goto pin_done;
@@ -1622,27 +1622,26 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 	return group;
 }
 
-static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
+static void promote_pinned_page_dirty_scope(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
 	struct vfio_group *group;
 
+	if (iommu->pinned_page_dirty_scope)
+		return;
+
 	list_for_each_entry(domain, &iommu->domain_list, next) {
 		list_for_each_entry(group, &domain->group_list, next) {
-			if (!group->pinned_page_dirty_scope) {
-				iommu->pinned_page_dirty_scope = false;
+			if (!group->pinned_page_dirty_scope)
 				return;
-			}
 		}
 	}
 
 	if (iommu->external_domain) {
 		domain = iommu->external_domain;
 		list_for_each_entry(group, &domain->group_list, next) {
-			if (!group->pinned_page_dirty_scope) {
-				iommu->pinned_page_dirty_scope = false;
+			if (!group->pinned_page_dirty_scope)
 				return;
-			}
 		}
 	}
 
@@ -2057,8 +2056,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			 * addition of a dirty tracking group.
 			 */
 			group->pinned_page_dirty_scope = true;
-			if (!iommu->pinned_page_dirty_scope)
-				update_pinned_page_dirty_scope(iommu);
+			promote_pinned_page_dirty_scope(iommu);
 			mutex_unlock(&iommu->lock);
 
 			return 0;
@@ -2341,7 +2339,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
 	struct vfio_group *group;
-	bool update_dirty_scope = false;
+	bool promote_dirty_scope = false;
 	LIST_HEAD(iova_copy);
 
 	mutex_lock(&iommu->lock);
@@ -2349,7 +2347,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	if (iommu->external_domain) {
 		group = find_iommu_group(iommu->external_domain, iommu_group);
 		if (group) {
-			update_dirty_scope = !group->pinned_page_dirty_scope;
+			promote_dirty_scope = !group->pinned_page_dirty_scope;
 			list_del(&group->next);
 			kfree(group);
 
@@ -2379,7 +2377,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			continue;
 
 		vfio_iommu_detach_group(domain, group);
-		update_dirty_scope = !group->pinned_page_dirty_scope;
+		promote_dirty_scope = !group->pinned_page_dirty_scope;
 		list_del(&group->next);
 		kfree(group);
 		/*
@@ -2415,8 +2413,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	 * Removal of a group without dirty tracking may allow the iommu scope
 	 * to be promoted.
 	 */
-	if (update_dirty_scope)
-		update_pinned_page_dirty_scope(iommu);
+	if (promote_dirty_scope)
+		promote_pinned_page_dirty_scope(iommu);
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
