From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv7 1/3] arm: Add PMU test
Date: Thu, 3 Nov 2016 16:04:13 +0100
Message-ID: <20161103150413.c2y4wdq2rmqkjrsq@kamzik.brq.redhat.com>
References: <1478125337-11770-1-git-send-email-wei@redhat.com>
 <1478125337-11770-2-git-send-email-wei@redhat.com>
 <20161103101427.2ze2x4yrvo32znk5@kamzik.brq.redhat.com>
 <afe0852cc9a29565c4d891df86f146b7@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF9FE402EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2016 11:04:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RtQtcVlcYOrb for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2016 11:04:05 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 851A240284
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2016 11:04:05 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <afe0852cc9a29565c4d891df86f146b7@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: cov@codeaurora.org
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 03, 2016 at 08:29:57AM -0600, cov@codeaurora.org wrote:
> On 2016-11-03 04:14, Andrew Jones wrote:
> > On Wed, Nov 02, 2016 at 05:22:15PM -0500, Wei Huang wrote:
> > 
> > Missing
> >  From: Christopher Covington <cov@codeaurora.org>
> > 
> > 
> > > Beginning with a simple sanity check of the control register, add
> > > a unit test for the ARM Performance Monitors Unit (PMU).
> > > 
> > > Signed-off-by: Christopher Covington <cov@codeaurora.org>
> > 
> > Missing
> >   Signed-off-by: Wei Huang <wei@redhat.com>
> > 
> > > ---
> > >  arm/Makefile.common |  3 +-
> > >  arm/pmu.c           | 82
> > > +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  arm/unittests.cfg   | 20 +++++++++++++
> > >  3 files changed, 104 insertions(+), 1 deletion(-)
> > >  create mode 100644 arm/pmu.c
> > > 
> > > diff --git a/arm/Makefile.common b/arm/Makefile.common
> > > index ccb554d..f98f422 100644
> > > --- a/arm/Makefile.common
> > > +++ b/arm/Makefile.common
> > > @@ -11,7 +11,8 @@ endif
> > > 
> > >  tests-common = \
> > >  	$(TEST_DIR)/selftest.flat \
> > > -	$(TEST_DIR)/spinlock-test.flat
> > > +	$(TEST_DIR)/spinlock-test.flat \
> > > +	$(TEST_DIR)/pmu.flat
> > > 
> > >  all: test_cases
> > > 
> > > diff --git a/arm/pmu.c b/arm/pmu.c
> > > new file mode 100644
> > > index 0000000..42d0ee1
> > > --- /dev/null
> > > +++ b/arm/pmu.c
> > > @@ -0,0 +1,82 @@
> > > +/*
> > > + * Test the ARM Performance Monitors Unit (PMU).
> > > + *
> > > + * Copyright 2015 The Linux Foundation. All rights reserved.
> > 
> > Is the Linux Foundation correct for codeaurora patches? Should bump
> > the year to 2016.
> > 
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > modify it
> > > + * under the terms of the GNU Lesser General Public License version
> > > 2.1 and
> > > + * only version 2.1 as published by the Free Software Foundation.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > but WITHOUT
> > > + * ANY WARRANTY; without even the implied warranty of
> > > MERCHANTABILITY or
> > > + * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General
> > > Public License
> > > + * for more details.
> > > + */
> > > +#include "libcflat.h"
> > > +
> > > +#if defined(__arm__)
> > > +static inline uint32_t get_pmcr(void)
> > > +{
> > > +	uint32_t ret;
> > > +
> > > +	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
> > > +	return ret;
> > > +}
> > > +#elif defined(__aarch64__)
> > > +static inline uint32_t get_pmcr(void)
> > > +{
> > > +	uint32_t ret;
> > > +
> > > +	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
> > > +	return ret;
> > > +}
> > > +#endif
> > > +
> > > +struct pmu_data {
> > > +	union {
> > > +		uint32_t pmcr_el0;
> > > +		struct {
> > > +			uint32_t enable:1;
> > > +			uint32_t event_counter_reset:1;
> > > +			uint32_t cycle_counter_reset:1;
> > > +			uint32_t cycle_counter_clock_divider:1;
> > > +			uint32_t event_counter_export:1;
> > > +			uint32_t cycle_counter_disable_when_prohibited:1;
> > > +			uint32_t cycle_counter_long:1;
> > > +			uint32_t reserved:4;
> > > +			uint32_t counters:5;
> > > +			uint32_t identification_code:8;
> > > +			uint32_t implementer:8;
> > > +		};
> > > +	};
> > > +};
> > 
> > I know I already reviewed/agreed to this bitfield, but I'm having second
> > thoughts. I think I'd prefer a bunch of defined shifts like the kernel
> > uses.
> > 
> > > +
> > > +/*
> > > + * As a simple sanity check on the PMCR_EL0, ensure the implementer
> > > field isn't
> > > + * null. Also print out a couple other interesting fields for
> > > diagnostic
> > > + * purposes. For example, as of fall 2015, QEMU TCG mode doesn't
> > > implement
> > 
> > s/2015/2016/   how time flies...
> > 
> > > + * event counters and therefore reports zero event counters, but
> > > hopefully
> > > + * support for at least the instructions event will be added in the
> > > future and
> > > + * the reported number of event counters will become nonzero.
> > > + */
> > > +static bool check_pmcr(void)
> > > +{
> > > +	struct pmu_data pmu;
> > > +
> > > +	pmu.pmcr_el0 = get_pmcr();
> > > +
> > > +	printf("PMU implementer:     %c\n", pmu.implementer);
> > > +	printf("Identification code: 0x%x\n", pmu.identification_code);
> > > +	printf("Event counters:      %d\n", pmu.counters);
> > > +
> > > +	return pmu.implementer != 0;
> > > +}
> > > +
> > > +int main(void)
> > > +{
> > > +	report_prefix_push("pmu");
> > > +
> > > +	report("Control register", check_pmcr());
> > > +
> > > +	return report_summary();
> > > +}
> > > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > > index 3f6fa45..b647b69 100644
> > > --- a/arm/unittests.cfg
> > > +++ b/arm/unittests.cfg
> > > @@ -54,3 +54,23 @@ file = selftest.flat
> > >  smp = $MAX_SMP
> > >  extra_params = -append 'smp'
> > >  groups = selftest
> > > +
> > > +# Test PMU support (KVM)
> > > +[pmu-kvm]
> > > +file = pmu.flat
> > > +groups = pmu
> > > +accel = kvm
> > 
> > No need to specify kvm when it works for both. Both is assumed.
> > tcg-only or kvm-only tests are exceptions requiring the 'accel'
> > parameter and a comment explaining why it doesn't work on the
> > other.
> > 
> > > +
> > > +# Test PMU support (TCG) with -icount IPC=1
> > > +[pmu-tcg-icount-1]
> > > +file = pmu.flat
> > > +extra_params = -icount 0 -append '1'
> > > +groups = pmu
> > > +accel = tcg
> > > +
> > > +# Test PMU support (TCG) with -icount IPC=256
> > > +[pmu-tcg-icount-256]
> > > +file = pmu.flat
> > > +extra_params = -icount 8 -append '256'
> > > +groups = pmu
> > > +accel = tcg
> > 
> > Why are these entries added now. These tests aren't yet implemented.
> 
> What makes you say they aren't implemented? They're running the
> same binary with a different command line arguments (that turns on
> stricter TCG-specific checking).

Not in this patch, they're not. 'int main(void)' <-- arguments are
ignored. Please only introduce unittests.cfg blocks with the patch
that implements them.

Thanks,
drew
