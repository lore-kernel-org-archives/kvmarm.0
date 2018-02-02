From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 07/18] arm/arm64: KVM: Implement PSCI 1.0 support
Date: Fri, 2 Feb 2018 13:33:27 +0100
Message-ID: <20180202123327.GJ21802@cbox>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-8-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180201114657.7323-8-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Jones <drjones@redhat.com>, Hanjun Guo <guohanjun@huawei.com>, Jayachandran C <jnair@caviumnetworks.com>, Jon Masters <jcm@redhat.com>, Russell King - ARM Linux <linux@armlinux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 01, 2018 at 11:46:46AM +0000, Marc Zyngier wrote:
> PSCI 1.0 can be trivially implemented by having PSCI 0.2 and
> the FEATURES call. Of, and returning 1.0 as the PSCI version.

Of?  (Oh ?)

> 
> We happily ignore everything else, as it is optional.

nit: Might be worth mentioning that there are other changes between v0.2
but they are clarifications or relaxations and therefore don't require
additional changes.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_psci.h |  1 +
>  virt/kvm/arm/psci.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 5659343580a3..5446435457c2 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -22,6 +22,7 @@
>  
>  #define KVM_ARM_PSCI_0_1	PSCI_VERSION(0, 1)
>  #define KVM_ARM_PSCI_0_2	PSCI_VERSION(0, 2)
> +#define KVM_ARM_PSCI_1_0	PSCI_VERSION(1, 0)
>  
>  int kvm_psci_version(struct kvm_vcpu *vcpu);
>  int kvm_psci_call(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index c41553d35110..291874cff85e 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -313,6 +313,47 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> +static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
> +{
> +	u32 psci_fn = smccc_get_function(vcpu);
> +	u32 feature;
> +	unsigned long val;
> +	int ret = 1;
> +
> +	switch(psci_fn) {
> +	case PSCI_0_2_FN_PSCI_VERSION:
> +		val = KVM_ARM_PSCI_1_0;
> +		break;
> +	case PSCI_1_0_FN_PSCI_FEATURES:
> +		feature = smccc_get_arg1(vcpu);
> +		switch(feature) {
> +		case PSCI_0_2_FN_PSCI_VERSION:
> +		case PSCI_0_2_FN_CPU_SUSPEND:
> +		case PSCI_0_2_FN64_CPU_SUSPEND:
> +		case PSCI_0_2_FN_CPU_OFF:
> +		case PSCI_0_2_FN_CPU_ON:
> +		case PSCI_0_2_FN64_CPU_ON:
> +		case PSCI_0_2_FN_AFFINITY_INFO:
> +		case PSCI_0_2_FN64_AFFINITY_INFO:
> +		case PSCI_0_2_FN_MIGRATE_INFO_TYPE:
> +		case PSCI_0_2_FN_SYSTEM_OFF:
> +		case PSCI_0_2_FN_SYSTEM_RESET:
> +		case PSCI_1_0_FN_PSCI_FEATURES:
> +			val = 0;
> +			break;
> +		default:
> +			val = PSCI_RET_NOT_SUPPORTED;
> +			break;
> +		}
> +		break;
> +	default:
> +		return kvm_psci_0_2_call(vcpu);
> +	}
> +
> +	smccc_set_retval(vcpu, val, 0, 0, 0);
> +	return ret;
> +}
> +
>  static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> @@ -355,6 +396,8 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
>  int kvm_psci_call(struct kvm_vcpu *vcpu)
>  {
>  	switch (kvm_psci_version(vcpu)) {
> +	case KVM_ARM_PSCI_1_0:
> +		return kvm_psci_1_0_call(vcpu);
>  	case KVM_ARM_PSCI_0_2:
>  		return kvm_psci_0_2_call(vcpu);
>  	case KVM_ARM_PSCI_0_1:
> -- 
> 2.14.2
> 
