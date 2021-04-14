Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C83FC43462
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F2B08613C7
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2B08613C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4E304B6BD;
	Wed, 14 Apr 2021 07:25:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V0tlTzEs5po1; Wed, 14 Apr 2021 07:25:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 762F24B688;
	Wed, 14 Apr 2021 07:25:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43CC04B6D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TohEkn0g52of for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:25:17 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A81CC4B688
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:16 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FL0TQ3NHCzkjcG;
 Wed, 14 Apr 2021 19:23:22 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:25:04 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 10/16] arm64/mm: Split the arm64_mm_context_get/put
Date: Wed, 14 Apr 2021 12:23:06 +0100
Message-ID: <20210414112312.13704-11-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
References: <20210414112312.13704-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.82.32]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, julien@xen.org, maz@kernel.org,
 linuxarm@huawei.com, catalin.marinas@arm.com, will@kernel.org
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

Keep only the mm specific part in arm64_mm_context_get/put
and move the rest to generic functions.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/mm/context.c | 53 +++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 40ef013c90c3..901472a57b5d 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -307,20 +307,21 @@ void check_and_switch_context(struct mm_struct *mm)
 		cpu_switch_mm(mm->pgd, mm);
 }
 
-unsigned long arm64_mm_context_get(struct mm_struct *mm)
+static unsigned long asid_context_pinned_get(struct asid_info *info,
+					     atomic64_t *pasid,
+					     refcount_t *pinned)
 {
 	unsigned long flags;
 	u64 asid;
-	struct asid_info *info = &asid_info;
 
 	if (!info->pinned_map)
 		return 0;
 
 	raw_spin_lock_irqsave(&info->lock, flags);
 
-	asid = atomic64_read(&mm->context.id);
+	asid = atomic64_read(pasid);
 
-	if (refcount_inc_not_zero(&mm->context.pinned))
+	if (refcount_inc_not_zero(pinned))
 		goto out_unlock;
 
 	if (info->nr_pinned_asids >= info->max_pinned_asids) {
@@ -333,45 +334,61 @@ unsigned long arm64_mm_context_get(struct mm_struct *mm)
 		 * We went through one or more rollover since that ASID was
 		 * used. Ensure that it is still valid, or generate a new one.
 		 */
-		asid = new_context(info, &mm->context.id, &mm->context.pinned);
-		atomic64_set(&mm->context.id, asid);
+		asid = new_context(info, pasid, pinned);
+		atomic64_set(pasid, asid);
 	}
 
 	info->nr_pinned_asids++;
 	__set_bit(asid2idx(info, asid), info->pinned_map);
-	refcount_set(&mm->context.pinned, 1);
+	refcount_set(pinned, 1);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&info->lock, flags);
-
 	asid &= ~ASID_MASK(info);
-
-	/* Set the equivalent of USER_ASID_BIT */
-	if (asid && arm64_kernel_unmapped_at_el0())
-		asid |= 1;
-
 	return asid;
 }
-EXPORT_SYMBOL_GPL(arm64_mm_context_get);
 
-void arm64_mm_context_put(struct mm_struct *mm)
+static void asid_context_pinned_put(struct asid_info *info, atomic64_t *pasid,
+				    refcount_t *pinned)
 {
 	unsigned long flags;
-	struct asid_info *info = &asid_info;
-	u64 asid = atomic64_read(&mm->context.id);
+	u64 asid = atomic64_read(pasid);
 
 	if (!info->pinned_map)
 		return;
 
 	raw_spin_lock_irqsave(&info->lock, flags);
 
-	if (refcount_dec_and_test(&mm->context.pinned)) {
+	if (refcount_dec_and_test(pinned)) {
 		__clear_bit(asid2idx(info, asid), info->pinned_map);
 		info->nr_pinned_asids--;
 	}
 
 	raw_spin_unlock_irqrestore(&info->lock, flags);
 }
+
+unsigned long arm64_mm_context_get(struct mm_struct *mm)
+{
+	u64 asid;
+	struct asid_info *info = &asid_info;
+
+	asid = asid_context_pinned_get(info, &mm->context.id,
+				       &mm->context.pinned);
+
+	/* Set the equivalent of USER_ASID_BIT */
+	if (asid && arm64_kernel_unmapped_at_el0())
+		asid |= 1;
+
+	return asid;
+}
+EXPORT_SYMBOL_GPL(arm64_mm_context_get);
+
+void arm64_mm_context_put(struct mm_struct *mm)
+{
+	struct asid_info *info = &asid_info;
+
+	asid_context_pinned_put(info, &mm->context.id, &mm->context.pinned);
+}
 EXPORT_SYMBOL_GPL(arm64_mm_context_put);
 
 /* Errata workaround post TTBRx_EL1 update. */
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
