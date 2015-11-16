From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] arm64: kvm: report original PAR_EL1 upon panic
Date: Mon, 16 Nov 2015 13:58:29 +0000
Message-ID: <1447682309-5875-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BADDF498E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:58:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HahoNySuTc6N for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Nov 2015 08:58:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABD10498E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Nov 2015 08:58:11 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If we call __kvm_hyp_panic while a guest context is active, we call
__restore_sysregs before acquiring the system register values for the
panic, in the process throwing away the PAR_EL1 value at the point of
the panic.

This patch modifies __kvm_hyp_panic to stash the PAR_EL1 value prior to
restoring host register values, enabling us to report the original
values at the point of the panic.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 11183ce..2a8a4aa 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -864,6 +864,10 @@ ENTRY(__kvm_flush_vm_context)
 ENDPROC(__kvm_flush_vm_context)
 
 __kvm_hyp_panic:
+	// Stash PAR_EL1 before corrupting it in __restore_sysregs
+	mrs	x0, par_el1
+	push	x0, xzr
+
 	// Guess the context by looking at VTTBR:
 	// If zero, then we're already a host.
 	// Otherwise restore a minimal host context before panicing.
@@ -898,7 +902,7 @@ __kvm_hyp_panic:
 	mrs	x3, esr_el2
 	mrs	x4, far_el2
 	mrs	x5, hpfar_el2
-	mrs	x6, par_el1
+	pop	x6, xzr		// active context PAR_EL1
 	mrs	x7, tpidr_el2
 
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
-- 
1.9.1
