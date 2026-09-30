Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB792DF128;
	Wed, 30 Sep 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783751; cv=none; b=R190P4N8/MoDi0VIPFl1zqwDYlGZVFjikLAyGyOiFQIYFgp/XqJq6l37xLzxoZqDxmxL/Ucc+hv5aozQ6hnsXNCfFzpgZPjfp6QK2N7NajaqCajW+XKFl+emDNtpujip2f4kZu47fNqsqVYHcdOiAVzDjGvaQu6CaKkBfxPyZsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783751; c=relaxed/simple;
	bh=Bc5mWey1FMzal2RQfaDFWEDiyRbRNQu+XKVSnU+udT4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUD/P989HLAJZN0e32ncs0s7RRvEUS06WQ/M0+QjKwv8zc/DahMZrDjSJgEU7z9A3Zi8QROtf9U+M4siD2HmXvur4Me2W63vsiL1IJ5Wp166uKd3lndofnVv+HUt/j4zwO4UfZSyoA5VhkEa7xNCByVJ/rXlLe0YJV80AU3bA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pTyBwWCd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pTyBwWCd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A554C2F;
	Wed, 30 Sep 2026 08:55:39 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADFAF3F86F;
	Wed, 30 Sep 2026 08:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790783743; bh=Bc5mWey1FMzal2RQfaDFWEDiyRbRNQu+XKVSnU+udT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pTyBwWCdjrYPTJJSYO92B4a1mS3MpLniYzgmdympuLvTm1K6xYAkgDEYfr1yvjVgt
	 q/y+ffzRccdbw11Z4sxKlJWU2Z8rQwyBLJiTwd+lucIgdcuxmmZI6Y/vMdyE6KYcHB
	 0dgbg4WFuEyRcOmFkUu0RPcCwQ1GUN6EPm+GPTis=
Message-ID: <210c0b27-c7cb-447a-b6ee-bf6b3fb63acc@arm.com>
Date: Wed, 30 Sep 2026 16:55:38 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 6/9] firmware: arm_rmm: Ensure the RMM has GPT entries
 for memory
Content-Language: en-GB
To: Sudeep Holla <sudeep.holla@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 jonathan.cameron@oss.qualcomm.com
References: <20260929221623.1342076-1-suzuki.poulose@arm.com>
 <20260929221623.1342076-7-suzuki.poulose@arm.com>
 <20260930-judicious-loris-of-will-dea0a3@sudeepholla>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260930-judicious-loris-of-will-dea0a3@sudeepholla>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sudeep

On 30/09/2026 15:44, Sudeep Holla wrote:
> On Tue, Sep 29, 2026 at 11:16:20PM +0100, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> The RMM maintains the state of all the granules in the system to make
>> sure that the host is abiding by the rules. This state can be maintained
>> at different granularity, per page (TRACKING_FINE) or per region
>> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on the
>> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
>> all pages in the region must be of the same state, this implies we need to
>> have "fine" tracking for DRAM, so that we can delegate individual pages.
>>
>> For now we only support a statically carved out memory for tracking
>> granules for the "fine" regions. This can be extended in the future to
>> allow modifying the tracking granularity and remove the need for a
>> static allocation by the firmware.
>>
>> Similarly, the firmware may create L0 GPT entries describing the total
>> address space. But if we change the "PAS" (Physical Address Space) of a
>> granule, then the firmware may need to create L1 tables to track the PAS
>> at a finer granularity. Linux therefore checks if the platform firmware
>> manages the PAR region. i.e., the firmware is in charge of managing the
>> L1 GPTs (creation and the required memory for the GPT tables - via static
>> carveouts) without host intervention. Support for dynamic GPT creation by
>> the host will be added later.
>>
>> If the firmware requires us to manage the tracking or GPT memory,
>> deactivate the RMM and reclaim any memory donated at RMM activation.
>>
>> Apply the same checks when hotplugged memory is brought online.
>>
...

>> ---
>>   drivers/firmware/arm_rmm/rmi.c | 247 ++++++++++++++++++++++++++++++++-
>>   include/linux/arm-rmi-cmds.h   |  18 +++
>>   2 files changed, 264 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index d982cf158f8da..d4d098448e46e 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> [...]
> 
>> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, phys_addr_t end)
>> +{
>> +	unsigned long l0gpt_sz;
>> +	unsigned long next, par_state;
>> +
>> +	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +					  rmi_feat_reg(1)));
>> +	start = ALIGN_DOWN(start, l0gpt_sz);
>> +	end = ALIGN(end, l0gpt_sz);
>> +
> 
> Is it guaranteed that end with not be = PASZ ? The spec says RMI_GPT_INFO
> will return RMI_GPT_INFO when top >= pasz. Unlike start, end for good
> reason is aligned up(ceil) instead of aligned down, but that also means
> end will become PASZ when we reach end of memory, no ?

Good point. The RMM spec needs to be fixed to make the condition

  top > pasz

as the top, is really the top the region and is not inclusive.

This is already a known issue, tracked by FENIMORE-1807. The proposed
fix is :

pre: UInt(top) > rmm.static.pasz


> 
> Sorry if I am missing something, trying to understand bits and piece of
> RME still, just getting started.

Thanks for looking !

Cheers
Suzuki

> 
>> +	while (start < end) {
>> +		long ret = rmi_gpt_info(start, end, &next, &par_state);
>> +
>> +		if (ret != RMI_SUCCESS) {
>> +			pr_err("RMI_GPT_INFO failed for %llx-%llx: (%ld)\n",
>> +				start, end, ret);
>> +			return -ENXIO;
>> +		}
>> +
>> +		if (WARN_ON(next <= start))
>> +			return -ENXIO;
>> +
>> +		if (par_state != RMI_GPT_PAR_PLAT) {
>> +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
>> +				start, next);
>> +			return -ENODEV;
>> +		}
>> +		start = next;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
> 

