From: Mario Smarduch <m.smarduch@samsung.com>
Subject: [PATCH v5 3/3] KVM/arm/arm64: enable enhanced armv8 fp/simd lazy
 switch
Date: Sun, 06 Dec 2015 17:07:14 -0800
Message-ID: <1449450434-2929-4-git-send-email-m.smarduch@samsung.com>
References: <1449450434-2929-1-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAFD2496F5
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Dec 2015 20:06:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nK5h4EMn+xQq for <kvmarm@lists.cs.columbia.edu>;
 Sun,  6 Dec 2015 20:06:28 -0500 (EST)
Received: from usmailout3.samsung.com (mailout3.w2.samsung.com
 [211.189.100.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E842C419D1
 for <kvmarm@lists.cs.columbia.edu>; Sun,  6 Dec 2015 20:06:28 -0500 (EST)
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYY00EEOR5QSU80@usmailout3.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Sun, 06 Dec 2015 20:08:14 -0500 (EST)
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

This patch tracks armv7 and armv8 fp/simd hardware state with cptr_el2 register.
On vcpu_load for 32 bit guests enable FP access, and enable fp/simd
trapping for 32 and 64 bit guests. On first fp/simd access trap to handler 
to save host and restore guest context, and clear trapping bits to enable vcpu 
lazy mode. On vcpu_put if trap bits are clear save guest and restore host 
context and also save 32 bit guest fpexc register.

Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
---
 arch/arm/include/asm/kvm_emulate.h   |   5 ++
 arch/arm/include/asm/kvm_host.h      |   2 +
 arch/arm/kvm/arm.c                   |  20 +++++--
 arch/arm64/include/asm/kvm_asm.h     |   2 +
 arch/arm64/include/asm/kvm_emulate.h |  15 +++--
 arch/arm64/include/asm/kvm_host.h    |  16 +++++-
 arch/arm64/kernel/asm-offsets.c      |   1 +
 arch/arm64/kvm/Makefile              |   3 +-
 arch/arm64/kvm/fpsimd_switch.S       |  38 ++++++++++++
 arch/arm64/kvm/hyp.S                 | 108 +++++++++++++----------------------
 arch/arm64/kvm/hyp_head.S            |  48 ++++++++++++++++
 11 files changed, 181 insertions(+), 77 deletions(-)
 create mode 100644 arch/arm64/kvm/fpsimd_switch.S
 create mode 100644 arch/arm64/kvm/hyp_head.S

diff --git a/arch/arm/include/asm/kvm_emulate.h b/arch/arm/include/asm/kvm_emulate.h
index 3de11a2..13feed5 100644
--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -243,6 +243,11 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	}
 }
 
+static inline bool kvm_guest_vcpu_is_32bit(struct kvm_vcpu *vcpu)
+{
+	return true;
+}
+
 #ifdef CONFIG_VFPv3
 /* Called from vcpu_load - save fpexc and enable guest access to fp/simd unit */
 static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu)
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index ecc883a..720ae51 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -227,6 +227,8 @@ int kvm_perf_teardown(void);
 void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
 
 struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
+
+static inline void kvm_save_guest_vcpu_fpexc(struct kvm_vcpu *vcpu) {}
 void kvm_restore_host_vfp_state(struct kvm_vcpu *);
 
 static inline void kvm_arch_hardware_disable(void) {}
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 1de07ab..dd59f8a 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -292,8 +292,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_arm_set_running_vcpu(vcpu);
 
-	/*  Save and enable FPEXC before we load guest context */
-	kvm_enable_vcpu_fpexc(vcpu);
+	/*
+	 * For 32bit guest executing on arm64, enable fp/simd access in
+	 * EL2. On arm32 save host fpexc and then enable fp/simd access.
+	 */
+	if (kvm_guest_vcpu_is_32bit(vcpu))
+		kvm_enable_vcpu_fpexc(vcpu);
 
 	/* reset hyp cptr register to trap on tracing and vfp/simd access*/
 	vcpu_reset_cptr(vcpu);
@@ -302,10 +306,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	/* If the fp/simd registers are dirty save guest, restore host. */
-	if (kvm_vcpu_vfp_isdirty(vcpu))
+	if (kvm_vcpu_vfp_isdirty(vcpu)) {
 		kvm_restore_host_vfp_state(vcpu);
 
-	/* Restore host FPEXC trashed in vcpu_load */
+		/*
+		 * For 32bit guest on arm64 save the guest fpexc register
+		 * in EL2 mode.
+		 */
+		if (kvm_guest_vcpu_is_32bit(vcpu))
+			kvm_save_guest_vcpu_fpexc(vcpu);
+	}
+
+	/* For arm32 restore host FPEXC trashed in vcpu_load. */
 	kvm_restore_host_fpexc(vcpu);
 
 	/*
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 5e37710..d53d069 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -117,6 +117,8 @@ extern char __kvm_hyp_vector[];
 extern void __kvm_flush_vm_context(void);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
+extern void __kvm_vcpu_enable_fpexc32(void);
+extern void __kvm_vcpu_save_fpexc32(struct kvm_vcpu *vcpu);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 8dccbd7..bbbee9d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -290,13 +290,20 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 	return data;		/* Leave LE untouched */
 }
 
-static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu) {}
-static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
-static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu) {}
+static inline bool kvm_guest_vcpu_is_32bit(struct kvm_vcpu *vcpu)
+{
+	 return !(vcpu->arch.hcr_el2 & HCR_RW);
+}
+
+static inline void vcpu_reset_cptr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.cptr_el2 = CPTR_EL2_TTA | CPTR_EL2_TFP;
+}
+
 
 static inline bool kvm_vcpu_vfp_isdirty(struct kvm_vcpu *vcpu)
 {
-	return false;
+	return !!(~vcpu->arch.cptr_el2 & CPTR_EL2_TFP);
 }
 
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e16fd39..0c65393 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -100,6 +100,7 @@ struct kvm_vcpu_arch {
 	/* HYP configuration */
 	u64 hcr_el2;
 	u32 mdcr_el2;
+	u32 cptr_el2;
 
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
@@ -248,7 +249,20 @@ static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
-static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
+
+static inline void kvm_enable_vcpu_fpexc(struct kvm_vcpu *vcpu)
+{
+	/* Enable FP/SIMD access from EL2 mode*/
+	kvm_call_hyp(__kvm_vcpu_enable_fpexc32);
+}
+
+static inline void kvm_save_guest_vcpu_fpexc(struct kvm_vcpu *vcpu)
+{
+	/* Save FPEXEC32_EL2 in EL2 mode */
+	kvm_call_hyp(__kvm_vcpu_save_fpexc32, vcpu);
+}
+static inline void kvm_restore_host_fpexc(struct kvm_vcpu *vcpu) {}
+void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu);
 
 void kvm_arm_init_debug(void);
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 8d89cf8..3c8d836 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -123,6 +123,7 @@ int main(void)
   DEFINE(DEBUG_WVR, 		offsetof(struct kvm_guest_debug_arch, dbg_wvr));
   DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(VCPU_MDCR_EL2,	offsetof(struct kvm_vcpu, arch.mdcr_el2));
+  DEFINE(VCPU_CPTR_EL2,		offsetof(struct kvm_vcpu, arch.cptr_el2));
   DEFINE(VCPU_IRQ_LINES,	offsetof(struct kvm_vcpu, arch.irq_lines));
   DEFINE(VCPU_HOST_CONTEXT,	offsetof(struct kvm_vcpu, arch.host_cpu_context));
   DEFINE(VCPU_HOST_DEBUG_STATE, offsetof(struct kvm_vcpu, arch.host_debug_state));
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 1949fe5..262b9a5 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -17,7 +17,8 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
 kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
-kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
+kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o
+kvm-$(CONFIG_KVM_ARM_HOST) += sys_regs_generic_v8.o fpsimd_switch.o
 
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
diff --git a/arch/arm64/kvm/fpsimd_switch.S b/arch/arm64/kvm/fpsimd_switch.S
new file mode 100644
index 0000000..5295512
--- /dev/null
+++ b/arch/arm64/kvm/fpsimd_switch.S
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/linkage.h>
+
+#include "hyp_head.S"
+
+	.text
+/**
+ * void kvm_restore_host_vfp_state(struct vcpu *vcpu) -
+ *     This function saves the guest, restores host, called from host.
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
diff --git a/arch/arm64/kvm/hyp.S b/arch/arm64/kvm/hyp.S
index e583613..b8b1afb 100644
--- a/arch/arm64/kvm/hyp.S
+++ b/arch/arm64/kvm/hyp.S
@@ -17,23 +17,7 @@
 
 #include <linux/linkage.h>
 
-#include <asm/alternative.h>
-#include <asm/asm-offsets.h>
-#include <asm/assembler.h>
-#include <asm/cpufeature.h>
-#include <asm/debug-monitors.h>
-#include <asm/esr.h>
-#include <asm/fpsimdmacros.h>
-#include <asm/kvm.h>
-#include <asm/kvm_arm.h>
-#include <asm/kvm_asm.h>
-#include <asm/kvm_mmu.h>
-#include <asm/memory.h>
-
-#define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
-#define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
-#define CPU_SPSR_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_SPSR + 8*x)
-#define CPU_SYSREG_OFFSET(x)	(CPU_SYSREGS + 8*x)
+#include "hyp_head.S"
 
 	.text
 	.pushsection	.hyp.text, "ax"
@@ -104,20 +88,6 @@
 	restore_common_regs
 .endm
 
-.macro save_fpsimd
-	// x2: cpu context address
-	// x3, x4: tmp regs
-	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
-	fpsimd_save x3, 4
-.endm
-
-.macro restore_fpsimd
-	// x2: cpu context address
-	// x3, x4: tmp regs
-	add	x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
-	fpsimd_restore x3, 4
-.endm
-
 .macro save_guest_regs
 	// x0 is the vcpu address
 	// x1 is the return code, do not corrupt!
@@ -385,14 +355,6 @@
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
@@ -433,10 +395,6 @@
 	mrs	x5, ifsr32_el2
 	stp	x4, x5, [x3]
 
-	skip_fpsimd_state x8, 2f
-	mrs	x6, fpexc32_el2
-	str	x6, [x3, #16]
-2:
 	skip_debug_state x8, 1f
 	mrs	x7, dbgvcr32_el2
 	str	x7, [x3, #24]
@@ -467,22 +425,9 @@
 
 .macro activate_traps
 	ldr     x2, [x0, #VCPU_HCR_EL2]
-
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
-	mov	x2, #CPTR_EL2_TTA
-	orr     x2, x2, #CPTR_EL2_TFP
+
+	ldr     w2, [x0, VCPU_CPTR_EL2]
 	msr	cptr_el2, x2
 
 	mov	x2, #(1 << 15)	// Trap CP15 Cr=15
@@ -668,15 +613,15 @@ __restore_debug:
 
 	ret
 
-__save_fpsimd:
-	skip_fpsimd_state x3, 1f
+ENTRY(__save_fpsimd)
 	save_fpsimd
-1:	ret
+	ret
+ENDPROC(__save_fpsimd)
 
-__restore_fpsimd:
-	skip_fpsimd_state x3, 1f
+ENTRY(__restore_fpsimd)
 	restore_fpsimd
-1:	ret
+	ret
+ENDPROC(__restore_fpsimd)
 
 switch_to_guest_fpsimd:
 	push	x4, lr
@@ -763,7 +708,6 @@ __kvm_vcpu_return:
 	add	x2, x0, #VCPU_CONTEXT
 
 	save_guest_regs
-	bl __save_fpsimd
 	bl __save_sysregs
 
 	skip_debug_state x3, 1f
@@ -784,8 +728,10 @@ __kvm_vcpu_return:
 	kern_hyp_va x2
 
 	bl __restore_sysregs
-	bl __restore_fpsimd
-	/* Clear FPSIMD and Trace trapping */
+
+	/* Save CPTR_EL2 between exits and clear FPSIMD and Trace trapping */
+	mrs     x3, cptr_el2
+	str     w3, [x0, VCPU_CPTR_EL2]
 	msr     cptr_el2, xzr
 
 	skip_debug_state x3, 1f
@@ -863,6 +809,34 @@ ENTRY(__kvm_flush_vm_context)
 	ret
 ENDPROC(__kvm_flush_vm_context)
 
+/**
+  * void __kvm_enable_fpexc32(void) -
+  *	We may be entering the guest and set CPTR_EL2.TFP to trap all floating
+  *	point register accesses to EL2, however, the ARM manual clearly states
+  *	that traps are only taken to EL2 if the operation would not otherwise
+  *	trap to EL1.  Therefore, always make sure that for 32-bit guests,
+  *	we set FPEXC.EN to prevent traps to EL1, when setting the TFP bit.
+  */
+ENTRY(__kvm_vcpu_enable_fpexc32)
+	mov	x3, #(1 << 30)
+	msr	fpexc32_el2, x3
+	isb
+	ret
+ENDPROC(__kvm_vcpu_enable_fpexc32)
+
+/**
+ * void __kvm_save_fpexc32(void) -
+ *	This function restores guest FPEXC to its vcpu context, we call this
+ *	function from vcpu_put.
+ */
+ENTRY(__kvm_vcpu_save_fpexc32)
+	kern_hyp_va x0
+	add     x2, x0, #VCPU_CONTEXT
+	mrs     x1, fpexc32_el2
+	str     x1, [x2, #CPU_SYSREG_OFFSET(FPEXC32_EL2)]
+	ret
+ENDPROC(__kvm_vcpu_save_fpexc32)
+
 __kvm_hyp_panic:
 	// Guess the context by looking at VTTBR:
 	// If zero, then we're already a host.
diff --git a/arch/arm64/kvm/hyp_head.S b/arch/arm64/kvm/hyp_head.S
new file mode 100644
index 0000000..bb32824
--- /dev/null
+++ b/arch/arm64/kvm/hyp_head.S
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <asm/alternative.h>
+#include <asm/asm-offsets.h>
+#include <asm/assembler.h>
+#include <asm/cpufeature.h>
+#include <asm/debug-monitors.h>
+#include <asm/esr.h>
+#include <asm/fpsimdmacros.h>
+#include <asm/kvm.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_mmu.h>
+#include <asm/memory.h>
+
+#define CPU_GP_REG_OFFSET(x)    (CPU_GP_REGS + x)
+#define CPU_XREG_OFFSET(x)      CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
+#define CPU_SPSR_OFFSET(x)      CPU_GP_REG_OFFSET(CPU_SPSR + 8*x)
+#define CPU_SYSREG_OFFSET(x)    (CPU_SYSREGS + 8*x)
+
+.macro save_fpsimd
+	// x2: cpu context address
+	// x3, x4: tmp regs
+	add x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
+	fpsimd_save x3, 4
+.endm
+
+.macro restore_fpsimd
+	// x2: cpu context address
+	// x3, x4: tmp regs
+	add x3, x2, #CPU_GP_REG_OFFSET(CPU_FP_REGS)
+	fpsimd_restore x3, 4
+.endm
-- 
1.9.1
