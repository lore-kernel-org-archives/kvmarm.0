From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 8/8] arm64: kvm: report original PAR_EL1 upon panic
Date: Tue, 24 Nov 2015 18:35:36 +0100
Message-ID: <1448386536-30118-9-git-send-email-christoffer.dall@linaro.org>
References: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DBA9412D0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NzRtIfqAJyll for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2015 12:34:26 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3598649680
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 12:34:26 -0500 (EST)
Received: by wmww144 with SMTP id w144so36432429wmw.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2015 09:35:24 -0800 (PST)
In-Reply-To: <1448386536-30118-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

If we call __kvm_hyp_panic while a guest context is active, we call
__restore_sysregs before acquiring the system register values for the
panic, in the process throwing away the PAR_EL1 value at the point of
the panic.

This patch modifies __kvm_hyp_panic to stash the PAR_EL1 value prior to
restoring host register values, enabling us to report the original
values at the point of the panic.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp.S | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index ce70817..86c2898 100644
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
2.1.2.330.g565301e.dirty
