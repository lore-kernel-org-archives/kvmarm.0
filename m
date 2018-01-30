From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 13/16] firmware/psci: Expose SMCCC version through
 psci_ops
Date: Tue, 30 Jan 2018 12:09:33 +0000
Message-ID: <8a19a20a-1d4f-8d34-91a3-f1838d41bee7@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-14-marc.zyngier@arm.com>
 <20180129183933.GB24577@e107981-ln.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180129183933.GB24577@e107981-ln.cambridge.arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 29/01/18 18:39, Lorenzo Pieralisi wrote:
> On Mon, Jan 29, 2018 at 05:45:56PM +0000, Marc Zyngier wrote:
>> Since PSCI 1.0 allows the SMCCC version to be (indirectly) probed,
>> let's do that at boot time, and expose the version of the calling
>> convention as part of the psci_ops structure.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>  drivers/firmware/psci.c | 21 +++++++++++++++++++++
>>  include/linux/psci.h    |  6 ++++++
>>  2 files changed, 27 insertions(+)
>>
>> diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
>> index e9493da2b111..dd035aaa1c33 100644
>> --- a/drivers/firmware/psci.c
>> +++ b/drivers/firmware/psci.c
>> @@ -511,6 +511,26 @@ static void __init psci_init_migrate(void)
>>  	pr_info("Trusted OS resident on physical CPU 0x%lx\n", cpuid);
>>  }
>>  
>> +static void __init psci_init_smccc(u32 ver)
>> +{
>> +	int feature = PSCI_RET_NOT_SUPPORTED;
>> +
>> +	if (PSCI_VERSION_MAJOR(ver) >= 1)
>> +		feature = psci_features(ARM_SMCCC_VERSION_FUNC_ID);
>> +
>> +	if (feature == PSCI_RET_NOT_SUPPORTED) {
>> +		psci_ops.variant = SMCCC_VARIANT_1_0;
>> +	} else {
>> +		ver = invoke_psci_fn(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0);
>> +		if (ver != ARM_SMCCC_VERSION_1_1)
>> +			psci_ops.variant = SMCCC_VARIANT_1_0;
>> +		else
>> +			psci_ops.variant = SMCCC_VARIANT_1_1;
>> +	}
>> +
>> +	pr_info("SMC Calling Convention v1.%d\n", psci_ops.variant);
>> +}
>> +
>>  static void __init psci_0_2_set_functions(void)
>>  {
>>  	pr_info("Using standard PSCI v0.2 function IDs\n");
>> @@ -557,6 +577,7 @@ static int __init psci_probe(void)
>>  	psci_0_2_set_functions();
>>  
>>  	psci_init_migrate();
>> +	psci_init_smccc(ver);
> 
> Given that SMCCC_VARIANT_1_0 is already the default value (unless you do
> the same we did with the conduit) we can move psci_init_smccc() call
> inside the if below (that is there to detect a callable psci_features())
> and remove the check in psci_init_smccc(), up to you.

Yes, this makes sense.

> 
>>  
>>  	if (PSCI_VERSION_MAJOR(ver) >= 1) {
>>  		psci_init_cpu_suspend();
>> diff --git a/include/linux/psci.h b/include/linux/psci.h
>> index f2679e5faa4f..83fd16a37be3 100644
>> --- a/include/linux/psci.h
>> +++ b/include/linux/psci.h
>> @@ -31,6 +31,11 @@ enum psci_conduit {
>>  	PSCI_CONDUIT_HVC,
>>  };
>>  
>> +enum smccc_variant {
>> +	SMCCC_VARIANT_1_0,
>> +	SMCCC_VARIANT_1_1,
>> +};
>> +
>>  struct psci_operations {
>>  	u32 (*get_version)(void);
>>  	int (*cpu_suspend)(u32 state, unsigned long entry_point);
>> @@ -41,6 +46,7 @@ struct psci_operations {
>>  			unsigned long lowest_affinity_level);
>>  	int (*migrate_info_type)(void);
>>  	enum psci_conduit conduit;
>> +	enum smccc_variant variant;
> 
> Nit: I would add an smccc_ prefix to the variant field (or rename it
> to smccc_version).

I've renamed both the field and the enum to smccc_version (as well as
the members of the enum). This is definitely more consistent with the
symbols exposed by arm-smccc.h.

> 
> You can add my:
> 
> Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
