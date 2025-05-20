Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E34026738B
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 11:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747739098; cv=none; b=IR/7H0Zm1ljUdSXQC+SH6BSNCReCJzZ/u50foZK+0EW5NaLB2t3u/0SpjlESbUmqMEpX8KUJDVI/519HzZWMnB5dro+PNtjqjbFKD7t7QnY4P0zSOrGMMOJTfVFKHadhuqgVn7FpmPZ3pUKXx9fGY2ES40WVbDMxut8bK5n7dzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747739098; c=relaxed/simple;
	bh=v9wMhG1tbcMgzdvcVcBK6f1E05JBFTb3Aj60AGJruF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EHc4K2FwWbnBJRopptGEvPnEXFoKuJW5nkFfO38XM5xW+nH+zQfLzjh0azXP3iS2fs0vMHqJ5gaS1FT6qUcYXshdJd1trARDASB9tvbsPD/Ge9BFprtVxsygxsDjmnpW8wcDCy9VKPZGQeIOSSy/11NFedIdt8ZR1Dbp3DXlQBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 387571516;
	Tue, 20 May 2025 04:04:42 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 397943F6A8;
	Tue, 20 May 2025 04:04:55 -0700 (PDT)
Date: Tue, 20 May 2025 12:04:50 +0100
From: Leo Yan <leo.yan@arm.com>
To: James Clark <james.clark@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH 04/10] arm64/boot: Enable EL2 requirements for
 SPE_FEAT_FDS
Message-ID: <20250520110450.GN412060@e132581.arm.com>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-4-dd480e8e4851@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-4-dd480e8e4851@linaro.org>

On Tue, May 06, 2025 at 12:41:36PM +0100, James Clark wrote:
> SPE data source filtering (optional from Armv8.8) requires that traps to
> the filter register PMSDSFR be disabled. Document the requirements and
> disable the traps if the feature is present.
> 
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  Documentation/arch/arm64/booting.rst | 11 +++++++++++
>  arch/arm64/include/asm/el2_setup.h   | 14 ++++++++++++++
>  2 files changed, 25 insertions(+)
> 
> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
> index dee7b6de864f..8da6801da9a0 100644
> --- a/Documentation/arch/arm64/booting.rst
> +++ b/Documentation/arch/arm64/booting.rst
> @@ -404,6 +404,17 @@ Before jumping into the kernel, the following conditions must be met:
>      - HDFGWTR2_EL2.nPMICFILTR_EL0 (bit 3) must be initialised to 0b1.
>      - HDFGWTR2_EL2.nPMUACR_EL1 (bit 4) must be initialised to 0b1.
>  
> +  For CPUs with SPE data source filtering (SPE_FEAT_FDS):

For alignment with Arm ARM:

s/SPE_FEAT_FDS/FEAT_SPE_FDS

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
> index ebceaae3c749..155b45092f5e 100644
> --- a/arch/arm64/include/asm/el2_setup.h
> +++ b/arch/arm64/include/asm/el2_setup.h
> @@ -275,6 +275,20 @@
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMICFILTR_EL0
>  	orr	x0, x0, #HDFGRTR2_EL2_nPMUACR_EL1
>  .Lskip_pmuv3p9_\@:
> +	mrs	x1, id_aa64dfr0_el1
> +	ubfx	x1, x1, #ID_AA64DFR0_EL1_PMSVer_SHIFT, #4
> +	/* If SPE is implemented, we can read PMSIDR and */
> +	cmp	x1, #ID_AA64DFR0_EL1_PMSVer_IMP
> +	b.lt	.Lskip_spefds_\@
> +
> +	mrs_s	x1, SYS_PMSIDR_EL1
> +	and	x1, x1, PMSIDR_EL1_FDS_SHIFT

Should be:

        and     x1, x1, #(1 << PMSIDR_EL1_FDS_SHIFT)

> +	/* if FEAT_SPE_FDS is implemented, */
> +	cbz	x1, .Lskip_spefds_\@
> +	/* disable traps to PMSDSFR. */
> +	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
> +
> +.Lskip_spefds_\@:
>  	msr_s   SYS_HDFGRTR2_EL2, x0
>  	msr_s   SYS_HDFGWTR2_EL2, x0
>  	msr_s   SYS_HFGRTR2_EL2, xzr
> 
> -- 
> 2.34.1
> 
