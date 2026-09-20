Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F284447FB00
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933166; cv=none; b=QXYFwtI+zqOdXVtR+RjtQ8KMuxmJ6bjegySrw0XlUNd5WHFcyCisy0+fJBgVTU8finwRRhk668jGV8CMtuBE9XnFOHI64b0frAwEfEUpSakKTuMj06HUGmSA1ZeTU5QgrvFT7tICsUU2OD50gppAaNVkYz6wyTSobbueDnMhLmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933166; c=relaxed/simple;
	bh=1dGfuKt7fofYNW4Qi1s9T49DlB1/tUBSSVg6v1aZEZs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siOIyYxbHkRi0HSZhOohPojkM0KzLvE5E/tTtVPshFEm3kNzMkbv7CIrvI4a8UAEJsvIUsWD/8UkEQrklHpaTY+MEKNR+3/DrcuiKuCfX/0A0KS5PhtHiYCSkJPG32GTw/XYA4c9kCMZX8xGQKiiHRVrAx8MQg329U0Z/A4fPFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=gNHdbAqG; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="gNHdbAqG"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d43ac8d1eso16265827b3.2
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933163; x=1790537963; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2ibDJILDIEWvBMPoTlKij96smUhkgzpAH7q+zsoMbGI=;
        b=gNHdbAqGfDhma9AJtCjoihxSFwiBfGL5ipGnlV/w/bz6JhkwzqpY0l3PYw7HWkCHc7
         c/v4IZlY+DfV5WYN2vQLQV8J71ssATYopKH82mVPk7d1N0NgN4r9sB+w9QrchrUL263J
         wz/HFvPoBtBCoq72ei4hNtlqu7BH/OQ0aZwldaZ2OiaNriw6AWfsyPKUPCsrjbarRMob
         1M164lMTJc0iB5dsJfOhgAcM9IIQ2VleGXylLTxs41L57cweP6P/Z+VgMid12BtPIRe7
         bJrw7Wl7CpN+SIlDt7UzIWLtyGfT6ME8HVbfMDmalEOR1gU7tTKg+Qd4he+bdVFXFeJ6
         RclQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933163; x=1790537963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2ibDJILDIEWvBMPoTlKij96smUhkgzpAH7q+zsoMbGI=;
        b=zfwH/cFRlRy3TUuhYAAV55Xj8KOf4hOFNeUugPPK+OpAUCcOkWWmiGPe67N0aQ4t3T
         wExcbPdcAEmshw+yId2aexgHFZnH6UWFEAL53lr8X7b3CXFvLnRJVMZ9PoFOJlaag0MG
         HfMaRSU0srvku85XfeH4QBrUUoSRbjFSYgJQyCofZcTrjngZCjYmi62Wz3A0P+TYCJeR
         VufX25VI8mxvanKtL3Z/n+7tvPFW8CbE+uEYZi9ZgZH8XzkeP+3htQv4W08LnmproTKt
         DOmJdT8zaYO4uO7pjF+y0GC+Zy1r2Tg6wa79cZBz/TNbc8f0cXP/ICtuOq+ktalu/HaP
         Ae1Q==
X-Forwarded-Encrypted: i=1; AKwUvByP2/dTMCMuu0iUmL7PEIe0roRZzVQZirl+JV9cgh4hwLRVdJrZo5EchgZqez4xuOe9z9rKj1U=@lists.linux.dev
X-Gm-Message-State: AFuF++n8qvfa2VgjboNyiprIt187qTMxfd8ecZbpXv9+3ecAPcKC4v4/
	ugF0UdS7E0dWPbsbHLauR5pDm/BanDi5iDDcFnpSlPbwQEX8GQeDJmpL/w0bKarEWRg=
X-Gm-Gg: AYBFou25PMkS45viiO5h/wNZffChF5z49aG3lEgpokCaoUQZLZbW7kvwgYUcUP/+jMd
	SoBgQszueU2TTxp2HCRMceAzxA3hhcxEm36CfPdBPIfBgJ9Ykf5IDw02t4xCpiQZcGYs/P3rz7W
	uQFRSz8Rr+YSyVO67xyFtwlFzs0j44ffdpOiFTfEKv446FH0d/VDc9cxsM0l24pj41ZoV/HWJ1L
	UicdC44HhsTljL0NlfssCFh8BKvYOh2mNHlqYVmV+eAOMUorPN7W6gSSZgMZ8j1aCCr2CPTbS2f
	awPCFhqRYgzwe8q05XHUCga8NTHDzGVA7oZvwAHTvnTFtZ833fca+G0FOabTots2CAuZ1+VwwVR
	R+NBnOaTkDhybyRrOqiRLmMMT/Ttdmk8dCzUv2vnw2SrHm7RTOYmlM7do4NUNvsRg73kVx275co
	BuEwd+5ZD6cOqz36TvF4dD11/oVGzl/nhnJfCYiiDglGJXB27L9yaTcaExAFOdZb91/VHw+A1c+
	dcm+LBDfrsRstjgXTCWjpJqpaRgK8n0d7LMMAwROGcEHlLIpc8K3r5W7ADJ9wQktTMoGZM0o5EI
	eluUIos2vQ36+81KQaKs2IcK9eTUgg==
X-Received: by 2002:a05:690c:e1dc:10b0:873:5c0f:27d with SMTP id 00721157ae682-89735f6eb39mr22894817b3.39.1789933162976;
        Sun, 20 Sep 2026 12:39:22 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a47af7bfbsm18840877b3.33.2026.09.20.12.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:39:21 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 25/46] arm64: liveupdate: Add support for physical CPU preservation
Date: Sun, 20 Sep 2026 15:36:29 -0400
Message-ID: <20260920193650.3373435-26-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable physical CPU preservation on arm64 by selecting
ARCH_SUPPORTS_LIVEUPDATE_CPU.

Integrate preserved CPU handling into the arm64 SMP and CPU hotplug
paths with isolated transition page tables:
- Build isolated transition page tables mapping exclusively preserved
  text/rodata (ROX), data (RW), stacks (RW), and preserved buffers.
- Completely eliminate bulk cloning of the kernel linear direct map.
- Limit KHO page table memory footprint to < 10 pages total.
- Include CPU_PRESERVED_TEXT in arm64 vmlinux.lds.S.
- Compile cpu_preserve.o with -mbranch-protection=none and
  -fno-stack-protector to prevent PAC key mismatch aborts.
- In __cpu_disable(), avoid tearing down IPIs for preserved CPUs.
- In op_cpu_kill(), skip waiting for the CPU to die if preserved.
- In smp_send_stop(), exclude preserved CPUs from stop IPIs.
- Add cache maintenance to PoC for secondary boot data and page tables.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/Kconfig                    |   1 +
 arch/arm64/include/asm/cpu_preserve.h |  44 ++++
 arch/arm64/kernel/Makefile            |   7 +
 arch/arm64/kernel/cpu_preserve.c      | 365 ++++++++++++++++++++++++++
 arch/arm64/kernel/preserve_cpu.S      |  44 ++++
 arch/arm64/kernel/smp.c               |   8 +-
 arch/arm64/kernel/vmlinux.lds.S       |   1 +
 7 files changed, 469 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/cpu_preserve.h
 create mode 100644 arch/arm64/kernel/cpu_preserve.c
 create mode 100644 arch/arm64/kernel/preserve_cpu.S

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5a51b0ef944..957ec38a9680 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -38,6 +38,7 @@ config ARM64
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
+	select ARCH_SUPPORTS_LIVEUPDATE_CPU if LIVEUPDATE
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_NONLEAF_PMD_YOUNG if ARM64_HAFT
diff --git a/arch/arm64/include/asm/cpu_preserve.h b/arch/arm64/include/asm/cpu_preserve.h
new file mode 100644
index 000000000000..7c7c94f21ccc
--- /dev/null
+++ b/arch/arm64/include/asm/cpu_preserve.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#ifndef __ASM_ARM64_CPU_PRESERVE_H
+#define __ASM_ARM64_CPU_PRESERVE_H
+
+#include <asm/memory.h>
+#include <asm/tlbflush.h>
+#include <asm/virt.h>
+
+#define ARCH_CPU_PRESERVED_STACK_ORDER	(THREAD_SIZE_ORDER + 1)
+
+bool arch_cpu_preserved_is_active(void);
+asmlinkage void __arch_cpu_preserved_dcache_clean(unsigned long start, unsigned long end);
+asmlinkage void arch_cpu_preserved_dcache_clean(unsigned long start, unsigned long end);
+asmlinkage void arch_cpu_preserved_dcache_inval(unsigned long start, unsigned long end);
+
+static inline void arm64_flush_host_tlb_local(void)
+{
+	dsb(nshst);
+	if (is_kernel_in_hyp_mode()) {
+		asm volatile("tlbi alle2\n"
+			     "dsb nsh\n"
+			     "isb\n" ::: "memory");
+	} else {
+		local_flush_tlb_all();
+	}
+}
+
+static inline void arm64_flush_host_tlb_all(void)
+{
+	dsb(ishst);
+	if (is_kernel_in_hyp_mode()) {
+		asm volatile("tlbi alle2is\n"
+			     "dsb ish\n"
+			     "isb\n" ::: "memory");
+	} else {
+		flush_tlb_all();
+	}
+}
+
+#endif /* __ASM_ARM64_CPU_PRESERVE_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index d2690c3ec528..151513a5350b 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -70,6 +70,13 @@ obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
 obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
 obj-$(CONFIG_ARM64_MPAM)		+= mpam.o
 obj-$(CONFIG_ARM64_MTE)			+= mte.o
+obj-$(CONFIG_LIVEUPDATE_CPU)		+= cpu_preserve.o preserve_cpu.o
+KASAN_SANITIZE_cpu_preserve.o := n
+KCSAN_SANITIZE_cpu_preserve.o := n
+UBSAN_SANITIZE_cpu_preserve.o := n
+KCOV_INSTRUMENT_cpu_preserve.o := n
+CFLAGS_REMOVE_cpu_preserve.o = $(CC_FLAGS_FTRACE)
+CFLAGS_cpu_preserve.o += $(call cc-option,-mbranch-protection=none) -fno-stack-protector $(call cc-option,-ftrivial-auto-var-init=uninitialized) $(call cc-option,-fno-jump-tables)
 obj-y					+= vdso-wrap.o
 obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
 
diff --git a/arch/arm64/kernel/cpu_preserve.c b/arch/arm64/kernel/cpu_preserve.c
new file mode 100644
index 000000000000..15de1ca09062
--- /dev/null
+++ b/arch/arm64/kernel/cpu_preserve.c
@@ -0,0 +1,365 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ *
+ * Architecture specific CPU preservation support for ARM64.
+ */
+#include <linux/arm-smccc.h>
+#include <linux/cpu_preserve.h>
+#include <linux/irqchip/arm-gic-v3.h>
+#include <linux/kexec_handover.h>
+#include <linux/kho/abi/cpu.h>
+#include <linux/mm.h>
+#include <linux/psci.h>
+#include <linux/sched/mm.h>
+#include <uapi/linux/psci.h>
+
+#include <asm/barrier.h>
+#include <linux/cacheflush.h>
+#include <asm/cpu_ops.h>
+#include <asm/daifflags.h>
+#include <asm/kernel-pgtable.h>
+#include <asm/kvm_asm.h>
+#include <linux/pgtable.h>
+#include <asm/sysreg.h>
+#include <asm/tlbflush.h>
+#include <asm/trans_pgd.h>
+#include <asm/virt.h>
+
+static enum arm_smccc_conduit arm64_psci_conduit __cpu_preserved_data;
+phys_addr_t arm64_caretaker_pgd_pa __cpu_preserved_data;
+static u64 arm64_cpu_mpidr[NR_CPUS] __cpu_preserved_data;
+
+/*
+ * Signal or wake up a preserved physical CPU via SEV.
+ */
+void __cpu_preserved_text arch_cpu_preserved_kick(int cpu)
+{
+	dsb(ishst);
+	sev();
+	isb();
+}
+
+/*
+ * Low-power wait in parking loop.
+ */
+void __cpu_preserved_text arch_cpu_preserved_park_wait(void)
+{
+	wfe();
+}
+
+int __cpu_preserved_text arch_cpu_preserved_mpidr_to_cpu(u64 mpidr)
+{
+	int c;
+
+	for (c = 0; c < ARRAY_SIZE(arm64_cpu_mpidr); c++) {
+		if ((arm64_cpu_mpidr[c] & MPIDR_HWID_BITMASK) == (mpidr & MPIDR_HWID_BITMASK))
+			return c;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_mpidr_to_cpu);
+
+bool __cpu_preserved_text arch_cpu_preserved_is_active(void)
+{
+	struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
+	u64 ttbr1 = read_sysreg(ttbr1_el1);
+
+	if (sctx && sctx->session_pgd_pa && ttbr1 == sctx->session_pgd_pa)
+		return true;
+
+	if (arm64_caretaker_pgd_pa)
+		return ttbr1 == arm64_caretaker_pgd_pa;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_is_active);
+
+void __cpu_preserved_text arch_cpu_preserved_switch_pgd(phys_addr_t pgd_pa)
+{
+	if (pgd_pa && read_sysreg(ttbr1_el1) != pgd_pa) {
+		write_sysreg(pgd_pa, ttbr1_el1);
+		isb();
+		arm64_flush_host_tlb_local();
+	}
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_switch_pgd);
+
+static pte_t *arm64_get_kernel_pte(unsigned long addr)
+{
+	pgd_t *pgdp = pgd_offset_k(addr);
+	p4d_t *p4dp;
+	pud_t *pudp;
+	pmd_t *pmdp;
+
+	if (pgd_none(READ_ONCE(*pgdp)))
+		return NULL;
+
+	p4dp = p4d_offset(pgdp, addr);
+	if (p4d_none(READ_ONCE(*p4dp)))
+		return NULL;
+
+	pudp = pud_offset(p4dp, addr);
+	if (pud_none(READ_ONCE(*pudp)) || pud_leaf(READ_ONCE(*pudp)))
+		return NULL;
+
+	pmdp = pmd_offset(pudp, addr);
+	if (pmd_none(READ_ONCE(*pmdp)) || pmd_leaf(READ_ONCE(*pmdp)))
+		return NULL;
+
+	return pte_offset_kernel(pmdp, addr);
+}
+
+/**
+ * arch_cpu_preserved_as_map - Populate an isolated page table on arm64
+ * @as: Address space to map into.
+ * @pa: Physical address of the range.
+ * @va: Virtual address the range must appear at.
+ * @size: Size of the range in bytes.
+ * @prot: Protection to apply.
+ *
+ * Return: 0 on success, or a negative errno on failure.
+ */
+int arch_cpu_preserved_as_map(struct cpu_preserved_as *as, phys_addr_t pa,
+			      unsigned long va, size_t size, pgprot_t prot)
+{
+	struct trans_pgd_info info = {
+		.trans_alloc_page = cpu_preserved_as_alloc_page,
+		.trans_alloc_arg = as,
+	};
+	unsigned long offset = va & ~PAGE_MASK;
+	size_t page_size = PAGE_ALIGN(offset + size);
+	unsigned long page_va = va & PAGE_MASK;
+	phys_addr_t page_pa = (pa & PAGE_MASK);
+
+	return trans_pgd_map_range(&info, as->pgd, page_pa,
+				   page_va, page_size, prot);
+}
+
+void arch_cpu_preserved_as_flush_tlb(void)
+{
+	arm64_flush_host_tlb_all();
+}
+
+void arch_cpu_preserved_set_transition_as(struct cpu_preserved_as *as)
+{
+	arm64_caretaker_pgd_pa = as ? as->pgd_pa : 0;
+	cpu_preserved_clean(&arm64_caretaker_pgd_pa);
+}
+
+/**
+ * arch_cpu_preserved_setup_buffer - Set up runtime buffer and page tables
+ * @text_page: Runtime-allocated physical page backing preserved text
+ * @text_nr_pages: Number of pages in text buffer
+ * @data_page: Runtime-allocated physical page backing preserved data
+ * @data_nr_pages: Number of pages in data buffer
+ *
+ * Remap init_mm kernel mappings for __cpu_preserved_text and
+ * __cpu_preserved_data to point to the runtime-allocated pages outside
+ * Scratch.
+ *
+ * Return: 0 on success, or -ENOMEM on failure.
+ */
+static void arm64_split_contpte_range(unsigned long start, unsigned long end)
+{
+	unsigned long addr;
+
+	if (start >= end)
+		return;
+
+	for (addr = ALIGN_DOWN(start, CONT_PTE_SIZE); addr < end; addr += CONT_PTE_SIZE) {
+		pte_t *ptep = arm64_get_kernel_pte(addr);
+		int i;
+
+		if (!ptep)
+			continue;
+
+		ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
+
+		for (i = 0; i < CONT_PTES; i++) {
+			pte_t pte = __ptep_get(&ptep[i]);
+
+			if (pte_valid_cont(pte))
+				__set_pte(&ptep[i], pte_mknoncont(pte));
+		}
+	}
+
+	flush_tlb_kernel_range(ALIGN_DOWN(start, CONT_PTE_SIZE),
+			       ALIGN(end, CONT_PTE_SIZE));
+	arm64_flush_host_tlb_all();
+}
+
+int arch_cpu_preserved_setup_buffer(struct page *text_page,
+				    unsigned int text_nr_pages,
+				    struct page *data_page,
+				    unsigned int data_nr_pages)
+{
+	unsigned long text_start = (unsigned long)__cpu_preserved_text_start;
+	unsigned long data_start = (unsigned long)__cpu_preserved_data_start;
+	unsigned int i;
+
+	/* Split any contiguous 64KB mappings before replacing individual PTEs */
+	arm64_split_contpte_range(text_start, text_start + text_nr_pages * PAGE_SIZE);
+	arm64_split_contpte_range(data_start, data_start + data_nr_pages * PAGE_SIZE);
+
+	/* Clean old mappings before switching PTEs */
+	__arch_cpu_preserved_dcache_clean(text_start, text_start + text_nr_pages * PAGE_SIZE);
+	__arch_cpu_preserved_dcache_clean(data_start, data_start + data_nr_pages * PAGE_SIZE);
+
+	/* Remap init_mm kernel mappings to point to allocated buffer pages */
+	for (i = 0; i < text_nr_pages; i++) {
+		unsigned long va = text_start + i * PAGE_SIZE;
+		pte_t *ptep = arm64_get_kernel_pte(va);
+
+		if (!ptep)
+			return -EINVAL;
+
+		pgprot_t prot = __pgprot(pgprot_val(pte_pgprot(*ptep)) & ~PTE_CONT);
+		phys_addr_t pa = page_to_phys(text_page) + i * PAGE_SIZE;
+
+		set_pte_at(&init_mm, va, ptep, pfn_pte(PHYS_PFN(pa), prot));
+	}
+
+	for (i = 0; i < data_nr_pages; i++) {
+		unsigned long va = data_start + i * PAGE_SIZE;
+		pte_t *ptep = arm64_get_kernel_pte(va);
+
+		if (!ptep)
+			return -EINVAL;
+
+		pgprot_t prot = __pgprot(pgprot_val(pte_pgprot(*ptep)) & ~PTE_CONT);
+		phys_addr_t pa = page_to_phys(data_page) + i * PAGE_SIZE;
+
+		set_pte_at(&init_mm, va, ptep, pfn_pte(PHYS_PFN(pa), prot));
+	}
+
+	arm64_flush_host_tlb_all();
+	flush_icache_range(text_start, text_start + (text_nr_pages * PAGE_SIZE));
+
+	for (i = 0; i < nr_cpu_ids; i++)
+		arm64_cpu_mpidr[i] = cpu_logical_map(i);
+	cpu_preserved_clean(&arm64_cpu_mpidr);
+
+	return 0;
+}
+
+/*
+ * Masks DAIF interrupts and enables GIC CPU interface for WFx wakeups.
+ */
+void __cpu_preserved_text arch_cpu_preserved_park_init(int cpu)
+{
+	struct cpu_preserved_stack_context *sctx = cpu_preserved_get_stack_context();
+	phys_addr_t pgd_pa = 0;
+
+	if (sctx && sctx->session_pgd_pa)
+		pgd_pa = sctx->session_pgd_pa;
+	else
+		pgd_pa = cpu_preserved_get_pgd(cpu);
+
+	local_daif_mask();
+	cpu_preserved_inval(&arm64_psci_conduit);
+	cpu_preserved_inval(&arm64_cpu_mpidr);
+	if (!pgd_pa) {
+		cpu_preserved_inval(&arm64_caretaker_pgd_pa);
+		pgd_pa = READ_ONCE(arm64_caretaker_pgd_pa);
+	}
+
+	write_sysreg(0, ttbr0_el1);
+	if (pgd_pa)
+		write_sysreg(pgd_pa, ttbr1_el1);
+	isb();
+	arm64_flush_host_tlb_local();
+
+	write_sysreg_s(0xff, SYS_ICC_PMR_EL1);
+	write_sysreg_s(1, SYS_ICC_IGRPEN1_EL1);
+	isb();
+}
+
+void arch_cpu_preserved_early_init(void)
+{
+	int c;
+
+	for (c = 0; c < ARRAY_SIZE(arm64_cpu_mpidr); c++)
+		arm64_cpu_mpidr[c] = cpu_logical_map(c);
+	cpu_preserved_clean(&arm64_cpu_mpidr);
+
+	cpu_preserved_inval(&arm64_psci_conduit);
+	if (arm64_psci_conduit == SMCCC_CONDUIT_NONE) {
+		arm64_psci_conduit = arm_smccc_1_1_get_conduit();
+		cpu_preserved_clean(&arm64_psci_conduit);
+	}
+}
+EXPORT_SYMBOL_GPL(arch_cpu_preserved_early_init);
+
+void __cpu_preserved_text arch_cpu_preserved_park_finish(int cpu)
+{
+	u32 el = (read_sysreg(CurrentEL) >> 2) & 3;
+	enum arm_smccc_conduit conduit;
+
+	cpu_preserved_inval(&arm64_psci_conduit);
+	conduit = READ_ONCE(arm64_psci_conduit);
+
+	local_daif_mask();
+	write_sysreg_s(0, SYS_ICC_PMR_EL1);
+	write_sysreg_s(0, SYS_ICC_IGRPEN1_EL1);
+	isb();
+
+	if (el == 2 || conduit == SMCCC_CONDUIT_NONE)
+		conduit = (el == 2) ? SMCCC_CONDUIT_SMC : SMCCC_CONDUIT_HVC;
+
+	cpu_preserved_set_dead(cpu);
+
+	/*
+	 * Direct PSCI CPU_OFF call in preserved text without relying on
+	 * unpreserved kernel data structures or function pointers.
+	 *
+	 * x0: PSCI_0_2_FN_CPU_OFF (0x84000002)
+	 * x1: Power down state (0x00010000)
+	 */
+	if (conduit == SMCCC_CONDUIT_HVC) {
+		asm volatile("mov	x0, #0x0002\n"
+			"movk	x0, #0x8400, lsl #16\n"
+			"mov	x1, #0\n"
+			"mov	x2, #0\n"
+			"mov	x3, #0\n"
+			"mov	x4, #0\n"
+			"mov	x5, #0\n"
+			"mov	x6, #0\n"
+			"mov	x7, #0\n"
+			"hvc	#0\n"
+			:
+			:
+			: "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "memory"
+		);
+	} else {
+		asm volatile("mov	x0, #0x0002\n"
+			"movk	x0, #0x8400, lsl #16\n"
+			"mov	x1, #0\n"
+			"mov	x2, #0\n"
+			"mov	x3, #0\n"
+			"mov	x4, #0\n"
+			"mov	x5, #0\n"
+			"mov	x6, #0\n"
+			"mov	x7, #0\n"
+			"smc	#0\n"
+			:
+			:
+			: "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "memory"
+		);
+	}
+
+	while (1) {
+		wfi();
+		wfe();
+	}
+}
+
+void arch_cpu_preserved_wait_dead(int cpu)
+{
+	const struct cpu_operations *ops = get_cpu_ops(cpu);
+
+	if (ops && ops->cpu_kill)
+		ops->cpu_kill(cpu);
+}
+
diff --git a/arch/arm64/kernel/preserve_cpu.S b/arch/arm64/kernel/preserve_cpu.S
new file mode 100644
index 000000000000..c7e3cd8133f0
--- /dev/null
+++ b/arch/arm64/kernel/preserve_cpu.S
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Low-level assembly routines for ARM64 physical CPU preservation.
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+	.section .text.cpu_preserved, "ax"
+
+/*
+ * arch_cpu_preserved_park_on_stack - Switch stack and enter park loop
+ * @cpu: Logical CPU identifier (x0)
+ * @stack_top: Top of runtime allocated stack (x1)
+ */
+SYM_FUNC_START(arch_cpu_preserved_park_on_stack)
+	mov	sp, x1
+	mov	x19, x0
+	bl	cpu_preserved_park_loop
+	mov	x0, x19
+	bl	arch_cpu_preserved_park_finish
+	b	.
+SYM_FUNC_END(arch_cpu_preserved_park_on_stack)
+EXPORT_SYMBOL(arch_cpu_preserved_park_on_stack)
+
+/*
+ * __arch_cpu_preserved_dcache_clean - Clean and invalidate data cache to PoC
+ * @start: Virtual start address (x0)
+ * @end: Virtual end address (x1)
+ */
+SYM_FUNC_START(__arch_cpu_preserved_dcache_clean)
+	dsb	sy
+	raw_dcache_line_size x2, x3
+	dcache_by_myline_op_nosync civac, x0, x1, x2, x3
+	dsb	sy
+	ret
+SYM_FUNC_END(__arch_cpu_preserved_dcache_clean)
+SYM_FUNC_ALIAS(arch_cpu_preserved_dcache_clean, __arch_cpu_preserved_dcache_clean)
+SYM_FUNC_ALIAS(arch_cpu_preserved_dcache_inval, __arch_cpu_preserved_dcache_clean)
+EXPORT_SYMBOL(__arch_cpu_preserved_dcache_clean)
+EXPORT_SYMBOL(arch_cpu_preserved_dcache_clean)
+EXPORT_SYMBOL(arch_cpu_preserved_dcache_inval)
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index a61dc3016a11..43651eceb09c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -21,6 +21,7 @@
 #include <linux/mm.h>
 #include <linux/err.h>
 #include <linux/cpu.h>
+#include <linux/cpu_preserve.h>
 #include <linux/smp.h>
 #include <linux/seq_file.h>
 #include <linux/irq.h>
@@ -327,7 +328,12 @@ int __cpu_disable(void)
 
 static int op_cpu_kill(unsigned int cpu)
 {
-	const struct cpu_operations *ops = get_cpu_ops(cpu);
+	const struct cpu_operations *ops;
+
+	if (cpu_is_preserved(cpu))
+		return 0;
+
+	ops = get_cpu_ops(cpu);
 
 	/*
 	 * If we have no means of synchronising with the dying CPU, then assume
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index af1d72020976..9e809b6908a1 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -197,6 +197,7 @@ SECTIONS
 			IRQENTRY_TEXT
 			SOFTIRQENTRY_TEXT
 			ENTRY_TEXT
+			CPU_PRESERVED_TEXT
 			TEXT_TEXT
 			SCHED_TEXT
 			LOCK_TEXT
-- 
2.55.0.1082.g2b9226bbc0-goog

