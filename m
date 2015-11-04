From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 17/21] arm64: kvm: restore EL1N SP for panic
Date: Wed,  4 Nov 2015 15:49:56 +0100
Message-ID: <1446648600-27297-18-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 678C149A05
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:50:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hB1HGhlVPGoW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 09:50:05 -0500 (EST)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA6B749A0A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:50:02 -0500 (EST)
Received: by wmeg8 with SMTP id g8so43526403wme.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 06:53:15 -0800 (PST)
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

If we panic in hyp mode, we inject a call to panic() into the EL1N host
kernel. If a guest context is active, we first attempt to restore the
minimal amount of state necessary to execute the host kernel with
restore_sysregs.

However, the SP is restored as part of restore_common_regs, and so we
may return to the host's panic() function with the SP of the guest. Any
calculations based on the SP will be bogus, and any attempt to access
the stack will result in recursive data aborts.

When running Linux as a guest, the guest's EL1N SP is like to be some
valid kernel address. In this case, the host kernel may use that region
as a stack for panic(), corrupting it in the process.

Avoid the problem by restoring the host SP prior to returning to the
host. To prevent misleading backtraces in the host, the FP is zeroed at
the same time. We don't need any of the other "common" registers in
order to panic successfully.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: <kvmarm@lists.cs.columbia.edu>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm64/kvm/hyp.S | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index e583613..1599701 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -880,6 +880,14 @@ __kvm_hyp_panic:
 
 	bl __restore_sysregs
 
+	/*
+	 * Make sure we have a valid host stack, and don't leave junk in the
+	 * frame pointer that will give us a misleading host stack unwinding.
+	 */
+	ldr	x22, [x2, #CPU_GP_REG_OFFSET(CPU_SP_EL1)]
+	msr	sp_el1, x22
+	mov	x29, xzr
+
 1:	adr	x0, __hyp_panic_str
 	adr	x1, 2f
 	ldp	x2, x3, [x1]
-- 
2.1.2.330.g565301e.dirty
