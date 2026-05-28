Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7743D412B;
	Thu, 28 May 2026 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779965891; cv=none; b=Jw4cu4ZevmywMm09hbk+XtRvaG+UZ3jvrp+l7jt+nyni64841gUvUljjXP/9A1pl5KG/Rnu0XcBk2v6gM83nIJ3eQ8tclEbA4NEGWlKwd3aKYh+Ef1x0E9zoR0QZrDB9P4lSBCMdJgqEFMz8/eJN/DZYYQzWU1HhA6cvLjieWb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779965891; c=relaxed/simple;
	bh=JDQKtL4IVUGpe0Zwan6l7S7qn77w7Olw9yMuVULXJTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CHv4Y02RSBhE2J+RRPeoPMIYgtoMWECgBMwSbxjxafL1agy31OZYU+jSdZgtd9YI9fNVBXTF39KH5r/yEMsp5jq7VIqi6HtCD3kOYspu+8caL0kfNCg4l5ObERWhgQfdZ6eWEQ71BhAhoT77EbNbhChIwgogMSOj/fhEWELARwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yt5eziJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yt5eziJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7C61F00A3A;
	Thu, 28 May 2026 10:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779965890;
	bh=HAvav6R5t93mPf+IsV6oM8wi/DYmL7Av8BLO8+paoBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yt5eziJjWJqM7GXD/h+c6lzlAku8RwBBV96jYEEcKlMRhjH7G85ZYwZYbQehFJXoC
	 e5t17t9T+Pqat0BJPsqkuWALIXQ8ihQ3Tf+REUVsUVljuNPq7H1Y+jX/hYLeXfCqr2
	 83GDe99jo9dNCjashkHxDyxJkdp5C1/PNHlyCCqGQ2O7SUXhZYs7jTpo/8xNAfXAVm
	 cx85YgTkpTYgYAbQuj4MZY01pW8xGgJC7YZDxXZGMv0SwfvRwkhPYaww8sYC5k5URz
	 kt68nx+4/kTiABgo4X4MxqcQumcQnqII3HAyYY8y9DGs4plkqhVR/veXimb4crheTi
	 5jZ29U4Gcugfg==
Date: Thu, 28 May 2026 11:58:05 +0100
From: Will Deacon <will@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>
Subject: Re: [PATCH v4 5/6] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Message-ID: <ahgfvfw5Yb0XLEr4@willie-the-truck>
References: <20260407-arm-debug-8-9-v4-0-a4864e69b0ea@kernel.org>
 <20260407-arm-debug-8-9-v4-5-a4864e69b0ea@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407-arm-debug-8-9-v4-5-a4864e69b0ea@kernel.org>

On Tue, Apr 07, 2026 at 09:29:47AM -0500, Rob Herring (Arm) wrote:
> From: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> Fine grained trap control for MDSELR_EL1 register needs to be configured in
> HDFGRTR2_EL2, and HDFGWTR2_EL2 registers when kernel enters at EL1, but EL2
> is also present.
> 
> MDCR_EL2.EBWE needs to be enabled for additional (beyond 16) breakpoint and
> watchpoint exceptions when kernel enters at EL1, but EL2 is also present.
> 
> While here, also update booting.rst with MDCR_EL3 and SCR_EL3 requirements.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Oliver Upton <oliver.upton@linux.dev>
> Cc: kvmarm@lists.linux.dev
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> ---
> v4:
>  - Add that the requirements only apply when there are >16
>    breakpoints/watchpoints
>  - Adapt to changes in v7.0-rc1
> ---
>  Documentation/arch/arm64/booting.rst | 13 +++++++++++++
>  arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index 13ef311dace8..00ba91bbd278 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -369,6 +369,19 @@ Before jumping into the kernel, the following conditions must be met:
>      - ZCR_EL2.LEN must be initialised to the same value for all CPUs the
>        kernel will execute on.
>  
> +  For CPUs with FEAT_Debugv8p9 extension present and >16 breakpoints or
> +  watchpoints:
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
> index 85f4c1615472..b51a280c18c0 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -174,6 +174,13 @@
>  						// to own it.
>  
>  .Lskip_trace_\@:
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
> +	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
> +	b.lt	.Lskip_dbg_v8p9_\@

Why do you need to check the id register here?

> +
> +	orr	x2, x2, #MDCR_EL2_EBWE
> +.Lskip_dbg_v8p9_\@:
>  	msr	mdcr_el2, x2			// Configure debug traps
>  .endm
>  
> @@ -438,6 +445,13 @@
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
>  
>  .Lskip_spefds_\@:
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_DebugVer_SHIFT, #4
> +	cmp	x1, #ID_AA64DFR0_EL1_DebugVer_V8P9
> +	b.lt	.Lskip_dbg_v8p9_\@
> +
> +	mov_q   x0, HDFGWTR2_EL2_nMDSELR_EL1

Doesn't this clobber the trap configuration from the previous blocks?

Will
