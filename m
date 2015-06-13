From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH] arm64: KVM: Optimize arm64 guest exit VFP/SIMD register
 save/restore
Date: Sat, 13 Jun 2015 15:20:52 -0700
Message-ID: <557CACC4.8040405@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E42B454F07
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Jun 2015 18:10:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tJ5GWsCDWXyy for <kvmarm@lists.cs.columbia.edu>;
 Sat, 13 Jun 2015 18:10:41 -0400 (EDT)
Received: from usmailout2.samsung.com (mailout2.w2.samsung.com
 [211.189.100.12])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D5C3354EED
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Jun 2015 18:10:41 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NPW00DTCM39CL20@mailout2.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 13 Jun 2015 18:21:09 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Currently VFP/SIMD registers are always saved and restored
on Guest entry and exit.

This patch only saves and restores VFP/SIMD registers on
Guest access. To do this cptr_el2 VFP/SIMD trap is set
on Guest entry and later checked on exit. This follows
the ARMv7 VFPv3 implementation. Running an informal test
there are high number of exits that don't access VFP/SIMD
registers.

Tested on FVP Model, executed threads on host and
Guest accessing VFP/SIMD registers resulting in consistent
results.


Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm64/include/asm/kvm_arm.h |  5 +++-
 arch/arm64/kvm/hyp.S             | 57
+++++++++++++++++++++++++++++++++++++---
 2 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h
b/arch/arm64/include/asm/kvm_arm.h
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
index 5befd01..b3044b4 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -673,6 +673,24 @@
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
+/*
+ * Check cptr VFP/SIMD accessed bit if set, VFP/SIMD not accessed by guest.
+ * Also disable all cptr traps on return to host.
+ */
+.macro skip_fpsimd_state_reset tmp, target
+	mrs	\tmp, cptr_el2
+	msr	cptr_el2, xzr
+	tbnz	\tmp, #CPTR_EL2_TFP_SHIFT, \target
+.endm
+
 .macro compute_debug_state target
 	// Compute debug state: If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY
 	// is set, we do a full save/restore cycle and disable trapping.
@@ -763,6 +781,7 @@
 	ldr     x2, [x0, #VCPU_HCR_EL2]
 	msr     hcr_el2, x2
 	mov	x2, #CPTR_EL2_TTA
+	orr	x2, x2, #CPTR_EL2_TFP
 	msr	cptr_el2, x2

 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -785,7 +804,6 @@
 .macro deactivate_traps
 	mov	x2, #HCR_RW
 	msr	hcr_el2, x2
-	msr	cptr_el2, xzr
 	msr	hstr_el2, xzr

 	mrs	x2, mdcr_el2
@@ -911,6 +929,30 @@ __save_fpsimd:
 __restore_fpsimd:
 	restore_fpsimd
 	ret
+/*
+ * On Guest VFP/SIMD access, switch Guest/Host registers and reset cptr
access
+ * bit to disable trapping.
+ */
+switch_to_guest_vfp:
+	ldr	x2, =(CPTR_EL2_TTA)
+	msr	cptr_el2, x2
+
+	mrs	x0, tpidr_el2
+
+	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
+	kern_hyp_va x2
+
+	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
+	fpsimd_save x3, 1
+
+	add	x2, x0, #VCPU_CONTEXT
+	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
+	fpsimd_restore x3, 1
+
+	pop	x2, x3
+	pop	x0, x1
+
+	eret

 /*
  * u64 __kvm_vcpu_run(struct kvm_vcpu *vcpu);
@@ -932,7 +974,6 @@ ENTRY(__kvm_vcpu_run)
 	kern_hyp_va x2

 	save_host_regs
-	bl __save_fpsimd
 	bl __save_sysregs

 	compute_debug_state 1f
@@ -948,7 +989,6 @@ ENTRY(__kvm_vcpu_run)
 	add	x2, x0, #VCPU_CONTEXT

 	bl __restore_sysregs
-	bl __restore_fpsimd

 	skip_debug_state x3, 1f
 	bl	__restore_debug
@@ -967,7 +1007,9 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT

 	save_guest_regs
+	skip_fpsimd_state x3, 1f
 	bl __save_fpsimd
+1:
 	bl __save_sysregs

 	skip_debug_state x3, 1f
@@ -986,8 +1028,11 @@ __kvm_vcpu_return:
 	kern_hyp_va x2

 	bl __restore_sysregs
-	bl __restore_fpsimd

+	/* Disable cptr VFP/SIMD access bit, skip restore if VFP not accessed */
+	skip_fpsimd_state_reset x3, 1f
+	bl __restore_fpsimd
+1:
 	skip_debug_state x3, 1f
 	// Clear the dirty flag for the next run, as all the state has
 	// already been saved. Note that we nuke the whole 64bit word.
@@ -1166,6 +1211,10 @@ el1_sync:					// Guest trapped into EL2
 	mrs	x1, esr_el2
 	lsr	x2, x1, #ESR_ELx_EC_SHIFT

+	/* Guest accessed VFP/SIMD registers, save host, restore Guest */
+	cmp	x2, #ESR_ELx_EC_FP_ASIMD
+	b.eq	switch_to_guest_vfp
+
 	cmp	x2, #ESR_ELx_EC_HVC64
 	b.ne	el1_trap

-- 
1.9.1
