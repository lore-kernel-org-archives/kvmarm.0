Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9070F38838B;
	Sun, 13 Sep 2026 06:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789282762; cv=none; b=RpWpkvPwShqrqvJZjXBf+48WNzFIB9qZy3fJDiBoMtBWkFkIWt4IYY3hb+urWrOU6E360TcRIJ16cO33COqFFqg9QPKabgrnhs+y+wXz3/H10aEHFo7MVks68yk3pE31f6pFXJuueXlsEelEZqcXP8RYSroAS/YWcT7WGL9BLWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789282762; c=relaxed/simple;
	bh=Fuon6Idcei3znjbJ88tnc5G1XsT4AP69/fZ4x8B2uNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DP/0itJzI0yl3qmSqbeZawIRpwwMkiPhR/Kx5DXM3DLqZ2+wpPni0Xw+7DXPTmtGULbfXwkNVkh5yrAC7v0O6k/x+bX1n0MgSEOUPwB5draeJIY9OHhlyZMUIceItFlL953BzgPmY0BEGvKt4y8uDoA/8epMqTme+ecuy2+Ji+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KOEqQ7Zz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KOEqQ7Zz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E81181655;
	Sat, 12 Sep 2026 23:59:13 -0700 (PDT)
Received: from [10.57.10.40] (unknown [10.57.10.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BBAFF3F7B4;
	Sat, 12 Sep 2026 23:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789282757; bh=Fuon6Idcei3znjbJ88tnc5G1XsT4AP69/fZ4x8B2uNI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KOEqQ7ZzGoFPgP3+TJuDR02kGn0giJXAOpoH5bmsRjW8sDn1g1ObQuixSyAzRgftm
	 5gr2iDyhbqp0RJHcTYZ+/UgAPz8QvAgarWxlje1nZ7wMVZ9t1vyIbEfn4BFlKFCnRJ
	 ctZn4Llopczd9J7/J6MetbIDRSBlsXVe69uuXDmo=
Message-ID: <c3b9b251-8e9d-4fba-ac4c-dddc94b94787@arm.com>
Date: Sun, 13 Sep 2026 07:59:06 +0100
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
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-7-suzuki.poulose@arm.com>
 <20260912084654.655CF1F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260912084654.655CF1F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/09/2026 09:46, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Missing forward-progress check on firmware-provided boundaries (`next`) can cause an infinite loop during boot or memory hotplug.
> - [High] Sub-page or inverted memblock regions are incorrectly expanded to 1GB blocks, resulting in out-of-bounds firmware queries that can falsely fail RMI initialization.
> --
> 
> commit 9d5a0191d0b2d820e7529339f354ee6f7cd2d469
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Ensure the RMM has GPT entries for memory
> 
> This patch adds checks during initialization and hotplug to ensure that the
> firmware correctly tracks memory at fine granularity and manages L1 GPTs. If
> the firmware expects the host to manage tracking or GPT memory, the RMM is
> deactivated.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index ecc89e91d264d..583e1aca9b15a 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> [ ... ]
> 
>> +static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
>> +{
>> +	while (start < end) {
>> +		unsigned long ret, category, state, next;
>> +
>> +		ret = rmi_granule_tracking_get(start, end, &category, &state, &next);
>> +		if (ret != RMI_SUCCESS)
>> +			return -ENOMEM;
>> +
>> +		if (state != RMI_TRACKING_FINE ||
>> +		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
>> +			/* TODO: Set granule tracking in this case */
>> +			pr_err("Granule tracking for region isn't fine/conventional: %llx-%lx\n",
>> +			       start, next);
>> +			return -ENODEV;
>> +		}
>> +		start = next;
>                  ^^^^^^^^^^^^
> 
> [Severity: High]
> Are we missing a forward-progress check here?
> 
> If a buggy or malicious firmware returns a next boundary where next <= start,
> this loop will never terminate, resulting in a permanent kernel hang during
> boot or memory hotplug.
> 
> The pre-existing rmi_undelegate_range() handles this exact scenario with:
> 
>      if (WARN_ON(out_top <= phys))
>          return -ENXIO;
> 
> Could we add a similar validation check here to verify next > start?

Ack, I added the check before we check the granularity.

> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/*
>> + * We do not support creating L1 GPTs yet. So, make sure that
>> + * all the regions are managed by the firmware.
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
>          ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [Severity: High]
> Does this alignment expansion cause issues if the incoming range is inverted?
> 
> As noted below in rmi_init_metadata(), if an inverted range (where
> start > end) is passed in, this alignment expands it into a massive block.
> 
> For example, if start=0x2000 and end=0x1000, and l0gpt_sz is 1GB, this expands
> to start=0 and end=1GB. The start < end loop condition then evaluates to true,
> and we end up querying the firmware for a 1GB block that might not be managed
> by firmware, falsely failing initialization.
> 
>> +
>> +	while (start < end) {
>> +		long ret = rmi_gpt_info(start, end, &next, &par_state);
>> +
>> +		if (ret != RMI_SUCCESS)
>> +			return -ENOMEM;
>> +
>> +		if (par_state != RMI_GPT_PAR_PLAT) {
>> +			pr_err("GPT for the region is not managed by firmware %llx-%lx\n",
>> +				start, next);
>> +			return -ENOMEM;
>> +		}
>> +		start = next;
>                  ^^^^^^^^^^^^
> 
> [Severity: High]
> Similar to rmi_verify_memory_tracking(), is a forward-progress check
> needed here to prevent an infinite loop if the firmware returns a boundary
> where next <= start?


Ack, added check before we check the par_state

> 
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int rmi_prepare_memory(phys_addr_t start, phys_addr_t end)
>> +{
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [Severity: High]
> Should there be an if (start >= end) return 0; check here?
> 
> This would protect downstream logic and prevent empty or inverted regions from
> reaching the alignment expansion in rmi_verify_gpt_firmware_managed().
> 

I have added the check here.

>> +	int ret;
>> +
>> +	ret = rmi_verify_memory_tracking(start, end);
>> +	if (ret)
>> +		return ret;
>> +
>> +	return rmi_verify_gpt_firmware_managed(start, end);
>> +}
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
>> +		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
>> +		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [Severity: High]
> Does this calculate an inverted range (start > end) for unaligned memblock
> regions smaller than a page?
> 
> memblock_region_memory_base_pfn() rounds up, while
> memblock_region_memory_end_pfn() rounds down. For small, unaligned memory
> regions, this yields start > end.

Though this looks extremely rare, not practical (i.e., a memblock not 
aligned a PAGE_SIZE and size less than < 2 * PAGE_SIZE), lets fix it.

I have switched to using the values directly. regs->base, regs->base+size.

Suzuki


> 
> This inverted range then flows into rmi_prepare_memory() and gets
> incorrectly expanded to a full 1GB block in
> rmi_verify_gpt_firmware_managed(), leading to a fatal initialization failure.
> 
>> +
>> +		ret = rmi_prepare_memory(start, end);
>> +		if (ret)
>> +			return ret;
>> +	}
> 

