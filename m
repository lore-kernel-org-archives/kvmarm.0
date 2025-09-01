Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3113931AF08
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730752; cv=none; b=l9vxdppCodxRr0C/9lhxEHPJjJqjVwXZETOvlyniXOPsy9YS77Y4DnEu/y4p7js61YY7KZjyllb39XdyUwjg16BHGDvxdEeQaWGa8ck49mmIe95t27bmRnxNYC+sEr0FsGreMvmpUGiIOx8Yc+PVnm/h4za4+hWpa1TOFYZGYbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730752; c=relaxed/simple;
	bh=dVStAfEgko4TYcCvhCj7zcqJ+XM9dEF+LYtHnZ7rmO0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DfMBWGZQTOZBTsz9QN8qBoEsxZb/7vPljrCelzCKqwLrO5AmyGMTkxUhz7aGd6tsgRNV0eW+DbSZFviHUjXXxa8Aa7EjajU0NcWbaQQHtf0w3qocp4L917cGWbm5NpcrKW5mjQYmgcIUy7keqomVNYbSEM2zgnrrl+crtTUeMws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 021E716A3;
	Mon,  1 Sep 2025 05:45:40 -0700 (PDT)
Received: from [10.163.70.120] (unknown [10.163.70.120])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D169A3F694;
	Mon,  1 Sep 2025 05:45:44 -0700 (PDT)
Message-ID: <dd34c47a-ea5a-4bd6-a27e-11f55a08d27e@arm.com>
Date: Mon, 1 Sep 2025 18:15:41 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] arm64/sysreg: Replace TCR_EL1 field macros
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250901072037.743380-1-anshuman.khandual@arm.com>
 <20250901072037.743380-3-anshuman.khandual@arm.com>
 <07171e19-71a4-4672-adfd-03feb17433e9@arm.com>
 <8faf8d1d-0987-4ce0-b626-01de8f214baf@arm.com>
Content-Language: en-US
In-Reply-To: <8faf8d1d-0987-4ce0-b626-01de8f214baf@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 01/09/25 4:47 PM, Anshuman Khandual wrote:
> 
> 
> On 01/09/25 4:07 PM, Ben Horgan wrote:
>> Hi Anshuman,
>>
>> On 9/1/25 08:20, Anshuman Khandual wrote:
>>> This just replaces all used TCR_EL1 field macros with tools sysreg variant
>>> based fields and subsequently drops them from the header (pgtable-hwdef.h)
>>> and moves them into KVM header (asm/kvm_arm.h) for continued usage in KVM.
>>>
>>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Will Deacon <will@kernel.org>
>>> Cc: Marc Zyngier <maz@kernel.org>
>>> Cc: Mark Brown <broonie@kernel.org>
>>> Cc: kvmarm@lists.linux.dev
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>> Changes in V3:
>>>
>>> - KVM TCR_XXX flags are expressed via TCR_EL1_XXX flags per Marc
>>>
>>>  arch/arm64/include/asm/assembler.h     |  6 +-
>>>  arch/arm64/include/asm/cputype.h       |  2 +-
>>>  arch/arm64/include/asm/kvm_arm.h       | 78 ++++++++++++++++++++
>>>  arch/arm64/include/asm/mmu_context.h   |  4 +-
>>>  arch/arm64/include/asm/pgtable-hwdef.h | 98 +-------------------------
>>>  arch/arm64/include/asm/pgtable-prot.h  |  2 +-
>>>  arch/arm64/kernel/cpufeature.c         |  4 +-
>>>  arch/arm64/kernel/pi/map_kernel.c      |  8 +--
>>>  arch/arm64/kernel/vmcore_info.c        |  2 +-
>>>  arch/arm64/mm/proc.S                   | 36 ++++++----
>>>  tools/arch/arm64/include/asm/cputype.h |  2 +-
>>>  11 files changed, 118 insertions(+), 124 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>>> index 23be85d93348..1392860a3c97 100644
>>> --- a/arch/arm64/include/asm/assembler.h
>>> +++ b/arch/arm64/include/asm/assembler.h
>>> @@ -325,14 +325,14 @@ alternative_cb_end
>>>   * tcr_set_t0sz - update TCR.T0SZ so that we can load the ID map
>>>   */
>>>  	.macro	tcr_set_t0sz, valreg, t0sz
>>> -	bfi	\valreg, \t0sz, #TCR_T0SZ_OFFSET, #TCR_TxSZ_WIDTH
>>> +	bfi	\valreg, \t0sz, #TCR_EL1_T0SZ_SHIFT, #TCR_EL1_T0SZ_WIDTH
>>>  	.endm
>>>  
>>>  /*
>>>   * tcr_set_t1sz - update TCR.T1SZ
>>>   */
>>>  	.macro	tcr_set_t1sz, valreg, t1sz
>>> -	bfi	\valreg, \t1sz, #TCR_T1SZ_OFFSET, #TCR_TxSZ_WIDTH
>>> +	bfi	\valreg, \t1sz, #TCR_EL1_T1SZ_SHIFT, #TCR_EL1_T1SZ_WIDTH
>>>  	.endm
>>>  
>>>  /*
>>> @@ -589,7 +589,7 @@ alternative_endif
>>>  	.macro	offset_ttbr1, ttbr, tmp
>>>  #if defined(CONFIG_ARM64_VA_BITS_52) && !defined(CONFIG_ARM64_LPA2)
>>>  	mrs	\tmp, tcr_el1
>>> -	and	\tmp, \tmp, #TCR_T1SZ_MASK
>>> +	and	\tmp, \tmp, #TCR_EL1_T1SZ_MASK
>>>  	cmp	\tmp, #TCR_T1SZ(VA_BITS_MIN)
>>>  	orr	\tmp, \ttbr, #TTBR1_BADDR_4852_OFFSET
>>>  	csel	\ttbr, \tmp, \ttbr, eq
>>> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
>>> index 661735616787..5d80710ca85f 100644
>>> --- a/arch/arm64/include/asm/cputype.h
>>> +++ b/arch/arm64/include/asm/cputype.h
>>> @@ -243,7 +243,7 @@
>>>  /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
>>>  #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
>>>  #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
>>> -#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
>>> +#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
>>>  
>>>  #ifndef __ASSEMBLY__
>>>  
>>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>>> index 1da290aeedce..4e0ca6140857 100644
>>> --- a/arch/arm64/include/asm/kvm_arm.h
>>> +++ b/arch/arm64/include/asm/kvm_arm.h
>>> @@ -107,6 +107,84 @@
>>>  
>>>  #define MPAMHCR_HOST_FLAGS	0
>>>  
>>> +#define TCR_T0SZ_MASK		TCR_EL1_T0SZ_MASK
>>> +#define TCR_T1SZ_MASK		TCR_EL1_T1SZ_MASK
>>> +
>>> +#define TCR_EPD0_MASK		TCR_EL1_EPD0_MASK
>>> +#define TCR_EPD1_MASK		TCR_EL1_EPD1_MASK
>>> +
>>> +#define TCR_IRGN0_MASK		TCR_EL1_IRGN0_MASK
>>> +#define TCR_IRGN0_NC		(TCR_EL1_IRGN0_NC << TCR_EL1_IRGN0_SHIFT)
>>> +#define TCR_IRGN0_WBWA		(TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT)
>>> +#define TCR_IRGN0_WT		(TCR_EL1_IRGN0_WT << TCR_EL1_IRGN0_SHIFT)
>>> +#define TCR_IRGN0_WBnWA		(TCR_EL1_IRGN0_WBnWA << TCR_EL1_IRGN0_SHIFT)
>>> +
>>> +#define TCR_IRGN1_MASK		TCR_EL1_IRGN1_MASK
>>> +#define TCR_IRGN1_NC		(TCR_EL1_IRGN1_NC << TCR_EL1_IRGN1_SHIFT)
>>> +#define TCR_IRGN1_WBWA		(TCR_EL1_IRGN1_WBWA << TCR_EL1_IRGN1_SHIFT)
>>> +#define TCR_IRGN1_WT		(TCR_EL1_IRGN1_WT << TCR_EL1_IRGN1_SHIFT)
>>> +#define TCR_IRGN1_WBnWA		(TCR_EL1_IRGN1_WBnWA << TCR_EL1_IRGN1_SHIFT)
>>> +
>>> +#define TCR_IRGN_NC		(TCR_EL1_IRGN0_NC | TCR_EL1_IRGN1_NC)
>>> +#define TCR_IRGN_WT		(TCR_EL1_IRGN0_WT | TCR_EL1_IRGN1_WT)
>>> +#define TCR_IRGN_WBnWA		(TCR_EL1_IRGN0_WBnWA | TCR_EL1_IRGN1_WBnWA)
>>> +#define TCR_IRGN_MASK		(TCR_EL1_IRGN0_MASK | TCR_EL1_IRGN1_MASK)
>>> +
>>> +#define TCR_ORGN0_MASK		TCR_EL1_ORGN0_MASK
>>> +#define TCR_ORGN0_NC		(TCR_EL1_ORGN0_NC << TCR_EL1_ORGN0_SHIFT)
>>> +#define TCR_ORGN0_WBWA		(TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT)
>>> +#define TCR_ORGN0_WT		(TCR_EL1_ORGN0_WT << TCR_EL1_ORGN0_SHIFT)
>>> +#define TCR_ORGN0_WBnWA		(TCR_EL1_ORGN0_WBnWA << TCR_EL1_ORGN0_SHIFT)
>>> +
>>> +#define TCR_ORGN1_MASK		TCR_EL1_ORGN1_MASK
>>> +#define TCR_ORGN1_NC		(TCR_EL1_ORGN1_NC << TCR_EL1_ORGN1_SHIFT)
>>> +#define TCR_ORGN1_WBWA		(TCR_EL1_ORGN1_WBWA << TCR_EL1_ORGN1_SHIFT)
>>> +#define TCR_ORGN1_WT		(TCR_EL1_ORGN1_WT << TCR_EL1_ORGN1_SHIFT)
>>> +#define TCR_ORGN1_WBnWA		(TCR_EL1_ORGN1_WBnWA << TCR_EL1_ORGN1_SHIFT)
>>> +
>>> +#define TCR_ORGN_NC		(TCR_EL1_ORGN0_NC | TCR_EL1_ORGN1_NC)
>>> +#define TCR_ORGN_WT		(TCR_EL1_ORGN0_WT | TCR_EL1_ORGN1_WT)
>>> +#define TCR_ORGN_WBnWA		(TCR_EL1_ORGN0_WBnWA | TCR_EL1_ORGN1_WBnWA)
>> Shouldn't these 3 be defined as per the code you remove below?
>>
>> #define TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
>> #define TCR_ORGN_WT		(TCR_ORGN0_WT | TCR_ORGN1_WT)
>> #define TCR_ORGN_WBnWA		(TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
>>
>> However, it does seem surprising that whether or not EL1 is in the name
>> changes whether there is a shift or not.
> 
> I am afraid you are right.
> 
> Originally TCR_ORGN_NC actually ORed in place shifted values
> for both ORGN0 and ORGN1 register fields.
> 
> TCR_ORGN0_NC (UL(0) << TCR_ORGN0_SHIFT)
> TCR_ORGN1_NC (UL(0) << TCR_ORGN1_SHIFT)
> TCR_ORGN_NC (TCR_ORGN0_NC | TCR_ORGN1_NC)
> 
> Hence after this change it should still do the same.
> 
> TCR_ORGN0_NC            (TCR_EL1_ORGN0_NC << TCR_EL1_ORGN0_SHIFT)
> TCR_ORGN1_WBWA          (TCR_EL1_ORGN1_WBWA << TCR_EL1_ORGN1_SHIFT)
> 
> As TCR_ORGN0_NC and TCR_ORGN1_WBWA again contain the shifted
> in place register field values, hence these macro definitions
> should not change at all.
> 
> It should still be
> 
> TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
> 
> Not as proposed in this patch
> 
> TCR_ORGN_NC		(TCR_EL1_ORGN0_NC | TCR_EL1_ORGN1_NC)
> 
> This problem exists for the above TCR_IRGN_XXX flags as well.
> Will do the following changes.
> 
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -125,10 +125,10 @@
>  #define TCR_IRGN1_WT           (TCR_EL1_IRGN1_WT << TCR_EL1_IRGN1_SHIFT)
>  #define TCR_IRGN1_WBnWA                (TCR_EL1_IRGN1_WBnWA << TCR_EL1_IRGN1_SHIFT)
> 
> -#define TCR_IRGN_NC            (TCR_EL1_IRGN0_NC | TCR_EL1_IRGN1_NC)
> -#define TCR_IRGN_WT            (TCR_EL1_IRGN0_WT | TCR_EL1_IRGN1_WT)
> -#define TCR_IRGN_WBnWA         (TCR_EL1_IRGN0_WBnWA | TCR_EL1_IRGN1_WBnWA)
> -#define TCR_IRGN_MASK          (TCR_EL1_IRGN0_MASK | TCR_EL1_IRGN1_MASK)
> +#define TCR_IRGN_NC            (TCR_IRGN0_NC | TCR_IRGN1_NC)
> +#define TCR_IRGN_WT            (TCR_IRGN0_WT | TCR_IRGN1_WT)
> +#define TCR_IRGN_WBnWA         (TCR_IRGN0_WBnWA | TCR_IRGN1_WBnWA)
> +#define TCR_IRGN_MASK          (TCR_IRGN0_MASK | TCR_IRGN1_MASK)
> 
>  #define TCR_ORGN0_MASK         TCR_EL1_ORGN0_MASK
>  #define TCR_ORGN0_NC           (TCR_EL1_ORGN0_NC << TCR_EL1_ORGN0_SHIFT)
> @@ -142,10 +142,10 @@
>  #define TCR_ORGN1_WT           (TCR_EL1_ORGN1_WT << TCR_EL1_ORGN1_SHIFT)
>  #define TCR_ORGN1_WBnWA                (TCR_EL1_ORGN1_WBnWA << TCR_EL1_ORGN1_SHIFT)
> 
> -#define TCR_ORGN_NC            (TCR_EL1_ORGN0_NC | TCR_EL1_ORGN1_NC)
> -#define TCR_ORGN_WT            (TCR_EL1_ORGN0_WT | TCR_EL1_ORGN1_WT)
> -#define TCR_ORGN_WBnWA         (TCR_EL1_ORGN0_WBnWA | TCR_EL1_ORGN1_WBnWA)
> -#define TCR_ORGN_MASK          (TCR_EL1_ORGN0_MASK | TCR_EL1_ORGN1_MASK)
> +#define TCR_ORGN_NC            (TCR_ORGN0_NC | TCR_ORGN1_NC)
> +#define TCR_ORGN_WT            (TCR_ORGN0_WT | TCR_ORGN1_WT)
> +#define TCR_ORGN_WBnWA         (TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
> +#define TCR_ORGN_MASK          (TCR_ORGN0_MASK | TCR_ORGN1_MASK)
> 
>  #define TCR_SH0_MASK           TCR_EL1_SH0_MASK
>  #define TCR_SH0_INNER          (TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT) 

These macros are not used in KVM and hence can be dropped off completely
along with some others that are being moved here. The following set of
TCR_XXX macros seems to be sufficient for KVM.

#define TCR_T0SZ_MASK           TCR_EL1_T0SZ_MASK
#define TCR_T1SZ_MASK           TCR_EL1_T1SZ_MASK

#define TCR_EPD0_MASK           TCR_EL1_EPD0_MASK
#define TCR_EPD1_MASK           TCR_EL1_EPD1_MASK

#define TCR_IRGN0_MASK          TCR_EL1_IRGN0_MASK
#define TCR_ORGN0_MASK          TCR_EL1_ORGN0_MASK
#define TCR_IRGN0_WBWA          (TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT)
#define TCR_ORGN0_WBWA          (TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT)

#define TCR_SH0_MASK            TCR_EL1_SH0_MASK
#define TCR_SH0_INNER           (TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT)

#define TCR_TG0_SHIFT           TCR_EL1_TG0_SHIFT
#define TCR_TG0_MASK            TCR_EL1_TG0_MASK
#define TCR_TG0_4K              (TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT)
#define TCR_TG0_64K             (TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT)
#define TCR_TG0_16K             (TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT)

#define TCR_TG1_SHIFT           TCR_EL1_TG1_SHIFT
#define TCR_TG1_MASK            TCR_EL1_TG1_MASK
#define TCR_TG1_16K             (TCR_EL1_TG1_16K << TCR_EL1_TG1_SHIFT)
#define TCR_TG1_4K              (TCR_EL1_TG1_4K << TCR_EL1_TG1_SHIFT)
#define TCR_TG1_64K             (TCR_EL1_TG1_64K << TCR_EL1_TG1_SHIFT)

#define TCR_IPS_SHIFT           TCR_EL1_IPS_SHIFT
#define TCR_IPS_MASK            TCR_EL1_IPS_MASK
#define TCR_A1                  TCR_EL1_A1
#define TCR_ASID16              TCR_EL1_AS
#define TCR_TBI0                TCR_EL1_TBI0
#define TCR_TBI1                TCR_EL1_TBI1
#define TCR_HA                  TCR_EL1_HA
#define TCR_HD                  TCR_EL1_HD
#define TCR_HPD0                TCR_EL1_HPD0
#define TCR_HPD1                TCR_EL1_HPD1
#define TCR_TBID0               TCR_EL1_TBID0
#define TCR_TBID1               TCR_EL1_TBID1
#define TCR_E0PD0               TCR_EL1_E0PD0
#define TCR_E0PD1               TCR_EL1_E0PD1
#define TCR_DS                  TCR_EL1_DS
