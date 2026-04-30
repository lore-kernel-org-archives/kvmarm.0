Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6AF40B6E5;
	Thu, 30 Apr 2026 11:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777547749; cv=none; b=OXGF9Nsim5MZ5dVmptGLqRO439zsimZSJ5B8r/PpLrK1sHamy5oC70SDhtVBpcXtJUYiMjATY5rxOsVmHEn86MscpcnslUgR3zWLNlom/V7BATOicQw1835M4KMMH+WfZkCWuzQpl5Pwa76m+zx2ghlhwyArpjdgDTv7vEtmbUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777547749; c=relaxed/simple;
	bh=wZ+B2i5T+YTs9KjTiOk5jbT7BSpcv7bgMbQ7JYPWchg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pOjlG085rvwzF+OBaaPIuOHIs5ZxNfURVXfy6VvlWPaUK+uhbJg++E25F4zK9UqSj25LungZbZKrQaVV3frLBcTHtHf8TGr3Xe5q3ovO4hm6nlBfkXkumciy2sMp36ISreUahI4mbOPVqJBSw3kdXPcpW3q2oMsIBVG63XCJ2zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=jjmBGAm/; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="jjmBGAm/"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9EEF354E;
	Thu, 30 Apr 2026 04:15:41 -0700 (PDT)
Received: from devkitleo.cambridge.arm.com (devkitleo.cambridge.arm.com [10.1.196.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2D6D3F763;
	Thu, 30 Apr 2026 04:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777547747; bh=wZ+B2i5T+YTs9KjTiOk5jbT7BSpcv7bgMbQ7JYPWchg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjmBGAm/d8papjvaMBr0lo1UQvwyvDA/gKC4gwQknxiPPsQn2EBUvTJPXBWAI32bM
	 XtnLw5KnXMhUvswEeFrI9/QT4uAVUsh+3jiUnpbhE9VQnwpNs4JG6GBaGbKQmbozQx
	 M77mFI3b1VeX3w2ftIGOnqnDj+1UnWQrtgz5Tl5A=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Leonardo Bras <leo.bras@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Saket Dumbre <saket.dumbre@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Chengwen Feng <fengchengwen@huawei.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Kees Cook <kees@kernel.org>,
	=?UTF-8?q?Miko=C5=82aj=20Lenczewski?= <miko.lenczewski@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Thomas Huth <thuth@redhat.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-acpi@vger.kernel.org,
	acpica-devel@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v1 06/12] KVM: arm64: dirty_bit: Add base FEAT_HACDBS cleaning routine
Date: Thu, 30 Apr 2026 12:14:10 +0100
Message-ID: <20260430111424.3479613-8-leo.bras@arm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430111424.3479613-2-leo.bras@arm.com>
References: <20260430111424.3479613-2-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce the basic cleaning routine that is going to be used for both
dirty-bitmap and dirty-ring routines.

It sets the required registers with the input buffer, and wait for
HACDBSIRQ to happen, which means either the task is done, or there was some
error during processing.

It is ran with preemption disabled, as a task being scheduled in could
change the translation registers used by HACDBS and end up corrupting the
current dirty-bit tracking and the sched-in task's S2 pagetables.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/kvm/dirty_bit.c | 86 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
index 765ef609ff70..22e3ed07256a 100644
--- a/arch/arm64/kvm/dirty_bit.c
+++ b/arch/arm64/kvm/dirty_bit.c
@@ -1,17 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (C) 2026 ARM Ltd.
  * Author: Leonardo Bras <leo.bras@arm.com>
  */
 
 #include <asm/kvm_dirty_bit.h>
+#include <asm/kvm_mmu.h>
 #include <linux/kconfig.h>
 #include <linux/acpi.h>
 
 DEFINE_PER_CPU(struct hacdbs, hacdbs_pcp) = {
 	.status = HACDBS_OFF,
 	.size = 0,
 };
 
 /* HDBSS entry field definitions */
 #define HDBSS_ENTRY_VALID BIT(0)
@@ -24,20 +25,105 @@ DEFINE_PER_CPU(struct hacdbs, hacdbs_pcp) = {
 
 inline u64 hdbss_get_ttwl(u64 chunk_size)
 {
 	u64 hw_lvl = ARM64_HW_PGTABLE_LEVELS(ilog2(chunk_size));
 
 	return HDBSS_ENTRY_TTWL(3 - hw_lvl);
 }
 
 static __ro_after_init int hacdbsirq = -1;
 
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
+	this_cpu_write(hacdbs_pcp.status, HACDBS_RUNNING);
+	this_cpu_write(hacdbs_pcp.size, size);
+	write_sysreg_s(br, SYS_HACDBSBR_EL2);
+	isb();
+}
+
+static int hacdbs_stop(void)
+{
+	write_sysreg_s(0, SYS_HACDBSBR_EL2);
+	isb();
+
+	if (this_cpu_read(hacdbs_pcp.status) == HACDBS_ERROR) {
+		/* In case of error, HACDBSCONS_EL2.INDEX should point the faulty entry */
+		u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
+		int idx = FIELD_GET(HACDBSCONS_EL2_INDEX, cons);
+
+		trace_printk("HACDBS found error %lu in index %d / %d\n",
+			     FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons), idx,
+			     this_cpu_read(hacdbs_pcp.size));
+
+		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
+
+		return idx;
+	}
+
+	return this_cpu_read(hacdbs_pcp.size);
+}
+
+/*
+ * Clears dirty-bits for an array of pages (hw_entries) using HACDBS
+ * Returns the number of items cleaned from the array. If returns value < size,
+ *	there was an error in the processing.
+ */
+static int dirty_bit_clear(struct kvm *kvm, u64 *hw_entries, int size)
+{
+	enum hacdbs_status st;
+	u64 hcr_el2;
+	int ret;
+
+	preempt_disable();
+
+	hcr_el2 = read_sysreg(HCR_EL2);
+	write_sysreg(hcr_el2 | HCR_EL2_VM, HCR_EL2);
+	__load_stage2(&kvm->arch.mmu, kvm->arch.mmu.arch);
+
+	hacdbs_start(hw_entries, size);
+
+	do {
+		wfi();
+	} while ((st = this_cpu_read(hacdbs_pcp.status)) == HACDBS_RUNNING);
+
+	ret = hacdbs_stop();
+
+	write_sysreg(hcr_el2, HCR_EL2);
+	isb();
+
+	/*
+	 * No DSB is needed here, as kvm_flush_remote_tlbs_memslot() that happens
+	 * later in generic dirty-cleaning code already performs a DSB before
+	 * doing the TLBI.
+	 */
+
+	preempt_enable();
+
+	return ret;
+}
+
 static irqreturn_t hacdbsirq_handler(int irq, void *pcpu)
 {
 	u64 cons = read_sysreg_s(SYS_HACDBSCONS_EL2);
 	unsigned long err = FIELD_GET(HACDBSCONS_EL2_ERR_REASON, cons);
 
 	switch (err) {
 	case HACDBSCONS_EL2_ERR_REASON_NOF:
 		this_cpu_write(hacdbs_pcp.status, HACDBS_IDLE);
 		break;
 	case HACDBSCONS_EL2_ERR_REASON_IPAHACF:
-- 
2.54.0

