From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 09/14] arm64/mm: Split the function
 check_and_switch_context in 3 parts
Date: Thu, 21 Mar 2019 16:36:18 +0000
Message-ID: <20190321163623.20219-10-julien.grall@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86C4C4A3B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:37:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X3gDrzUm847R for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Mar 2019 12:37:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 004FC4A332
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Mar 2019 12:37:00 -0400 (EDT)
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

The function check_and_switch_context is used to:
    1) Check whether the ASID is still valid
    2) Generate a new one if it is not valid
    3) Switch the context

While the latter is specific to the MM subsystem, the rest could be part
of the generic ASID allocator.

After this patch, the function is now split in 3 parts which corresponds
to the use of the functions:
    1) asid_check_context: Check if the ASID is still valid
    2) asid_new_context: Generate a new ASID for the context
    3) check_and_switch_context: Call 1) and 2) and switch the context

1) and 2) have not been merged in a single function because we want to
avoid to add a branch in when the ASID is still valid. This will matter
when the code will be moved in separate file later on as 1) will reside
in the header as a static inline function.

Signed-off-by: Julien Grall <julien.grall@arm.com>

---

    Will wants to avoid to add a branch when the ASID is still valid. So
    1) and 2) are in separates function. The former will move to a new
    header and make static inline.
---
 arch/arm64/mm/context.c | 51 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index b071a1b3469e..cbf1c24cb3ee 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -204,16 +204,21 @@ static u64 new_context(struct asid_info *info, atomic64_t *pasid)
 	return idx2asid(info, asid) | generation;
 }
 
-void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
+static void asid_new_context(struct asid_info *info, atomic64_t *pasid,
+			     unsigned int cpu);
+
+/*
+ * Check the ASID is still valid for the context. If not generate a new ASID.
+ *
+ * @pasid: Pointer to the current ASID batch
+ * @cpu: current CPU ID. Must have been acquired throught get_cpu()
+ */
+static void asid_check_context(struct asid_info *info,
+			       atomic64_t *pasid, unsigned int cpu)
 {
-	unsigned long flags;
 	u64 asid, old_active_asid;
-	struct asid_info *info = &asid_info;
 
-	if (system_supports_cnp())
-		cpu_set_reserved_ttbr0();
-
-	asid = atomic64_read(&mm->context.id);
+	asid = atomic64_read(pasid);
 
 	/*
 	 * The memory ordering here is subtle.
@@ -234,14 +239,30 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	    !((asid ^ atomic64_read(&info->generation)) >> info->bits) &&
 	    atomic64_cmpxchg_relaxed(&active_asid(info, cpu),
 				     old_active_asid, asid))
-		goto switch_mm_fastpath;
+		return;
+
+	asid_new_context(info, pasid, cpu);
+}
+
+/*
+ * Generate a new ASID for the context.
+ *
+ * @pasid: Pointer to the current ASID batch allocated. It will be updated
+ * with the new ASID batch.
+ * @cpu: current CPU ID. Must have been acquired through get_cpu()
+ */
+static void asid_new_context(struct asid_info *info, atomic64_t *pasid,
+			     unsigned int cpu)
+{
+	unsigned long flags;
+	u64 asid;
 
 	raw_spin_lock_irqsave(&info->lock, flags);
 	/* Check that our ASID belongs to the current generation. */
-	asid = atomic64_read(&mm->context.id);
+	asid = atomic64_read(pasid);
 	if ((asid ^ atomic64_read(&info->generation)) >> info->bits) {
-		asid = new_context(info, &mm->context.id);
-		atomic64_set(&mm->context.id, asid);
+		asid = new_context(info, pasid);
+		atomic64_set(pasid, asid);
 	}
 
 	if (cpumask_test_and_clear_cpu(cpu, &info->flush_pending))
@@ -249,8 +270,14 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 
 	atomic64_set(&active_asid(info, cpu), asid);
 	raw_spin_unlock_irqrestore(&info->lock, flags);
+}
+
+void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
+{
+	if (system_supports_cnp())
+		cpu_set_reserved_ttbr0();
 
-switch_mm_fastpath:
+	asid_check_context(&asid_info, &mm->context.id, cpu);
 
 	arm64_apply_bp_hardening();
 
-- 
2.11.0
