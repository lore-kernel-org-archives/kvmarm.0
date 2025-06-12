Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46FA91F5435
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 07:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749713740; cv=none; b=DVBV2CRdtA3Sjx72l8wQ1nlYj2YLyx7hMVqbJjmjo/733/PbenOFmw5hchckEBuyng8fj0sDG/xms4IWGjlKd/VettuGMfYdvPss2PVwtFZEeuTTe1UATUEmxSHiWw4KZjLnjAfJNceEdxvrczLob4GHizGa7WbeFnYjBnZ0JEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749713740; c=relaxed/simple;
	bh=KCX0a7J/dQCLi8OUq7jTcNS7abTSEHutYT5eX0F9dO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cEcHg/38BMwl/hN7FyAvfDf2OxdDR2eLO4+31eVWFy23nvk5Kk4P3VrWtgv9vO6cugOlfX63hT7p9emdAjSbbOM1aO9/H6HtPFTPZ+8IkjoYJt4x48nSDFPTAgYpe/k1+vLFEHXEYgSa4zCqSlg6KD2xShy2R8m9hmjPwW9KAMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B280F1595;
	Thu, 12 Jun 2025 00:35:17 -0700 (PDT)
Received: from [10.163.33.129] (unknown [10.163.33.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F4223F66E;
	Thu, 12 Jun 2025 00:35:29 -0700 (PDT)
Message-ID: <10f63976-afa7-4e1c-bec1-d9f2447d9c13@arm.com>
Date: Thu, 12 Jun 2025 13:05:27 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] perf: arm_spe: Support FEAT_SPEv1p4 filters
To: James Clark <james.clark@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, leo.yan@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org,
 kvmarm@lists.linux.dev
References: <20250605-james-perf-feat_spe_eft-v3-0-71b0c9f98093@linaro.org>
 <20250605-james-perf-feat_spe_eft-v3-2-71b0c9f98093@linaro.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-2-71b0c9f98093@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/06/25 4:19 PM, James Clark wrote:
> FEAT_SPEv1p4 (optional from Armv8.8) adds some new filter bits, so
> remove them from the previous version's RES0 bits using
> PMSEVFR_EL1_RES0_V1P4_EXCL. It also makes some previously available bits
> unavailable again, so add those back using PMSEVFR_EL1_RES0_V1P4_INCL.

Just wondering - why cannot all the new applicable filter bits be added
explicitly for PMSEVFR_EL1_RES0_V1P4 without using exclude and include
intermediaries.

> E.g:
> 
>   E[30], bit [30]
>   When FEAT_SPEv1p4 is _not_ implemented ...
> 
> FEAT_SPE_V1P3 has the same filters as V1P2 so explicitly add it to the
> switch.
A small nit - should FEAT_SPE_V1P3 addition be done in a previous patch
as it is an already existing thing ?

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
> +	(GENMASK_ULL(31, 26))> +#define PMSEVFR_EL1_RES0_V1P4	\
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




