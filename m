From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: Remove obsolete kvm_unmap_hva notifier backend
Date: Thu, 23 Aug 2018 16:38:05 +0100
Message-ID: <20180823153805.158563-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 072954A22E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 11:38:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g+2fEuDZrsUN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Aug 2018 11:38:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 971244A22B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Aug 2018 11:38:20 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: James Hogan <jhogan@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

kvm_unmap_hva is long gone, and we only have kvm_unmap_hva_range to
deal with. Drop the now obsolete code.

Fixes: fb1522e099f0 ("KVM: update to new mmu_notifier semantic v2")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_host.h   |  1 -
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/mips/include/asm/kvm_host.h  |  1 -
 arch/mips/kvm/mmu.c               | 10 ----------
 arch/x86/include/asm/kvm_host.h   |  1 -
 arch/x86/kvm/mmu.c                |  5 -----
 virt/kvm/arm/mmu.c                | 12 ------------
 virt/kvm/arm/trace.h              | 15 ---------------
 8 files changed, 46 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 1f1fe4109b02..dd282cc54e45 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -218,7 +218,6 @@ unsigned long kvm_call_hyp(void *hypfn, ...);
 void force_vm_exit(const cpumask_t *mask);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fe8777b12f86..d6c68cf4f264 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -352,7 +352,6 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index a9af1d2dcd69..2c1c53d12179 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -931,7 +931,6 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 						   bool write);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index ee64db032793..d8dcdb350405 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -512,16 +512,6 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 	return 1;
 }
 
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
-{
-	unsigned long end = hva + PAGE_SIZE;
-
-	handle_hva_to_gpa(kvm, hva, end, &kvm_unmap_hva_handler, NULL);
-
-	kvm_mips_callbacks->flush_shadow_all(kvm);
-	return 0;
-}
-
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
 {
 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c13cd28d9d1b..9bf27626c167 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1401,7 +1401,6 @@ asmlinkage void kvm_spurious_fault(void);
 	____kvm_handle_fault_on_reboot(insn, "")
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6b8f11521c41..0182a4ee799c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1801,11 +1801,6 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	return kvm_handle_hva_range(kvm, hva, hva + 1, data, handler);
 }
 
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
-{
-	return kvm_handle_hva(kvm, hva, 0, kvm_unmap_rmapp);
-}
-
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
 {
 	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 287c8e274655..b5b9746af23c 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1768,18 +1768,6 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *dat
 	return 0;
 }
 
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
-{
-	unsigned long end = hva + PAGE_SIZE;
-
-	if (!kvm->arch.pgd)
-		return 0;
-
-	trace_kvm_unmap_hva(hva);
-	handle_hva_to_gpa(kvm, hva, end, &kvm_unmap_hva_handler, NULL);
-	return 0;
-}
-
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end)
 {
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index e53b596f483b..57b3edebbb40 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -134,21 +134,6 @@ TRACE_EVENT(kvm_mmio_emulate,
 		  __entry->vcpu_pc, __entry->instr, __entry->cpsr)
 );
 
-TRACE_EVENT(kvm_unmap_hva,
-	TP_PROTO(unsigned long hva),
-	TP_ARGS(hva),
-
-	TP_STRUCT__entry(
-		__field(	unsigned long,	hva		)
-	),
-
-	TP_fast_assign(
-		__entry->hva		= hva;
-	),
-
-	TP_printk("mmu notifier unmap hva: %#08lx", __entry->hva)
-);
-
 TRACE_EVENT(kvm_unmap_hva_range,
 	TP_PROTO(unsigned long start, unsigned long end),
 	TP_ARGS(start, end),
-- 
2.18.0
