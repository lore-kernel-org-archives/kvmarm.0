From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [RFT - PATCH 2/2] KVM/arm64: enable armv8 fp/simd lazy switch
Date: Mon, 21 Sep 2015 14:26:23 -0700
Message-ID: <1442870783-30752-3-git-send-email-m.smarduch@samsung.com>
References: <1442870783-30752-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E99F48F07
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2015 17:25:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k1PsRbYH1O7m for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Sep 2015 17:25:49 -0400 (EDT)
Received: from usmailout4.samsung.com (mailout4.w2.samsung.com
 [211.189.100.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E062E48EFD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Sep 2015 17:25:49 -0400 (EDT)
Received: from uscpsbgex2.samsung.com
 (u123.gpu85.samsung.co.kr [203.254.195.123]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NV1007E4Q933L40@usmailout4.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 21 Sep 2015 17:27:03 -0400 (EDT)
In-reply-to: <1442870783-30752-1-git-send-email-m.smarduch@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch enables arm64 lazy fp/simd switch. Removes the ARM constraint,
and follows the same approach as armv7 version - found here

https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016518.html  

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/kvm/arm.c   |  2 --
 arch/arm64/kvm/hyp.S | 59 +++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 0acbb69..7260853 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -112,12 +112,10 @@ void kvm_arch_check_processor_compat(void *rtn)
  */
 static void kvm_switch_fp_regs(struct kvm_vcpu *vcpu)
 {
-#ifdef CONFIG_ARM
 	if (vcpu->arch.vfp_lazy == 1) {
 		kvm_call_hyp(__kvm_restore_host_vfp_state, vcpu);
 		vcpu->arch.vfp_lazy = 0;
 	}
-#endif
 }
 
 /**
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 39aa322..e412251 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -385,14 +385,6 @@
 	tbz	\tmp, #KVM_ARM64_DEBUG_DIRTY_SHIFT, \target
 .endm
 
-/*
- * Branch to target if CPTR_EL2.TFP bit is set (VFP/SIMD trapping enabled)
- */
-.macro skip_fpsimd_state tmp, target
-	mrs	\tmp, cptr_el2
-	tbnz	\tmp, #CPTR_EL2_TFP_SHIFT, \target
-.endm
-
 .macro compute_debug_state target
 	// Compute debug state: If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY
 	// is set, we do a full save/restore cycle and disable trapping.
@@ -433,10 +425,6 @@
 	mrs	x5, ifsr32_el2
 	stp	x4, x5, [x3]
 
-	skip_fpsimd_state x8, 3f
-	mrs	x6, fpexc32_el2
-	str	x6, [x3, #16]
-3:
 	skip_debug_state x8, 2f
 	mrs	x7, dbgvcr32_el2
 	str	x7, [x3, #24]
@@ -495,8 +483,14 @@
 	isb
 99:
 	msr     hcr_el2, x2
-	mov	x2, #CPTR_EL2_TTA
+
+	mov     x2, #0
+	ldr     x3, [x0, #VCPU_VFP_LAZY]
+	tbnz    x3, #0, 98f
+
 	orr     x2, x2, #CPTR_EL2_TFP
+98:
+	mov	x2, #CPTR_EL2_TTA
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -674,14 +668,10 @@ __restore_debug:
 	ret
 
 __save_fpsimd:
-	skip_fpsimd_state x3, 1f
 	save_fpsimd
-1:	ret
 
 __restore_fpsimd:
-	skip_fpsimd_state x3, 1f
 	restore_fpsimd
-1:	ret
 
 switch_to_guest_fpsimd:
 	push	x4, lr
@@ -693,6 +683,9 @@ switch_to_guest_fpsimd:
 
 	mrs	x0, tpidr_el2
 
+	mov	x2, #1
+	str	x2, [x0, #VCPU_VFP_LAZY]
+
 	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
 	kern_hyp_va x2
 	bl __save_fpsimd
@@ -768,7 +761,6 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	skip_debug_state x3, 1f
@@ -789,7 +781,6 @@ __kvm_vcpu_return:
 	kern_hyp_va x2
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
 	/* Clear FPSIMD and Trace trapping */
 	msr     cptr_el2, xzr
 
@@ -868,6 +859,36 @@ ENTRY(__kvm_flush_vm_context)
 	ret
 ENDPROC(__kvm_flush_vm_context)
 
+/**
+ * kvm_switch_fp_regs() - switch guest/host VFP/SIMD registers
+ * @vcpu:      pointer to vcpu structure.
+ *
+ */
+ENTRY(__kvm_restore_host_vfp_state)
+	push    x4, lr
+
+	kern_hyp_va x0
+
+	// Load Guest HCR, determine if guest is 32 or 64 bit
+	ldr     x2, [x0, #VCPU_HCR_EL2]
+	msr     hcr_el2, x2
+
+	add	x2, x0, #VCPU_CONTEXT
+
+	skip_32bit_state x3, 1f
+	mrs	x4, fpexc32_el2
+	str	x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
+1:
+	bl __save_fpsimd
+
+	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
+	kern_hyp_va x2
+	bl __restore_fpsimd
+
+	pop	x4, lr
+	ret
+ENDPROC(__kvm_restore_host_vfp_state)
+
 __kvm_hyp_panic:
 	// Guess the context by looking at VTTBR:
 	// If zero, then we're already a host.
-- 
1.9.1
