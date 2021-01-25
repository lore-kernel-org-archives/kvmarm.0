Return-Path: <SRS0=+Nyp=G4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33081C433E6
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 02:47:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B884422AAA
	for <kvmarm@archiver.kernel.org>; Mon, 25 Jan 2021 02:47:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B884422AAA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF74D4B476;
	Sun, 24 Jan 2021 21:47:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WpEEq8rj2Toz; Sun, 24 Jan 2021 21:47:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5DAE4B483;
	Sun, 24 Jan 2021 21:47:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7AC84B45C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 Jan 2021 21:46:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3nJ0nPQDSHTk for <kvmarm@lists.cs.columbia.edu>;
 Sun, 24 Jan 2021 21:46:58 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D6534B458
 for <kvmarm@lists.cs.columbia.edu>; Sun, 24 Jan 2021 21:46:57 -0500 (EST)
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DPDkp1PRwzjBfN;
 Mon, 25 Jan 2021 10:45:54 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 10:46:45 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <iommu@lists.linux-foundation.org>, Alex Williamson
 <alex.williamson@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>,
 "Cornelia Huck" <cohuck@redhat.com>
Subject: [PATCH] vfio/iommu_type1: Mantainance a counter for non_pinned_groups
Date: Mon, 25 Jan 2021 10:46:42 +0800
Message-ID: <20210125024642.14604-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Daniel Lezcano <daniel.lezcano@linaro.org>,
 Alexios Zavras <alexios.zavras@intel.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>
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

With this counter, we never need to traverse all groups to update
pinned_scope of vfio_iommu.

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/vfio/vfio_iommu_type1.c | 40 +++++----------------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 0b4dedaa9128..bb4bbcc79101 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -73,7 +73,7 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
-	bool			pinned_page_dirty_scope;
+	uint64_t		num_non_pinned_groups;
 };
 
 struct vfio_domain {
@@ -148,7 +148,6 @@ static int put_pfn(unsigned long pfn, int prot);
 static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 					       struct iommu_group *iommu_group);
 
-static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu);
 /*
  * This code handles mapping and unmapping of user data buffers
  * into DMA'ble space using the IOMMU
@@ -714,7 +713,7 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
 	group = vfio_iommu_find_iommu_group(iommu, iommu_group);
 	if (!group->pinned_page_dirty_scope) {
 		group->pinned_page_dirty_scope = true;
-		update_pinned_page_dirty_scope(iommu);
+		iommu->num_non_pinned_groups--;
 	}
 
 	goto pin_done;
@@ -991,7 +990,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
 	 * mark all pages dirty if any IOMMU capable device is not able
 	 * to report dirty pages and all pages are pinned and mapped.
 	 */
-	if (!iommu->pinned_page_dirty_scope && dma->iommu_mapped)
+	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
 		bitmap_set(dma->bitmap, 0, nbits);
 
 	if (shift) {
@@ -1622,33 +1621,6 @@ static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
 	return group;
 }
 
-static void update_pinned_page_dirty_scope(struct vfio_iommu *iommu)
-{
-	struct vfio_domain *domain;
-	struct vfio_group *group;
-
-	list_for_each_entry(domain, &iommu->domain_list, next) {
-		list_for_each_entry(group, &domain->group_list, next) {
-			if (!group->pinned_page_dirty_scope) {
-				iommu->pinned_page_dirty_scope = false;
-				return;
-			}
-		}
-	}
-
-	if (iommu->external_domain) {
-		domain = iommu->external_domain;
-		list_for_each_entry(group, &domain->group_list, next) {
-			if (!group->pinned_page_dirty_scope) {
-				iommu->pinned_page_dirty_scope = false;
-				return;
-			}
-		}
-	}
-
-	iommu->pinned_page_dirty_scope = true;
-}
-
 static bool vfio_iommu_has_sw_msi(struct list_head *group_resv_regions,
 				  phys_addr_t *base)
 {
@@ -2057,8 +2029,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 			 * addition of a dirty tracking group.
 			 */
 			group->pinned_page_dirty_scope = true;
-			if (!iommu->pinned_page_dirty_scope)
-				update_pinned_page_dirty_scope(iommu);
 			mutex_unlock(&iommu->lock);
 
 			return 0;
@@ -2188,7 +2158,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 * demotes the iommu scope until it declares itself dirty tracking
 	 * capable via the page pinning interface.
 	 */
-	iommu->pinned_page_dirty_scope = false;
+	iommu->num_non_pinned_groups++;
 	mutex_unlock(&iommu->lock);
 	vfio_iommu_resv_free(&group_resv_regions);
 
@@ -2416,7 +2386,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	 * to be promoted.
 	 */
 	if (update_dirty_scope)
-		update_pinned_page_dirty_scope(iommu);
+		iommu->num_non_pinned_groups--;
 	mutex_unlock(&iommu->lock);
 }
 
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
