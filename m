Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792589754;
	b=NFAC7Y2YaRfeQDaeoEqnz9Q9+4LfDO9POC7lcKdGgK8FVv8LSgbGgbpIrjDHQLasWeAL
	 aTW5LX64cizxDm63t+ERqMW9WTDCAkaDb9Ru2uPTvVUiyuPsECMBeuHAf5t4vc+c4ibN7
	 3xxOU5UrkmqgAp4bJYuh3YGMf5I/rrl+LGdEeYxYRP70ZN7Ju+ay3tO/utcivoQahWUMc
	 w95OOVOAzKO3e5YasriJB0i7xCaGmntSdM1fn0p1IWYf4xUFvBsX7KA1BaEDjgwlHLNYP
	 hfXG7wnl+no4TVjbx1ReeXKbSdIQdLLi4nyqS7hYUcsmqEP+LgehjBKkvUrthFX5ivA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792589754;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=TWEer91pURJKpMqcGr1P37YbC2QaRDdu+H8+zHCyteo=;
	b=5sg4U3JLY0g2JC/ymkPHX9AG0X2ElpiHhu2OBChbJobwduOj2HlKWJKxwl7U4eumyqiX
	 LPCX0ZA+MK6kZQ+4dqj6cizCTIp847vmjXEkCNmlwU+V3YsczZAsXjDFaadkTNfWFStyZ
	 rQEnPYf8BwRBUWjJ49p/Mns8O9tNY2tin0aLV6u/WYp1x0l5lT2KCmb5Fxv8a2KNYg1LI
	 aybhNkqt+C+EyD6VpLIljHsa7aSlXQpezhWT4+oK6GCzm7urM+FZhFNPC5RF7TrdzISnM
	 iW/mQHWyEXh2kqbsHfVMjjHmV2vQcRuxHhErx2Na7AJRIiQKXJzmAKx3ADh3oTItPZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nYXLNQ+m;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B518606A31A;
	Wed, 21 Oct 2026 13:35:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B518606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=nYXLNQ+m
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E59A616F8;
	Wed, 21 Oct 2026 06:35:48 -0700 (PDT)
Received: from [10.0.129.145] (Suzukis-MBP.cambridge.arm.com [10.0.129.145])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15B443F7B4;
	Wed, 21 Oct 2026 06:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792589752; bh=K1+XouPflyX+8G49/HiO730D52/jF3umhs279EWrgBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nYXLNQ+m65v1I4y0obonQ9lqui4JgOt4+DqhX03+NXDRwPJhBR+5eXzu3HFypdarB
	 260uJDalXUV9HrTgNpR7ZPbYtjl9wbcutcQcYsbMycxZAFFN23wSwQesecaDaWSXY8
	 V9wUjjfnHaCB1HCL+OPrGx+2p/vshWxKbHaQoRJo=
Message-ID: <34bf0c98-35b1-4402-842f-a100245cb9a7@arm.com>
Date: Wed, 21 Oct 2026 14:35:47 +0100
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 06/10] firmware: arm_rmm: Ensure the RMM has GPT
 entries for memory
Content-Language: en-GB
To: Kohei Enju <enju.kohei@fujitsu.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com, Soby Mathew <Soby.Mathew@arm.com>
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-7-suzuki.poulose@arm.com>
 <atiyZ7_S7aBxowIQ@FCCLS0092175.localdomain>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <atiyZ7_S7aBxowIQ@FCCLS0092175.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi

On 21/10/2026 14:07, Kohei Enju wrote:
> Hi Suzuki,
> 
> I've tested this series and found a possible TF-RMM issue.
> Please  below.
> 
> On 10/02 07:15, Suzuki K Poulose wrote:
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
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
> [...]
>> +/*
>> + * We do not support creating L1 GPTs yet. So, make sure that all the regions
>> + * are managed by the firmware.
>> + */
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
> 
> When system RAM starts at a non-L0GPTSZ-aligned address, the alignment
> in rmi_verify_gpt_firmware_managed() may cause the queried L0GPT range
> to include a memory hole.

> 
> On out platform, the relevant memory layout is:
> 
>      800c0000000-800dc3fffff : memory hole
>      800dc400000-82fffffffff : System RAM
> 

Thanks for the report.

> Consequently, Linux queries the following L0GPT range:
> 
>      800c0000000-80100000000
> 
> The query fails with RMI_GPT_PAR_RESERVED:
> 
>      [    8.551855] GPT for the region is not managed by firmware 800c0000000-80100000000
> 
> and arm64_init_rmi() subsequently fails.
> 
> As I understand it, smc_gpt_info() in TF-RMM checks only the beginning
> of the aligned L0GPT range. Since that address is in the hole, the whole
> range is reported as RMI_GPT_PAR_RESERVED, even though it contains
> platform-managed System RAM.
> 
> I believe this should be addressed in TF-RMM. Do you have any thoughts
> on the expected RMI_GPT_INFO behavior in this case?

I believe the RMM should report a value that represents the situation
better. In this case, there is a hole, and some conventional memory
areas. For the conventional memory, the RMM has to manage the GPTs.
(This applies to the tf-RMM implementation of TRACKING Granule state
too. It only looks at the first granule and reports the type of memory.)

RMI_GPT_PAR_RESERVED is not accurate as the memory region is not
reserved, unless it is reserved for firmware (in which case the
memory description is wrong).

I would say RMI_GPT_PAR_PLAT  is accurate if the L1GPT exists, as the
  region covered by the L0GPT has some memory that are delegable.

Otherwise it must be reported as RMI_GPT_HOST_NOT_CREATED.

The information that a given memory region is not "memory" (i.e. hole)
is basically TRACKING_STATE returned as RMI_MEM_CATEGORY_NONE


> 
> As a side note, we tested this series and the v23 integration branch
> with a Linux-side workaround to avoid the problem above, and we have not
> observed any other major issues. Sorry for the delay in testing this
> series.

Thanks for the testing !

Suzuki
> 
> Thanks,
> Kohei
> 
>> +		}
>> +		start = next;
>> +	}
>> +
>> +	return 0;
>> +}

