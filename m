From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH kvmtool v2 2/3] arm64: Add basic SVE support
Date: Wed, 20 Mar 2019 12:07:27 +0000
Message-ID: <1553083648-5345-3-git-send-email-Dave.Martin@arm.com>
References: <1553083648-5345-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6099E49F94
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 08:08:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id elbvwHMg-Bqb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Mar 2019 08:08:22 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 340214A41A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Mar 2019 08:08:21 -0400 (EDT)
In-Reply-To: <1553083648-5345-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Zhang Lei <zhang.lei@jp.fujitsu.com>, Julien Grall <Julien.Grall@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds an --sve command line option to allow the Scalable
Vector Extension to be enabled when creating a guest.

This requires use of the new KVM_ARM_VCPU_FINALIZE ioctl before the
vcpu is runnable, so a new hook kvm_cpu__configure_features() is
added to provide an appropiate place to do this work.

The kernel does not enable SVE by default, and for now kvmtool
adopts the same policy: without --sve, SVE is not enabled for the
guest even if the host supports it.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arm/aarch32/include/kvm/kvm-cpu-arch.h    |  5 +++++
 arm/aarch64/include/kvm/kvm-config-arch.h |  4 +++-
 arm/aarch64/include/kvm/kvm-cpu-arch.h    |  7 ++++++-
 arm/aarch64/kvm-cpu.c                     | 19 +++++++++++++++++++
 arm/include/arm-common/kvm-config-arch.h  |  1 +
 arm/kvm-cpu.c                             |  3 +++
 6 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
index d28ea67..04740d4 100644
--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
@@ -13,4 +13,9 @@
 #define ARM_CPU_ID		0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 
+static inline int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+{
+	return 0;
+}
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
index 04be43d..50b7aae 100644
--- a/arm/aarch64/include/kvm/kvm-config-arch.h
+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
@@ -8,7 +8,9 @@
 			"Create PMUv3 device"),				\
 	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
 			"Specify random seed for Kernel Address Space "	\
-			"Layout Randomization (KASLR)"),
+			"Layout Randomization (KASLR)"),		\
+	OPT_BOOLEAN('\0', "sve", &(cfg)->has_sve,			\
+			"Enable SVE for the guest"),
 
 #include "arm-common/kvm-config-arch.h"
 
diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
index a9d8563..7f2bfb9 100644
--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
@@ -8,13 +8,18 @@
 #define ARM_VCPU_FEATURE_FLAGS(kvm, cpuid)	{				\
 	[0] = ((!!(cpuid) << KVM_ARM_VCPU_POWER_OFF) |				\
 	       (!!(kvm)->cfg.arch.aarch32_guest << KVM_ARM_VCPU_EL1_32BIT) |	\
-	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3))		\
+	       (!!(kvm)->cfg.arch.has_pmuv3 << KVM_ARM_VCPU_PMU_V3) |		\
+	       (!!(kvm)->cfg.arch.has_sve << KVM_ARM_VCPU_SVE))			\
 }
 
+
+
 #define ARM_MPIDR_HWID_BITMASK	0xFF00FFFFFFUL
 #define ARM_CPU_ID		3, 0, 0, 0
 #define ARM_CPU_ID_MPIDR	5
 #define ARM_CPU_CTRL		3, 0, 1, 0
 #define ARM_CPU_CTRL_SCTLR_EL1	0
 
+int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
+
 #endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 0aaefaf..43eb69e 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -128,6 +128,25 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
 	}
 }
 
+static int configure_sve(struct kvm_cpu *vcpu)
+{
+	int feature = KVM_ARM_VCPU_SVE;
+
+	if (ioctl(vcpu->vcpu_fd, KVM_ARM_VCPU_FINALIZE, &feature))
+		return -1;
+
+	return 0;
+}
+
+int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
+{
+	if (vcpu->kvm->cfg.arch.has_sve)
+		if (configure_sve(vcpu))
+			return -1;
+
+	return 0;
+}
+
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 {
 	if (vcpu->kvm->cfg.arch.aarch32_guest)
diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
index 5734c46..bdab680 100644
--- a/arm/include/arm-common/kvm-config-arch.h
+++ b/arm/include/arm-common/kvm-config-arch.h
@@ -12,6 +12,7 @@ struct kvm_config_arch {
 	u64		kaslr_seed;
 	enum irqchip_type irqchip;
 	u64		fw_addr;
+	bool		has_sve;
 };
 
 int irqchip_parser(const struct option *opt, const char *arg, int unset);
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 7780251..91d5241 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -122,6 +122,9 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	vcpu->cpu_compatible	= target->compatible;
 	vcpu->is_running	= true;
 
+	if (kvm_cpu__configure_features(vcpu))
+		die("Unable to configure requested vcpu features");
+
 	return vcpu;
 }
 
-- 
2.1.4
