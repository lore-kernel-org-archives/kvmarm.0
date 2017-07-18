From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH kvm-unit-tests 3/3] arm64: timer: Add support for phys
 timer testing
Date: Tue, 18 Jul 2017 15:01:53 +0200
Message-ID: <20170718130153.GD14069@cbox>
References: <20170713192009.10069-1-cdall@linaro.org>
 <20170713192009.10069-4-cdall@linaro.org>
 <20170718120957.uvxb546eqpj5oxbp@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8F2440D1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:01:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 45XvpMO2FfJs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 09:01:09 -0400 (EDT)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5D3540D14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 09:01:09 -0400 (EDT)
Received: by mail-lf0-f43.google.com with SMTP id w198so12831325lff.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 06:01:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170718120957.uvxb546eqpj5oxbp@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jul 18, 2017 at 02:09:57PM +0200, Andrew Jones wrote:
> On Thu, Jul 13, 2017 at 09:20:09PM +0200, Christoffer Dall wrote:
> > Rearrange the code to be able to reuse as much as posible and add
> > support for testing the physical timer as well.
> > 
> > Also change the default unittests configuration to run a separate vtimer
> > and ptimer test so that older kernels without ptimer support just show a
> > failure.
> 
> We could run tests for both the ptimer and vtimer in a single execution,
> rather than splitting them and requiring the input, because the read of
> cntp_ctl_el0 will predictably cause an UNKNOWN exception. Also, by
> applying the errata framework we can ensure that if we expect the read
> to work, i.e. the host kernel is recent enough, then, if we still get
> an UNKNOWN exception, we can report FAIL instead of SKIP. Below is an
> add on patch that makes the conversion. Let me know what you think.

The problem with this patch, is that we then report SKIP instead of
FAIL, when we regress the kernel and actually break physical counter
access (which I did while developing my series).

I think something like this should be discovered by way of capabilities
or hardcoding a kernel version.

Does kvm-unit-tests generally care about not reporting FAIL with earlier
kernel versions?

Thanks,
-Christoffer

> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 33dfc6facc190..d0ba1e9a3bafa 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -7,6 +7,7 @@
>   */
>  #include <libcflat.h>
>  #include <devicetree.h>
> +#include <errata.h>
>  #include <asm/processor.h>
>  #include <asm/gic.h>
>  #include <asm/io.h>
> @@ -16,6 +17,27 @@
>  #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
>  
>  static void *gic_ispendr;
> +static bool ptimer_unsupported;
> +
> +static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
> +{
> +	ptimer_unsupported = true;
> +	regs->pc += 4;
> +}
> +
> +static void set_ptimer_unsupported(void)
> +{
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
> +	read_sysreg(cntp_ctl_el0);
> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
> +
> +	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
> +		report_skip("Skipping ptimer tests. Set ERRATA_7b6b46311a85=y to enable.");
> +	} else if (ptimer_unsupported) {
> +		report("ptimer: read CNTP_CTL_EL0", false);
> +		report_info("ptimer: skipping remaining tests");
> +	}
> +}
>  
>  static u64 read_vtimer_counter(void)
>  {
> @@ -159,7 +181,6 @@ static void test_timer(struct timer_info *info)
>  	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
>  	u64 later = now + time_10s;
>  
> -
>  	/* Enable the timer, but schedule it for much later*/
>  	info->write_cval(later);
>  	isb();
> @@ -182,6 +203,9 @@ static void test_vtimer(void)
>  
>  static void test_ptimer(void)
>  {
> +	if (ptimer_unsupported)
> +		return;
> +
>  	report_prefix_push("ptimer-busy-loop");
>  	test_timer(&ptimer_info);
>  	report_prefix_pop();
> @@ -226,52 +250,27 @@ static void test_init(void)
>  	local_irq_enable();
>  }
>  
> -static void print_vtimer_info(void)
> +static void print_timer_info(void)
>  {
>  	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
> +
> +	if (!ptimer_unsupported) {
> +		printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
> +		printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
> +		printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
> +	}
> +
>  	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
>  	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
>  	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
>  }
>  
> -static void print_ptimer_info(void)
> -{
> -	printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
> -	printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
> -	printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
> -}
> -
> -
>  int main(int argc, char **argv)
>  {
> -	bool run_ptimer_test = false;
> -	bool run_vtimer_test = false;
> -
> -	/* Check if we should also check the physical timer */
> -	if (argc > 1) {
> -		if (strcmp(argv[1], "vtimer") == 0) {
> -			run_vtimer_test = true;
> -		} else if (strcmp(argv[1], "ptimer") == 0) {
> -			run_ptimer_test = true;
> -		} else {
> -			report_abort("Unknown option '%s'", argv[1]);
> -		}
> -	} else {
> -		run_vtimer_test = true;
> -	}
> -
> -	if (run_vtimer_test)
> -		print_vtimer_info();
> -	else if (run_ptimer_test)
> -		print_ptimer_info();
> -
> +	set_ptimer_unsupported();
> +	print_timer_info();
>  	test_init();
> -
> -	if (run_vtimer_test)
> -		test_vtimer();
> -	else if (run_ptimer_test)
> -		test_ptimer();
> -
> -
> +	test_ptimer();
> +	test_vtimer();
>  	return report_summary();
>  }
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index d55e52e1a4c4f..bdfedf86b01cb 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -111,14 +111,7 @@ smp = $MAX_SMP
>  groups = psci
>  
>  # Timer tests
> -[vtimer]
> +[timer]
>  file = timer.flat
> -extra_params = -append 'vtimer'
> -groups = timer
> -timeout = 2s
> -
> -[ptimer]
> -file = timer.flat
> -extra_params = -append 'ptimer'
>  groups = timer
>  timeout = 2s
