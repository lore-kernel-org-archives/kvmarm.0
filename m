Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794417482;
	b=sdZN7moEo+/IgdH8CwMORM2ULQZrCtZcL5mT8oSuvUmLVoWWBuBnJ53+V6CeN2gNLyt4
	 QAEesWs3rVM7qElC3NeNJ6crB92U9WYXtE8NG+VRToZ92O2H+ojJJpTNdiI+lMTbsipdE
	 mQEOkv5sBqRp2xELbCDg9bMLWX2zhSqu+T3HNoY5BLEJK9DPgCNZULCNj4EucmejA2Zmy
	 7xIehjhKFB6+A/pWTkoiE3DUxlWQFo2rnbObXZ2e//DvTueblmEHlu/6dtInCRyvzKnCQ
	 K3OHJmikZwocEIJ0v03agNDnkSG0otRi5bRo4mExYsm+iw3KkyUoQfvPbw9rTa5vnFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794417482;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=hoUaDOXjvR+PfhexV4Pyo/MoYW9ox9uoEc03akIFgno=;
	b=ISYquPdSfPQZMNQmDWjkXXw4Vv33/aVZ8nt0QjqyTx5r3Xv/dQr9Ee1CxtNgplTTWkx6
	 7tVAGTkF/Vheni91Q2t9BVu8v/FtnrXcLT3q4x3BEsNqHaj4YNEmtNJY5hYsioaGbo3LH
	 kWFBX/DrFwSbxcVW0OpGB5dZp22q4hPt9Dvpr4vrCES8DA2trkQOl5gGXaJRYTBZsZbLh
	 ZgchIGgSLIQkN2GllSKDc0tPb9b42k+5vhYxaI3D7sf5t3wz+KVw08dU/somQCZABylvs
	 OKZgXl5yVuMibnaVxmGYf1fRUhb8Z/ygqz/c6T86uCg0s9Rx1L1JLJpO8Dz7LNCX9UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EEt6Egq0;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB4B606A31C
	for <kvmarm@lists.linux.dev>; Wed, 11 Nov 2026 17:18:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECB4B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=EEt6Egq0
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F6541576;
	Wed, 11 Nov 2026 09:17:58 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31B2C3F632;
	Wed, 11 Nov 2026 09:17:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794417481; bh=UrZqN4uTe8uR++LX3BUuIbvtsKfw4L/it9U0FMTY02A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EEt6Egq01I0d/W3/mcLTMJ8M9L2pHaoCM3Nn+SoOgaEkFLAtPlvnpjUsnkuHj5GN7
	 6pOn6kN+Sb1YU3abfAjb7MFDguqK6ugZ2CCCzv7ZsUZ0j7dJiquVyjt+VaF7tNUgam
	 TN5tJvfDnAmEwtzoo/yP0DA4ICqOkLvnaWyDiIlY=
Date: Wed, 11 Nov 2026 17:17:22 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, will@kernel.org, mark.rutland@arm.com,
	linux-perf-users@vger.kernel.org, catalin.marinas@arm.com,
	james.clark@linaro.org
Subject: Re: [RFC PATCH v7 04/28] perf: arm_spe_pmu: Move struct arm_spe_pmu
 to a separate header file
Message-ID: <avSjIvJM5TZAuQlG@raptor>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-5-alexandru.elisei@arm.com>
 <atDgBR0WOGHUsLaF@gremlin>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atDgBR0WOGHUsLaF@gremlin>

Hi Lorenzo,

On Thu, Oct 15, 2026 at 03:40:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 03, 2026 at 05:05:59PM +0100, Alexandru Elisei wrote:
> > KVM will soon want to make use of struct arm_spe_pmu, move it to a separate
> > header where it will be easily accessible.
> >
> > Cc: Will Deacon <will@kernel.org>
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> 
> Looks to be a straightforward mechanical change, couple nits below but with
> those addressed:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> > ---
> >  drivers/perf/arm_spe_pmu.c       | 33 +--------------------
> >  include/linux/perf/arm_spe_pmu.h | 50 ++++++++++++++++++++++++++++++++
> 
> This should be added to MAINTAINERS too I think?

Added this under ARM PMU PROFILING AND DEBUGGING:

+F:     include/linux/perf/arm_spe_pmu.h

> 
> >  2 files changed, 51 insertions(+), 32 deletions(-)
> >  create mode 100644 include/linux/perf/arm_spe_pmu.h
> >
> > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > index b70f3fedf028..79c571a649d5 100644
> > --- a/drivers/perf/arm_spe_pmu.c
> > +++ b/drivers/perf/arm_spe_pmu.c
> > @@ -28,6 +28,7 @@
> >  #include <linux/of.h>
> >  #include <linux/perf_event.h>
> >  #include <linux/perf/arm_pmu.h>
> > +#include <linux/perf/arm_spe_pmu.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/printk.h>
> >  #include <linux/slab.h>
> > @@ -67,38 +68,6 @@ struct arm_spe_pmu_buf {
> >  	void					*base;
> >  };
> >
> > -struct arm_spe_pmu {
> > -	struct pmu				pmu;
> > -	struct platform_device			*pdev;
> > -	cpumask_t				supported_cpus;
> > -	struct hlist_node			hotplug_node;
> > -
> > -	int					irq; /* PPI */
> > -	u16					pmsver;
> > -	u16					min_period;
> > -	u16					counter_sz;
> > -
> > -#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
> > -#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
> > -#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
> > -#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
> > -#define SPE_PMU_FEAT_LDS			(1UL << 4)
> > -#define SPE_PMU_FEAT_ERND			(1UL << 5)
> > -#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
> > -#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
> > -#define SPE_PMU_FEAT_EFT			(1UL << 8)
> > -#define SPE_PMU_FEAT_FDS			(1UL << 9)
> > -#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
> > -	u64					features;
> > -
> > -	u64					pmsevfr_res0;
> > -	u16					max_record_sz;
> > -	u16					align;
> > -	struct perf_output_handle __percpu	*handle;
> > -};
> > -
> > -#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> > -
> >  /* Convert a free-running index from perf into an SPE buffer offset */
> >  #define PERF_IDX2OFF(idx, buf) \
> >  	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
> > diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> > new file mode 100644
> > index 000000000000..af86fd184050
> > --- /dev/null
> > +++ b/include/linux/perf/arm_spe_pmu.h
> > @@ -0,0 +1,50 @@
> > +// SPDX-License-Identifier: GPL-2.0
> 
> Pedantic I know, sorry :P but as per Documentation/process/license-rules.rst:
> 
>       C source:	// SPDX-License-Identifier: <SPDX License Expression>
>       C header:	/* SPDX-License-Identifier: <SPDX License Expression> */
>       ...
> 
> So should be /* */ here.

Fixed.

> 
> > +/*
> > + * Split from driver/perf/arm_spe_pmu.c
> 
> NIT: should be drivers/...

Fixed.

Thanks,
Alex

> 
> > + *
> > + * Copyright (C) 2016 ARM Limited
> > + */
> > +
> > +#ifndef __PERF_ARM_SPE_PMU_H__
> > +#define __PERF_ARM_SPE_PMU_H__
> > +
> > +#include <linux/cpumask.h>
> > +#include <linux/container_of.h>
> > +#include <linux/list.h>
> > +#include <linux/perf_event.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/types.h>
> > +
> > +struct arm_spe_pmu {
> > +	struct pmu				pmu;
> > +	struct platform_device			*pdev;
> > +	cpumask_t				supported_cpus;
> > +	struct hlist_node			hotplug_node;
> > +
> > +	int					irq; /* PPI */
> > +	u16					pmsver;
> > +	u16					min_period;
> > +	u16					counter_sz;
> > +
> > +#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
> > +#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
> > +#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
> > +#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
> > +#define SPE_PMU_FEAT_LDS			(1UL << 4)
> > +#define SPE_PMU_FEAT_ERND			(1UL << 5)
> > +#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
> > +#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
> > +#define SPE_PMU_FEAT_EFT			(1UL << 8)
> > +#define SPE_PMU_FEAT_FDS			(1UL << 9)
> > +#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
> > +	u64					features;
> > +
> > +	u64					pmsevfr_res0;
> > +	u16					max_record_sz;
> > +	u16					align;
> > +	struct perf_output_handle __percpu	*handle;
> > +};
> > +
> > +#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> > +
> > +#endif /* __PERF_ARM_SPE_PMU_H__ */
> > --
> > 2.43.0
> >
> >
> 
> --
> Cheers, Lorenzo
