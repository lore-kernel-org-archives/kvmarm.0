Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B6F197A7F
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 11:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904113; cv=none; b=PkCgjxOs8QimulA9vePcNSv3zz13QIGyY66MY1y6ZWlFIz9hshK4XIjHnRW3D19JftyNIOAgX9qx5WhqjFA0ezviTC1l+oYZ+iQ6T3mFPuiEfVO1FMQDURyx6ONZxL15qol8gBzE7yvCq4rpM0f6QktRi89cB2h+fc1yTaJUv4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904113; c=relaxed/simple;
	bh=vtEgCTxGZDgLyHPqBJeeO57xsUmq3uC2TGRhYpM97sM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uGI/L1xKIaOVCAiXUiqZXNVu2qTE1vINO9ALF8k9Glvx5JZGIEwb9CiQG7n0gZYXSZ2grZfdEjh87e3tMq87w+emWtRz8xZ7KZ4xfNVjxbOlM/jXoGfEpKMsEOLpMhn/ZAnKCSrFgJ5ZUIzXgdXwP+V4tiVPy1sYCdIfR+XNcQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 551401688;
	Mon, 14 Oct 2024 04:09:01 -0700 (PDT)
Received: from [10.57.86.130] (unknown [10.57.86.130])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EAB983F51B;
	Mon, 14 Oct 2024 04:08:29 -0700 (PDT)
Message-ID: <e8f8f9e8-b042-4df8-92ea-1439a5e1ffb4@arm.com>
Date: Mon, 14 Oct 2024 12:08:28 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] arm64/mm: Drop pte_mkhuge()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
 <20241005123824.1366397-2-anshuman.khandual@arm.com>
 <a4372d54-34bb-4a32-8742-ea6aacc0848c@arm.com>
 <a91df2f6-e0d6-4902-ae22-5df132f00737@arm.com>
Content-Language: en-GB
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <a91df2f6-e0d6-4902-ae22-5df132f00737@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/10/2024 09:59, Anshuman Khandual wrote:
> 
> 
> On 10/9/24 18:50, Ryan Roberts wrote:
>> On 05/10/2024 13:38, Anshuman Khandual wrote:
>>> Core HugeTLB defines arch_make_huge_pte() fallback definition, which calls
>>> platform provided pte_mkhuge(). But if any platform already provides custom
>>> arch_make_huge_pte(), then it does not need to provide pte_mkhuge(). arm64
>>> defines arch_make_huge_pte(), but then also calls pte_mkhuge() internally.
>>> This creates confusion as if both of these callbacks are being used in core
>>> HugeTLB and required to be defined in the platform.
>>>
>>> This changes arch_make_huge_pte() to create block mapping directly and also
>>> drops off now redundant helper pte_mkhuge(), making things clear. Also this
>>> changes HugeTLB page creation from just clearing the PTE_TABLE_BIT (bit[1])
>>> to actually setting bits[1:0] via PTE_TYPE_[MASK|SECT] instead.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Ard Biesheuvel <ardb@kernel.org>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>>  arch/arm64/include/asm/pgtable-hwdef.h | 1 +
>>>  arch/arm64/include/asm/pgtable.h       | 5 -----
>>>  arch/arm64/mm/hugetlbpage.c            | 2 +-
>>>  3 files changed, 2 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
>>> index fd330c1db289..956a702cb532 100644
>>> --- a/arch/arm64/include/asm/pgtable-hwdef.h
>>> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
>>> @@ -158,6 +158,7 @@
>>>  #define PTE_VALID		(_AT(pteval_t, 1) << 0)
>>>  #define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
>>>  #define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
>>> +#define PTE_TYPE_SECT		(_AT(pteval_t, 1) << 0)
>>>  #define PTE_TABLE_BIT		(_AT(pteval_t, 1) << 1)
>>>  #define PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
>>>  #define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* AP[2] */
>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>> index c329ea061dc9..fa4c32a9f572 100644
>>> --- a/arch/arm64/include/asm/pgtable.h
>>> +++ b/arch/arm64/include/asm/pgtable.h
>>> @@ -438,11 +438,6 @@ static inline void __set_ptes(struct mm_struct *mm,
>>>  	}
>>>  }
>>>  
>>> -/*
>>> - * Huge pte definitions.
>>> - */
>>> -#define pte_mkhuge(pte)		(__pte(pte_val(pte) & ~PTE_TABLE_BIT))
>>> -
>>>  /*
>>>   * Hugetlb definitions.
>>>   */
>>> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
>>> index 5f1e2103888b..5922c95630ad 100644
>>> --- a/arch/arm64/mm/hugetlbpage.c
>>> +++ b/arch/arm64/mm/hugetlbpage.c
>>> @@ -361,7 +361,7 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
>>>  {
>>>  	size_t pagesize = 1UL << shift;
>>>  
>>> -	entry = pte_mkhuge(entry);
>>> +	entry = __pte((pte_val(entry) & ~PTE_TYPE_MASK) | PTE_TYPE_SECT);
>>
>> I think there may be an existing bug here; if pagesize == CONT_PTE_SIZE, then
>> entry will be placed in the level 3 table. In this case, shouldn't bit 1 remain
>> set, because at level 3, a page mapping is denoted by bits[1:0] = 3 ? Currently
>> its being unconditionally cleared.
> 
> That's not a problem, pte_mkcont() brings back both the bits
> via PTE_TYPE_PAGE along with PTE_CONT.
> 
>         if (pagesize == CONT_PTE_SIZE) {
>                 entry = pte_mkcont(entry);
>         } else if (pagesize == CONT_PMD_SIZE) {
>                 entry = pmd_pte(pmd_mkcont(pte_pmd(entry)));
>         } else if (pagesize != PUD_SIZE && pagesize != PMD_SIZE) {
>                 pr_warn("%s: unrecognized huge page size 0x%lx\n",
>                         __func__, pagesize);
>         }
> 
> static inline pte_t pte_mkcont(pte_t pte)
> {
> 	pte = set_pte_bit(pte, __pgprot(PTE_CONT));
>       	return set_pte_bit(pte, __pgprot(PTE_TYPE_PAGE));

Oh wow, that's pretty hacky. Good job we never call pte_mkcont() on a
PTE_PRESENT_INVALID PTE. This would turn it valid again.

> }
> 
> Although the same is not required for CONT_PMD_SIZE size huge
> pages where only PTE_CONT is enough.
> 
> static inline pmd_t pmd_mkcont(pmd_t pmd)
> {
>         return __pmd(pmd_val(pmd) | PMD_SECT_CONT);
> }
>  
>>>  	if (pagesize == CONT_PTE_SIZE) {
>>>  		entry = pte_mkcont(entry);
>>>  	} else if (pagesize == CONT_PMD_SIZE) {
>>

