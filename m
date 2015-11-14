From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 3/3] KVM/arm/arm64: enable enhanced armv8 fp/simd lazy
 switch
Date: Sat, 14 Nov 2015 14:12:10 -0800
Message-ID: <1447539130-4613-4-git-send-email-m.smarduch@samsung.com>
References: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58A114968B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 17:12:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lnfqxaAQonZ8 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Nov 2015 17:12:21 -0500 (EST)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31944496EC
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 17:12:21 -0500 (EST)
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NXT00I3OSD7XQ40@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 14 Nov 2015 17:12:43 -0500 (EST)
In-reply-to: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com>
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

This patch tracks armv7 and armv8 fp/simd hardware state with a vcpu lazy flag.
On vcpu_load for 32 bit guests enable FP access, and later enable fp/simd
trapping for 32 and 64 bit guests if lazy flag is not set. On first fp/simd 
access trap to handler to save host and restore guest context, disable 
trapping and set vcpu lazy flag. On vcpu_put if flag is set save guest and 
restore host context and also save guest fpexc register.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_host.h   |  3 ++
 arch/arm/kvm/arm.c                | 18 +++++++--
 arch/arm64/include/asm/kvm_asm.h  |  2 +
 arch/arm64/include/asm/kvm_host.h | 17 +++++++-
 arch/arm64/kernel/asm-offsets.c   |  1 +
 arch/arm64/kvm/hyp.S              | 83 +++++++++++++++++++++++++--------------
 6 files changed, 89 insertions(+), 35 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 8fc7a59..6960ff2 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -40,6 +40,8 @@
 
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
 
+#define kvm_guest_is32bit(vcpu)	true
+
 /*
  * Reads the host FPEXC register, saves to vcpu context and enables the
  * FPEXC.
@@ -260,6 +262,7 @@ void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
 void kvm_restore_host_vfp_state(struct kvm_vcpu *);
+static inline void kvm_save_guest_fpexc(struct kvm_vcpu *vcpu) {}
 
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index cfc348a..7a20530 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -292,8 +292,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_arm_set_running_vcpu(vcpu);
 
-	/* Save and enable FPEXC before we load guest context */
-	kvm_enable_fpexc(vcpu);
+	/*
+	 * For 32bit guest executing on arm64, enable fp/simd access in
+	 * EL2. On arm32 save host fpexc and then enable fp/simd access.
+	 */
+	if (kvm_guest_is32bit(vcpu))
+		kvm_enable_fpexc(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -301,10 +305,18 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	/* If the fp/simd registers are dirty save guest, restore host. */
 	if (vcpu->arch.vfp_dirty) {
 		kvm_restore_host_vfp_state(vcpu);
+
+		/*
+		 * For 32bit guest on arm64 save the guest fpexc register
+		 * in EL2 mode.
+		 */
+		if (kvm_guest_is32bit(vcpu))
+			kvm_save_guest_fpexc(vcpu);
+
 		vcpu->arch.vfp_dirty = 0;
 	}
 
-	/* Restore host FPEXC trashed in vcpu_load */
+	/* For arm32 restore host FPEXC trashed in vcpu_load. */
 	kvm_restore_host_fpexc(vcpu);
 
 	/*
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5e37710..c589ca9 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -117,6 +117,8 @@ extern char __kvm_hyp_vector[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern void __kvm_enable_fpexc32(void);
+extern void __kvm_save_fpexc32(struct kvm_vcpu *vcpu);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 83e65dd..6e2d6b5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -41,6 +41,8 @@
 
 #define KVM_VCPU_MAX_FEATURES 3
 
+#define kvm_guest_is32bit(vcpu)	(!(vcpu->arch.hcr_el2 & HCR_RW))
+
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
 int kvm_arch_dev_ioctl_check_extension(long ext);
@@ -251,9 +253,20 @@ static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
-static inline void kvm_enable_fpexc(struct kvm_vcpu *vcpu) {}
-static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
+
+static inline void kvm_enable_fpexc(struct kvm_vcpu *vcpu)
+{
+	/* Enable FP/SIMD access from EL2 mode*/
+	kvm_call_hyp(__kvm_enable_fpexc32);
+}
+
+static inline void kvm_save_guest_fpexc(struct kvm_vcpu *vcpu)
+{
+	/* Save FPEXEC32_EL2 in EL2 mode */
+	kvm_call_hyp(__kvm_save_fpexc32, vcpu);
+}
 static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
+void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
 
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 8d89cf8..c9c5242 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -124,6 +124,7 @@ int main(void)
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
+  DEFINE(VCPU_VFP_DIRTY,	offsetof(struct kvm_vcpu, arch.vfp_dirty));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
   DEFINE(VCPU_HOST_DEBUG_STATE, offsetof(struct kvm_vcpu, arch.host_debug_state));
   DEFINE(VCPU_TIMER_CNTV_CTL,	offsetof(struct kvm_vcpu, arch.timer_cpu.cntv_ctl));
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index e583613..06efb93 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -36,6 +36,23 @@
 #define CPU_SYSREG_OFFSET(x)	(CPU_SYSREGS + 8*x)
 
 	.text
+/**
+ * void kvm_restore_host_vfp_state(struct vcpu *vcpu) -
+ *	This function saves the guest, restores host, called from host.
+ */
+ENTRY(kvm_restore_host_vfp_state)
+	push	xzr, lr
+
+	add	x2, x0, #VCPU_CONTEXT
+	bl __save_fpsimd
+
+	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
+	bl __restore_fpsimd
+
+	pop	xzr, lr
+	ret
+ENDPROC(kvm_restore_host_vfp_state)
+
 	.pushsection	.hyp.text, "ax"
 	.align	PAGE_SHIFT
 
@@ -385,14 +402,6 @@
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
@@ -433,10 +442,6 @@
 	mrs	x5, ifsr32_el2
 	stp	x4, x5, [x3]
 
-	skip_fpsimd_state x8, 2f
-	mrs	x6, fpexc32_el2
-	str	x6, [x3, #16]
-2:
 	skip_debug_state x8, 1f
 	mrs	x7, dbgvcr32_el2
 	str	x7, [x3, #24]
@@ -468,21 +473,13 @@
 .macro activate_traps
 	ldr     x2, [x0, #VCPU_HCR_EL2]
 
-	/*
-	 * We are about to set CPTR_EL2.TFP to trap all floating point
-	 * register accesses to EL2, however, the ARM ARM clearly states that
-	 * traps are only taken to EL2 if the operation would not otherwise
-	 * trap to EL1.  Therefore, always make sure that for 32-bit guests,
-	 * we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
-	 */
-	tbnz	x2, #HCR_RW_SHIFT, 99f // open code skip_32bit_state
-	mov	x3, #(1 << 30)
-	msr	fpexc32_el2, x3
-	isb
-99:
 	msr     hcr_el2, x2
 	mov	x2, #CPTR_EL2_TTA
+
+	ldrb    w3, [x0, #VCPU_VFP_DIRTY]
+	tbnz    w3, #0, 98f
 	orr     x2, x2, #CPTR_EL2_TFP
+98:
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -669,14 +666,12 @@ __restore_debug:
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
@@ -688,6 +683,9 @@ switch_to_guest_fpsimd:
 
 	mrs	x0, tpidr_el2
 
+	mov	w2, #1
+	strb    w2, [x0, #VCPU_VFP_DIRTY]
+
 	ldr	x2, [x0, #VCPU_HOST_CONTEXT]
 	kern_hyp_va x2
 	bl __save_fpsimd
@@ -763,7 +761,6 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	skip_debug_state x3, 1f
@@ -784,7 +781,6 @@ __kvm_vcpu_return:
 	kern_hyp_va x2
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
 	/* Clear FPSIMD and Trace trapping */
 	msr     cptr_el2, xzr
 
@@ -863,6 +859,33 @@ ENTRY(__kvm_flush_vm_context)
 	ret
 ENDPROC(__kvm_flush_vm_context)
 
+/**
+ * void __kvm_enable_fpexc32(void) -
+ *	We may be entering the guest and set CPTR_EL2.TFP to trap all floating
+ *	point register accesses to EL2, however, the ARM manual clearly states
+ *	that traps are only taken to EL2 if the operation would not otherwise
+ *	trap to EL1.  Therefore, always make sure that for 32-bit guests,
+ *	we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
+ */
+ENTRY(__kvm_enable_fpexc32)
+	mov	x3, #(1 << 30)
+	msr	fpexc32_el2, x3
+	ret
+ENDPROC(__kvm_enable_fpexc32)
+
+/**
+ * void __kvm_save_fpexc32(void) -
+ *	This function restores guest FPEXC to its vcpu context, we call this
+ *	function from vcpu_put.
+ */
+ENTRY(__kvm_save_fpexc32)
+	kern_hyp_va x0
+	add     x2, x0, #VCPU_CONTEXT
+	mrs     x1, fpexc32_el2
+	str     x1, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
+	ret
+ENDPROC(__kvm_save_fpexc32)
+
 __kvm_hyp_panic:
 	// Guess the context by looking at VTTBR:
 	// If zero, then we're already a host.
-- 
1.9.1
