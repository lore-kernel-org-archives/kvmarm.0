From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: [PATCH v3 7/7] arm/kvm: arm64: Add a vcpu feature for pointer
 authentication
Date: Wed, 17 Oct 2018 16:18:00 +0530
Message-ID: <1539773280-4159-8-git-send-email-amit.kachhap@arm.com>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C65554A1D1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 06:49:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DWO+yZlK1ymt for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Oct 2018 06:49:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 66FEA4A1DC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Oct 2018 06:49:25 -0400 (EDT)
In-Reply-To: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
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

This is a runtime feature and can be enabled by --ptrauth option.

Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arm/aarch32/include/kvm/kvm-cpu-arch.h    | 2 ++
 arm/aarch64/include/asm/kvm.h             | 3 +++
 arm/aarch64/include/kvm/kvm-arch.h        | 1 +
 arm/aarch64/include/kvm/kvm-config-arch.h | 4 +++-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    | 2 ++
 arm/aarch64/kvm-cpu.c                     | 5 +++++
 arm/include/arm-common/kvm-config-arch.h  | 1 +
 arm/kvm-cpu.c                             | 7 +++++++
 include/linux/kvm.h                       | 1 +
 9 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
index d28ea67..5779767 100644
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
@@ -13,4 +13,6 @@
 #define ARM_CPU_ID		0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 
+unsigned int kvm__cpu_ptrauth_get_feature(void) {}
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index c286035..0fd183d 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -98,6 +98,9 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
 #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
 
+/* CPU uses address authentication and A key */
+#define KVM_ARM_VCPU_PTRAUTH		4
+
 struct kvm_vcpu_init {
 	__u32 target;
 	__u32 features[7];
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 9de623a..bd566cb 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -11,4 +11,5 @@
 
 #include "arm-common/kvm-arch.h"
 
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43d..2074684 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -8,7 +8,9 @@
 			"Create PMUv3 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
-			"Layout Randomization (KASLR)"),
+			"Layout Randomization (KASLR)"),		\
+	OPT_BOOLEAN('\0', "ptrauth", &(cfg)->has_ptrauth,		\
+			"Enable address authentication"),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index a9d8563..f7b64b7 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -17,4 +17,6 @@
 #define ARM_CPU_CTRL		3, 0, 1, 0
 #define ARM_CPU_CTRL_SCTLR_EL1	0
 
+unsigned int kvm__cpu_ptrauth_get_feature(void);
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 1b29374..10da2cb 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -123,6 +123,11 @@ void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 		return reset_vcpu_aarch64(vcpu);
 }
 
+unsigned int kvm__cpu_ptrauth_get_feature(void)
+{
+	return (1UL << KVM_ARM_VCPU_PTRAUTH);
+}
+
 int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
 {
 	struct kvm_one_reg reg;
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 6a196f1..eb872db 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -10,6 +10,7 @@ struct kvm_config_arch {
 	bool		aarch32_guest;
 	bool		has_pmuv3;
 	u64		kaslr_seed;
+	bool		has_ptrauth;
 	enum irqchip_type irqchip;
 };
 
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7780251..5afd727 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -68,6 +68,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
 	}
 
+	/* Set KVM_ARM_VCPU_PTRAUTH_I_A if available */
+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH)) {
+		if (kvm->cfg.arch.has_ptrauth)
+			vcpu_init.features[0] |=
+					kvm__cpu_ptrauth_get_feature();
+	}
+
 	/*
 	 * If the preferred target ioctl is successful then
 	 * use preferred target else try each and every target type
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f51d508..ffd8f5c 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -883,6 +883,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_PPC_MMU_RADIX 134
 #define KVM_CAP_PPC_MMU_HASH_V3 135
 #define KVM_CAP_IMMEDIATE_EXIT 136
+#define KVM_CAP_ARM_PTRAUTH 160
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.7.4
