Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296771D2B1B
	for <kvmarm@lists.linux.dev>; Mon, 28 Oct 2024 13:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730122702; cv=none; b=TGHIWTQRoUWzzbLkkJTjRQlJIxcJIs+8k9aHmyz7K7gkvYP4srZpgl/WB/zSQ1cGHAkipycdY3gLaCc3vTShN6SqEekUDm2gQNSxQSSzemkkjkFzpl6kwF7DjrcQBKAAFBfmeVq6qNFZtmfprxKmDeRBToE6GKPvUCfpjopuwRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730122702; c=relaxed/simple;
	bh=NJI+6p5QD3JzdQ8UoXWF2ZhgwxAKXIeZlWxKrHiuewo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H5lBAAdzRjEu+TsF2YKkxbMesgvaJZp+DR9yvRg6tcS1f0lLB6cARbGqE9QvXXgvj+NGrMWkeHDiDsTP2hv+BCKwvYE8iN5D9M0+OF+6h8Vk3E0TzoG7VIfbZXa494jlbGn2SDxzE1tcjpIn0FXTC8xFSdrQPq2te55evxMwg00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF662497;
	Mon, 28 Oct 2024 06:38:48 -0700 (PDT)
Received: from [10.163.42.200] (unknown [10.163.42.200])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 976283F66E;
	Mon, 28 Oct 2024 06:38:15 -0700 (PDT)
Message-ID: <8efe902c-8b9f-494a-b9da-430d8ced32ef@arm.com>
Date: Mon, 28 Oct 2024 19:08:11 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] arm64/cpufeature: Add field details for
 ID_AA64DFR1_EL1 register
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-2-anshuman.khandual@arm.com>
 <ZxfLEqlbGLnK15sf@J2N7QTR9R3> <2c51de68-fcca-4457-b8e9-b488d8030738@arm.com>
 <Zx-EqqkQL_FQMRuu@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Zx-EqqkQL_FQMRuu@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/24 18:03, Mark Rutland wrote:
> On Wed, Oct 23, 2024 at 11:18:12AM +0530, Anshuman Khandual wrote:
>>
>>
>> On 10/22/24 21:26, Mark Rutland wrote:
>>> On Tue, Oct 01, 2024 at 10:06:00AM +0530, Anshuman Khandual wrote:
>>>> This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
>>>> ftr_raz[] array which is now redundant. These register fields will be used
>>>> to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
>>>> later.
> 
>>>> +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
>>>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
>>>> +	ARM64_FTR_END,
>>>> +};
>>>> +
>>>
>>> Is there some general principle that has been applied here? e.g. is this
>>> STRICT unless we know of variation in practice?
>>
>> Yes, that's correct. STRICT unless there is a known variation in practice.
> 
> Please mention that somewhere, e.g. in the commit message.

Sure, will add that.

> 
>>> e.g. it seems a bit odd that ABLE cannot vary while the number of
>>> breakpoints can...
>> But all these (ABL_CMPs, CTX_CMPs, WRPs, BRPs) are marked as FTR_NONSTRICT.
>> Would not that allow ABL_CMPs to vary as well ?
> 
> I asked about ABLE, not ABL_CMPs.
> 
> ABL_CMPs is marked as FTR_NONSTRICT, but ABLE is marked as FTR_STRICT.

Ahh, that was my bad, completely missed.

> 
>> Although the existing break-point numbers are currently marked FTR_STRICT,
>> should they be changed first ?
>>
>> static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>> 	...................
>> 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_CTX_CMPs_SHIFT, 4, 0),
>>         ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_WRPs_SHIFT, 4, 0),
>>         ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR0_EL1_BRPs_SHIFT, 4, 0),
>> 	...................
>> }
> 
> My point was that the above didn't seem to be logically consistent; I
> think you didn't handle ABLE as you should have.

Agreed, will change ABLE as FTR_NONSTRICT instead.

But what about the ID_AA64DFR0_EL1_WRPs_SHIFT and ID_AA64DFR0_EL1_BRPs_SHIFT
which could have variations in different cpus on the same system ? So should
those be fixed as FTR_NONSTRICT first ?

I have posted V2 for this series earlier today, hence will accommodate all the
new comments here in V3 going forward.

https://lore.kernel.org/all/20241028053426.2486633-1-anshuman.khandual@arm.com/
