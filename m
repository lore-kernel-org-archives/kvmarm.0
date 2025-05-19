Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DB026A1B9;
	Mon, 19 May 2025 14:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747663642; cv=none; b=o9k8CJ1Bl65za1Zvevh6JvieuhyxnLCsXVEMDktoXXX9rsoGGpk3vQ7j+ufXbElnm5dvmZwAjD3DGs5q4jFLRZLkJPnSUHhBCal545TXZrAS2PJwA+puPIqqTG3iU+++eMO3QQG8VReL35gecRLC9Qcmy+wSzEQJWMlaJlgZzpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747663642; c=relaxed/simple;
	bh=Vjxx3sdINLSP5xcLk8gOYpfc7PhkgV2RnCzn4FnV044=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqdrYJ2xt/pRklAdAjPrvHq9ILZgkdPZsa6u4Vwy4mI1KqjzetIQq3FXsDB7bQyakdQ/OHoSoZgJ8TcQJVGd6WYdY8PjZ8EeWtu0iN4Ug+TAAF5MjO5nSrCKUR01mbseVvYOSONg3uNN/TQmoXFimjQP6fLR0oAX1wRUTznayDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUGyJqZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUGyJqZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EC2C4CEE4;
	Mon, 19 May 2025 14:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747663641;
	bh=Vjxx3sdINLSP5xcLk8gOYpfc7PhkgV2RnCzn4FnV044=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OUGyJqZBxfE0T2+hgIza/5xrQaClypfGHZhlPS1OYpQeM8FkeJOsiGDVJqL52nuf4
	 yYhKAwzAS7Tf31lG5xoLcEgQRssYWn/b0k8H5zsT96akuXDLsx0FNB67Wp/tujIhYg
	 Ifak/vE8mTwOLZSLDJtGDHbKbWJ8CN23U+zQNrOxnkQPym0MxrkldTS6iHxQ1poH9e
	 SbKan18lTHozANPl1Gg2U+bCVFx1oHv0KEEhbb4C3hfCqAi6hOMCm77yMnGrqJqJ8r
	 ZP3eTjXHstTzFVTU6Lc4olp0eh9QxVMCJ1Uq55V3qLLxT9Ca2CYoqXs1YOrjmDEI69
	 bJX2rLrdgnXlQ==
Date: Mon, 19 May 2025 15:07:15 +0100
From: Will Deacon <will@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v21 2/4] arm64: Handle BRBE booting requirements
Message-ID: <20250519140713.GA16991@willie-the-truck>
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
 <20250407-arm-brbe-v19-v21-2-ff187ff6c928@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250407-arm-brbe-v19-v21-2-ff187ff6c928@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Apr 07, 2025 at 12:41:31PM -0500, Rob Herring (Arm) wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> To use the Branch Record Buffer Extension (BRBE), some configuration is
> necessary at EL3 and EL2. This patch documents the requirements and adds
> the initial EL2 setup code, which largely consists of configuring the
> fine-grained traps and initializing a couple of BRBE control registers.
> 
> Before this patch, __init_el2_fgt() would initialize HDFGRTR_EL2 and
> HDFGWTR_EL2 with the same value, relying on the read/write trap controls
> for a register occupying the same bit position in either register. The
> 'nBRBIDR' trap control only exists in bit 59 of HDFGRTR_EL2, while bit
> 59 of HDFGWTR_EL2 is RES0, and so this assumption no longer holds.
> 
> To handle HDFGRTR_EL2 and HDFGWTR_EL2 having (slightly) different bit
> layouts, __init_el2_fgt() is changed to accumulate the HDFGRTR_EL2 and
> HDFGWTR_EL2 control bits separately. While making this change the
> open-coded value (1 << 62) is replaced with
> HDFG{R,W}TR_EL2_nPMSNEVFR_EL1_MASK.
> 
> The BRBCR_EL1 and BRBCR_EL2 registers are unusual and require special
> initialisation: even though they are subject to E2H renaming, both have
> an effect regardless of HCR_EL2.TGE, even when running at EL2, and
> consequently both need to be initialised. This is handled in
> __init_el2_brbe() with a comment to explain the situation.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> [Mark: rewrite commit message, fix typo in comment]
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
> Tested-by: James Clark <james.clark@linaro.org>
> ---
> v20:
>  - Document that MDCR_EL3.SBRBE can be 0b01 also
>  - Fix "HDFGWTR_EL2 is RES0" in commit msg
> ---
>  Documentation/arch/arm64/booting.rst | 21 +++++++++
>  arch/arm64/include/asm/el2_setup.h   | 86 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 104 insertions(+), 3 deletions(-)

It would be good to have an Ack from the kvm/arm64 side on this, but in
the meantime I've left some comments inline.

> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index dee7b6de864f..a627c1e0e4a0 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -358,6 +358,27 @@ Before jumping into the kernel, the following conditions must be met:
>  
>      - HWFGWTR_EL2.nSMPRI_EL1 (bit 54) must be initialised to 0b01.
>  
> +  For CPUs with feature Branch Record Buffer Extension (FEAT_BRBE):

This doesn't make sense ^^^

> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index ebceaae3c749..e7fcba1e7d8e 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -189,6 +189,39 @@
>  .Lskip_set_cptr_\@:
>  .endm
>  
> +/*
> + * Configure BRBE to permit recording cycle counts and branch mispredicts.
> + *
> + * At any EL, to record cycle counts BRBE requires that both BRBCR_EL2.CC=1 and
> + * BRBCR_EL1.CC=1.
> + *
> + * At any EL, to record branch mispredicts BRBE requires that both
> + * BRBCR_EL2.MPRED=1 and BRBCR_EL1.MPRED=1.
> + *
> + * When HCR_EL2.E2H=1, the BRBCR_EL1 encoding is redirected to BRBCR_EL2, but
> + * the {CC,MPRED} bits in the real BRBCR_EL1 register still apply.
> + *
> + * Set {CC,MPRED} in both BRBCR_EL2 and BRBCR_EL1 so that at runtime we only
> + * need to enable/disable these in BRBCR_EL1 regardless of whether the kernel
> + * ends up executing in EL1 or EL2.
> + */
> +.macro __init_el2_brbe
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +	cbz	x1, .Lskip_brbe_\@
> +
> +	mov_q	x0, BRBCR_ELx_CC | BRBCR_ELx_MPRED
> +	msr_s	SYS_BRBCR_EL2, x0
> +
> +	__check_hvhe .Lset_brbe_nvhe_\@, x1
> +	msr_s	SYS_BRBCR_EL12, x0	// VHE
> +	b	.Lskip_brbe_\@
> +
> +.Lset_brbe_nvhe_\@:
> +	msr_s	SYS_BRBCR_EL1, x0	// NVHE
> +.Lskip_brbe_\@:

Why do we have to poke BRBCR_EL12/BRBCR_EL1 here rather than in the BRBE
driver code?

> +.endm
> +
>  /* Disable any fine grained traps */
>  .macro __init_el2_fgt
>  	mrs	x1, id_aa64mmfr0_el1
> @@ -196,16 +229,48 @@
>  	cbz	x1, .Lskip_fgt_\@
>  
>  	mov	x0, xzr
> +	mov	x2, xzr
>  	mrs	x1, id_aa64dfr0_el1
>  	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
>  	cmp	x1, #3
>  	b.lt	.Lskip_spe_fgt_\@
> +
>  	/* Disable PMSNEVFR_EL1 read and write traps */
> -	orr	x0, x0, #(1 << 62)
> +	orr	x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
> +	orr	x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK
>  
>  .Lskip_spe_fgt_\@:
> +#ifdef CONFIG_ARM64_BRBE

Why is this gated on CONFIG_ARM64_BRBE?

> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +	cbz	x1, .Lskip_brbe_reg_fgt_\@
> +
> +	/*
> +	 * Disable read traps for the following registers
> +	 *
> +	 * [BRBSRC|BRBTGT|RBINF]_EL1
> +	 * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
> +	 */
> +	orr	x0, x0, #HDFGRTR_EL2_nBRBDATA_MASK
> +
> +	/*
> +	 * Disable write traps for the following registers
> +	 *
> +	 * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
> +	 */
> +	orr	x2, x2, #HDFGWTR_EL2_nBRBDATA_MASK
> +
> +	/* Disable read and write traps for [BRBCR|BRBFCR]_EL1 */
> +	orr	x0, x0, #HDFGRTR_EL2_nBRBCTL_MASK
> +	orr	x2, x2, #HDFGWTR_EL2_nBRBCTL_MASK
> +
> +	/* Disable read traps for BRBIDR_EL1 */
> +	orr	x0, x0, #HDFGRTR_EL2_nBRBIDR_MASK
> +
> +.Lskip_brbe_reg_fgt_\@:

I think this label should become .Lset_debug_fgt_\@:. That way, we have
a clear point at which we're done with HDFG*TR_EL2. We can zero x0 and
x2 and from then on we can focus on HFG*TR + HFGITR.

nit: the existing .Lskip_debug_fgt_\@ label looks to be misnamed -- it
should probably be .Lskip_sme_fgt_\@ ?

> +#endif /* CONFIG_ARM64_BRBE */
>  	msr_s	SYS_HDFGRTR_EL2, x0
> -	msr_s	SYS_HDFGWTR_EL2, x0
> +	msr_s	SYS_HDFGWTR_EL2, x2

nit: It would be cleaner to use x0/x1 for the pair of trap registers
but I can see that would be a more invasive change.

>  	mov	x0, xzr
>  	mrs	x1, id_aa64pfr1_el1
> @@ -246,7 +311,21 @@
>  .Lset_fgt_\@:
>  	msr_s	SYS_HFGRTR_EL2, x0
>  	msr_s	SYS_HFGWTR_EL2, x0
> -	msr_s	SYS_HFGITR_EL2, xzr
> +	mov	x0, xzr
> +#ifdef CONFIG_ARM64_BRBE
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +	cbz	x1, .Lskip_brbe_insn_fgt_\@

It would probably scale better if we unconditionally stick x2 in
HFGITR_EL2 and zero that register in '.Lset_debug_fgt_\@'. We still have
two checks for BRBE, but at least '.Lset_fgt_\@' could just stick to
writing the registers.

Will
