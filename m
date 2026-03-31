Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D613AA502;
	Tue, 31 Mar 2026 11:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774955154; cv=none; b=gku/mTitXTuLad9FcXLWp1YsuHqvxjGTVzppNtIdtcinslI79E1OkQwZx8TtCq5x+Hmd05MoQiPWVu9PjULOUxDj5vtowuCOEOYtIWtZ+dSQJhGd+m1tbjiUTwkK6il4H6YE6U87nKExx4xHKvE+GmibTK7QLIBCLseQGLzPBWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774955154; c=relaxed/simple;
	bh=SXqEk71BSaaBeUSF2ew0z1un4HM7vo7rVW84ixT4WY4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VAm6lXFtULMaiU+xN7C+uySIaGsYiylO5z3CZ1u26QICMLKiUTWHZtoehl9I1Qvz5FqalecPFdt+m0QeNfLoqhNcJTIAMiSuyo8nJzzU+aMKRUNxVlgPbmw35/K4rxUFxwCuu49QlgIbix9BLaWoXqttwKex0X7FMKc7p0hNf8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=H7Gb0/Lc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="H7Gb0/Lc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3D4C4983;
	Tue, 31 Mar 2026 04:05:45 -0700 (PDT)
Received: from [10.57.17.66] (unknown [10.57.17.66])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EF3FA3F641;
	Tue, 31 Mar 2026 04:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774955151; bh=SXqEk71BSaaBeUSF2ew0z1un4HM7vo7rVW84ixT4WY4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=H7Gb0/LcvB0+eLbF5RvOApy2pS6wZvhm623HaPVBt4XeMLB0uQZ16neUC2vLOdAzl
	 0soNXv7Pgbu6loJbbx8OAh8hXbrM4Vw+1kwi75/1fWNtgf32alsML8n3SklnvDsOPy
	 2ZY0jSixIxU7I23ihVmOkK9wYuhcN3f7T3RfUEEk=
Message-ID: <152f5070-fda6-4381-bc40-4a70908c27c1@arm.com>
Date: Tue, 31 Mar 2026 12:05:47 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/48] arm64: RMI: Ensure that the RMM has GPT entries
 for memory
Content-Language: en-GB
To: Mathieu Poirier <mathieu.poirier@linaro.org>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-11-steven.price@arm.com> <acrj-cKphy4hJsEG@p14s>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <acrj-cKphy4hJsEG@p14s>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Mathieu,

On 30/03/2026 21:58, Mathieu Poirier wrote:
> Hi,
> 
> On Wed, Mar 18, 2026 at 03:53:34PM +0000, Steven Price wrote:
>> The RMM may not be tracking all the memory of the system at boot. Create
>> the necessary tracking state and GPTs within the RMM so that all boot
>> memory can be delegated to the RMM as needed during runtime.
>>
>> Note: support is currently missing for SROs which means that if the RMM
>> needs memory donating this will fail (and render CCA unusable in Linux).
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v13
>> ---
>>   arch/arm64/kvm/rmi.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 89 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 9590dff9a2c1..80aedc85e94a 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -4,6 +4,7 @@
>>    */
>>   
>>   #include <linux/kvm_host.h>
>> +#include <linux/memblock.h>
>>   
>>   #include <asm/kvm_pgtable.h>
>>   #include <asm/rmi_cmds.h>
>> @@ -56,6 +57,18 @@ static int rmi_check_version(void)
>>   	return 0;
>>   }
>>   
>> +/*
>> + * These are the 'default' sizes when passing 0 as the tracking_region_size.
>> + * TODO: Support other granule sizes
>> + */
>> +#ifdef CONFIG_PAGE_SIZE_4KB
>> +#define RMM_GRANULE_TRACKING_SIZE	SZ_1G
>> +#elif defined(CONFIG_PAGE_SIZE_16KB)
>> +#define RMM_GRANULE_TRACKING_SIZE	SZ_32M
>> +#elif defined(CONFIG_PAGE_SIZE_64KB)
>> +#define RMM_GRANULE_TRACKING_SIZE	SZ_512M
>> +#endif
>> +
>>   static int rmi_configure(void)
>>   {
>>   	struct rmm_config *config __free(free_page) = NULL;
>> @@ -95,6 +108,80 @@ static int rmi_configure(void)
>>   	return 0;
>>   }
>>   
>> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
>> +{
>> +	start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
> 
> This will produce an error on systems where the start of system memory is not
> aligned to RMM_GRANULE_TRACKING_SIZE.  For instance, on QEMU-SBSA the system
> memory starts at 0x100_4300_0000.  With the above and RMM_GRANULE_TRACKING_SIZE
> set to SZ_1G, @start becomes 0x100_4000_0000, which falls outside the memory map
> known to the TF-A.  I fixed it with these modifications:

Thanks for raising this. This would need to be addressed in the RMM
spec, I have raised it with the team and will be addressed soon.

> 
> LINUX:
> 
> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
> index 10ff1c3bddaf..21bfbbe2f047 100644
> --- a/arch/arm64/kvm/rmi.c
> +++ b/arch/arm64/kvm/rmi.c
> @@ -424,7 +424,9 @@ static int rmi_configure(void)
>   
>   static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
>   {
> -       start = ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
> +       phys_addr_t offset;
> +
> +       offset = start - ALIGN_DOWN(start, RMM_GRANULE_TRACKING_SIZE);
>          end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
>   
>          while (start < end) {
> @@ -439,7 +441,13 @@ static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
>                                  start);
>                          return -ENODEV;
>                  }
> -               start += RMM_GRANULE_TRACKING_SIZE;
> +
> +               if (offset) {
> +                       start += (RMM_GRANULE_TRACKING_SIZE - offset);
> +                       offset = 0;
> +               } else {
> +                       start += RMM_GRANULE_TRACKING_SIZE;
> +               }
>          }
>   
>          return 0;
> 
> RMM:
> 
> diff --git a/runtime/rmi/granule.c b/runtime/rmi/granule.c
> index cef521fc0869..60358d9ee81e 100644
> --- a/runtime/rmi/granule.c
> +++ b/runtime/rmi/granule.c
> @@ -209,9 +209,11 @@ void smc_granule_tracking_get(unsigned long addr,
>                  return;
>          }
>   
> +#if 0
>          if (!ALIGNED(addr, RMM_INTERNAL_TRACKING_REGION_SIZE)) {
>                  return;
>          }
> +#endif
>   
>          g = find_granule(addr);
>          if (g != NULL) {
> 
> This is likely not the right fix but hopefully provides some guidance.  Send me
> your patches when you have an idea and I'll test them.

We will send you the update once it is fixed in the RMM spec. The rough 
idea is to remove the ALIGNMENT restrictions and return a Range that
the host can iterate over to find "regions" with the same type of
memory.


Cheers
Suzuki


> 
> Thanks,
> Mathieu
> 
> 
>> +	end = ALIGN(end, RMM_GRANULE_TRACKING_SIZE);
>> +
>> +	while (start < end) {
>> +		unsigned long ret, category, state;
>> +
>> +		ret = rmi_granule_tracking_get(start, &category, &state);
>> +		if (ret != RMI_SUCCESS ||
>> +		    state != RMI_TRACKING_FINE ||
>> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
>> +			/* TODO: Set granule tracking in this case */
>> +			kvm_err("Granule tracking for region isn't fine/conventional: %llx",
>> +				start);
>> +			return -ENODEV;
>> +		}
>> +		start += RMM_GRANULE_TRACKING_SIZE;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static unsigned long rmi_l0gpt_size(void)
>> +{
>> +	return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +				      rmm_feat_reg1));
>> +}
>> +
>> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
>> +{
>> +	unsigned long l0gpt_sz = rmi_l0gpt_size();
>> +
>> +	start = ALIGN_DOWN(start, l0gpt_sz);
>> +	end = ALIGN(end, l0gpt_sz);
>> +
>> +	while (start < end) {
>> +		int ret = rmi_gpt_l1_create(start);
>> +
>> +		if (ret && ret != RMI_ERROR_GPT) {
>> +			/*
>> +			 * FIXME: Handle SRO so that memory can be donated for
>> +			 * the tables.
>> +			 */
>> +			kvm_err("GPT Level1 table missing for %llx\n", start);
>> +			return -ENOMEM;
>> +		}
>> +		start += l0gpt_sz;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int rmi_init_metadata(void)
>> +{
>> +	phys_addr_t start, end;
>> +	const struct memblock_region *r;
>> +
>> +	for_each_mem_region(r) {
>> +		int ret;
>> +
>> +		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
>> +		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
>> +		ret = rmi_verify_memory_tracking(start, end);
>> +		if (ret)
>> +			return ret;
>> +		ret = rmi_create_gpts(start, end);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int rmm_check_features(void)
>>   {
>>   	if (kvm_lpa2_is_enabled() && !rmi_has_feature(RMI_FEATURE_REGISTER_0_LPA2)) {
>> @@ -120,6 +207,8 @@ void kvm_init_rmi(void)
>>   		return;
>>   	if (rmi_configure())
>>   		return;
>> +	if (rmi_init_metadata())
>> +		return;
>>   
>>   	/* Future patch will enable static branch kvm_rmi_is_available */
>>   }
>> -- 
>> 2.43.0
>>
>>

