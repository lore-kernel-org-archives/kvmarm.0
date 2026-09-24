Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 501694FC8CF;
	Thu, 24 Sep 2026 23:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790292636; cv=none; b=XDaGphf/rVe4NcmIevISbTUODhG+vm7QHqr2S9NaBcukKXI57MxtCY0xnfHN9hCL42o4+IyP8Wh2o+PAseWabT+oaEpCvcxVFkeZ6bhfaxVPMROaoewJZj/RCEi3fDjhKY8zjLPynNrqpBuImtfly+vckrqgFyWT+WtOOsMnLWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790292636; c=relaxed/simple;
	bh=o5jjLLvdLx+mHh34vmnUPVowLVRcHX+QrLaCzvpL7t8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uhjs3v29PSDsC4K9D7ju/F/ViQJB8ThZy9Z+oB2yMhkhavJsQKgrYTaqxPtq9fEk+c1l0UXLxbvtwvZLdPq+6rCPsdlIOhfIIASDRV3mhf9JhDbcNcDhfbtxoyOnKyPOGszb4LSbo5Mney5vEjabTMcymzspdpgJ249Tjp9NEaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WF54MV3R; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WF54MV3R"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 286471E5E;
	Thu, 24 Sep 2026 16:30:31 -0700 (PDT)
Received: from [10.57.10.88] (unknown [10.57.10.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 339BE3F632;
	Thu, 24 Sep 2026 16:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790292634; bh=o5jjLLvdLx+mHh34vmnUPVowLVRcHX+QrLaCzvpL7t8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WF54MV3RqxVOWL0I8myGWcAs0hbJK8pEQz6EoOmO6ClVhbMVRW7r2NvLpbYPu//JK
	 Wp8X7oqpfqlcLy7qCXer7xKkbwVLcZU/6aGpAWEHwnrmkFf4iMTkQLvHGUTi9GyABy
	 XzJ8SYbRVKAOstgcBy3PkFhcnFqi/TcASycuxwGU=
Message-ID: <14c6a10d-2891-42ce-8dd8-9745be2f7347@arm.com>
Date: Fri, 25 Sep 2026 00:30:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 6/7] firmware: arm_rmm: Ensure the RMM has GPT entries
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
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-7-suzuki.poulose@arm.com>
 <20260924143821.00003491@oss.qualcomm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260924143821.00003491@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/09/2026 22:38, Jonathan Cameron wrote:
> On Thu, 24 Sep 2026 14:52:00 +0100
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
> 
>> From: Steven Price <steven.price@arm.com>
>>
>> The RMM maintains the state of all the granules in the system to make
>> sure that the host is abiding by the rules. This state can be maintained
>> at different granularity, per page (TRACKING_FINE) or per region
>> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the

...

>>
>> If the firmware requires us to manage the tracking or GPT memory,
>> deactivate the RMM and reclaim any memory donated at RMM activation.
>>
>> Apply the same checks when hotplugged memory is brought online.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> [ Switch to RMI_GPT_L1_INFO for checking GPTs and deactivate RMM ]
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> A few trivial comments. Either way on those
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

Thank you !
> 
>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 218 ++++++++++++++++++++++++++++++++-
>>   include/linux/arm-rmi-cmds.h   |   2 +
>>   2 files changed, 219 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 0859f256e192b..1a8f3debd844a 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> 
>> +
>> +/*
>> + * rmi_gpt_info - Query the GPT info for the given PAR.
>> + * @start: Base of the physical address region
>> + * @end: Top of the physical address region
>> + * @out_top: Top of the physical address region for which
>> + *		the GPT @out_gpt_par_state is valid
> 
> wrap to 80.
> 

Ack

>> + * @out_gpt_par_state: State of the GPT covered by [start, out_top)
>> + */
>> +static long rmi_gpt_info(unsigned long start, unsigned long end,
>> +			 unsigned long *out_top,
>> +			 unsigned long *out_gpt_par_state)
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
>> +
>> +/*
>> + * We do not support creating L1 GPTs yet. So, make sure that
>> + * all the regions are managed by the firmware.
> Wrap to 80 chars.
> 
> Not relevant to this patch, but when are you thinking we will support that?

Once we have a full firmware stack that implements the L1GPT (Firme in 
tf-a and tf-RMM) we will take it up. That won't come before the first
drop of KVM is merged.

>> +
>> +static int rmi_init_metadata(void)
>> +{
>> +	phys_addr_t start, end;
>> +	struct memblock_region *r;
>> +
>> +	for_each_mem_region(r) {
>> +		int ret;
>> +
>> +		/* Firmware-reserved NOMAP regions are not usable system RAM */
>> +		if (memblock_is_nomap(r))
>> +			continue;
>> +
>> +		start = PAGE_ALIGN(r->base);
>> +		end = PAGE_ALIGN_DOWN(r->base + r->size);
> 
> Add a comment on why rounding down.  Doe we expect that to ever be relevant?

Do we really need a comment here ? We always deal with PAGE_SIZE and if
in the odd case this region boundary is not PAGE aligned we stick to the
page that we can use from the region. I can stick in a comment if you
really think so.


...

>> @@ -843,9 +1049,19 @@ static int __init arm64_init_rmi(void)

...

>> -	return ret;
>> +	ret = rmi_init_memory();
>> +	if (ret) {
>> +		/* Deactivate the RMM */
>> +		WARN_ON(rmi_sro_memxfer_cmd(sro, GFP_KERNEL, SMC_RMI_RMM_DEACTIVATE));
>> +		return ret;
>> +	}
>> +
>> +	arm64_rmi_is_available = true;
>> +	pr_info("RMI configured\n");
> 
> Blank line nice for the eye to spot the return.

Ack

Thanks for your review !

Suzuki
