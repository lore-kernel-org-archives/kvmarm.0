From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 12/14] arm64/lib: asid: Allow user to update the context under the lock
Date: Thu, 21 Mar 2019 16:36:21 +0000
Message-ID: <20190321163623.20219-13-julien.grall@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321163623.20219-1-julien.grall@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@arm.com, james.morse@arm.com, marc.zyngier@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Some users of the ASID allocator (e.g VMID) will require to update the
context when a new ASID is generated. This has to be protected by a lock
to prevent concurrent modification.

Rather than introducing yet another lock, it is possible to re-use the
allocator lock for that purpose. This patch introduces a new callback
that will be call when updating the context.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/include/asm/asid.h | 12 ++++++++----
 arch/arm64/lib/asid.c         | 10 ++++++++--
 arch/arm64/mm/context.c       | 11 ++++++++---
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/asid.h b/arch/arm64/include/asm/asid.h
index bb62b587f37f..d8d9dc875bec 100644
--- a/arch/arm64/include/asm/asid.h
+++ b/arch/arm64/include/asm/asid.h
@@ -23,6 +23,8 @@ struct asid_info
 	unsigned int		ctxt_shift;
 	/* Callback to locally flush the context. */
 	void			(*flush_cpu_ctxt_cb)(void);
+	/* Callback to call when a context is updated */
+	void			(*update_ctxt_cb)(void *ctxt);
 };
 
 #define NUM_ASIDS(info)			(1UL << ((info)->bits))
@@ -31,7 +33,7 @@ struct asid_info
 #define active_asid(info, cpu)	*per_cpu_ptr((info)->active, cpu)
 
 void asid_new_context(struct asid_info *info, atomic64_t *pasid,
-		      unsigned int cpu);
+		      unsigned int cpu, void *ctxt);
 
 /*
  * Check the ASID is still valid for the context. If not generate a new ASID.
@@ -40,7 +42,8 @@ void asid_new_context(struct asid_info *info, atomic64_t *pasid,
  * @cpu: current CPU ID. Must have been acquired throught get_cpu()
  */
 static inline void asid_check_context(struct asid_info *info,
-				      atomic64_t *pasid, unsigned int cpu)
+				       atomic64_t *pasid, unsigned int cpu,
+				       void *ctxt)
 {
 	u64 asid, old_active_asid;
 
@@ -67,11 +70,12 @@ static inline void asid_check_context(struct asid_info *info,
 				     old_active_asid, asid))
 		return;
 
-	asid_new_context(info, pasid, cpu);
+	asid_new_context(info, pasid, cpu, ctxt);
 }
 
 int asid_allocator_init(struct asid_info *info,
 			u32 bits, unsigned int asid_per_ctxt,
-			void (*flush_cpu_ctxt_cb)(void));
+			void (*flush_cpu_ctxt_cb)(void),
+			void (*update_ctxt_cb)(void *ctxt));
 
 #endif
diff --git a/arch/arm64/lib/asid.c b/arch/arm64/lib/asid.c
index 72b71bfb32be..b47e6769c1bc 100644
--- a/arch/arm64/lib/asid.c
+++ b/arch/arm64/lib/asid.c
@@ -130,9 +130,10 @@ static u64 new_context(struct asid_info *info, atomic64_t *pasid)
  * @pasid: Pointer to the current ASID batch allocated. It will be updated
  * with the new ASID batch.
  * @cpu: current CPU ID. Must have been acquired through get_cpu()
+ * @ctxt: Context to update when calling update_context
  */
 void asid_new_context(struct asid_info *info, atomic64_t *pasid,
-		      unsigned int cpu)
+		      unsigned int cpu, void *ctxt)
 {
 	unsigned long flags;
 	u64 asid;
@@ -149,6 +150,9 @@ void asid_new_context(struct asid_info *info, atomic64_t *pasid,
 		info->flush_cpu_ctxt_cb();
 
 	atomic64_set(&active_asid(info, cpu), asid);
+
+	info->update_ctxt_cb(ctxt);
+
 	raw_spin_unlock_irqrestore(&info->lock, flags);
 }
 
@@ -163,11 +167,13 @@ void asid_new_context(struct asid_info *info, atomic64_t *pasid,
  */
 int asid_allocator_init(struct asid_info *info,
 			u32 bits, unsigned int asid_per_ctxt,
-			void (*flush_cpu_ctxt_cb)(void))
+			void (*flush_cpu_ctxt_cb)(void),
+			void (*update_ctxt_cb)(void *ctxt))
 {
 	info->bits = bits;
 	info->ctxt_shift = ilog2(asid_per_ctxt);
 	info->flush_cpu_ctxt_cb = flush_cpu_ctxt_cb;
+	info->update_ctxt_cb = update_ctxt_cb;
 	/*
 	 * Expect allocation after rollover to fail if we don't have at least
 	 * one more ASID than CPUs. ASID #0 is always reserved.
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 95ee7711a2ef..737b4bd7bbe7 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -82,7 +82,7 @@ void check_and_switch_context(struct mm_struct *mm, unsigned int cpu)
 	if (system_supports_cnp())
 		cpu_set_reserved_ttbr0();
 
-	asid_check_context(&asid_info, &mm->context.id, cpu);
+	asid_check_context(&asid_info, &mm->context.id, cpu, mm);
 
 	arm64_apply_bp_hardening();
 
@@ -108,12 +108,17 @@ static void asid_flush_cpu_ctxt(void)
 	local_flush_tlb_all();
 }
 
+static void asid_update_ctxt(void *ctxt)
+{
+	/* Nothing to do */
+}
+
 static int asids_init(void)
 {
 	u32 bits = get_cpu_asid_bits();
 
-	if (!asid_allocator_init(&asid_info, bits, ASID_PER_CONTEXT,
-				 asid_flush_cpu_ctxt))
+	if (asid_allocator_init(&asid_info, bits, ASID_PER_CONTEXT,
+				asid_flush_cpu_ctxt, asid_update_ctxt))
 		panic("Unable to initialize ASID allocator for %lu ASIDs\n",
 		      NUM_ASIDS(&asid_info));
 
-- 
2.11.0
