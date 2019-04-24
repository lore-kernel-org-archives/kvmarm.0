From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [kvmtool PATCH v10 5/5] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
Date: Wed, 24 Apr 2019 14:41:21 +0100
Message-ID: <20190424134120.GW3567@e103592.cambridge.arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-6-git-send-email-amit.kachhap@arm.com>
 <20190423154625.GP3567@e103592.cambridge.arm.com>
 <3b7bafc9-5d6a-7845-ef1f-577ea59000e2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3b7bafc9-5d6a-7845-ef1f-577ea59000e2@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 24, 2019 at 12:32:22PM +0530, Amit Daniel Kachhap wrote:
> Hi,
> 
> On 4/23/19 9:16 PM, Dave Martin wrote:
> >On Tue, Apr 23, 2019 at 10:12:38AM +0530, Amit Daniel Kachhap wrote:
> >>This patch adds a runtime capabality for KVM tool to enable Arm64 8.3
> >>Pointer Authentication in guest kernel. Two vcpu features
> >>KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] are supplied together to enable
> >>Pointer Authentication in KVM guest after checking the capability.
> >>
> >>Command line options --enable-ptrauth and --disable-ptrauth are added
> >>to use this feature. However, if those options are not provided then
> >>also this feature is enabled if host supports this capability.
> >>
> >>The macros defined in the headers are not in sync and should be replaced
> >>from the upstream.
> >>
> >>Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> >>---
> >>
> >>Changes since v9:
> >>* Added a error check for both enable-ptrauth and disable-ptrauth
> >>   option.
> >>* Make the error explicit when enable-ptrauth is provided [Dave Martin].
> >>
> >>  arm/aarch32/include/kvm/kvm-cpu-arch.h    |  1 +
> >>  arm/aarch64/include/asm/kvm.h             |  2 ++
> >>  arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
> >>  arm/aarch64/include/kvm/kvm-cpu-arch.h    |  2 ++
> >>  arm/include/arm-common/kvm-config-arch.h  |  2 ++
> >>  arm/kvm-cpu.c                             | 20 ++++++++++++++++++--
> >>  include/linux/kvm.h                       |  2 ++
> >>  7 files changed, 32 insertions(+), 3 deletions(-)
> >>
> >>diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> >>index d28ea67..520ea76 100644
> >>--- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> >>+++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> >>@@ -13,4 +13,5 @@
> >>  #define ARM_CPU_ID		0, 0, 0
> >>  #define ARM_CPU_ID_MPIDR	5
> >>+#define ARM_VCPU_PTRAUTH_FEATURE	0
> >>  #endif /* KVM__KVM_CPU_ARCH_H */
> >>diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
> >>index 97c3478..a2546e6 100644
> >>--- a/arm/aarch64/include/asm/kvm.h
> >>+++ b/arm/aarch64/include/asm/kvm.h
> >>@@ -102,6 +102,8 @@ struct kvm_regs {
> >>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
> >>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
> >>  #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
> >>+#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* CPU uses address pointer authentication */
> >>+#define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* CPU uses generic pointer authentication */
> >>  struct kvm_vcpu_init {
> >>  	__u32 target;
> >>diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> >>index 04be43d..0279b13 100644
> >>--- a/arm/aarch64/include/kvm/kvm-config-arch.h
> >>+++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> >>@@ -8,7 +8,11 @@
> >>  			"Create PMUv3 device"),				\
> >>  	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
> >>  			"Specify random seed for Kernel Address Space "	\
> >>-			"Layout Randomization (KASLR)"),
> >>+			"Layout Randomization (KASLR)"),		\
> >>+	OPT_BOOLEAN('\0', "enable-ptrauth", &(cfg)->enable_ptrauth,	\
> >>+			"Enables pointer authentication"),		\
> >>+	OPT_BOOLEAN('\0', "disable-ptrauth", &(cfg)->disable_ptrauth,	\
> >>+			"Disables pointer authentication"),
> >>  #include "arm-common/kvm-config-arch.h"
> >>diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> >>index a9d8563..fcc2107 100644
> >>--- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> >>+++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> >>@@ -17,4 +17,6 @@
> >>  #define ARM_CPU_CTRL		3, 0, 1, 0
> >>  #define ARM_CPU_CTRL_SCTLR_EL1	0
> >>+#define ARM_VCPU_PTRAUTH_FEATURE	((1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS) \
> >>+					| (1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC))
> >>  #endif /* KVM__KVM_CPU_ARCH_H */
> >>diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> >>index 5734c46..1b4287d 100644
> >>--- a/arm/include/arm-common/kvm-config-arch.h
> >>+++ b/arm/include/arm-common/kvm-config-arch.h
> >>@@ -10,6 +10,8 @@ struct kvm_config_arch {
> >>  	bool		aarch32_guest;
> >>  	bool		has_pmuv3;
> >>  	u64		kaslr_seed;
> >>+	bool		enable_ptrauth;
> >>+	bool		disable_ptrauth;
> >>  	enum irqchip_type irqchip;
> >>  	u64		fw_addr;
> >>  };
> >>diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> >>index 7780251..acd1d5f 100644
> >>--- a/arm/kvm-cpu.c
> >>+++ b/arm/kvm-cpu.c
> >>@@ -68,6 +68,18 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >>  		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
> >>  	}
> >>+	/* Check Pointer Authentication command line arguments. */
> >>+	if (kvm->cfg.arch.enable_ptrauth && kvm->cfg.arch.disable_ptrauth)
> >>+		die("Both enable-ptrauth and disable-ptrauth option cannot be present");
> >
> >Preferably, print the leading dashes, the same as the user would see
> >on the command line (e.g., --enable-ptrauth, --disable-ptrauth).
> >
> >For brevity, we could write something like:
> >
> >		die("--enable-ptrauth conflicts with --disable-ptrauth");
> >
> >>+	/*
> >>+	 * Always enable Pointer Authentication if system supports
> >>+	 * this extension unless disable-ptrauth option is present.
> >>+	 */
> >>+	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> >>+	    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
> >>+	    !kvm->cfg.arch.disable_ptrauth)
> >>+			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
> >>+
> >>  	/*
> >>  	 * If the preferred target ioctl is successful then
> >>  	 * use preferred target else try each and every target type
> >>@@ -106,8 +118,12 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >>  			die("Unable to find matching target");
> >>  	}
> >>-	if (err || target->init(vcpu))
> >>-		die("Unable to initialise vcpu");
> >>+	if (err || target->init(vcpu)) {
> >>+		if (kvm->cfg.arch.enable_ptrauth)
> >>+			die("Unable to initialise vcpu with pointer authentication feature");
> >
> >We don't special-case this error message for any other feature yet:
> >there are a variety of reasons why we might have failed, so suggesting
> >that the failure is something to do with ptrauth may be misleading to
> >the user.
> >
> >If we want to be more informative, we could do something like the
> >following:
> >
> >	bool supported;
> >
> >	supported = kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> >		    kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC);
> >
> >	if (kvm->cfg.arch.enable_ptrauth && !supported)
> >		die("--enable-ptrauth not supported on this host");
> >
> >	if (supported && !kvm->cfg.arch.disable_ptrauth)
> >		vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
> >
> >	/* ... */
> >
> >	if (err || target->init(vcpu))
> >		die("Unable to initialise vcpu");
> >
> >We don't do this for any other feature today, but since it helps the
> >user to understand what went wrong it's probably a good idea.
> Yes this is more clear. As Mark has picked the core guest ptrauth patches. I
> will post this changes as standalone.

Sounds good.  (I also need to do that separately for SVE...)

Cheers
---Dave
