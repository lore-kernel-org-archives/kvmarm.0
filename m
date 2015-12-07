From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v5 2/3] KVM/arm/arm64: enable enhanced armv7 fp/simd lazy
 switch
Date: Sun, 06 Dec 2015 17:07:13 -0800
Message-ID: <1449450434-2929-3-git-send-email-m.smarduch@samsung.com>
References: <1449450434-2929-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9215740FA7
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Dec 2015 20:06:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aW3eHYA0YlVC for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Dec 2015 20:06:28 -0500 (EST)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E9D4412D0
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Dec 2015 20:06:28 -0500 (EST)
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYY00FDYR5PT980@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sun, 06 Dec 2015 20:08:13 -0500 (EST)
In-reply-to: <1449450434-2929-1-git-send-email-m.smarduch@samsung.com>
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

This patch tracks armv7 fp/simd hardware state with hcptr register.
On vcpu_load saves host fpexc, enables FP access, and sets trapping
on fp/simd access. On first fp/simd access trap to handler to save host and 
restore guest context, clear trapping bits to enable vcpu lazy mode. On 
vcpu_put if trap bits are cleared save guest and restore host context and 
always restore host fpexc.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_emulate.h   | 50 ++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/kvm_host.h      |  1 +
 arch/arm/kvm/Makefile                |  2 +-
 arch/arm/kvm/arm.c                   | 13 ++++++++++
 arch/arm/kvm/fpsimd_switch.S         | 46 +++++++++++++++++++++++++++++++++
 arch/arm/kvm/interrupts.S            | 32 +++++------------------
 arch/arm/kvm/interrupts_head.S       | 33 ++++++++++--------------
 arch/arm64/include/asm/kvm_emulate.h |  9 +++++++
 arch/arm64/include/asm/kvm_host.h    |  1 +
 9 files changed, 142 insertions(+), 45 deletions(-)
 create mode 100644 arch/arm/kvm/fpsimd_switch.S

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index a9c80a2..3de11a2 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -243,4 +243,54 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	}
 }
 
+#ifdef CONFIG_VFPv3
+/* Called from vcpu_load - save fpexc and enable guest access to fp/simd unit */
+static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu)
+{
+	u32 fpexc;
+
+	asm volatile(
+	 "mrc p10, 7, %0, cr8, cr0, 0\n"
+	 "str %0, [%1]\n"
+	 "mov %0, #(1 << 30)\n"
+	 "mcr p10, 7, %0, cr8, cr0, 0\n"
+	 "isb\n"
+	 : "+r" (fpexc)
+	 : "r" (&vcpu->arch.host_fpexc)
+	);
+}
+
+/* Called from vcpu_put - restore host fpexc */
+static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu)
+{
+	asm volatile(
+	 "mcr p10, 7, %0, cr8, cr0, 0\n"
+	 :
+	 : "r" (vcpu->arch.host_fpexc)
+	);
+}
+
+/* If trap bits are reset then fp/simd registers are dirty */
+static inline bool kvm_vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
+{
+	return !!(~vcpu->arch.hcptr & (HCPTR_TCP(10) | HCPTR_TCP(11)));
+}
+
+static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcptr |= (HCPTR_TTA | HCPTR_TCP(10)  | HCPTR_TCP(11));
+}
+#else
+static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu) {}
+static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcptr = HCPTR_TTA;
+}
+#endif
+
 #endif /* __ARM_KVM_EMULATE_H__ */
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 09bb1f2..ecc883a 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -227,6 +227,7 @@ int kvm_perf_teardown(void);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
+void kvm_restore_host_vfp_state(struct kvm_vcpu *);
 
 static inline void kvm_arch_hardware_disable(void) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index c5eef02c..411b3e4 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -19,7 +19,7 @@ kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vf
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
-obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
+obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o fpsimd_switch.o
 obj-y += $(KVM)/arm/vgic.o
 obj-y += $(KVM)/arm/vgic-v2.o
 obj-y += $(KVM)/arm/vgic-v2-emul.o
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index dc017ad..1de07ab 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -291,10 +291,23 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
 
 	kvm_arm_set_running_vcpu(vcpu);
+
+	/*  Save and enable FPEXC before we load guest context */
+	kvm_enable_vcpu_fpexc(vcpu);
+
+	/* reset hyp cptr register to trap on tracing and vfp/simd access*/
+	vcpu_reset_cptr(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	/* If the fp/simd registers are dirty save guest, restore host. */
+	if (kvm_vcpu_vfp_isdirty(vcpu))
+		kvm_restore_host_vfp_state(vcpu);
+
+	/* Restore host FPEXC trashed in vcpu_load */
+	kvm_restore_host_fpexc(vcpu);
+
 	/*
 	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
 	 * if the vcpu is no longer assigned to a cpu.  This is used for the
diff --git a/arch/arm/kvm/fpsimd_switch.S b/arch/arm/kvm/fpsimd_switch.S
new file mode 100644
index 0000000..d297c54
--- /dev/null
+++ b/arch/arm/kvm/fpsimd_switch.S
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2012 - Virtual Open Systems and Columbia University
+ * Author: Christoffer Dall <c.dall@virtualopensystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#include <linux/linkage.h>
+#include <linux/const.h>
+#include <asm/unified.h>
+#include <asm/page.h>
+#include <asm/ptrace.h>
+#include <asm/asm-offsets.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_arm.h>
+#include <asm/vfpmacros.h>
+#include "interrupts_head.S"
+
+	.text
+/**
+  * void kvm_restore_host_vfp_state(struct vcpu *vcpu) -
+  *     This function is called from host to save the guest, and restore host
+  *     fp/simd hardware context. It's placed outside of hyp start/end region.
+  */
+ENTRY(kvm_restore_host_vfp_state)
+#ifdef CONFIG_VFPv3
+	push	{r4-r7}
+
+	add	r7, r0, #VCPU_VFP_GUEST
+	store_vfp_state r7
+
+	add	r7, r0, #VCPU_VFP_HOST
+	ldr	r7, [r7]
+	restore_vfp_state r7
+
+	pop	{r4-r7}
+#endif
+	bx	lr
+ENDPROC(kvm_restore_host_vfp_state)
diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
index 900ef6d..8e25431 100644
--- a/arch/arm/kvm/interrupts.S
+++ b/arch/arm/kvm/interrupts.S
@@ -116,22 +116,15 @@ ENTRY(__kvm_vcpu_run)
 	read_cp15_state store_to_vcpu = 0
 	write_cp15_state read_from_vcpu = 1
 
-	@ If the host kernel has not been configured with VFPv3 support,
-	@ then it is safer if we deny guests from using it as well.
-#ifdef CONFIG_VFPv3
-	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
-	VFPFMRX r2, FPEXC		@ VMRS
-	push	{r2}
-	orr	r2, r2, #FPEXC_EN
-	VFPFMXR FPEXC, r2		@ VMSR
-#endif
+	@ Enable tracing and possibly fp/simd trapping
+	ldr r4, [vcpu, #VCPU_HCPTR]
+	set_hcptr vmentry, #0, r4
 
 	@ Configure Hyp-role
 	configure_hyp_role vmentry
 
 	@ Trap coprocessor CRx accesses
 	set_hstr vmentry
-	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
 	set_hdcr vmentry
 
 	@ Write configured ID register into MIDR alias
@@ -170,23 +163,12 @@ __kvm_vcpu_return:
 	@ Don't trap coprocessor accesses for host kernel
 	set_hstr vmexit
 	set_hdcr vmexit
-	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
 
-#ifdef CONFIG_VFPv3
-	@ Switch VFP/NEON hardware state to the host's
-	add	r7, vcpu, #VCPU_VFP_GUEST
-	store_vfp_state r7
-	add	r7, vcpu, #VCPU_VFP_HOST
-	ldr	r7, [r7]
-	restore_vfp_state r7
+	/* Preserve HCPTR across exits */
+	mrc     p15, 4, r2, c1, c1, 2
+	str     r2, [vcpu, #VCPU_HCPTR]
 
-after_vfp_restore:
-	@ Restore FPEXC_EN which we clobbered on entry
-	pop	{r2}
-	VFPFMXR FPEXC, r2
-#else
-after_vfp_restore:
-#endif
+	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
 
 	@ Reset Hyp-role
 	configure_hyp_role vmexit
diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
index 51a5950..7701ccd 100644
--- a/arch/arm/kvm/interrupts_head.S
+++ b/arch/arm/kvm/interrupts_head.S
@@ -593,29 +593,24 @@ ARM_BE8(rev	r6, r6  )
  * (hardware reset value is 0). Keep previous value in r2.
  * An ISB is emited on vmexit/vmtrap, but executed on vmexit only if
  * VFP wasn't already enabled (always executed on vmtrap).
- * If a label is specified with vmexit, it is branched to if VFP wasn't
- * enabled.
  */
-.macro set_hcptr operation, mask, label = none
-	mrc	p15, 4, r2, c1, c1, 2
-	ldr	r3, =\mask
+.macro set_hcptr operation, mask, reg
+	mrc     p15, 4, r2, c1, c1, 2
 	.if \operation == vmentry
-	orr	r3, r2, r3		@ Trap coproc-accesses defined in mask
+	mov     r3, \reg              @ Trap coproc-accesses defined in mask
 	.else
-	bic	r3, r2, r3		@ Don't trap defined coproc-accesses
-	.endif
-	mcr	p15, 4, r3, c1, c1, 2
-	.if \operation != vmentry
-	.if \operation == vmexit
-	tst	r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
-	beq	1f
-	.endif
-	isb
-	.if \label != none
-	b	\label
-	.endif
+        ldr     r3, =\mask
+        bic     r3, r2, r3            @ Don't trap defined coproc-accesses
+        .endif
+        mcr     p15, 4, r3, c1, c1, 2
+        .if \operation != vmentry
+        .if \operation == vmexit
+        tst     r2, #(HCPTR_TCP(10) | HCPTR_TCP(11))
+        beq     1f
+        .endif
+        isb
 1:
-	.endif
+        .endif
 .endm
 
 /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 17e92f0..8dccbd7 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -290,4 +290,13 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
+static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu) {}
+static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
+static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu) {}
+
+static inline bool kvm_vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4562459..e16fd39 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -248,6 +248,7 @@ static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
 
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
-- 
1.9.1
