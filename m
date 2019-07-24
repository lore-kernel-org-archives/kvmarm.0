Return-Path: <SRS0=vYaB=VV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61318C76191
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 16:25:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2482D2190F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jul 2019 16:25:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2482D2190F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE6DC4A5C9;
	Wed, 24 Jul 2019 12:25:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pR6dB6x7mIoP; Wed, 24 Jul 2019 12:25:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62ECE4A5C6;
	Wed, 24 Jul 2019 12:25:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2E64A57A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 12:25:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GpJmBpstuzgd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jul 2019 12:25:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ED454A59F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jul 2019 12:25:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8977337;
 Wed, 24 Jul 2019 09:25:48 -0700 (PDT)
Received: from e108454-lin.cambridge.arm.com (e108454-lin.cambridge.arm.com
 [10.1.196.50])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 650D13F71F;
 Wed, 24 Jul 2019 09:25:47 -0700 (PDT)
From: Julien Grall <julien.grall@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 01/15] arm64/mm: Introduce asid_info structure and move
 asid_generation/asid_map to it
Date: Wed, 24 Jul 2019 17:25:20 +0100
Message-Id: <20190724162534.7390-2-julien.grall@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190724162534.7390-1-julien.grall@arm.com>
References: <20190724162534.7390-1-julien.grall@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com,
 Julien Grall <julien.grall@arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

In an attempt to make the ASID allocator generic, create a new structure
asid_info to store all the information necessary for the allocator.

For now, move the variables asid_generation and asid_map to the new structure
asid_info. Follow-up patches will move more variables.

Note to avoid more renaming aftwards, a local variable 'info' has been
created and is a pointer to the ASID allocator structure.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---
    Changes in v2:
        - Add turn asid_info to a static variable
---
 arch/arm64/mm/context.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index b5e329fde2dd..b0789f30d03b 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -19,8 +19,11 @@
 static u32 asid_bits;
 static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
 
-static atomic64_t asid_generation;
-static unsigned long *asid_map;
+static struct asid_info
+{
+	atomic64_t	generation;
+	unsigned long	*map;
+} asid_info;
 
 static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
@@ -77,13 +80,13 @@ void verify_cpu_asid_bits(void)
 	}
 }
 
-static void flush_context(void)
+static void flush_context(struct asid_info *info)
 {
 	int i;
 	u64 asid;
 
 	/* Update the list of reserved ASIDs and the ASID bitmap. */
-	bitmap_clear(asid_map, 0, NUM_USER_ASIDS);
+	bitmap_clear(info->map, 0, NUM_USER_ASIDS);
 
 	for_each_possible_cpu(i) {
 		asid = atomic64_xchg_relaxed(&per_cpu(active_asids, i), 0);
@@ -96,7 +99,7 @@ static void flush_context(void)
 		 */
 		if (asid == 0)
 			asid = per_cpu(reserved_asids, i);
-		__set_bit(asid2idx(asid), asid_map);
+		__set_bit(asid2idx(asid), info->map);
 		per_cpu(reserved_asids, i) = asid;
 	}
 
@@ -131,11 +134,11 @@ static bool check_update_reserved_asid(u64 asid, u64 newasid)
 	return hit;
 }
 
-static u64 new_context(struct mm_struct *mm)
+static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 {
 	static u32 cur_idx = 1;
 	u64 asid = atomic64_read(&mm->context.id);
-	u64 generation = atomic64_read(&asid_generation);
+	u64 generation = atomic64_read(&info->generation);
 
 	if (asid != 0) {
 		u64 newasid = generation | (asid & ~ASID_MASK);
@@ -151,7 +154,7 @@ static u64 new_context(struct mm_struct *mm)
 		 * We had a valid ASID in a previous life, so try to re-use
 		 * it if possible.
 		 */
-		if (!__test_and_set_bit(asid2idx(asid), asid_map))
+		if (!__test_and_set_bit(asid2idx(asid), info->map))
 			return newasid;
 	}
 
@@ -162,20 +165,20 @@ static u64 new_context(struct mm_struct *mm)
 	 * a reserved TTBR0 for the init_mm and we allocate ASIDs in even/odd
 	 * pairs.
 	 */
-	asid = find_next_zero_bit(asid_map, NUM_USER_ASIDS, cur_idx);
+	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS, cur_idx);
 	if (asid != NUM_USER_ASIDS)
 		goto set_asid;
 
 	/* We're out of ASIDs, so increment the global generation count */
 	generation = atomic64_add_return_relaxed(ASID_FIRST_VERSION,
-						 &asid_generation);
-	flush_context();
+						 &info->generation);
+	flush_context(info);
 
 	/* We have more ASIDs than CPUs, so this will always succeed */
-	asid = find_next_zero_bit(asid_map, NUM_USER_ASIDS, 1);
+	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS, 1);
 
 set_asid:
-	__set_bit(asid, asid_map);
+	__set_bit(asid, info->map);
 	cur_idx = asid;
 	return idx2asid(asid) | generation;
 }
@@ -184,6 +187,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 {
 	unsigned long flags;
 	u64 asid, old_active_asid;
+	struct asid_info *info = &asid_info;
 
 	if (system_supports_cnp())
 		cpu_set_reserved_ttbr0();
@@ -206,7 +210,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	 */
 	old_active_asid = atomic64_read(&per_cpu(active_asids, cpu));
 	if (old_active_asid &&
-	    !((asid ^ atomic64_read(&asid_generation)) >> asid_bits) &&
+	    !((asid ^ atomic64_read(&info->generation)) >> asid_bits) &&
 	    atomic64_cmpxchg_relaxed(&per_cpu(active_asids, cpu),
 				     old_active_asid, asid))
 		goto switch_mm_fastpath;
@@ -214,8 +218,8 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	raw_spin_lock_irqsave(&cpu_asid_lock, flags);
 	/* Check that our ASID belongs to the current generation. */
 	asid = atomic64_read(&mm->context.id);
-	if ((asid ^ atomic64_read(&asid_generation)) >> asid_bits) {
-		asid = new_context(mm);
+	if ((asid ^ atomic64_read(&info->generation)) >> asid_bits) {
+		asid = new_context(info, mm);
 		atomic64_set(&mm->context.id, asid);
 	}
 
@@ -248,16 +252,18 @@ asmlinkage void post_ttbr_update_workaround(void)
 
 static int asids_init(void)
 {
+	struct asid_info *info = &asid_info;
+
 	asid_bits = get_cpu_asid_bits();
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
 	 * one more ASID than CPUs. ASID #0 is reserved for init_mm.
 	 */
 	WARN_ON(NUM_USER_ASIDS - 1 <= num_possible_cpus());
-	atomic64_set(&asid_generation, ASID_FIRST_VERSION);
-	asid_map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS), sizeof(*asid_map),
-			   GFP_KERNEL);
-	if (!asid_map)
+	atomic64_set(&info->generation, ASID_FIRST_VERSION);
+	info->map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS), sizeof(*info->map),
+			    GFP_KERNEL);
+	if (!info->map)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
 		      NUM_USER_ASIDS);
 
-- 
2.11.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
