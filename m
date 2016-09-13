From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH 5/7] arm64/kvm: hyp: tlb: use __tlbi() helper
Date: Tue, 13 Sep 2016 11:16:07 +0100
Message-ID: <1473761769-30572-6-git-send-email-punit.agrawal@arm.com>
References: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F6149B93
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:08:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ytwJC4xsMXQw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Sep 2016 06:08:30 -0400 (EDT)
Received: from cam-smtp0.cambridge.arm.com (fw-tnat.cambridge.arm.com
 [217.140.96.140])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6908749B94
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Sep 2016 06:08:30 -0400 (EDT)
In-Reply-To: <1473761769-30572-1-git-send-email-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
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
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
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
