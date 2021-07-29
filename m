Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EA7C4320A
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 10:43:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4621F60F43
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 10:43:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4621F60F43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA5754AEDC;
	Thu, 29 Jul 2021 06:43:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jnv3RQBef9eH; Thu, 29 Jul 2021 06:43:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2984B098;
	Thu, 29 Jul 2021 06:43:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2CCC4B092
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:43:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4MPdN-J2KddI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 06:43:45 -0400 (EDT)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB01F4B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:43:45 -0400 (EDT)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.200])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gb6FJ0kqvz6GDTD;
 Thu, 29 Jul 2021 18:28:36 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 12:43:44 +0200
Received: from A2006125610.china.huawei.com (10.47.90.183) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 11:43:37 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/4] KVM: arm64: Introduce a new VMID allocator for KVM
Date: Thu, 29 Jul 2021 11:40:06 +0100
Message-ID: <20210729104009.382-2-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.90.183]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
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

A new VMID allocator for arm64 KVM use. This is based on
arm64 ASID allocator algorithm.

One major deviation from the ASID allocator is the way we
flush the context. Unlike ASID allocator, we expect less
frequent rollover in the case of VMIDs. Hence, instead of
marking the CPU as flush_pending and issuing a local context
invalidation on the next context switch, we broadcast TLB
flush + I-cache invalidation over the inner shareable domain
on rollover.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |   4 +
 arch/arm64/kvm/vmid.c             | 176 ++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)
 create mode 100644 arch/arm64/kvm/vmid.c

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41911585ae0c..9df15811e7df 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -685,6 +685,10 @@ int kvm_arm_pvtime_get_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pvtime_has_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
 
+int kvm_arm_vmid_alloc_init(void);
+void kvm_arm_vmid_alloc_free(void);
+void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
+
 static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch *vcpu_arch)
 {
 	vcpu_arch->steal.base = GPA_INVALID;
diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
new file mode 100644
index 000000000000..b2dc12549405
--- /dev/null
+++ b/arch/arm64/kvm/vmid.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * VMID allocator.
+ *
+ * Based on Arm64 ASID allocator algorithm.
+ * Please refer arch/arm64/mm/context.c for detailed
+ * comments on algorithm.
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
+static unsigned int kvm_arm_vmid_bits;
+static DEFINE_RAW_SPINLOCK(cpu_vmid_lock);
+
+static atomic64_t vmid_generation;
+static unsigned long *vmid_map;
+
+static DEFINE_PER_CPU(atomic64_t, active_vmids);
+static DEFINE_PER_CPU(u64, reserved_vmids);
+
+#define VMID_MASK		(~GENMASK(kvm_arm_vmid_bits - 1, 0))
+#define VMID_FIRST_VERSION	(1UL << kvm_arm_vmid_bits)
+
+#define NUM_USER_VMIDS		VMID_FIRST_VERSION
+#define vmid2idx(vmid)		((vmid) & ~VMID_MASK)
+#define idx2vmid(idx)		vmid2idx(idx)
+
+#define vmid_gen_match(vmid) \
+	(!(((vmid) ^ atomic64_read(&vmid_generation)) >> kvm_arm_vmid_bits))
+
+static void flush_context(void)
+{
+	int cpu;
+	u64 vmid;
+
+	bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
+
+	for_each_possible_cpu(cpu) {
+		vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids, cpu), 0);
+
+		/* Preserve reserved VMID */
+		if (vmid == 0)
+			vmid = per_cpu(reserved_vmids, cpu);
+		__set_bit(vmid2idx(vmid), vmid_map);
+		per_cpu(reserved_vmids, cpu) = vmid;
+	}
+
+	/*
+	 * Unlike ASID allocator, we expect less frequent rollover in
+	 * case of VMIDs. Hence, instead of marking the CPU as
+	 * flush_pending and issuing a local context invalidation on
+	 * the next context-switch, we broadcast TLB flush + I-cache
+	 * invalidation over the inner shareable domain on rollover.
+	 */
+	 kvm_call_hyp(__kvm_flush_vm_context);
+}
+
+static bool check_update_reserved_vmid(u64 vmid, u64 newvmid)
+{
+	int cpu;
+	bool hit = false;
+
+	/*
+	 * Iterate over the set of reserved VMIDs looking for a match
+	 * and update to use newvmid (i.e. the same VMID in the current
+	 * generation).
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
+static u64 new_vmid(struct kvm_vmid *kvm_vmid)
+{
+	static u32 cur_idx = 1;
+	u64 vmid = atomic64_read(&kvm_vmid->id);
+	u64 generation = atomic64_read(&vmid_generation);
+
+	if (vmid != 0) {
+		u64 newvmid = generation | (vmid & ~VMID_MASK);
+
+		if (check_update_reserved_vmid(vmid, newvmid))
+			return newvmid;
+
+		if (!__test_and_set_bit(vmid2idx(vmid), vmid_map))
+			return newvmid;
+	}
+
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
+void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
+{
+	unsigned long flags;
+	unsigned int cpu;
+	u64 vmid, old_active_vmid;
+
+	vmid = atomic64_read(&kvm_vmid->id);
+
+	/*
+	 * Please refer comments in check_and_switch_context() in
+	 * arch/arm64/mm/context.c.
+	 */
+	old_active_vmid = atomic64_read(this_cpu_ptr(&active_vmids));
+	if (old_active_vmid && vmid_gen_match(vmid) &&
+	    atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
+				     old_active_vmid, vmid))
+		return;
+
+	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
+
+	/* Check that our VMID belongs to the current generation. */
+	vmid = atomic64_read(&kvm_vmid->id);
+	if (!vmid_gen_match(vmid)) {
+		vmid = new_vmid(kvm_vmid);
+		atomic64_set(&kvm_vmid->id, vmid);
+	}
+
+	cpu = smp_processor_id();
+
+	atomic64_set(this_cpu_ptr(&active_vmids), vmid);
+	raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
+}
+
+/*
+ * Initialize the VMID allocator
+ */
+int kvm_arm_vmid_alloc_init(void)
+{
+	kvm_arm_vmid_bits = kvm_get_vmid_bits();
+
+	/*
+	 * Expect allocation after rollover to fail if we don't have
+	 * at least one more VMID than CPUs. VMID #0 is always reserved.
+	 */
+	WARN_ON(NUM_USER_VMIDS - 1 <= num_possible_cpus());
+	atomic64_set(&vmid_generation, VMID_FIRST_VERSION);
+	vmid_map = kcalloc(BITS_TO_LONGS(NUM_USER_VMIDS),
+			   sizeof(*vmid_map), GFP_KERNEL);
+	if (!vmid_map)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void kvm_arm_vmid_alloc_free(void)
+{
+	kfree(vmid_map);
+}
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
