From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 07/23] arm64: KVM: VHE: Patch out use of HVC
Date: Thu, 11 Feb 2016 18:39:48 +0000
Message-ID: <1455216004-19499-8-git-send-email-marc.zyngier@arm.com>
References: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA8249C05
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mABd19sobQGS for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Feb 2016 13:34:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2473449BED
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Feb 2016 13:34:25 -0500 (EST)
In-Reply-To: <1455216004-19499-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

With VHE, the host never issues an HVC instruction to get into the
KVM code, as we can simply branch there.

Use runtime code patching to simplify things a bit.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp.S           |  7 +++++++
 arch/arm64/kvm/hyp/hyp-entry.S | 40 +++++++++++++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 0ccdcbb..0689a74 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -17,7 +17,9 @@
 
 #include <linux/linkage.h>
 
+#include <asm/alternative.h>
 #include <asm/assembler.h>
+#include <asm/cpufeature.h>
 
 /*
  * u64 kvm_call_hyp(void *hypfn, ...);
@@ -38,6 +40,11 @@
  * arch/arm64/kernel/hyp_stub.S.
  */
 ENTRY(kvm_call_hyp)
+alternative_if_not ARM64_HAS_VIRT_HOST_EXTN	
 	hvc	#0
 	ret
+alternative_else
+	b	__vhe_hyp_call
+	nop
+alternative_endif
 ENDPROC(kvm_call_hyp)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 93e8d983..1bdeee7 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -38,6 +38,34 @@
 	ldp	x0, x1, [sp], #16
 .endm
 
+.macro do_el2_call
+	/*
+	 * Shuffle the parameters before calling the function
+	 * pointed to in x0. Assumes parameters in x[1,2,3].
+	 */
+	sub	sp, sp, #16
+	str	lr, [sp]
+	mov	lr, x0
+	mov	x0, x1
+	mov	x1, x2
+	mov	x2, x3
+	blr	lr
+	ldr	lr, [sp]
+	add	sp, sp, #16
+.endm
+
+ENTRY(__vhe_hyp_call)
+	do_el2_call
+	/*
+	 * We used to rely on having an exception return to get
+	 * an implicit isb. In the E2H case, we don't have it anymore.
+	 * rather than changing all the leaf functions, just do it here
+	 * before returning to the rest of the kernel.
+	 */
+	isb
+	ret
+ENDPROC(__vhe_hyp_call)
+	
 el1_sync:				// Guest trapped into EL2
 	save_x0_to_x3
 
@@ -58,19 +86,13 @@ el1_sync:				// Guest trapped into EL2
 	mrs	x0, vbar_el2
 	b	2f
 
-1:	stp	lr, xzr, [sp, #-16]!
-
+1:
 	/*
-	 * Compute the function address in EL2, and shuffle the parameters.
+	 * Perform the EL2 call
 	 */
 	kern_hyp_va	x0
-	mov	lr, x0
-	mov	x0, x1
-	mov	x1, x2
-	mov	x2, x3
-	blr	lr
+	do_el2_call
 
-	ldp	lr, xzr, [sp], #16
 2:	eret
 
 el1_trap:
-- 
2.1.4
