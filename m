From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 02/14] arm64/mm: Move active_asids and reserved_asids to
 asid_info
Date: Thu, 21 Mar 2019 16:36:11 +0000
Message-ID: <20190321163623.20219-3-julien.grall@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C68904A2E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:36:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gKuRrWMST64Q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Mar 2019 12:36:45 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 804D94A414
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:36:45 -0400 (EDT)
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

The variables active_asids and reserved_asids hold information for a
given ASID allocator. So move them to the structure asid_info.

At the same time, introduce wrappers to access the active and reserved
ASIDs to make the code clearer.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/mm/context.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 34db54f1a39a..cfe4c5f7abf3 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -34,10 +34,16 @@ struct asid_info
 {
 	atomic64_t	generation;
 	unsigned long	*map;
+	atomic64_t __percpu	*active;
+	u64 __percpu		*reserved;
 } asid_info;
 
+#define active_asid(info, cpu)	*per_cpu_ptr((info)->active, cpu)
+#define reserved_asid(info, cpu) *per_cpu_ptr((info)->reserved, cpu)
+
 static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
+
 static cpumask_t tlb_flush_pending;
 
 #define ASID_MASK		(~GENMASK(asid_bits - 1, 0))
@@ -100,7 +106,7 @@ static void flush_context(struct asid_info *info)
 	bitmap_clear(info->map, 0, NUM_USER_ASIDS);
 
 	for_each_possible_cpu(i) {
-		asid = atomic64_xchg_relaxed(&per_cpu(active_asids, i), 0);
+		asid = atomic64_xchg_relaxed(&active_asid(info, i), 0);
 		/*
 		 * If this CPU has already been through a
 		 * rollover, but hasn't run another task in
@@ -109,9 +115,9 @@ static void flush_context(struct asid_info *info)
 		 * the process it is still running.
 		 */
 		if (asid == 0)
-			asid = per_cpu(reserved_asids, i);
+			asid = reserved_asid(info, i);
 		__set_bit(asid2idx(asid), info->map);
-		per_cpu(reserved_asids, i) = asid;
+		reserved_asid(info, i) = asid;
 	}
 
 	/*
@@ -121,7 +127,8 @@ static void flush_context(struct asid_info *info)
 	cpumask_setall(&tlb_flush_pending);
 }
 
-static bool check_update_reserved_asid(u64 asid, u64 newasid)
+static bool check_update_reserved_asid(struct asid_info *info, u64 asid,
+				       u64 newasid)
 {
 	int cpu;
 	bool hit = false;
@@ -136,9 +143,9 @@ static bool check_update_reserved_asid(u64 asid, u64 newasid)
 	 * generation.
 	 */
 	for_each_possible_cpu(cpu) {
-		if (per_cpu(reserved_asids, cpu) == asid) {
+		if (reserved_asid(info, cpu) == asid) {
 			hit = true;
-			per_cpu(reserved_asids, cpu) = newasid;
+			reserved_asid(info, cpu) = newasid;
 		}
 	}
 
@@ -158,7 +165,7 @@ static u64 new_context(struct asid_info *info, struct mm_struct *mm)
 		 * If our current ASID was active during a rollover, we
 		 * can continue to use it and this was just a false alarm.
 		 */
-		if (check_update_reserved_asid(asid, newasid))
+		if (check_update_reserved_asid(info, asid, newasid))
 			return newasid;
 
 		/*
@@ -207,8 +214,8 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 
 	/*
 	 * The memory ordering here is subtle.
-	 * If our active_asids is non-zero and the ASID matches the current
-	 * generation, then we update the active_asids entry with a relaxed
+	 * If our active_asid is non-zero and the ASID matches the current
+	 * generation, then we update the active_asid entry with a relaxed
 	 * cmpxchg. Racing with a concurrent rollover means that either:
 	 *
 	 * - We get a zero back from the cmpxchg and end up waiting on the
@@ -219,10 +226,10 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	 *   relaxed xchg in flush_context will treat us as reserved
 	 *   because atomic RmWs are totally ordered for a given location.
 	 */
-	old_active_asid = atomic64_read(&per_cpu(active_asids, cpu));
+	old_active_asid = atomic64_read(&active_asid(info, cpu));
 	if (old_active_asid &&
 	    !((asid ^ atomic64_read(&info->generation)) >> asid_bits) &&
-	    atomic64_cmpxchg_relaxed(&per_cpu(active_asids, cpu),
+	    atomic64_cmpxchg_relaxed(&active_asid(info, cpu),
 				     old_active_asid, asid))
 		goto switch_mm_fastpath;
 
@@ -237,7 +244,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	if (cpumask_test_and_clear_cpu(cpu, &tlb_flush_pending))
 		local_flush_tlb_all();
 
-	atomic64_set(&per_cpu(active_asids, cpu), asid);
+	atomic64_set(&active_asid(info, cpu), asid);
 	raw_spin_unlock_irqrestore(&cpu_asid_lock, flags);
 
 switch_mm_fastpath:
@@ -278,6 +285,9 @@ static int asids_init(void)
 		panic("Failed to allocate bitmap for %lu ASIDs\n",
 		      NUM_USER_ASIDS);
 
+	info->active = &active_asids;
+	info->reserved = &reserved_asids;
+
 	pr_info("ASID allocator initialised with %lu entries\n", NUM_USER_ASIDS);
 	return 0;
 }
-- 
2.11.0
