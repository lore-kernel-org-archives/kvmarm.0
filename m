From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v3 2/7] arm64/kvm: context-switch ptrauth registers
Date: Wed, 17 Oct 2018 16:17:55 +0530
Message-ID: <1539773280-4159-3-git-send-email-amit.kachhap@arm.com>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, Amit Daniel Kachhap <amit.kachhap@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

When pointer authentication is supported, a guest may wish to use it.
This patch adds the necessary KVM infrastructure for this to work.

When we schedule a vcpu, we enable guest usage of pointer
authentication instructions and accesses to the keys. After these are
enabled, we allow context-switching the keys.

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
supports the relevant feature). When the guest is scheduled on a
physical CPU lacking the feature, these attempts will result in an UNDEF
being taken by the guest.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm/include/asm/kvm_host.h     |  2 +
 arch/arm64/include/asm/cpufeature.h |  6 +++
 arch/arm64/include/asm/kvm_host.h   | 29 +++++++++++++++
 arch/arm64/include/asm/kvm_hyp.h    |  7 ++++
 arch/arm64/kernel/traps.c           |  1 +
 arch/arm64/kvm/handle_exit.c        | 24 +++++++-----
 arch/arm64/kvm/hyp/Makefile         |  1 +
 arch/arm64/kvm/hyp/ptrauth-sr.c     | 73 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/switch.c         |  8 ++++
 arch/arm64/kvm/sys_regs.c           | 40 ++++++++++++++++----
 virt/kvm/arm/arm.c                  |  3 ++
 11 files changed, 177 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c

diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index dd32934..0ad3c3f 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -351,6 +351,8 @@ static inline int kvm_arm_have_ssbd(void)
 
 static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arm_vcpu_ptrauth_start(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arm_vcpu_ptrauth_stop(struct kvm_vcpu *vcpu) {}
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index af4ca92..967977f 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -517,6 +517,12 @@ static inline bool system_supports_sve(void)
 		cpus_have_const_cap(ARM64_SVE);
 }
 
+static inline bool system_supports_ptrauth(void)
+{
+	return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
+		cpus_have_const_cap(ARM64_HAS_ADDRESS_AUTH);
+}
+
 #define ARM64_SSBD_UNKNOWN		-1
 #define ARM64_SSBD_FORCE_DISABLE	0
 #define ARM64_SSBD_KERNEL		1
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c0e243..ecba6d5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -144,6 +144,18 @@ enum vcpu_sysreg {
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
@@ -426,6 +438,23 @@ static inline bool kvm_arch_check_sve_has_vhe(void)
 		return true;
 }
 
+void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
+void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
+static inline void kvm_arm_vcpu_ptrauth_start(struct kvm_vcpu *vcpu)
+{
+	/* Enable ptrauth for the vcpu */
+	if (system_supports_ptrauth())
+		kvm_arm_vcpu_ptrauth_enable(vcpu);
+}
+static inline void kvm_arm_vcpu_ptrauth_stop(struct kvm_vcpu *vcpu)
+{
+	/* Disable ptrauth for the vcpu */
+	if (system_supports_ptrauth())
+		kvm_arm_vcpu_ptrauth_disable(vcpu);
+}
+
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
+
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 384c343..3f4b844 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -152,6 +152,13 @@ bool __fpsimd_enabled(void);
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
 void deactivate_traps_vhe_put(void);
 
+void __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
+			       struct kvm_cpu_context *host_ctxt,
+			       struct kvm_cpu_context *guest_ctxt);
+void __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
+			      struct kvm_cpu_context *host_ctxt,
+			      struct kvm_cpu_context *guest_ctxt);
+
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 void __noreturn __hyp_do_panic(unsigned long, ...);
 
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 039e9ff..8c7ff96 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -557,6 +557,7 @@ static const char *esr_class_str[] = {
 	[ESR_ELx_EC_CP14_LS]		= "CP14 LDC/STC",
 	[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
 	[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
+	[ESR_ELx_EC_PAC]		= "Pointer authentication trap",
 	[ESR_ELx_EC_CP14_64]		= "CP14 MCRR/MRRC",
 	[ESR_ELx_EC_ILL]		= "PSTATE.IL",
 	[ESR_ELx_EC_SVC32]		= "SVC (AArch32)",
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 53759b3..798158d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -174,19 +174,25 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 }
 
 /*
+ * Handle the guest trying to use a ptrauth instruction, or trying to access a
+ * ptrauth register. This trap should not occur as we enable ptrauth during
+ * vcpu schedule itself but is anyway kept here for any unfortunate scenario.
+ */
+void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
+{
+	if (system_supports_ptrauth())
+		kvm_arm_vcpu_ptrauth_enable(vcpu);
+	else
+		kvm_inject_undefined(vcpu);
+}
+
+/*
  * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
- * a NOP).
+ * a NOP), or guest EL1 access to a ptrauth register.
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
index 2fabc2d..85ddb7f 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
 obj-$(CONFIG_KVM_ARM_HOST) += s2-setup.o
+obj-$(CONFIG_KVM_ARM_HOST) += ptrauth-sr.o
 
 # KVM code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
new file mode 100644
index 0000000..6e96908
--- /dev/null
+++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
@@ -0,0 +1,73 @@
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
+static __always_inline bool __hyp_text __ptrauth_is_enabled(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.hcr_el2 & (HCR_API | HCR_APK);
+}
+
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
+static __always_inline void __hyp_text __ptrauth_save_state(struct kvm_cpu_context *ctxt)
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
+static __always_inline void __hyp_text __ptrauth_restore_state(struct kvm_cpu_context *ctxt)
+{
+	__ptrauth_restore_key(ctxt->sys_regs, APIA);
+	__ptrauth_restore_key(ctxt->sys_regs, APIB);
+	__ptrauth_restore_key(ctxt->sys_regs, APDA);
+	__ptrauth_restore_key(ctxt->sys_regs, APDB);
+	__ptrauth_restore_key(ctxt->sys_regs, APGA);
+}
+
+void __no_ptrauth __hyp_text __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
+					  struct kvm_cpu_context *host_ctxt,
+					  struct kvm_cpu_context *guest_ctxt)
+{
+	if (!__ptrauth_is_enabled(vcpu))
+		return;
+
+	__ptrauth_save_state(host_ctxt);
+	__ptrauth_restore_state(guest_ctxt);
+}
+
+void __no_ptrauth __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
+					 struct kvm_cpu_context *host_ctxt,
+					 struct kvm_cpu_context *guest_ctxt)
+{
+	if (!__ptrauth_is_enabled(vcpu))
+		return;
+
+	__ptrauth_save_state(guest_ctxt);
+	__ptrauth_restore_state(host_ctxt);
+}
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index fa7dab9..714ee5b 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -508,6 +508,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
+	__ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
+
 	__set_guest_arch_workaround_state(vcpu);
 
 	do {
@@ -519,6 +521,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	__set_host_arch_workaround_state(vcpu);
 
+	__ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
+
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
 	__deactivate_traps(vcpu);
@@ -562,6 +566,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
 
+	__ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
+
 	__set_guest_arch_workaround_state(vcpu);
 
 	do {
@@ -573,6 +579,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
 
 	__set_host_arch_workaround_state(vcpu);
 
+	__ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
+
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1ca592d..6af6c7d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -986,6 +986,32 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
 	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
 
+
+void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+}
+
+void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
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
@@ -1040,14 +1066,6 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
 			kvm_debug("SVE unsupported for guests, suppressing\n");
 
 		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
-	} else if (id == SYS_ID_AA64ISAR1_EL1) {
-		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
-					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
-					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
-					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
-		if (val & ptrauth_mask)
-			kvm_debug("ptrauth unsupported for guests, suppressing\n");
-		val &= ~ptrauth_mask;
 	} else if (id == SYS_ID_AA64MMFR1_EL1) {
 		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
 			kvm_debug("LORegions unsupported for guests, suppressing\n");
@@ -1316,6 +1334,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
index b3d1ee4..71efc60 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -386,10 +386,13 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vcpu_clear_wfe_traps(vcpu);
 	else
 		vcpu_set_wfe_traps(vcpu);
+
+	kvm_arm_vcpu_ptrauth_start(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_arm_vcpu_ptrauth_stop(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	kvm_vcpu_put_sysregs(vcpu);
 	kvm_timer_vcpu_put(vcpu);
-- 
2.7.4
