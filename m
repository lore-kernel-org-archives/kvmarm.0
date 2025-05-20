Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FDFE263F39
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 10:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747735629; cv=none; b=B5FjzOjdC9gFOcngJGwKtmBaq+kOLnhaTxDhTD3osf9Ux0/d6JUq4T8HgoV0VKskaBuqJTH/kNA0Sp9XoU/G0MnYx72VclcFckUc0d8t7/6I7IXWoB0j9yeYDTTnjvO9ty0dDtDvnTtX0vUEj1nJWdcBtMYKN4w7TeXEdp5Glpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747735629; c=relaxed/simple;
	bh=p7ppXvUJEITrZqv5fOiuolGqKTskwl2XcxcfZt4xih8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzOMoC2VwIN0ALRCjfV+tY5bEU4om5VQ2xOzUF2mS2BvTsG2kzMHi/g0nV+lhG1x4Zwk8tcHztNadHQw4Moe5TVn1A4YXOgNueH5xqkK/ZjKe4GSx/5RCZf5fGSVaDWU4gPF5bBUDHY5eImCope6s7QZ27Q1ec+J6EDYEcQ8wXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0354E1BC0;
	Tue, 20 May 2025 03:06:52 -0700 (PDT)
Received: from localhost (e132581.arm.com [10.1.196.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0246C3F6A8;
	Tue, 20 May 2025 03:07:05 -0700 (PDT)
Date: Tue, 20 May 2025 11:07:01 +0100
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
Subject: Re: [PATCH 02/10] perf: arm_spe: Support FEAT_SPEv1p4 filters
Message-ID: <20250520100701.GL412060@e132581.arm.com>
References: <20250506-james-perf-feat_spe_eft-v1-0-dd480e8e4851@linaro.org>
 <20250506-james-perf-feat_spe_eft-v1-2-dd480e8e4851@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250506-james-perf-feat_spe_eft-v1-2-dd480e8e4851@linaro.org>

On Tue, May 06, 2025 at 12:41:34PM +0100, James Clark wrote:
> FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
> remove them from the previous version's RES0 bits using
> PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
> unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.
> E.g:
> 
>   E[30], bit [30]
>   When FEAT_SPEv1p4 is _not_ implemented ...

Yes, that's the case. I reviewed the bits below one by one, and they
all look correct to me.

> FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
> switch.
> 
> Signed-off-by: James Clark <james.clark@linaro.org>

Reviewed-by: Leo Yan <leo.yan@arm.com>

> ---
>  arch/arm64/include/asm/sysreg.h | 7 +++++++
>  drivers/perf/arm_spe_pmu.c      | 5 ++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 2639d3633073..e24042e914a4 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -354,6 +354,13 @@
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
>  	}
>  }
>  
> 
> -- 
> 2.34.1
> 
