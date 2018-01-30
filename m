From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 13/16] firmware/psci: Expose SMCCC version through
 psci_ops
Date: Tue, 30 Jan 2018 12:55:01 +0000
Message-ID: <c1fddec5-4d8a-5e43-470b-855b0dba705e@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-14-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129174559.1866-14-marc.zyngier@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/18 17:45, Marc Zyngier wrote:
> Since PSCI 1.0 allows the SMCCC version to be (indirectly) probed,
> let's do that at boot time, and expose the version of the calling
> convention as part of the psci_ops structure.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   drivers/firmware/psci.c | 21 +++++++++++++++++++++
>   include/linux/psci.h    |  6 ++++++
>   2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
> index e9493da2b111..dd035aaa1c33 100644
> --- a/drivers/firmware/psci.c
> +++ b/drivers/firmware/psci.c
> @@ -511,6 +511,26 @@ static void __init psci_init_migrate(void)
>   	pr_info("Trusted OS resident on physical CPU 0x%lx\n", cpuid);
>   }
>   
> +static void __init psci_init_smccc(u32 ver)
> +{
> +	int feature = PSCI_RET_NOT_SUPPORTED;
> +
> +	if (PSCI_VERSION_MAJOR(ver) >= 1)
> +		feature = psci_features(ARM_SMCCC_VERSION_FUNC_ID);
> +
> +	if (feature == PSCI_RET_NOT_SUPPORTED) {
> +		psci_ops.variant = SMCCC_VARIANT_1_0;

Presumably at some point in the future we might want to update PSCI 
itself to use 'fast' calls if available, at which point this 
initialisation is a bit backwards given that you've already made a call 
using *some* convention. Even I think relying on the enum value working 
out OK is a bit subtle, so perhaps it's best to default-initialise 
psci_ops.variant to 1.0 (either statically, or dynamically before the 
first call), then only update it to 1.1 if and when we discover that.

Robin.

> +	} else {
> +		ver = invoke_psci_fn(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0);
> +		if (ver != ARM_SMCCC_VERSION_1_1)
> +			psci_ops.variant = SMCCC_VARIANT_1_0;
> +		else
> +			psci_ops.variant = SMCCC_VARIANT_1_1;
> +	}
> +
> +	pr_info("SMC Calling Convention v1.%d\n", psci_ops.variant);
> +}
> +
>   static void __init psci_0_2_set_functions(void)
>   {
>   	pr_info("Using standard PSCI v0.2 function IDs\n");
> @@ -557,6 +577,7 @@ static int __init psci_probe(void)
>   	psci_0_2_set_functions();
>   
>   	psci_init_migrate();
> +	psci_init_smccc(ver);
>   
>   	if (PSCI_VERSION_MAJOR(ver) >= 1) {
>   		psci_init_cpu_suspend();
> diff --git a/include/linux/psci.h b/include/linux/psci.h
> index f2679e5faa4f..83fd16a37be3 100644
> --- a/include/linux/psci.h
> +++ b/include/linux/psci.h
> @@ -31,6 +31,11 @@ enum psci_conduit {
>   	PSCI_CONDUIT_HVC,
>   };
>   
> +enum smccc_variant {
> +	SMCCC_VARIANT_1_0,
> +	SMCCC_VARIANT_1_1,
> +};
> +
>   struct psci_operations {
>   	u32 (*get_version)(void);
>   	int (*cpu_suspend)(u32 state, unsigned long entry_point);
> @@ -41,6 +46,7 @@ struct psci_operations {
>   			unsigned long lowest_affinity_level);
>   	int (*migrate_info_type)(void);
>   	enum psci_conduit conduit;
> +	enum smccc_variant variant;
>   };
>   
>   extern struct psci_operations psci_ops;
> 
