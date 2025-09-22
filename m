Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB872F5322
	for <kvmarm@lists.linux.dev>; Mon, 22 Sep 2025 20:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.12.53.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758572706; cv=none; b=afFOIm5bprhIklHgshDDfIxqAl2dUpkapnqTAkomNRYAHRk5C8Kg5jcXiwUrN89SE0I7g/iZtF6kP1A/xkWdyJUFBVt0iSSRtb1wsvZNdw3pM48rBbutuA15AqY0korGsbErAwbg436l0tfWqd8NRamAT58ZpoklTdJ/PAi5Wyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758572706; c=relaxed/simple;
	bh=Sx6cjeuAPMlzsng4URO2TN05GPcjM1qRc0nWPhgjd4A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TIc3rVUDS+FiWZXSZCzWeam3rK96uBoIoj3B7+3eFHFYNX6SJhEI9t9kyKmp28Uhk92sOlcO3cWrkzvH2VnytyoficjkHfoIk/I50hGNAk74qeEpVRADS70UVMA5XMEZtrIF8FJG5tppC5TAcPajeq5xSFsMzv72rNsDUU502YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=PAZt68rk; arc=none smtp.client-ip=52.12.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="PAZt68rk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758572705; x=1790108705;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TKbiOyVBMpKh2bBgW/G0AuyVP7+bWtboi+S5aX+3tTM=;
  b=PAZt68rks4pahIjArQkH8+aq1CNsKvrbMBiZj9rH9BIA+7eOuzxxmRyh
   cg6M60jzt5M5LNMVKd+W86O7OTNQ4uQBOcFkjuYfIajdqzD7d+EzeW637
   cjo/vEuRQ09WAW4iFtoHCdR1LLfi/6mJ75I0SyXubOblcLZqROe2f/uNz
   uTCM0iT5kbkv4lpQQ0SPXWrzCysdMXXIfkeE7XzCYkUh1KZ3wGutLk6Pv
   rHmlL7uyCV3ySZb9C2FoCL1lQD5AHmZ/ob7xpps72tPlgz5Wk0MelKeGd
   LNgxkDkRzH0jFx7/ChfhRcSLaHI4EEy+RP8/15cyOeb6EzZiASIVQYrUd
   w==;
X-CSE-ConnectionGUID: LfYNyVMxT/ShDu5KS4Chkg==
X-CSE-MsgGUID: ZnyBiV3RQKqtvE8B7j9C0Q==
X-IronPort-AV: E=Sophos;i="6.18,286,1751241600"; 
   d="scan'208";a="3396962"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 20:25:04 +0000
Received: from EX19MTAUWA002.ant.amazon.com [10.0.21.151:45178]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.38.121:2525] with esmtp (Farcaster)
 id dc8e568d-8f29-43b0-8f67-dc1f42bfa638; Mon, 22 Sep 2025 20:24:59 +0000 (UTC)
X-Farcaster-Flow-ID: dc8e568d-8f29-43b0-8f67-dc1f42bfa638
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 20:24:59 +0000
Received: from c889f3b3a561.amazon.com (10.106.101.18) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 20:24:58 +0000
From: Priscilla Lam <prl@amazon.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <joey.gouly@arm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>
CC: <dwmw@amazon.co.uk>, <gurugubs@amazon.com>, <christoffer.dall@arm.com>,
	<graf@amazon.com>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: arm64: Implement KVM_TRANSLATE ioctl for arm64
Date: Mon, 22 Sep 2025 13:24:52 -0700
Message-ID: <20250922202452.45810-1-prl@amazon.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D046UWA003.ant.amazon.com (10.13.139.18) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

There is a KVM_TRANSLATE ioctl for x86 to translate a GVA
(guest virtual address) to a GPA (guest physical address) in EL1
which is not yet implemented for arm64.

Implement KVM_TRANSLATE on arm64 for both configurations that
support and do not support VHE. The VHE path uses the AT
instruction directly while the non-VHE implementation wraps the
AT call in a hypercall to allow for its execution in EL2. Add
selftest that tests the ioctl in both configurations.

Signed-off-by: Priscilla Lam <prl@amazon.com>
---
 arch/arm64/include/asm/kvm_asm.h              |   2 +
 arch/arm64/kvm/guest.c                        |  89 ++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/Makefile              |   3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  10 ++
 arch/arm64/kvm/hyp/nvhe/translate.c           |  84 ++++++++++++++
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/translate.c | 107 ++++++++++++++++++
 7 files changed, 292 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/translate.c
 create mode 100644 tools/testing/selftests/kvm/arm64/translate.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index bec227f9500a..56ecf4691650 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -87,6 +87,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___kvm_hyp_translate,
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
@@ -289,6 +290,7 @@ asmlinkage void __noreturn hyp_panic_bad_stack(void);
 asmlinkage void kvm_unexpected_el2_exception(void);
 struct kvm_cpu_context;
 void handle_trap(struct kvm_cpu_context *host_ctxt);
+extern u64 __kvm_hyp_translate(struct kvm_vcpu *vcpu, u64 gva);
 asmlinkage void __noreturn __kvm_host_psci_cpu_entry(bool is_cpu_on);
 void __noreturn __pkvm_init_finalise(void);
 void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 16ba5e9ac86c..180ea1df66cc 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <asm/fpsimd.h>
 #include <asm/kvm.h>
+#include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_nested.h>
 #include <asm/sigcontext.h>
@@ -932,10 +933,92 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	return -EINVAL;
 }
 
-int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
-				  struct kvm_translation *tr)
+static inline uint64_t par_to_ipa(uint64_t par, uint64_t va)
 {
-	return -EINVAL;
+	uint64_t offset = va & ((1ULL << PAGE_SHIFT) - 1);
+
+	return (par & GENMASK_ULL(51, 12)) | offset;
+}
+
+static int kvm_translate_vhe(struct kvm_vcpu *vcpu, struct kvm_translation *tr)
+{
+	unsigned long flags;
+	uint64_t hcr_old, hcr_new, par;
+	const uint64_t gva = tr->linear_address;
+
+	preempt_disable();
+	local_irq_save(flags);
+
+	/* Ensure we're in the expected VHE regime and enable S2 so PAR returns IPA. */
+	hcr_old = read_sysreg(hcr_el2);
+	hcr_new = hcr_old | HCR_E2H | HCR_VM;
+	hcr_new &= ~HCR_TGE;
+	write_sysreg(hcr_new, hcr_el2);
+	isb();
+
+	/* Load guest EL1 S1 context into *_EL12 (do not write into _EL1). */
+	write_sysreg_s(vcpu_read_sys_reg(vcpu, TTBR0_EL1), SYS_TTBR0_EL12);
+	write_sysreg_s(vcpu_read_sys_reg(vcpu, TTBR1_EL1), SYS_TTBR1_EL12);
+	write_sysreg_s(vcpu_read_sys_reg(vcpu, TCR_EL1), SYS_TCR_EL12);
+	write_sysreg_s(vcpu_read_sys_reg(vcpu, MAIR_EL1), SYS_MAIR_EL12);
+	write_sysreg_s(vcpu_read_sys_reg(vcpu, SCTLR_EL1), SYS_SCTLR_EL12);
+
+	/* Check address read */
+	asm volatile("at s1e1r, %0" :: "r"(gva));
+	isb();
+
+	par = read_sysreg(par_el1);
+	if (!(par & 1)) {
+		tr->valid = true;
+		tr->physical_address = par_to_ipa(par, gva);
+	}
+
+	/* Check address write */
+	asm volatile("at s1e1w, %0" :: "r"(gva));
+	isb();
+
+	par = read_sysreg(par_el1);
+
+	if (!(par & 1)) {
+		tr->valid = true;
+		tr->writeable = true;
+		tr->physical_address = par_to_ipa(par, gva);
+	}
+
+	/* Restore HCR_EL2 and exit */
+	write_sysreg(hcr_old, hcr_el2);
+	isb();
+	local_irq_restore(flags);
+	preempt_enable();
+
+	return 0;
+}
+
+static int kvm_translate_nvhe(struct kvm_vcpu *vcpu, struct kvm_translation *tr)
+{
+	u64 ret;
+
+	preempt_disable();
+	local_irq_disable();
+	ret = kvm_call_hyp_nvhe(__kvm_hyp_translate, vcpu, tr->linear_address);
+	local_irq_enable();
+	preempt_enable();
+
+	/* Unpack result: IPA in bits 63:8, valid in bit 4, writeable in bit 0 */
+	tr->physical_address = ret >> 8;
+	tr->valid = !!(ret & (1ULL << 4));
+	tr->writeable = !!(ret & 1ULL);
+	tr->usermode = 0;
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu, struct kvm_translation *tr)
+{
+	if (has_vhe())
+		return kvm_translate_vhe(vcpu, tr);
+	else
+		return kvm_translate_nvhe(vcpu, tr);
 }
 
 /**
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 0b0a68b663d4..bcbd4e5125b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -24,7 +24,8 @@ CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
-	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
+	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o \
+	 translate.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3206b2c07f82..a52cf002822c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -573,6 +573,15 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
 }
 
+static void handle___kvm_hyp_translate(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
+	DECLARE_REG(u64, gva, host_ctxt, 2);
+
+	host_vcpu = kern_hyp_va(host_vcpu);
+	cpu_reg(host_ctxt, 1) = __kvm_hyp_translate(host_vcpu, gva);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -612,6 +621,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__kvm_hyp_translate),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/translate.c b/arch/arm64/kvm/hyp/nvhe/translate.c
new file mode 100644
index 000000000000..239a095a015d
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/translate.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2025 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Author: Priscilla Lam <prl@amazon.com>
+ */
+
+#include <asm/sysreg.h>
+#include <hyp/sysreg-sr.h>
+#include <nvhe/mem_protect.h>
+
+static __always_inline u64 par_to_ipa(u64 par, u64 va)
+{
+	u64 offset = va & ((1ULL << PAGE_SHIFT) - 1);
+
+	return (par & GENMASK_ULL(51, 12)) | offset;
+}
+
+/**
+ * __kvm_hyp_translate - hypercall that translates a GVA to GPA when VHE is not enabled or available
+ * @vcpu: the vCPU pointer
+ * @gva: the guest virtual address
+ *
+ * This returns the result in a packed integer. The GPA if successful will be in bits 63:8, the
+ * validity in bit 4, and if the address is writeable in bit 0.
+ */
+u64 __kvm_hyp_translate(struct kvm_vcpu *vcpu, u64 gva)
+{
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_cpu_context *guest_ctxt;
+	struct kvm_s2_mmu *mmu;
+
+	u64 hcr_old = read_sysreg(hcr_el2);
+	u64 par = 0;
+	u64 gpa = 0;
+	bool valid = false;
+	bool writeable = false;
+
+	host_ctxt = host_data_ptr(host_ctxt);
+	host_ctxt->__hyp_running_vcpu = vcpu;
+	guest_ctxt = &vcpu->arch.ctxt;
+
+	__sysreg_save_state_nvhe(host_ctxt);
+	__debug_save_host_buffers_nvhe(vcpu);
+
+	dsb(nsh);
+
+	__sysreg_restore_state_nvhe(guest_ctxt);
+
+	mmu = kern_hyp_va(vcpu->arch.hw_mmu);
+	__load_stage2(mmu, kern_hyp_va(mmu->arch));
+
+	write_sysreg((hcr_old | HCR_E2H | HCR_VM) & ~HCR_TGE, hcr_el2);
+	isb();
+
+	asm volatile("at s1e1r, %0" :: "r"(gva));
+	isb();
+
+	par = read_sysreg(par_el1);
+
+	if (!(par & 1)) {
+		gpa = par_to_ipa(par, gva);
+		valid = true;
+	}
+
+	if (valid) {
+		asm volatile("at s1e1w, %0" :: "r"(gva));
+		isb();
+
+		par = read_sysreg(par_el1);
+		if (!(par & 1))
+			writeable = true;
+	}
+
+	write_sysreg(hcr_old, hcr_el2);
+	isb();
+
+	__load_host_stage2();
+	__sysreg_restore_state_nvhe(host_ctxt);
+	__debug_restore_host_buffers_nvhe(vcpu);
+	host_ctxt->__hyp_running_vcpu = NULL;
+
+	// Pack result: GPA in bits 63:8, valid in bit 4, writeable in bit 0
+	return (gpa << 8) | (valid ? (1ULL << 4) : 0) | (writeable ? 1ULL : 0);
+}
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 41b40c676d7f..894b1b888ce4 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -163,6 +163,7 @@ TEST_GEN_PROGS_arm64 += arm64/page_fault_test
 TEST_GEN_PROGS_arm64 += arm64/psci_test
 TEST_GEN_PROGS_arm64 += arm64/set_id_regs
 TEST_GEN_PROGS_arm64 += arm64/smccc_filter
+TEST_GEN_PROGS_arm64 += arm64/translate
 TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 += arm64/vgic_init
 TEST_GEN_PROGS_arm64 += arm64/vgic_irq
diff --git a/tools/testing/selftests/kvm/arm64/translate.c b/tools/testing/selftests/kvm/arm64/translate.c
new file mode 100644
index 000000000000..5cdc975ae52a
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/translate.c
@@ -0,0 +1,107 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * translate: Test the KVM_TRANSLATE ioctl on AArch64 by setting up
+ * guest page table mappings and verifying that the ioctl correctly
+ * translates guest virtual addresses to guest physical addresses.
+ */
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+#define GUEST_TEST_GVA1		0x400000
+#define GUEST_TEST_GVA2		0x500000
+#define GUEST_UNMAPPED_GVA	0x600000
+
+/* AArch64 page table entry flags */
+#define PTE_RDONLY		(1ULL << 7)	/* AP[2] - Read-only */
+
+static void guest_code(void)
+{
+	GUEST_DONE();
+}
+
+/*
+ * Create a read-only page mapping by first creating a normal mapping
+ * and then modifying the PTE to add the read-only flag.
+ */
+static void virt_pg_map_readonly(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
+{
+	uint64_t *ptep;
+
+	/* First create a normal read-write mapping */
+	virt_pg_map(vm, vaddr, paddr);
+
+	/* Now find the PTE and modify it to be read-only */
+	ptep = virt_get_pte_hva(vm, vaddr);
+	TEST_ASSERT(ptep, "Failed to get PTE for GVA 0x%lx", vaddr);
+
+	/* Set the read-only bit in the PTE */
+	*ptep |= PTE_RDONLY;
+}
+
+int main(void)
+{
+	struct kvm_translation tr;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_vaddr_t gva1, gva2;
+	vm_paddr_t gpa1, gpa2;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	/* Set up two different GVA to GPA mappings with different permissions. */
+	gva1 = GUEST_TEST_GVA1;
+	gpa1 = vm_phy_page_alloc(vm, vm->page_size, vm->memslots[MEM_REGION_TEST_DATA]);
+	printf("Allocated GPA1: 0x%lx for GVA1: 0x%lx\n", (unsigned long)gpa1, (unsigned long)gva1);
+	virt_pg_map(vm, gva1, gpa1);  /* Read-write mapping */
+
+	gva2 = GUEST_TEST_GVA2;
+	gpa2 = vm_phy_page_alloc(vm, vm->page_size, vm->memslots[MEM_REGION_TEST_DATA]);
+	printf("Allocated GPA2: 0x%lx for GVA2: 0x%lx\n", (unsigned long)gpa2, (unsigned long)gva2);
+	virt_pg_map_readonly(vm, gva2, gpa2);  /* Read-only mapping */
+
+	/*
+	 * The vCPU must be run at least once to initialize the system
+	 * registers needed for guest address translation.
+	 */
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	/* Verify the first mapping (read-write) translates correctly. */
+	memset(&tr, 0, sizeof(tr));
+	tr.linear_address = gva1;
+	vcpu_ioctl(vcpu, KVM_TRANSLATE, &tr);
+
+	printf("RW mapping: GVA=0x%lx -> GPA=0x%llx, valid=%d, writeable=%d\n",
+	       (unsigned long)gva1, (unsigned long long)tr.physical_address,
+	       tr.valid, tr.writeable);
+	TEST_ASSERT(tr.valid, "Translation should succeed for mapped GVA");
+	TEST_ASSERT_EQ(tr.physical_address, gpa1);
+	TEST_ASSERT(tr.writeable, "Read-write GVA should be writeable");
+
+	/* Verify the second mapping (read-only) translates correctly. */
+	memset(&tr, 0, sizeof(tr));
+	tr.linear_address = gva2;
+	vcpu_ioctl(vcpu, KVM_TRANSLATE, &tr);
+
+	printf("RO mapping: GVA=0x%lx -> GPA=0x%llx, valid=%d, writeable=%d\n",
+	       (unsigned long)gva2, (unsigned long long)tr.physical_address,
+	       tr.valid, tr.writeable);
+	TEST_ASSERT(tr.valid, "Translation should succeed for mapped GVA");
+	TEST_ASSERT_EQ(tr.physical_address, gpa2);
+	TEST_ASSERT(!tr.writeable, "Read-only GVA should not be writeable");
+
+	/* Verify that an unmapped GVA is reported as invalid. */
+	memset(&tr, 0, sizeof(tr));
+	tr.linear_address = GUEST_UNMAPPED_GVA;
+	vcpu_ioctl(vcpu, KVM_TRANSLATE, &tr);
+
+	printf("Unmapped: GVA=0x%lx -> GPA=0x%llx, valid=%d, writeable=%d\n",
+	       (unsigned long)GUEST_UNMAPPED_GVA, (unsigned long long)tr.physical_address,
+	       tr.valid, tr.writeable);
+	TEST_ASSERT(!tr.valid, "Translation should fail for unmapped GVA");
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.43.0

