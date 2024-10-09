Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D711192B70
	for <kvmarm@lists.linux.dev>; Wed,  9 Oct 2024 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728480022; cv=none; b=oRUAelBkZn3NSBSf6kOhReAlbYgUJInZb2AdLiRhhb01Fnm/pRjCMWi+YxRmMNti+oAkJpSdJMcFcEVi84KrZ0TbtJ2Vb2yAwmy67bA+BxEylJNmraPalj//3hPFFY0YYILjLnBeF+kT/FMQSyV3ZicpOv586pXkAOvEEmgiSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728480022; c=relaxed/simple;
	bh=cxz8JqYSfJgKxH0omaM69q1S6g8ZUsSIkHkuApJ4mls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cnlpTTevgHjxy4/52Tl9DtJeHiBNh8BtBhJr9RnZEsbg5TRBI60RLcRSHYU6kyfmf1P1WiIPOWUx6vQBdt35Oeg3QqLoQQ5jO/X2nurig9NIq7xXSMtthJF3Zwuujl+wrTI/6ykyEJJkXW2PuzjnmugNyYXZ7S67RAMQZn7rtQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E6EEFEC;
	Wed,  9 Oct 2024 06:20:48 -0700 (PDT)
Received: from [10.57.85.216] (unknown [10.57.85.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FD5A3F58B;
	Wed,  9 Oct 2024 06:20:17 -0700 (PDT)
Message-ID: <a4372d54-34bb-4a32-8742-ea6aacc0848c@arm.com>
Date: Wed, 9 Oct 2024 14:20:15 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] arm64/mm: Drop pte_mkhuge()
Content-Language: en-GB
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
 <20241005123824.1366397-2-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20241005123824.1366397-2-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/10/2024 13:38, Anshuman Khandual wrote:
> Core HugeTLB defines arch_make_huge_pte() fallback definition, which calls
> platform provided pte_mkhuge(). But if any platform already provides custom
> arch_make_huge_pte(), then it does not need to provide pte_mkhuge(). arm64
> defines arch_make_huge_pte(), but then also calls pte_mkhuge() internally.
> This creates confusion as if both of these callbacks are being used in core
> HugeTLB and required to be defined in the platform.
> 
> This changes arch_make_huge_pte() to create block mapping directly and also
> drops off now redundant helper pte_mkhuge(), making things clear. Also this
> changes HugeTLB page creation from just clearing the PTE_TABLE_BIT (bit[1])
> to actually setting bits[1:0] via PTE_TYPE_[MASK|SECT] instead.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable-hwdef.h | 1 +
>  arch/arm64/include/asm/pgtable.h       | 5 -----
>  arch/arm64/mm/hugetlbpage.c            | 2 +-
>  3 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index fd330c1db289..956a702cb532 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -158,6 +158,7 @@
>  #define PTE_VALID		(_AT(pteval_t, 1) << 0)
>  #define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
>  #define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
> +#define PTE_TYPE_SECT		(_AT(pteval_t, 1) << 0)
>  #define PTE_TABLE_BIT		(_AT(pteval_t, 1) << 1)
>  #define PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
>  #define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* AP[2] */
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index c329ea061dc9..fa4c32a9f572 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -438,11 +438,6 @@ static inline void __set_ptes(struct mm_struct *mm,
>  	}
>  }
>  
> -/*
> - * Huge pte definitions.
> - */
> -#define pte_mkhuge(pte)		(__pte(pte_val(pte) & ~PTE_TABLE_BIT))
> -
>  /*
>   * Hugetlb definitions.
>   */
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 5f1e2103888b..5922c95630ad 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -361,7 +361,7 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
>  {
>  	size_t pagesize = 1UL << shift;
>  
> -	entry = pte_mkhuge(entry);
> +	entry = __pte((pte_val(entry) & ~PTE_TYPE_MASK) | PTE_TYPE_SECT);

I think there may be an existing bug here; if pagesize == CONT_PTE_SIZE, then
entry will be placed in the level 3 table. In this case, shouldn't bit 1 remain
set, because at level 3, a page mapping is denoted by bits[1:0] = 3 ? Currently
its being unconditionally cleared.

>  	if (pagesize == CONT_PTE_SIZE) {
>  		entry = pte_mkcont(entry);
>  	} else if (pagesize == CONT_PMD_SIZE) {

