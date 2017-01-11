From: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH v3 4/5] arm64: Use __tlbi_dsb() macros in KVM code
Date: Wed, 11 Jan 2017 09:41:17 -0500
Message-ID: <20170111144118.17062-4-cov@codeaurora.org>
References: <20170111144118.17062-1-cov@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56B4A405B9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 09:39:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KOZCx4I5xcjK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 09:39:58 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4F889405A7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 09:39:58 -0500 (EST)
In-Reply-To: <20170111144118.17062-1-cov@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, shankerd@codeaurora.org, timur@codeaurora.org
Cc: Jon Masters <jcm@redhat.com>, Mark Langsdorf <mlangsdo@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Refactor the KVM code to use the newly introduced __tlbi_dsb macros, which
will allow an errata workaround that repeats tlbi dsb sequences to only
change one location. This is not intended to change the generated assembly
and comparing before and after vmlinux objdump shows no functional changes.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 arch/arm64/kvm/hyp/tlb.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index 88e2f2b..9669e4b 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -16,6 +16,7 @@
  */
 
 #include <asm/kvm_hyp.h>
+#include <asm/tlbflush.h>
 
 void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 {
@@ -30,19 +31,15 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
 	 * We could do so much better if we had the VA as well.
 	 * Instead, we invalidate Stage-2 for this IPA, and the
 	 * whole of Stage-1. Weep...
+	 *
+	 * We have to ensure completion of the invalidation at Stage-2 with a
+	 * DSB, since a table walk on another CPU could refill a TLB with a
+	 * complete (S1 + S2) walk based on the old Stage-2 mapping if the
+	 * Stage-1 invalidation happened first.
 	 */
 	ipa >>= 12;
-	asm volatile("tlbi ipas2e1is, %0" : : "r" (ipa));
-
-	/*
-	 * We have to ensure completion of the invalidation at Stage-2,
-	 * since a table walk on another CPU could refill a TLB with a
-	 * complete (S1 + S2) walk based on the old Stage-2 mapping if
-	 * the Stage-1 invalidation happened first.
-	 */
-	dsb(ish);
-	asm volatile("tlbi vmalle1is" : : );
-	dsb(ish);
+	__tlbi_dsb(ipas2e1is, ish, ipa);
+	__tlbi_dsb(vmalle1is, ish);
 	isb();
 
 	write_sysreg(0, vttbr_el2);
@@ -57,8 +54,7 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
 	isb();
 
-	asm volatile("tlbi vmalls12e1is" : : );
-	dsb(ish);
+	__tlbi_dsb(vmalls12e1is, ish);
 	isb();
 
 	write_sysreg(0, vttbr_el2);
@@ -72,8 +68,7 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 	write_sysreg(kvm->arch.vttbr, vttbr_el2);
 	isb();
 
-	asm volatile("tlbi vmalle1" : : );
-	dsb(nsh);
+	__tlbi_dsb(vmalle1, nsh);
 	isb();
 
 	write_sysreg(0, vttbr_el2);
@@ -82,7 +77,5 @@ void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
 void __hyp_text __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
-	asm volatile("tlbi alle1is	\n"
-		     "ic ialluis	  ": : );
-	dsb(ish);
+	__tlbi_asm_dsb("ic ialluis", alle1is, ish);
 }
-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc. Qualcomm Technologies, Inc. is a member of the Code Aurora
Forum, a Linux Foundation Collaborative Project.
