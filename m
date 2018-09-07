From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PULL RESEND v2 3/4] KVM: Remove obsolete kvm_unmap_hva notifier
 backend
Date: Fri,  7 Sep 2018 15:12:55 +0200
Message-ID: <20180907131256.2412-4-christoffer.dall@arm.com>
References: <20180907131256.2412-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AADA4A225
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 09:13:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dSSkcCTQqnwj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Sep 2018 09:13:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BE754A1DC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Sep 2018 09:13:08 -0400 (EDT)
In-Reply-To: <20180907131256.2412-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, James Hogan <jhogan@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

kvm_unmap_hva is long gone, and we only have kvm_unmap_hva_range to
deal with. Drop the now obsolete code.

Fixes: fb1522e099f0 ("KVM: update to new mmu_notifier semantic v2")
Cc: James Hogan <jhogan@kernel.org>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
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
index 79906cecb091..3ad482d2f1eb 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -223,7 +223,6 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end);
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f26055f2306e..8e6d46df38aa 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -357,7 +357,6 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events);
 
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
index 00ddb0c9e612..e6a33420b871 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1450,7 +1450,6 @@ asmlinkage void kvm_spurious_fault(void);
 	____kvm_handle_fault_on_reboot(insn, "")
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a282321329b5..d440154e8938 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1853,11 +1853,6 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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
index 111a660be3be..ed162a6c57c5 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1817,18 +1817,6 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *dat
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
