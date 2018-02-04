From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 11/18] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP
 hardening support
Date: Sun, 4 Feb 2018 19:39:01 +0100
Message-ID: <20180204183901.GO21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-12-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-12-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 11:46:50AM +0000, Marc Zyngier wrote:
> A new feature of SMCCC 1.1 is that it offers firmware-based CPU
> workarounds. In particular, SMCCC_ARCH_WORKAROUND_1 provides
> BP hardening for CVE-2017-5715.
> 
> If the host has some mitigation for this issue, report that
> we deal with it using SMCCC_ARCH_WORKAROUND_1, as we apply the
> host workaround on every guest exit.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 7 +++++++
>  arch/arm64/include/asm/kvm_host.h | 6 ++++++
>  include/linux/arm-smccc.h         | 5 +++++
>  virt/kvm/arm/psci.c               | 9 ++++++++-
>  4 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index e9d57060d88c..6c05e3b13081 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -309,4 +309,11 @@ static inline void kvm_fpsimd_flush_cpu_state(void) {}
>  
>  static inline void kvm_arm_vhe_guest_enter(void) {}
>  static inline void kvm_arm_vhe_guest_exit(void) {}
> +
> +static inline bool kvm_arm_harden_branch_predictor(void)
> +{
> +	/* No way to detect it yet, pretend it is not there. */
> +	return false;
> +}
> +
>  #endif /* __ARM_KVM_HOST_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 10af386642c6..448d3b9a58cb 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -418,4 +418,10 @@ static inline void kvm_arm_vhe_guest_exit(void)
>  {
>  	local_daif_restore(DAIF_PROCCTX_NOIRQ);
>  }
> +
> +static inline bool kvm_arm_harden_branch_predictor(void)
> +{
> +	return cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR);
> +}
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index dc68aa5a7261..e1ef944ef1da 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -73,6 +73,11 @@
>  			   ARM_SMCCC_SMC_32,				\
>  			   0, 1)
>  
> +#define ARM_SMCCC_ARCH_WORKAROUND_1					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   0, 0x8000)
> +
>  #ifndef __ASSEMBLY__
>  
>  #include <linux/linkage.h>
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 2efacbe7b1a2..22c24561d07d 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -406,13 +406,20 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
>  	u32 func_id = smccc_get_function(vcpu);
>  	u32 val = PSCI_RET_NOT_SUPPORTED;
> +	u32 feature;
>  
>  	switch (func_id) {
>  	case ARM_SMCCC_VERSION_FUNC_ID:
>  		val = ARM_SMCCC_VERSION_1_1;
>  		break;
>  	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> -		/* Nothing supported yet */
> +		feature = smccc_get_arg1(vcpu);
> +		switch(feature) {
> +		case ARM_SMCCC_ARCH_WORKAROUND_1:
> +			if (kvm_arm_harden_branch_predictor())
> +				val = 0;
> +			break;
> +		}
>  		break;
>  	default:
>  		return kvm_psci_call(vcpu);
> -- 
> 2.14.2
> 
