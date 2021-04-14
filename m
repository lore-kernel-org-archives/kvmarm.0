Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0167BC433ED
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:24:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7550F613C8
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:24:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7550F613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C33A4B6F2;
	Wed, 14 Apr 2021 07:24:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p23rn0NyD+G8; Wed, 14 Apr 2021 07:24:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AFFCD4B66D;
	Wed, 14 Apr 2021 07:24:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 40C0E4B63E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6sPWkW6ee+-p for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:24:50 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F1E744B583
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:24:47 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FL0Rf13ymzNvXv;
 Wed, 14 Apr 2021 19:21:50 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:24:35 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 03/16] arm64/mm: Move bits to asid_info
Date: Wed, 14 Apr 2021 12:22:59 +0100
Message-ID: <20210414112312.13704-4-shameerali.kolothum.thodi@huawei.com>
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

From: Julien Grall <julien.grall@arm.com>

The variable bits hold information for a given ASID allocator. So move
it to the asid_info structure.

Because most of the macros were relying on bits, they are now taking an
extra parameter that is a pointer to the asid_info structure.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/mm/context.c | 70 +++++++++++++++++++++--------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 42e011094571..1fd40a42955c 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -17,7 +17,6 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 
-static u32 asid_bits;
 static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
 
 static struct asid_info
@@ -27,6 +26,7 @@ static struct asid_info
 	unsigned int	map_idx;
 	atomic64_t __percpu	*active;
 	u64 __percpu		*reserved;
+	u32			bits;
 } asid_info;
 
 #define active_asid(info, cpu)	 (*per_cpu_ptr((info)->active, cpu))
@@ -40,12 +40,12 @@ static unsigned long max_pinned_asids;
 static unsigned long nr_pinned_asids;
 static unsigned long *pinned_asid_map;
 
-#define ASID_MASK		(~GENMASK(asid_bits - 1, 0))
-#define ASID_FIRST_VERSION	(1UL << asid_bits)
+#define ASID_MASK(info)			(~GENMASK((info)->bits - 1, 0))
+#define ASID_FIRST_VERSION(info)	(1UL << (info)->bits)
 
-#define NUM_USER_ASIDS		ASID_FIRST_VERSION
-#define asid2idx(asid)		((asid) & ~ASID_MASK)
-#define idx2asid(idx)		asid2idx(idx)
+#define NUM_USER_ASIDS(info)		ASID_FIRST_VERSION(info)
+#define asid2idx(info, asid)		((asid) & ~ASID_MASK(info))
+#define idx2asid(info, idx)		asid2idx(info, idx)
 
 /* Get the ASIDBits supported by the current CPU */
 static u32 get_cpu_asid_bits(void)
@@ -74,20 +74,20 @@ void verify_cpu_asid_bits(void)
 {
 	u32 asid = get_cpu_asid_bits();
 
-	if (asid < asid_bits) {
+	if (asid < asid_info.bits) {
 		/*
 		 * We cannot decrease the ASID size at runtime, so panic if we support
 		 * fewer ASID bits than the boot CPU.
 		 */
 		pr_crit("CPU%d: smaller ASID size(%u) than boot CPU (%u)\n",
-				smp_processor_id(), asid, asid_bits);
+				smp_processor_id(), asid, asid_info.bits);
 		cpu_panic_kernel();
 	}
 }
 
-static void set_kpti_asid_bits(unsigned long *map)
+static void set_kpti_asid_bits(struct asid_info *info, unsigned long *map)
 {
-	unsigned int len = BITS_TO_LONGS(NUM_USER_ASIDS) * sizeof(unsigned long);
+	unsigned int len = BITS_TO_LONGS(NUM_USER_ASIDS(info)) * sizeof(unsigned long);
 	/*
 	 * In case of KPTI kernel/user ASIDs are allocated in
 	 * pairs, the bottom bit distinguishes the two: if it
@@ -100,15 +100,15 @@ static void set_kpti_asid_bits(unsigned long *map)
 static void set_reserved_asid_bits(struct asid_info *info)
 {
 	if (pinned_asid_map)
-		bitmap_copy(info->map, pinned_asid_map, NUM_USER_ASIDS);
+		bitmap_copy(info->map, pinned_asid_map, NUM_USER_ASIDS(info));
 	else if (arm64_kernel_unmapped_at_el0())
-		set_kpti_asid_bits(info->map);
+		set_kpti_asid_bits(info, info->map);
 	else
-		bitmap_clear(info->map, 0, NUM_USER_ASIDS);
+		bitmap_clear(info->map, 0, NUM_USER_ASIDS(info));
 }
 
 #define asid_gen_match(asid, info) \
-	(!(((asid) ^ atomic64_read(&(info)->generation)) >> asid_bits))
+	(!(((asid) ^ atomic64_read(&(info)->generation)) >> info->bits))
 
 static void flush_context(struct asid_info *info)
 {
@@ -129,7 +129,7 @@ static void flush_context(struct asid_info *info)
 		 */
 		if (asid == 0)
 			asid = reserved_asid(info, i);
-		__set_bit(asid2idx(asid), info->map);
+		__set_bit(asid2idx(info, asid), info->map);
 		reserved_asid(info, i) = asid;
 	}
 
@@ -171,7 +171,7 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 	u64 generation = atomic64_read(&info->generation);
 
 	if (asid != 0) {
-		u64 newasid = generation | (asid & ~ASID_MASK);
+		u64 newasid = generation | (asid & ~ASID_MASK(info));
 
 		/*
 		 * If our current ASID was active during a rollover, we
@@ -192,7 +192,7 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 		 * We had a valid ASID in a previous life, so try to re-use
 		 * it if possible.
 		 */
-		if (!__test_and_set_bit(asid2idx(asid), info->map))
+		if (!__test_and_set_bit(asid2idx(info, asid), info->map))
 			return newasid;
 	}
 
@@ -203,22 +203,22 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 	 * a reserved TTBR0 for the init_mm and we allocate ASIDs in even/odd
 	 * pairs.
 	 */
-	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS, info->map_idx);
-	if (asid != NUM_USER_ASIDS)
+	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS(info), info->map_idx);
+	if (asid != NUM_USER_ASIDS(info))
 		goto set_asid;
 
 	/* We're out of ASIDs, so increment the global generation count */
-	generation = atomic64_add_return_relaxed(ASID_FIRST_VERSION,
+	generation = atomic64_add_return_relaxed(ASID_FIRST_VERSION(info),
 						 &info->generation);
 	flush_context(info);
 
 	/* We have more ASIDs than CPUs, so this will always succeed */
-	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS, 1);
+	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS(info), 1);
 
 set_asid:
 	__set_bit(asid, info->map);
 	info->map_idx = asid;
-	return idx2asid(asid) | generation;
+	return idx2asid(info, asid) | generation;
 }
 
 void check_and_switch_context(struct mm_struct *mm)
@@ -311,13 +311,13 @@ unsigned long arm64_mm_context_get(struct mm_struct *mm)
 	}
 
 	nr_pinned_asids++;
-	__set_bit(asid2idx(asid), pinned_asid_map);
+	__set_bit(asid2idx(info, asid), pinned_asid_map);
 	refcount_set(&mm->context.pinned, 1);
 
 out_unlock:
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
-	asid &= ~ASID_MASK;
+	asid &= ~ASID_MASK(info);
 
 	/* Set the equivalent of USER_ASID_BIT */
 	if (asid && arm64_kernel_unmapped_at_el0())
@@ -330,6 +330,7 @@ EXPORT_SYMBOL_GPL(arm64_mm_context_get);
 void arm64_mm_context_put(struct mm_struct *mm)
 {
 	unsigned long flags;
+	struct asid_info *info = &asid_info;
 	u64 asid = atomic64_read(&mm->context.id);
 
 	if (!pinned_asid_map)
@@ -338,7 +339,7 @@ void arm64_mm_context_put(struct mm_struct *mm)
 	raw_spin_lock_irqsave(&cpu_asid_lock, flags);
 
 	if (refcount_dec_and_test(&mm->context.pinned)) {
-		__clear_bit(asid2idx(asid), pinned_asid_map);
+		__clear_bit(asid2idx(info, asid), pinned_asid_map);
 		nr_pinned_asids--;
 	}
 
@@ -384,12 +385,13 @@ void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm)
 
 static int asids_update_limit(void)
 {
-	unsigned long num_available_asids = NUM_USER_ASIDS;
+	struct asid_info *info = &asid_info;
+	unsigned long num_available_asids = NUM_USER_ASIDS(info);
 
 	if (arm64_kernel_unmapped_at_el0()) {
 		num_available_asids /= 2;
 		if (pinned_asid_map)
-			set_kpti_asid_bits(pinned_asid_map);
+			set_kpti_asid_bits(info, pinned_asid_map);
 	}
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
@@ -413,19 +415,19 @@ static int asids_init(void)
 {
 	struct asid_info *info = &asid_info;
 
-	asid_bits = get_cpu_asid_bits();
-	atomic64_set(&info->generation, ASID_FIRST_VERSION);
-	info->map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS), sizeof(*info->map),
-			    GFP_KERNEL);
+	info->bits = get_cpu_asid_bits();
+	atomic64_set(&info->generation, ASID_FIRST_VERSION(info));
+	info->map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS(info)),
+			    sizeof(*info->map), GFP_KERNEL);
 	if (!info->map)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
-		      NUM_USER_ASIDS);
+		      NUM_USER_ASIDS(info));
 
 	info->map_idx = 1;
 	info->active = &active_asids;
 	info->reserved = &reserved_asids;
 
-	pinned_asid_map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS),
+	pinned_asid_map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS(info)),
 				  sizeof(*pinned_asid_map), GFP_KERNEL);
 	nr_pinned_asids = 0;
 
@@ -435,7 +437,7 @@ static int asids_init(void)
 	 * and reserve kernel ASID's from beginning.
 	 */
 	if (IS_ENABLED(CONFIG_UNMAP_KERNEL_AT_EL0))
-		set_kpti_asid_bits(info->map);
+		set_kpti_asid_bits(info, info->map);
 	return 0;
 }
 early_initcall(asids_init);
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
