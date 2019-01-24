From: Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 03/14] arm64: KVM: Drop VHE-specific HYP call stub
Date: Thu, 24 Jan 2019 15:00:21 +0100
Message-ID: <20190124140032.8588-4-christoffer.dall@arm.com>
References: <20190124140032.8588-1-christoffer.dall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C55CA4A3A7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XnbpcRMWnqZM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Jan 2019 09:00:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 319B24A403
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Jan 2019 09:00:44 -0500 (EST)
In-Reply-To: <20190124140032.8588-1-christoffer.dall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

We now call VHE code directly, without going through any central
dispatching function. Let's drop that code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
---
 arch/arm64/kvm/hyp.S           |  3 ---
 arch/arm64/kvm/hyp/hyp-entry.S | 12 ------------
 2 files changed, 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 952f6cb9cf72..2845aa680841 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -40,9 +40,6 @@
  * arch/arm64/kernel/hyp_stub.S.
  */
 ENTRY(__kvm_call_hyp)
-alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
 	hvc	#0
 	ret
-alternative_else_nop_endif
-	b	__vhe_hyp_call
 ENDPROC(__kvm_call_hyp)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 73c1b483ec39..2b1e686772bf 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -43,18 +43,6 @@
 	ldr	lr, [sp], #16
 .endm
 
-ENTRY(__vhe_hyp_call)
-	do_el2_call
-	/*
-	 * We used to rely on having an exception return to get
-	 * an implicit isb. In the E2H case, we don't have it anymore.
-	 * rather than changing all the leaf functions, just do it here
-	 * before returning to the rest of the kernel.
-	 */
-	isb
-	ret
-ENDPROC(__vhe_hyp_call)
-
 el1_sync:				// Guest trapped into EL2
 
 	mrs	x0, esr_el2
-- 
2.18.0
