Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 346632EB859
	for <kvmarm@lists.linux.dev>; Thu, 30 Oct 2025 02:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761792086; cv=none; b=hDHdnG9TXrJtVjqgj6Bo7qZ0HA2GE81gnbIumpOt5lcGoXLCxmBaSfQtYuah0G3lR2zlbRPnIZT+FGiuB7dVQ/iRnNpbeC+v52paMgu6dk7aCPrYM+MExgkXjw608x+57ZIln21Wko6zHNT/4/3G5PH+GdofpIdWZRSt09bx79c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761792086; c=relaxed/simple;
	bh=35O68B3yYenhF/csDe9xTVqzRsbi7wfuR8H72IjF2fY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AmIEHiXNWccKqQR0hejhvCAj6KZhWXEXc323FtsAyCM45aWRXsSSxeCLVAsvlT4koPIWvyiShYk5npptkCbX5uzOrsYvJyCuEZwq6K2KGvweutDQm6oncRQ3Xbpjk6ss55ieF7pDsXyye4k8JqX0J982mcvbZx+w8LJrAOVkCaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D4DE12C42;
	Wed, 29 Oct 2025 19:41:13 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD7E33F66E;
	Wed, 29 Oct 2025 19:41:18 -0700 (PDT)
Message-ID: <434eebff-069d-424f-a2b8-d9dae4e2202f@arm.com>
Date: Thu, 30 Oct 2025 08:11:15 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] arm64/mm: Add remaining TLBI_XXX_MASK macros
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, ben.horgan@arm.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
References: <20251024040207.137480-1-anshuman.khandual@arm.com>
 <20251024040207.137480-3-anshuman.khandual@arm.com>
 <20251024120014.000020af@huawei.com>
 <6e7d0bf3-ddf1-44a0-a0cb-7dc994101878@arm.com>
 <20251028124334.00001e77@huawei.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251028124334.00001e77@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 28/10/25 6:13 PM, Jonathan Cameron wrote:
> On Mon, 27 Oct 2025 07:06:45 +0530
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> 
>> On 24/10/25 4:30 PM, Jonathan Cameron wrote:
>>> On Fri, 24 Oct 2025 05:02:07 +0100
>>> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>>   
>>>> Add remaining TLBI_XXX_MASK macros and replace current open encoded fields.
>>>> While here replace hard coded page size based shifts but with derived ones
>>>> via ilog2() thus adding some required context.
>>>>
>>>> TLBI_TTL_MASK has been split into separate TLBI_TTL_MASK and TLBI_TG_MASK
>>>> as appropriate because currently it simultaneously contains both page size
>>>> and translation table level information. KVM on arm64 has been updated to
>>>> accommodate these changes to TLBI_TTL_MASK.
>>>>
>>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Will Deacon <will@kernel.org>
>>>> Cc: Marc Zyngier <maz@kernel.org>
>>>> Cc: Oliver Upton <oliver.upton@linux.dev>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Cc: kvmarm@lists.linux.dev
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/tlbflush.h | 26 ++++++++++++++++++--------
>>>>  arch/arm64/kvm/nested.c           |  8 +++++---
>>>>  2 files changed, 23 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
>>>> index 131096094f5b..cf75fc2a06c3 100644
>>>> --- a/arch/arm64/include/asm/tlbflush.h
>>>> +++ b/arch/arm64/include/asm/tlbflush.h
>>>> @@ -57,9 +57,10 @@
>>>>  /* This macro creates a properly formatted VA operand for the TLBI */
>>>>  #define __TLBI_VADDR(addr, asid)				\
>>>>  	({							\
>>>> -		unsigned long __ta = (addr) >> 12;		\
>>>> -		__ta &= GENMASK_ULL(43, 0);			\
>>>> -		__ta |= (unsigned long)(asid) << 48;		\
>>>> +		unsigned long __ta = (addr) >> ilog2(SZ_4K);	\
>>>> +		__ta &= TLBI_BADDR_MASK;			\
>>>> +		__ta &= ~TLBI_ASID_MASK;			\
>>>> +		__ta |= FIELD_PREP(TLBI_ASID_MASK, asid);	\  
>>> I think you can replace the two lines above with
>>> 		FIELD_MODIFY(TLBI_ASID_MASK, &__ta, asid);
>>>
>>> It's a small reduction in code but I don't mind much either way.  
>>
>> Right. FIELD_MODIFY() might be appropriate in this scenario but
>> there will be some additional code churn needed. I don't have a
>> strong opinion either way.
>>
>> --- a/arch/arm64/include/asm/tlbflush.h
>> +++ b/arch/arm64/include/asm/tlbflush.h
>> @@ -55,13 +55,12 @@
>>  } while (0)
>>
>>  /* This macro creates a properly formatted VA operand for the TLBI */
>> -#define __TLBI_VADDR(addr, asid)                               \
>> -       ({                                                      \
>> -               unsigned long __ta = (addr) >> ilog2(SZ_4K);    \
>> -               __ta &= TLBI_BADDR_MASK;                        \
>> -               __ta &= ~TLBI_ASID_MASK;                        \
>> -               __ta |= FIELD_PREP(TLBI_ASID_MASK, asid);       \
>> -               __ta;                                           \
>> +#define __TLBI_VADDR(addr, asid)                                       \
>> +       ({                                                              \
>> +               unsigned long __ta = (addr) >> ilog2(SZ_4K);            \
>> +               __ta &= TLBI_BADDR_MASK;                                \
>> +               __ta |= FIELD_MODIFY(TLBI_ASID_MASK, &__ta, asid);      \
> 		  FIELD_MODIFY(TLBI_ASID_MASK, &__tab, asid);
> 
> as it's done in place in the second parameter.

Sorry but could not understand your point above.
