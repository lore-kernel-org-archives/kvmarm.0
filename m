Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DF62D
	for <kvmarm@lists.linux.dev>; Fri, 17 Nov 2023 00:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CisYhOic"
Date: Thu, 16 Nov 2023 16:23:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700180608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=crtmuj7vo4FEzbjLhHi4cvhG3nsSCjx2s+yv7BGTVKw=;
	b=CisYhOicipF4342Tk/P8oJCS4xtz0PskvT20IcTGexGI7eR9UYcJyhHBwJM8xnoT6a8fEQ
	mzZoAZM+5chYTxTjfnFT1EqION/RlaKI2Wd1AzJafJM9BSw3lQndLam52wJ+Ozymg/1HIC
	nuYqzzZdxUCmZdL+KS0LzIsgPBj+j98=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 07/12] arm64: Treat HCR_EL2.E2H as RES1 when
 ID_AA64MMFR4_EL1.E2H0 is non-zero
Message-ID: <ZVaycYt51sUWS0h+@thinky-boi>
References: <20231113174244.3026520-1-maz@kernel.org>
 <20231113174244.3026520-8-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231113174244.3026520-8-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Mon, Nov 13, 2023 at 05:42:39PM +0000, Marc Zyngier wrote:
> For CPUs that have ID_AA64MMFR4_EL1.E2H0 as non-zero, it is important
> to avoid the boot path that sets HCR_EL2.E2H=0. Fortunately, we
> already have this path to cope with fruity CPUs.
> 
> Tweak init_el2 to look at ID_AA64MMFR4_EL1.E2H0 first.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kernel/head.S | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 7b236994f0e1..5853540f7809 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -584,25 +584,34 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
>  	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
>  
>  	/*
> -	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1,
> -	 * making it impossible to start in nVHE mode. Is that
> -	 * compliant with the architecture? Absolutely not!
> +	 * Compliant CPUs advertise their VHE-onlyness with
> +	 * ID_AA64MMFR4_EL1.E2H0=0b111x. HCR_EL2.E2H can be
> +	 * RES1 in that case.
> +	 *
> +	 * Fruity CPUs seem to have HCR_EL2.E2H set to RES1, but
> +	 * don't advertise it (they predate this relaxation).
>  	 */
> +	mrs_s	x0, SYS_ID_AA64MMFR4_EL1
> +	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
> +	and	x0, x0, #0b1110
> +	cmp	x0, #0b1110
> +	b.eq	1f

Wouldn't it be more consistent with the architectural definition of
signed feature fields to just test the sign bit in this case?

Maybe like:

	ubfx	x0, x0, #ID_AA64MMFR4_EL1_E2H0_SHIFT, #ID_AA64MMFR4_EL1_E2H0_WIDTH
	tbnz	x0, #3, 1f

You'll also save 8 measly bytes of text while you're at it :)

-- 
Thanks,
Oliver
