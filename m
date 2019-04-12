From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [kvmtool PATCH v9 5/5] KVM: arm/arm64: Add a vcpu feature for pointer authentication
Date: Fri, 12 Apr 2019 08:50:36 +0530
Message-ID: <1555039236-10608-6-git-send-email-amit.kachhap@arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Amit Daniel Kachhap <amit.kachhap@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds a runtime capabality for KVM tool to enable Arm64 8.3
Pointer Authentication in guest kernel. Two vcpu features
KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] are supplied together to enable
Pointer Authentication in KVM guest after checking the capability.

Command line options --enable-ptrauth and --disable-ptrauth are added
to use this feature. However, if those options are not provided then
also this feature is enabled if host supports this capability.

The macros defined in the headers are not in sync and should be replaced
from the upstream.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
---
Changes since v8:
*  Added option --enable-ptrauth and --disable-ptrauth to use ptrauth. Also
   enable ptrauth if no option provided and Host supports ptrauth. [Dave Martin]
* The macro definition are not linear as the kvmtool is not synchronised with the
  kernel changes present in kvmarm/next tree.

 arm/aarch32/include/kvm/kvm-cpu-arch.h    |  1 +
 arm/aarch64/include/asm/kvm.h             |  2 ++
 arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  2 ++
 arm/include/arm-common/kvm-config-arch.h  |  2 ++
 arm/kvm-cpu.c                             | 11 +++++++++++
 include/linux/kvm.h                       |  2 ++
 7 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
index d28ea67..520ea76 100644
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
@@ -13,4 +13,5 @@
 #define ARM_CPU_ID		0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 
+#define ARM_VCPU_PTRAUTH_FEATURE	0
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 97c3478..a2546e6 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -102,6 +102,8 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
+#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* CPU uses address pointer authentication */
+#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* CPU uses generic pointer authentication */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43d..0279b13 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -8,7 +8,11 @@
 			"Create PMUv3 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
-			"Layout Randomization (KASLR)"),
+			"Layout Randomization (KASLR)"),		\
+	OPT_BOOLEAN('\0', "enable-ptrauth", &(cfg)->enable_ptrauth,	\
+			"Enables pointer authentication"),		\
+	OPT_BOOLEAN('\0', "disable-ptrauth", &(cfg)->disable_ptrauth,	\
+			"Disables pointer authentication"),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index a9d8563..fcc2107 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -17,4 +17,6 @@
 #define ARM_CPU_CTRL		3, 0, 1, 0
 #define ARM_CPU_CTRL_SCTLR_EL1	0
 
+#define ARM_VCPU_PTRAUTH_FEATURE	((1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS) \
+					| (1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC))
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46..1b4287d 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -10,6 +10,8 @@ struct kvm_config_arch {
 	bool		aarch32_guest;
 	bool		has_pmuv3;
 	u64		kaslr_seed;
+	bool		enable_ptrauth;
+	bool		disable_ptrauth;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
 };
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7780251..a45a649 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -69,6 +69,17 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	}
 
 	/*
+	 * Always enable Pointer Authentication if requested. If system supports
+	 * this extension then also enable it by default provided no disable
+	 * request present.
+	 */
+	if ((kvm->cfg.arch.enable_ptrauth) ||
+		(kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+		kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
+		!kvm->cfg.arch.disable_ptrauth))
+			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
+
+	/*
 	 * If the preferred target ioctl is successful then
 	 * use preferred target else try each and every target type
 	 */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6d4ea4b..de1033b 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -988,6 +988,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_VM_IPA_SIZE 165
 #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
 #define KVM_CAP_HYPERV_CPUID 167
+#define KVM_CAP_ARM_PTRAUTH_ADDRESS 169
+#define KVM_CAP_ARM_PTRAUTH_GENERIC 170
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4
