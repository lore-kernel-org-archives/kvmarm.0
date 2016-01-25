From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 15/27] ARM: KVM: Add VFP lazy save/restore handler
Date: Mon, 25 Jan 2016 16:38:31 +0000
Message-ID: <1453739923-17846-16-git-send-email-marc.zyngier@arm.com>
References: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4367040B58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:34:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1vhCNIoyUZLl for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jan 2016 11:34:18 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 863F54852E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jan 2016 11:34:14 -0500 (EST)
In-Reply-To: <1453739923-17846-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Similar to the arm64 version, add the code that deals with VFP traps,
re-enabling VFP, save/restoring the registers and resuming the guest.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/hyp/entry.S | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/kvm/hyp/entry.S b/arch/arm/kvm/hyp/entry.S
index 32f79b0..21c2388 100644
--- a/arch/arm/kvm/hyp/entry.S
+++ b/arch/arm/kvm/hyp/entry.S
@@ -66,5 +66,36 @@ ENTRY(__guest_exit)
 	bx	lr
 ENDPROC(__guest_exit)
 
+/*
+ * If VFPv3 support is not available, then we will not switch the VFP
+ * registers; however cp10 and cp11 accesses will still trap and fallback
+ * to the regular coprocessor emulation code, which currently will
+ * inject an undefined exception to the guest.
+ */
+#ifdef CONFIG_VFPv3
+ENTRY(__vfp_guest_restore)
+	push	{r3, r4, lr}
+
+	@ NEON/VFP used.  Turn on VFP access.
+	mrc	p15, 4, r1, c1, c1, 2		@ HCPTR
+	bic	r1, r1, #(HCPTR_TCP(10) | HCPTR_TCP(11))
+	mcr	p15, 4, r1, c1, c1, 2		@ HCPTR
+	isb
+
+	@ Switch VFP/NEON hardware state to the guest's
+	mov	r4, r0
+	ldr	r0, [r0, #VCPU_HOST_CTXT]
+	add	r0, r0, #CPU_CTXT_VFP
+	bl	__vfp_save_state
+	add	r0, r4, #(VCPU_GUEST_CTXT + CPU_CTXT_VFP)
+	bl	__vfp_restore_state
+
+	pop	{r3, r4, lr}
+	pop	{r0, r1, r2}
+	clrex
+	eret
+ENDPROC(__vfp_guest_restore)
+#endif
+
 	.popsection
 
-- 
2.1.4
