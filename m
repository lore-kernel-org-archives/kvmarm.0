Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8757C3FE660;
	Thu, 16 Jul 2026 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211014; cv=none; b=Ih21oefds3JochX5juTPAhpljrerNansluZeVKmJy5EQrZxPvlKZcM+xaK79QLSFf+wapBt/ngVivAXTEEIyuVtGtCM2pUHxlWBDKiidbBTwk/rnjYYz5Y6JB01SX9iYZInZ7knrGl2pqFHjchnfgAUeeIbw1w6urdcZBmlRY88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211014; c=relaxed/simple;
	bh=nQgX0gW3D0MxlqQj8hNSakZmQWk5+JlEU7hGmfosL0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhJlI84sPAX9mlzfvrvdpiKnPP/DD8VEXKB3UF3prgzFK0vnHdOvWzkqbpcnmQD6bC9U2h5G1l6W8Sh7W/Nr18g+NpdaQwtPjvw4SM/BS2wfwQ8HPuRdZs3qfeJhAf/K9ivs9iqChpMVDYHxZJoxoWSbJFHbn7PGb0A6ZHZWHW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E48SCxK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E48SCxK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930CC1F000E9;
	Thu, 16 Jul 2026 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784211012;
	bh=i+9aCree0QE72tWNWq9iGnJd39ScqLp1k1EqLmo1VjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E48SCxK9zTeDNz2D3T0ERHGZStkep9q6e+Qz3wT4CYaGv+98AES7pXM6Emxp08MuB
	 Dba+LALbMFCnGsnMJNy7WRVGvtL/cF9zSteRJwKQSAzrsF1/rzxiBDTmMOD+RCl2gE
	 BgQnE/Ltzeb4jyq5mJ9AV3zlAAU0ZoIva5aVQ3pDnCIy7VMsfpSbU9t4fQA8Dz0zEc
	 wdQXzDQQ9k0EVfRR1vnOScuki5XuJ54ThzaI94BwZ3NWDsVRKlXiV8yYCkCflvxCWU
	 0hZwmCnfKfGeCLJV8U6OmSmKK3QiAlhifsYNlbH7niFpfbDndGR6qOkdhbHkFPfCft
	 ijZnfrwp8sbKA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [RFC PATCH 5/5] KVM: arm64: Use TTBR1_EL2 for hVHE runtime mappings
Date: Thu, 16 Jul 2026 19:39:36 +0530
Message-ID: <20260716140936.4003182-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
References: <20260716140936.4003182-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hVHE currently disables TTBR1_EL2 and places both the identity mapping
and runtime hyp mappings in TTBR0_EL2. This unnecessarily retains the
legacy nVHE VA layout even though hVHE can use canonical kernel-image
addresses through the EL2&0 translation regime.

Place hVHE runtime mappings in TTBR1_EL2 and reserve TTBR0_EL2 for the
identity mapping used during MMU and page-table transitions. Select this
layout based on hVHE support independently of protected mode, while
retaining the existing TTBR0-only layout for nVHE and protected nVHE.

Keep hyp symbols at their linked kernel-image VAs, disable the legacy VA
relocations for hVHE, and configure TCR_EL2 for both translation ranges.
Allocate separate runtime and idmap page tables during initial setup and
pKVM finalization, pass both roots through the per-CPU initialization
parameters, and install both during page-table transitions.

Add support for walking canonical TTBR1 hyp page tables, including
handling the wrap at the top of the address space. Use this when fixing
page-table reference counts and destroying hyp page tables.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h     |  3 +-
 arch/arm64/include/asm/kvm_hyp.h     |  4 +-
 arch/arm64/include/asm/kvm_mmu.h     | 46 ++++++++++++++++++---
 arch/arm64/include/asm/kvm_pgtable.h | 27 ++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  3 ++
 arch/arm64/kernel/asm-offsets.c      |  5 ++-
 arch/arm64/kvm/arm.c                 | 47 +++++++++++++--------
 arch/arm64/kvm/hyp/include/nvhe/mm.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-init.S   | 29 ++++++++++---
 arch/arm64/kvm/hyp/nvhe/mm.c         | 24 +++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c      | 35 ++++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c         | 62 +++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 | 57 +++++++++++++++++++++++--
 arch/arm64/kvm/pkvm.c                |  3 ++
 arch/arm64/kvm/va_layout.c           | 32 +++++++++++---
 15 files changed, 328 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6e0cc007bfe1..e42baadf7990 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -210,7 +210,8 @@ struct kvm_nvhe_init_params {
 	unsigned long tpidr_el2;
 	unsigned long stack_hyp_va;
 	unsigned long stack_pa;
-	phys_addr_t pgd_pa;
+	phys_addr_t ttbr0_pgd_pa;
+	phys_addr_t ttbr1_pgd_pa;
 	unsigned long hcr_el2;
 	unsigned long vttbr;
 	unsigned long vtcr;
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 4974492744cc..5cc196f84958 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -131,8 +131,8 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t pgd, unsigned long sp,
-		void (*fn)(void));
+void __pkvm_init_switch_pgd(phys_addr_t ttbr0, phys_addr_t ttbr1,
+			    unsigned long sp, void (*fn)(void));
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 #endif
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index bcc8e28985f7..30ac5cecaa93 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -105,6 +105,7 @@ alternative_cb_end
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
 #include <asm/kvm_nested.h>
+#include <asm/virt.h>
 
 void kvm_update_va_mask(struct alt_instr *alt,
 			__le32 *origptr, __le32 *updptr, int nr_inst);
@@ -112,13 +113,28 @@ void kvm_compute_layout(void);
 u32 kvm_hyp_va_bits(void);
 void kvm_apply_hyp_relocations(void);
 
+static __always_inline bool kvm_hyp_init_uses_ttbr1(void)
+{
+	BUILD_BUG_ON(__is_defined(__KVM_NVHE_HYPERVISOR__));
+
+	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
+}
+
+static __always_inline bool kvm_hyp_uses_ttbr1(void)
+{
+	return cpus_have_final_cap(ARM64_KVM_HVHE);
+}
+
 /**
  * kvm_hyp_kimg_kaddr - Select the kernel address used for an EL2 mapping
  * @ptr: Address within the kernel image
  *
- * Return @ptr when EL2 uses the kernel-image address directly, as with
- * VHE. Otherwise return the corresponding linear-map alias used as input
- * to the legacy nVHE VA conversion.
+ * Return @ptr when EL2 uses the kernel-image address directly, as with VHE
+ * or hVHE TTBR1. Otherwise return the corresponding linear-map alias used
+ * as input to the legacy nVHE VA conversion.
+ *
+ * This helper relies on finalized CPU capabilities and must not be used from
+ * earlier boot stages.
  *
  * Return: A kernel address suitable as the basis for an EL2 virtual address.
  */
@@ -126,10 +142,11 @@ static __always_inline void *kvm_hyp_kimg_kaddr(void *ptr)
 {
 	/*
 	 * With VHE, the host runs at EL2 using the kernel mapping, so
-	 * kernel-image VAs need no translation.
-	 * Only legacy nVHE requires a linear-map alias.
+	 * kernel-image VAs need no translation. hVHE similarly retains
+	 * kernel-image VAs in its TTBR1 EL2 mapping. Only legacy nVHE
+	 * requires a linear-map alias.
 	 */
-	if (is_kernel_in_hyp_mode())
+	if (is_kernel_in_hyp_mode() || kvm_hyp_uses_ttbr1())
 		return ptr;
 
 	return lm_alias(ptr);
@@ -137,6 +154,22 @@ static __always_inline void *kvm_hyp_kimg_kaddr(void *ptr)
 
 #define __hyp_linear_pa(x) (((phys_addr_t)(x)) + hyp_physvirt_offset)
 #define __hyp_symbol_pa(x) (((phys_addr_t)(x)) + hyp_symbol_physvirt_offset)
+
+static __always_inline unsigned long kvm_hyp_ttbr1_private_start(void)
+{
+	return PAGE_ALIGN((unsigned long)__hyp_bss_end);
+}
+
+static __always_inline unsigned long kvm_hyp_ttbr1_private_end(void)
+{
+	return VMALLOC_END;
+}
+
+static __always_inline unsigned long kvm_hyp_ttbr1_vmemmap_base(void)
+{
+	return kvm_hyp_ttbr1_private_start() + SZ_1G;
+}
+
 /*
  * Convert a kernel VA into a HYP VA.
  *
@@ -228,6 +261,7 @@ int kvm_handle_guest_sea(struct kvm_vcpu *vcpu);
 int kvm_handle_guest_abort(struct kvm_vcpu *vcpu);
 
 phys_addr_t kvm_mmu_get_httbr(void);
+phys_addr_t kvm_mmu_get_hyp_ttbr1(void);
 phys_addr_t kvm_get_idmap_vector(void);
 int __init kvm_mmu_init(u32 hyp_va_bits);
 
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..1d51dcaaac0d 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -255,6 +255,14 @@ enum kvm_pgtable_stage2_flags {
 	KVM_PGTABLE_S2_AS_S1			= BIT(1),
 };
 
+/**
+ * enum kvm_pgtable_hyp_flags - Hypervisor page-table flags.
+ * @KVM_PGTABLE_HYP_TTBR1:	Walk TTBR1 canonical virtual addresses.
+ */
+enum kvm_pgtable_hyp_flags {
+	KVM_PGTABLE_HYP_TTBR1			= BIT(0),
+};
+
 /**
  * enum kvm_pgtable_prot - Page-table permissions and attributes.
  * @KVM_PGTABLE_PROT_UX:	Unprivileged execute permission.
@@ -443,6 +451,7 @@ static inline bool kvm_pgtable_walk_lock_held(void)
  * @start_level:	Level at which the page-table walk starts.
  * @pgd:		Pointer to the first top-level entry of the page-table.
  * @mm_ops:		Memory management callbacks.
+ * @hyp_flags:		Hypervisor page-table flags.
  * @mmu:		Stage-2 KVM MMU struct. Unused for stage-1 page-tables.
  * @flags:		Stage-2 page-table flags.
  * @force_pte_cb:	Function that returns true if page level mappings must
@@ -457,6 +466,9 @@ struct kvm_pgtable {
 			kvm_pteref_t				pgd;
 			struct kvm_pgtable_mm_ops		*mm_ops;
 
+			/* Hyp only */
+			enum kvm_pgtable_hyp_flags		hyp_flags;
+
 			/* Stage-2 only */
 			enum kvm_pgtable_stage2_flags		flags;
 			kvm_pgtable_force_pte_cb_t		force_pte_cb;
@@ -465,6 +477,11 @@ struct kvm_pgtable {
 	struct kvm_s2_mmu					*mmu;
 };
 
+static inline void kvm_pgtable_hyp_enable_ttbr1(struct kvm_pgtable *pgt)
+{
+	pgt->hyp_flags |= KVM_PGTABLE_HYP_TTBR1;
+}
+
 /**
  * kvm_pgtable_hyp_init() - Initialise a hypervisor stage-1 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
@@ -851,6 +868,16 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker);
 
+/**
+ * kvm_pgtable_hyp_walk() - Walk the entire usable VA range of a hyp pgtable.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_hyp_init().
+ * @walker:	Walker callback description.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_hyp_walk(struct kvm_pgtable *pgt,
+			 struct kvm_pgtable_walker *walker);
+
 /**
  * kvm_pgtable_get_leaf() - Walk a page-table and retrieve the leaf entry
  *			    with its level.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 74fedd9c5ff0..e632fe4ec43c 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -139,6 +139,9 @@ static inline unsigned long hyp_s1_pgtable_pages(void)
 	/* Allow 1 GiB for private mappings */
 	res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
 
+	/* Allow a separate TTBR0 idmap page-table. */
+	res += __hyp_pgtable_max_pages(1);
+
 	return res;
 }
 
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index b6367ff3a49c..f95883771d34 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -120,7 +120,10 @@ int main(void)
   DEFINE(NVHE_INIT_TCR_EL2,	offsetof(struct kvm_nvhe_init_params, tcr_el2));
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
   DEFINE(NVHE_INIT_STACK_HYP_VA,	offsetof(struct kvm_nvhe_init_params, stack_hyp_va));
-  DEFINE(NVHE_INIT_PGD_PA,	offsetof(struct kvm_nvhe_init_params, pgd_pa));
+  DEFINE(NVHE_INIT_TTBR0_PGD_PA,
+	 offsetof(struct kvm_nvhe_init_params, ttbr0_pgd_pa));
+  DEFINE(NVHE_INIT_TTBR1_PGD_PA,
+	 offsetof(struct kvm_nvhe_init_params, ttbr1_pgd_pa));
   DEFINE(NVHE_INIT_HCR_EL2,	offsetof(struct kvm_nvhe_init_params, hcr_el2));
   DEFINE(NVHE_INIT_VTTBR,	offsetof(struct kvm_nvhe_init_params, vttbr));
   DEFINE(NVHE_INIT_VTCR,	offsetof(struct kvm_nvhe_init_params, vtcr));
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 924f33c1a9d4..f2ea75461c1f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2124,38 +2124,51 @@ static int kvm_init_vector_slots(void)
 	return 0;
 }
 
+static unsigned long __init kvm_compute_hyp_tcr(u32 hyp_va_bits)
+{
+	unsigned long tcr = read_sysreg(tcr_el1);
+
+	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		tcr &= ~(TCR_HD | TCR_HA | TCR_A1 | TCR_T0SZ_MASK |
+			 TCR_T1SZ_MASK |
+			 TCR_EPD0_MASK | TCR_EPD1_MASK);
+
+		if (kvm_hyp_uses_ttbr1())
+			tcr |= TCR_T1SZ(hyp_va_bits);
+		else
+			tcr |= TCR_EPD1_MASK;
+	} else {
+		unsigned long ips = FIELD_GET(TCR_IPS_MASK, tcr);
+
+		tcr &= TCR_EL2_MASK;
+		tcr |= TCR_EL2_RES1 | FIELD_PREP(TCR_EL2_PS_MASK, ips);
+		if (lpa2_is_enabled())
+			tcr |= TCR_EL2_DS;
+	}
+
+	return tcr | TCR_T0SZ(hyp_va_bits);
+}
+
 static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
-	unsigned long tcr;
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
 	 * kernel's mapping to the linear mapping, and store it in tpidr_el2
 	 * so that we can use adr_l to access per-cpu variables in EL2.
+	 * In TTBR1 mode, this is the delta from the canonical hyp symbol to
+	 * the linear-map VA at which the allocated per-cpu copy is mapped.
 	 * Also drop the KASAN tag which gets in the way...
 	 */
 	params->tpidr_el2 = (unsigned long)kasan_reset_tag(per_cpu_ptr_nvhe_sym(__per_cpu_start, cpu)) -
 			    (unsigned long)kvm_hyp_kimg_kaddr(CHOOSE_NVHE_SYM(__per_cpu_start));
 
 	params->mair_el2 = read_sysreg(mair_el1);
+	params->tcr_el2 = kvm_compute_hyp_tcr(hyp_va_bits);
 
-	tcr = read_sysreg(tcr_el1);
-	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
-		tcr &= ~(TCR_HD | TCR_HA | TCR_A1 | TCR_T0SZ_MASK);
-		tcr |= TCR_EPD1_MASK;
-	} else {
-		unsigned long ips = FIELD_GET(TCR_IPS_MASK, tcr);
-
-		tcr &= TCR_EL2_MASK;
-		tcr |= TCR_EL2_RES1 | FIELD_PREP(TCR_EL2_PS_MASK, ips);
-		if (lpa2_is_enabled())
-			tcr |= TCR_EL2_DS;
-	}
-	tcr |= TCR_T0SZ(hyp_va_bits);
-	params->tcr_el2 = tcr;
-
-	params->pgd_pa = kvm_mmu_get_httbr();
+	params->ttbr0_pgd_pa = kvm_mmu_get_httbr();
+	params->ttbr1_pgd_pa = kvm_mmu_get_hyp_ttbr1();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
 	else
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index c41152c84705..46f008ee6916 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -11,6 +11,7 @@
 #include <nvhe/spinlock.h>
 
 extern struct kvm_pgtable pkvm_pgtable;
+extern struct kvm_pgtable pkvm_idmap_pgtable;
 extern hyp_spinlock_t pkvm_pgd_lock;
 
 int hyp_create_fixmap(void);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 89cb553be1e5..07fc29c34fb3 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -127,13 +127,22 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
 	ldr	x1, [x0, #NVHE_INIT_VTCR]
 	msr	vtcr_el2, x1
 
-	ldr	x1, [x0, #NVHE_INIT_PGD_PA]
+	ldr	x1, [x0, #NVHE_INIT_TTBR0_PGD_PA]
 	phys_to_ttbr x2, x1
 alternative_if ARM64_HAS_CNP
 	orr	x2, x2, #TTBRx_EL1_CnP
 alternative_else_nop_endif
 	msr	ttbr0_el2, x2
 
+	ldr	x1, [x0, #NVHE_INIT_TTBR1_PGD_PA]
+	cbz	x1, 2f
+	phys_to_ttbr x2, x1
+alternative_if ARM64_HAS_CNP
+	orr	x2, x2, #TTBRx_EL1_CnP
+alternative_else_nop_endif
+	msr_s	SYS_TTBR1_EL2, x2
+2:
+
 	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
 	msr	tcr_el2, x0
 
@@ -261,13 +270,15 @@ reset:
 SYM_CODE_END(__kvm_handle_stub_hvc)
 
 /*
- * void __pkvm_init_switch_pgd(phys_addr_t pgd, unsigned long sp,
- *                             void (*fn)(void));
+ * void __pkvm_init_switch_pgd(phys_addr_t ttbr0, phys_addr_t ttbr1,
+ *                             unsigned long sp, void (*fn)(void));
  *
  * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
  * using a physical pointer without triggering a kCFI failure.
  */
 SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
+	mov	x6, x3
+
 	/* Turn the MMU off */
 	pre_disable_mmu_workaround
 	mrs	x3, sctlr_el2
@@ -284,14 +295,22 @@ alternative_if ARM64_HAS_CNP
 alternative_else_nop_endif
 	msr	ttbr0_el2, x5
 
+	cbz	x1, 1f
+	phys_to_ttbr x5, x1
+alternative_if ARM64_HAS_CNP
+	orr	x5, x5, #TTBRx_EL1_CnP
+alternative_else_nop_endif
+	msr_s	SYS_TTBR1_EL2, x5
+1:
+
 	/* Set the new stack pointer */
-	mov	sp, x1
+	mov	sp, x2
 
 	/* And turn the MMU back on! */
 	dsb	nsh
 	isb
 	set_sctlr_el2	x3
-	ret	x2
+	ret	x6
 SYM_FUNC_END(__pkvm_init_switch_pgd)
 
 	.popsection
diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index 3233a7c70f7c..c856b2399960 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -19,6 +19,7 @@
 #include <nvhe/spinlock.h>
 
 struct kvm_pgtable pkvm_pgtable;
+struct kvm_pgtable pkvm_idmap_pgtable;
 hyp_spinlock_t pkvm_pgd_lock;
 
 struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
@@ -431,6 +432,22 @@ int hyp_create_fixmap(void)
 	return create_fixblock();
 }
 
+static int pkvm_map_idmap_text(unsigned long start, unsigned long end)
+{
+	unsigned long idmap_start, idmap_end;
+
+	idmap_start = __hyp_symbol_pa(__hyp_idmap_text_start);
+	idmap_start = ALIGN_DOWN(idmap_start, PAGE_SIZE);
+	idmap_end = __hyp_symbol_pa(__hyp_idmap_text_end);
+	idmap_end = ALIGN(idmap_end, PAGE_SIZE);
+
+	if (WARN_ON(start != idmap_start || end != idmap_end))
+		return -EINVAL;
+
+	return kvm_pgtable_hyp_map(&pkvm_idmap_pgtable, start,
+				   end - start, start, PAGE_HYP_EXEC);
+}
+
 int hyp_create_idmap(u32 hyp_va_bits)
 {
 	unsigned long start, end;
@@ -441,6 +458,13 @@ int hyp_create_idmap(u32 hyp_va_bits)
 	end = __hyp_symbol_pa(__hyp_idmap_text_end);
 	end = ALIGN(end, PAGE_SIZE);
 
+	if (kvm_hyp_uses_ttbr1()) {
+		__hyp_private_va_base = kvm_hyp_ttbr1_private_start();
+		__hyp_vmemmap = kvm_hyp_ttbr1_vmemmap_base();
+
+		return pkvm_map_idmap_text(start, end);
+	}
+
 	/*
 	 * One half of the VA space is reserved to linearly map portions of
 	 * memory -- see va_layout.c for more details. The other half of the VA
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 2ef1972cc3dd..45b8f7213e39 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -109,6 +109,15 @@ static int recreate_hyp_mappings(phys_addr_t phys, unsigned long size,
 	if (ret)
 		return ret;
 
+	if (kvm_hyp_uses_ttbr1()) {
+		kvm_pgtable_hyp_enable_ttbr1(&pkvm_pgtable);
+
+		ret = kvm_pgtable_hyp_init(&pkvm_idmap_pgtable, hyp_va_bits,
+					   &hyp_early_alloc_mm_ops);
+		if (ret)
+			return ret;
+	}
+
 	ret = hyp_create_idmap(hyp_va_bits);
 	if (ret)
 		return ret;
@@ -169,12 +178,27 @@ static void update_nvhe_init_params(void)
 
 	for (i = 0; i < hyp_nr_cpus; i++) {
 		params = per_cpu_ptr(&kvm_init_params, i);
-		params->pgd_pa = __hyp_linear_pa(pkvm_pgtable.pgd);
+		params->ttbr0_pgd_pa = kvm_hyp_uses_ttbr1() ?
+					__hyp_linear_pa(pkvm_idmap_pgtable.pgd) :
+					__hyp_linear_pa(pkvm_pgtable.pgd);
+		params->ttbr1_pgd_pa = kvm_hyp_uses_ttbr1() ?
+					__hyp_linear_pa(pkvm_pgtable.pgd) : 0;
 		dcache_clean_inval_poc((unsigned long)params,
 				    (unsigned long)params + sizeof(*params));
 	}
 }
 
+static bool pkvm_init_ttbrs_valid(struct kvm_nvhe_init_params *params)
+{
+	if (!params->ttbr0_pgd_pa)
+		return false;
+
+	if (kvm_hyp_uses_ttbr1())
+		return params->ttbr1_pgd_pa;
+
+	return !params->ttbr1_pgd_pa;
+}
+
 static void *hyp_zalloc_hyp_page(void *arg)
 {
 	return hyp_alloc_pages(&hpool, 0);
@@ -284,8 +308,7 @@ static int fix_hyp_pgtable_refcnt(void)
 		.arg	= pkvm_pgtable.mm_ops,
 	};
 
-	return kvm_pgtable_walk(&pkvm_pgtable, 0, BIT(pkvm_pgtable.ia_bits),
-				&walker);
+	return kvm_pgtable_hyp_walk(&pkvm_pgtable, &walker);
 }
 
 void __noreturn __pkvm_init_finalise(void)
@@ -371,8 +394,12 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
 
 	/* Jump in the idmap page to switch to the new page-tables */
 	params = this_cpu_ptr(&kvm_init_params);
+	if (WARN_ON(!pkvm_init_ttbrs_valid(params)))
+		return -EINVAL;
+
 	fn = (typeof(fn))__hyp_symbol_pa(__pkvm_init_switch_pgd);
-	fn(params->pgd_pa, params->stack_hyp_va, __pkvm_init_finalise);
+	fn(params->ttbr0_pgd_pa, params->ttbr1_pgd_pa,
+	   params->stack_hyp_va, __pkvm_init_finalise);
 
 	unreachable();
 }
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 91a7dfad6686..ca07fc2a55ec 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -10,6 +10,7 @@
 #include <linux/bitfield.h>
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
+#include <asm/kvm_mmu.h>
 
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
@@ -71,6 +72,31 @@ static u32 kvm_pgd_pages(u32 ia_bits, s8 start_level)
 	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
+static bool kvm_pgtable_walk_range_valid(struct kvm_pgtable *pgt,
+					 struct kvm_pgtable_walk_data *data)
+{
+	u64 limit = BIT(pgt->ia_bits);
+	u64 mask = limit - 1;
+	u64 last = data->end - 1;
+
+	if (data->addr > data->end)
+		return false;
+
+	if (!(pgt->hyp_flags & KVM_PGTABLE_HYP_TTBR1))
+		return data->addr <= limit && data->end <= limit;
+
+	/*
+	 * TTBR1 hyp walks use canonical virtual addresses supplied by the
+	 * caller. The index helpers extract the relevant bits for each level;
+	 * the masked comparison here only rejects ranges that cross out of the
+	 * single TTBR1 address window described by ia_bits.
+	 */
+	if ((data->addr | mask) != ~0ULL || (last | mask) != ~0ULL)
+		return false;
+
+	return (data->addr & mask) <= (last & mask);
+}
+
 static bool kvm_pte_table(kvm_pte_t pte, s8 level)
 {
 	if (level == KVM_PGTABLE_LAST_LEVEL)
@@ -193,8 +219,13 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 
 	if (!table) {
-		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
-		data->addr += kvm_granule_size(level);
+		u64 granule = kvm_granule_size(level);
+		u64 addr = ALIGN_DOWN(data->addr, granule);
+
+		if (granule > data->end - addr)
+			data->addr = data->end;
+		else
+			data->addr = addr + granule;
 		goto out;
 	}
 
@@ -241,9 +272,8 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
 {
 	u32 idx;
 	int ret = 0;
-	u64 limit = BIT(pgt->ia_bits);
 
-	if (data->addr > limit || data->end > limit)
+	if (!kvm_pgtable_walk_range_valid(pgt, data))
 		return -ERANGE;
 
 	if (!pgt->pgd)
@@ -281,6 +311,26 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return r;
 }
 
+int kvm_pgtable_hyp_walk(struct kvm_pgtable *pgt,
+			 struct kvm_pgtable_walker *walker)
+{
+	u64 size = BIT(pgt->ia_bits);
+	u64 addr = 0;
+
+	if (pgt->hyp_flags & KVM_PGTABLE_HYP_TTBR1) {
+		addr = -size;
+
+		/*
+		 * The exclusive end of the TTBR1 range cannot be represented in
+		 * a u64. Exclude the last page, which cannot be mapped through
+		 * kvm_pgtable_walk() for the same reason.
+		 */
+		size -= PAGE_SIZE;
+	}
+
+	return kvm_pgtable_walk(pgt, addr, size, walker);
+}
+
 struct leaf_walk_data {
 	kvm_pte_t	pte;
 	s8		level;
@@ -539,6 +589,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	pgt->ia_bits		= va_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
+	pgt->hyp_flags		= 0;
 	pgt->mmu		= NULL;
 	pgt->force_pte_cb	= NULL;
 
@@ -568,7 +619,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
+	WARN_ON(kvm_pgtable_hyp_walk(pgt, &walker));
 	pgt->mm_ops->put_page(kvm_dereference_pteref(&walker, pgt->pgd));
 	pgt->pgd = NULL;
 }
@@ -1589,6 +1640,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
 	pgt->mmu		= mmu;
+	pgt->hyp_flags		= 0;
 	pgt->flags		= flags;
 	pgt->force_pte_cb	= force_pte_cb;
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 154d53dca619..46fd7040bca7 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -20,11 +20,13 @@
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/sections.h>
 #include <asm/virt.h>
 
 #include "trace.h"
 
 static struct kvm_pgtable *hyp_pgtable;
+static struct kvm_pgtable *hyp_idmap_pgtable;
 static DEFINE_MUTEX(kvm_hyp_pgd_mutex);
 
 static unsigned long __ro_after_init hyp_idmap_start;
@@ -392,6 +394,11 @@ static void stage2_flush_vm(struct kvm *kvm)
 void __init free_hyp_pgds(void)
 {
 	mutex_lock(&kvm_hyp_pgd_mutex);
+	if (hyp_idmap_pgtable) {
+		kvm_pgtable_hyp_destroy(hyp_idmap_pgtable);
+		kfree(hyp_idmap_pgtable);
+		hyp_idmap_pgtable = NULL;
+	}
 	if (hyp_pgtable) {
 		kvm_pgtable_hyp_destroy(hyp_pgtable);
 		kfree(hyp_pgtable);
@@ -2481,6 +2488,17 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 
 phys_addr_t kvm_mmu_get_httbr(void)
 {
+	if (hyp_idmap_pgtable)
+		return __pa(hyp_idmap_pgtable->pgd);
+
+	return __pa(hyp_pgtable->pgd);
+}
+
+phys_addr_t kvm_mmu_get_hyp_ttbr1(void)
+{
+	if (!kvm_hyp_uses_ttbr1())
+		return 0;
+
 	return __pa(hyp_pgtable->pgd);
 }
 
@@ -2491,9 +2509,15 @@ phys_addr_t kvm_get_idmap_vector(void)
 
 static int kvm_map_idmap_text(void)
 {
+	struct kvm_pgtable *pgt = hyp_idmap_pgtable ?: hyp_pgtable;
 	unsigned long size = hyp_idmap_end - hyp_idmap_start;
-	int err = __create_hyp_mappings(hyp_idmap_start, size, hyp_idmap_start,
-					PAGE_HYP_EXEC);
+	int err;
+
+	if (WARN_ON(kvm_hyp_uses_ttbr1() && !hyp_idmap_pgtable))
+		return -EINVAL;
+
+	err = kvm_pgtable_hyp_map(pgt, hyp_idmap_start, size, hyp_idmap_start,
+				  PAGE_HYP_EXEC);
 	if (err)
 		kvm_err("Failed to idmap %lx-%lx\n",
 			hyp_idmap_start, hyp_idmap_end);
@@ -2559,14 +2583,39 @@ int __init kvm_mmu_init(u32 hyp_va_bits)
 	if (err)
 		goto out_free_pgtable;
 
+	if (kvm_hyp_uses_ttbr1()) {
+		kvm_pgtable_hyp_enable_ttbr1(hyp_pgtable);
+
+		hyp_idmap_pgtable = kzalloc_obj(*hyp_idmap_pgtable);
+		if (!hyp_idmap_pgtable) {
+			kvm_err("Hyp mode idmap page-table not allocated\n");
+			err = -ENOMEM;
+			goto out_destroy_pgtable;
+		}
+
+		err = kvm_pgtable_hyp_init(hyp_idmap_pgtable, hyp_va_bits,
+					   &kvm_hyp_mm_ops);
+		if (err)
+			goto out_free_idmap_pgtable;
+	}
+
 	err = kvm_map_idmap_text();
 	if (err)
-		goto out_destroy_pgtable;
+		goto out_destroy_idmap_pgtable;
 
-	io_map_base = hyp_idmap_start;
+	if (kvm_hyp_uses_ttbr1())
+		io_map_base = kvm_hyp_ttbr1_private_end();
+	else
+		io_map_base = hyp_idmap_start;
 	__hyp_va_bits = hyp_va_bits;
 	return 0;
 
+out_destroy_idmap_pgtable:
+	if (hyp_idmap_pgtable)
+		kvm_pgtable_hyp_destroy(hyp_idmap_pgtable);
+out_free_idmap_pgtable:
+	kfree(hyp_idmap_pgtable);
+	hyp_idmap_pgtable = NULL;
 out_destroy_pgtable:
 	kvm_pgtable_hyp_destroy(hyp_pgtable);
 out_free_pgtable:
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 053e4f733e4b..1352c89d2bd8 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -292,6 +292,9 @@ static int __init finalize_pkvm(void)
 	ret = pkvm_drop_host_privileges();
 	if (ret)
 		pr_err("Failed to finalize Hyp protection: %d\n", ret);
+	else
+		kvm_info("pKVM finalized in %s mode\n",
+			 kvm_hyp_uses_ttbr1() ? "hVHE" : "nVHE");
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 75a89ad8fecf..1e1816995fe4 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -33,19 +33,29 @@ static u64 __early_kern_hyp_va(u64 addr)
 	return addr;
 }
 
+static u64 __early_kern_sym_hyp_va(void *ptr)
+{
+	if (is_kernel_in_hyp_mode() || kvm_hyp_init_uses_ttbr1())
+		return  (u64)ptr;
+
+	return __early_kern_hyp_va((u64)lm_alias(ptr));
+}
+
 /*
  * Store a hyp VA <-> PA offset into a EL2-owned variable.
  */
 static void init_hyp_physvirt_offset(void)
 {
-	u64 kern_va, hyp_va;
+	u64 kern_va, hyp_va, sym_va;
 
 	/* Compute the offset from the hyp VA and PA of a random symbol. */
 	kern_va = (u64)lm_alias(__hyp_text_start);
 	hyp_va = __early_kern_hyp_va(kern_va);
 	hyp_physvirt_offset = (s64)__pa(kern_va) - (s64)hyp_va;
 
-	hyp_symbol_physvirt_offset = hyp_physvirt_offset;
+	sym_va = __early_kern_sym_hyp_va(__hyp_text_start);
+	hyp_symbol_physvirt_offset = (s64)__pa_symbol(__hyp_text_start) -
+				     (s64)sym_va;
 }
 
 /*
@@ -87,6 +97,14 @@ __init void kvm_compute_layout(void)
 	u64 hyp_va_msb;
 	u32 hyp_va_bits = kvm_hyp_va_bits();
 
+	if (kvm_hyp_init_uses_ttbr1()) {
+		tag_lsb = 0;
+		tag_val = 0;
+		va_mask = ~0ULL;
+		init_hyp_physvirt_offset();
+		return;
+	}
+
 	/* Where is my RAM region? */
 	hyp_va_msb  = idmap_addr & BIT(hyp_va_bits - 1);
 	hyp_va_msb ^= BIT(hyp_va_bits - 1);
@@ -117,6 +135,9 @@ __init void kvm_apply_hyp_relocations(void)
 	int32_t *begin = (int32_t *)__hyp_reloc_begin;
 	int32_t *end = (int32_t *)__hyp_reloc_end;
 
+	if (kvm_hyp_init_uses_ttbr1())
+		return;
+
 	for (rel = begin; rel < end; ++rel) {
 		uintptr_t *ptr, kimg_va;
 
@@ -187,14 +208,15 @@ void __init kvm_update_va_mask(struct alt_instr *alt,
 		u32 rd, rn, insn, oinsn;
 
 		/*
-		 * VHE doesn't need any address translation, let's NOP
+		 * VHE/hVHE doesn't need any address translation, let's NOP
 		 * everything.
 		 *
 		 * Alternatively, if the tag is zero (because the layout
 		 * dictates it and we don't have any spare bits in the
 		 * address), NOP everything after masking the kernel VA.
 		 */
-		if (cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN) || (!tag_val && i > 0)) {
+		if (cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN) ||
+		    kvm_hyp_init_uses_ttbr1() || (!tag_val && i > 0)) {
 			updptr[i] = cpu_to_le32(aarch64_insn_gen_nop());
 			continue;
 		}
@@ -225,7 +247,7 @@ void kvm_patch_vector_branch(struct alt_instr *alt,
 	/*
 	 * Compute HYP VA by using the same computation as kern_hyp_va()
 	 */
-	addr = __early_kern_hyp_va((u64)kvm_hyp_kimg_kaddr(__kvm_hyp_vector));
+	addr = __early_kern_sym_hyp_va(__kvm_hyp_vector);
 
 	/* Use PC[10:7] to branch to the same vector in KVM */
 	addr |= ((u64)origptr & GENMASK_ULL(10, 7));
-- 
2.43.0

