From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/3] arm64: KVM: Drop VHE-specific HYP call stub
Date: Wed,  9 Jan 2019 13:54:35 +0000
Message-ID: <20190109135435.178664-4-marc.zyngier@arm.com>
References: <20190109135435.178664-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C360D4A36C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 08:54:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u-SrYSklnVsb for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Jan 2019 08:54:56 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7492E4A460
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Jan 2019 08:54:56 -0500 (EST)
In-Reply-To: <20190109135435.178664-1-marc.zyngier@arm.com>
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
List-Id: kvmarm@lists.cs.columbia.edu

We now call VHE code directly, without going through any central
dispatching function. Let's drop that code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
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
2.20.1
