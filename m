From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 1/6] arm64: KVM: Add support for Stage-2 control of memory
 types and cacheability
Date: Mon,  2 Jul 2018 16:02:45 +0100
Message-ID: <20180702150250.16550-2-marc.zyngier@arm.com>
References: <20180702150250.16550-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA808402DB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 10:51:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tbyJR4f5OK-2 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Jul 2018 10:50:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83D5E49F87
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Jul 2018 10:50:40 -0400 (EDT)
In-Reply-To: <20180702150250.16550-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Up to ARMv8.3, the combinaison of Stage-1 and Stage-2 attributes
results in the strongest attribute of the two stages.  This means
that the hypervisor has to perform quite a lot of cache maintenance
just in case the guest has some non-cacheable mappings around.

ARMv8.4 solves this problem by offering a different mode (FWB) where
Stage-2 has total control over the memory attribute (this is limited
to systems where both I/O and instruction fetches are coherent with
the dcache). This is achieved by having a different set of memory
attributes in the page tables, and a new bit set in HCR_EL2.

On such a system, we can then safely sidestep any form of dcache
management.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpucaps.h      |  3 ++-
 arch/arm64/include/asm/kvm_arm.h      |  1 +
 arch/arm64/include/asm/kvm_emulate.h  |  2 ++
 arch/arm64/include/asm/kvm_mmu.h      | 27 +++++++++++++++++++++------
 arch/arm64/include/asm/memory.h       |  7 +++++++
 arch/arm64/include/asm/pgtable-prot.h | 14 ++++++++++++--
 arch/arm64/include/asm/sysreg.h       |  1 +
 arch/arm64/kernel/cpufeature.c        | 20 ++++++++++++++++++++
 virt/kvm/arm/mmu.c                    |  4 ++++
 9 files changed, 70 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8a699c708fc9..ed84d6536830 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -49,7 +49,8 @@
 #define ARM64_HAS_CACHE_DIC			28
 #define ARM64_HW_DBM				29
 #define ARM64_SSBD				30
+#define ARM64_HAS_STAGE2_FWB			31
 
-#define ARM64_NCAPS				31
+#define ARM64_NCAPS				32
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 6dd285e979c9..aa45df752a16 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -23,6 +23,7 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_FWB		(UL(1) << 46)
 #define HCR_TEA		(UL(1) << 37)
 #define HCR_TERR	(UL(1) << 36)
 #define HCR_TLOR	(UL(1) << 35)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1dab3a984608..dd98fdf33d99 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -63,6 +63,8 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		/* trap error record accesses */
 		vcpu->arch.hcr_el2 |= HCR_TERR;
 	}
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		vcpu->arch.hcr_el2 |= HCR_FWB;
 
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
 		vcpu->arch.hcr_el2 &= ~HCR_RW;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index fb9a7127bb75..bac9f016736b 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -267,6 +267,15 @@ static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
 {
 	void *va = page_address(pfn_to_page(pfn));
 
+	/*
+	 * With FWB, we ensure that the guest always accesses memory using
+	 * cacheable attributes, and we don't have to clean to PoC when
+	 * faulting in pages. Furthermore, FWB implies IDC, so cleaning to
+	 * PoU is not required either in this case.
+	 */
+	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))
+		return;
+
 	kvm_flush_dcache_to_poc(va, size);
 }
 
@@ -287,20 +296,26 @@ static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
 
 static inline void __kvm_flush_dcache_pte(pte_t pte)
 {
-	struct page *page = pte_page(pte);
-	kvm_flush_dcache_to_poc(page_address(page), PAGE_SIZE);
+	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
+		struct page *page = pte_page(pte);
+		kvm_flush_dcache_to_poc(page_address(page), PAGE_SIZE);
+	}
 }
 
 static inline void __kvm_flush_dcache_pmd(pmd_t pmd)
 {
-	struct page *page = pmd_page(pmd);
-	kvm_flush_dcache_to_poc(page_address(page), PMD_SIZE);
+	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
+		struct page *page = pmd_page(pmd);
+		kvm_flush_dcache_to_poc(page_address(page), PMD_SIZE);
+	}
 }
 
 static inline void __kvm_flush_dcache_pud(pud_t pud)
 {
-	struct page *page = pud_page(pud);
-	kvm_flush_dcache_to_poc(page_address(page), PUD_SIZE);
+	if (!cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
+		struct page *page = pud_page(pud);
+		kvm_flush_dcache_to_poc(page_address(page), PUD_SIZE);
+	}
 }
 
 #define kvm_virt_to_phys(x)		__pa_symbol(x)
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 49d99214f43c..b96442960aea 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -155,6 +155,13 @@
 #define MT_S2_NORMAL		0xf
 #define MT_S2_DEVICE_nGnRE	0x1
 
+/*
+ * Memory types for Stage-2 translation when ID_AA64MMFR2_EL1.FWB is 0001
+ * Stage-2 enforces Normal-WB and Device-nGnRE
+ */
+#define MT_S2_FWB_NORMAL	6
+#define MT_S2_FWB_DEVICE_nGnRE	1
+
 #ifdef CONFIG_ARM64_4K_PAGES
 #define IOREMAP_MAX_ORDER	(PUD_SHIFT)
 #else
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 108ecad7acc5..c66c3047400e 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -67,8 +67,18 @@
 #define PAGE_HYP_RO		__pgprot(_HYP_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY | PTE_HYP_XN)
 #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
 
-#define PAGE_S2			__pgprot(_PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_NORMAL) | PTE_S2_RDONLY | PTE_S2_XN)
-#define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PTE_S2_MEMATTR(MT_S2_DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
+#define PAGE_S2_MEMATTR(attr)						\
+	({								\
+		u64 __val;						\
+		if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB))		\
+			__val = PTE_S2_MEMATTR(MT_S2_FWB_ ## attr);	\
+		else							\
+			__val = PTE_S2_MEMATTR(MT_S2_ ## attr);		\
+		__val;							\
+	 })
+
+#define PAGE_S2			__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(NORMAL) | PTE_S2_RDONLY | PTE_S2_XN)
+#define PAGE_S2_DEVICE		__pgprot(_PROT_DEFAULT | PAGE_S2_MEMATTR(DEVICE_nGnRE) | PTE_S2_RDONLY | PTE_S2_XN)
 
 #define PAGE_NONE		__pgprot(((_PAGE_DEFAULT) & ~PTE_VALID) | PTE_PROT_NONE | PTE_RDONLY | PTE_NG | PTE_PXN | PTE_UXN)
 #define PAGE_SHARED		__pgprot(_PAGE_DEFAULT | PTE_USER | PTE_NG | PTE_PXN | PTE_UXN | PTE_WRITE)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index a8f84812c6e8..98af0b37fb31 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -576,6 +576,7 @@
 #define ID_AA64MMFR1_VMIDBITS_16	2
 
 /* id_aa64mmfr2 */
+#define ID_AA64MMFR2_FWB_SHIFT		40
 #define ID_AA64MMFR2_AT_SHIFT		32
 #define ID_AA64MMFR2_LVA_SHIFT		16
 #define ID_AA64MMFR2_IESB_SHIFT		12
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f24892a40d2c..d58d1f0abe16 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -192,6 +192,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_FWB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_AT_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LVA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_IESB_SHIFT, 4, 0),
@@ -1026,6 +1027,14 @@ static void cpu_copy_el2regs(const struct arm64_cpu_capabilities *__unused)
 }
 #endif
 
+static void cpu_has_fwb(const struct arm64_cpu_capabilities *__unused)
+{
+	u64 val = read_sysreg_s(SYS_CLIDR_EL1);
+
+	/* Check that CLIDR_EL1.LOU{U,IS} are both 0 */
+	WARN_ON(val & (7 << 27 | 7 << 21));
+}
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -1182,6 +1191,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = has_cache_dic,
 	},
+	{
+		.desc = "Stage-2 Force Write-Back",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HAS_STAGE2_FWB,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_FWB_SHIFT,
+		.min_field_value = 1,
+		.matches = has_cpuid_feature,
+		.cpu_enable = cpu_has_fwb,
+	},
 #ifdef CONFIG_ARM64_HW_AFDBM
 	{
 		/*
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 1d90d79706bd..ea7314296ad1 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -196,6 +196,10 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
  * This is why right after unmapping a page/section and invalidating
  * the corresponding TLBs, we call kvm_flush_dcache_p*() to make sure
  * the IO subsystem will never hit in the cache.
+ *
+ * This is all avoided on systems that have ARM64_HAS_STAGE2_FWB, as
+ * we then fully enforce cacheability of RAM, no matter what the guest
+ * does.
  */
 static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 		       phys_addr_t addr, phys_addr_t end)
-- 
2.17.1
