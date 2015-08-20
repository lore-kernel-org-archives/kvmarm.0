From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 24/25] arm64: KVM: Optimize arm64 skip 30-50% vfp/simd save/restore on exits
Date: Thu, 20 Aug 2015 17:29:02 +0100
Message-ID: <1440088143-4722-25-git-send-email-marc.zyngier@arm.com>
References: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440088143-4722-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Mario Smarduch <m.smarduch@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mario Smarduch <m.smarduch@samsung.com>

This patch only saves and restores FP/SIMD registers on Guest access. To do
this cptr_el2 FP/SIMD trap is set on Guest entry and later checked on exit.
lmbench, hackbench show significant improvements, for 30-50% exits FP/SIMD
context is not saved/restored

[chazy/maz: fixed save/restore logic for 32bit guests]

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h |  5 ++-
 arch/arm64/kvm/hyp.S             | 73 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 68 insertions(+), 10 deletions(-)

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
index d93c0a2..8188f6a 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -385,6 +385,14 @@
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
@@ -423,10 +431,12 @@
 	add	x3, x2, #CPU_SYSREG_OFFSET(DACR32_EL2)
 	mrs	x4, dacr32_el2
 	mrs	x5, ifsr32_el2
-	mrs	x6, fpexc32_el2
 	stp	x4, x5, [x3]
-	str	x6, [x3, #16]
 
+	skip_fpsimd_state x8, 3f
+	mrs	x6, fpexc32_el2
+	str	x6, [x3, #16]
+3:
 	skip_debug_state x8, 2f
 	mrs	x7, dbgvcr32_el2
 	str	x7, [x3, #24]
@@ -453,10 +463,8 @@
 
 	add	x3, x2, #CPU_SYSREG_OFFSET(DACR32_EL2)
 	ldp	x4, x5, [x3]
-	ldr	x6, [x3, #16]
 	msr	dacr32_el2, x4
 	msr	ifsr32_el2, x5
-	msr	fpexc32_el2, x6
 
 	skip_debug_state x8, 2f
 	ldr	x7, [x3, #24]
@@ -473,8 +481,22 @@
 
 .macro activate_traps
 	ldr     x2, [x0, #VCPU_HCR_EL2]
+
+	/*
+	 * We are about to set CPTR_EL2.TFP to trap all floating point
+	 * register accesses to EL2, however, the ARM ARM clearly states that
+	 * traps are only taken to EL2 if the operation would not otherwise
+	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
+	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
+	 */
+	tbnz	x2, #HCR_RW_SHIFT, 99f // open code skip_32bit_state
+	mov	x3, #(1 << 30)
+	msr	fpexc32_el2, x3
+	isb
+99:
 	msr     hcr_el2, x2
 	mov	x2, #CPTR_EL2_TTA
+	orr     x2, x2, #CPTR_EL2_TFP
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -488,7 +510,6 @@
 .macro deactivate_traps
 	mov	x2, #HCR_RW
 	msr	hcr_el2, x2
-	msr	cptr_el2, xzr
 	msr	hstr_el2, xzr
 
 	mrs	x2, mdcr_el2
@@ -653,12 +674,41 @@ __restore_debug:
 	ret
 
 __save_fpsimd:
+	skip_fpsimd_state x3, 1f
 	save_fpsimd
-	ret
+1:	ret
 
 __restore_fpsimd:
+	skip_fpsimd_state x3, 1f
 	restore_fpsimd
-	ret
+1:	ret
+
+switch_to_guest_fpsimd:
+	push	x4, lr
+
+	mrs	x2, cptr_el2
+	bic	x2, x2, #CPTR_EL2_TFP
+	msr	cptr_el2, x2
+	isb
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
+	skip_32bit_state x3, 1f
+	ldr	x4, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
+	msr	fpexc32_el2, x4
+1:
+	pop	x4, lr
+	pop	x2, x3
+	pop	x0, x1
+
+	eret
 
 /*
  * u64 __kvm_vcpu_run(struct kvm_vcpu *vcpu);
@@ -680,7 +730,6 @@ ENTRY(__kvm_vcpu_run)
 	kern_hyp_va x2
 
 	save_host_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	compute_debug_state 1f
@@ -697,7 +746,6 @@ ENTRY(__kvm_vcpu_run)
 	add	x2, x0, #VCPU_CONTEXT
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
 
 	skip_debug_state x3, 1f
 	ldr	x3, [x0, #VCPU_DEBUG_PTR]
@@ -740,6 +788,8 @@ __kvm_vcpu_return:
 
 	bl __restore_sysregs
 	bl __restore_fpsimd
+	/* Clear FPSIMD and Trace trapping */
+	msr     cptr_el2, xzr
 
 	skip_debug_state x3, 1f
 	// Clear the dirty flag for the next run, as all the state has
@@ -949,6 +999,11 @@ el1_trap:
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
2.1.4

