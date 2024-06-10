Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A31200DB
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 09:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718011825; cv=none; b=V7xtaeQsdLhAeA/ZzNP8o8jnJ7mYKo8w0T05umRK+RNv/2LOOS+FPUo96Sr7biL+yrZKvV8gUpzRjHx4+8G5Bsiaq5RzIBesiQt0GeihUBIxJ83r1JeRM8NA8mo68HOWCb5gBqLy7SSUxG0bBdgtq4z62V3/0nMsQ0ebHOt4+b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718011825; c=relaxed/simple;
	bh=BzOFp0MDhXXy+iCPicy7Sy9fxkKj25CRtqXNxtQwAjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pOk33YiUGweHfFEbl7903f1xaMRVc4qUHFQxB+lBOFLbb492a3S4NJ/GPSySYRsTdy51UJx58BB6AckkkfBGMiN46f6JyzfyGokrNOJUQz86/ZIgmRLOdhNUAzHXFE8aFT+REPLwYJPHn7/dxqCRRLuyYpM9HhzAWKOdPlD+IXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45A4312FC;
	Mon, 10 Jun 2024 02:30:47 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 731673F73B;
	Mon, 10 Jun 2024 02:30:19 -0700 (PDT)
Date: Mon, 10 Jun 2024 10:30:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 2/9] perf: arm_v6/7_pmu: Drop non-DT probe support
Message-ID: <ZmbHpTXlSP4T0JqI@J2N7QTR9R3>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-2-c7bd2dceff3b@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-2-c7bd2dceff3b@kernel.org>

On Fri, Jun 07, 2024 at 02:31:27PM -0600, Rob Herring (Arm) wrote:
> There are no non-DT based PMU users for v6 or v7, so drop the custom
> non-DT probe table.
> 
> Note that this drops support for arm1156 PMU, but there are no arm1156
> based systems supported in the kernel.
> 
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

It might be worth adding an explciit note that xscale still has non-DT
support, and hence we need to retain the infrastructure for that.

Regardless:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  drivers/perf/arm_v6_pmu.c | 17 +----------------
>  drivers/perf/arm_v7_pmu.c | 10 +---------
>  2 files changed, 2 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/perf/arm_v6_pmu.c b/drivers/perf/arm_v6_pmu.c
> index f7593843bb85..0bb685b4bac5 100644
> --- a/drivers/perf/arm_v6_pmu.c
> +++ b/drivers/perf/arm_v6_pmu.c
> @@ -401,13 +401,6 @@ static int armv6_1136_pmu_init(struct arm_pmu *cpu_pmu)
>  	return 0;
>  }
>  
> -static int armv6_1156_pmu_init(struct arm_pmu *cpu_pmu)
> -{
> -	armv6pmu_init(cpu_pmu);
> -	cpu_pmu->name		= "armv6_1156";
> -	return 0;
> -}
> -
>  static int armv6_1176_pmu_init(struct arm_pmu *cpu_pmu)
>  {
>  	armv6pmu_init(cpu_pmu);
> @@ -421,17 +414,9 @@ static const struct of_device_id armv6_pmu_of_device_ids[] = {
>  	{ /* sentinel value */ }
>  };
>  
> -static const struct pmu_probe_info armv6_pmu_probe_table[] = {
> -	ARM_PMU_PROBE(ARM_CPU_PART_ARM1136, armv6_1136_pmu_init),
> -	ARM_PMU_PROBE(ARM_CPU_PART_ARM1156, armv6_1156_pmu_init),
> -	ARM_PMU_PROBE(ARM_CPU_PART_ARM1176, armv6_1176_pmu_init),
> -	{ /* sentinel value */ }
> -};
> -
>  static int armv6_pmu_device_probe(struct platform_device *pdev)
>  {
> -	return arm_pmu_device_probe(pdev, armv6_pmu_of_device_ids,
> -				    armv6_pmu_probe_table);
> +	return arm_pmu_device_probe(pdev, armv6_pmu_of_device_ids, NULL);
>  }
>  
>  static struct platform_driver armv6_pmu_driver = {
> diff --git a/drivers/perf/arm_v7_pmu.c b/drivers/perf/arm_v7_pmu.c
> index fdd936fbd188..928ac3d626ed 100644
> --- a/drivers/perf/arm_v7_pmu.c
> +++ b/drivers/perf/arm_v7_pmu.c
> @@ -1977,17 +1977,9 @@ static const struct of_device_id armv7_pmu_of_device_ids[] = {
>  	{},
>  };
>  
> -static const struct pmu_probe_info armv7_pmu_probe_table[] = {
> -	ARM_PMU_PROBE(ARM_CPU_PART_CORTEX_A8, armv7_a8_pmu_init),
> -	ARM_PMU_PROBE(ARM_CPU_PART_CORTEX_A9, armv7_a9_pmu_init),
> -	{ /* sentinel value */ }
> -};
> -
> -
>  static int armv7_pmu_device_probe(struct platform_device *pdev)
>  {
> -	return arm_pmu_device_probe(pdev, armv7_pmu_of_device_ids,
> -				    armv7_pmu_probe_table);
> +	return arm_pmu_device_probe(pdev, armv7_pmu_of_device_ids, NULL);
>  }
>  
>  static struct platform_driver armv7_pmu_driver = {
> 
> -- 
> 2.43.0
> 
