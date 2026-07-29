Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ECF53590A9
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 10:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321994; cv=none; b=Qh4m3jgGp4lkdLGKqZ9TluZyoONWGjMJV3G3vkUhdICmF5l6TolITAKhPjy4jWOknr4i5eAch4aGzwuA8hfSsBTjJ1pT5j5ooh/L7luTK1jEfUOytoQMu7UJQ5R7O2i4bIrxRKHL+dPzJanD57AqYEtTookpU74n/9kS703kV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321994; c=relaxed/simple;
	bh=krw/sfsyDoIbNATh5zn2IBbCLe/1TBp6iVLQC6rR4tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heS4mtLBKHtKh0lsRunLJfqxdM3HQA9K92G9lfAnzSAXkdt92O47lrAelpDmgsNR+PCtLWt9XFfgVg4BnG4ve8SC57e06HzYJriwrnVOlkScvblcZNKbTTvxPzN1/UbJKLkUPAcQbbK9Vi2bVFOiexdeHjCWbOZiBdtb1wiM1gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gZ4THYRe; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gZ4THYRe"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC9101688;
	Wed, 29 Jul 2026 03:46:27 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3156D3F66F;
	Wed, 29 Jul 2026 03:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785321992; bh=krw/sfsyDoIbNATh5zn2IBbCLe/1TBp6iVLQC6rR4tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZ4THYReWjkQIfO3/0NY3KVdRivTSev+Kcw/dT8DqtRgdnF3+EN3suJYqCX8B9pAG
	 uDMd2YD0+rj6uMBFa9itsOJBmIZo9u99CZlL8/43KgGmFmcm5aWMZ0YY1OB2Z2PHqi
	 Pi0yG5fAxK/tVArBCLTIScPCEKKlsmxZCVZgqyw8=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v3 04/11] KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
Date: Wed, 29 Jul 2026 11:45:39 +0100
Message-ID: <20260729104548.3439958-5-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729104548.3439958-1-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5998; i=leo.bras@arm.com; h=from:subject; bh=krw/sfsyDoIbNATh5zn2IBbCLe/1TBp6iVLQC6rR4tw=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLIyb1779VlZ0/PL3GsH51xqnsj08b74xSWliRMfJC1Tz eiK7dyc0VHKwiDGxSArpsgi+2j+Kp7vUzKOXPmxAGYOKxPIEAYuTgGYyP1tDH+FtxwxNOHbeGaX 7k5FXVnXiOnaVpOCd5wuvhPpyGapduw2wz+TD3+Knj7WZlD6svwQY8ADJ3mR1DS31O0VJYwdbkt 37GcDAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

Introduce the basic cleaning routine that is going to be used for both
dirty-bitmap and dirty-ring routines.

It sets the required registers with the input buffer, and wait for
HACDBS to finish, which means either the task is done, or there was some
error during processing.

It is ran with preemption disabled, as a task being scheduled in could
change the translation registers used by HACDBS and end up corrupting the
current dirty-bit tracking and the sched-in task's S2 pagetables.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/dirty_bit.c | 176 +++++++++++++++++++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index 32fe938d6bf7..33826bbd16d9 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -1,16 +1,192 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2026 ARM Ltd.
  * Author: Leonardo Bras <leo.bras@arm.com>
  */
 
 #include <asm/kvm_dirty_bit.h>
+#include <asm/kvm_mmu.h>
 
 /* HDBSS entry field definitions */
 #define HDBSS_ENTRY_VALID BIT(0)
 #define HDBSS_ENTRY_TTWL_SHIFT (1)
 #define HDBSS_ENTRY_TTWL_MASK (GENMASK(3, 1))
 #define HDBSS_ENTRY_TTWL(x) \
 	(((x) << HDBSS_ENTRY_TTWL_SHIFT) & HDBSS_ENTRY_TTWL_MASK)
 #define HDBSS_ENTRY_TTWL_RESV HDBSS_ENTRY_TTWL(-4)
 #define HDBSS_ENTRY_IPA GENMASK_ULL(55, 12)
+
+struct hacdbs_save {
+	u64 hacdbsbr_el2;
+	u64 hacdbscons_el2;
+	u64 vttbr_el2;
+	u64 vtcr_el2;
+	bool hcr_vm_set;
+};
+
+struct hacdbs_sched_save {
+	struct preempt_notifier notifier;
+	struct hacdbs_save save;
+};
+
+static int hacdbs_last_entry(int size)
+{
+	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
+	int index = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
+
+	switch (FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons)) {
+	case HACDBSCONS_EL2_ERR_REASON_NOF:
+		return size;
+	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
+		/* When size not a power of two >= 4k, exit with reserved TTLW */
+		if (index >= size)
+			return size;
+
+		fallthrough;
+	default:
+		/* In case of error, INDEX should point the faulty entry */
+		return index;
+	}
+}
+
+static void hacdbs_start(u64 *hw_entries, int size)
+{
+	u64 br;
+	/* Each entry is 8 bytes */
+	int size_b = size * sizeof(hw_entries[0]);
+	int size_p2 = max(roundup_pow_of_two(size_b), PAGE_SIZE);
+
+	/* If not using the full size of the array, put a stop entry at the end */
+	if (size_b < size_p2)
+		hw_entries[size] = HDBSS_ENTRY_VALID | HDBSS_ENTRY_TTWL_RESV;
+
+	sysreg_clear_set_s(SYS_HACDBSCONS_EL2,
+			   HACDBSCONS_EL2_ERR_REASON | HACDBSCONS_EL2_INDEX, 0);
+
+	br = (virt_to_phys(hw_entries) & HACDBSBR_EL2_BADDR_MASK) |
+	     FIELD_PREP(HACDBSBR_EL2_SZ, ilog2(size_p2) - 12) |
+	     FIELD_PREP(HACDBSBR_EL2_EN, 1);
+
+	/* All writes to the array have to complete before starting */
+	dsb(ishst);
+
+	write_sysreg_s(br, SYS_HACDBSBR_EL2);
+	isb();
+}
+
+static int hacdbs_stop(int size)
+{
+	int idx;
+
+	write_sysreg_s(0, SYS_HACDBSBR_EL2);
+	isb();
+
+	idx = hacdbs_last_entry(size);
+
+	return idx;
+}
+
+static void hacdbs_sched_in(struct preempt_notifier *notifier, int cpu)
+{
+	struct hacdbs_sched_save *save = container_of(notifier,
+						      struct hacdbs_sched_save,
+						      notifier);
+
+	write_sysreg_s(save->save.vtcr_el2, SYS_VTCR_EL2);
+	write_sysreg_s(save->save.vttbr_el2, SYS_VTTBR_EL2);
+	isb();
+
+	if (save->save.hcr_vm_set) {
+		sysreg_clear_set_hcr(0, HCR_EL2_VM);
+		isb();
+	}
+
+	write_sysreg_s(save->save.hacdbscons_el2, SYS_HACDBSCONS_EL2);
+	write_sysreg_s(save->save.hacdbsbr_el2, SYS_HACDBSBR_EL2);
+	isb();
+}
+
+static void hacdbs_sched_out(struct preempt_notifier *notifier,
+			     struct task_struct *next)
+{
+	struct hacdbs_sched_save *save = container_of(notifier,
+						      struct hacdbs_sched_save,
+						      notifier);
+
+	if (read_sysreg_s(SYS_HACDBSBR_EL2) & HACDBSBR_EL2_EN) {
+		save->save.hacdbsbr_el2 = HACDBSBR_EL2_EN;
+		sysreg_clear_set_s(SYS_HACDBSBR_EL2, HACDBSBR_EL2_EN, 0);
+		isb();
+	} else {
+		save->save.hacdbsbr_el2 = 0;
+	}
+
+	save->save.hacdbscons_el2 = read_sysreg_s(SYS_HACDBSCONS_EL2);
+	save->save.hacdbsbr_el2 |= read_sysreg_s(SYS_HACDBSBR_EL2);
+	save->save.vttbr_el2 = read_sysreg_s(SYS_VTTBR_EL2);
+	save->save.vtcr_el2 = read_sysreg_s(SYS_VTCR_EL2);
+
+	if (read_sysreg_s(SYS_HCR_EL2) & HCR_EL2_VM) {
+		sysreg_clear_set_hcr(HCR_EL2_VM, 0);
+		isb();
+		save->save.hcr_vm_set = true;
+	} else {
+		save->save.hcr_vm_set = false;
+	}
+}
+
+static struct preempt_ops hacdbs_preempt_ops = {
+	.sched_in = hacdbs_sched_in,
+	.sched_out = hacdbs_sched_out,
+};
+
+/*
+ * Clears dirty-bits for an array of pages (hw_entries) using HACDBS
+ * Returns the number of items cleaned from the array. If returns value < size,
+ *	there was an error in the processing.
+ */
+static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
+{
+	int ret;
+	u64 cons;
+	struct hacdbs_sched_save save;
+
+	preempt_notifier_init(&save.notifier, &hacdbs_preempt_ops);
+	preempt_disable();
+	preempt_notifier_register(&save.notifier);
+	preempt_enable();
+
+	__load_stage2(&kvm->arch.mmu);
+	sysreg_clear_set_hcr(0, HCR_EL2_VM);
+	isb();
+
+	hacdbs_start(hw_entries, size);
+
+	do {
+		cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
+		if (FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons))
+			break;
+
+		if (FIELD_GET(HACDBSCONS_EL2_INDEX, cons) >= size)
+			break;
+
+		udelay(1);
+	} while (true);
+
+	ret = hacdbs_stop(size);
+
+	sysreg_clear_set_hcr(HCR_EL2_VM, 0);
+	isb();
+
+	/*
+	 * No DSB is needed here, as kvm_flush_remote_tlbs_memslot() that happens
+	 * later in generic dirty-cleaning code already performs a DSB before
+	 * doing the TLBI.
+	 */
+
+	preempt_disable();
+	preempt_notifier_unregister(&save.notifier);
+	preempt_enable();
+
+	return ret;
+}
-- 
2.55.0

