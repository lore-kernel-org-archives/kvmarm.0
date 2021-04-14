Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D547C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 33B23613C8
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 11:25:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33B23613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D7F444B64F;
	Wed, 14 Apr 2021 07:25:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HXZKKb4+BcjR; Wed, 14 Apr 2021 07:25:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D41E74B5AC;
	Wed, 14 Apr 2021 07:25:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2EF94B64F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VQbGyUub8OWP for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 07:25:26 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 524274B5AC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 07:25:26 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FL0T70FnWzB0Xw;
 Wed, 14 Apr 2021 19:23:07 +0800 (CST)
Received: from S00345302A-PC.china.huawei.com (10.47.82.32) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Wed, 14 Apr 2021 19:25:16 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 13/16] arm64: Move the ASID allocator code in a separate
 file
Date: Wed, 14 Apr 2021 12:23:09 +0100
Message-ID: <20210414112312.13704-14-shameerali.kolothum.thodi@huawei.com>
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

We will want to re-use the ASID allocator in a separate context (e.g
allocating VMID). So move the code in a new file.

The function asid_check_context has been moved in the header as a static
inline function because we want to avoid add a branch when checking if the
ASID is still valid.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/lib_asid.h |  85 ++++++++
 arch/arm64/lib/Makefile           |   2 +
 arch/arm64/lib/asid.c             | 258 +++++++++++++++++++++++++
 arch/arm64/mm/context.c           | 310 +-----------------------------
 4 files changed, 347 insertions(+), 308 deletions(-)
 create mode 100644 arch/arm64/include/asm/lib_asid.h
 create mode 100644 arch/arm64/lib/asid.c

diff --git a/arch/arm64/include/asm/lib_asid.h b/arch/arm64/include/asm/lib_asid.h
new file mode 100644
index 000000000000..acae8d243d17
--- /dev/null
+++ b/arch/arm64/include/asm/lib_asid.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_ASM_LIB_ASID_H
+#define __ASM_ASM_LIB_ASID_H
+
+#include <linux/atomic.h>
+#include <linux/compiler.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/spinlock.h>
+
+struct asid_info {
+	atomic64_t	generation;
+	unsigned long	*map;
+	unsigned int	map_idx;
+	atomic64_t __percpu	*active;
+	u64 __percpu		*reserved;
+	u32			bits;
+	raw_spinlock_t		lock;
+	/* Which CPU requires context flush on next call */
+	cpumask_t		flush_pending;
+	/* Pinned ASIDs info */
+	unsigned long		*pinned_map;
+	unsigned long		max_pinned_asids;
+	unsigned long		nr_pinned_asids;
+	/* Callback to locally flush the context. */
+	void			(*flush_cpu_ctxt_cb)(void);
+	/* Callback to set the list of reserved ASIDs */
+	void			(*set_reserved_bits)(struct asid_info *info);
+};
+
+#define NUM_CTXT_ASIDS(info)		(1UL << ((info)->bits))
+
+#define active_asid(info, cpu)	 (*per_cpu_ptr((info)->active, cpu))
+#define asid_gen_match(asid, info) \
+	(!(((asid) ^ atomic64_read(&(info)->generation)) >> info->bits))
+
+void asid_new_context(struct asid_info *info, atomic64_t *pasid,
+		      refcount_t *pinned, unsigned int cpu);
+
+/*
+ * Check the ASID is still valid for the context. If not generate a new ASID.
+ *
+ * @pasid: Pointer to the current ASID batch
+ * @pinned: refcount if asid is pinned
+ */
+static inline void asid_check_context(struct asid_info *info, atomic64_t *pasid,
+				      refcount_t *pinned)
+{
+	unsigned int cpu;
+	u64 asid, old_active_asid;
+
+	asid = atomic64_read(pasid);
+
+	/*
+	 * The memory ordering here is subtle.
+	 * If our active_asid is non-zero and the ASID matches the current
+	 * generation, then we update the active_asid entry with a relaxed
+	 * cmpxchg. Racing with a concurrent rollover means that either:
+	 *
+	 * - We get a zero back from the cmpxchg and end up waiting on the
+	 *   lock. Taking the lock synchronises with the rollover and so
+	 *   we are forced to see the updated generation.
+	 *
+	 * - We get a valid ASID back from the cmpxchg, which means the
+	 *   relaxed xchg in flush_context will treat us as reserved
+	 *   because atomic RmWs are totally ordered for a given location.
+	 */
+	old_active_asid = atomic64_read(this_cpu_ptr(info->active));
+	if (old_active_asid && asid_gen_match(asid, info) &&
+	    atomic64_cmpxchg_relaxed(this_cpu_ptr(info->active),
+				     old_active_asid, asid))
+		return;
+
+	cpu = smp_processor_id();
+	asid_new_context(info, pasid, pinned, cpu);
+}
+
+unsigned long asid_context_pinned_get(struct asid_info *info,
+				      atomic64_t *pasid,
+				      refcount_t *pinned);
+void asid_context_pinned_put(struct asid_info *info, atomic64_t *pasid,
+			     refcount_t *pinned);
+int asid_allocator_init(struct asid_info *info, u32 bits, bool pinned);
+
+#endif
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index d31e1169d9b8..d42c66ce0460 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -5,6 +5,8 @@ lib-y		:= clear_user.o delay.o copy_from_user.o		\
 		   memset.o memcmp.o strcmp.o strncmp.o strlen.o	\
 		   strnlen.o strchr.o strrchr.o tishift.o
 
+lib-y		+= asid.o
+
 ifeq ($(CONFIG_KERNEL_MODE_NEON), y)
 obj-$(CONFIG_XOR_BLOCKS)	+= xor-neon.o
 CFLAGS_REMOVE_xor-neon.o	+= -mgeneral-regs-only
diff --git a/arch/arm64/lib/asid.c b/arch/arm64/lib/asid.c
new file mode 100644
index 000000000000..286285616f65
--- /dev/null
+++ b/arch/arm64/lib/asid.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Generic ASID allocator.
+ *
+ * Based on arch/arm/mm/context.c
+ *
+ * Copyright (C) 2002-2003 Deep Blue Solutions Ltd, all rights reserved.
+ * Copyright (C) 2012 ARM Ltd.
+ */
+
+#include <linux/slab.h>
+
+#include <asm/lib_asid.h>
+
+#define reserved_asid(info, cpu) (*per_cpu_ptr((info)->reserved, cpu))
+
+#define ASID_MASK(info)			(~GENMASK((info)->bits - 1, 0))
+#define ASID_FIRST_VERSION(info)        NUM_CTXT_ASIDS(info)
+
+#define asid2idx(info, asid)		((asid) & ~ASID_MASK(info))
+#define idx2asid(info, idx)		asid2idx(info, idx)
+
+static void flush_context(struct asid_info *info)
+{
+	int i;
+	u64 asid;
+
+	/* Update the list of reserved ASIDs and the ASID bitmap. */
+	if (info->set_reserved_bits)
+		info->set_reserved_bits(info);
+
+	for_each_possible_cpu(i) {
+		asid = atomic64_xchg_relaxed(&active_asid(info, i), 0);
+		/*
+		 * If this CPU has already been through a
+		 * rollover, but hasn't run another task in
+		 * the meantime, we must preserve its reserved
+		 * ASID, as this is the only trace we have of
+		 * the process it is still running.
+		 */
+		if (asid == 0)
+			asid = reserved_asid(info, i);
+		__set_bit(asid2idx(info, asid), info->map);
+		reserved_asid(info, i) = asid;
+	}
+
+	/*
+	 * Queue a TLB invalidation for each CPU to perform on next
+	 * context-switch
+	 */
+	cpumask_setall(&info->flush_pending);
+}
+
+static bool check_update_reserved_asid(struct asid_info *info, u64 asid,
+				       u64 newasid)
+{
+	int cpu;
+	bool hit = false;
+
+	/*
+	 * Iterate over the set of reserved ASIDs looking for a match.
+	 * If we find one, then we can update our mm to use newasid
+	 * (i.e. the same ASID in the current generation) but we can't
+	 * exit the loop early, since we need to ensure that all copies
+	 * of the old ASID are updated to reflect the mm. Failure to do
+	 * so could result in us missing the reserved ASID in a future
+	 * generation.
+	 */
+	for_each_possible_cpu(cpu) {
+		if (reserved_asid(info, cpu) == asid) {
+			hit = true;
+			reserved_asid(info, cpu) = newasid;
+		}
+	}
+
+	return hit;
+}
+
+static u64 new_context(struct asid_info *info, atomic64_t *pasid,
+		       refcount_t *pinned)
+{
+	u64 asid = atomic64_read(pasid);
+	u64 generation = atomic64_read(&info->generation);
+
+	if (asid != 0) {
+		u64 newasid = generation | (asid & ~ASID_MASK(info));
+
+		/*
+		 * If our current ASID was active during a rollover, we
+		 * can continue to use it and this was just a false alarm.
+		 */
+		if (check_update_reserved_asid(info, asid, newasid))
+			return newasid;
+
+		/*
+		 * If it is pinned, we can keep using it. Note that reserved
+		 * takes priority, because even if it is also pinned, we need to
+		 * update the generation into the reserved_asids.
+		 */
+		if (pinned && refcount_read(pinned))
+			return newasid;
+
+		/*
+		 * We had a valid ASID in a previous life, so try to re-use
+		 * it if possible.
+		 */
+		if (!__test_and_set_bit(asid2idx(info, asid), info->map))
+			return newasid;
+	}
+
+	/*
+	 * Allocate a free ASID. If we can't find one, take a note of the
+	 * currently active ASIDs and mark the TLBs as requiring flushes.  We
+	 * always count from ASID #2 (index 1), as we use ASID #0 when setting
+	 * a reserved TTBR0 for the init_mm and we allocate ASIDs in even/odd
+	 * pairs.
+	 */
+	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), info->map_idx);
+	if (asid != NUM_CTXT_ASIDS(info))
+		goto set_asid;
+
+	/* We're out of ASIDs, so increment the global generation count */
+	generation = atomic64_add_return_relaxed(ASID_FIRST_VERSION(info),
+						 &info->generation);
+	flush_context(info);
+
+	/* We have more ASIDs than CPUs, so this will always succeed */
+	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), 1);
+
+set_asid:
+	__set_bit(asid, info->map);
+	info->map_idx = asid;
+	return idx2asid(info, asid) | generation;
+}
+
+/*
+ * Generate a new ASID for the context.
+ *
+ * @pasid: Pointer to the current ASID batch allocated. It will be updated
+ * with the new ASID batch.
+ * @pinned: refcount if asid is pinned
+ * @cpu: current CPU ID. Must have been acquired through get_cpu()
+ */
+void asid_new_context(struct asid_info *info, atomic64_t *pasid,
+		      refcount_t *pinned, unsigned int cpu)
+{
+	unsigned long flags;
+	u64 asid;
+
+	raw_spin_lock_irqsave(&info->lock, flags);
+	/* Check that our ASID belongs to the current generation. */
+	asid = atomic64_read(pasid);
+	if (!asid_gen_match(asid, info)) {
+		asid = new_context(info, pasid, pinned);
+		atomic64_set(pasid, asid);
+	}
+
+	if (cpumask_test_and_clear_cpu(cpu, &info->flush_pending) &&
+	    info->flush_cpu_ctxt_cb)
+		info->flush_cpu_ctxt_cb();
+
+	atomic64_set(&active_asid(info, cpu), asid);
+	raw_spin_unlock_irqrestore(&info->lock, flags);
+}
+
+unsigned long asid_context_pinned_get(struct asid_info *info,
+				      atomic64_t *pasid,
+				      refcount_t *pinned)
+{
+	unsigned long flags;
+	u64 asid;
+
+	if (!info->pinned_map)
+		return 0;
+
+	raw_spin_lock_irqsave(&info->lock, flags);
+
+	asid = atomic64_read(pasid);
+
+	if (refcount_inc_not_zero(pinned))
+		goto out_unlock;
+
+	if (info->nr_pinned_asids >= info->max_pinned_asids) {
+		asid = 0;
+		goto out_unlock;
+	}
+
+	if (!asid_gen_match(asid, info)) {
+		/*
+		 * We went through one or more rollover since that ASID was
+		 * used. Ensure that it is still valid, or generate a new one.
+		 */
+		asid = new_context(info, pasid, pinned);
+		atomic64_set(pasid, asid);
+	}
+
+	info->nr_pinned_asids++;
+	__set_bit(asid2idx(info, asid), info->pinned_map);
+	refcount_set(pinned, 1);
+
+out_unlock:
+	raw_spin_unlock_irqrestore(&info->lock, flags);
+	asid &= ~ASID_MASK(info);
+	return asid;
+}
+
+void asid_context_pinned_put(struct asid_info *info, atomic64_t *pasid,
+			     refcount_t *pinned)
+{
+	unsigned long flags;
+	u64 asid = atomic64_read(pasid);
+
+	if (!info->pinned_map)
+		return;
+
+	raw_spin_lock_irqsave(&info->lock, flags);
+
+	if (refcount_dec_and_test(pinned)) {
+		__clear_bit(asid2idx(info, asid), info->pinned_map);
+		info->nr_pinned_asids--;
+	}
+
+	raw_spin_unlock_irqrestore(&info->lock, flags);
+}
+
+/*
+ * Initialize the ASID allocator
+ *
+ * @info: Pointer to the asid allocator structure
+ * @bits: Number of ASIDs available
+ * @pinned: Support for Pinned ASIDs
+ */
+int asid_allocator_init(struct asid_info *info, u32 bits, bool pinned)
+{
+	info->bits = bits;
+
+	/*
+	 * Expect allocation after rollover to fail if we don't have at least
+	 * one more ASID than CPUs. ASID #0 is always reserved.
+	 */
+	WARN_ON(NUM_CTXT_ASIDS(info) - 1 <= num_possible_cpus());
+	atomic64_set(&info->generation, ASID_FIRST_VERSION(info));
+	info->map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
+			    sizeof(*info->map), GFP_KERNEL);
+	if (!info->map)
+		return -ENOMEM;
+
+	info->map_idx = 1;
+	raw_spin_lock_init(&info->lock);
+
+	if (pinned) {
+		info->pinned_map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
+					   sizeof(*info->pinned_map), GFP_KERNEL);
+		info->nr_pinned_asids = 0;
+	}
+
+	return 0;
+}
diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index e9049d14f54a..f44e08981841 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -13,43 +13,15 @@
 #include <linux/mm.h>
 
 #include <asm/cpufeature.h>
+#include <asm/lib_asid.h>
 #include <asm/mmu_context.h>
 #include <asm/smp.h>
 #include <asm/tlbflush.h>
 
-static struct asid_info
-{
-	atomic64_t	generation;
-	unsigned long	*map;
-	unsigned int	map_idx;
-	atomic64_t __percpu	*active;
-	u64 __percpu		*reserved;
-	u32			bits;
-	raw_spinlock_t		lock;
-	/* Which CPU requires context flush on next call */
-	cpumask_t		flush_pending;
-	/* Pinned ASIDs info */
-	unsigned long		*pinned_map;
-	unsigned long		max_pinned_asids;
-	unsigned long		nr_pinned_asids;
-	/* Callback to locally flush the context. */
-	void			(*flush_cpu_ctxt_cb)(void);
-	/* Callback to set the list of reserved ASIDs */
-	void			(*set_reserved_bits)(struct asid_info *info);
-} asid_info;
-
-#define active_asid(info, cpu)	 (*per_cpu_ptr((info)->active, cpu))
-#define reserved_asid(info, cpu) (*per_cpu_ptr((info)->reserved, cpu))
-
 static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
 
-#define ASID_MASK(info)			(~GENMASK((info)->bits - 1, 0))
-#define NUM_CTXT_ASIDS(info)		(1UL << ((info)->bits))
-#define ASID_FIRST_VERSION(info)        NUM_CTXT_ASIDS(info)
-
-#define asid2idx(info, asid)		((asid) & ~ASID_MASK(info))
-#define idx2asid(info, idx)		asid2idx(info, idx)
+static struct asid_info asid_info;
 
 /* Get the ASIDBits supported by the current CPU */
 static u32 get_cpu_asid_bits(void)
@@ -111,190 +83,6 @@ static void set_reserved_asid_bits(struct asid_info *info)
 		bitmap_clear(info->map, 0, NUM_CTXT_ASIDS(info));
 }
 
-#define asid_gen_match(asid, info) \
-	(!(((asid) ^ atomic64_read(&(info)->generation)) >> info->bits))
-
-static void flush_context(struct asid_info *info)
-{
-	int i;
-	u64 asid;
-
-	/* Update the list of reserved ASIDs and the ASID bitmap. */
-	if (info->set_reserved_bits)
-		info->set_reserved_bits(info);
-
-	for_each_possible_cpu(i) {
-		asid = atomic64_xchg_relaxed(&active_asid(info, i), 0);
-		/*
-		 * If this CPU has already been through a
-		 * rollover, but hasn't run another task in
-		 * the meantime, we must preserve its reserved
-		 * ASID, as this is the only trace we have of
-		 * the process it is still running.
-		 */
-		if (asid == 0)
-			asid = reserved_asid(info, i);
-		__set_bit(asid2idx(info, asid), info->map);
-		reserved_asid(info, i) = asid;
-	}
-
-	/*
-	 * Queue a TLB invalidation for each CPU to perform on next
-	 * context-switch
-	 */
-	cpumask_setall(&info->flush_pending);
-}
-
-static bool check_update_reserved_asid(struct asid_info *info, u64 asid,
-				       u64 newasid)
-{
-	int cpu;
-	bool hit = false;
-
-	/*
-	 * Iterate over the set of reserved ASIDs looking for a match.
-	 * If we find one, then we can update our mm to use newasid
-	 * (i.e. the same ASID in the current generation) but we can't
-	 * exit the loop early, since we need to ensure that all copies
-	 * of the old ASID are updated to reflect the mm. Failure to do
-	 * so could result in us missing the reserved ASID in a future
-	 * generation.
-	 */
-	for_each_possible_cpu(cpu) {
-		if (reserved_asid(info, cpu) == asid) {
-			hit = true;
-			reserved_asid(info, cpu) = newasid;
-		}
-	}
-
-	return hit;
-}
-
-static u64 new_context(struct asid_info *info, atomic64_t *pasid,
-		       refcount_t *pinned)
-{
-	u64 asid = atomic64_read(pasid);
-	u64 generation = atomic64_read(&info->generation);
-
-	if (asid != 0) {
-		u64 newasid = generation | (asid & ~ASID_MASK(info));
-
-		/*
-		 * If our current ASID was active during a rollover, we
-		 * can continue to use it and this was just a false alarm.
-		 */
-		if (check_update_reserved_asid(info, asid, newasid))
-			return newasid;
-
-		/*
-		 * If it is pinned, we can keep using it. Note that reserved
-		 * takes priority, because even if it is also pinned, we need to
-		 * update the generation into the reserved_asids.
-		 */
-		if (pinned && refcount_read(pinned))
-			return newasid;
-
-		/*
-		 * We had a valid ASID in a previous life, so try to re-use
-		 * it if possible.
-		 */
-		if (!__test_and_set_bit(asid2idx(info, asid), info->map))
-			return newasid;
-	}
-
-	/*
-	 * Allocate a free ASID. If we can't find one, take a note of the
-	 * currently active ASIDs and mark the TLBs as requiring flushes.  We
-	 * always count from ASID #2 (index 1), as we use ASID #0 when setting
-	 * a reserved TTBR0 for the init_mm and we allocate ASIDs in even/odd
-	 * pairs.
-	 */
-	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), info->map_idx);
-	if (asid != NUM_CTXT_ASIDS(info))
-		goto set_asid;
-
-	/* We're out of ASIDs, so increment the global generation count */
-	generation = atomic64_add_return_relaxed(ASID_FIRST_VERSION(info),
-						 &info->generation);
-	flush_context(info);
-
-	/* We have more ASIDs than CPUs, so this will always succeed */
-	asid = find_next_zero_bit(info->map, NUM_CTXT_ASIDS(info), 1);
-
-set_asid:
-	__set_bit(asid, info->map);
-	info->map_idx = asid;
-	return idx2asid(info, asid) | generation;
-}
-
-/*
- * Generate a new ASID for the context.
- *
- * @pasid: Pointer to the current ASID batch allocated. It will be updated
- * with the new ASID batch.
- * @pinned: refcount if asid is pinned.
- * Caller needs to make sure preempt is disabled before calling this function.
- */
-static void asid_new_context(struct asid_info *info, atomic64_t *pasid,
-			     refcount_t *pinned)
-{
-	unsigned long flags;
-	u64 asid;
-	unsigned int cpu = smp_processor_id();
-
-	raw_spin_lock_irqsave(&info->lock, flags);
-	/* Check that our ASID belongs to the current generation. */
-	asid = atomic64_read(pasid);
-	if (!asid_gen_match(asid, info)) {
-		asid = new_context(info, pasid, pinned);
-		atomic64_set(pasid, asid);
-	}
-
-	if (cpumask_test_and_clear_cpu(cpu, &info->flush_pending) &&
-	    info->flush_cpu_ctxt_cb)
-		info->flush_cpu_ctxt_cb();
-
-	atomic64_set(&active_asid(info, cpu), asid);
-	raw_spin_unlock_irqrestore(&info->lock, flags);
-}
-
-/*
- * Check the ASID is still valid for the context. If not generate a new ASID.
- *
- * @pasid: Pointer to the current ASID batch
- * @pinned: refcount if asid is pinned
- * Caller needs to make sure preempt is disabled before calling this function.
- */
-static void asid_check_context(struct asid_info *info, atomic64_t *pasid,
-			       refcount_t *pinned)
-{
-	u64 asid, old_active_asid;
-
-	asid = atomic64_read(pasid);
-
-	/*
-	 * The memory ordering here is subtle.
-	 * If our active_asid is non-zero and the ASID matches the current
-	 * generation, then we update the active_asid entry with a relaxed
-	 * cmpxchg. Racing with a concurrent rollover means that either:
-	 *
-	 * - We get a zero back from the cmpxchg and end up waiting on the
-	 *   lock. Taking the lock synchronises with the rollover and so
-	 *   we are forced to see the updated generation.
-	 *
-	 * - We get a valid ASID back from the cmpxchg, which means the
-	 *   relaxed xchg in flush_context will treat us as reserved
-	 *   because atomic RmWs are totally ordered for a given location.
-	 */
-	old_active_asid = atomic64_read(this_cpu_ptr(info->active));
-	if (old_active_asid && asid_gen_match(asid, info) &&
-	    atomic64_cmpxchg_relaxed(this_cpu_ptr(info->active),
-				     old_active_asid, asid))
-		return;
-
-	asid_new_context(info, pasid, pinned);
-}
-
 void check_and_switch_context(struct mm_struct *mm)
 {
 	if (system_supports_cnp())
@@ -313,66 +101,6 @@ void check_and_switch_context(struct mm_struct *mm)
 		cpu_switch_mm(mm->pgd, mm);
 }
 
-static unsigned long asid_context_pinned_get(struct asid_info *info,
-					     atomic64_t *pasid,
-					     refcount_t *pinned)
-{
-	unsigned long flags;
-	u64 asid;
-
-	if (!info->pinned_map)
-		return 0;
-
-	raw_spin_lock_irqsave(&info->lock, flags);
-
-	asid = atomic64_read(pasid);
-
-	if (refcount_inc_not_zero(pinned))
-		goto out_unlock;
-
-	if (info->nr_pinned_asids >= info->max_pinned_asids) {
-		asid = 0;
-		goto out_unlock;
-	}
-
-	if (!asid_gen_match(asid, info)) {
-		/*
-		 * We went through one or more rollover since that ASID was
-		 * used. Ensure that it is still valid, or generate a new one.
-		 */
-		asid = new_context(info, pasid, pinned);
-		atomic64_set(pasid, asid);
-	}
-
-	info->nr_pinned_asids++;
-	__set_bit(asid2idx(info, asid), info->pinned_map);
-	refcount_set(pinned, 1);
-
-out_unlock:
-	raw_spin_unlock_irqrestore(&info->lock, flags);
-	asid &= ~ASID_MASK(info);
-	return asid;
-}
-
-static void asid_context_pinned_put(struct asid_info *info, atomic64_t *pasid,
-				    refcount_t *pinned)
-{
-	unsigned long flags;
-	u64 asid = atomic64_read(pasid);
-
-	if (!info->pinned_map)
-		return;
-
-	raw_spin_lock_irqsave(&info->lock, flags);
-
-	if (refcount_dec_and_test(pinned)) {
-		__clear_bit(asid2idx(info, asid), info->pinned_map);
-		info->nr_pinned_asids--;
-	}
-
-	raw_spin_unlock_irqrestore(&info->lock, flags);
-}
-
 unsigned long arm64_mm_context_get(struct mm_struct *mm)
 {
 	u64 asid;
@@ -466,40 +194,6 @@ static int asids_update_limit(void)
 }
 arch_initcall(asids_update_limit);
 
-/*
- * Initialize the ASID allocator
- *
- * @info: Pointer to the asid allocator structure
- * @bits: Number of ASIDs available
- * @pinned: Support for Pinned ASIDs
- */
-static int asid_allocator_init(struct asid_info *info, u32 bits, bool pinned)
-{
-	info->bits = bits;
-
-	/*
-	 * Expect allocation after rollover to fail if we don't have at least
-	 * one more ASID than CPUs. ASID #0 is always reserved.
-	 */
-	WARN_ON(NUM_CTXT_ASIDS(info) - 1 <= num_possible_cpus());
-	atomic64_set(&info->generation, ASID_FIRST_VERSION(info));
-	info->map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
-			    sizeof(*info->map), GFP_KERNEL);
-	if (!info->map)
-		return -ENOMEM;
-
-	info->map_idx = 1;
-	raw_spin_lock_init(&info->lock);
-
-	if (pinned) {
-		info->pinned_map = kcalloc(BITS_TO_LONGS(NUM_CTXT_ASIDS(info)),
-					   sizeof(*info->pinned_map), GFP_KERNEL);
-		info->nr_pinned_asids = 0;
-	}
-
-	return 0;
-}
-
 static int asids_init(void)
 {
 	struct asid_info *info = &asid_info;
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
