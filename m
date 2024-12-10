Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0011A1C5F30;
	Tue, 10 Dec 2024 16:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733848911; cv=none; b=uWMUfwqClSj7bi1xtYDq6P7JuUGTrJmGQWUvTRtOhJ+AGe44hwqh1nP6VWmc9UCDZ23bP8r1vLkfv74NFoZ/QDs/bHRlsB8QKhXeucg0bY/PP1c9S2FUdRL4WKdxJhPRITYij/kBoMRVHidk5OE3OuCQXoguNYfFJRaEEVPrEIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733848911; c=relaxed/simple;
	bh=xaA23xB16z/5D+tNHd073yTElA75DnnIwElqjGk2tNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eL+cdPSbpUa97NxcyXIWzDb711YOn6SoblPYqnO36+MrGl4Qrm7GCL8yW9XFG4B5Gl693Bzzo1kpUxlijx3KvJSf+ikG6NTEf2iu4EcrdtdACUh+o1LrVjfYzGwtWz21jBrZ48Im7+3TAGxuzL+uGWK52yaQoIrBLsOXq8vxTGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GITZ7eJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GITZ7eJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D716C4CED6;
	Tue, 10 Dec 2024 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733848910;
	bh=xaA23xB16z/5D+tNHd073yTElA75DnnIwElqjGk2tNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GITZ7eJpcEZSY5m72sNsQhL6soXf+boRvXJVnxzGeJDi6RRIB5aBNRe46mdySblN0
	 N4jZXZk21kCMZ9dOZRGYOghk4n8ZZbDD0HtMffn5aj5X3jvdzEbecK3j9Qlnatd9xl
	 Q0QRYGVFeFebnrC8lU07p9YtawyXrpQS/f1AXZhTCJoiqfs5zkvUSDvezrMGh4DSZT
	 1Wv2IVYaNlKKZQH6QoYqyGxZq7lj5M9+GXtkcYnnBvNu0CM3L9+09G4H6e7B9qOFJu
	 aAIc4JulW9babXWjiqksRWYyd1yCLlxjY+ucD+qJTWmwh8iZwEUmfE7q8Ij77FLTVC
	 VukvPPeSrbsWA==
Date: Tue, 10 Dec 2024 16:41:44 +0000
From: Will Deacon <will@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH V2 5/7] arm64/cpufeature: Add field details for
 ID_AA64DFR1_EL1 register
Message-ID: <20241210164144.GA16039@willie-the-truck>
References: <20241028053426.2486633-1-anshuman.khandual@arm.com>
 <20241028053426.2486633-6-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028053426.2486633-6-anshuman.khandual@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Oct 28, 2024 at 11:04:24AM +0530, Anshuman Khandual wrote:
> This adds required field details for ID_AA64DFR1_EL1, and also drops dummy
> ftr_raz[] array which is now redundant. These register fields will be used
> to enable increased breakpoint and watchpoint registers via FEAT_Debugv8p9
> later.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> cc: Mark Brown <broonie@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/kernel/cpufeature.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 718728a85430..bd4d85f5dd92 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -530,6 +530,21 @@ static const struct arm64_ftr_bits ftr_id_aa64dfr0[] = {
>  	ARM64_FTR_END,
>  };
>  
> +static const struct arm64_ftr_bits ftr_id_aa64dfr1[] = {
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABL_CMPs_SHIFT, 8, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_DPFZS_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_EBEP_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ITE_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_ABLE_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_PMICNTR_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SPMU_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_CTX_CMPs_SHIFT, 8, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_WRPs_SHIFT, 8, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_BRPs_SHIFT, 8, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64DFR1_EL1_SYSPMUID_SHIFT, 8, 0),
> +	ARM64_FTR_END,
> +};

I think I mentioned this on an earlier series, but it would be useful to
see some justification in the commit message as to why some of these
features are considered STRICT vs NONSTRICT and why LOWER_SAFE is
preferred over EXACT.

For example, why is EBEP strict whereas other PMU-related fields aren't?
Why is the CTX_CMPs field treated differently to the same field in DFR0?

I'm not saying the above table is wrong, it just looks arbitrary without
the justification.

Will
