Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17FFB34EF15;
	Mon, 21 Sep 2026 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983184; cv=none; b=gSRtc1BoMNdZ3tYgl4msoeAX4lFXEVbvClA0X6jfPiagnoeVl0gGvA6q8S3ihLHCG06GHVzR9O+yAv6eVm1dkOPdHYmBZXK13HgjdIIFv7ygiC5bTHgYq68MplI84UaN9TWvOlF79tHX0dOGn210B8bGJMUkDkywrU9d//xeehA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983184; c=relaxed/simple;
	bh=B+BCQeVg0IeeUhu6Ob/UgCt/CZY7OCEK8gMHWMyBohk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aX3f6EksUURliZyFcqINHzjD5B86B7XI96FnI4qYTh+hI6YV9cANowbogFNDhrAgtDbCihyHLO8hRswIi3i84aFHlxnrRFk9mr8XPqjSNeo7VO9sVQtE2Oa9rvFDE3WNpRRpGu0IsKTcNdGs3Wb8aJv6gmFY2G/rU8mhqA2oCbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vrTxUkU5; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vrTxUkU5"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAEA61476;
	Mon, 21 Sep 2026 02:32:58 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28C9B3F86F;
	Mon, 21 Sep 2026 02:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789983182; bh=B+BCQeVg0IeeUhu6Ob/UgCt/CZY7OCEK8gMHWMyBohk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vrTxUkU5EokJyM+O6vocnZOre+9Hm/zL/psZb2j5wq0ib0aPS77g8TxaTl+R6pBo7
	 vxkpDKVN4HocH01hrrylZzzdL9upfpdvpXEealrDA1Ba5SMWmFOqqaqVjfxjeLR5jt
	 DSNnAGCwoigCPtBiotCwuNvfddJajT2mvtAGQIxM=
Message-ID: <65b0c03b-36b9-4e60-aa55-c3b4b85e21ee@arm.com>
Date: Mon, 21 Sep 2026 10:32:57 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-7-suzuki.poulose@arm.com>
 <178978126543.2352296.12214136703168879825.b4-review@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <178978126543.2352296.12214136703168879825.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/09/2026 02:27, Jonathan Cameron wrote:
>> The RMM maintains the state of all the granules in the system to make
>> sure that the host is abiding by the rules. This state can be maintained
>> at different granularity, per page (TRACKING_FINE) or per region
>> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
>> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region, all pages
>> in the region must be of the same state, this implies we need to have "fine"
>> tracking for DRAM, so that we can delegate individual pages.
>>
>> For now we only support a statically carved out memory for tracking
>> granules for the "fine" regions. This can be extended in the future to
>> allow modifying the tracking granularity and remove the need for a
>> static allocation by the firmware.
>>
>> Similarly, the firmware may create L0 GPT entries describing the total
>> address space. But if we change the "PAS" (Physical Address Space) of a
>> granule, then the firmware may need to create L1 tables to track the PAS
>> at a finer granularity. Linux therefore checks if the platform firmware manages
>> the PAR region. i.e., the firmware is in charge of managing the L1 GPTs
>> (creation and the required memory for the GPT tables - via static carveouts)
>> without host intervention. Support for dynamic GPT creation by the host will be
>> added later.
>>
>> If the firmware requires us to manage the tracking or GPT memory, Deactivate
>> the RMM and reclaim any memory donated at RMM activation.
>>
>> Apply the same checks when hotplugged memory is brought online.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> [ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
>> Co-Developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> A few comments inline.
> 
> 
>> ---
>>   Changes since v17:
>>       * Move wrappers that may not be used elsewhere, out of arm-rmi-cmds.h
>>   Changes since v16:
>>       * Check fine tracking and create L1 GPTs for hotplug-added memory.
>>       * Clarify the L1 GPT setup and move the explanatory comment.
>>       * Switch to using RMI_GPT_INFO command for checking the GPTs.
>>       * Deactivate the RMM and reclaim the memory if we can't proceed.
>>   Changes since v15:
>>       * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
>>       * Handle negative error codes from wrappers.
>>   Changes since v14:
>>       * Move the implementation into drivers/firmware/arm_rmm.
>>   Changes since v13:
>>       * Moved out of KVM
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 200 +++++++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h   |   2 +
>>   2 files changed, 202 insertions(+)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index ecc89e91d264..583e1aca9b15 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> 
>> + */
>> +static inline long rmi_gpt_info(unsigned long start, unsigned long end,
> 
> Why inline vs letting compiler make it's mind up?
> Same in other places
> 
>> +				unsigned long *out_top,
>> +				unsigned long *out_gpt_par_state)
>> +{
>> +	struct arm_smccc_1_2_regs regs = {
>> +		SMC_RMI_GPT_INFO, start, end,
>> +	};
>> +
>> +	rmi_smccc_invoke(&regs);
>> +	if (regs.a0 != RMI_SUCCESS)
>> +		return regs.a0;
>> +
>> +	if (out_top)
>> +		*out_top = regs.a1;
>> +	if (out_gpt_par_state)
>> +		*out_gpt_par_state = regs.a2;
>> +
>> +	return RMI_SUCCESS;
>> +}
> 
> 
> 
>>   static int __init arm64_init_rmi(void)
>>   {
>>   	int ret;
>> @@ -786,8 +970,24 @@ static int __init arm64_init_rmi(void)
>>   	if (ret) {
>>   		pr_err("RMM activate failed\n");
>>   		ret = ret < 0 ? ret : -ENXIO;
>> +		return ret;
> 
> Why did this change?

Rebase messed up. I will restore it.

> 
>>   	}
>>   
>> +	ret = rmi_init_metadata();
>> +	if (ret)
> 
> And this is hitting another bit of guidance in cleanup.h.
> Functions shouldn't be mixing __free and friends with
> gotos.  Again, not a bug here but there are large ugly
> monsters around this stuff, hence the blanket guidance.
> I haven't thought that hard on how you avoid it here, but
> usually it's a combination of suitable helpers and wrappers
> and resulting code is often more readable as a result.
> 

I will see if I can improve it.

Cheers
Suzuki

