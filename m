From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 02/34] arm64: KVM: Move lr save/restore to do_el2_call
Date: Mon,  3 Apr 2017 19:37:35 +0100
Message-ID: <20170403183807.1620-3-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CF4640A66
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EfJ3dP4vfNxC for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:36:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6154B40190
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:24 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

At the moment, we only save/restore lr if on VHE, as we rely only
the EL1 code to have preserved it in the non-VHE case.

As we're about to get rid of the latter, let's move the save/restore
code to the do_el2_call macro, unifying both code paths.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp.S           | 3 ---
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 2726635dceba..f6f20b58d65a 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -38,13 +38,10 @@
  * A function pointer with a value less than 0xfff has a special meaning,
  * and is used to implement __hyp_get_vectors in the same way as in
  * arch/arm64/kernel/hyp_stub.S.
- * HVC behaves as a 'bl' call and will clobber lr.
  */
 ENTRY(__kvm_call_hyp)
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	str     lr, [sp, #-16]!
 	hvc	#0
-	ldr     lr, [sp], #16
 	ret
 alternative_else_nop_endif
 	b	__vhe_hyp_call
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5e9052f087f2..d8ef788646c6 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -32,17 +32,17 @@
 	 * Shuffle the parameters before calling the function
 	 * pointed to in x0. Assumes parameters in x[1,2,3].
 	 */
+	str	lr, [sp, #-16]!
 	mov	lr, x0
 	mov	x0, x1
 	mov	x1, x2
 	mov	x2, x3
 	blr	lr
+	ldr	lr, [sp], #16
 .endm
 
 ENTRY(__vhe_hyp_call)
-	str	lr, [sp, #-16]!
 	do_el2_call
-	ldr	lr, [sp], #16
 	/*
 	 * We used to rely on having an exception return to get
 	 * an implicit isb. In the E2H case, we don't have it anymore.
-- 
2.11.0
