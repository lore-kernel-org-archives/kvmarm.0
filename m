Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E43C36B907;
	Wed, 30 Sep 2026 08:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790756231; cv=none; b=DzObGLpvUJyhiH/g5pFS0Ppj8CcVCmAzIwURPJWySVN4eC5q6xar2nlKxcpcAftdF2WpsbRxmw+1Psez91dTUKAzqQBbbpRe6M6Ghot5EmVnu+MdJKJ6rcLpUUMPi2pu56Crr8WPuxCqk98l1+Us8cPdU5Y0Yebbl3QIeXr++o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790756231; c=relaxed/simple;
	bh=GNXZa7j1/VTmq7tnRy/t6ruvY0i6WuGqOi1nPlTRzL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eGWBAfqNY18OE5pB51vdAxCHozarbQgqGd4AVI5/Ftdtozrp2hCwvCMAijxOnQqBJg9fxXNieLw+cAv5cnc/7gjcc/tFDOEheADnV0teprgCfChXlPyg71iTCS5zEUX5Xtl5LeR1/usCXkgNmjuv8VFm6Zv9MDOMZnMFtv8ng4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BKFn+Xi7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BKFn+Xi7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AFC61477;
	Wed, 30 Sep 2026 01:17:01 -0700 (PDT)
Received: from [192.168.1.148] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CAA463F85F;
	Wed, 30 Sep 2026 01:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790756224; bh=GNXZa7j1/VTmq7tnRy/t6ruvY0i6WuGqOi1nPlTRzL8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BKFn+Xi71PDm13PN8c8mgumEtRVu6FdNVGMRI1NxBTY3+SXllrtsQ3wOiOa9C9yGH
	 50qcRfxA51AqF4pH++UxpnBh8vGYwXCVwWTAkE001/+beCOgzfLMxE2tz0ga5977lw
	 wFuOCDVKLSU2T89a1BcDCSroJtJc5QdZ9Gr6OJe0=
Message-ID: <af49e948-3120-401f-a00d-74c853ee17b9@arm.com>
Date: Wed, 30 Sep 2026 09:17:00 +0100
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
To: Shanker Donthineni <sdonthineni@nvidia.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 gshan@redhat.com, joey.gouly@arm.com, tabba@google.com,
 yuzenghui@huawei.com, linux-coco@lists.linux.dev,
 gankulkarni@os.amperecomputing.com, alpergun@google.com,
 fj0570is@fujitsu.com, WeiLin.Chang@arm.com, lpieralisi@kernel.org,
 enju.kohei@fujitsu.com, sudeep.holla@arm.com,
 jonathan.cameron@oss.qualcomm.com
References: <20260924135201.850038-1-suzuki.poulose@arm.com>
 <20260924135201.850038-7-suzuki.poulose@arm.com>
 <a27970c6-a7d2-4abc-84c3-7e50225f0a1a@nvidia.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <a27970c6-a7d2-4abc-84c3-7e50225f0a1a@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 29/09/2026 23:29, Shanker Donthineni wrote:
> Hi Suzuki,
> 
> On 9/24/2026 8:52 AM, Suzuki K Poulose wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> From: Steven Price <steven.price@arm.com>
>>
>> The RMM maintains the state of all the granules in the system to make
>> sure that the host is abiding by the rules. This state can be maintained
>> at different granularity, per page (TRACKING_FINE) or per region
>> (TRACKING_COARSE or TRACKING_INTERMEDIATE). The region size depends on 
>> the
>> underlying "RMI_GRANULE_SIZE". For a "coarse"/"intermediate" region,
>> all pages in the region must be of the same state, this implies we 
>> need to
>> have "fine" tracking for DRAM, so that we can delegate individual pages.
>>
>> For now we only support a statically carved out memory for tracking
>> granules for the "fine" regions. This can be extended in the future to
>> allow modifying the tracking granularity and remove the need for a
>> static allocation by the firmware.

...

>> +
>> +/*
>> + * We do not support creating L1 GPTs yet. So, make sure that
>> + * all the regions are managed by the firmware.
>> + */
>> +static int rmi_verify_gpt_firmware_managed(phys_addr_t start, 
>> phys_addr_t end)
>> +{
>> +       unsigned long l0gpt_sz;
>> +       unsigned long next, par_state;
>> +
>> +       l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +                                         rmi_feat_reg(1)));
>> +       start = ALIGN_DOWN(start, l0gpt_sz);
>> +       end = ALIGN(end, l0gpt_sz);
>> +
>> +       while (start < end) {
>> +               long ret = rmi_gpt_info(start, end, &next, &par_state);
>> +
>> +               if (ret != RMI_SUCCESS)
>> +                       return -ENOMEM;
>> +
>> +               if (WARN_ON(next <= start))
>> +                       return -ENXIO;
>> +
>> +               if (par_state != RMI_GPT_PAR_PLAT) {
>> +                       pr_err("GPT for the region is not managed by 
>> firmware %llx-%lx\n",
>> +                               start, next);
>> +                       return -ENOMEM;
> 
> Accepting only RMI_GPT_PAR_PLAT rules out the host ever creating its own
> L1 GPTs. On NVIDIA platforms the PARs backing system RAM come up as
> RMI_GPT_PAR_HOST_NOT_CREATED, so this returns -ENOMEM and CCA cannot be
> enabled at all.

Like I mentioned in the previous response, this is staged upstreaming.
The dynamic GPT/Tracking will follow after. This also calls for 
on-demand activation which Catalin requested and can be combined together,
as we dedicate quite a lot of memory for the metadata and L1GPTs.


> 
> With local changes to promote granule tracking via RMI_GRANULE_TRACKING_SET
> and to create the host L1 GPTs, I was able to boot a Realm with multiple
> vCPUs and exercise basic boot functionality on NVIDIA silicon.

Thanks for the testing !

Cheers
Suzuki
