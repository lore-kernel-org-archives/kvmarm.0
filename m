Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59B438F80
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 03:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755575212; cv=none; b=bI7ZTCUwYel0ySQUcYVx9HFnh+YRcDDM2E6iubnRIcvCszB91opXuNWNZiK5zcEkVXkb92ZiOyB95lQPiXOAmp+rOU2HIhRmsgOhwEyOeK4IGqzVYaZw/3ZbyJj+uY8qR065+mXrL1HtZVIOT8QHS6mDPJIOeB3iXX/FbXfbjuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755575212; c=relaxed/simple;
	bh=CybrX/I+Sfq+4vxNl4rvUqohj08LbqK4g97JTJwIutE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ThnbCV7RzEfQjigGHRf4XGIGvy1NNhoV8Fd6myZnv9mehjNSCzhyMx98z0NSPQr0BN3KnBvWRPEMUBGmWT8VZrPD9/tJRQl7K5n1Q75aZdYTA8UvVPRy/VRdrpDscMyKYOrD2NViLtIOjng5AekAUtTEoRXklhX/d9S0fs4s+4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E2266152B;
	Mon, 18 Aug 2025 20:46:40 -0700 (PDT)
Received: from [10.164.146.16] (J09HK2D2RT.blr.arm.com [10.164.146.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC97F3F58B;
	Mon, 18 Aug 2025 20:46:45 -0700 (PDT)
Message-ID: <ce4528c1-2b78-47a3-95c7-e4e3248755e4@arm.com>
Date: Tue, 19 Aug 2025 09:16:42 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] arm64/sysreg: Add TCR_EL2 register
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
 <20250818045759.672408-4-anshuman.khandual@arm.com>
 <aKLvm2_bNtxcs8Dz@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aKLvm2_bNtxcs8Dz@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 18/08/25 2:47 PM, Mark Rutland wrote:
> On Mon, Aug 18, 2025 at 10:27:58AM +0530, Anshuman Khandual wrote:
>> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
>> index 4bdae8bb11dc..d2b40105eb41 100644
>> --- a/arch/arm64/tools/sysreg
>> +++ b/arch/arm64/tools/sysreg
>> @@ -4812,6 +4812,50 @@ Sysreg	TCR_EL12        3	5	2	0	2
>>  Mapping	TCR_EL1
>>  EndSysreg
>>  
>> +Sysreg	TCR_EL2        3	4	2	0	2
>> +Res0	63:34
>> +Field	33	MTX
>> +Field	32	DS
>> +Res1	31
>> +Field	30	TCMA
>> +Field	29	TBID
>> +Field	28	HWU62
>> +Field	27	HWU61
>> +Field	26	HWU60
>> +Field	25	HWU59
>> +Field	24	HPD
>> +Res1	23
>> +Field	22	HD
>> +Field	21	HA
>> +Field	20	TBI
>> +Res0	19
>> +Field   18:16	PS
>> +UnsignedEnum	15:14	TG0
>> +	0b00	4K
>> +	0b01	64K
>> +	0b10	16K
>> +EndEnum
> 
> Same comment as for patch 1: this is not ordered, use Enum rather than
> UnsignedEnum. Likewise for the other cases below.


Sure, will change.
> 
> Mark.
> 
>> +UnsignedEnum	13:12	SH0
>> +	0b00	NONE
>> +	0b10	OUTER
>> +	0b11	INNER
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
>> +Res0    7:6
>> +Field   5:0	T0SZ
>> +EndSysreg
>> +
>>  Sysreg	TCRALIAS_EL1    3	0	2	7	6
>>  Mapping	TCR_EL1
>>  EndSysreg
>> -- 
>> 2.25.1
>>
>>

