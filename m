Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C0336D9E9
	for <kvmarm@lists.linux.dev>; Wed, 23 Sep 2026 06:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790145443; cv=none; b=k3CAaIo3rJOGh6EmARk1UAzw+zOlfHbuXxoByQoafwn2BsZxtjZnTUJgZzaGq3exDJPOHA9Crh0VtisCLgeaNntDU2zRgOmyePr90M8loYSsog3ju8neNbDltd3343wsl6dAiT+IGuMskxtJv1fDFM9bRiyib48i9y+hMpggfR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790145443; c=relaxed/simple;
	bh=o4hG7piVOUQgAGaxVWLjt4d5r0pbx4AC/Tq7g2GLnac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kTVOPi3L76WrBy/xBgo46CI88rIDVwX82gt7mor8F4wM/3XNaJ5xfiIGBAgaX+nRPGAHSSn7TpOSYYBrtR+vKoIXLBWgJ7yWt/Qmpp99P3MhVwwWF4Q1bhkX/evjJle81khfeyACiaicU5HQr3uGlCjzNpAshQdxj181tI25y10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sYX/4Ojf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sYX/4Ojf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33A5F1516;
	Tue, 22 Sep 2026 23:37:12 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0D453F86C;
	Tue, 22 Sep 2026 23:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790145435; bh=o4hG7piVOUQgAGaxVWLjt4d5r0pbx4AC/Tq7g2GLnac=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sYX/4OjfLkbaAjPqf/UqqZ4gmpM6iQcIn8+LGG5oxSljlAeunNYcNxQTa9+dW+JlT
	 PY3EsuxYwFI2XfdpFU8OXUB6HdSxRMe/jaG93jLLZtSa1LP61xzJf2NCOacuiFpdwM
	 tDjnTuDPs+OrZqibBW6yS1Eh2kGE7u6la5KDo2xU=
Date: Wed, 23 Sep 2026 12:07:12 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh@kernel.org>, 
	James Clark <james.clark@linaro.org>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] arm64/boot: Disable trapping of PMZR_EL0 writes to EL2
Message-ID: <x2yybbtclm2lv6shjrootdf466tsnxqrpvtd3s75jcxrlrv6hi@7swnsdxykxdc>
References: <20260922181430.3532371-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922181430.3532371-1-fuad.tabba@linux.dev>

On Tue, Sep 22, 2026 at 07:14:30PM +0100, Fuad Tabba wrote:
> __init_el2_fgt2() writes one mask to both HDFGRTR2_EL2 and HDFGWTR2_EL2.
> PMZR_EL0 is write-only, so its trap bit, nPMZR_EL0, exists only in
> HDFGWTR2_EL2 and is therefore never set: a PMZR_EL0 write from the host
> traps to EL2, where the nVHE hypervisor has no handler and BUG()s. The
> kernel never writes PMZR_EL0, but kernel.perf_user_access=1 has the PMU
> driver set PMUSERENR_EL0.UEN for a task with a user-read event, so a
> write from EL0 reaches the trap and takes the host down without a panic
> message.
> 
> Accumulate the HDFGWTR2_EL2 bits separately, as __init_el2_fgt() already
> does for HDFGWTR_EL2, and set nPMZR_EL0 with the other FEAT_PMUv3p9
> bits.
> 
> Fixes: 858c7bfcb35e1 ("arm64/boot: Enable EL2 requirements for FEAT_PMUv3p9")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> Based on Linux 7.3-rc4 (93f51579e7df2).
> 
>  Documentation/arch/arm64/booting.rst | 1 +
>  arch/arm64/include/asm/el2_setup.h   | 9 ++++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index 13ef311dace83..3fea4b14ef7c2 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -465,6 +465,7 @@ Before jumping into the kernel, the following conditions must be met:
>      - HDFGWTR2_EL2.nPMICNTR_EL0 (bit 2) must be initialised to 0b1.
>      - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>      - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
> +    - HDFGWTR2_EL2.nPMZR_EL0 (bit 21) must be initialised to 0b1.
>  
>    For CPUs with SPE data source filtering (FEAT_SPE_FDS):
>  
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index aa8ec9df80243..87560d8b254e6 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -418,6 +418,7 @@
>  	b.lt	.Lskip_fgt2_\@
>  
>  	mov	x0, xzr
> +	mov	x2, xzr
>  	mrs	x1, id_aa64dfr0_el1
>  	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMUVer_SHIFT, #4
>  	cmp	x1, #ID_AA64DFR0_EL1_PMUVer_V3P9
> @@ -426,6 +427,11 @@
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMICNTR_EL0
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMICNTR_EL0
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMICFILTR_EL0
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMUACR_EL1
> +	/* PMZR_EL0 is write-only, so it has no read trap to disable */
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMZR_EL0
>  .Lskip_pmuv3p9_\@:
>  	/* If SPE is implemented, */
>  	__spe_vers_imp .Lskip_spefds_\@, ID_AA64DFR0_EL1_PMSVer_IMP, x1
> @@ -436,10 +442,11 @@
>  	cbz	x1, .Lskip_spefds_\@
>  	/* disable traps of PMSDSFR to EL2. */
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
> +	orr	x2, x2, #HDFGWTR2_EL2_nPMSDSFR_EL1
>  
>  .Lskip_spefds_\@:
>  	msr_s   SYS_HDFGRTR2_EL2, x0
> -	msr_s   SYS_HDFGWTR2_EL2, x0
> +	msr_s   SYS_HDFGWTR2_EL2, x2
>  	msr_s   SYS_HFGRTR2_EL2, xzr
>  	msr_s   SYS_HFGWTR2_EL2, xzr
>  	msr_s   SYS_HFGITR2_EL2, xzr
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
> -- 
> 2.39.5
> 
