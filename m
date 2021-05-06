Return-Path: <SRS0=4Pzf=KB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2D5C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 16:54:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E55ED61289
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 16:54:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E55ED61289
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 894DD4B70F;
	Thu,  6 May 2021 12:54:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W-SXQIy00czY; Thu,  6 May 2021 12:54:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 096224B4B5;
	Thu,  6 May 2021 12:54:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 291EC4B40C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 12:54:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dEN9LHcmV1Ba for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 May 2021 12:54:53 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE33A4B0B1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 12:54:52 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FbflC6j1qzlc5G;
 Fri,  7 May 2021 00:52:39 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.47.85.115) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 00:54:38 +0800
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/3] kvm/arm: Introduce a new vmid allocator for KVM
Date: Thu, 6 May 2021 17:52:31 +0100
Message-ID: <20210506165232.1969-3-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
References: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.85.115]
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@huawei.com,
 catalin.marinas@arm.com, will@kernel.org
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

This is based on arm64 asid allocator algorithm and
has duplicated most of the code here.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |   6 +
 arch/arm64/kvm/vmid.c             | 285 ++++++++++++++++++++++++++++++
 2 files changed, 291 insertions(+)
 create mode 100644 arch/arm64/kvm/vmid.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3d10e6527f7d..9d476f1f34af 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -670,6 +670,12 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 
+int kvm_arm_vmid_alloc_init(void);
+void kvm_arm_vmid_alloc_free(void);
+void kvm_arm_update_vmid(atomic64_t *id, refcount_t *pinned);
+unsigned long kvm_arm_pinned_vmid_get(atomic64_t *id, refcount_t *pinned);
+void kvm_arm_pinned_vmid_put(atomic64_t *id, refcount_t *pinned);
+
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
 	vcpu_arch->steal.base = GPA_INVALID;
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
new file mode 100644
index 000000000000..14854c786e00
--- /dev/null
+++ b/arch/arm64/kvm/vmid.c
@@ -0,0 +1,285 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * VMID allocator.
+ *
+ * Based on arch/arm64/mm/context.c
+ *
+ * Copyright (C) 2002-2003 Deep Blue Solutions Ltd, all rights reserved.
+ * Copyright (C) 2012 ARM Ltd.
+ */
+
+#include <linux/bitfield.h>
+#include <linux/bitops.h>
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_mmu.h>
+
+static u32 vmid_bits;
+static DEFINE_RAW_SPINLOCK(cpu_vmid_lock);
+
+static atomic64_t vmid_generation;
+static unsigned long *vmid_map;
+
+static DEFINE_PER_CPU(atomic64_t, active_vmids);
+static DEFINE_PER_CPU(u64, reserved_vmids);
+static cpumask_t tlb_flush_pending;
+
+static unsigned long max_pinned_vmids;
+static unsigned long nr_pinned_vmids;
+static unsigned long *pinned_vmid_map;
+
+#define VMID_MASK		(~GENMASK(vmid_bits - 1, 0))
+#define VMID_FIRST_VERSION	(1UL << vmid_bits)
+
+#define NUM_USER_VMIDS		VMID_FIRST_VERSION
+#define vmid2idx(vmid)		((vmid) & ~VMID_MASK)
+#define idx2vmid(idx)		vmid2idx(idx)
+
+#define vmid_gen_match(vmid) \
+	(!(((vmid) ^ atomic64_read(&vmid_generation)) >> vmid_bits))
+
+static void flush_context(void)
+{
+	int cpu;
+	u64 vmid;
+
+	if (pinned_vmid_map)
+		bitmap_copy(vmid_map, pinned_vmid_map, NUM_USER_VMIDS);
+	else
+		bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
+
+	for_each_possible_cpu(cpu) {
+		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
+		/*
+		 * If this CPU has already been through a
+		 * rollover, but hasn't run another task in
+		 * the meantime, we must preserve its reserved
+		 * VMID, as this is the only trace we have of
+		 * the process it is still running.
+		 */
+		if (vmid == 0)
+			vmid = per_cpu(reserved_vmids, cpu);
+		__set_bit(vmid2idx(vmid), vmid_map);
+		per_cpu(reserved_vmids, cpu) = vmid;
+	}
+
+	/*
+	 * Queue a TLB invalidation for each CPU to perform on next
+	 * context-switch
+	 */
+	cpumask_setall(&tlb_flush_pending);
+}
+
+static bool check_update_reserved_vmid(u64 vmid, u64 newvmid)
+{
+	int cpu;
+	bool hit = false;
+
+	/*
+	 * Iterate over the set of reserved VMIDs looking for a match.
+	 * If we find one, then we can update our mm to use newvmid
+	 * (i.e. the same VMID in the current generation) but we can't
+	 * exit the loop early, since we need to ensure that all copies
+	 * of the old VMID are updated to reflect the mm. Failure to do
+	 * so could result in us missing the reserved VMID in a future
+	 * generation.
+	 */
+	for_each_possible_cpu(cpu) {
+		if (per_cpu(reserved_vmids, cpu) == vmid) {
+			hit = true;
+			per_cpu(reserved_vmids, cpu) = newvmid;
+		}
+	}
+
+	return hit;
+}
+
+static u64 new_vmid(atomic64_t *id, refcount_t *pinned)
+{
+	static u32 cur_idx = 1;
+	u64 vmid = atomic64_read(id);
+	u64 generation = atomic64_read(&vmid_generation);
+
+	if (vmid != 0) {
+		u64 newvmid = generation | (vmid & ~VMID_MASK);
+
+		/*
+		 * If our current VMID was active during a rollover, we
+		 * can continue to use it and this was just a false alarm.
+		 */
+		if (check_update_reserved_vmid(vmid, newvmid))
+			return newvmid;
+
+		/*
+		 * If it is pinned, we can keep using it. Note that reserved
+		 * takes priority, because even if it is also pinned, we need to
+		 * update the generation into the reserved_vmids.
+		 */
+		if (pinned && refcount_read(pinned))
+			return newvmid;
+
+		/*
+		 * We had a valid VMID in a previous life, so try to re-use
+		 * it if possible.
+		 */
+		if (!__test_and_set_bit(vmid2idx(vmid), vmid_map))
+			return newvmid;
+	}
+
+	/*
+	 * Allocate a free VMID. If we can't find one, take a note of the
+	 * currently active VMIDs and mark the TLBs as requiring flushes.  We
+	 * always count from VMID #2 (index 1), as we use VMID #0 for host.
+	 */
+	vmid = find_next_zero_bit(vmid_map, NUM_USER_VMIDS, cur_idx);
+	if (vmid != NUM_USER_VMIDS)
+		goto set_vmid;
+
+	/* We're out of VMIDs, so increment the global generation count */
+	generation = atomic64_add_return_relaxed(VMID_FIRST_VERSION,
+						 &vmid_generation);
+	flush_context();
+
+	/* We have more VMIDs than CPUs, so this will always succeed */
+	vmid = find_next_zero_bit(vmid_map, NUM_USER_VMIDS, 1);
+
+set_vmid:
+	__set_bit(vmid, vmid_map);
+	cur_idx = vmid;
+	return idx2vmid(vmid) | generation;
+}
+
+void kvm_arm_update_vmid(atomic64_t *id, refcount_t *pinned)
+{
+	unsigned long flags;
+	unsigned int cpu;
+	u64 vmid, old_active_vmid;
+
+	vmid = atomic64_read(id);
+
+	/*
+	 * The memory ordering here is subtle.
+	 * If our active_vmids is non-zero and the VMID matches the current
+	 * generation, then we update the active_vmids entry with a relaxed
+	 * cmpxchg. Racing with a concurrent rollover means that either:
+	 *
+	 * - We get a zero back from the cmpxchg and end up waiting on the
+	 *   lock. Taking the lock synchronises with the rollover and so
+	 *   we are forced to see the updated generation.
+	 *
+	 * - We get a valid VMID back from the cmpxchg, which means the
+	 *   relaxed xchg in flush_context will treat us as reserved
+	 *   because atomic RmWs are totally ordered for a given location.
+	 */
+	old_active_vmid = atomic64_read(this_cpu_ptr(&active_vmids));
+	if (old_active_vmid && vmid_gen_match(vmid) &&
+	    atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
+				     old_active_vmid, vmid))
+		return;
+
+	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
+	/* Check that our VMID belongs to the current generation. */
+	vmid = atomic64_read(id);
+	if (!vmid_gen_match(vmid)) {
+		vmid = new_vmid(id, pinned);
+		atomic64_set(id, vmid);
+	}
+
+	cpu = smp_processor_id();
+	if (cpumask_test_and_clear_cpu(cpu, &tlb_flush_pending))
+		kvm_call_hyp(__kvm_tlb_flush_local_all);
+
+	atomic64_set(this_cpu_ptr(&active_vmids), vmid);
+	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
+}
+
+unsigned long kvm_arm_pinned_vmid_get(atomic64_t *id, refcount_t *pinned)
+{
+	unsigned long flags;
+	u64 vmid;
+
+	if (!pinned_vmid_map)
+		return 0;
+
+	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
+
+	vmid = atomic64_read(id);
+
+	if (refcount_inc_not_zero(pinned))
+		goto out_unlock;
+
+	if (nr_pinned_vmids >= max_pinned_vmids) {
+		vmid = 0;
+		goto out_unlock;
+	}
+
+	if (!vmid_gen_match(vmid)) {
+		/*
+		 * We went through one or more rollover since that VMID was
+		 * used. Ensure that it is still valid, or generate a new one.
+		 */
+		vmid = new_vmid(id, pinned);
+		atomic64_set(id, vmid);
+	}
+
+	nr_pinned_vmids++;
+	__set_bit(vmid2idx(vmid), pinned_vmid_map);
+	refcount_set(pinned, 1);
+
+out_unlock:
+	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
+
+	vmid &= ~VMID_MASK;
+
+	return vmid;
+}
+
+void kvm_arm_pinned_vmid_put(atomic64_t *id, refcount_t *pinned)
+{
+	unsigned long flags;
+	u64 vmid = atomic64_read(id);
+
+	if (!pinned_vmid_map)
+		return;
+
+	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
+
+	if (refcount_dec_and_test(pinned)) {
+		__clear_bit(vmid2idx(vmid), pinned_vmid_map);
+		nr_pinned_vmids--;
+	}
+
+	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
+}
+
+/*
+ * Initialize the VMID allocator
+ */
+int kvm_arm_vmid_alloc_init(void)
+{
+	vmid_bits = kvm_get_vmid_bits();
+
+	/*
+	 * Expect allocation after rollover to fail if we don't have at least
+	 * one more VMID than CPUs. VMID #0 is always reserved.
+	 */
+	WARN_ON(NUM_USER_VMIDS - 1 <= num_possible_cpus());
+	atomic64_set(&vmid_generation, VMID_FIRST_VERSION);
+	vmid_map = kcalloc(BITS_TO_LONGS(NUM_USER_VMIDS),
+			   sizeof(*vmid_map), GFP_KERNEL);
+	if (!vmid_map)
+		return -ENOMEM;
+
+	pinned_vmid_map = kcalloc(BITS_TO_LONGS(NUM_USER_VMIDS),
+				  sizeof(*pinned_vmid_map), GFP_KERNEL);
+	nr_pinned_vmids = 0;
+	max_pinned_vmids = NUM_USER_VMIDS - num_possible_cpus() - 2;
+
+	return 0;
+}
+
+void kvm_arm_vmid_alloc_free(void)
+{
+	kfree(vmid_map);
+	kfree(pinned_vmid_map);
+}
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
