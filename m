From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [kvmtool PATCH v9 5/5] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
Date: Wed, 17 Apr 2019 16:38:02 +0100
Message-ID: <20190417153802.GD3567@e103592.cambridge.arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-6-git-send-email-amit.kachhap@arm.com>
 <20190416163221.GY3567@e103592.cambridge.arm.com>
 <364bccb9-a818-3cad-1885-724781b99c9e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <364bccb9-a818-3cad-1885-724781b99c9e@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 17, 2019 at 06:06:11PM +0530, Amit Daniel Kachhap wrote:
> Hi,
> 
> On 4/16/19 10:02 PM, Dave Martin wrote:
> >On Fri, Apr 12, 2019 at 08:50:36AM +0530, Amit Daniel Kachhap wrote:
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
> >>Changes since v8:
> >>*  Added option --enable-ptrauth and --disable-ptrauth to use ptrauth. Also
> >>    enable ptrauth if no option provided and Host supports ptrauth. [Dave Martin]
> >>* The macro definition are not linear as the kvmtool is not synchronised with the
> >>   kernel changes present in kvmarm/next tree.
> >>
> >>  arm/aarch32/include/kvm/kvm-cpu-arch.h    |  1 +
> >>  arm/aarch64/include/asm/kvm.h             |  2 ++
> >>  arm/aarch64/include/kvm/kvm-config-arch.h |  6 +++++-
> >>  arm/aarch64/include/kvm/kvm-cpu-arch.h    |  2 ++
> >>  arm/include/arm-common/kvm-config-arch.h  |  2 ++
> >>  arm/kvm-cpu.c                             | 11 +++++++++++
> >>  include/linux/kvm.h                       |  2 ++
> >>  7 files changed, 25 insertions(+), 1 deletion(-)
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
> >>index 7780251..a45a649 100644
> >>--- a/arm/kvm-cpu.c
> >>+++ b/arm/kvm-cpu.c
> >>@@ -69,6 +69,17 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> >>  	}
> >>  	/*
> >>+	 * Always enable Pointer Authentication if requested. If system supports
> >>+	 * this extension then also enable it by default provided no disable
> >>+	 * request present.
> >>+	 */
> >>+	if ((kvm->cfg.arch.enable_ptrauth) ||
> >
> >Nit: redundant ()
> ok.
> >
> >>+		(kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> >
> >Funny indentation?
> ok will align it.
> >
> >>+		kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC) &&
> >>+		!kvm->cfg.arch.disable_ptrauth))
> >>+			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
> >>+
> >
> >Hmm, we have some weird behaviours here: --enable-ptrauth
> >--disable-ptrauth will result in us trying to enable it, and
> May be 1 more check can be added here like,
> 
> if (kvm->cfg.arch.enable_ptrauth && kvm->cfg.arch.disable_ptrauth) {
> 	print_err("Only 1 option should be supplied\n");

Sure, but we should indicate which actual options conflicted.

> 	ret -EINVAL;
> }
> 
> >--enable-ptrauth without the required caps will result in an unhelpful
> >"Unable to initialise vcpu" error message.  I'm not sure this is a
> >whole lot worse than the way other options behave today, though.
> 
> Since now ptrauth is enabled by default if system supports it even though it
> is not explicitly requested. so I thought --enable-ptrauth
> option has to now forcefully enable ptrauth and may cause some error message
> in failure.
> Did I interpret something different from your last suggestion[1]?

No, this is what I meant.

> Actually we can skip with --enable-ptrauth and have just 2 option,
> * By default enable ptrauth if system supports it.
> * --disable-ptrauth: useful to migrate non-ptrauth guests on ptrauth hosts

I think --enable-ptrauth is still useful: with --disable-ptrauth,
ptrauth is definitely turned off; with --enable-ptrauth, ptrauth is
definitely turned on (or we refuse to start the guest at all); with
neither, ptrauth is on for the guest if the host supports it.

Cheers
---Dave
