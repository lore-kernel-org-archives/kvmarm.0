From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 1/2] arm64: KVM: Optimize arm64 non-VHE fpsimd skip 30-50%
 save/restore on exits
Date: Fri, 10 Jul 2015 18:19:06 -0700
Message-ID: <1436577547-5646-2-git-send-email-m.smarduch@samsung.com>
References: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E0025861B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 21:07:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qAmckVR3FdSv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2015 21:07:44 -0400 (EDT)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DBF5358619
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2015 21:07:44 -0400 (EDT)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NRA002V7UCCV830@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 10 Jul 2015 21:19:24 -0400 (EDT)
In-reply-to: <1436577547-5646-1-git-send-email-m.smarduch@samsung.com>
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
The non-VHE path has been tested, future work would add VHE support.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm64/include/asm/kvm_arm.h |  5 +++-
 arch/arm64/kvm/hyp.S             | 58 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index c8998c0..0a1d152 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -172,10 +172,13 @@
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
index 64a5280..9d154ed 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -731,6 +731,15 @@ ifnvhe "mrs	\tmp, hcr_el2",			_S_(ldr	\tmp, [x0, #VCPU_HCR_EL2])
 	tbz	\tmp, #KVM_ARM64_DEBUG_DIRTY_SHIFT, \target
 .endm
 
+/*
+ * For non-VHE - branch to target if CPTR_EL2.TFP bit is set (VFP/SIMD trapping
+ * enabled). For VHE do nothing.
+ */
+.macro skip_fpsimd_state tmp, target
+ifnvhe	"mrs     \tmp, cptr_el2",				nop
+ifnvhe	_S_(tbnz    \tmp, #CPTR_EL2_TFP_SHIFT, \target),	nop
+.endm
+
 .macro compute_debug_state target
 	// Compute debug state: If any of KDE, MDE or KVM_ARM64_DEBUG_DIRTY
 	// is set, we do a full save/restore cycle and disable trapping.
@@ -823,7 +832,7 @@ ifnvhe "mrs	\tmp, hcr_el2",			_S_(ldr	\tmp, [x0, #VCPU_HCR_EL2])
 	adr	x3, __kvm_hyp_vector
 ifnvhe	nop,					"msr	vbar_el1, x3"
 ifnvhe	nop,					"mrs	x2, cpacr_el1"
-ifnvhe _S_(ldr	x2, =(CPTR_EL2_TTA)),		"orr x2, x2, #(1 << 28)"
+ifnvhe _S_(ldr	x2, =(CPTR_EL2_TTA|CPTR_EL2_TFP)),	"orr x2, x2, #(1 << 28)"
 ifnvhe "msr	cptr_el2, x2",			"msr	cpacr_el1, x2"
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -851,7 +860,7 @@ ifnvhe 	nop,					_S_(orr	x2, x2, #HCR_E2H)
 ifnvhe	nop,					"mrs	x2, cpacr_el1"
 ifnvhe	nop,					"movn	x3, #(1 << 12), lsl #16"
 ifnvhe	nop,					"and	x2, x2, x3"
-ifnvhe "msr	cptr_el2, xzr",			"msr	cpacr_el1, x2"
+ifnvhe	nop,					"msr    cpacr_el1, x2"
 	msr	hstr_el2, xzr
 
 	mrs	x2, mdcr_el2
@@ -988,6 +997,33 @@ __restore_fpsimd:
 	ret
 
 /*
+ * For non-VHE - on first FP/SIMD access, restore guest, save host registers
+ * and disable future trapping. For VHE this should never get called.
+ */
+switch_to_guest_fpsimd:
+       push    x4, lr
+
+       mrs     x2, cptr_el2
+       bic     x2, x2, #CPTR_EL2_TFP
+       msr     cptr_el2, x2
+
+       mrs     x0, tpidr_el2
+
+       ldr     x2, [x0, #VCPU_HOST_CONTEXT]
+       kern_hyp_va x2
+       bl __save_fpsimd
+
+       add     x2, x0, #VCPU_CONTEXT
+       bl __restore_fpsimd
+
+       pop     x4, lr
+       pop     x2, x3
+       pop     x0, x1
+
+       eret
+
+
+/*
  * u64 __kvm_vcpu_run(struct kvm_vcpu *vcpu);
  *
  * This is the world switch. The first half of the function
@@ -1007,7 +1043,7 @@ ENTRY(__kvm_vcpu_run)
 	kern_hyp_va x2
 
 	save_host_regs
-	bl __save_fpsimd
+ifnvhe	nop,					"bl __save_fpsimd"
 ifnvhe "bl	__save_sysregs",		"nop"
 	bl	__save_shared_sysregs
 
@@ -1025,7 +1061,7 @@ ifnvhe "bl	__save_sysregs",		"nop"
 
 	bl __restore_sysregs
 	bl __restore_shared_sysregs
-	bl __restore_fpsimd
+ifnvhe	"nop",			"bl __restore_fpsimd"
 
 	skip_debug_state x3, 1f
 	bl	__restore_debug
@@ -1044,7 +1080,9 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
+	skip_fpsimd_state x3, 1f
 	bl __save_fpsimd
+1:
 	bl __save_sysregs
 	bl __save_shared_sysregs
 
@@ -1072,7 +1110,11 @@ __kvm_vcpu_return_irq:
 
 ifnvhe "bl	__restore_sysregs",		"nop"
 	bl	__restore_shared_sysregs
+	skip_fpsimd_state x3, 1f
 	bl __restore_fpsimd
+1:
+	/* For non-VHE - Clear FPSIMD and Trace trapping, do nothig for VHE */
+ifnvhe	"msr     cptr_el2, xzr",		"nop"
 
 	skip_debug_state x3, 1f
 	// Clear the dirty flag for the next run, as all the state has
@@ -1298,6 +1340,14 @@ el1_trap:
 	 * x1: ESR
 	 * x2: ESR_EC
 	 */
+
+	/*
+	 * For non-VHE Guest accessed FP/SIMD registers, save host, restore
+	 * guest. For VHE condition should never be true.
+	 */
+	cmp     x2, #ESR_ELx_EC_FP_ASIMD
+	b.eq    switch_to_guest_fpsimd
+
 	cmp	x2, #ESR_ELx_EC_DABT_LOW
 	mov	x0, #ESR_ELx_EC_IABT_LOW
 	ccmp	x2, x0, #4, ne
-- 
1.9.1
