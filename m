From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [RFT - PATCH v2 2/2] enable armv8 fp/simd lazy switch
Date: Tue, 22 Sep 2015 16:34:03 -0700
Message-ID: <1442964843-11953-3-git-send-email-m.smarduch@samsung.com>
References: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1442964843-11953-1-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch enables arm64 lazy fp/simd switch. Removes the ARM constraint,
and follows the same approach as armv7 version - found here

https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016518.html

To summarize - provided the guest accesses fp/simd unit we limit number of 
fp/simd context switches to one per vCPU scheduled execution.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/kvm/arm.c               |  2 --
 arch/arm64/include/asm/kvm_asm.h |  1 +
 arch/arm64/kvm/hyp.S             | 58 +++++++++++++++++++++++++++-------------
 3 files changed, 40 insertions(+), 21 deletions(-)

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
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 67fa0de..7d9936b 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -119,6 +119,7 @@ extern char __kvm_hyp_vector[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern void __kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index 39aa322..2273916 100644
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
+	orr     x2, x2, #CPTR_EL2_TTA
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -674,14 +668,12 @@ __restore_debug:
 	ret
 
 __save_fpsimd:
-	skip_fpsimd_state x3, 1f
 	save_fpsimd
-1:	ret
+	ret
 
 __restore_fpsimd:
-	skip_fpsimd_state x3, 1f
 	restore_fpsimd
-1:	ret
+	ret
 
 switch_to_guest_fpsimd:
 	push	x4, lr
@@ -693,6 +685,9 @@ switch_to_guest_fpsimd:
 
 	mrs	x0, tpidr_el2
 
+	mov     x2, #1
+	str     x2, [x0, #VCPU_VFP_LAZY]
+
 	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
 	kern_hyp_va x2
 	bl __save_fpsimd
@@ -768,7 +763,6 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	skip_debug_state x3, 1f
@@ -789,7 +783,6 @@ __kvm_vcpu_return:
 	kern_hyp_va x2
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
 	/* Clear FPSIMD and Trace trapping */
 	msr     cptr_el2, xzr
 
@@ -868,6 +861,33 @@ ENTRY(__kvm_flush_vm_context)
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
+	add     x2, x0, #VCPU_CONTEXT
+
+	// Load Guest HCR, determine if guest is 32 or 64 bit
+	ldr     x3, [x0, #VCPU_HCR_EL2]
+	tbnz	x3, #HCR_RW_SHIFT, 1f
+	mrs     x4, fpexc32_el2
+	str     x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
+1:
+	bl __save_fpsimd
+
+	ldr     x2, [x0, #VCPU_HOST_CONTEXT]
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

