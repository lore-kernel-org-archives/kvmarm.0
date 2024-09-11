Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EBC1A3030
	for <kvmarm@lists.linux.dev>; Wed, 11 Sep 2024 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726065522; cv=none; b=BILNNABWFvZ2Gs60GC63pkOV515aUszx2GbqH0l9h+XEvO+IfC5TbAPp3jEmWBd2NLWGIVmBZSDhfkCe6ZgFbyFg2u/fO6aQBglczRgX3RuTcgWqtV9/tqPSfqTmcALLHdOQ78kbN2zjc25KN3IDuj+11eR7w1l4n44O5YIQAQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726065522; c=relaxed/simple;
	bh=y69GLusekEpOSkfF6e4m3oTOacotg5cYQYvn2myDj2w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4RFY+ib34Et6TRRXHqt+KReCNotG7Y9CRA2I/DkT/wkBHyW+5li02Wl5DyotXLQ8Y1Ap0EkhKn4FYxlMPoMvVkyNL0rLDd9Ilp6THJfTEQjTX1CmHXW38Ikckm5lq6uGUMI/dYTD3toWnnOS1RhawpWgv9eRAzvFuFbrtsat9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=LIeLRz3s; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="LIeLRz3s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1726065520; x=1757601520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y7aHv3GtJyRu8tFW/46gCzZ/hJvvqzg3ZHRgqRHdqdU=;
  b=LIeLRz3sAPyO7Y9WMDYHaD3IyoPwLRe+Ta1QhWRAWRY+BoKAblG4VPKP
   TqMCiAHCF7VxoY23617uT2vE1vv55vSRr7NfCY5H4nBMTohsHkPP0HsO7
   yvfibcs11gQHX2+Fu+hmTLQE0HP0j6l87hUbolN8HKo14ZlxXFk6aChpr
   w=;
X-IronPort-AV: E=Sophos;i="6.10,220,1719878400"; 
   d="scan'208";a="658274111"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 14:37:14 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.43.254:16521]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.59:2525] with esmtp (Farcaster)
 id c7fcd23e-81e6-4810-ad32-43bfceb7c5f9; Wed, 11 Sep 2024 14:37:13 +0000 (UTC)
X-Farcaster-Flow-ID: c7fcd23e-81e6-4810-ad32-43bfceb7c5f9
Received: from EX19D007EUA004.ant.amazon.com (10.252.50.76) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 11 Sep 2024 14:37:12 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUA004.ant.amazon.com (10.252.50.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Wed, 11 Sep 2024 14:37:12 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (10.253.79.181)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34
 via Frontend Transport; Wed, 11 Sep 2024 14:37:09 +0000
From: Fares Mehanna <faresx@amazon.de>
To: 
CC: <nh-open-source@amazon.com>, Fares Mehanna <faresx@amazon.de>, "Marc
 Zyngier" <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, "Will
 Deacon" <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, =?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=
	<ptosi@google.com>, Ard Biesheuvel <ardb@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Javier Martinez Canillas <javierm@redhat.com>, "Arnd
 Bergmann" <arnd@arndb.de>, Fuad Tabba <tabba@google.com>, Mark Brown
	<broonie@kernel.org>, Joey Gouly <joey.gouly@arm.com>, Kristina Martsenko
	<kristina.martsenko@arm.com>, Randy Dunlap <rdunlap@infradead.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>, "David
 Hildenbrand" <david@redhat.com>, Roman Kagan <rkagan@amazon.de>, "moderated
 list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)"
	<linux-arm-kernel@lists.infradead.org>, "open list:KERNEL VIRTUAL MACHINE FOR
 ARM64 (KVM/arm64)" <kvmarm@lists.linux.dev>, open list
	<linux-kernel@vger.kernel.org>, "open list:MEMORY MANAGEMENT"
	<linux-mm@kvack.org>
Subject: [RFC PATCH 5/7] arm64: KVM: Allocate vCPU gp-regs dynamically on VHE and KERNEL_SECRETMEM enabled systems
Date: Wed, 11 Sep 2024 14:34:04 +0000
Message-ID: <20240911143421.85612-6-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240911143421.85612-1-faresx@amazon.de>
References: <20240911143421.85612-1-faresx@amazon.de>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To allocate the vCPU gp-regs using secret memory, we need to dynamically
allocate the vCPU gp-regs first.

This is tricky with NVHE (Non-Virtualization Host Extensions) since it will
require adjusting the virtual address on every access. With a large shared
codebase between the OS and the hypervisor, it would be cumbersome to duplicate
the code with one version using `kern_hyp_va()`.

To avoid this issue, and since the secret memory feature will not be enabled on
NVHE systems, we're introducing the following changes:
1. Maintain a `struct user_pt_regs regs_storage` in the vCPU context struct as a
 fallback storage for the vCPU gp-regs.
2. Introduce a pointer `struct user_pt_regs *regs` in the vCPU context struct to
 hold the dynamically allocated vCPU gp-regs.

If we are on an NVHE system or a VHE (Virtualization Host Extensions) system
that doesn't support `KERNEL_SECRETMEM`, we will use `ctxt_storage`. Accessing
the context in this case will not require a de-reference operation.

If we are on a VHE system with support for `KERNEL_SECRETMEM`, we will use the
`regs` pointer. In this case, we will add one de-reference operation every time
the vCPU gp-reg is accessed.

Accessing the gp-regs embedded in the vCPU context without de-reference is done
as:
add     \regs, \ctxt, #CPU_USER_PT_REGS_STRG

Accessing the dynamically allocated gp-regs with de-reference is done as:
ldr     \regs, [\ctxt, #CPU_USER_PT_REGS]

By default, we are using the first version. If we are booting on a system that
supports VHE and `KERNEL_SECRETMEM`, we switch to the second version.

We are also allocating the needed gp-regs allocations for vCPU, kvm_hyp_ctxt and
kvm_host_data structs when needed.

Signed-off-by: Fares Mehanna <faresx@amazon.de>
---
 arch/arm64/include/asm/kvm_asm.h  |  4 +-
 arch/arm64/include/asm/kvm_host.h | 24 +++++++++++-
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kernel/image-vars.h    |  1 +
 arch/arm64/kvm/arm.c              | 63 ++++++++++++++++++++++++++++++-
 arch/arm64/kvm/va_layout.c        | 23 +++++++++++
 6 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index fa4fb642a5f5..1d6de0806dbd 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -314,7 +314,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr, u64 elr_virt,
 .endm
 
 .macro get_ctxt_gp_regs ctxt, regs
-	add	\regs, \ctxt, #CPU_USER_PT_REGS
+alternative_cb ARM64_HAS_VIRT_HOST_EXTN, kvm_update_ctxt_gp_regs
+	add	\regs, \ctxt, #CPU_USER_PT_REGS_STRG
+alternative_cb_end
 .endm
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 31cbd62a5d06..23a10178d1b0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -541,7 +541,9 @@ struct kvm_sysreg_masks {
 };
 
 struct kvm_cpu_context {
-	struct user_pt_regs regs;	/* sp = sp_el0 */
+	struct user_pt_regs *regs;	/* sp = sp_el0 */
+	struct user_pt_regs regs_storage;
+	struct secretmem_area *regs_area;
 
 	u64	spsr_abt;
 	u64	spsr_und;
@@ -946,7 +948,25 @@ struct kvm_vcpu_arch {
 #define vcpu_clear_on_unsupported_cpu(vcpu)				\
 	vcpu_clear_flag(vcpu, ON_UNSUPPORTED_CPU)
 
-#define ctxt_gp_regs(ctxt)	(&(ctxt)->regs)
+/* Static allocation is used if NVHE-host or if KERNEL_SECRETMEM is not enabled */
+static __inline bool kvm_use_dynamic_regs(void)
+{
+#ifndef CONFIG_KERNEL_SECRETMEM
+	return false;
+#endif
+	return cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN);
+}
+
+static __always_inline struct user_pt_regs *ctxt_gp_regs(const struct kvm_cpu_context *ctxt)
+{
+	struct user_pt_regs *regs = (void *) ctxt;
+	asm volatile(ALTERNATIVE_CB("add %0, %0, %1\n",
+				    ARM64_HAS_VIRT_HOST_EXTN,
+				    kvm_update_ctxt_gp_regs)
+		     : "+r" (regs)
+		     : "I" (offsetof(struct kvm_cpu_context, regs_storage)));
+	return regs;
+}
 #define vcpu_gp_regs(v)		(ctxt_gp_regs(&(v)->arch.ctxt))
 
 /*
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 27de1dddb0ab..275d480f5e65 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -128,6 +128,7 @@ int main(void)
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
+  DEFINE(CPU_USER_PT_REGS_STRG, offsetof(struct kvm_cpu_context, regs_storage));
   DEFINE(CPU_ELR_EL2,		offsetof(struct kvm_cpu_context, sys_regs[ELR_EL2]));
   DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
   DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8f5422ed1b75..e3bb626e299c 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -86,6 +86,7 @@ KVM_NVHE_ALIAS(kvm_patch_vector_branch);
 KVM_NVHE_ALIAS(kvm_update_va_mask);
 KVM_NVHE_ALIAS(kvm_get_kimage_voffset);
 KVM_NVHE_ALIAS(kvm_compute_final_ctr_el0);
+KVM_NVHE_ALIAS(kvm_update_ctxt_gp_regs);
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_iter);
 KVM_NVHE_ALIAS(spectre_bhb_patch_loop_mitigation_enable);
 KVM_NVHE_ALIAS(spectre_bhb_patch_wa3);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9bef7638342e..78c562a060de 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
+#include <linux/secretmem.h>
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
@@ -452,6 +453,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
+	unsigned long pages_needed;
 	int err;
 
 	spin_lock_init(&vcpu->arch.mp_state_lock);
@@ -469,6 +471,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
 
+	if (kvm_use_dynamic_regs()) {
+		pages_needed = (sizeof(*vcpu_gp_regs(vcpu)) + PAGE_SIZE - 1) / PAGE_SIZE;
+		vcpu->arch.ctxt.regs_area = secretmem_allocate_pages(fls(pages_needed - 1));
+		if (!vcpu->arch.ctxt.regs_area)
+			return -ENOMEM;
+		vcpu->arch.ctxt.regs = vcpu->arch.ctxt.regs_area->ptr;
+	}
+
 	/* Set up the timer */
 	kvm_timer_vcpu_init(vcpu);
 
@@ -489,9 +499,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
-		return err;
+		goto free_vcpu_ctxt;
 
 	return kvm_share_hyp(vcpu, vcpu + 1);
+
+free_vcpu_ctxt:
+	if (kvm_use_dynamic_regs())
+		secretmem_release_pages(vcpu->arch.ctxt.regs_area);
+	return err;
 }
 
 void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
@@ -508,6 +523,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_pmu_vcpu_destroy(vcpu);
 	kvm_vgic_vcpu_destroy(vcpu);
 	kvm_arm_vcpu_destroy(vcpu);
+
+	if (kvm_use_dynamic_regs())
+		secretmem_release_pages(vcpu->arch.ctxt.regs_area);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -2683,6 +2701,45 @@ static int __init init_hyp_mode(void)
 	return err;
 }
 
+static int init_hyp_hve_mode(void)
+{
+	int cpu;
+	int err = 0;
+
+	if (!kvm_use_dynamic_regs())
+		return 0;
+
+	/* Allocate gp-regs */
+	for_each_possible_cpu(cpu) {
+		void *hyp_ctxt_regs;
+		void *kvm_host_data_regs;
+
+		hyp_ctxt_regs = kzalloc(sizeof(struct user_pt_regs), GFP_KERNEL);
+		if (!hyp_ctxt_regs) {
+			err = -ENOMEM;
+			goto free_regs;
+		}
+		per_cpu(kvm_hyp_ctxt, cpu).regs = hyp_ctxt_regs;
+
+		kvm_host_data_regs = kzalloc(sizeof(struct user_pt_regs), GFP_KERNEL);
+		if (!kvm_host_data_regs) {
+			err = -ENOMEM;
+			goto free_regs;
+		}
+		per_cpu(kvm_host_data, cpu).host_ctxt.regs = kvm_host_data_regs;
+	}
+
+	return 0;
+
+free_regs:
+	for_each_possible_cpu(cpu) {
+		kfree(per_cpu(kvm_hyp_ctxt, cpu).regs);
+		kfree(per_cpu(kvm_host_data, cpu).host_ctxt.regs);
+	}
+
+	return err;
+}
+
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 {
 	struct kvm_vcpu *vcpu = NULL;
@@ -2806,6 +2863,10 @@ static __init int kvm_arm_init(void)
 		err = init_hyp_mode();
 		if (err)
 			goto out_err;
+	} else {
+		err = init_hyp_hve_mode();
+		if (err)
+			goto out_err;
 	}
 
 	err = kvm_init_vector_slots();
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 91b22a014610..fcef7e89d042 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -185,6 +185,29 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 	}
 }
 
+void __init kvm_update_ctxt_gp_regs(struct alt_instr *alt,
+				    __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	u32 rd, rn, imm, insn, oinsn;
+
+	BUG_ON(nr_inst != 1);
+
+	if (!kvm_use_dynamic_regs())
+		return;
+
+	oinsn = le32_to_cpu(origptr[0]);
+	rd = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RD, oinsn);
+	rn = aarch64_insn_decode_register(AARCH64_INSN_REGTYPE_RN, oinsn);
+	imm = offsetof(struct kvm_cpu_context, regs);
+
+	insn = aarch64_insn_gen_load_store_imm(rd, rn, imm,
+					       AARCH64_INSN_SIZE_64,
+					       AARCH64_INSN_LDST_LOAD_IMM_OFFSET);
+	BUG_ON(insn == AARCH64_BREAK_FAULT);
+
+	updptr[0] = cpu_to_le32(insn);
+}
+
 void kvm_patch_vector_branch(struct alt_instr *alt,
 			     __le32 *origptr, __le32 *updptr, int nr_inst)
 {
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

