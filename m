Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97AEB244660
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 10:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756723051; cv=none; b=D3N6v+/uf2SilJxCDD19bqLiBTHStAm7r2Gewa9xhXxps9XqVSfSRdZ5vx9gxMiryhgBwkF8YB1jeKdbnVbtkUDDg7ECCGyA2NgT3REnQv8G7Ljhgo3iI5CV2CMlQ7WZZjuU5kfZWir53U/db67M55BpXXVPOV64qe34inamlDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756723051; c=relaxed/simple;
	bh=S8gxZ1MUpVftIgPaTK3+NJe55LRjkZdTn6eilVpKB9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t6W6iqNwfEOBZYW5Gs0OlyEVYgGQGq2O6LYsGcUGHMPzqXjV0Ic0gZ9x3Tdlv9HdFOJoOSBFxo3GHBmj6r9ZRElwg8Jrujt0XXK3AdCJ+91LMfMCEIhXyS6gWFH7O6uueLFkNOxSQQSl9O+vhv0ZW4e7AqqRKH6FxqPBOWQ5NZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B017D16A3;
	Mon,  1 Sep 2025 03:37:19 -0700 (PDT)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 778B43F6A8;
	Mon,  1 Sep 2025 03:37:26 -0700 (PDT)
Message-ID: <07171e19-71a4-4672-adfd-03feb17433e9@arm.com>
Date: Mon, 1 Sep 2025 11:37:25 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/2] arm64/sysreg: Replace TCR_EL1 field macros
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Mark Brown <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250901072037.743380-1-anshuman.khandual@arm.com>
 <20250901072037.743380-3-anshuman.khandual@arm.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <20250901072037.743380-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Anshuman,

On 9/1/25 08:20, Anshuman Khandual wrote:
> This just replaces all used TCR_EL1 field macros with tools sysreg variant
> based fields and subsequently drops them from the header (pgtable-hwdef.h)
> and moves them into KVM header (asm/kvm_arm.h) for continued usage in KVM.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: kvmarm@lists.linux.dev
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in V3:
> 
> - KVM TCR_XXX flags are expressed via TCR_EL1_XXX flags per Marc
> 
>  arch/arm64/include/asm/assembler.h     |  6 +-
>  arch/arm64/include/asm/cputype.h       |  2 +-
>  arch/arm64/include/asm/kvm_arm.h       | 78 ++++++++++++++++++++
>  arch/arm64/include/asm/mmu_context.h   |  4 +-
>  arch/arm64/include/asm/pgtable-hwdef.h | 98 +-------------------------
>  arch/arm64/include/asm/pgtable-prot.h  |  2 +-
>  arch/arm64/kernel/cpufeature.c         |  4 +-
>  arch/arm64/kernel/pi/map_kernel.c      |  8 +--
>  arch/arm64/kernel/vmcore_info.c        |  2 +-
>  arch/arm64/mm/proc.S                   | 36 ++++++----
>  tools/arch/arm64/include/asm/cputype.h |  2 +-
>  11 files changed, 118 insertions(+), 124 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index 23be85d93348..1392860a3c97 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -325,14 +325,14 @@ alternative_cb_end
>   * tcr_set_t0sz - update TCR.T0SZ so that we can load the ID map
>   */
>  	.macro	tcr_set_t0sz, valreg, t0sz
> -	bfi	\valreg, \t0sz, #TCR_T0SZ_OFFSET, #TCR_TxSZ_WIDTH
> +	bfi	\valreg, \t0sz, #TCR_EL1_T0SZ_SHIFT, #TCR_EL1_T0SZ_WIDTH
>  	.endm
>  
>  /*
>   * tcr_set_t1sz - update TCR.T1SZ
>   */
>  	.macro	tcr_set_t1sz, valreg, t1sz
> -	bfi	\valreg, \t1sz, #TCR_T1SZ_OFFSET, #TCR_TxSZ_WIDTH
> +	bfi	\valreg, \t1sz, #TCR_EL1_T1SZ_SHIFT, #TCR_EL1_T1SZ_WIDTH
>  	.endm
>  
>  /*
> @@ -589,7 +589,7 @@ alternative_endif
>  	.macro	offset_ttbr1, ttbr, tmp
>  #if defined(CONFIG_ARM64_VA_BITS_52) && !defined(CONFIG_ARM64_LPA2)
>  	mrs	\tmp, tcr_el1
> -	and	\tmp, \tmp, #TCR_T1SZ_MASK
> +	and	\tmp, \tmp, #TCR_EL1_T1SZ_MASK
>  	cmp	\tmp, #TCR_T1SZ(VA_BITS_MIN)
>  	orr	\tmp, \ttbr, #TTBR1_BADDR_4852_OFFSET
>  	csel	\ttbr, \tmp, \ttbr, eq
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index 661735616787..5d80710ca85f 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -243,7 +243,7 @@
>  /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
>  #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
>  #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
> -#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
> +#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
>  
>  #ifndef __ASSEMBLY__
>  
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 1da290aeedce..4e0ca6140857 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -107,6 +107,84 @@
>  
>  #define MPAMHCR_HOST_FLAGS	0
>  
> +#define TCR_T0SZ_MASK		TCR_EL1_T0SZ_MASK
> +#define TCR_T1SZ_MASK		TCR_EL1_T1SZ_MASK
> +
> +#define TCR_EPD0_MASK		TCR_EL1_EPD0_MASK
> +#define TCR_EPD1_MASK		TCR_EL1_EPD1_MASK
> +
> +#define TCR_IRGN0_MASK		TCR_EL1_IRGN0_MASK
> +#define TCR_IRGN0_NC		(TCR_EL1_IRGN0_NC << TCR_EL1_IRGN0_SHIFT)
> +#define TCR_IRGN0_WBWA		(TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT)
> +#define TCR_IRGN0_WT		(TCR_EL1_IRGN0_WT << TCR_EL1_IRGN0_SHIFT)
> +#define TCR_IRGN0_WBnWA		(TCR_EL1_IRGN0_WBnWA << TCR_EL1_IRGN0_SHIFT)
> +
> +#define TCR_IRGN1_MASK		TCR_EL1_IRGN1_MASK
> +#define TCR_IRGN1_NC		(TCR_EL1_IRGN1_NC << TCR_EL1_IRGN1_SHIFT)
> +#define TCR_IRGN1_WBWA		(TCR_EL1_IRGN1_WBWA << TCR_EL1_IRGN1_SHIFT)
> +#define TCR_IRGN1_WT		(TCR_EL1_IRGN1_WT << TCR_EL1_IRGN1_SHIFT)
> +#define TCR_IRGN1_WBnWA		(TCR_EL1_IRGN1_WBnWA << TCR_EL1_IRGN1_SHIFT)
> +
> +#define TCR_IRGN_NC		(TCR_EL1_IRGN0_NC | TCR_EL1_IRGN1_NC)
> +#define TCR_IRGN_WT		(TCR_EL1_IRGN0_WT | TCR_EL1_IRGN1_WT)
> +#define TCR_IRGN_WBnWA		(TCR_EL1_IRGN0_WBnWA | TCR_EL1_IRGN1_WBnWA)
> +#define TCR_IRGN_MASK		(TCR_EL1_IRGN0_MASK | TCR_EL1_IRGN1_MASK)
> +
> +#define TCR_ORGN0_MASK		TCR_EL1_ORGN0_MASK
> +#define TCR_ORGN0_NC		(TCR_EL1_ORGN0_NC << TCR_EL1_ORGN0_SHIFT)
> +#define TCR_ORGN0_WBWA		(TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT)
> +#define TCR_ORGN0_WT		(TCR_EL1_ORGN0_WT << TCR_EL1_ORGN0_SHIFT)
> +#define TCR_ORGN0_WBnWA		(TCR_EL1_ORGN0_WBnWA << TCR_EL1_ORGN0_SHIFT)
> +
> +#define TCR_ORGN1_MASK		TCR_EL1_ORGN1_MASK
> +#define TCR_ORGN1_NC		(TCR_EL1_ORGN1_NC << TCR_EL1_ORGN1_SHIFT)
> +#define TCR_ORGN1_WBWA		(TCR_EL1_ORGN1_WBWA << TCR_EL1_ORGN1_SHIFT)
> +#define TCR_ORGN1_WT		(TCR_EL1_ORGN1_WT << TCR_EL1_ORGN1_SHIFT)
> +#define TCR_ORGN1_WBnWA		(TCR_EL1_ORGN1_WBnWA << TCR_EL1_ORGN1_SHIFT)
> +
> +#define TCR_ORGN_NC		(TCR_EL1_ORGN0_NC | TCR_EL1_ORGN1_NC)
> +#define TCR_ORGN_WT		(TCR_EL1_ORGN0_WT | TCR_EL1_ORGN1_WT)
> +#define TCR_ORGN_WBnWA		(TCR_EL1_ORGN0_WBnWA | TCR_EL1_ORGN1_WBnWA)

Shouldn't these 3 be defined as per the code you remove below?

#define TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
#define TCR_ORGN_WT		(TCR_ORGN0_WT | TCR_ORGN1_WT)
#define TCR_ORGN_WBnWA		(TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)

However, it does seem surprising that whether or not EL1 is in the name
changes whether there is a shift or not.


> +#define TCR_ORGN_MASK		(TCR_EL1_ORGN0_MASK | TCR_EL1_ORGN1_MASK)
> +
> +#define TCR_SH0_MASK		TCR_EL1_SH0_MASK
> +#define TCR_SH0_INNER		(TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT)
> +
> +#define TCR_SH1_MASK		TCR_EL1_SH1_MASK
> +#define TCR_SH1_INNER		(TCR_EL1_SH1_INNER << TCR_EL1_SH1_SHIFT)
> +
> +#define TCR_TG0_SHIFT		TCR_EL1_TG0_SHIFT
> +#define TCR_TG0_MASK		TCR_EL1_TG0_MASK
> +#define TCR_TG0_4K		(TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT)
> +#define TCR_TG0_64K		(TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT)
> +#define TCR_TG0_16K		(TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT)
> +
> +#define TCR_TG1_SHIFT		TCR_EL1_TG1_SHIFT
> +#define TCR_TG1_MASK		TCR_EL1_TG1_MASK
> +#define TCR_TG1_16K		(TCR_EL1_TG1_16K << TCR_EL1_TG1_SHIFT)
> +#define TCR_TG1_4K		(TCR_EL1_TG1_4K << TCR_EL1_TG1_SHIFT)
> +#define TCR_TG1_64K		(TCR_EL1_TG1_64K << TCR_EL1_TG1_SHIFT)
> +
> +#define TCR_IPS_SHIFT		TCR_EL1_IPS_SHIFT
> +#define TCR_IPS_MASK		TCR_EL1_IPS_MASK
> +#define TCR_A1			TCR_EL1_A1
> +#define TCR_ASID16		TCR_EL1_AS
> +#define TCR_TBI0		TCR_EL1_TBI0
> +#define TCR_TBI1		TCR_EL1_TBI1
> +#define TCR_HA			TCR_EL1_HA
> +#define TCR_HD			TCR_EL1_HD
> +#define TCR_HPD0		TCR_EL1_HPD0
> +#define TCR_HPD1		TCR_EL1_HPD1
> +#define TCR_TBID0		TCR_EL1_TBID0
> +#define TCR_TBID1		TCR_EL1_TBID1
> +#define TCR_NFD0		TCR_EL1_NFD0
> +#define TCR_NFD1		TCR_EL1_NFD1
> +#define TCR_E0PD0		TCR_EL1_E0PD0
> +#define TCR_E0PD1		TCR_EL1_E0PD1
> +#define TCR_TCMA0		TCR_EL1_TCMA0
> +#define TCR_TCMA1		TCR_EL1_TCMA1
> +#define TCR_DS			TCR_EL1_DS
> +
>  /* TCR_EL2 Registers bits */
>  #define TCR_EL2_DS		(1UL << 32)
>  #define TCR_EL2_RES1		((1U << 31) | (1 << 23))
> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
> index 0dbe3b29049b..1b4ac7b23e18 100644
> --- a/arch/arm64/include/asm/mmu_context.h
> +++ b/arch/arm64/include/asm/mmu_context.h
> @@ -73,10 +73,10 @@ static inline void __cpu_set_tcr_t0sz(unsigned long t0sz)
>  {
>  	unsigned long tcr = read_sysreg(tcr_el1);
>  
> -	if ((tcr & TCR_T0SZ_MASK) == t0sz)
> +	if ((tcr & TCR_EL1_T0SZ_MASK) == t0sz)
>  		return;
>  
> -	tcr &= ~TCR_T0SZ_MASK;
> +	tcr &= ~TCR_EL1_T0SZ_MASK;
>  	tcr |= t0sz;
>  	write_sysreg(tcr, tcr_el1);
>  	isb();
> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
> index f3b77deedfa2..5059abda78d8 100644
> --- a/arch/arm64/include/asm/pgtable-hwdef.h
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> @@ -228,102 +228,8 @@
>  /*
>   * TCR flags.
>   */
> -#define TCR_T0SZ_OFFSET		0
> -#define TCR_T1SZ_OFFSET		16
> -#define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_T0SZ_OFFSET)
> -#define TCR_T1SZ(x)		((UL(64) - (x)) << TCR_T1SZ_OFFSET)
> -#define TCR_TxSZ(x)		(TCR_T0SZ(x) | TCR_T1SZ(x))
> -#define TCR_TxSZ_WIDTH		6
> -#define TCR_T0SZ_MASK		(((UL(1) << TCR_TxSZ_WIDTH) - 1) << TCR_T0SZ_OFFSET)
> -#define TCR_T1SZ_MASK		(((UL(1) << TCR_TxSZ_WIDTH) - 1) << TCR_T1SZ_OFFSET)
> -
> -#define TCR_EPD0_SHIFT		7
> -#define TCR_EPD0_MASK		(UL(1) << TCR_EPD0_SHIFT)
> -#define TCR_IRGN0_SHIFT		8
> -#define TCR_IRGN0_MASK		(UL(3) << TCR_IRGN0_SHIFT)
> -#define TCR_IRGN0_NC		(UL(0) << TCR_IRGN0_SHIFT)
> -#define TCR_IRGN0_WBWA		(UL(1) << TCR_IRGN0_SHIFT)
> -#define TCR_IRGN0_WT		(UL(2) << TCR_IRGN0_SHIFT)
> -#define TCR_IRGN0_WBnWA		(UL(3) << TCR_IRGN0_SHIFT)
> -
> -#define TCR_EPD1_SHIFT		23
> -#define TCR_EPD1_MASK		(UL(1) << TCR_EPD1_SHIFT)
> -#define TCR_IRGN1_SHIFT		24
> -#define TCR_IRGN1_MASK		(UL(3) << TCR_IRGN1_SHIFT)
> -#define TCR_IRGN1_NC		(UL(0) << TCR_IRGN1_SHIFT)
> -#define TCR_IRGN1_WBWA		(UL(1) << TCR_IRGN1_SHIFT)
> -#define TCR_IRGN1_WT		(UL(2) << TCR_IRGN1_SHIFT)
> -#define TCR_IRGN1_WBnWA		(UL(3) << TCR_IRGN1_SHIFT)
> -
> -#define TCR_IRGN_NC		(TCR_IRGN0_NC | TCR_IRGN1_NC)
> -#define TCR_IRGN_WBWA		(TCR_IRGN0_WBWA | TCR_IRGN1_WBWA)
> -#define TCR_IRGN_WT		(TCR_IRGN0_WT | TCR_IRGN1_WT)
> -#define TCR_IRGN_WBnWA		(TCR_IRGN0_WBnWA | TCR_IRGN1_WBnWA)
> -#define TCR_IRGN_MASK		(TCR_IRGN0_MASK | TCR_IRGN1_MASK)
> -
> -
> -#define TCR_ORGN0_SHIFT		10
> -#define TCR_ORGN0_MASK		(UL(3) << TCR_ORGN0_SHIFT)
> -#define TCR_ORGN0_NC		(UL(0) << TCR_ORGN0_SHIFT)
> -#define TCR_ORGN0_WBWA		(UL(1) << TCR_ORGN0_SHIFT)
> -#define TCR_ORGN0_WT		(UL(2) << TCR_ORGN0_SHIFT)
> -#define TCR_ORGN0_WBnWA		(UL(3) << TCR_ORGN0_SHIFT)
> -
> -#define TCR_ORGN1_SHIFT		26
> -#define TCR_ORGN1_MASK		(UL(3) << TCR_ORGN1_SHIFT)
> -#define TCR_ORGN1_NC		(UL(0) << TCR_ORGN1_SHIFT)
> -#define TCR_ORGN1_WBWA		(UL(1) << TCR_ORGN1_SHIFT)
> -#define TCR_ORGN1_WT		(UL(2) << TCR_ORGN1_SHIFT)
> -#define TCR_ORGN1_WBnWA		(UL(3) << TCR_ORGN1_SHIFT)
> -
> -#define TCR_ORGN_NC		(TCR_ORGN0_NC | TCR_ORGN1_NC)
> -#define TCR_ORGN_WBWA		(TCR_ORGN0_WBWA | TCR_ORGN1_WBWA)
> -#define TCR_ORGN_WT		(TCR_ORGN0_WT | TCR_ORGN1_WT)
> -#define TCR_ORGN_WBnWA		(TCR_ORGN0_WBnWA | TCR_ORGN1_WBnWA)
> -#define TCR_ORGN_MASK		(TCR_ORGN0_MASK | TCR_ORGN1_MASK)
> -
> -#define TCR_SH0_SHIFT		12
> -#define TCR_SH0_MASK		(UL(3) << TCR_SH0_SHIFT)
> -#define TCR_SH0_INNER		(UL(3) << TCR_SH0_SHIFT)
> -
> -#define TCR_SH1_SHIFT		28
> -#define TCR_SH1_MASK		(UL(3) << TCR_SH1_SHIFT)
> -#define TCR_SH1_INNER		(UL(3) << TCR_SH1_SHIFT)
> -#define TCR_SHARED		(TCR_SH0_INNER | TCR_SH1_INNER)
> -
> -#define TCR_TG0_SHIFT		14
> -#define TCR_TG0_MASK		(UL(3) << TCR_TG0_SHIFT)
> -#define TCR_TG0_4K		(UL(0) << TCR_TG0_SHIFT)
> -#define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
> -#define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
> -
> -#define TCR_TG1_SHIFT		30
> -#define TCR_TG1_MASK		(UL(3) << TCR_TG1_SHIFT)
> -#define TCR_TG1_16K		(UL(1) << TCR_TG1_SHIFT)
> -#define TCR_TG1_4K		(UL(2) << TCR_TG1_SHIFT)
> -#define TCR_TG1_64K		(UL(3) << TCR_TG1_SHIFT)
> -
> -#define TCR_IPS_SHIFT		32
> -#define TCR_IPS_MASK		(UL(7) << TCR_IPS_SHIFT)
> -#define TCR_A1			(UL(1) << 22)
> -#define TCR_ASID16		(UL(1) << 36)
> -#define TCR_TBI0		(UL(1) << 37)
> -#define TCR_TBI1		(UL(1) << 38)
> -#define TCR_HA			(UL(1) << 39)
> -#define TCR_HD			(UL(1) << 40)
> -#define TCR_HPD0_SHIFT		41
> -#define TCR_HPD0		(UL(1) << TCR_HPD0_SHIFT)
> -#define TCR_HPD1_SHIFT		42
> -#define TCR_HPD1		(UL(1) << TCR_HPD1_SHIFT)
> -#define TCR_TBID0		(UL(1) << 51)
> -#define TCR_TBID1		(UL(1) << 52)
> -#define TCR_NFD0		(UL(1) << 53)
> -#define TCR_NFD1		(UL(1) << 54)
> -#define TCR_E0PD0		(UL(1) << 55)
> -#define TCR_E0PD1		(UL(1) << 56)
> -#define TCR_TCMA0		(UL(1) << 57)
> -#define TCR_TCMA1		(UL(1) << 58)
> -#define TCR_DS			(UL(1) << 59)
> +#define TCR_T0SZ(x)		((UL(64) - (x)) << TCR_EL1_T0SZ_SHIFT)
> +#define TCR_T1SZ(x)		((UL(64) - (x)) << TCR_EL1_T1SZ_SHIFT)
>  
>  /*
>   * TTBR.
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 85dceb1c66f4..21a3d3342283 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -84,7 +84,7 @@ extern unsigned long prot_ns_shared;
>  #else
>  static inline bool __pure lpa2_is_enabled(void)
>  {
> -	return read_tcr() & TCR_DS;
> +	return read_tcr() & TCR_EL1_DS;
>  }
>  
>  #define PTE_MAYBE_SHARED	(lpa2_is_enabled() ? 0 : PTE_SHARED)
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index ef269a5a37e1..98b53e1a228e 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2065,7 +2065,7 @@ static struct cpumask dbm_cpus __read_mostly;
>  
>  static inline void __cpu_enable_hw_dbm(void)
>  {
> -	u64 tcr = read_sysreg(tcr_el1) | TCR_HD;
> +	u64 tcr = read_sysreg(tcr_el1) | TCR_EL1_HD;
>  
>  	write_sysreg(tcr, tcr_el1);
>  	isb();
> @@ -2342,7 +2342,7 @@ static bool has_generic_auth(const struct arm64_cpu_capabilities *entry,
>  static void cpu_enable_e0pd(struct arm64_cpu_capabilities const *cap)
>  {
>  	if (this_cpu_has_cap(ARM64_HAS_E0PD))
> -		sysreg_clear_set(tcr_el1, 0, TCR_E0PD1);
> +		sysreg_clear_set(tcr_el1, 0, TCR_EL1_E0PD1);
>  }
>  #endif /* CONFIG_ARM64_E0PD */
>  
> diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
> index 0f4bd7771859..3f81e0610577 100644
> --- a/arch/arm64/kernel/pi/map_kernel.c
> +++ b/arch/arm64/kernel/pi/map_kernel.c
> @@ -135,13 +135,13 @@ static void __init map_kernel(u64 kaslr_offset, u64 va_offset, int root_level)
>  static void noinline __section(".idmap.text") set_ttbr0_for_lpa2(u64 ttbr)
>  {
>  	u64 sctlr = read_sysreg(sctlr_el1);
> -	u64 tcr = read_sysreg(tcr_el1) | TCR_DS;
> +	u64 tcr = read_sysreg(tcr_el1) | TCR_EL1_DS;
>  	u64 mmfr0 = read_sysreg(id_aa64mmfr0_el1);
>  	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
>  							   ID_AA64MMFR0_EL1_PARANGE_SHIFT);
>  
> -	tcr &= ~TCR_IPS_MASK;
> -	tcr |= parange << TCR_IPS_SHIFT;
> +	tcr &= ~TCR_EL1_IPS_MASK;
> +	tcr |= parange << TCR_EL1_IPS_SHIFT;
>  
>  	asm("	msr	sctlr_el1, %0		;"
>  	    "	isb				;"
> @@ -256,7 +256,7 @@ asmlinkage void __init early_map_kernel(u64 boot_status, void *fdt)
>  	}
>  
>  	if (va_bits > VA_BITS_MIN)
> -		sysreg_clear_set(tcr_el1, TCR_T1SZ_MASK, TCR_T1SZ(va_bits));
> +		sysreg_clear_set(tcr_el1, TCR_EL1_T1SZ_MASK, TCR_T1SZ(va_bits));
>  
>  	/*
>  	 * The virtual KASLR displacement modulo 2MiB is decided by the
> diff --git a/arch/arm64/kernel/vmcore_info.c b/arch/arm64/kernel/vmcore_info.c
> index b19d5d6cb8b3..9619ece66b79 100644
> --- a/arch/arm64/kernel/vmcore_info.c
> +++ b/arch/arm64/kernel/vmcore_info.c
> @@ -14,7 +14,7 @@ static inline u64 get_tcr_el1_t1sz(void);
>  
>  static inline u64 get_tcr_el1_t1sz(void)
>  {
> -	return (read_sysreg(tcr_el1) & TCR_T1SZ_MASK) >> TCR_T1SZ_OFFSET;
> +	return (read_sysreg(tcr_el1) & TCR_EL1_T1SZ_MASK) >> TCR_EL1_T1SZ_SHIFT;
>  }
>  
>  void arch_crash_save_vmcoreinfo(void)
> diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> index 8c75965afc9e..46a1addc1465 100644
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -23,15 +23,18 @@
>  #include <asm/sysreg.h>
>  
>  #ifdef CONFIG_ARM64_64K_PAGES
> -#define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
> +#define TCR_TG_FLAGS	((TCR_EL1_TG0_64K << TCR_EL1_TG0_SHIFT) |\
> +			 (TCR_EL1_TG1_64K << TCR_EL1_TG1_SHIFT))
>  #elif defined(CONFIG_ARM64_16K_PAGES)
> -#define TCR_TG_FLAGS	TCR_TG0_16K | TCR_TG1_16K
> +#define TCR_TG_FLAGS	((TCR_EL1_TG0_16K << TCR_EL1_TG0_SHIFT) |\
> +			 (TCR_EL1_TG1_16K << TCR_EL1_TG1_SHIFT))
>  #else /* CONFIG_ARM64_4K_PAGES */
> -#define TCR_TG_FLAGS	TCR_TG0_4K | TCR_TG1_4K
> +#define TCR_TG_FLAGS	((TCR_EL1_TG0_4K << TCR_EL1_TG0_SHIFT) |\
> +			 (TCR_EL1_TG1_4K << TCR_EL1_TG1_SHIFT))
>  #endif
>  
>  #ifdef CONFIG_RANDOMIZE_BASE
> -#define TCR_KASLR_FLAGS	TCR_NFD1
> +#define TCR_KASLR_FLAGS	TCR_EL1_NFD1
>  #else
>  #define TCR_KASLR_FLAGS	0
>  #endif
> @@ -40,23 +43,30 @@
>  #define TCR_CACHE_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA
>  
>  #ifdef CONFIG_KASAN_SW_TAGS
> -#define TCR_KASAN_SW_FLAGS TCR_TBI1 | TCR_TBID1
> +#define TCR_KASAN_SW_FLAGS TCR_EL1_TBI1 | TCR_EL1_TBID1
>  #else
>  #define TCR_KASAN_SW_FLAGS 0
>  #endif
>  
>  #ifdef CONFIG_KASAN_HW_TAGS
> -#define TCR_MTE_FLAGS TCR_TCMA1 | TCR_TBI1 | TCR_TBID1
> +#define TCR_MTE_FLAGS TCR_EL1_TCMA1 | TCR_EL1_TBI1 | TCR_EL1_TBID1
>  #elif defined(CONFIG_ARM64_MTE)
>  /*
>   * The mte_zero_clear_page_tags() implementation uses DC GZVA, which relies on
>   * TBI being enabled at EL1.
>   */
> -#define TCR_MTE_FLAGS TCR_TBI1 | TCR_TBID1
> +#define TCR_MTE_FLAGS TCR_EL1_TBI1 | TCR_EL1_TBID1
>  #else
>  #define TCR_MTE_FLAGS 0
>  #endif
>  
> +#define TCR_IRGN_WBWA	((TCR_EL1_IRGN0_WBWA << TCR_EL1_IRGN0_SHIFT) |\
> +			 (TCR_EL1_IRGN1_WBWA << TCR_EL1_IRGN1_SHIFT))
> +#define TCR_ORGN_WBWA	((TCR_EL1_ORGN0_WBWA << TCR_EL1_ORGN0_SHIFT) |\
> +			 (TCR_EL1_ORGN1_WBWA << TCR_EL1_ORGN1_SHIFT))
> +#define TCR_SHARED	((TCR_EL1_SH0_INNER << TCR_EL1_SH0_SHIFT) |\
> +			 (TCR_EL1_SH1_INNER << TCR_EL1_SH1_SHIFT))
> +
>  /*
>   * Default MAIR_EL1. MT_NORMAL_TAGGED is initially mapped as Normal memory and
>   * changed during mte_cpu_setup to Normal Tagged if the system supports MTE.
> @@ -129,7 +139,7 @@ SYM_FUNC_START(cpu_do_resume)
>  
>  	/* Don't change t0sz here, mask those bits when restoring */
>  	mrs	x7, tcr_el1
> -	bfi	x8, x7, TCR_T0SZ_OFFSET, TCR_TxSZ_WIDTH
> +	bfi	x8, x7, TCR_EL1_T0SZ_SHIFT, TCR_EL1_T0SZ_WIDTH
>  
>  	msr	tcr_el1, x8
>  	msr	vbar_el1, x9
> @@ -468,8 +478,8 @@ SYM_FUNC_START(__cpu_setup)
>  	tcr2	.req	x15
>  	mov_q	mair, MAIR_EL1_SET
>  	mov_q	tcr, TCR_T0SZ(IDMAP_VA_BITS) | TCR_T1SZ(VA_BITS_MIN) | TCR_CACHE_FLAGS | \
> -		     TCR_SHARED | TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_ASID16 | \
> -		     TCR_TBI0 | TCR_A1 | TCR_KASAN_SW_FLAGS | TCR_MTE_FLAGS
> +		     TCR_SHARED | TCR_TG_FLAGS | TCR_KASLR_FLAGS | TCR_EL1_AS | \
> +		     TCR_EL1_TBI0 | TCR_EL1_A1 | TCR_KASAN_SW_FLAGS | TCR_MTE_FLAGS
>  	mov	tcr2, xzr
>  
>  	tcr_clear_errata_bits tcr, x9, x5
> @@ -479,7 +489,7 @@ SYM_FUNC_START(__cpu_setup)
>  alternative_if ARM64_HAS_VA52
>  	tcr_set_t1sz	tcr, x9
>  #ifdef CONFIG_ARM64_LPA2
> -	orr		tcr, tcr, #TCR_DS
> +	orr		tcr, tcr, #TCR_EL1_DS
>  #endif
>  alternative_else_nop_endif
>  #endif
> @@ -487,7 +497,7 @@ alternative_else_nop_endif
>  	/*
>  	 * Set the IPS bits in TCR_EL1.
>  	 */
> -	tcr_compute_pa_size tcr, #TCR_IPS_SHIFT, x5, x6
> +	tcr_compute_pa_size tcr, #TCR_EL1_IPS_SHIFT, x5, x6
>  #ifdef CONFIG_ARM64_HW_AFDBM
>  	/*
>  	 * Enable hardware update of the Access Flags bit.
> @@ -497,7 +507,7 @@ alternative_else_nop_endif
>  	mrs	x9, ID_AA64MMFR1_EL1
>  	ubfx	x9, x9, ID_AA64MMFR1_EL1_HAFDBS_SHIFT, #4
>  	cbz	x9, 1f
> -	orr	tcr, tcr, #TCR_HA		// hardware Access flag update
> +	orr	tcr, tcr, #TCR_EL1_HA		// hardware Access flag update
>  #ifdef CONFIG_ARM64_HAFT
>  	cmp	x9, ID_AA64MMFR1_EL1_HAFDBS_HAFT
>  	b.lt	1f
> diff --git a/tools/arch/arm64/include/asm/cputype.h b/tools/arch/arm64/include/asm/cputype.h
> index 139d5e87dc95..dfa12df5e290 100644
> --- a/tools/arch/arm64/include/asm/cputype.h
> +++ b/tools/arch/arm64/include/asm/cputype.h
> @@ -243,7 +243,7 @@
>  /* Fujitsu Erratum 010001 affects A64FX 1.0 and 1.1, (v0r0 and v1r0) */
>  #define MIDR_FUJITSU_ERRATUM_010001		MIDR_FUJITSU_A64FX
>  #define MIDR_FUJITSU_ERRATUM_010001_MASK	(~MIDR_CPU_VAR_REV(1, 0))
> -#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_NFD1 | TCR_NFD0)
> +#define TCR_CLEAR_FUJITSU_ERRATUM_010001	(TCR_EL1_NFD1 | TCR_EL1_NFD0)
>  
>  #ifndef __ASSEMBLY__
>  

Thanks,

Ben

