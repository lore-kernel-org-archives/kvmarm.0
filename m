From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 1/2] arm64: KVM: Optimize arm64 skip 30-50% vfp/simd
 save/restore on exits
Date: Thu, 16 Jul 2015 14:29:37 -0700
Message-ID: <1437082178-11039-2-git-send-email-m.smarduch@samsung.com>
References: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC0BA58B89
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 17:18:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kd912qPLgZvz for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Jul 2015 17:18:26 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8641D58B83
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Jul 2015 17:18:26 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRL004T3NQLSL60@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Thu, 16 Jul 2015 17:30:21 -0400 (EDT)
In-reply-to: <1437082178-11039-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch only saves and restores FP/SIMD registers on Guest access. To do
this cptr_el2 FP/SIMD trap is set on Guest entry and later checked on exit.
lmbench, hackbench show significant improvements, for 30-50% exits FP/SIMD
context is not saved/restored

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm64/include/asm/kvm_arm.h |  5 ++++-
 arch/arm64/kvm/hyp.S             | 45 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index ac6fafb..7605e09 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -171,10 +171,13 @@
 #define HSTR_EL2_TTEE	(1 << 16)
 #define HSTR_EL2_T(x)	(1 << x)
 
+/* Hyp Coproccessor Trap Register Shifts */
+#define CPTR_EL2_TFP_SHIFT 10
+
 /* Hyp Coprocessor Trap Register */
 #define CPTR_EL2_TCPAC	(1 << 31)
 #define CPTR_EL2_TTA	(1 << 20)
-#define CPTR_EL2_TFP	(1 << 10)
+#define CPTR_EL2_TFP	(1 << CPTR_EL2_TFP_SHIFT)
 
 /* Hyp Debug Configuration Register bits */
 #define MDCR_EL2_TDRA		(1 << 11)
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 5befd01..e708d5a 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -673,6 +673,14 @@
 	tbz	\tmp, #KVM_ARM64_DEBUG_DIRTY_SHIFT, \target
 .endm
 
+/*
+ * Branch to target if CPTR_EL2.TFP bit is set (VFP/SIMD trapping enabled)
+ */
+.macro skip_fpsimd_state tmp, target
+	mrs	\tmp, cptr_el2
+	tbnz	\tmp, #CPTR_EL2_TFP_SHIFT, \target
+.endm
+
 .macro compute_debug_state target
 	// Compute debug state: If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY
 	// is set, we do a full save/restore cycle and disable trapping.
@@ -763,6 +771,7 @@
 	ldr     x2, [x0, #VCPU_HCR_EL2]
 	msr     hcr_el2, x2
 	mov	x2, #CPTR_EL2_TTA
+	orr     x2, x2, #CPTR_EL2_TFP
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -785,7 +794,6 @@
 .macro deactivate_traps
 	mov	x2, #HCR_RW
 	msr	hcr_el2, x2
-	msr	cptr_el2, xzr
 	msr	hstr_el2, xzr
 
 	mrs	x2, mdcr_el2
@@ -912,6 +920,28 @@ __restore_fpsimd:
 	restore_fpsimd
 	ret
 
+switch_to_guest_fpsimd:
+	push	x4, lr
+
+	mrs	x2, cptr_el2
+	bic	x2, x2, #CPTR_EL2_TFP
+	msr	cptr_el2, x2
+
+	mrs	x0, tpidr_el2
+
+	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
+	kern_hyp_va x2
+	bl __save_fpsimd
+
+	add	x2, x0, #VCPU_CONTEXT
+	bl __restore_fpsimd
+
+	pop	x4, lr
+	pop	x2, x3
+	pop	x0, x1
+
+	eret
+
 /*
  * u64 __kvm_vcpu_run(struct kvm_vcpu *vcpu);
  *
@@ -932,7 +962,6 @@ ENTRY(__kvm_vcpu_run)
 	kern_hyp_va x2
 
 	save_host_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	compute_debug_state 1f
@@ -948,7 +977,6 @@ ENTRY(__kvm_vcpu_run)
 	add	x2, x0, #VCPU_CONTEXT
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
 
 	skip_debug_state x3, 1f
 	bl	__restore_debug
@@ -967,7 +995,9 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
+	skip_fpsimd_state x3, 1f
 	bl __save_fpsimd
+1:
 	bl __save_sysregs
 
 	skip_debug_state x3, 1f
@@ -986,7 +1016,11 @@ __kvm_vcpu_return:
 	kern_hyp_va x2
 
 	bl __restore_sysregs
+	skip_fpsimd_state x3, 1f
 	bl __restore_fpsimd
+1:
+	/* Clear FPSIMD and Trace trapping */
+	msr     cptr_el2, xzr
 
 	skip_debug_state x3, 1f
 	// Clear the dirty flag for the next run, as all the state has
@@ -1201,6 +1235,11 @@ el1_trap:
 	 * x1: ESR
 	 * x2: ESR_EC
 	 */
+
+	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
+	cmp	x2, #ESR_ELx_EC_FP_ASIMD
+	b.eq	switch_to_guest_fpsimd
+
 	cmp	x2, #ESR_ELx_EC_DABT_LOW
 	mov	x0, #ESR_ELx_EC_IABT_LOW
 	ccmp	x2, x0, #4, ne
-- 
1.9.1
