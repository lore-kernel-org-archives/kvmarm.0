Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB395C43334
	for <kvmarm@archiver.kernel.org>; Wed,  6 Jul 2022 10:50:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F8A4BE66;
	Wed,  6 Jul 2022 06:50:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gVi+7stMrRGp; Wed,  6 Jul 2022 06:50:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09BAA4BE69;
	Wed,  6 Jul 2022 06:50:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 907694BE66
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 06:50:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6cbgKT46U-0A for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Jul 2022 06:50:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 565F749EF6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Jul 2022 06:50:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31A171042;
 Wed,  6 Jul 2022 03:50:52 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F0363F66F;
 Wed,  6 Jul 2022 03:50:50 -0700 (PDT)
Date: Wed, 6 Jul 2022 11:51:17 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Calvin Owens <quic_calvinow@quicinc.com>
Subject: Re: [RFC PATCH v5 15/38] perf: arm_spe_pmu: Move struct arm_spe_pmu
 to a separate header file
Message-ID: <YsVpJTRWTIzE/WKP@monolith.localdoman>
References: <20211117153842.302159-1-alexandru.elisei@arm.com>
 <20211117153842.302159-16-alexandru.elisei@arm.com>
 <YsRtcvxyufSCoIE5@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YsRtcvxyufSCoIE5@debian-BULLSEYE-live-builder-AMD64>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Calvin,

Thank you for the interest! FYI, I'm working on the next iteration of the
series where I'm planning to remove the dependency on CONFIG_NUMA_BALANCING
being unset.

On Tue, Jul 05, 2022 at 09:57:22AM -0700, Calvin Owens wrote:
> Hi Alexandru,
> 
> I've been taking a look at this series, it needs a little tweak to
> build successfully as a module which I've appended below.
> 
> Cheers,
> Calvin
> 
> On Wed, Nov 17, 2021 at 03:38:19PM +0000, Alexandru Elisei wrote:
> > KVM will soon want to make use of struct arm_spe_pmu, move it to a separate
> > header where it will be easily accessible. This is a straightforward move
> > and functionality should not be impacted.
> >
> > CC: Will Deacon <will@kernel.org>
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> 
> <snip>
> 
> > +++ b/include/linux/perf/arm_spe_pmu.h
> > @@ -0,0 +1,49 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Split from from drivers/perf/arm_spe_pmu.c.
> > + *
> > + *  Copyright (C) 2021 ARM Limited
> > + */
> > +
> > +#ifndef __ARM_SPE_PMU_H__
> > +#define __ARM_SPE_PMU_H__
> > +
> > +#include <linux/cpumask.h>
> > +#include <linux/perf_event.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/types.h>
> > +
> > +#ifdef CONFIG_ARM_SPE_PMU
> 
> Here, we need to use the IS_ENABLED() macro for the ARM_SPE_PMU=m case.
> 
> Signed-off-by: Calvin Owens <calvinow@qti.qualcomm.com>
> ---
>  include/linux/perf/arm_spe_pmu.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/perf/arm_spe_pmu.h b/include/linux/perf/arm_spe_pmu.h
> index 505a8867daad..b643e5e7a766 100644
> --- a/include/linux/perf/arm_spe_pmu.h
> +++ b/include/linux/perf/arm_spe_pmu.h
> @@ -13,7 +13,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/types.h>
>  
> -#ifdef CONFIG_ARM_SPE_PMU
> +#if IS_ENABLED(CONFIG_ARM_SPE_PMU)
>  
>  struct arm_spe_pmu {
>  	struct pmu				pmu;
> @@ -50,6 +50,6 @@ void kvm_host_spe_init(struct arm_spe_pmu *spe_pmu);
>  #define kvm_host_spe_init(x)	do { } while(0)
>  #endif
>  
> -#endif /* CONFIG_ARM_SPE_PMU */
> +#endif /* IS_ENABLED(CONFIG_ARM_SPE_PMU) */
>  
>  #endif /* __ARM_SPE_PMU_H__ */
> -- 
> 2.30.2

This indeed fixes the nasty screenfulls of errors that I get when trying to
compile with CONFIG_ARM_SPE_PMU=m.

If that's alright with you, I'll fold the fix into the patch and I'll CC
you.

Thanks,
Alex
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
