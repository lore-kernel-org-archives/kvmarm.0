Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794852242;
	b=bkkiq7ae0lDqKPl+Lv5XvEz2sjJYkPmmTRnSk5SNWCxACtOnkpD2fU4BOKu4vwct8ajO
	 sDbzhbmQdyoox6Qbd47jXB+atK7Bp6qj4/gmXQHu8AbT60wiZatg6cdtVZP01S4NJf6aa
	 cZjMHzfNVqKZKTWQqtPIdov07M31SJEr9WYyVOf/HKjgk2t/3cxjvubnliv2i8FuKfTKB
	 mXNE7cXF6GxN/xgtRT94YvRDhZKSBZnyNI3HBc303hy9voxWMgtcGBeQ46tR0yXJM8zND
	 C9NcEUUJarlald872hrKYW5Y+DbIJodHcn/WF8iuN8Ou3dCaSOY9jvh7TvoY3b4t1bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794852242;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PjgDifA+WY+ML1G6HjbkqA7torFG5UegbIaFkipl26w=;
	b=OyIoXgwG5lvkJjmvY/hH7Qfwt9lKjjrJ+RtvY/UHj//bwoH6fnyCNhkotb4Ewd62Fd2/
	 ZQsnkqKkD2K0Opk4NUfy9pGMA8NI+XJPZtYOY35C8Uim33EZG+ikXaJtSntj8ZE8fCCj1
	 s4ZIcXOQ+gHZe6odTh64sxsdWphFDzrx3QGrCCiAnpurpFjdfdxwNcW1WFJ008DK5Nb39
	 XsNwXOz3RFEmh+GU2M+mEWn6SXIfz9o61GZntmzR/ytLXoRyIJiir697vd6/EzJ93JJVx
	 7K0QDa80HOcZ3kLtNDRv97AsUyDAZ+aHClBRMV4A5xZ5r22hDRJyTdZ1nndt26wuXsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZQvZvdn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856A6606A322;
	Mon, 16 Nov 2026 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZQvZvdn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370F81F000C4;
	Mon, 16 Nov 2026 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794852242;
	bh=PjgDifA+WY+ML1G6HjbkqA7torFG5UegbIaFkipl26w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BZQvZvdnCu1giJ3n9uXH1U5699IR0+LrLB7Y8Ha/qpjipq/k5KAbUrH5utPqTM5P2
	 HQDKJxG2+GlXB9EMO6S7nFz2X7N/LHyZ6IHoJZL/izg8PP93rExefpbo5vm3mloKRa
	 pquMJdJ/EkrGWpEF82c9Tac77BaJO/elDrRDLvseO8kGHFFr9ElDzVxdnFo4NpxuDI
	 lrmoqU/D/flKe151y5d8z45H0et4/vOMd8L/XnUrw8RDiVqZpVp+2QLnOUchXm4O7S
	 nc4QlNJARiOkUGcp1ZAUe1yt0XzD7T8MEev8Q2gpJuoz60e9RMvFHiVQ7UMfyoqxvX
	 Gn3/KbYdSR6Qg==
Date: Mon, 16 Nov 2026 18:03:49 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	will@kernel.org, mark.rutland@arm.com, linux-perf-users@vger.kernel.org, 
	catalin.marinas@arm.com, james.clark@linaro.org
Subject: Re: [RFC PATCH v7 04/28] perf: arm_spe_pmu: Move struct arm_spe_pmu
 to a separate header file
Message-ID: <avtFfIHH5KP01r0j@gremlin>
References: <20260903160623.315525-1-alexandru.elisei@arm.com>
 <20260903160623.315525-5-alexandru.elisei@arm.com>
 <atDgBR0WOGHUsLaF@gremlin>
 <avSjIvJM5TZAuQlG@raptor>
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
In-Reply-To: <avSjIvJM5TZAuQlG@raptor>

On Wed, Nov 11, 2026 at 05:17:22PM +0000, Alexandru Elisei wrote:
> Hi Lorenzo,
>
> On Thu, Oct 15, 2026 at 03:40:09PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 03, 2026 at 05:05:59PM +0100, Alexandru Elisei wrote:
> > > KVM will soon want to make use of struct arm_spe_pmu, move it to a separate
> > > header where it will be easily accessible.
> > >
> > > Cc: Will Deacon <will@kernel.org>
> > > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >
> > Looks to be a straightforward mechanical change, couple nits below but with
> > those addressed:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > > ---
> > >  drivers/perf/arm_spe_pmu.c       | 33 +--------------------
> > >  include/linux/perf/arm_spe_pmu.h | 50 ++++++++++++++++++++++++++++++++
> >
> > This should be added to MAINTAINERS too I think?
>
> Added this under ARM PMU PROFILING AND DEBUGGING:
>
> +F:     include/linux/perf/arm_spe_pmu.h
>
> >
> > >  2 files changed, 51 insertions(+), 32 deletions(-)
> > >  create mode 100644 include/linux/perf/arm_spe_pmu.h
> > >
> > > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > > index b70f3fedf028..79c571a649d5 100644
> > > --- a/drivers/perf/arm_spe_pmu.c
> > > +++ b/drivers/perf/arm_spe_pmu.c
> > > @@ -28,6 +28,7 @@
> > >  #include <linux/of.h>
> > >  #include <linux/perf_event.h>
> > >  #include <linux/perf/arm_pmu.h>
> > > +#include <linux/perf/arm_spe_pmu.h>
> > >  #include <linux/platform_device.h>
> > >  #include <linux/printk.h>
> > >  #include <linux/slab.h>
> > > @@ -67,38 +68,6 @@ struct arm_spe_pmu_buf {
> > >  	void					*base;
> > >  };
> > >
> > > -struct arm_spe_pmu {
> > > -	struct pmu				pmu;
> > > -	struct platform_device			*pdev;
> > > -	cpumask_t				supported_cpus;
> > > -	struct hlist_node			hotplug_node;
> > > -
> > > -	int					irq; /* PPI */
> > > -	u16					pmsver;
> > > -	u16					min_period;
> > > -	u16					counter_sz;
> > > -
> > > -#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
> > > -#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
> > > -#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
> > > -#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
> > > -#define SPE_PMU_FEAT_LDS			(1UL << 4)
> > > -#define SPE_PMU_FEAT_ERND			(1UL << 5)
> > > -#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
> > > -#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
> > > -#define SPE_PMU_FEAT_EFT			(1UL << 8)
> > > -#define SPE_PMU_FEAT_FDS			(1UL << 9)
> > > -#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
> > > -	u64					features;
> > > -
> > > -	u64					pmsevfr_res0;
> > > -	u16					max_record_sz;
> > > -	u16					align;
> > > -	struct perf_output_handle __percpu	*handle;
> > > -};
> > > -
> > > -#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> > > -
> > >  /* Convert a free-running index from perf into an SPE buffer offset */
> > >  #define PERF_IDX2OFF(idx, buf) \
> > >  	((idx) % ((unsigned long)(buf)->nr_pages << PAGE_SHIFT))
> > > diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> > > new file mode 100644
> > > index 000000000000..af86fd184050
> > > --- /dev/null
> > > +++ b/include/linux/perf/arm_spe_pmu.h
> > > @@ -0,0 +1,50 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> >
> > Pedantic I know, sorry :P but as per Documentation/process/license-rules.rst:
> >
> >       C source:	// SPDX-License-Identifier: <SPDX License Expression>
> >       C header:	/* SPDX-License-Identifier: <SPDX License Expression> */
> >       ...
> >
> > So should be /* */ here.
>
> Fixed.
>
> >
> > > +/*
> > > + * Split from driver/perf/arm_spe_pmu.c
> >
> > NIT: should be drivers/...
>
> Fixed.
>
> Thanks,
> Alex
>
> >
> > > + *
> > > + * Copyright (C) 2016 ARM Limited
> > > + */
> > > +
> > > +#ifndef __PERF_ARM_SPE_PMU_H__
> > > +#define __PERF_ARM_SPE_PMU_H__
> > > +
> > > +#include <linux/cpumask.h>
> > > +#include <linux/container_of.h>
> > > +#include <linux/list.h>
> > > +#include <linux/perf_event.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/types.h>
> > > +
> > > +struct arm_spe_pmu {
> > > +	struct pmu				pmu;
> > > +	struct platform_device			*pdev;
> > > +	cpumask_t				supported_cpus;
> > > +	struct hlist_node			hotplug_node;
> > > +
> > > +	int					irq; /* PPI */
> > > +	u16					pmsver;
> > > +	u16					min_period;
> > > +	u16					counter_sz;
> > > +
> > > +#define SPE_PMU_FEAT_FILT_EVT			(1UL << 0)
> > > +#define SPE_PMU_FEAT_FILT_TYP			(1UL << 1)
> > > +#define SPE_PMU_FEAT_FILT_LAT			(1UL << 2)
> > > +#define SPE_PMU_FEAT_ARCH_INST			(1UL << 3)
> > > +#define SPE_PMU_FEAT_LDS			(1UL << 4)
> > > +#define SPE_PMU_FEAT_ERND			(1UL << 5)
> > > +#define SPE_PMU_FEAT_INV_FILT_EVT		(1UL << 6)
> > > +#define SPE_PMU_FEAT_DISCARD			(1UL << 7)
> > > +#define SPE_PMU_FEAT_EFT			(1UL << 8)
> > > +#define SPE_PMU_FEAT_FDS			(1UL << 9)
> > > +#define SPE_PMU_FEAT_DEV_PROBED			(1UL << 63)
> > > +	u64					features;
> > > +
> > > +	u64					pmsevfr_res0;
> > > +	u16					max_record_sz;
> > > +	u16					align;
> > > +	struct perf_output_handle __percpu	*handle;
> > > +};
> > > +
> > > +#define to_spe_pmu(p) (container_of(p, struct arm_spe_pmu, pmu))
> > > +
> > > +#endif /* __PERF_ARM_SPE_PMU_H__ */
> > > --
> > > 2.43.0
> > >
> > >
> >
> > --
> > Cheers, Lorenzo

Cheers for all above!

--
Cheers, Lorenzo
