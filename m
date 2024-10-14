Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F272158DC4
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 10:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728902885; cv=none; b=pmz5KUn4XNNy+3AQ3j4dNR9G+zKKLKSsLPULpmHHM8jXb+h9oFxE8rYAzsHt7lQA3ITdqcMVMzlVBhQF4mbIPau5qwDyfn3VIRiNQhU+90QlB1wA+LFIAASaLWkl4R+uj07sUFk7yUJ3FJlXqfIZx5sNt8/isvL0UkQASxBR/EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728902885; c=relaxed/simple;
	bh=Fy8O4T0wrSTEzzQEqExtz1vMOSLdBu40q/2KIJ6LpQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oA4ULTIxgLSCRytz26/yHOtKborZICsk7ObqinCeIZmdcSkBz1Ig3P1Xy2DPAQCyYbu5ZJnOeHsy6wywd5ee/Lgzb3QdBPnWDnvEg+PFYwboz2hIhrVXWV4zV2Gvb4qhDd/rdKHs3ajKcEv5BUe6CLr7n9zdmJP54ZHNTSihA4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F01891007;
	Mon, 14 Oct 2024 03:48:31 -0700 (PDT)
Received: from [10.163.38.184] (unknown [10.163.38.184])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D27F3F51B;
	Mon, 14 Oct 2024 03:47:58 -0700 (PDT)
Message-ID: <61203419-014e-4815-823c-62079aea93c9@arm.com>
Date: Mon, 14 Oct 2024 16:18:00 +0530
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
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <bb1dcfcf-302a-4932-a0d5-3abf5ed958c5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/9/24 18:58, Ryan Roberts wrote:
> On 05/10/2024 13:38, Anshuman Khandual wrote:
>> This modifies existing block mapping related helpers e.g [pmd|pud]_mkhuge()
>> , mk_[pmd|pud]_sect_prot() and pmd_trans_huge() to use PXD_TYPE_[MASK|SECT]
>> instead of corresponding PXD_TABLE_BIT. This also moves pmd_sect() earlier
>> for the symbol's availability preventing a build warning.
>>
>> While here this also drops pmd_val() check from pmd_trans_huge() helper, as
>> pmd_present() returning true already ensures that pmd_val() cannot be false
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 15 ++++++++-------
>>  1 file changed, 8 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index fa4c32a9f572..45c49c5ace80 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -484,12 +484,12 @@ static inline pmd_t pte_pmd(pte_t pte)
>>  
>>  static inline pgprot_t mk_pud_sect_prot(pgprot_t prot)
>>  {
>> -	return __pgprot((pgprot_val(prot) & ~PUD_TABLE_BIT) | PUD_TYPE_SECT);
>> +	return __pgprot((pgprot_val(prot) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT);
>>  }
>>  
>>  static inline pgprot_t mk_pmd_sect_prot(pgprot_t prot)
>>  {
>> -	return __pgprot((pgprot_val(prot) & ~PMD_TABLE_BIT) | PMD_TYPE_SECT);
>> +	return __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
>>  }
>>  
>>  static inline pte_t pte_swp_mkexclusive(pte_t pte)
>> @@ -554,10 +554,13 @@ static inline int pmd_protnone(pmd_t pmd)
>>   * THP definitions.
>>   */
>>  
>> +#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
>> +				 PMD_TYPE_SECT)
>> +
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  static inline int pmd_trans_huge(pmd_t pmd)
>>  {
>> -	return pmd_val(pmd) && pmd_present(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
>> +	return pmd_present(pmd) && pmd_sect(pmd);
> 
> Bug? Prevously we would have returned true for a "present-invalid" PMD block
> mapping - that's one which is formatted as a PMD block mapping except the
> PTE_VALID bit is clear and PTE_PRESENT_INVALID is set. But now, due to
> pmd_sect() testing VALID is set (via PMD_TYPE_SECT), we no longer return true in
> this case.

Agreed, that will be problematic but the situation can be rectified by decoupling
pmd_present_invalid() from pte_present_invalid() by checking for both last bits
instead of just the valid bit against PTE_PRESENT_INVALID.

#define pmd_sect(pmd)          ((pmd_val(pmd) & PMD_TYPE_MASK) == \
                                PMD_TYPE_SECT)

#define pmd_present_invalid(pmd) \
       ((pmd_val(pmd) & (PMD_TYPE_MASK | PTE_PRESENT_INVALID)) == PTE_PRESENT_INVALID)

 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
	return pmd_sect(pmd) || pmd_present_invalid(pmd);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */

> 
>>  }
>>  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>  
>> @@ -586,7 +589,7 @@ static inline int pmd_trans_huge(pmd_t pmd)
>>  
>>  #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
>>  
>> -#define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
>> +#define pmd_mkhuge(pmd)		(__pmd((pmd_val(pmd) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT))
> 
> I'm not sure if this also suffers from a similar problem? Is it possible that a
> present-invalid pmd would be passed to pmd_mkhuge()? If so, then we are now
> incorrectly setting the PTE_VALID bit.
pmd_mkhuge() converts a regular pmd into a huge page and on arm64
creating a huge page also involves setting PTE_VALID. Why would a
present-invalid pmd is passed into pmd_mkhuge() without intending
to make a huge entry ?

There just two generic use cases for pmd_mkhuge().

insert_pfn_pmd
	   entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));

set_huge_zero_folio
        entry = mk_pmd(&zero_folio->page, vma->vm_page_prot);
        entry = pmd_mkhuge(entry);

As instances in mm/debug_vm_pgtable.c, pmd_mkinvalid() should be
called on a PMD entry after pmd_mkhuge() not the other way around.

> 
>>  
>>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  #define pmd_devmap(pmd)		pte_devmap(pmd_pte(pmd))
>> @@ -614,7 +617,7 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
>>  #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
>>  #define pud_write(pud)		pte_write(pud_pte(pud))
>>  
>> -#define pud_mkhuge(pud)		(__pud(pud_val(pud) & ~PUD_TABLE_BIT))
>> +#define pud_mkhuge(pud)		(__pud((pud_val(pud) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT))
>>  
>>  #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
>>  #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
>> @@ -712,8 +715,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
>>  
>>  #define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
>>  				 PMD_TYPE_TABLE)
>> -#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
>> -				 PMD_TYPE_SECT)
>>  #define pmd_leaf(pmd)		(pmd_present(pmd) && !pmd_table(pmd))
>>  #define pmd_bad(pmd)		(!pmd_table(pmd))
>>  
> 
