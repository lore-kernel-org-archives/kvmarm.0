Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB912BE7DD;
	Mon, 20 Jul 2026 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784559796; cv=none; b=S44T53AFlW3KcX16vrZ/2qHjTYpfbeKD1v4koAwkYxqFniIyb7bewfyFdhOdI2xXPshPSMxDLO6/poYVbBawurkYxvnrg97eU75kfy/vwoBPfmLZyyZjUUlINbTbPNIvi1U2KPA0sukdbqZt41hpGxUnPW/ok6Z6GrL8U6JikWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784559796; c=relaxed/simple;
	bh=ecPphwYcfS/q9xG0DGZNMPggdMTPszdtVDUdQSiFCsU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=emyeqrk7G0QzFg+HLwj8L9CzR9zBLanmLuNAaZG0qVprPlL+WanolhtbQAwaICgGAcO5hSFzpOgZeQW3CQ4fpPc8kXEuw/+a5mpvOY8VfEjhgXpZwuMQGmjtgHVc4Y0zA1ReCcGX7ay9EKMaojlq4BkdH4m3LpP7bfVv/LP4NdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tcLaYrQh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tcLaYrQh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 774EE143D;
	Mon, 20 Jul 2026 08:03:09 -0700 (PDT)
Received: from [10.57.85.41] (unknown [10.57.85.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 003F03F86F;
	Mon, 20 Jul 2026 08:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784559793; bh=ecPphwYcfS/q9xG0DGZNMPggdMTPszdtVDUdQSiFCsU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tcLaYrQhKvN8Yc/TQ2ahVcIOzL1KArRBZfJQehK+OVeZMItiQh446Wp9ivSDlV7lQ
	 aWjQlWvehMhUZHFZpvyWSII1cF4YDqhTuyZjoco4g1p8g0tQeia3g5T0mv2ldop1/i
	 EjGNH1BFJmFrCg9cCDzgOQuO8ENAWIShOtG8MgRY=
Message-ID: <f63c0275-1c26-49dd-a046-459728de6a39@arm.com>
Date: Mon, 20 Jul 2026 16:03:11 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] firmware: arm_rmm: Ensure the RMM has GPT entries for
 memory
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>
References: <20260715142739.80398-1-steven.price@arm.com>
 <20260715142739.80398-7-steven.price@arm.com>
 <20260715154738.5339F1F000E9@smtp.kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260715154738.5339F1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2026 16:47, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issue(s) to consider:
> - [Medium] Host-side memory allocation failures are incorrectly parsed as RMI firmware errors.
> - [Low] Empty or sub-page memblock regions are expanded into 1GB GPT allocations.
> - [Low] Missing trailing newline in success message.
> --
> 
> --- Patch [6]: [PATCH 6/6] firmware: arm_rmm: Ensure the RMM has GPT entries for memory ---
> commit dfe33cca468028175b080bbcfc671eba1604716c
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Ensure the RMM has GPT entries for memory
>     
> This commit configures RMM memory tracking to ensure DRAM regions are 
> tracked at FINE granularity. It statically allocates tracking granules and 
> creates Level 1 GPT tables for these regions when needed.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index 6a9f61760fd77..d0c083bdf251f 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> 
> [ ... ]
> 
>> @@ -604,6 +606,89 @@ static int rmi_configure(void)
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Make sure the area is tracked by RMM at FINE granularity.
>> + * We do not support changing the tracking yet.
>> + */
> 
> [ ... ]
> 
>> +static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
>> +{
>> +	struct rmi_sro_state *sro;
>> +	unsigned long l0gpt_sz;
>> +
>> +	sro = kmalloc_obj(*sro, GFP_KERNEL);
>> +	if (!sro)
>> +		return -ENOMEM;
>> +
>> +	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
>> +					  rmi_feat_reg(1)));
>> +	start = ALIGN_DOWN(start, l0gpt_sz);
>> +	end = ALIGN(end, l0gpt_sz);
> 
> [Severity: Low]
> If a memblock region is smaller than a page or misaligned, is it possible
> for the initial start physical address to be greater than or equal to end?

I don't understand how start >= end would work. That seems like a very
broken memblock.

> If so, applying ALIGN_DOWN() to start and ALIGN() to end could force 
> start < end to evaluate to true for an originally empty region. Could this
> cause the loop to inadvertently execute and allocate an L1 GPT table for a
> 1GB block that contains no full pages?

A misaligned/small memblock would be very weird. But we'd still want a
L1 GPT table to cover it.

>> +
>> +	while (start < end) {
>> +		int ret = rmi_gpt_l1_create(start, sro, GFP_KERNEL);
>> +
>> +		/*
>> +		 * Make sure the L1 GPT tables are created for the region.
>> +		 * RMI_ERROR_GPT indicates the L1 table already exists.
>> +		 */
>> +		if (ret != RMI_SUCCESS && RMI_RETURN_STATUS(ret) != RMI_ERROR_GPT) {
> 
> [Severity: Medium]
> Since rmi_gpt_l1_create() can return a standard negative POSIX error code
> like -ENOMEM from a host page allocation failure, does passing it to
> RMI_RETURN_STATUS(ret) misinterpret the error?

Note that rmi_gpt_l1_create() only returns "a standard negative POSIX
error code" in the WARN_ON path. In the more usual case of out-of-memory
then the operation is cancelled and the results of the cancelled
operation is returned.

> For -ENOMEM (-12), the macro extracts the lower bits (244), which won't
> match RMI_ERROR_GPT. Could this result in printing a misleading "GPT Level1
> table missing" error when the real issue is an out-of-memory condition in
> the host kernel?

Yes, although this is only after the WARN. I'm not sure it's really
worth fixing the error message for this corner case.

>> +			pr_err("GPT Level1 table missing for %llx\n", start);
>> +			kfree(sro);
>> +			return -ENOMEM;
>> +		}
>> +		start += l0gpt_sz;
>> +	}
>> +
>> +	kfree(sro);
>> +	return 0;
>> +}
> 
> [ ... ]
> 
>> @@ -621,6 +706,13 @@ static int __init arm64_init_rmi(void)
>>  	if (ret)
>>  		return ret;
>>  
>> +	ret = rmi_init_metadata();
>> +	if (ret)
>> +		return ret;
>> +
>> +	arm64_rmi_is_available = true;
>> +	pr_info("RMI configured");
> 
> [Severity: Low]
> This isn't a bug, but should this include a trailing newline ("\n") to 
> prevent subsequent kernel logs from being appended to the same line?

This is actually a bug - yes that newline is missing.

>> +
>>  	return 0;
>>  }
>>
> 

