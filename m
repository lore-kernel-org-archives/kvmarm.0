From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v4 2/3] KVM/arm/arm64: enable enhanced armv7 fp/simd lazy
 switch
Date: Sat, 14 Nov 2015 14:12:09 -0800
Message-ID: <1447539130-4613-3-git-send-email-m.smarduch@samsung.com>
References: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEB4A4968B
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 17:12:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pDw3qbUlEZic for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Nov 2015 17:12:14 -0500 (EST)
Received: from usmailout1.samsung.com (mailout1.w2.samsung.com
 [211.189.100.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A695548531
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Nov 2015 17:12:14 -0500 (EST)
Received: from uscpsbgex1.samsung.com
 (u122.gpu85.samsung.co.kr [203.254.195.122]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NXT00KZPSD18230@mailout1.w2.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sat, 14 Nov 2015 17:12:37 -0500 (EST)
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

This patch tracks armv7 fp/simd hardware state with a vcpu lazy flag.
On vcpu_load saves host fpexc and enables FP access, and later enables fp/simd
trapping if lazy flag is not set. On first fp/simd access trap to handler 
to save host and restore guest context, disable trapping and set vcpu lazy 
flag. On vcpu_put if flag is set save guest and restore host context and 
always restore host fpexc.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_host.h   | 33 ++++++++++++++++++++++
 arch/arm/kvm/arm.c                | 12 ++++++++
 arch/arm/kvm/interrupts.S         | 58 +++++++++++++++++++++++----------------
 arch/arm/kvm/interrupts_head.S    | 26 +++++++++++++-----
 arch/arm64/include/asm/kvm_host.h |  6 ++++
 5 files changed, 104 insertions(+), 31 deletions(-)

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index f1bf551..8fc7a59 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -40,6 +40,38 @@
 
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
 
+/*
+ * Reads the host FPEXC register, saves it to vcpu context and enables the
+ * FP/SIMD unit.
+ */
+#ifdef CONFIG_VFPv3
+#define kvm_enable_fpexc(vcpu) {			\
+	u32 fpexc = 0;					\
+	asm volatile(					\
+	"mrc p10, 7, %0, cr8, cr0, 0\n"			\
+	"str %0, [%1]\n"				\
+	"orr %0, %0, #(1 << 30)\n"			\
+	"mcr p10, 7, %0, cr8, cr0, 0\n"			\
+	: "+r" (fpexc)					\
+	: "r" (&vcpu->arch.host_fpexc)			\
+	);						\
+}
+#else
+#define kvm_enable_fpexc(vcpu)
+#endif
+
+/* Restores host FPEXC register */
+#ifdef CONFIG_VFPv3
+#define kvm_restore_host_fpexc(vcpu) {			\
+	asm volatile(					\
+		"mcr p10, 7, %0, cr8, cr0, 0\n"		\
+		: : "r" (vcpu->arch.host_fpexc)		\
+	);						\
+}
+#else
+#define kvm_restore_host_fpexc(vcpu)
+#endif
+
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
@@ -227,6 +259,7 @@ int kvm_perf_teardown(void);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
+void kvm_restore_host_vfp_state(struct kvm_vcpu *);
 
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dc017ad..cfc348a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -291,10 +291,22 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
 
 	kvm_arm_set_running_vcpu(vcpu);
+
+	/* Save and enable FPEXC before we load guest context */
+	kvm_enable_fpexc(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	/* If the fp/simd registers are dirty save guest, restore host. */
+	if (vcpu->arch.vfp_dirty) {
+		kvm_restore_host_vfp_state(vcpu);
+		vcpu->arch.vfp_dirty = 0;
+	}
+
+	/* Restore host FPEXC trashed in vcpu_load */
+	kvm_restore_host_fpexc(vcpu);
+
 	/*
 	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
 	 * if the vcpu is no longer assigned to a cpu.  This is used for the
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 900ef6d..1ddaa89 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -28,6 +28,26 @@
 #include "interrupts_head.S"
 
 	.text
+/**
+ * void kvm_restore_host_vfp_state(struct vcpu *vcpu) -
+ *	This function is called from host to save the guest, and restore host
+ *	fp/simd hardware context. It's placed outside of hyp start/end region.
+ */
+ENTRY(kvm_restore_host_vfp_state)
+#ifdef CONFIG_VFPv3
+	push    {r4-r7}
+
+	add     r7, vcpu, #VCPU_VFP_GUEST
+	store_vfp_state r7
+
+	add     r7, vcpu, #VCPU_VFP_HOST
+	ldr     r7, [r7]
+	restore_vfp_state r7
+
+	pop     {r4-r7}
+#endif
+	bx      lr
+ENDPROC(kvm_restore_host_vfp_state)
 
 __kvm_hyp_code_start:
 	.globl __kvm_hyp_code_start
@@ -116,22 +136,22 @@ ENTRY(__kvm_vcpu_run)
 	read_cp15_state store_to_vcpu = 0
 	write_cp15_state read_from_vcpu = 1
 
+	set_hcptr_bits set, r4, (HCPTR_TTA)
 	@ If the host kernel has not been configured with VFPv3 support,
 	@ then it is safer if we deny guests from using it as well.
 #ifdef CONFIG_VFPv3
-	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
-	VFPFMRX r2, FPEXC		@ VMRS
-	push	{r2}
-	orr	r2, r2, #FPEXC_EN
-	VFPFMXR FPEXC, r2		@ VMSR
+	@ fp/simd register file has already been accessed, so skip trap enable.
+	vfp_skip_if_dirty r7, skip_guest_vfp_trap
+	set_hcptr_bits orr, r4, (HCPTR_TCP(10) | HCPTR_TCP(11))
+skip_guest_vfp_trap:
 #endif
+	set_hcptr vmentry, r4
 
 	@ Configure Hyp-role
 	configure_hyp_role vmentry
 
 	@ Trap coprocessor CRx accesses
 	set_hstr vmentry
-	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
 	set_hdcr vmentry
 
 	@ Write configured ID register into MIDR alias
@@ -170,23 +190,8 @@ __kvm_vcpu_return:
 	@ Don't trap coprocessor accesses for host kernel
 	set_hstr vmexit
 	set_hdcr vmexit
-	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
-
-#ifdef CONFIG_VFPv3
-	@ Switch VFP/NEON hardware state to the host's
-	add	r7, vcpu, #VCPU_VFP_GUEST
-	store_vfp_state r7
-	add	r7, vcpu, #VCPU_VFP_HOST
-	ldr	r7, [r7]
-	restore_vfp_state r7
-
-after_vfp_restore:
-	@ Restore FPEXC_EN which we clobbered on entry
-	pop	{r2}
-	VFPFMXR FPEXC, r2
-#else
-after_vfp_restore:
-#endif
+	set_hcptr_bits clear, r4, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
+	set_hcptr vmexit, r4
 
 	@ Reset Hyp-role
 	configure_hyp_role vmexit
@@ -483,7 +488,12 @@ switch_to_guest_vfp:
 	push	{r3-r7}
 
 	@ NEON/VFP used.  Turn on VFP access.
-	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
+	set_hcptr_bits clear, r4, (HCPTR_TCP(10) | HCPTR_TCP(11))
+	set_hcptr vmtrap, r4
+
+	@ set lazy mode flag, switch hardware context on vcpu_put
+	mov     r1, #1
+	strb    r1, [vcpu, #VCPU_VFP_DIRTY]
 
 	@ Switch VFP/NEON hardware state to the guest's
 	add	r7, r0, #VCPU_VFP_HOST
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 51a5950..b2b698e 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -589,16 +589,24 @@ ARM_BE8(rev	r6, r6  )
 	mcr	p15, 4, r2, c1, c1, 3
 .endm
 
+/* Prepares HCPTR bit mask to set, clear or 'orr' bits */
+.macro set_hcptr_bits op, reg, mask
+	.if     \op == set || \op == clear
+	ldr     \reg, =\mask
+	.else
+	orr     \reg, \reg, #\mask
+	.endif
+.endm
+
+
 /* Configures the HCPTR (Hyp Coprocessor Trap Register) on entry/return
  * (hardware reset value is 0). Keep previous value in r2.
  * An ISB is emited on vmexit/vmtrap, but executed on vmexit only if
  * VFP wasn't already enabled (always executed on vmtrap).
- * If a label is specified with vmexit, it is branched to if VFP wasn't
- * enabled.
  */
-.macro set_hcptr operation, mask, label = none
+.macro set_hcptr operation, mask
 	mrc	p15, 4, r2, c1, c1, 2
-	ldr	r3, =\mask
+	mov	r3, \mask
 	.if \operation == vmentry
 	orr	r3, r2, r3		@ Trap coproc-accesses defined in mask
 	.else
@@ -611,13 +619,17 @@ ARM_BE8(rev	r6, r6  )
 	beq	1f
 	.endif
 	isb
-	.if \label != none
-	b	\label
-	.endif
 1:
 	.endif
 .endm
 
+/* Checks if VFP/SIMD dirty flag is set, if it is branch to label. */
+.macro vfp_skip_if_dirty, reg, label
+	ldr	\reg, [vcpu, #VCPU_VFP_DIRTY]
+	cmp	\reg, #1
+	beq	\label
+.endm
+
 /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
  * (hardware reset value is 0) */
 .macro set_hdcr operation
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4562459..83e65dd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -157,6 +157,9 @@ struct kvm_vcpu_arch {
 	/* Interrupt related fields */
 	u64 irq_lines;		/* IRQ and FIQ levels */
 
+	/* fp/simd dirty flag true if guest accessed register file */
+	bool    vfp_dirty;
+
 	/* Cache some mmu pages needed inside spinlock regions */
 	struct kvm_mmu_memory_cache mmu_page_cache;
 
@@ -248,6 +251,9 @@ static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_enable_fpexc(struct kvm_vcpu *vcpu) {}
+static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
+static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
-- 
1.9.1
