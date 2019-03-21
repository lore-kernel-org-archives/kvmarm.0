From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 03/14] arm64/mm: Move bits to asid_info
Date: Thu, 21 Mar 2019 16:36:12 +0000
Message-ID: <20190321163623.20219-4-julien.grall@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F7CD4A36C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:36:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k-Y7G8SwgxLr for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Mar 2019 12:36:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B01BE4A424
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:36:47 -0400 (EDT)
In-Reply-To: <20190321163623.20219-1-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The variable bits hold information for a given ASID allocator. So move
it to the asid_info structure.

Because most of the macros were relying on bits, they are now taking an
extra parameter that is a pointer to the asid_info structure.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/mm/context.c | 59 +++++++++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index cfe4c5f7abf3..da17ed6c7117 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -27,7 +27,6 @@
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 
-static u32 asid_bits;
 static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
 
 struct asid_info
@@ -36,6 +35,7 @@ struct asid_info
 	unsigned long	*map;
 	atomic64_t __percpu	*active;
 	u64 __percpu		*reserved;
+	u32			bits;
 } asid_info;
 
 #define active_asid(info, cpu)	*per_cpu_ptr((info)->active, cpu)
@@ -46,17 +46,17 @@ static DEFINE_PER_CPU(u64, reserved_asids);
 
 static cpumask_t tlb_flush_pending;
 
-#define ASID_MASK		(~GENMASK(asid_bits - 1, 0))
-#define ASID_FIRST_VERSION	(1UL << asid_bits)
+#define ASID_MASK(info)			(~GENMASK((info)->bits - 1, 0))
+#define ASID_FIRST_VERSION(info)	(1UL << ((info)->bits))
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-#define NUM_USER_ASIDS		(ASID_FIRST_VERSION >> 1)
-#define asid2idx(asid)		(((asid) & ~ASID_MASK) >> 1)
-#define idx2asid(idx)		(((idx) << 1) & ~ASID_MASK)
+#define NUM_USER_ASIDS(info)		(ASID_FIRST_VERSION(info) >> 1)
+#define asid2idx(info, asid)		(((asid) & ~ASID_MASK(info)) >> 1)
+#define idx2asid(info, idx)		(((idx) << 1) & ~ASID_MASK(info))
 #else
-#define NUM_USER_ASIDS		(ASID_FIRST_VERSION)
-#define asid2idx(asid)		((asid) & ~ASID_MASK)
-#define idx2asid(idx)		asid2idx(idx)
+#define NUM_USER_ASIDS(info)		(ASID_FIRST_VERSION(info))
+#define asid2idx(info, asid)		((asid) & ~ASID_MASK(info))
+#define idx2asid(info, idx)		asid2idx(info, idx)
 #endif
 
 /* Get the ASIDBits supported by the current CPU */
@@ -86,13 +86,13 @@ void verify_cpu_asid_bits(void)
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
@@ -103,7 +103,7 @@ static void flush_context(struct asid_info *info)
 	u64 asid;
 
 	/* Update the list of reserved ASIDs and the ASID bitmap. */
-	bitmap_clear(info->map, 0, NUM_USER_ASIDS);
+	bitmap_clear(info->map, 0, NUM_USER_ASIDS(info));
 
 	for_each_possible_cpu(i) {
 		asid = atomic64_xchg_relaxed(&active_asid(info, i), 0);
@@ -116,7 +116,7 @@ static void flush_context(struct asid_info *info)
 		 */
 		if (asid == 0)
 			asid = reserved_asid(info, i);
-		__set_bit(asid2idx(asid), info->map);
+		__set_bit(asid2idx(info, asid), info->map);
 		reserved_asid(info, i) = asid;
 	}
 
@@ -159,7 +159,7 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 	u64 generation = atomic64_read(&info->generation);
 
 	if (asid != 0) {
-		u64 newasid = generation | (asid & ~ASID_MASK);
+		u64 newasid = generation | (asid & ~ASID_MASK(info));
 
 		/*
 		 * If our current ASID was active during a rollover, we
@@ -172,7 +172,7 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 		 * We had a valid ASID in a previous life, so try to re-use
 		 * it if possible.
 		 */
-		if (!__test_and_set_bit(asid2idx(asid), info->map))
+		if (!__test_and_set_bit(asid2idx(info, asid), info->map))
 			return newasid;
 	}
 
@@ -183,22 +183,22 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 	 * a reserved TTBR0 for the init_mm and we allocate ASIDs in even/odd
 	 * pairs.
 	 */
-	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS, cur_idx);
-	if (asid != NUM_USER_ASIDS)
+	asid = find_next_zero_bit(info->map, NUM_USER_ASIDS(info), cur_idx);
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
 	cur_idx = asid;
-	return idx2asid(asid) | generation;
+	return idx2asid(info, asid) | generation;
 }
 
 void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
@@ -228,7 +228,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	 */
 	old_active_asid = atomic64_read(&active_asid(info, cpu));
 	if (old_active_asid &&
-	    !((asid ^ atomic64_read(&info->generation)) >> asid_bits) &&
+	    !((asid ^ atomic64_read(&info->generation)) >> info->bits) &&
 	    atomic64_cmpxchg_relaxed(&active_asid(info, cpu),
 				     old_active_asid, asid))
 		goto switch_mm_fastpath;
@@ -236,7 +236,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	raw_spin_lock_irqsave(&cpu_asid_lock, flags);
 	/* Check that our ASID belongs to the current generation. */
 	asid = atomic64_read(&mm->context.id);
-	if ((asid ^ atomic64_read(&info->generation)) >> asid_bits) {
+	if ((asid ^ atomic64_read(&info->generation)) >> info->bits) {
 		asid = new_context(info, mm);
 		atomic64_set(&mm->context.id, asid);
 	}
@@ -272,23 +272,24 @@ static int asids_init(void)
 {
 	struct asid_info *info = &asid_info;
 
-	asid_bits = get_cpu_asid_bits();
+	info->bits = get_cpu_asid_bits();
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
 	 * one more ASID than CPUs. ASID #0 is reserved for init_mm.
 	 */
-	WARN_ON(NUM_USER_ASIDS - 1 <= num_possible_cpus());
-	atomic64_set(&info->generation, ASID_FIRST_VERSION);
-	info->map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS), sizeof(*info->map),
-			    GFP_KERNEL);
+	WARN_ON(NUM_USER_ASIDS(info) - 1 <= num_possible_cpus());
+	atomic64_set(&info->generation, ASID_FIRST_VERSION(info));
+	info->map = kcalloc(BITS_TO_LONGS(NUM_USER_ASIDS(info)),
+			    sizeof(*info->map), GFP_KERNEL);
 	if (!info->map)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
-		      NUM_USER_ASIDS);
+		      NUM_USER_ASIDS(info));
 
 	info->active = &active_asids;
 	info->reserved = &reserved_asids;
 
-	pr_info("ASID allocator initialised with %lu entries\n", NUM_USER_ASIDS);
+	pr_info("ASID allocator initialised with %lu entries\n",
+		NUM_USER_ASIDS(info));
 	return 0;
 }
 early_initcall(asids_init);
-- 
2.11.0
