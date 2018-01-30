From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 13/16] firmware/psci: Expose SMCCC version through
 psci_ops
Date: Tue, 30 Jan 2018 13:51:22 +0000
Message-ID: <6bb72d9d-ac47-70c1-19a1-25d2bd477018@arm.com>
References: <20180129174559.1866-1-marc.zyngier@arm.com>
 <20180129174559.1866-14-marc.zyngier@arm.com>
 <c1fddec5-4d8a-5e43-470b-855b0dba705e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c1fddec5-4d8a-5e43-470b-855b0dba705e@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jon Masters <jcm@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 30/01/18 12:55, Robin Murphy wrote:
> On 29/01/18 17:45, Marc Zyngier wrote:
>> Since PSCI 1.0 allows the SMCCC version to be (indirectly) probed,
>> let's do that at boot time, and expose the version of the calling
>> convention as part of the psci_ops structure.
>>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   drivers/firmware/psci.c | 21 +++++++++++++++++++++
>>   include/linux/psci.h    |  6 ++++++
>>   2 files changed, 27 insertions(+)
>>
>> diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
>> index e9493da2b111..dd035aaa1c33 100644
>> --- a/drivers/firmware/psci.c
>> +++ b/drivers/firmware/psci.c
>> @@ -511,6 +511,26 @@ static void __init psci_init_migrate(void)
>>   	pr_info("Trusted OS resident on physical CPU 0x%lx\n", cpuid);
>>   }
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
> 
> Presumably at some point in the future we might want to update PSCI 
> itself to use 'fast' calls if available, at which point this 
> initialisation is a bit backwards given that you've already made a call 
> using *some* convention. Even I think relying on the enum value working 
> out OK is a bit subtle, so perhaps it's best to default-initialise 
> psci_ops.variant to 1.0 (either statically, or dynamically before the 
> first call), then only update it to 1.1 if and when we discover that.

Indeed. Lorenzo already suggested something along those lines, and I now
(statically) default to 1.0.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
