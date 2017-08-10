From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH kvm-unit-tests] arm64: timer: guard ptimer tests with
 errata
Date: Thu, 10 Aug 2017 16:59:26 +0200
Message-ID: <bf5dd26f-2e19-feb6-5ee7-bb02e4b862cd@redhat.com>
References: <20170810144516.32370-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170810144516.32370-1-drjones@redhat.com>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: cdall@linaro.org, rkrcmar@redhat.com, Ashish.Kalra@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

On 10/08/2017 16:45, Andrew Jones wrote:
> Rather than unconditionally attempting ptimer tests, which
> won't work on older KVM, check the KVM version first, reporting
> SKIP when the tests would fail. This also allows vtimer and
> ptimer tests to be merged into just "timer" tests.
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/timer.c       | 67 +++++++++++++++++++++++++++----------------------------
>  arm/unittests.cfg | 10 +--------
>  errata.txt        |  1 +
>  3 files changed, 35 insertions(+), 43 deletions(-)
> 
> diff --git a/arm/timer.c b/arm/timer.c
> index 4cdca9e6dabf..5f3135fa1445 100644
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
> @@ -16,6 +17,13 @@
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
>  
>  static u64 read_vtimer_counter(void)
>  {
> @@ -213,6 +221,9 @@ static void test_vtimer(void)
>  
>  static void test_ptimer(void)
>  {
> +	if (ptimer_unsupported)
> +		return;
> +
>  	report_prefix_push("ptimer-busy-loop");
>  	test_timer(&ptimer_info);
>  	report_prefix_pop();
> @@ -238,6 +249,17 @@ static void test_init(void)
>  	vtimer_info.irq = fdt32_to_cpu(data[7]);
>  	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
>  
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
> +
>  	gic_enable_defaults();
>  
>  	switch (gic_version()) {
> @@ -253,52 +275,29 @@ static void test_init(void)
>  	local_irq_enable();
>  }
>  
> -static void print_vtimer_info(void)
> +static void print_timer_info(void)
>  {
>  	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
> +
> +	if (!ptimer_unsupported){
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
>  	test_init();
>  
> -	if (run_vtimer_test)
> -		test_vtimer();
> -	else if (run_ptimer_test)
> -		test_ptimer();
> +	print_timer_info();
>  
> +	test_vtimer();
> +	test_ptimer();
>  
>  	return report_summary();
>  }
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 1f4baa24cafe..44b98cfc7afd 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -111,16 +111,8 @@ smp = $MAX_SMP
>  groups = psci
>  
>  # Timer tests
> -[vtimer]
> +[timer]
>  file = timer.flat
> -extra_params = -append 'vtimer'
> -groups = timer
> -timeout = 2s
> -arch = arm64
> -
> -[ptimer]
> -file = timer.flat
> -extra_params = -append 'ptimer'
>  groups = timer
>  timeout = 2s
>  arch = arm64
> diff --git a/errata.txt b/errata.txt
> index b943695173e0..7d6abc2a7bf6 100644
> --- a/errata.txt
> +++ b/errata.txt
> @@ -3,5 +3,6 @@
>  # 12 hex digits : version                       :
>  #---------------:-------------------------------:---------------------------------------------------
>  9e3f7a296940    : 4.9                           : arm64: KVM: pmu: Fix AArch32 cycle counter access
> +7b6b46311a85    : 4.11                          : KVM: arm/arm64: Emulate the EL1 phys timer registers
>  6c7a5dce22b3    : 4.12                          : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
>  #---------------:-------------------------------:---------------------------------------------------
> 


Applied, thanks.

Paolo
