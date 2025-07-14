Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA44248883;
	Mon, 14 Jul 2025 13:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752499607; cv=none; b=KtVps/esgVohwjjXylRJz+qSmRD3Th4kTTkEHtl3Jj+58IwPnBU61iSLFh6UnckdG8ZN4X8uv6VGvJ+u/+gkdes/iFDIwdfuzYi1KED4dh0k3kSYDgS9qZj/Z6oAqkNpRKOh6isWtmhYFZCwuDI6URhkFnfqqTCjN5Uq2bxtytg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752499607; c=relaxed/simple;
	bh=F0h9qPfS1IFEzVFRGzECq3FkHstZL9RWV6sL0z924sM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPJ3XLYnLY+fg9CAQsXqdvgSSOF7e0mgoi+LQ9yOR0Wd7EAVZFamsbniBMGuIGR9xPAO1tGB+G849oa2svcEoz0VaPidHFKk7zJsGImPp8WiS9v8s64FX79ujih440EGWyQERpdhYZ661EUq4800ZAHb3QSX0YV08qOedVTE3N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qw1miNrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qw1miNrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F583C4CEED;
	Mon, 14 Jul 2025 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752499607;
	bh=F0h9qPfS1IFEzVFRGzECq3FkHstZL9RWV6sL0z924sM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qw1miNrNBh0wkTZ/anfy7aGB7/NfB3gC2jbI1iY9RGdvO/jyibOW8mHgITKi/WHqR
	 9oruhqtRVHi/HQFfXtVrXuYJ8tZSUnO4DVdS2NHst28qKNxNDDzU6WK5nYKhHQJYVb
	 uowtKbBVr9JRIUntIH7+S1lUBzaDpxa9otPil7K44hjlPzCqul67n3QFd3ZGZczViR
	 U+QDSKRGKRyVd5PIhDK8FPKGWsmsA9XaPAHHpeTvU5IVhI4905xdRra3VdM/HwM3UG
	 KBpN/xFSGxOEZpAnqx2ouiyPiaYCl3uVQthDvJqmqbutytAYTgehiKk7kY17tExVdO
	 uzSg3fUKz4cAA==
Date: Mon, 14 Jul 2025 14:26:39 +0100
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
Subject: Re: [PATCH v3 02/10] perf: arm_spe: Support FEAT_SPEv1p4 filters
Message-ID: <aHUFj9lH5bZwa4Z2@willie-the-truck>
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-2-71b0c9f98093@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-2-71b0c9f98093@linaro.org>

On Thu, Jun 05, 2025 at 11:49:00AM +0100, James Clark wrote:
> FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
> remove them from the previous version's RES0 bits using
> PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
> unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.
> E.g:
> 
>   E[30], bit [30]
>   When FEAT_SPEv1p4 is _not_ implemented ...
> 
> FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
> switch.
> 
> Reviewed-by: Leo Yan <leo.yan@arm.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 7 +++++++
>  drivers/perf/arm_spe_pmu.c      | 5 ++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index f1bb0d10c39a..880090df3efc 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -358,6 +358,13 @@
>  	(PMSEVFR_EL1_RES0_IMP & ~(BIT_ULL(18) | BIT_ULL(17) | BIT_ULL(11)))
>  #define PMSEVFR_EL1_RES0_V1P2	\
>  	(PMSEVFR_EL1_RES0_V1P1 & ~BIT_ULL(6))
> +#define PMSEVFR_EL1_RES0_V1P4_EXCL \
> +	(BIT_ULL(2) | BIT_ULL(4) | GENMASK_ULL(10, 8) | GENMASK_ULL(23, 19))
> +#define PMSEVFR_EL1_RES0_V1P4_INCL \
> +	(GENMASK_ULL(31, 26))
> +#define PMSEVFR_EL1_RES0_V1P4	\
> +	(PMSEVFR_EL1_RES0_V1P4_INCL | \
> +	(PMSEVFR_EL1_RES0_V1P2 & ~PMSEVFR_EL1_RES0_V1P4_EXCL))
>  
>  /* Buffer error reporting */
>  #define PMBSR_EL1_FAULT_FSC_SHIFT	PMBSR_EL1_MSS_SHIFT
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index 3efed8839a4e..d9f6d229dce8 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -701,9 +701,12 @@ static u64 arm_spe_pmsevfr_res0(u16 pmsver)
>  	case ID_AA64DFR0_EL1_PMSVer_V1P1:
>  		return PMSEVFR_EL1_RES0_V1P1;
>  	case ID_AA64DFR0_EL1_PMSVer_V1P2:
> +	case ID_AA64DFR0_EL1_PMSVer_V1P3:
> +		return PMSEVFR_EL1_RES0_V1P2;
> +	case ID_AA64DFR0_EL1_PMSVer_V1P4:
>  	/* Return the highest version we support in default */
>  	default:
> -		return PMSEVFR_EL1_RES0_V1P2;
> +		return PMSEVFR_EL1_RES0_V1P4;

See my reply [1] to Leo about this function, but I think we should just
remove it.

Will

[1] https://lore.kernel.org/all/20250707-arm_spe_support_hitm_overhead_v1_public-v3-0-33ea82da3280@arm.com/
