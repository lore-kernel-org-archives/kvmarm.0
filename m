Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DD4C43470
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 731B4613C3
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 731B4613C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22FFD4B56E;
	Wed, 14 Apr 2021 07:25:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FdS5cHd0NuE2; Wed, 14 Apr 2021 07:25:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC51F4B666;
	Wed, 14 Apr 2021 07:25:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A4404B270
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ynN6vAj9fjnY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:25:01 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0A3B4B56E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:00 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FL0Sf2hvKztVy2;
 Wed, 14 Apr 2021 19:22:42 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:24:52 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 07/16] arm64/mm: Move Pinned ASID related variables to
 asid_info
Date: Wed, 14 Apr 2021 12:23:03 +0100
Message-ID: <20210414112312.13704-8-shameerali.kolothum.thodi@huawei.com>
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

The Pinned ASID variables hold information for a given ASID
allocator. So move them to the structure asid_info.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/mm/context.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 0f11d7c7f6a3..8af54e06f5bc 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -28,6 +28,10 @@ static struct asid_info
 	raw_spinlock_t		lock;
 	/* Which CPU requires context flush on next call */
 	cpumask_t		flush_pending;
+	/* Pinned ASIDs info */
+	unsigned long		*pinned_map;
+	unsigned long		max_pinned_asids;
+	unsigned long		nr_pinned_asids;
 } asid_info;
 
 #define active_asid(info, cpu)	 (*per_cpu_ptr((info)->active, cpu))
@@ -36,10 +40,6 @@ static struct asid_info
 static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
 
-static unsigned long max_pinned_asids;
-static unsigned long nr_pinned_asids;
-static unsigned long *pinned_asid_map;
-
 #define ASID_MASK(info)			(~GENMASK((info)->bits - 1, 0))
 #define NUM_CTXT_ASIDS(info)		(1UL << ((info)->bits))
 #define ASID_FIRST_VERSION(info)        NUM_CTXT_ASIDS(info)
@@ -99,8 +99,8 @@ static void set_kpti_asid_bits(struct asid_info *info, unsigned long *map)
 
 static void set_reserved_asid_bits(struct asid_info *info)
 {
-	if (pinned_asid_map)
-		bitmap_copy(info->map, pinned_asid_map, NUM_CTXT_ASIDS(info));
+	if (info->pinned_map)
+		bitmap_copy(info->map, info->pinned_map, NUM_CTXT_ASIDS(info));
 	else if (arm64_kernel_unmapped_at_el0())
 		set_kpti_asid_bits(info, info->map);
 	else
@@ -287,7 +287,7 @@ unsigned long arm64_mm_context_get(struct mm_struct *mm)
 	u64 asid;
 	struct asid_info *info = &asid_info;
 
-	if (!pinned_asid_map)
+	if (!info->pinned_map)
 		return 0;
 
 	raw_spin_lock_irqsave(&info->lock, flags);
@@ -297,7 +297,7 @@ unsigned long arm64_mm_context_get(struct mm_struct *mm)
 	if (refcount_inc_not_zero(&mm->context.pinned))
 		goto out_unlock;
 
-	if (nr_pinned_asids >= max_pinned_asids) {
+	if (info->nr_pinned_asids >= info->max_pinned_asids) {
 		asid = 0;
 		goto out_unlock;
 	}
@@ -311,8 +311,8 @@ unsigned long arm64_mm_context_get(struct mm_struct *mm)
 		atomic64_set(&mm->context.id, asid);
 	}
 
-	nr_pinned_asids++;
-	__set_bit(asid2idx(info, asid), pinned_asid_map);
+	info->nr_pinned_asids++;
+	__set_bit(asid2idx(info, asid), info->pinned_map);
 	refcount_set(&mm->context.pinned, 1);
 
 out_unlock:
@@ -334,14 +334,14 @@ void arm64_mm_context_put(struct mm_struct *mm)
 	struct asid_info *info = &asid_info;
 	u64 asid = atomic64_read(&mm->context.id);
 
-	if (!pinned_asid_map)
+	if (!info->pinned_map)
 		return;
 
 	raw_spin_lock_irqsave(&info->lock, flags);
 
 	if (refcount_dec_and_test(&mm->context.pinned)) {
-		__clear_bit(asid2idx(info, asid), pinned_asid_map);
-		nr_pinned_asids--;
+		__clear_bit(asid2idx(info, asid), info->pinned_map);
+		info->nr_pinned_asids--;
 	}
 
 	raw_spin_unlock_irqrestore(&info->lock, flags);
@@ -391,8 +391,8 @@ static int asids_update_limit(void)
 
 	if (arm64_kernel_unmapped_at_el0()) {
 		num_available_asids /= 2;
-		if (pinned_asid_map)
-			set_kpti_asid_bits(info, pinned_asid_map);
+		if (info->pinned_map)
+			set_kpti_asid_bits(info, info->pinned_map);
 	}
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
@@ -407,7 +407,7 @@ static int asids_update_limit(void)
 	 * even if all CPUs have a reserved ASID and the maximum number of ASIDs
 	 * are pinned, there still is at least one empty slot in the ASID map.
 	 */
-	max_pinned_asids = num_available_asids - num_possible_cpus() - 2;
+	info->max_pinned_asids = num_available_asids - num_possible_cpus() - 2;
 	return 0;
 }
 arch_initcall(asids_update_limit);
@@ -429,9 +429,9 @@ static int asids_init(void)
 	info->reserved = &reserved_asids;
 	raw_spin_lock_init(&info->lock);
 
-	pinned_asid_map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
-				  sizeof(*pinned_asid_map), GFP_KERNEL);
-	nr_pinned_asids = 0;
+	info->pinned_map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
+				   sizeof(*info->pinned_map), GFP_KERNEL);
+	info->nr_pinned_asids = 0;
 
 	/*
 	 * We cannot call set_reserved_asid_bits() here because CPU
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
