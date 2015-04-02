From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/27] arm/arm64: KVM: Implement Stage-2 page aging
Date: Thu,  2 Apr 2015 11:05:14 +0100
Message-ID: <1427969131-8445-11-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>, Eric Auger <eric.auger@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Nikolay Nikolaev <n.nikolaev@virtualopensystems.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Until now, KVM/arm didn't care much for page aging (who was swapping
anyway?), and simply provided empty hooks to the core KVM code. With
server-type systems now being available, things are quite different.

This patch implements very simple support for page aging, by clearing
the Access flag in the Stage-2 page tables. On access fault, the current
fault handling will write the PTE or PMD again, putting the Access flag
back on.

It should be possible to implement a much faster handling for Access
faults, but that's left for a later patch.

With this in place, performance in VMs is degraded much more gracefully.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_arm.h    |  1 +
 arch/arm/include/asm/kvm_host.h   | 13 ++------
 arch/arm/kvm/mmu.c                | 65 ++++++++++++++++++++++++++++++++++++++-
 arch/arm/kvm/trace.h              | 33 ++++++++++++++++++++
 arch/arm64/include/asm/esr.h      |  1 +
 arch/arm64/include/asm/kvm_arm.h  |  1 +
 arch/arm64/include/asm/kvm_host.h | 13 ++------
 7 files changed, 104 insertions(+), 23 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index 816db0b..d995821 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -185,6 +185,7 @@
 #define HSR_COND	(0xfU << HSR_COND_SHIFT)
 
 #define FSC_FAULT	(0x04)
+#define FSC_ACCESS	(0x08)
 #define FSC_PERM	(0x0c)
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 902a7d1..d71607c 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -167,19 +167,10 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 
 unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
 int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 /* We do not have shadow page tables, hence the empty hooks */
-static inline int kvm_age_hva(struct kvm *kvm, unsigned long start,
-			      unsigned long end)
-{
-	return 0;
-}
-
-static inline int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
-{
-	return 0;
-}
-
 static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 							 unsigned long address)
 {
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index ffa06e0..1831aa2 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -1299,6 +1299,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 out_unlock:
 	spin_unlock(&kvm->mmu_lock);
+	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret;
 }
@@ -1333,7 +1334,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	/* Check the stage-2 fault is trans. fault or write fault */
 	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
-	if (fault_status != FSC_FAULT && fault_status != FSC_PERM) {
+	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
+	    fault_status != FSC_ACCESS) {
 		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
 			kvm_vcpu_trap_get_class(vcpu),
 			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
@@ -1475,6 +1477,67 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
 }
 
+static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+{
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pmd = stage2_get_pmd(kvm, NULL, gpa);
+	if (!pmd || pmd_none(*pmd))	/* Nothing there */
+		return 0;
+
+	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
+		if (pmd_young(*pmd)) {
+			*pmd = pmd_mkold(*pmd);
+			return 1;
+		}
+
+		return 0;
+	}
+
+	pte = pte_offset_kernel(pmd, gpa);
+	if (pte_none(*pte))
+		return 0;
+
+	if (pte_young(*pte)) {
+		*pte = pte_mkold(*pte);	/* Just a page... */
+		return 1;
+	}
+
+	return 0;
+}
+
+static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
+{
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pmd = stage2_get_pmd(kvm, NULL, gpa);
+	if (!pmd || pmd_none(*pmd))	/* Nothing there */
+		return 0;
+
+	if (kvm_pmd_huge(*pmd))		/* THP, HugeTLB */
+		return pmd_young(*pmd);
+
+	pte = pte_offset_kernel(pmd, gpa);
+	if (!pte_none(*pte))		/* Just a page... */
+		return pte_young(*pte);
+
+	return 0;
+}
+
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+{
+	trace_kvm_age_hva(start, end);
+	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
+}
+
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	trace_kvm_test_age_hva(hva);
+	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
+}
+
 void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
 	mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
index 6817664..c09f37f 100644
--- a/arch/arm/kvm/trace.h
+++ b/arch/arm/kvm/trace.h
@@ -210,6 +210,39 @@ TRACE_EVENT(kvm_set_spte_hva,
 	TP_printk("mmu notifier set pte hva: %#08lx", __entry->hva)
 );
 
+TRACE_EVENT(kvm_age_hva,
+	TP_PROTO(unsigned long start, unsigned long end),
+	TP_ARGS(start, end),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+	),
+
+	TP_fast_assign(
+		__entry->start		= start;
+		__entry->end		= end;
+	),
+
+	TP_printk("mmu notifier age hva: %#08lx -- %#08lx",
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(kvm_test_age_hva,
+	TP_PROTO(unsigned long hva),
+	TP_ARGS(hva),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	hva		)
+	),
+
+	TP_fast_assign(
+		__entry->hva		= hva;
+	),
+
+	TP_printk("mmu notifier test age hva: %#08lx", __entry->hva)
+);
+
 TRACE_EVENT(kvm_hvc,
 	TP_PROTO(unsigned long vcpu_pc, unsigned long r0, unsigned long imm),
 	TP_ARGS(vcpu_pc, r0, imm),
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index 92bbae3..7052245 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -90,6 +90,7 @@
 #define ESR_ELx_FSC		(0x3F)
 #define ESR_ELx_FSC_TYPE	(0x3C)
 #define ESR_ELx_FSC_EXTABT	(0x10)
+#define ESR_ELx_FSC_ACCESS	(0x08)
 #define ESR_ELx_FSC_FAULT	(0x04)
 #define ESR_ELx_FSC_PERM	(0x0C)
 #define ESR_ELx_CV		(UL(1) << 24)
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 94674eb..9e5543e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -187,6 +187,7 @@
 
 /* For compatibility with fault code shared with 32-bit */
 #define FSC_FAULT	ESR_ELx_FSC_FAULT
+#define FSC_ACCESS	ESR_ELx_FSC_ACCESS
 #define FSC_PERM	ESR_ELx_FSC_PERM
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 967fb1c..f0f58c9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -179,19 +179,10 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
+int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 
 /* We do not have shadow page tables, hence the empty hooks */
-static inline int kvm_age_hva(struct kvm *kvm, unsigned long start,
-			      unsigned long end)
-{
-	return 0;
-}
-
-static inline int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
-{
-	return 0;
-}
-
 static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
 							 unsigned long address)
 {
-- 
2.1.4

