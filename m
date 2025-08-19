Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB6D3451DC
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 04:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755577478; cv=none; b=Od8OU0VVhfjlBiOYjSJ5oK9rFKVFUOyDoSMDmpyBvdxsAll5rrNF7JwGcyHiB9Q4pCkktjHsK6948MtArP6hE4cnJKD7J7+wysi5n4wQOCA/+hn3uUCEk1ARyieQAF34s7nMBzDmRzocXlZvjncfmKFXUla69WKY1RdxA3pfonk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755577478; c=relaxed/simple;
	bh=yZWO+us9BsBsZLgRyLz1RZnETM4MXpixOqlu1zQX1Tk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2cjk/4ZLCZRs0MqC1xgZjDQ1RhICn6ri9gF7gDU/US5qhsKGIHSoaxDpqeTtrm40EDG9bJkjagPE4i6kMYbsbiZX297EItq3eJmABZlf2Jnh/0D2zdUot9jvK7ccX1z1vAImiaGcCtsjXwraPpErKR0JFREGUxt9P0fyLPK5kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65603152B;
	Mon, 18 Aug 2025 21:24:27 -0700 (PDT)
Received: from [10.164.146.16] (J09HK2D2RT.blr.arm.com [10.164.146.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DF223F63F;
	Mon, 18 Aug 2025 21:24:32 -0700 (PDT)
Message-ID: <bf78530c-e3e7-42b1-be7c-409d6427afda@arm.com>
Date: Tue, 19 Aug 2025 09:54:29 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] arm64/sysreg: Add VTCR_EL2 register
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
 <20250818045759.672408-5-anshuman.khandual@arm.com>
 <aKLw1jvwOo4wG64n@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aKLw1jvwOo4wG64n@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 18/08/25 2:52 PM, Mark Rutland wrote:
> On Mon, Aug 18, 2025 at 10:27:59AM +0530, Anshuman Khandual wrote:
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index d2b40105eb41..f5a0a304f844 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -4910,6 +4910,63 @@ Field	1	PIE
>>  Field	0	PnCH
>>  EndSysreg
>>  
>> +Sysreg	VTCR_EL2	3	4	2	1	2
>> +Res0	63:46
>> +Field	45	HDBSS
>> +Field	44	HAFT
>> +Res0	43:42
>> +Field	41	TL0
>> +Field	40	GCSH
>> +Res0	39
>> +Field	38	D128
>> +Field	37	S2POE
>> +Field	36	S2PIE
>> +Field	35	TL1
>> +Field	34	AssuredOnly
>> +Field	33	SL2
>> +Field	32	DS
>> +Res1	31
>> +Field	30	NSA
>> +Field	29	NSW
>> +Field	28	HWU62
>> +Field	27	HWU61
>> +Field	26	HWU60
>> +Field	25	HWU59
>> +Res0	24:23
>> +Field	22	HD
>> +Field	21	HA
>> +Res0	20
>> +UnsignedEnum	19	VS
>> +	0b0	8BIT
>> +	0b1	16BIT
>> +EndEnum
> 
> You left TCR_EL1.AS as a single-bit 'Field', so please do the same here
> for consistency. I don't think there's much gained by making this any
> sort of enum.

But actually there is an use case in kvm_get_vtcr().

        /* Set the vmid bits */
        vtcr |= (get_vmid_bits(mmfr1) == 16) ?
                SYS_FIELD_PREP_ENUM(VTCR_EL2, VS, 16BIT) :
                SYS_FIELD_PREP_ENUM(VTCR_EL2, VS, 8BIT);

> 
>> +Field	18:16	PS
>> +UnsignedEnum	15:14	TG0
>> +		0b00	4K
>> +		0b01	64K
>> +		0b10	16K
>> +EndEnum
> 
> As with other patches, this is not ordered. Please use Enum.
> 
> Likewise for the other cases below.


Sure, will do the changes.
> 
> Mark.
> 
>> +UnsignedEnum	13:12	SH0
>> +		0b00	NONE
>> +		0b10	OUTER
>> +		0b11	INNER
>> +EndEnum
>> +UnsignedEnum	11:10	ORGN0
>> +	0b00	NC
>> +	0b01	WBWA
>> +	0b10	WT
>> +	0b11	WBnWA
>> +EndEnum
>> +UnsignedEnum	9:8	IRGN0
>> +	0b00	NC
>> +	0b01	WBWA
>> +	0b10	WT
>> +	0b11	WBnWA
>> +EndEnum
>> +Field	7:6	SL0
>> +Field	5:0	T0SZ
>> +EndSysreg
>> +
>>  SysregFields MAIR2_ELx
>>  Field	63:56	Attr7
>>  Field	55:48	Attr6
>> -- 
>> 2.25.1
>>
>>

