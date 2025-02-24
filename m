Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43E3C7CF16
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 14:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740406299; cv=none; b=SRCeGyUp6s9t/v0KI3U5BtgWYSQVlmE2vJ8gn+2u8ManxQWC2rzL8i5sui7hPQG+wDIbtTLluIX7nrNzwkMrwR2nupM3SOxMYhXY/YYRgByOE8iyoACqJigU18LnVuf1cYlQ+f1E+W94Yyz3swqpzAm047sUgqjk2u06jlB3BpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740406299; c=relaxed/simple;
	bh=qbABspKHTl7q1m2eaGEAV0p55jJgAh/ssIKCRexnX58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZY3u+ckP0oczLieNNwTFhXaJ9e6SbK6ZazGSKXwu64P6VTNuQ3tqTOy7dYdNnGO10/AHHEXu37PIT8E1UH/12NZ6DILj6T2PpPR2XBWBJXFWSVAHWuafEZt9w2NdBLWJsQCbJW3e6SsW+PKyBvYeYsVBeWJnbrVq6OwT1Zau5RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E2DF1516;
	Mon, 24 Feb 2025 06:11:54 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B19513F5A1;
	Mon, 24 Feb 2025 06:11:35 -0800 (PST)
Date: Mon, 24 Feb 2025 14:11:28 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Mark Brown <robh@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 7/7] arm64/boot: Enable EL2 requirements for
 FEAT_PMUv3p9
Message-ID: <Z7x-EDH9QP7g4lC6@J2N7QTR9R3.cambridge.arm.com>
References: <20250203050828.1049370-1-anshuman.khandual@arm.com>
 <20250203050828.1049370-8-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203050828.1049370-8-anshuman.khandual@arm.com>

On Mon, Feb 03, 2025 at 10:38:28AM +0530, Anshuman Khandual wrote:
> FEAT_PMUv3p9 registers such as PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1
> access from EL1 requires appropriate EL2 fine grained trap configuration
> via FEAT_FGT2 based trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2.
> Otherwise such register accesses will result in traps into EL2.
> 
> Add a new helper __init_el2_fgt2() which initializes FEAT_FGT2 based fine
> grained trap control registers HDFGRTR2_EL2 and HDFGWTR2_EL2 (setting the
> bits nPMICNTR_EL0, nPMICFILTR_EL0 and nPMUACR_EL1) to enable access into
> PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 registers.
> 
> Also update booting.rst with SCR_EL3.FGTEn2 requirement for all FEAT_FGT2
> based registers to be accessible in EL2.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvmarm@lists.linux.dev
> Tested-by: Rob Herring (Arm) <robh@kernel.org>
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  Documentation/arch/arm64/booting.rst | 18 ++++++++++++++++++
>  arch/arm64/include/asm/el2_setup.h   | 25 +++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)

Three things to note here:

(1) I think this is missing some other necessary register configuration.

    From a quick scan, we also require MDCR_EL3.EnPM2 (bit [7]) to be
    configured, which is not described in mainline nor here. If that
    resets to 0, then EL{2,1,0} accesses to a number of registers such
    as PMUACR_EL1 may trap to EL3.

    AFAICT the boot-wrapper resets that bit to 0, so have we actually
    tested all of this with the boot-wrapper? Does TF-A set this bit?

    Are we sure we've cpatured *all* requirements for FEAT_PMUv3p9? i.e.
    is there anything else that we've missed?

(2) This is a fix for !VHE support for PMUACR and ICNTR, where the host
    may run at EL1 and consequently will be affected by fine grained
    traps.

    So this probably needs a CC stable and/or fixes tag, and backport.

(3) As there's no KVM changes, this is only safe provided that the
    registers affected by these fine grained traps are already
    unconditionally trapped by other traps when running a vCPU.

    It looks like PMICNTR_EL0, PMICFILTR_EL0, and PMUACR_EL1 are all
    trapped by MDCR_EL2.TPM, so that should work as long as we emulate
    the PMU. For direct access, FGT2 support will be a prerequisite.

Ideally, we'd have added support for FGT2 before the PMU functionality
that implicitly depends upon it. We should pay more attention to trap
controls in future.

Given (1) and (2) I think someone needs to look into this a bit more and
figure out if this needs a fixup or a respin.

Mark.

> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index cad6fdc96b98..04d97a1d5ffa 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -288,6 +288,12 @@ Before jumping into the kernel, the following conditions must be met:
>  
>      - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
>  
> +  For CPUs with the Fine Grained Traps 2 (FEAT_FGT2) extension present:
> +
> +  - If EL3 is present and the kernel is entered at EL2:
> +
> +    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
> +
>    For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
>  
>    - If EL3 is present and the kernel is entered at EL2:
> @@ -382,6 +388,18 @@ Before jumping into the kernel, the following conditions must be met:
>  
>      - SMCR_EL2.EZT0 (bit 30) must be initialised to 0b1.
>  
> +  For CPUs with the Performance Monitors Extension (FEAT_PMUv3p9):
> +
> + - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HDFGRTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
> +    - HDFGRTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
> +    - HDFGRTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
> +
> +    - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
> +    - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
> +    - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
> +
>    For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
>  
>    - If the kernel is entered at EL1 and EL2 is present:
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 25e162651750..1a0071faf57e 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -233,6 +233,30 @@
>  .Lskip_fgt_\@:
>  .endm
>  
> +.macro __init_el2_fgt2
> +	mrs	x1, id_aa64mmfr0_el1
> +	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> +	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2
> +	b.lt	.Lskip_fgt2_\@
> +
> +	mov	x0, xzr
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
> +	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
> +	b.lt	.Lskip_pmuv3p9_\@
> +
> +	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
> +	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
> +	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
> +.Lskip_pmuv3p9_\@:
> +	msr_s   SYS_HDFGRTR2_EL2, x0
> +	msr_s   SYS_HDFGWTR2_EL2, x0
> +	msr_s   SYS_HFGRTR2_EL2, xzr
> +	msr_s   SYS_HFGWTR2_EL2, xzr
> +	msr_s   SYS_HFGITR2_EL2, xzr
> +.Lskip_fgt2_\@:
> +.endm
> +
>  .macro __init_el2_gcs
>  	mrs_s	x1, SYS_ID_AA64PFR1_EL1
>  	ubfx	x1, x1, #ID_AA64PFR1_EL1_GCS_SHIFT, #4
> @@ -283,6 +307,7 @@
>  	__init_el2_nvhe_idregs
>  	__init_el2_cptr
>  	__init_el2_fgt
> +	__init_el2_fgt2
>          __init_el2_gcs
>  .endm
>  
> -- 
> 2.25.1
> 
