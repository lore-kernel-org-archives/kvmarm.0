From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v6 3/6] arm64/kvm: context-switch ptrauth registers
Date: Tue, 19 Feb 2019 14:54:28 +0530
Message-ID: <1550568271-5319-4-git-send-email-amit.kachhap@arm.com>
References: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 49F7E4A414
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Feb 2019 04:25:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KHcK+zpH9dop for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Feb 2019 04:25:11 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 252194A3FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Feb 2019 04:25:11 -0500 (EST)
In-Reply-To: <1550568271-5319-1-git-send-email-amit.kachhap@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

When pointer authentication is supported, a guest may wish to use it.
This patch adds the necessary KVM infrastructure for this to work, with
a semi-lazy context switch of the pointer auth state.

Pointer authentication feature is only enabled when VHE is built
in the kernel and present into CPU implementation so only VHE code
paths are modified.

When we schedule a vcpu, we disable guest usage of pointer
authentication instructions and accesses to the keys. While these are
disabled, we avoid context-switching the keys. When we trap the guest
trying to use pointer authentication functionality, we change to eagerly
context-switching the keys, and enable the feature. The next time the
vcpu is scheduled out/in, we start again. However the host key registers
are saved in vcpu load stage as they remain constant for each vcpu
schedule.

Pointer authentication consists of address authentication and generic
authentication, and CPUs in a system might have varied support for
either. Where support for either feature is not uniform, it is hidden
from guests via ID register emulation, as a result of the cpufeature
framework in the host.

Unfortunately, address authentication and generic authentication cannot
be trapped separately, as the architecture provides a single EL2 trap
covering both. If we wish to expose one without the other, we cannot
prevent a (badly-written) guest from intermittently using a feature
which is not uniformly supported (when scheduled on a physical CPU which
supports the relevant feature). Hence, this patch expects both type of
authentication to be present in a cpu.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[Only VHE, key switch from from assembly, kvm_supports_ptrauth
checks, save host key in vcpu_load]
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm/include/asm/kvm_host.h   |   1 +
 arch/arm64/include/asm/kvm_host.h |  23 +++++++++
 arch/arm64/include/asm/kvm_hyp.h  |   7 +++
 arch/arm64/kernel/traps.c         |   1 +
 arch/arm64/kvm/handle_exit.c      |  21 +++++---
 arch/arm64/kvm/hyp/Makefile       |   1 +
 arch/arm64/kvm/hyp/entry.S        |  17 +++++++
 arch/arm64/kvm/hyp/ptrauth-sr.c   | 101 ++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c         |  37 +++++++++++++-
 virt/kvm/arm/arm.c                |   2 +
 10 files changed, 201 insertions(+), 10 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index 704667e..b200c14 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -345,6 +345,7 @@ static inline int kvm_arm_have_ssbd(void)
 
 static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu) {}
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2f1bb86..1bacf78 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -146,6 +146,18 @@ enum vcpu_sysreg {
 	PMSWINC_EL0,	/* Software Increment Register */
 	PMUSERENR_EL0,	/* User Enable Register */
 
+	/* Pointer Authentication Registers */
+	APIAKEYLO_EL1,
+	APIAKEYHI_EL1,
+	APIBKEYLO_EL1,
+	APIBKEYHI_EL1,
+	APDAKEYLO_EL1,
+	APDAKEYHI_EL1,
+	APDBKEYLO_EL1,
+	APDBKEYHI_EL1,
+	APGAKEYLO_EL1,
+	APGAKEYHI_EL1,
+
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
 	IFSR32_EL2,	/* Instruction Fault Status Register */
@@ -439,6 +451,17 @@ static inline bool kvm_arch_requires_vhe(void)
 	return false;
 }
 
+static inline bool kvm_supports_ptrauth(void)
+{
+	return has_vhe() && system_supports_address_auth() &&
+				system_supports_generic_auth();
+}
+
+void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
+
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 6e65cad..09e061a 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -153,6 +153,13 @@ bool __fpsimd_enabled(void);
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
 void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 
+void __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
+			       struct kvm_cpu_context *host_ctxt,
+			       struct kvm_cpu_context *guest_ctxt);
+void __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
+			      struct kvm_cpu_context *guest_ctxt,
+			      struct kvm_cpu_context *host_ctxt);
+
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 4e2fb87..5cac605 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -749,6 +749,7 @@ static const char *esr_class_str[] = {
 	[ESR_ELx_EC_CP14_LS]		= "CP14 LDC/STC",
 	[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
 	[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
+	[ESR_ELx_EC_PAC]		= "Pointer authentication trap",
 	[ESR_ELx_EC_CP14_64]		= "CP14 MCRR/MRRC",
 	[ESR_ELx_EC_ILL]		= "PSTATE.IL",
 	[ESR_ELx_EC_SVC32]		= "SVC (AArch32)",
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 0b79834..7622ab3 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -174,19 +174,24 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 /*
+ * Handle the guest trying to use a ptrauth instruction, or trying to access a
+ * ptrauth register.
+ */
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
+{
+	if (kvm_supports_ptrauth())
+		kvm_arm_vcpu_ptrauth_enable(vcpu);
+	else
+		kvm_inject_undefined(vcpu);
+}
+
+/*
  * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
  * a NOP).
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	/*
-	 * We don't currently support ptrauth in a guest, and we mask the ID
-	 * registers to prevent well-behaved guests from trying to make use of
-	 * it.
-	 *
-	 * Inject an UNDEF, as if the feature really isn't present.
-	 */
-	kvm_inject_undefined(vcpu);
+	kvm_arm_vcpu_ptrauth_trap(vcpu);
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 82d1904..17cec99 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += switch.o
 obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
+obj-$(CONFIG_KVM_ARM_HOST) += ptrauth-sr.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 675fdc1..b78cc15 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -64,6 +64,12 @@ ENTRY(__guest_enter)
 
 	add	x18, x0, #VCPU_CONTEXT
 
+#ifdef	CONFIG_ARM64_PTR_AUTH
+	// Prepare parameter for __ptrauth_switch_to_guest(vcpu, host, guest).
+	mov	x2, x18
+	bl	__ptrauth_switch_to_guest
+#endif
+
 	// Restore guest regs x0-x17
 	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
 	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
@@ -118,6 +124,17 @@ ENTRY(__guest_exit)
 
 	get_host_ctxt	x2, x3
 
+#ifdef	CONFIG_ARM64_PTR_AUTH
+	// Prepare parameter for __ptrauth_switch_to_host(vcpu, guest, host).
+	// Save x0, x2 which are used later in callee saved registers.
+	mov	x19, x0
+	mov	x20, x2
+	sub	x0, x1, #VCPU_CONTEXT
+	ldr	x29, [x2, #CPU_XREG_OFFSET(29)]
+	bl	__ptrauth_switch_to_host
+	mov	x0, x19
+	mov	x2, x20
+#endif
 	// Now restore the host regs
 	restore_callee_saved_regs x2
 
diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
new file mode 100644
index 0000000..528ee6e
--- /dev/null
+++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * arch/arm64/kvm/hyp/ptrauth-sr.c: Guest/host ptrauth save/restore
+ *
+ * Copyright 2018 Arm Limited
+ * Author: Mark Rutland <mark.rutland@arm.com>
+ *         Amit Daniel Kachhap <amit.kachhap@arm.com>
+ */
+#include <linux/compiler.h>
+#include <linux/kvm_host.h>
+
+#include <asm/cpucaps.h>
+#include <asm/cpufeature.h>
+#include <asm/kvm_asm.h>
+#include <asm/kvm_hyp.h>
+#include <asm/pointer_auth.h>
+
+static __always_inline bool __ptrauth_is_enabled(struct kvm_vcpu *vcpu)
+{
+	return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
+			vcpu->arch.ctxt.hcr_el2 & (HCR_API | HCR_APK);
+}
+
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
+static __always_inline void __ptrauth_save_state(struct kvm_cpu_context *ctxt)
+{
+	__ptrauth_save_key(ctxt->sys_regs, APIA);
+	__ptrauth_save_key(ctxt->sys_regs, APIB);
+	__ptrauth_save_key(ctxt->sys_regs, APDA);
+	__ptrauth_save_key(ctxt->sys_regs, APDB);
+	__ptrauth_save_key(ctxt->sys_regs, APGA);
+}
+
+#define __ptrauth_restore_key(regs, key) 					\
+({										\
+	write_sysreg_s(regs[key ## KEYLO_EL1], SYS_ ## key ## KEYLO_EL1);	\
+	write_sysreg_s(regs[key ## KEYHI_EL1], SYS_ ## key ## KEYHI_EL1);	\
+})
+
+static __always_inline void __ptrauth_restore_state(struct kvm_cpu_context *ctxt)
+{
+	__ptrauth_restore_key(ctxt->sys_regs, APIA);
+	__ptrauth_restore_key(ctxt->sys_regs, APIB);
+	__ptrauth_restore_key(ctxt->sys_regs, APDA);
+	__ptrauth_restore_key(ctxt->sys_regs, APDB);
+	__ptrauth_restore_key(ctxt->sys_regs, APGA);
+}
+
+/**
+ * This function changes the key so assign Pointer Authentication safe
+ * GCC attribute if protected by it.
+ */
+void __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
+				  struct kvm_cpu_context *host_ctxt,
+				  struct kvm_cpu_context *guest_ctxt)
+{
+	if (!__ptrauth_is_enabled(vcpu))
+		return;
+
+	__ptrauth_restore_state(guest_ctxt);
+}
+
+/**
+ * This function changes the key so assign Pointer Authentication safe
+ * GCC attribute if protected by it.
+ */
+void __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
+				 struct kvm_cpu_context *guest_ctxt,
+				 struct kvm_cpu_context *host_ctxt)
+{
+	if (!__ptrauth_is_enabled(vcpu))
+		return;
+
+	__ptrauth_save_state(guest_ctxt);
+	__ptrauth_restore_state(host_ctxt);
+}
+
+/**
+ * kvm_arm_vcpu_ptrauth_reset - resets ptrauth for vcpu schedule
+ *
+ * @vcpu: The VCPU pointer
+ *
+ * This function may be used to disable ptrauth and use it in a lazy context
+ * via traps. However host key registers are saved here as they dont change
+ * during host/guest switch.
+ */
+void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *host_ctxt;
+
+	if (kvm_supports_ptrauth()) {
+		kvm_arm_vcpu_ptrauth_disable(vcpu);
+		host_ctxt = vcpu->arch.host_cpu_context;
+		__ptrauth_save_state(host_ctxt);
+	}
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a6c9381..12529df 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -986,6 +986,32 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
+
+void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.ctxt.hcr_el2 |= (HCR_API | HCR_APK);
+}
+
+void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.ctxt.hcr_el2 &= ~(HCR_API | HCR_APK);
+}
+
+static bool trap_ptrauth(struct kvm_vcpu *vcpu,
+			 struct sys_reg_params *p,
+			 const struct sys_reg_desc *rd)
+{
+	kvm_arm_vcpu_ptrauth_trap(vcpu);
+	return false;
+}
+
+#define __PTRAUTH_KEY(k)						\
+	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k }
+
+#define PTRAUTH_KEY(k)							\
+	__PTRAUTH_KEY(k ## KEYLO_EL1),					\
+	__PTRAUTH_KEY(k ## KEYHI_EL1)
+
 static bool access_cntp_tval(struct kvm_vcpu *vcpu,
 		struct sys_reg_params *p,
 		const struct sys_reg_desc *r)
@@ -1045,9 +1071,10 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
 					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
 					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
-		if (val & ptrauth_mask)
+		if (!kvm_supports_ptrauth()) {
 			kvm_debug("ptrauth unsupported for guests, suppressing\n");
-		val &= ~ptrauth_mask;
+			val &= ~ptrauth_mask;
+		}
 	} else if (id == SYS_ID_AA64MMFR1_EL1) {
 		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
 			kvm_debug("LORegions unsupported for guests, suppressing\n");
@@ -1316,6 +1343,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
 	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
 
+	PTRAUTH_KEY(APIA),
+	PTRAUTH_KEY(APIB),
+	PTRAUTH_KEY(APDA),
+	PTRAUTH_KEY(APDB),
+	PTRAUTH_KEY(APGA),
+
 	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
 	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
 	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 2032a66..d7e003f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -388,6 +388,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vcpu_clear_wfe_traps(vcpu);
 	else
 		vcpu_set_wfe_traps(vcpu);
+
+	kvm_arm_vcpu_ptrauth_reset(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
-- 
2.7.4
