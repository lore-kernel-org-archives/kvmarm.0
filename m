From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] arm: Add simple arch timer test
Date: Mon, 19 Sep 2016 16:52:01 +0200
Message-ID: <20160919145201.64o2a4hkxhx3u55u@kamzik.localdomain>
References: <1474285480-215480-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80882410D7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 10:43:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CYsiyQrqEwTZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2016 10:43:05 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC72340FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2016 10:43:05 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1474285480-215480-1-git-send-email-agraf@suse.de>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 19, 2016 at 01:44:40PM +0200, Alexander Graf wrote:
> All virtualization capable ARM cores support the ARM architected virtual timer.
> 
> This patch adds minimalistic checks whether we can fire a virtual timer event
> using them. It does not actually trigger an interrupt yet, as infrastructure
> for that is missing. However, it does check whether the timer pin is marked as
> pending on the GIC.
> 
> Signed-off-by: Alexander Graf <agraf@suse.de>
> ---
>  arm/Makefile.arm64 |   2 +-
>  arm/vtimer-test.c  | 122 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 123 insertions(+), 1 deletion(-)
>  create mode 100644 arm/vtimer-test.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 0b0761c..5b3fbe8 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -12,7 +12,7 @@ cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
>  
>  # arm64 specific tests
> -tests =
> +tests = $(TEST_DIR)/vtimer-test.flat
>  
>  include $(TEST_DIR)/Makefile.common
>  
> diff --git a/arm/vtimer-test.c b/arm/vtimer-test.c
> new file mode 100644
> index 0000000..a3e24ce
> --- /dev/null
> +++ b/arm/vtimer-test.c
> @@ -0,0 +1,122 @@
> +/*
> + * Unit tests for the virtual timer on the ARM virt machine
> + *
> + * Copyright (C) 2016, Alexander Graf <agraf@suse.de>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/io.h>
> +
> +#define VTIMER_CTL_ENABLE  (1 << 0)
> +#define VTIMER_CTL_IMASK   (1 << 1)
> +#define VTIMER_CTL_ISTATUS (1 << 2)
> +
> +#define VIRT_GIC_DIST_BASE 0x08000000
> +#define GIC_DIST_PENDING_SET            0x200
> +#define GIC_DIST_PENDING_CLEAR          0x280
> +#define GIC_DIST_ACTIVE_SET             0x300
> +#define GIC_DIST_ACTIVE_CLEAR           0x380
> +
> +#define VIRT_GIC_CPU_BASE  0x08010000

Once I get my arm/gic series in we won't need to hard code
the gic base addresses and these gic register offsets will
also be provided.

> +
> +#define ARCH_TIMER_VIRT_IRQ   11
> +#define ARCH_TIMER_S_EL1_IRQ  13
> +#define ARCH_TIMER_NS_EL1_IRQ 14
> +#define ARCH_TIMER_NS_EL2_IRQ 10

We can pull these out of the DT.

> +
> +static void write_vtimer_ctl(u64 val)
> +{
> +	asm volatile("msr cntv_ctl_el0, %0" : : "r" (val));
> +}
> +
> +static void write_vtimer_cval(u64 val)
> +{
> +	asm volatile("msr cntv_cval_el0, %0" : : "r" (val));
> +}
> +
> +static u64 read_vtimer_ctl(void)
> +{
> +	u64 val;
> +	asm volatile("mrs %0, cntv_ctl_el0" : "=r" (val));
> +	return val;
> +}
> +
> +static u64 read_vtimer_cval(void)
> +{
> +	u64 val;
> +	asm volatile("mrs %0, cntv_cval_el0" : "=r" (val));
> +	return val;
> +}
> +
> +static u64 read_vtimer_val(void)
> +{
> +	u64 val;
> +	asm volatile("mrs %0, cntvct_el0" : "=r" (val));
> +	return val;
> +}
> +
> +static u64 read_vtimer_freq(void)
> +{
> +	u64 val;
> +	asm volatile("mrs %0, cntfrq_el0" : "=r" (val));
> +	return val;
> +}
> +
> +static bool gic_vtimer_pending(void)
> +{
> +	u32 *pending = (u32*)(VIRT_GIC_DIST_BASE + GIC_DIST_PENDING_SET);
> +	return (readl(pending) & (1 << (ARCH_TIMER_VIRT_IRQ + 16)));

nit: don't need the outer ()

I think I'd like to add the PPI(irq) macro we added to QEMU for
the +16's.

> +}
> +
> +static bool test_cval_10msec(void)
> +{
> +	u64 time_10ms = read_vtimer_freq() / 100;
> +	u64 time_1us = time_10ms / 10000;
> +	u64 before_timer = read_vtimer_val();
> +	u64 after_timer, latency;
> +
> +	/* Program timer to fire in 10ms */
> +	write_vtimer_cval(before_timer + time_10ms);
> +
> +	/* Wait for the timer to fire */
> +	while (!(read_vtimer_ctl() & VTIMER_CTL_ISTATUS)) ;

If emulation fails to set the status bit then we'll spin forever.
That's OK if we set the test timeout (arm/unittests.cfg:timeout
for this test appropriately) Or, maybe can add a trial count here
that's sufficiently large?

> +
> +	/* It fired, check how long it took */
> +	after_timer = read_vtimer_val();
> +
> +	latency = (after_timer - (before_timer + time_10ms));

nit: don't need the outer ()

Shouldn't latency be signed so we can see if the status bit was
set too soon? Or just compare time_10ms with after - before?

> +	printf("After timer: 0x%lx\n", after_timer);
> +	printf("Expected   : 0x%lx\n", before_timer + time_10ms);
> +	printf("Latency    : %ld us\n", latency / time_1us);
> +
> +	return latency < time_10ms;

Does this mean that the threshold for success is 10ms? If so,
then that's not too large?

> +}
> +
> +static void test_vtimer(void)
> +{
> +	printf("\n=== vtimer with busy loop ===\n");

I guess this is a subtest header, i.e. this file will get
other subtests and headers like this one will divide up
the test output. That's fine, but new, at least for arm tests.
Currently we're dividing subtests with report prefixes. In
this case, instead of the above printf, we'd do

 report_prefix_push("busy-loop");

or whatever the prefix should be. At the end of the function
we'd pop the prefix. I prefer the prefix style as it makes
grepping test logs easier.

> +
> +	/* Enable the timer */
> +	write_vtimer_cval(-1);

nit: I prefer ~0

> +	write_vtimer_ctl(VTIMER_CTL_ENABLE);
> +
> +	report("timer is not pending before", !gic_vtimer_pending());
> +	report("latency is within 10ms", test_cval_10msec());
> +	report("timer is pending after", gic_vtimer_pending());
> +
> +	/* Disable the timer again */
> +	write_vtimer_ctl(0);
> +}
> +
> +int main(void)
> +{
> +	printf("vtimer ctl:  0x%lx\n", read_vtimer_ctl());
> +	printf("vtimer cval: 0x%lx\n", read_vtimer_cval());
> +	printf("vtimer val:  0x%lx\n", read_vtimer_val());
> +	printf("vtimer freq: 0x%lx\n", read_vtimer_freq());
> +
> +	test_vtimer();
> +
> +	return report_summary();
> +}
> -- 
> 1.8.5.6
>

Thanks for submitting this Alex. I'll bump the arm/gic patches up in my
priority queue.

drew
