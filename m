From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH kvm-unit-tests 3/3] arm64: timer: Add support for phys
 timer testing
Date: Tue, 18 Jul 2017 15:23:24 +0200
Message-ID: <20170718132324.i5we5dsmpva45dw5@kamzik.brq.redhat.com>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-4-cdall@linaro.org>
 <20170718120957.uvxb546eqpj5oxbp@kamzik.brq.redhat.com>
 <20170718130153.GD14069@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170718130153.GD14069@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Alexander Graf <agraf@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Jintack Lim <jintack@cs.columbia.edu>, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 03:01:53PM +0200, Christoffer Dall wrote:
> On Tue, Jul 18, 2017 at 02:09:57PM +0200, Andrew Jones wrote:
> > On Thu, Jul 13, 2017 at 09:20:09PM +0200, Christoffer Dall wrote:
> > > Rearrange the code to be able to reuse as much as posible and add
> > > support for testing the physical timer as well.
> > > 
> > > Also change the default unittests configuration to run a separate vtimer
> > > and ptimer test so that older kernels without ptimer support just show a
> > > failure.
> > 
> > We could run tests for both the ptimer and vtimer in a single execution,
> > rather than splitting them and requiring the input, because the read of
> > cntp_ctl_el0 will predictably cause an UNKNOWN exception. Also, by
> > applying the errata framework we can ensure that if we expect the read
> > to work, i.e. the host kernel is recent enough, then, if we still get
> > an UNKNOWN exception, we can report FAIL instead of SKIP. Below is an
> > add on patch that makes the conversion. Let me know what you think.
> 
> The problem with this patch, is that we then report SKIP instead of
> FAIL, when we regress the kernel and actually break physical counter
> access (which I did while developing my series).
>

Well, as long as the cntp_ctl_el0 read isn't regressed into generating
an unknown exception, then the ptimer tests will always be run, reporting
failures as they should.

> I think something like this should be discovered by way of capabilities
> or hardcoding a kernel version.

That's possible already by making one more change (which I should have
made in the first place)

diff --git a/errata.txt b/errata.txt
index 5608a308ce7c9..8859d4f1d3860 100644
--- a/errata.txt
+++ b/errata.txt
@@ -4,4 +4,5 @@
 #---------------:-----------------------:--------------------------------------
 9e3f7a296940   : 4.9                   : arm64: KVM: pmu: Fix AArch32 cycle counter access
 6c7a5dce22b3   : 4.12                  : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
+7b6b46311a85   : 4.11                  : KVM: arm/arm64: Emulate the EL1 phys timer registers
 #---------------:-----------------------:--------------------------------------

With that change, when the test runtime system detects it's running on
a host with at least a 4.11 kernel, then it will automatically set
ERRATA_7b6b46311a85=y (unless overridden by the user). Having that
errata set will even ensure the cntp_ctl_el0 read is tested.

> 
> Does kvm-unit-tests generally care about not reporting FAIL with earlier
> kernel versions?

Yes and no. kvm-unit-tests targets upstream KVM, thus if somebody gets
FAILs, then they should update KVM and try again before reporting them.
However, when it's not too difficult to detect a lacking feature, meaning
the tests should be skipped, then outputting SKIP is preferred, as it
allows upstream kvm-unit-tests to work nicely on downstream (older) KVM
without modification as well. Indeed, the errata framework was built with
that in mind. Ideally, upstream kvm-unit-tests can just work on downstream
KVM by only replacing the errata.txt file with one that properly
represents the downstream KVM under test.

Thanks,
drew

> > 
> > diff --git a/arm/timer.c b/arm/timer.c
> > index 33dfc6facc190..d0ba1e9a3bafa 100644
> > --- a/arm/timer.c
> > +++ b/arm/timer.c
> > @@ -7,6 +7,7 @@
> >   */
> >  #include <libcflat.h>
> >  #include <devicetree.h>
> > +#include <errata.h>
> >  #include <asm/processor.h>
> >  #include <asm/gic.h>
> >  #include <asm/io.h>
> > @@ -16,6 +17,27 @@
> >  #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
> >  
> >  static void *gic_ispendr;
> > +static bool ptimer_unsupported;
> > +
> > +static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
> > +{
> > +	ptimer_unsupported = true;
> > +	regs->pc += 4;
> > +}
> > +
> > +static void set_ptimer_unsupported(void)
> > +{
> > +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
> > +	read_sysreg(cntp_ctl_el0);
> > +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
> > +
> > +	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
> > +		report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a85=y to enable.");
> > +	} else if (ptimer_unsupported) {
> > +		report("ptimer: read CNTP_CTL_EL0", false);
> > +		report_info("ptimer: skipping remaining tests");
> > +	}
> > +}
> >  
> >  static u64 read_vtimer_counter(void)
> >  {
> > @@ -159,7 +181,6 @@ static void test_timer(struct timer_info *info)
> >  	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
> >  	u64 later = now + time_10s;
> >  
> > -
> >  	/* Enable the timer, but schedule it for much later*/
> >  	info->write_cval(later);
> >  	isb();
> > @@ -182,6 +203,9 @@ static void test_vtimer(void)
> >  
> >  static void test_ptimer(void)
> >  {
> > +	if (ptimer_unsupported)
> > +		return;
> > +
> >  	report_prefix_push("ptimer-busy-loop");
> >  	test_timer(&ptimer_info);
> >  	report_prefix_pop();
> > @@ -226,52 +250,27 @@ static void test_init(void)
> >  	local_irq_enable();
> >  }
> >  
> > -static void print_vtimer_info(void)
> > +static void print_timer_info(void)
> >  {
> >  	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
> > +
> > +	if (!ptimer_unsupported) {
> > +		printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
> > +		printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
> > +		printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
> > +	}
> > +
> >  	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
> >  	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
> >  	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
> >  }
> >  
> > -static void print_ptimer_info(void)
> > -{
> > -	printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
> > -	printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
> > -	printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
> > -}
> > -
> > -
> >  int main(int argc, char **argv)
> >  {
> > -	bool run_ptimer_test = false;
> > -	bool run_vtimer_test = false;
> > -
> > -	/* Check if we should also check the physical timer */
> > -	if (argc > 1) {
> > -		if (strcmp(argv[1], "vtimer") == 0) {
> > -			run_vtimer_test = true;
> > -		} else if (strcmp(argv[1], "ptimer") == 0) {
> > -			run_ptimer_test = true;
> > -		} else {
> > -			report_abort("Unknown option '%s'", argv[1]);
> > -		}
> > -	} else {
> > -		run_vtimer_test = true;
> > -	}
> > -
> > -	if (run_vtimer_test)
> > -		print_vtimer_info();
> > -	else if (run_ptimer_test)
> > -		print_ptimer_info();
> > -
> > +	set_ptimer_unsupported();
> > +	print_timer_info();
> >  	test_init();
> > -
> > -	if (run_vtimer_test)
> > -		test_vtimer();
> > -	else if (run_ptimer_test)
> > -		test_ptimer();
> > -
> > -
> > +	test_ptimer();
> > +	test_vtimer();
> >  	return report_summary();
> >  }
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index d55e52e1a4c4f..bdfedf86b01cb 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -111,14 +111,7 @@ smp = $MAX_SMP
> >  groups = psci
> >  
> >  # Timer tests
> > -[vtimer]
> > +[timer]
> >  file = timer.flat
> > -extra_params = -append 'vtimer'
> > -groups = timer
> > -timeout = 2s
> > -
> > -[ptimer]
> > -file = timer.flat
> > -extra_params = -append 'ptimer'
> >  groups = timer
> >  timeout = 2s
