Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D60331E832;
	Thu, 15 Oct 2026 14:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075218; cv=none; b=JhiFz62XEHIQl3Wa60CdGvN8drU1wZdCJYCRjXVQjYjUiq8dwnA/7vEDEVjQxI3Xbf2XTABQEpKqQaxaKdXSRovkA4QQtGHLgXCNgwFw8sOGDMu9QL5jhKjdeBO4E28nvB4a5gwJOpDuKCYbZ8cfi+CuhS8Ps9PQvV+P74nAMP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075218; c=relaxed/simple;
	bh=yKpQWkh+0wBAtq8iLLzcxYtaICdtDidEyCl1vUfi3ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SjcHX7UiNNhRK0wtfijToBTRe+hwIuue+3awYfz+yTM+VqHmjp6K/0H+lrKCf0Zf1WZFAbeSeL2vFNnnx0W3V2VuAhXFoY3powHVM8CRk6Hw7dKGGWfFwaY+OQzSi2ediuDZC7Nw+TkzsbeAn7IsqGnH7YJksQ3Y3cwX8wCLXdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=apf57+B3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="apf57+B3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73BE1F000C4;
	Thu, 15 Oct 2026 14:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075216;
	bh=x+WbW2/AMhXZdEubCnrJgm7dbLwFj9qtF+7pjh0jU2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=apf57+B3qo2bNygvN+Rge7NO4qF6q6JofjpUvYbWCm1IoR71qccfsx7EqtONodgIo
	 wXK6Ag2NlWGx4zGWGABznTEexPi0A66v71B6r/PN7dqlJypF3w1wtlNxemZxiafXsV
	 e6tlZ5R36fSJNjRaNooV5u45XuIEqlODGHrUnWb5tYdNGT5SBN7xLIwyusgN7vbdZ5
	 MFivwOGSTDU/wUTwsWRcLeKarHj2H+ATjw4SA1b/ETeMBE6xLP4MmtWZzlKQ4QDDtU
	 E15YNSxPiGeb+pvPG2MjQIHHUtfds0IZpVM2At6bBU6kogrLPL/aMb/cfyCKk7vTNU
	 N+nd1M4bdZDtQ==
Date: Thu, 15 Oct 2026 15:40:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 04/28] perf: arm_spe_pmu: Move struct arm_spe_pmu
 to a separate header file
Message-ID: <atDgBR0WOGHUsLaF@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-5-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903160623.315525-5-alexandru.elisei@arm.com>

On Thu, Sep 03, 2026 at 05:05:59PM +0100, Alexandru Elisei wrote:
> KVM will soon want to make use of struct arm_spe_pmu, move it to a separate
> header where it will be easily accessible.
>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Looks to be a straightforward mechanical change, couple nits below but with
those addressed:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  drivers/perf/arm_spe_pmu.c       | 33 +--------------------
>  include/linux/perf/arm_spe_pmu.h | 50 ++++++++++++++++++++++++++++++++

This should be added to MAINTAINERS too I think?

>  2 files changed, 51 insertions(+), 32 deletions(-)
>  create mode 100644 include/linux/perf/arm_spe_pmu.h
>
> diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> index b70f3fedf028..79c571a649d5 100644
> --- a/drivers/perf/arm_spe_pmu.c
> +++ b/drivers/perf/arm_spe_pmu.c
> @@ -28,6 +28,7 @@
>  #include <linux/of.h>
>  #include <linux/perf_event.h>
>  #include <linux/perf/arm_pmu.h>
> +#include <linux/perf/arm_spe_pmu.h>
>  #include <linux/platform_device.h>
>  #include <linux/printk.h>
>  #include <linux/slab.h>
> @@ -67,38 +68,6 @@ struct arm_spe_pmu_buf {
>  	void					*base;
>  };
>
> -struct arm_spe_pmu {
> -	struct pmu				pmu;
> -	struct platform_device			*pdev;
> -	cpumask_t				supported_cpus;
> -	struct hlist_node			hotplug_node;
> -
> -	int					irq; /* PPI */
> -	u16					pmsver;
> -	u16					min_period;
> -	u16					counter_sz;
> -
> -#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
> -#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
> -#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
> -#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
> -#define SPE_PMU_FEAT_LDS			(1UL << 4)
> -#define SPE_PMU_FEAT_ERND			(1UL << 5)
> -#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
> -#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
> -#define SPE_PMU_FEAT_EFT			(1UL << 8)
> -#define SPE_PMU_FEAT_FDS			(1UL << 9)
> -#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
> -	u64					features;
> -
> -	u64					pmsevfr_res0;
> -	u16					max_record_sz;
> -	u16					align;
> -	struct perf_output_handle __percpu	*handle;
> -};
> -
> -#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> -
>  /* Convert a free-running index from perf into an SPE buffer offset */
>  #define PERF_IDX2OFF(idx, buf) \
>  	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
> diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> new file mode 100644
> index 000000000000..af86fd184050
> --- /dev/null
> +++ b/include/linux/perf/arm_spe_pmu.h
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0

Pedantic I know, sorry :P but as per Documentation/process/license-rules.rst:

      C source:	// SPDX-License-Identifier: <SPDX License Expression>
      C header:	/* SPDX-License-Identifier: <SPDX License Expression> */
      ...

So should be /* */ here.

> +/*
> + * Split from driver/perf/arm_spe_pmu.c

NIT: should be drivers/...

> + *
> + * Copyright (C) 2016 ARM Limited
> + */
> +
> +#ifndef __PERF_ARM_SPE_PMU_H__
> +#define __PERF_ARM_SPE_PMU_H__
> +
> +#include <linux/cpumask.h>
> +#include <linux/container_of.h>
> +#include <linux/list.h>
> +#include <linux/perf_event.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +
> +struct arm_spe_pmu {
> +	struct pmu				pmu;
> +	struct platform_device			*pdev;
> +	cpumask_t				supported_cpus;
> +	struct hlist_node			hotplug_node;
> +
> +	int					irq; /* PPI */
> +	u16					pmsver;
> +	u16					min_period;
> +	u16					counter_sz;
> +
> +#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
> +#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
> +#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
> +#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
> +#define SPE_PMU_FEAT_LDS			(1UL << 4)
> +#define SPE_PMU_FEAT_ERND			(1UL << 5)
> +#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
> +#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
> +#define SPE_PMU_FEAT_EFT			(1UL << 8)
> +#define SPE_PMU_FEAT_FDS			(1UL << 9)
> +#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
> +	u64					features;
> +
> +	u64					pmsevfr_res0;
> +	u16					max_record_sz;
> +	u16					align;
> +	struct perf_output_handle __percpu	*handle;
> +};
> +
> +#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> +
> +#endif /* __PERF_ARM_SPE_PMU_H__ */
> --
> 2.43.0
>
>

--
Cheers, Lorenzo
