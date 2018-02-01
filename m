From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 14/18] firmware/psci: Expose SMCCC version through
 psci_ops
Date: Thu, 1 Feb 2018 12:48:30 +0000
Message-ID: <83ae5571-c3a2-65df-b7d8-4c7dccb1fb02@arm.com>
References: <20180201114657.7323-1-marc.zyngier@arm.com>
 <20180201114657.7323-15-marc.zyngier@arm.com>
 <87705115-ca05-4d35-a169-51e1f3676133@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <87705115-ca05-4d35-a169-51e1f3676133@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Robin Murphy <robin.murphy@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Jon Masters <jcm@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King - ARM Linux <linux@armlinux.org.uk>, Jayachandran C <jnair@caviumnetworks.com>, Hanjun Guo <guohanjun@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 01/02/18 12:32, Robin Murphy wrote:
> On 01/02/18 11:46, Marc Zyngier wrote:
>> Since PSCI 1.0 allows the SMCCC version to be (indirectly) probed,
>> let's do that at boot time, and expose the version of the calling
>> convention as part of the psci_ops structure.
>>
>> Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> ---
>>   drivers/firmware/psci.c | 19 +++++++++++++++++++
>>   include/linux/psci.h    |  6 ++++++
>>   2 files changed, 25 insertions(+)
>>
>> diff --git a/drivers/firmware/psci.c b/drivers/firmware/psci.c
>> index e9493da2b111..8631906c414c 100644
>> --- a/drivers/firmware/psci.c
>> +++ b/drivers/firmware/psci.c
>> @@ -61,6 +61,7 @@ bool psci_tos_resident_on(int cpu)
>>   
>>   struct psci_operations psci_ops = {
>>   	.conduit = PSCI_CONDUIT_NONE,
>> +	.smccc_version = SMCCC_VERSION_1_0,
>>   };
>>   
>>   typedef unsigned long (psci_fn)(unsigned long, unsigned long,
>> @@ -511,6 +512,23 @@ static void __init psci_init_migrate(void)
>>   	pr_info("Trusted OS resident on physical CPU 0x%lx\n", cpuid);
>>   }
>>   
>> +static void __init psci_init_smccc(u32 ver)
>> +{
>> +	int feature;
>> +
>> +	feature = psci_features(ARM_SMCCC_VERSION_FUNC_ID);
>> +
>> +	if (feature != PSCI_RET_NOT_SUPPORTED) {
>> +		ver = invoke_psci_fn(ARM_SMCCC_VERSION_FUNC_ID, 0, 0, 0);
>> +		if (ver != ARM_SMCCC_VERSION_1_1)
>> +			psci_ops.smccc_version = SMCCC_VERSION_1_0;
> 
> AFAICS, unless you somehow run psci_probe() twice *and* have 
> schizophrenic firmware, this assignment now does precisely nothing.

That's a leftover of a previous tracing hack I had...  Embarrassing.

> With the condition flipped and the redundant else case removed (or an 
> explanation of why I'm wrong...)
> 
> Reviewed-by: Robin Murphy <robin.murphy@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
