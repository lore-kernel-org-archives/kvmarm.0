From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [kvmtool PATCH v8 9/9] KVM: arm/arm64: Add a vcpu feature for
 pointer authentication
Date: Fri, 5 Apr 2019 12:04:23 +0100
Message-ID: <20190405110423.GV3567@e103592.cambridge.arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-10-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1554172037-4516-10-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 02, 2019 at 07:57:17AM +0530, Amit Daniel Kachhap wrote:
> This is a runtime capabality for KVM tool to enable Arm64 8.3 Pointer
> Authentication in guest kernel. Two vcpu features
> KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] are supplied together to enable
> Pointer Authentication in KVM guest after checking the capability.
> 
> A command line option --ptrauth is also required to select this feature.
> 
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> ---
> 
> Changes since v7:
> * Added check for capability KVM_CAP_ARM_PTRAUTH_GENERIC
> 
>  arm/aarch32/include/kvm/kvm-cpu-arch.h    | 1 +
>  arm/aarch64/include/asm/kvm.h             | 2 ++
>  arm/aarch64/include/kvm/kvm-config-arch.h | 4 +++-
>  arm/aarch64/include/kvm/kvm-cpu-arch.h    | 2 ++
>  arm/include/arm-common/kvm-config-arch.h  | 1 +
>  arm/kvm-cpu.c                             | 7 +++++++
>  include/linux/kvm.h                       | 2 ++
>  7 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/aarch32/include/kvm/kvm-cpu-arch.h b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> index d28ea67..520ea76 100644
> --- a/arm/aarch32/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch32/include/kvm/kvm-cpu-arch.h
> @@ -13,4 +13,5 @@
>  #define ARM_CPU_ID		0, 0, 0
>  #define ARM_CPU_ID_MPIDR	5
>  
> +#define ARM_VCPU_PTRAUTH_FEATURE	0
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
> index 97c3478..d4d0d8c 100644
> --- a/arm/aarch64/include/asm/kvm.h
> +++ b/arm/aarch64/include/asm/kvm.h
> @@ -102,6 +102,8 @@ struct kvm_regs {
>  #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
>  #define KVM_ARM_VCPU_PSCI_0_2		2 /* CPU uses PSCI v0.2 */
>  #define KVM_ARM_VCPU_PMU_V3		3 /* Support guest PMUv3 */
> +#define KVM_ARM_VCPU_PTRAUTH_ADDRESS	4 /* CPU uses address pointer authentication */
> +#define KVM_ARM_VCPU_PTRAUTH_GENERIC	5 /* CPU uses generic pointer authentication */
>  
>  struct kvm_vcpu_init {
>  	__u32 target;
> diff --git a/arm/aarch64/include/kvm/kvm-config-arch.h b/arm/aarch64/include/kvm/kvm-config-arch.h
> index 04be43d..2074684 100644
> --- a/arm/aarch64/include/kvm/kvm-config-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-config-arch.h
> @@ -8,7 +8,9 @@
>  			"Create PMUv3 device"),				\
>  	OPT_U64('\0', "kaslr-seed", &(cfg)->kaslr_seed,			\
>  			"Specify random seed for Kernel Address Space "	\
> -			"Layout Randomization (KASLR)"),
> +			"Layout Randomization (KASLR)"),		\
> +	OPT_BOOLEAN('\0', "ptrauth", &(cfg)->has_ptrauth,		\
> +			"Enable address authentication"),

This should probably say "pointer", not "address" now, since we enable
both kinds of ptrauth together.  (Sorry!)

When discussing how to control SVE, I was eventually convinced that it
is more user-friendly to make SVE default to on if present, and maybe
provide two options --disable-sve, --enable-sve, in case the user wants
to force it off or on instead of just getting what the host supports.

Passing --enable-sve on a host that doesn't support SVE would then lead
to kvmtool bailing out with an error, which is probably better then
silently turning it off.

I don't have this change in my kvmtool patches yet.

What's your view?  It makes sense to do things the same way for all
features if we can.

>  #include "arm-common/kvm-config-arch.h"
>  
> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> index a9d8563..fcc2107 100644
> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
> @@ -17,4 +17,6 @@
>  #define ARM_CPU_CTRL		3, 0, 1, 0
>  #define ARM_CPU_CTRL_SCTLR_EL1	0
>  
> +#define ARM_VCPU_PTRAUTH_FEATURE	((1UL << KVM_ARM_VCPU_PTRAUTH_ADDRESS) \
> +					| (1UL << KVM_ARM_VCPU_PTRAUTH_GENERIC))
>  #endif /* KVM__KVM_CPU_ARCH_H */
> diff --git a/arm/include/arm-common/kvm-config-arch.h b/arm/include/arm-common/kvm-config-arch.h
> index 5734c46..5badcbd 100644
> --- a/arm/include/arm-common/kvm-config-arch.h
> +++ b/arm/include/arm-common/kvm-config-arch.h
> @@ -10,6 +10,7 @@ struct kvm_config_arch {
>  	bool		aarch32_guest;
>  	bool		has_pmuv3;
>  	u64		kaslr_seed;
> +	bool		has_ptrauth;
>  	enum irqchip_type irqchip;
>  	u64		fw_addr;
>  };
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 7780251..398c9d6 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -68,6 +68,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  		vcpu_init.features[0] |= (1UL << KVM_ARM_VCPU_PSCI_0_2);
>  	}
>  
> +	/* Set KVM_ARM_VCPU_PTRAUTH_[ADDRESS/GENERIC] if available */
> +	if (kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
> +		kvm__supports_extension(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC)) {
> +		if (kvm->cfg.arch.has_ptrauth)
> +			vcpu_init.features[0] |= ARM_VCPU_PTRAUTH_FEATURE;
> +	}
> +
>  	/*
>  	 * If the preferred target ioctl is successful then
>  	 * use preferred target else try each and every target type
> diff --git a/include/linux/kvm.h b/include/linux/kvm.h
> index 6d4ea4b..500ac2b 100644
> --- a/include/linux/kvm.h
> +++ b/include/linux/kvm.h
> @@ -988,6 +988,8 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_ARM_VM_IPA_SIZE 165
>  #define KVM_CAP_MANUAL_DIRTY_LOG_PROTECT 166
>  #define KVM_CAP_HYPERV_CPUID 167
> +#define KVM_CAP_ARM_PTRAUTH_ADDRESS 168
> +#define KVM_CAP_ARM_PTRAUTH_GENERIC 169

(Note, 168 will probably be KVM_CAP_ARM_SVE, now that the SVE patches
are in kvmarm/next.)

Cheers
---Dave
