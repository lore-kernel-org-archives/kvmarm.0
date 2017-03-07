From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] arm/arm64: gic: Test changing active
 state of interrupts
Date: Tue, 7 Mar 2017 20:34:33 +0100
Message-ID: <20170307193432.GC18298@potion>
References: <1488813369-87368-1-git-send-email-christoffer.dall@linaro.org>
 <20170307165811.a3c6tar7qlen4n2i@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BACE40BE3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 14:33:17 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gHrextsa0TFe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Mar 2017 14:33:16 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 161EC40A69
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Mar 2017 14:33:15 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170307165811.a3c6tar7qlen4n2i@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

2017-03-07 17:58+0100, Andrew Jones:
> On Mon, Mar 06, 2017 at 07:16:09AM -0800, Christoffer Dall wrote:
> > From: Christoffer Dall <cdall@linaro.org>
> > 
> > We found a deadlock when changing the active state of an interrupt while
> > the interrupt is queued on the LR of the running VCPU.
> > 
> > Defend KVM against this bug in the future now when we've introduced a
> > fix.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> > Sending with the right subject prefix this time.
> > 
> >  arm/gic.c         | 43 +++++++++++++++++++++++++++++++++++++++++++
> >  arm/unittests.cfg | 14 +++++++++++++-
> >  lib/arm/asm/gic.h |  2 ++
> >  3 files changed, 58 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arm/gic.c b/arm/gic.c
> > index 3054d45..82f6632 100644
> > --- a/arm/gic.c
> > +++ b/arm/gic.c
> > @@ -254,6 +254,47 @@ static struct gic gicv3 = {
> >  	},
> >  };
> >  
> > +static void ipi_clear_active_handler(struct pt_regs *regs __unused)
> > +{
> > +	u32 irqstat = gic_read_iar();
> > +	u32 irqnr = gic_iar_irqnr(irqstat);
> > +
> > +	if (irqnr != GICC_INT_SPURIOUS) {
> > +		void *base;
> > +		u32 val = 1 << IPI_IRQ;
> > +
> > +		if (gic_version() == 2)
> > +			base = gicv2_dist_base();
> > +		else
> > +			base = gicv3_redist_base();
> 
> Using the redistributor interface is correct with the current
> gic_enable_defaults(), because it enables affinity routing. I
> wonder if we shouldn't confirm it's enabled first though.
> 
> > +
> > +		writel(val, base + GICD_ICACTIVER);
> 
> For gicv3, with affinity routing enabled, the offset is
> technically named GICR_ICACTIVER0, but that's also 0x380, so
> it doesn't matter.
> 
> Not sure we need the 'val' variable.
> 
> > +
> > +		smp_rmb(); /* pairs with wmb in stats_reset */
> > +		++acked[smp_processor_id()];
> > +		check_irqnr(irqnr);
> > +		smp_wmb(); /* pairs with rmb in check_acked */
> > +	} else {
> > +		++spurious[smp_processor_id()];
> > +		smp_wmb();
> > +	}
> > +}
> > +
> > +static void run_active_clear_test(void)
> > +{
> > +	report_prefix_push("active");
> > +	gic_enable_defaults();
> > +#ifdef __arm__
> > +	install_exception_handler(EXCPTN_IRQ, ipi_clear_active_handler);
> > +#else
> > +	install_irq_handler(EL1H_IRQ, ipi_clear_active_handler);
> > +#endif
> > +	local_irq_enable();
> > +
> > +	ipi_test_self();
> > +	report_prefix_pop();
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >  	char pfx[8];
> > @@ -290,6 +331,8 @@ int main(int argc, char **argv)
> >  				cpu == IPI_SENDER ? ipi_send : ipi_recv);
> >  		}
> >  		ipi_recv();
> > +	} else if (strcmp(argv[1], "active") == 0) {
> > +		run_active_clear_test();
> 
> test_active_clear() ?
> 
> >  	} else {
> >  		report_abort("Unknown subtest '%s'", argv[1]);
> >  	}
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index c98658f..32d9858 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -26,7 +26,7 @@
> >  ##############################################################################
> >  
> >  #
> > -# Test that the configured number of processors (smp = <num>), and
> > +/# Test that the configured number of processors (smp = <num>), and
> 
> stray character here
> 
> >  # that the configured amount of memory (-m <MB>) are correctly setup
> >  # by the framework.
> >  #
> > @@ -92,6 +92,18 @@ smp = $MAX_SMP
> >  extra_params = -machine gic-version=3 -append 'ipi'
> >  groups = gic
> >  
> > +[gicv2-active]
> > +file = gic.flat
> > +smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
> > +extra_params = -machine gic-version=2 -append 'active'
> > +groups = gic
> > +
> > +[gicv3-active]
> > +file = gic.flat
> > +smp = $MAX_SMP
> > +extra_params = -machine gic-version=3 -append 'active'
> > +groups = gic
> > +
> >  # Test PSCI emulation
> >  [psci]
> >  file = psci.flat
> > diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> > index c8186f2..c688ccc 100644
> > --- a/lib/arm/asm/gic.h
> > +++ b/lib/arm/asm/gic.h
> > @@ -12,6 +12,8 @@
> >  #define GICD_TYPER			0x0004
> >  #define GICD_IGROUPR			0x0080
> >  #define GICD_ISENABLER			0x0100
> > +#define GICD_ISACTIVER			0x0300
> > +#define GICD_ICACTIVER			0x0380
> >  #define GICD_IPRIORITYR			0x0400
> >  #define GICD_SGIR			0x0f00
> >  
> > -- 
> > 2.5.0
> > 
> 
> Everything besides the stray character in unittests.cfg is on
> nit level, and the stray character can probably be cleaned up
> on commit, so
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Christoffer, I have fixed the slash in a local repo, ready to push if
you do not want any other changes.

Btw. can the host be rebooted without magic-SysRq after hitting the bug?
(I was wondering if the bug was bad enough for the nodefault group, but
 Drew didn't point it out and the host should still be useable
 afterwards ...)

Thanks.
