Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC061D63C6;
	Mon, 16 Dec 2024 23:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734392579; cv=none; b=gNCCsDByrbNzCuDw2KtKBQk+teAJB0KXI4KfXUxNMC8EvsY8DHT/aNYUKHTvxqcFHw+Cjm9BjHuiC4yMJ7RHaQ45oWr2vaLJFRZ6MwbCWOhFvDaRE/InSrPcIkiRqfahWruhtgN6HsM+SwSKBONm30UOC5Y6IkUb9YMu1AW/N00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734392579; c=relaxed/simple;
	bh=l9/IM5DK3ADr42QtgwUNbWJj+tcvKoSHuW74nZOhIOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ifro6YwNrQrj/3wosEvVpXGJDUNQe63k2QgCUXtSAkmuQbSMBlakQ6BN76N0PbzVDdudFEGepkyeAUq5zf9HxkHYHamisH/FIABUP4cxfRKWfKamLMnajAQYr6SUPIdhAkncF72hI1F+OiBbcbN1XPG5qx+2daIkfnKyemr5Z9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TeAKWYMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TeAKWYMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DA8C4CED3;
	Mon, 16 Dec 2024 23:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734392579;
	bh=l9/IM5DK3ADr42QtgwUNbWJj+tcvKoSHuW74nZOhIOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TeAKWYMtgpjXG7dc85ISU9j6nRO40mbDGB1um+uayjQaSRprGvfN/g87iXczdu+Xy
	 79rS7XMZWnhry/ibvEwXJpTb0i52jo3YXnv5JUCuDV4hAH98advS6apIGDzsVBekqG
	 8GexjslubEflXux3UFQmuEPBOr0Y5fOx4KbQXGUIbj+vl8c7mM5we3Rh3l1bzdqdde
	 a0ICMdEVut4JWUJyGQnIssv2NRb5et9DCzSIr9UPgzJc2v2NjsyA/CiutR1kGeG3bq
	 UyaWBRJhqNTw/+IYcsN0jvuoIOa8dZG0wTb3CfKqyPC/2zt1NKDiYbNg0rVGsO5sIg
	 T4oH8JltltR8Q==
Date: Mon, 16 Dec 2024 17:42:51 -0600
From: Rob Herring <robh@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH V3 6/7] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Message-ID: <20241216234251.GA629562-robh@kernel.org>
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-7-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241216040831.2448257-7-anshuman.khandual@arm.com>

On Mon, Dec 16, 2024 at 09:38:30AM +0530, Anshuman Khandual wrote:
> Fine grained trap control for MDSELR_EL1 register needs to be configured in
> HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
> is also present.

Shouldn't this be "when kernel enters at EL2, and EL3 is also present"? 
Though it is really "If EL3 set FGTEn2 and the kernel is entered in 
EL2, then FGT2 must be initialized for MDSELR_EL1."

If it was me, I'd just plagarize what was written for prior FGT 
commits for this code. :)

> This adds a new helper __init_el2_fgt2() initializing this
> new FEAT_FGT2 based fine grained registers.

"This adds" is the same as saying "This patch/commit adds" which is well 
documented to avoid. Use imperative "Add a new helper...". Though it is 
clear from the diff that is what you are doing...


> MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
> watchpoint exceptions when kernel enters at EL1, but EL2 is also present.
> This updates __init_el2_debug() as required for FEAT_Debugv8p9.
> 
> While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: kvmarm@lists.linux.dev
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Changes in V3:
> 
> - Dropped MDCR_EL3.TDA boot requirement from documentation (separate series)
> - Dropped MDCR_EL2_EBWE definition as MDCR_EL2 is now defined in tools sysreg
> 
> https://lore.kernel.org/all/20241211065425.1106683-1-anshuman.khandual@arm.com/
> 
>  Documentation/arch/arm64/booting.rst | 18 ++++++++++++++++++
>  arch/arm64/include/asm/el2_setup.h   | 26 ++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index 3278fb4bf219..054cfe1cad18 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -288,6 +288,12 @@ Before jumping into the kernel, the following conditions must be met:
>  
>      - SCR_EL3.FGTEn (bit 27) must be initialised to 0b1.
>  
> +  For CPUs with the Fine Grained Traps (FEAT_FGT2) extension present:
> +
> +  - If EL3 is present and the kernel is entered at EL2:
> +
> +    - SCR_EL3.FGTEn2 (bit 59) must be initialised to 0b1.
> +
>    For CPUs with support for HCRX_EL2 (FEAT_HCX) present:
>  
>    - If EL3 is present and the kernel is entered at EL2:
> @@ -322,6 +328,18 @@ Before jumping into the kernel, the following conditions must be met:
>      - ZCR_EL2.LEN must be initialised to the same value for all CPUs the
>        kernel will execute on.
>  
> +  For CPUs with FEAT_Debugv8p9 extension present:
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HDFGRTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> +    - HDFGWTR2_EL2.nMDSELR_EL1 (bit 5) must be initialized to 0b1
> +    - MDCR_EL2.EBWE (bit 43) must be initialized to 0b1
> +
> +  - If EL3 is present:
> +
> +    - MDCR_EL3.EBWE (bit 43) must be initialized to 0b1
> +
>    For CPUs with the Scalable Matrix Extension (FEAT_SME):
>  
>    - If EL3 is present:
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 4ef52d7245bb..2fbfe27d38b5 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -105,6 +105,13 @@
>  						// to own it.
>  
>  .Lskip_trace_\@:
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
> +	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
> +	b.lt	.Lskip_dbg_v8p9_\@
> +
> +	orr	x2, x2, #MDCR_EL2_EBWE
> +.Lskip_dbg_v8p9_\@:
>  	msr	mdcr_el2, x2			// Configure debug traps
>  .endm
>  
> @@ -244,6 +251,24 @@
>  .Lskip_gcs_\@:
>  .endm
>  
> +.macro __init_el2_fgt2
> +	mrs	x1, id_aa64mmfr0_el1
> +	ubfx	x1, x1, #ID_AA64MMFR0_EL1_FGT_SHIFT, #4
> +	cmp	x1, #ID_AA64MMFR0_EL1_FGT_FGT2

We already read this field in __init_el2_fgt, shouldn't we leverage that 
and move all this there rather than read the feature reg twice.

> +	b.lt	.Lskip_fgt2_\@
> +
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
> +	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
> +	b.lt	.Lskip_dbg_v8p9_\@
> +
> +	mov_q   x0, HDFGWTR2_EL2_nMDSELR_EL1
> +	msr_s	SYS_HDFGWTR2_EL2, x0
> +	msr_s	SYS_HDFGRTR2_EL2, x0

If Debug v8.9 is not present, but FGT2 is, shouldn't we write 0 to these 
registers? That is what we do for FGT.


I just realized I forgot to add FGT2 setup for the PMUv3.9 features I 
already added in 6.12 and 6.13. So this really needs to land sooner 
rather than later to add that. 

Rob
