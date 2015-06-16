From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v2 1/2] arm64: KVM: Optimize arm64 fp/simd save/restore
Date: Tue, 16 Jun 2015 14:50:51 -0700
Message-ID: <1434491452-19177-2-git-send-email-m.smarduch@samsung.com>
References: <1434491452-19177-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <1434491452-19177-1-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, Mario Smarduch <m.smarduch@samsung.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch only saves and restores FP/SIMD registers on Guest access. To do
this cptr_el2 FP/SIMD trap is set on Guest entry and later checked on exit.
lmbench, hackbench show significant improvements, for 30-50% exits FP/SIMD
context is not saved/restored

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm64/include/asm/kvm_arm.h |    5 ++++-
 arch/arm64/kvm/hyp.S             |   46 +++++++++++++++++++++++++++++++++++---
 2 files changed, 47 insertions(+), 4 deletions(-)

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
index 5befd01..de0788f 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -673,6 +673,15 @@
 	tbz	\tmp, #KVM_ARM64_DEBUG_DIRTY_SHIFT, \target
 .endm
 
+/*
+ * Check cptr VFP/SIMD accessed bit, if set VFP/SIMD not accessed by guest.
+ */
+.macro skip_fpsimd_state tmp, target
+	mrs	\tmp, cptr_el2
+	tbnz	\tmp, #CPTR_EL2_TFP_SHIFT, \target
+.endm
+
+
 .macro compute_debug_state target
 	// Compute debug state: If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY
 	// is set, we do a full save/restore cycle and disable trapping.
@@ -763,6 +772,7 @@
 	ldr     x2, [x0, #VCPU_HCR_EL2]
 	msr     hcr_el2, x2
 	mov	x2, #CPTR_EL2_TTA
+	orr     x2, x2, #CPTR_EL2_TFP
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -785,7 +795,6 @@
 .macro deactivate_traps
 	mov	x2, #HCR_RW
 	msr	hcr_el2, x2
-	msr	cptr_el2, xzr
 	msr	hstr_el2, xzr
 
 	mrs	x2, mdcr_el2
@@ -912,6 +921,28 @@ __restore_fpsimd:
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
@@ -932,7 +963,6 @@ ENTRY(__kvm_vcpu_run)
 	kern_hyp_va x2
 
 	save_host_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	compute_debug_state 1f
@@ -948,7 +978,6 @@ ENTRY(__kvm_vcpu_run)
 	add	x2, x0, #VCPU_CONTEXT
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
 
 	skip_debug_state x3, 1f
 	bl	__restore_debug
@@ -967,7 +996,9 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
+	skip_fpsimd_state x3, 1f
 	bl __save_fpsimd
+1:
 	bl __save_sysregs
 
 	skip_debug_state x3, 1f
@@ -986,7 +1017,11 @@ __kvm_vcpu_return:
 	kern_hyp_va x2
 
 	bl __restore_sysregs
+	skip_fpsimd_state x3, 1f
 	bl __restore_fpsimd
+1:
+	/* Clear FPSIMD and Trace trapping */
+	msr     cptr_el2, xzr
 
 	skip_debug_state x3, 1f
 	// Clear the dirty flag for the next run, as all the state has
@@ -1201,6 +1236,11 @@ el1_trap:
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
1.7.9.5

