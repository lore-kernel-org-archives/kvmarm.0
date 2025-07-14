Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF41991B6;
	Mon, 14 Jul 2025 13:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752501306; cv=none; b=lxHShbplYM6ZVVcGaep8Rx347Y6ZjWA3ABQ3Lmxv9enP3yeVz1fiDuO+wIM7JNDvPYa0atVi7Ja4I53IfhZUGuQcVera0aXyegssWLRxmirJwVg/nM6OcpN3NsT2Twaxefztnq9ToaB2mLWOUnA/lAlB/lXkirts/a/OdXvIKX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752501306; c=relaxed/simple;
	bh=SsDJZedGWgEi2BKmb66mOY5op0SJ42iRGSbd4YnIV8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IcJig9k+mB8wIoitspc7LGvaCw1809a7lPce80c6texXct1lOEP9YGtR1IgE5vsHp//F/qnfwOkNeVW42TSTMiBstfmq8GYzZ5qV9RUnNgYHPTCcvzAyB0PW4hkFYPc8BsqdyxZR9YtbeBpqROaS8Z4j3JFYB/uL1Cld/Ym8ErY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kdl3S+vL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kdl3S+vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6438C4CEED;
	Mon, 14 Jul 2025 13:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752501305;
	bh=SsDJZedGWgEi2BKmb66mOY5op0SJ42iRGSbd4YnIV8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kdl3S+vLRtZWBuqnyVvLDBGEiSQ8tPChA9ba9F6FokLDS+mmIPv17jkqYGxc7Qx2B
	 cD7S5UlGpnMsdqM0tkC/edGc2W+EBHd3o1Tw4nM4WFrM64PxIewSARZPHleeTtIUp5
	 1h1qC7duFHHetvOrGA1YcArcNWi4AJKfltmgQXcJkSkHibFhwUDdZoufD43GwEhYaN
	 sOVLKO4DanJ+LB+KnRbIPEl6YxXWXwdqB446mBP8IST/mMcHYjT2QBJLkQ7ubB40yn
	 hUbfva7GkltBHybjFJhHFvJagzFIbIm5JYxkbzic5uzE/JdgFQ3UgYObJqN4qCXr7Y
	 rjVxp5L6kZnyA==
Date: Mon, 14 Jul 2025 14:54:58 +0100
From: Will Deacon <will@kernel.org>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 04/10] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Message-ID: <aHUMMk9JUdK6luLN@willie-the-truck>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-4-71b0c9f98093@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-4-71b0c9f98093@linaro.org>

On Thu, Jun 05, 2025 at 11:49:02AM +0100, James Clark wrote:
> SPE data source filtering (optional from Armv8.8) requires that traps to
> the filter register PMSDSFR be disabled. Document the requirements and
> disable the traps if the feature is present.
> 
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  Documentation/arch/arm64/booting.rst | 11 +++++++++++
>  arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index dee7b6de864f..abd75085a239 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
>      - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>      - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>  
> +  For CPUs with SPE data source filtering (FEAT_SPE_FDS):
> +
> +  - If EL3 is present:
> +
> +    - MDCR_EL3.EnPMS3 (bit 42) must be initialised to 0b1.
> +
> +  - If the kernel is entered at EL1 and EL2 is present:
> +
> +    - HDFGRTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
> +    - HDFGWTR2_EL2.nPMSDSFR_EL1 (bit 19) must be initialised to 0b1.
> +
>    For CPUs with Memory Copy and Memory Set instructions (FEAT_MOPS):
>  
>    - If the kernel is entered at EL1 and EL2 is present:
> diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
> index 1e7c7475e43f..02b4a7fc016e 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -279,6 +279,20 @@
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>  .Lskip_pmuv3p9_\@:
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
> +	/* If SPE is implemented, */
> +	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
> +	b.lt	.Lskip_spefds_\@
> +	/* we can read PMSIDR and */
> +	mrs_s	x1, SYS_PMSIDR_EL1
> +	and	x1, x1,  #PMSIDR_EL1_FDS
> +	/* if FEAT_SPE_FDS is implemented, */
> +	cbz	x1, .Lskip_spefds_\@
> +	/* disable traps to PMSDSFR. */
> +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1

Why is this being done here rather than alongside the existing SPE
configuration of HDFGRTR_EL2 and HDFGWTR_EL2 near the start of
__init_el2_fgt?

Will
