Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B86B81DDC37
	for <kvmarm@lists.linux.dev>; Thu, 12 Jun 2025 06:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749710702; cv=none; b=k3FJvoNplcyNFR5baRtUFu6CRStBunSTzmAkc7p/cYurbJBvACYWUHc/8j8gfFS0RJ8MMSSCbp/s/wZAQoYzjE8KejvZv99gxPi5BTLo3TXIVx3oKba3ULCOR/oLagQndp21UyXz5ErUP17jpWzEWER0LeXbLMKnLrY2QE5T6cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749710702; c=relaxed/simple;
	bh=rxKO1BKV4hODD1SbaLCwVicmOFDO4mKDfQbwr7D0Nvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=grSw3Up1apbebXP6w933EFPVxd0E1AbXSQOtlquhCNN/d4OqyS5X2HVeoQpkcR60NtVP9cM0Ul2KgTjO4XYcEecYWD7CTbquIKmDvddAazZQ3zCpJeLive563fyxQiLyAcC/XfmFYZsX/lfWa1xAI8B0sFnAwfvGbmip9JYn1n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 11DE014BF;
	Wed, 11 Jun 2025 23:44:40 -0700 (PDT)
Received: from [10.163.33.129] (unknown [10.163.33.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 711AB3F59E;
	Wed, 11 Jun 2025 23:44:52 -0700 (PDT)
Message-ID: <f89faeb2-1091-41af-ae06-f49bd2d4866a@arm.com>
Date: Thu, 12 Jun 2025 12:14:49 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/10] arm64: sysreg: Add new PMSFCR_EL1 fields and
 PMSDSFR_EL1 register
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
 <20250605-james-perf-feat_spe_eft-v3-1-71b0c9f98093@linaro.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250605-james-perf-feat_spe_eft-v3-1-71b0c9f98093@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/06/25 4:18 PM, James Clark wrote:
> Add new fields and register that are introduced for the features
> FEAT_SPE_EFT (extended filtering) and FEAT_SPE_FDS (data source
> filtering).
> 
> Tested-by: Leo Yan <leo.yan@arm.com>
> Signed-off-by: James Clark <james.clark@linaro.org>
> ---
>  arch/arm64/tools/sysreg | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index 8a8cf6874298..2e897d8a4040 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2859,11 +2859,20 @@ Field	0	RND
>  EndSysreg
>  
>  Sysreg	PMSFCR_EL1	3	0	9	9	4
> -Res0	63:19
> +Res0	63:53
> +Field	52	SIMDm
> +Field	51	FPm
> +Field	50	STm
> +Field	49	LDm
> +Field	48	Bm
> +Res0	47:21
> +Field	20	SIMD
> +Field	19	FP
>  Field	18	ST
>  Field	17	LD
>  Field	16	B
> -Res0	15:4
> +Res0	15:5
> +Field	4	FDS
>  Field	3	FnE
>  Field	2	FL
>  Field	1	FT
> 

These register fields checks out against ARM ARM DDI 0487 (L.b)

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
