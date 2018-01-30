From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 10/16] arm64: KVM: Report SMCCC_ARCH_WORKAROUND_1 BP
 hardening support
Date: Tue, 30 Jan 2018 12:38:35 +0000
Message-ID: <748db3f9-bf6c-17d6-ff92-e814ec06aa20@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-11-marc.zyngier@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/18 17:45, Marc Zyngier wrote:
> A new feature of SMCCC 1.1 is that it offers firmware-based CPU
> workarounds. In particular, SMCCC_ARCH_WORKAROUND_1 provides
> BP hardening for CVE-2017-5715.
> 
> If the host has some mitigation for this issue, report that
> we deal with it using SMCCC_ARCH_WORKAROUND_1, as we apply the
> host workaround on every guest exit.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   include/linux/arm-smccc.h |  5 +++++
>   virt/kvm/arm/psci.c       | 17 +++++++++++++++--
>   2 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> index dc68aa5a7261..e1ef944ef1da 100644
> --- a/include/linux/arm-smccc.h
> +++ b/include/linux/arm-smccc.h
> @@ -73,6 +73,11 @@
>   			   ARM_SMCCC_SMC_32,				\
>   			   0, 1)
>   
> +#define ARM_SMCCC_ARCH_WORKAROUND_1					\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
> +			   ARM_SMCCC_SMC_32,				\
> +			   0, 0x8000)
> +
>   #ifndef __ASSEMBLY__
>   
>   #include <linux/linkage.h>
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index a021b62ed762..5677d16abc71 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
> @@ -407,14 +407,27 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
>   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   {
>   	u32 func_id = smccc_get_function(vcpu);
> -	u32 val;
> +	u32 val, feature;
>   
>   	switch (func_id) {
>   	case ARM_SMCCC_VERSION_FUNC_ID:
>   		val = ARM_SMCCC_VERSION_1_1;
>   		break;
>   	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> -		val = -1;	/* Nothing supported yet */

Conceptually, might it still make sense to initialise val to 
NOT_SUPPORTED here, then overwrite it if and when a feature actually is 
present? It would in this case save a few lines as well, but I know 
multiple assignment can be one of those religious issues, so I'm not too 
fussed either way.

Robin.

> +		feature = smccc_get_arg1(vcpu);
> +		switch(feature) {
> +#ifdef CONFIG_ARM64
> +		case ARM_SMCCC_ARCH_WORKAROUND_1:
> +			if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR))
> +				val = 0;
> +			else
> +				val = -1;
> +			break;
> +#endif
> +		default:
> +			val = -1;
> +			break;
> +		}
>   		break;
>   	default:
>   		return kvm_psci_call(vcpu);
> 
