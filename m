Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C024205AAF
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 12:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739362256; cv=none; b=pBfWM7yRFHL6/gtTEflTPh2UUwqUwpB1Jp3EsQo6LwhQr+FoR9dZk+aJwlZlqEO3L923P1hpggEeTAp9LO6O1Qa0j8UZNqgYLS8EJ7zXHYkxKHtREfBYByuxIyRWJihlX3zr/Lil+whGkGnzLjUYgog+miZizfQhxdeBCfGreFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739362256; c=relaxed/simple;
	bh=3cMlbShasNaTjDQlhgec8F70jWl3atG199Ep1PjuelQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBGWPAEn6zLrJZyBYK+PrY+7YG/OYAuqUtcX3IhVAAmQHiB5aWjfR5N2yY463wGRLY6ZTnKNmCKDdpeDxn00skql9wDC9lDoiOjv83KcMJHTxUTCyXdYdrivHOLiqsyakB2BprSB2JOMGhQErEDa+tC4+7Jr59aNWYbRcEVI8tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC7A1113E;
	Wed, 12 Feb 2025 04:11:12 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 399C53F58B;
	Wed, 12 Feb 2025 04:10:51 -0800 (PST)
Date: Wed, 12 Feb 2025 12:10:46 +0000
From: Leo Yan <leo.yan@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v19 09/11] arm64: Handle BRBE booting requirements
Message-ID: <20250212121046.GB235556@e132581.arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-9-1c1300802385@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250202-arm-brbe-v19-v19-9-1c1300802385@kernel.org>

On Sun, Feb 02, 2025 at 06:43:03PM -0600, Rob Herring (Arm) wrote:
> 
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
> 59 of HDFGRTR_EL2 is RES0, and so this assumption no longer holds.

s/HDFGRTR_EL2/HDFGWTR_EL2

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
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> [Mark: rewrite commit message, fix typo in comment]
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
>  Documentation/arch/arm64/booting.rst | 21 +++++++++
>  arch/arm64/include/asm/el2_setup.h   | 86 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 104 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index cad6fdc96b98..0a421757cacf 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -352,6 +352,27 @@ Before jumping into the kernel, the following conditions must be met:
> 
>      - HWFGWTR_EL2.nSMPRI_EL1 (bit 54) must be initialised to 0b01.
> 
> +  For CPUs with feature Branch Record Buffer Extension (FEAT_BRBE):
> +
> +  - If EL3 is present:
> +
> +    - MDCR_EL3.SBRBE (bits 33:32) must be initialised to 0b11.

Can MDCR_EL3.SBRBE be 0b01 ?

> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - BRBCR_EL2.CC (bit 3) must be initialised to 0b1.
> +    - BRBCR_EL2.MPRED (bit 4) must be initialised to 0b1.

Should clarify BRBCR_EL2.TS to be initialised to 0b00 ?  Arm ARM
claims the reset behaviour of the TS field is unknown value.  The
assembly code below actually has initializes the TS field as zero.

Except the above minor comments, I read the assembly code and it looks
good to me:

Reviewed-by: Leo Yan <leo.yan@arm.com>

> +
> +    - HDFGRTR_EL2.nBRBDATA (bit 61) must be initialised to 0b1.
> +    - HDFGRTR_EL2.nBRBCTL  (bit 60) must be initialised to 0b1.
> +    - HDFGRTR_EL2.nBRBIDR  (bit 59) must be initialised to 0b1.
> +
> +    - HDFGWTR_EL2.nBRBDATA (bit 61) must be initialised to 0b1.
> +    - HDFGWTR_EL2.nBRBCTL  (bit 60) must be initialised to 0b1.
> +
> +    - HFGITR_EL2.nBRBIALL (bit 56) must be initialised to 0b1.
> +    - HFGITR_EL2.nBRBINJ  (bit 55) must be initialised to 0b1.
> +
>    For CPUs with the Scalable Matrix Extension FA64 feature (FEAT_SME_FA64):
> 
>    - If EL3 is present:
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 25e162651750..bf21ce513aff 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -163,6 +163,39 @@
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
> +       mrs     x1, id_aa64dfr0_el1
> +       ubfx    x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +       cbz     x1, .Lskip_brbe_\@
> +
> +       mov_q   x0, BRBCR_ELx_CC | BRBCR_ELx_MPRED
> +       msr_s   SYS_BRBCR_EL2, x0
> +
> +       __check_hvhe .Lset_brbe_nvhe_\@, x1
> +       msr_s   SYS_BRBCR_EL12, x0      // VHE
> +       b       .Lskip_brbe_\@
> +
> +.Lset_brbe_nvhe_\@:
> +       msr_s   SYS_BRBCR_EL1, x0       // NVHE
> +.Lskip_brbe_\@:
> +.endm
> +
>  /* Disable any fine grained traps */
>  .macro __init_el2_fgt
>         mrs     x1, id_aa64mmfr0_el1
> @@ -170,16 +203,48 @@
>         cbz     x1, .Lskip_fgt_\@
> 
>         mov     x0, xzr
> +       mov     x2, xzr
>         mrs     x1, id_aa64dfr0_el1
>         ubfx    x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
>         cmp     x1, #3
>         b.lt    .Lskip_spe_fgt_\@
> +
>         /* Disable PMSNEVFR_EL1 read and write traps */
> -       orr     x0, x0, #(1 << 62)
> +       orr     x0, x0, #HDFGRTR_EL2_nPMSNEVFR_EL1_MASK
> +       orr     x2, x2, #HDFGWTR_EL2_nPMSNEVFR_EL1_MASK
> 
>  .Lskip_spe_fgt_\@:
> +#ifdef CONFIG_ARM64_BRBE
> +       mrs     x1, id_aa64dfr0_el1
> +       ubfx    x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +       cbz     x1, .Lskip_brbe_reg_fgt_\@
> +
> +       /*
> +        * Disable read traps for the following registers
> +        *
> +        * [BRBSRC|BRBTGT|RBINF]_EL1
> +        * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
> +        */
> +       orr     x0, x0, #HDFGRTR_EL2_nBRBDATA_MASK
> +
> +       /*
> +        * Disable write traps for the following registers
> +        *
> +        * [BRBSRCINJ|BRBTGTINJ|BRBINFINJ|BRBTS]_EL1
> +        */
> +       orr     x2, x2, #HDFGWTR_EL2_nBRBDATA_MASK
> +
> +       /* Disable read and write traps for [BRBCR|BRBFCR]_EL1 */
> +       orr     x0, x0, #HDFGRTR_EL2_nBRBCTL_MASK
> +       orr     x2, x2, #HDFGWTR_EL2_nBRBCTL_MASK
> +
> +       /* Disable read traps for BRBIDR_EL1 */
> +       orr     x0, x0, #HDFGRTR_EL2_nBRBIDR_MASK
> +
> +.Lskip_brbe_reg_fgt_\@:
> +#endif /* CONFIG_ARM64_BRBE */
>         msr_s   SYS_HDFGRTR_EL2, x0
> -       msr_s   SYS_HDFGWTR_EL2, x0
> +       msr_s   SYS_HDFGWTR_EL2, x2
> 
>         mov     x0, xzr
>         mrs     x1, id_aa64pfr1_el1
> @@ -220,7 +285,21 @@
>  .Lset_fgt_\@:
>         msr_s   SYS_HFGRTR_EL2, x0
>         msr_s   SYS_HFGWTR_EL2, x0
> -       msr_s   SYS_HFGITR_EL2, xzr
> +       mov     x0, xzr
> +#ifdef CONFIG_ARM64_BRBE
> +       mrs     x1, id_aa64dfr0_el1
> +       ubfx    x1, x1, #ID_AA64DFR0_EL1_BRBE_SHIFT, #4
> +       cbz     x1, .Lskip_brbe_insn_fgt_\@
> +
> +       /* Disable traps for BRBIALL instruction */
> +       orr     x0, x0, #HFGITR_EL2_nBRBIALL_MASK
> +
> +       /* Disable traps for BRBINJ instruction */
> +       orr     x0, x0, #HFGITR_EL2_nBRBINJ_MASK
> +
> +.Lskip_brbe_insn_fgt_\@:
> +#endif /* CONFIG_ARM64_BRBE */
> +       msr_s   SYS_HFGITR_EL2, x0
> 
>         mrs     x1, id_aa64pfr0_el1             // AMU traps UNDEF without AMU
>         ubfx    x1, x1, #ID_AA64PFR0_EL1_AMU_SHIFT, #4
> @@ -275,6 +354,7 @@
>         __init_el2_hcrx
>         __init_el2_timers
>         __init_el2_debug
> +       __init_el2_brbe
>         __init_el2_lor
>         __init_el2_stage2
>         __init_el2_gicv3
> 
> --
> 2.47.2
> 
> 
