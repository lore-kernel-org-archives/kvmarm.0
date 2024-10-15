Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E243D46B8
	for <kvmarm@lists.linux.dev>; Tue, 15 Oct 2024 03:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728964228; cv=none; b=PtbiIf387FshO1wrm48fVj42u2BQU9by4aWdlY16KnomBB5hgfLNu2gVSLnWQllelaCMf86/XIs5VcG0R0TAIBs5tX6puKOaCoLfORPUKS81UIFnzWN+u92cuhcZ4gCtw3/9kbv9daYVgCiWJheCFhJZaq6mRMQ9OMWbfiyoGDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728964228; c=relaxed/simple;
	bh=IFq29kHKXchdrmcm1ZIHSlghjV7EwcpUl348m0hF+v8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZfJaYtCYHqMXCqbtXZYcuwPhYsjkccJNRRJkftwMDw67n1FLWNRYcGV8gRQbHkdR50T3bj2euS0DkJZz3zkgDJW/PtVZhXsATFEZGGE4MZESN4b1QU5uiTaWYT0JrdBUXgGPvOcOaD7tslPVEaFjbGO39bci/riWrbSk3JVfEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 749D51007;
	Mon, 14 Oct 2024 20:50:47 -0700 (PDT)
Received: from [10.162.16.109] (a077893.blr.arm.com [10.162.16.109])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC2D13F71E;
	Mon, 14 Oct 2024 20:50:14 -0700 (PDT)
Message-ID: <ee960f42-d41c-4c61-b3a1-74ddb3a41001@arm.com>
Date: Tue, 15 Oct 2024 09:20:12 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] arm64/mm: Replace PXD_TABLE_BIT with
 PXD_TYPE_[MASK|SECT]
To: Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
 <20241005123824.1366397-3-anshuman.khandual@arm.com>
 <bb1dcfcf-302a-4932-a0d5-3abf5ed958c5@arm.com>
 <61203419-014e-4815-823c-62079aea93c9@arm.com>
 <38469540-2759-4a65-8e7f-e2b309d58614@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <38469540-2759-4a65-8e7f-e2b309d58614@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/14/24 17:03, Ryan Roberts wrote:
> On 14/10/2024 11:48, Anshuman Khandual wrote:
>>
>>
>> On 10/9/24 18:58, Ryan Roberts wrote:
>>> On 05/10/2024 13:38, Anshuman Khandual wrote:
>>>> This modifies existing block mapping related helpers e.g [pmd|pud]_mkhuge()
>>>> , mk_[pmd|pud]_sect_prot() and pmd_trans_huge() to use PXD_TYPE_[MASK|SECT]
>>>> instead of corresponding PXD_TABLE_BIT. This also moves pmd_sect() earlier
>>>> for the symbol's availability preventing a build warning.
>>>>
>>>> While here this also drops pmd_val() check from pmd_trans_huge() helper, as
>>>> pmd_present() returning true already ensures that pmd_val() cannot be false
>>>>
>>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>>> Cc: Will Deacon <will@kernel.org>
>>>> Cc: Ard Biesheuvel <ardb@kernel.org>
>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/pgtable.h | 15 ++++++++-------
>>>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>>>> index fa4c32a9f572..45c49c5ace80 100644
>>>> --- a/arch/arm64/include/asm/pgtable.h
>>>> +++ b/arch/arm64/include/asm/pgtable.h
>>>> @@ -484,12 +484,12 @@ static inline pmd_t pte_pmd(pte_t pte)
>>>>  
>>>>  static inline pgprot_t mk_pud_sect_prot(pgprot_t prot)
>>>>  {
>>>> -	return __pgprot((pgprot_val(prot) & ~PUD_TABLE_BIT) | PUD_TYPE_SECT);
>>>> +	return __pgprot((pgprot_val(prot) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT);
>>>>  }
>>>>  
>>>>  static inline pgprot_t mk_pmd_sect_prot(pgprot_t prot)
>>>>  {
>>>> -	return __pgprot((pgprot_val(prot) & ~PMD_TABLE_BIT) | PMD_TYPE_SECT);
>>>> +	return __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
>>>>  }
>>>>  
>>>>  static inline pte_t pte_swp_mkexclusive(pte_t pte)
>>>> @@ -554,10 +554,13 @@ static inline int pmd_protnone(pmd_t pmd)
>>>>   * THP definitions.
>>>>   */
>>>>  
>>>> +#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
>>>> +				 PMD_TYPE_SECT)
>>>> +
>>>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>  static inline int pmd_trans_huge(pmd_t pmd)
>>>>  {
>>>> -	return pmd_val(pmd) && pmd_present(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
>>>> +	return pmd_present(pmd) && pmd_sect(pmd);
>>>
>>> Bug? Prevously we would have returned true for a "present-invalid" PMD block
>>> mapping - that's one which is formatted as a PMD block mapping except the
>>> PTE_VALID bit is clear and PTE_PRESENT_INVALID is set. But now, due to
>>> pmd_sect() testing VALID is set (via PMD_TYPE_SECT), we no longer return true in
>>> this case.
>>
>> Agreed, that will be problematic but the situation can be rectified by decoupling
>> pmd_present_invalid() from pte_present_invalid() by checking for both last bits
>> instead of just the valid bit against PTE_PRESENT_INVALID.
>>
>> #define pmd_sect(pmd)          ((pmd_val(pmd) & PMD_TYPE_MASK) == \
>>                                 PMD_TYPE_SECT)
> 
> I know this is pre-existing, but the fact that this depends on PMD_VALID being
> set feels like something waiting to bite us. From the SW's PoV, we should get
> the same answer regardless of whether PMD_VALID xor PTE_PRESENT_INVALID is set.

I guess you are talking about pmd_sect() above, right ? pmd_sect() is just a HW
level check about the entry being a block mapping, which is not aware about the
PTE_PRESENT_INVALID based mechanism used for pmd_present().

> I know there is nobody depending on that right now, but it feels like a bug
> waiting to happen. I'm not sure how you would fix that without having the SW
> explcitly know about the table bit's existance though.
> 
>>
>> #define pmd_present_invalid(pmd) \
>>        ((pmd_val(pmd) & (PMD_TYPE_MASK | PTE_PRESENT_INVALID)) == PTE_PRESENT_INVALID)
> 
> I read this as "if the type field is 0 and PTE_PRESENT_INVALID is 1 then it's
> present-invalid". That doesn't really feel any better to me than the code
> knowing there is a table bit. What's the benefit of doing this vs what the code
> already does? It all feels quite hacky to me.

Table bit does not need to be known explicitly, which is the point of dropping
it off completely. 

#define pmd_mkinvalid()	pte_pmd(pte_mkinvalid(pmd_pte(pmd)))

static inline pte_t pte_mkinvalid(pte_t pte)
{
        pte = set_pte_bit(pte, __pgprot(PTE_PRESENT_INVALID));
        pte = clear_pte_bit(pte, __pgprot(PTE_VALID));
        return pte;
}

Instead pmd_mkinvalid() should be redefined as the following, asserting the fact
that PMD_TYPE_MASK bits as a block field which is being cleared and replaced with
PTE_PRESENT_INVALID, not only the table bit.

static inline pmd_t pmd_mkinvalid(pmd_t pmd)
{
        pmd = set_pmd_bit(pmd, __pgprot(PTE_PRESENT_INVALID));
        pmd = clear_pte_bit(pte, __pgprot(PMD_TYPE_MASK));
        return pte;
}

In fact currently PMD_TABLE_BIT check is required here only because pmd_present()
does not check against pmd_sect().

i.e pmd_present(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT); 

pmd_present() should return true when

- pmd_sect() returns true
- pmd_present_invalid() returns true because PMD_TYPE_MASK bits field has been
  cleared and instead PTE_PRESENT_INVALID has been set.

In both the cases PMD_TABLE_BIT is not required.

> 
>>
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  static inline int pmd_trans_huge(pmd_t pmd)
>>  {
>> 	return pmd_sect(pmd) || pmd_present_invalid(pmd);
>>  }
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>>
>>>>  }
>>>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>>  
>>>> @@ -586,7 +589,7 @@ static inline int pmd_trans_huge(pmd_t pmd)
>>>>  
>>>>  #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
>>>>  
>>>> -#define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
>>>> +#define pmd_mkhuge(pmd)		(__pmd((pmd_val(pmd) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT))
>>>
>>> I'm not sure if this also suffers from a similar problem? Is it possible that a
>>> present-invalid pmd would be passed to pmd_mkhuge()? If so, then we are now
>>> incorrectly setting the PTE_VALID bit.
>> pmd_mkhuge() converts a regular pmd into a huge page and on arm64
>> creating a huge page also involves setting PTE_VALID. Why would a
>> present-invalid pmd is passed into pmd_mkhuge() without intending
>> to make a huge entry ?
>>
>> There just two generic use cases for pmd_mkhuge().
>>
>> insert_pfn_pmd
>> 	   entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
>>
>> set_huge_zero_folio
>>         entry = mk_pmd(&zero_folio->page, vma->vm_page_prot);
>>         entry = pmd_mkhuge(entry);
>>
>> As instances in mm/debug_vm_pgtable.c, pmd_mkinvalid() should be
>> called on a PMD entry after pmd_mkhuge() not the other way around.
> 
> I guess it depends on your perspective. I agree there is no issue today. But
> from the core-mm's PoV, a present-invalid PMD should be indistinguishable from a
> present (-valid) one.

That's ideally is the case when huge page is achieved with a dedicated single HW
PTE bit apart from the valid HW PTE bit (which is not the case on arm64). So when
valid bit is cleared it still has the huge bit to test against for being "present"
with all other information on the entry, just that it's not mapped.

That's the reason PTE_PRESENT_INVALID is there to hold the fort while clearing out
PMD_VALID bit. But it actually rather clears entire PMD_TYPE_MASK completely and
depending on just PMD_TABLE_BIT being clear is not really prudent.

> 
> 
>>
>>>
>>>>  
>>>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>  #define pmd_devmap(pmd)		pte_devmap(pmd_pte(pmd))
>>>> @@ -614,7 +617,7 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
>>>>  #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
>>>>  #define pud_write(pud)		pte_write(pud_pte(pud))
>>>>  
>>>> -#define pud_mkhuge(pud)		(__pud(pud_val(pud) & ~PUD_TABLE_BIT))
>>>> +#define pud_mkhuge(pud)		(__pud((pud_val(pud) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT))
>>>>  
>>>>  #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
>>>>  #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
>>>> @@ -712,8 +715,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>>>>  
>>>>  #define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
>>>>  				 PMD_TYPE_TABLE)
>>>> -#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
>>>> -				 PMD_TYPE_SECT)
>>>>  #define pmd_leaf(pmd)		(pmd_present(pmd) && !pmd_table(pmd))
>>>>  #define pmd_bad(pmd)		(!pmd_table(pmd))
>>>>  
>>>
> 
