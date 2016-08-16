From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC PATCH 5/7] arm64/kvm: hyp: tlb: use __tlbi() helper
Date: Tue, 16 Aug 2016 11:45:10 +0100
Message-ID: <1471344312-26685-6-git-send-email-punit.agrawal@arm.com>
References: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1471344312-26685-1-git-send-email-punit.agrawal@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Punit Agrawal <punit.agrawal@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Now that we have a __tlbi() helper, make use of this in the arm64 KVM hyp
code to get rid of asm() boilerplate. At the same time, we simplify
__tlb_flush_vm_context by using __flush_icache_all(), as this has the
appropriate instruction cache maintenance and barrier.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
[ rename tlbi -> __tlbi, convert additional sites, update commit log ]
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
---
 arch/arm64/kvm/hyp/tlb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index be8177c..4cda100 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -16,6 +16,7 @@
  */
 
 #include <asm/kvm_hyp.h>
+#include <asm/tlbflush.h>
 
 static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
@@ -32,7 +33,7 @@ static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * whole of Stage-1. Weep...
 	 */
 	ipa >>= 12;
-	asm volatile("tlbi ipas2e1is, %0" : : "r" (ipa));
+	__tlbi(ipas2e1is, ipa);
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,
@@ -41,7 +42,7 @@ static void __hyp_text __tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * the Stage-1 invalidation happened first.
 	 */
 	dsb(ish);
-	asm volatile("tlbi vmalle1is" : : );
+	__tlbi(vmalle1is);
 	dsb(ish);
 	isb();
 
@@ -60,7 +61,7 @@ static void __hyp_text __tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
 	isb();
 
-	asm volatile("tlbi vmalls12e1is" : : );
+	__tlbi(vmalls12e1is);
 	dsb(ish);
 	isb();
 
@@ -72,9 +73,8 @@ __alias(__tlb_flush_vmid) void __kvm_tlb_flush_vmid(struct kvm *kvm);
 static void __hyp_text __tlb_flush_vm_context(void)
 {
 	dsb(ishst);
-	asm volatile("tlbi alle1is	\n"
-		     "ic ialluis	  ": : );
-	dsb(ish);
+	__tlbi(alle1is);
+	__flush_icache_all(); /* contains a dsb(ish) */
 }
 
 __alias(__tlb_flush_vm_context) void __kvm_flush_vm_context(void);
-- 
2.8.1
