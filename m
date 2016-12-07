From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] arm64: Work around Falkor erratum 1009
Date: Wed,  7 Dec 2016 15:04:31 -0500
Message-ID: <20161207200431.4587-1-cov@codeaurora.org>
References: <20161207200028.4420-1-cov@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161207200028.4420-1-cov@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Shanker Donthineni <shankerd@codeaurora.org>, Christopher Covington <cov@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Shanker Donthineni <shankerd@codeaurora.org>

During a TLB invalidate sequence targeting the inner shareable
domain, Falkor may prematurely complete the DSB before all loads
and stores using the old translation are observed; instruction
fetches are not subject to the conditions of this erratum.

Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/Kconfig                | 10 +++++++++
 arch/arm64/include/asm/cpucaps.h  |  3 ++-
 arch/arm64/include/asm/tlbflush.h | 43 +++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpu_errata.c    |  7 +++++++
 arch/arm64/kvm/hyp/tlb.c          | 39 ++++++++++++++++++++++++++++++-----
 5 files changed, 96 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1004a3d..125440f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -485,6 +485,16 @@ config QCOM_FALKOR_ERRATUM_E1003
 
 	  If unsure, say Y.
 
+config QCOM_FALKOR_ERRATUM_E1009
+	bool "Falkor E1009: Prematurely complete a DSB after a TLBI"
+	default y
+	help
+	  Falkor CPU may prematurely complete a DSB following a TLBI xxIS
+	  invalidate maintenance operations. Repeat the TLBI operation one
+	  more time to fix the issue.
+
+	  If unsure, say Y.
+
 endmenu
 
 
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index cb6a8c2..5357d7f 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -35,7 +35,8 @@
 #define ARM64_HYP_OFFSET_LOW			14
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	16
+#define ARM64_WORKAROUND_QCOM_FALKOR_E1009	17
 
-#define ARM64_NCAPS				17
+#define ARM64_NCAPS				18
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index deab523..03bafc5 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -23,6 +23,7 @@
 
 #include <linux/sched.h>
 #include <asm/cputype.h>
+#include <asm/alternative.h>
 
 /*
  * Raw TLBI operations.
@@ -94,6 +95,13 @@ static inline void flush_tlb_all(void)
 	dsb(ishst);
 	__tlbi(vmalle1is);
 	dsb(ish);
+	asm volatile(ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "tlbi vmalle1is \n"
+		     "dsb ish \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : :);
 	isb();
 }
 
@@ -104,6 +112,13 @@ static inline void flush_tlb_mm(struct mm_struct *mm)
 	dsb(ishst);
 	__tlbi(aside1is, asid);
 	dsb(ish);
+	asm volatile(ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "tlbi aside1is, %0 \n"
+		     "dsb ish \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : "r" (asid));
 }
 
 static inline void flush_tlb_page(struct vm_area_struct *vma,
@@ -114,6 +129,13 @@ static inline void flush_tlb_page(struct vm_area_struct *vma,
 	dsb(ishst);
 	__tlbi(vale1is, addr);
 	dsb(ish);
+	asm volatile(ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "tlbi vale1is, %0 \n"
+		     "dsb ish \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : "r" (addr));
 }
 
 /*
@@ -145,6 +167,13 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 			__tlbi(vae1is, addr);
 	}
 	dsb(ish);
+	asm volatile(ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "tlbi vae1is, %0 \n"
+		     "dsb ish \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : "r" (end));
 }
 
 static inline void flush_tlb_range(struct vm_area_struct *vma,
@@ -169,6 +198,13 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 	for (addr = start; addr < end; addr += 1 << (PAGE_SHIFT - 12))
 		__tlbi(vaae1is, addr);
 	dsb(ish);
+	asm volatile(ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "tlbi vaae1is, %0 \n"
+		     "dsb ish \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : "r" (end));
 	isb();
 }
 
@@ -183,6 +219,13 @@ static inline void __flush_tlb_pgtable(struct mm_struct *mm,
 
 	__tlbi(vae1is, addr);
 	dsb(ish);
+	asm volatile(ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "tlbi vae1is, %0 \n"
+		     "dsb ish \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : "r" (addr));
 }
 
 #endif
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 3789e2f..8013579 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -137,6 +137,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		MIDR_RANGE(MIDR_QCOM_FALKOR_V1, 0x00, 0x00),
 	},
 #endif
+#ifdef CONFIG_QCOM_FALKOR_ERRATUM_E1009
+	{
+		.desc = "Qualcomm Falkor erratum E1009",
+		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1009,
+		MIDR_RANGE(MIDR_QCOM_FALKOR_V1, 0x00, 0x00),
+	},
+#endif
 	{
 	}
 };
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 88e2f2b..dfd3a77 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -16,6 +16,7 @@
  */
 
 #include <asm/kvm_hyp.h>
+#include <asm/alternative.h>
 
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
@@ -32,7 +33,14 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * whole of Stage-1. Weep...
 	 */
 	ipa >>= 12;
-	asm volatile("tlbi ipas2e1is, %0" : : "r" (ipa));
+	asm volatile("tlbi ipas2e1is, %0 \n"
+		     ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "dsb ish \n"
+		     "tlbi ipas2e1is, %0 \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : "r" (ipa));
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,
@@ -41,7 +49,14 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * the Stage-1 invalidation happened first.
 	 */
 	dsb(ish);
-	asm volatile("tlbi vmalle1is" : : );
+	asm volatile("tlbi vmalle1is \n"
+		     ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "dsb ish \n"
+		     "tlbi vmalle1is \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : );
 	dsb(ish);
 	isb();
 
@@ -57,7 +72,14 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
 	isb();
 
-	asm volatile("tlbi vmalls12e1is" : : );
+	asm volatile("tlbi vmalls12e1is \n"
+		     ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "dsb ish \n"
+		     "tlbi vmalls12e1is \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     : : );
 	dsb(ish);
 	isb();
 
@@ -82,7 +104,14 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 void __hyp_text __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
-	asm volatile("tlbi alle1is	\n"
-		     "ic ialluis	  ": : );
+	asm volatile("tlbi alle1is \n"
+		     ALTERNATIVE(
+		     "nop \n"
+		     "nop \n",
+		     "dsb ish \n"
+		     "tlbi alle1is \n",
+		     ARM64_WORKAROUND_QCOM_FALKOR_E1009)
+		     "ic ialluis \n"
+		     : : );
 	dsb(ish);
 }
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project.
