From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv5 3/3] arm: pmu: Add CPI
 checking
Date: Tue, 10 Nov 2015 21:05:16 -0500
Message-ID: <20151111020516.GA12386@hawk.localdomain>
References: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
 <1446059575-23903-1-git-send-email-cov@codeaurora.org>
 <1446059575-23903-4-git-send-email-cov@codeaurora.org>
 <20151030130022.GA8197@hawk.localdomain>
 <5633C5DB.7090009@codeaurora.org>
 <20151102155814.GA5279@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151102155814.GA5279@hawk.localdomain>
Sender: kvm-owner@vger.kernel.org
To: Christopher Covington <cov@codeaurora.org>
Cc: wei@redhat.com, alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 02, 2015 at 09:58:14AM -0600, Andrew Jones wrote:
> On Fri, Oct 30, 2015 at 03:32:43PM -0400, Christopher Covington wrote:
> > Hi Drew,
> > 
> > On 10/30/2015 09:00 AM, Andrew Jones wrote:
> > > On Wed, Oct 28, 2015 at 03:12:55PM -0400, Christopher Covington wrote:
> > >> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> > >> PMU cycle counter values. The code includes a strict checking facility
> > >> intended for the -icount option in TCG mode but it is not yet enabled
> > >> in the configuration file. Enabling it must wait on infrastructure
> > >> improvements which allow for different tests to be run on TCG versus
> > >> KVM.
> > >>
> > >> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> > >> ---
> > >>  arm/pmu.c | 103 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > >>  1 file changed, 102 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/arm/pmu.c b/arm/pmu.c
> > >> index 4334de4..788886a 100644
> > >> --- a/arm/pmu.c
> > >> +++ b/arm/pmu.c
> > >> @@ -43,6 +43,23 @@ static inline unsigned long get_pmccntr(void)
> > >>  	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
> > >>  	return cycles;
> > >>  }
> > >> +
> > >> +/*
> > >> + * Extra instructions inserted by the compiler would be difficult to compensate
> > >> + * for, so hand assemble everything between, and including, the PMCR accesses
> > >> + * to start and stop counting.
> > >> + */
> > >> +static inline void loop(int i, uint32_t pmcr)
> > >> +{
> > >> +	asm volatile(
> > >> +	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
> > >> +	"1:	subs	%[i], %[i], #1\n"
> > >> +	"	bgt	1b\n"
> > >> +	"	mcr	p15, 0, %[z], c9, c12, 0\n"
> > >> +	: [i] "+r" (i)
> > >> +	: [pmcr] "r" (pmcr), [z] "r" (0)
> > >> +	: "cc");
> > >> +}
> > >>  #elif defined(__aarch64__)
> > >>  static inline uint32_t get_pmcr(void)
> > >>  {
> > >> @@ -64,6 +81,23 @@ static inline unsigned long get_pmccntr(void)
> > >>  	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
> > >>  	return cycles;
> > >>  }
> > >> +
> > >> +/*
> > >> + * Extra instructions inserted by the compiler would be difficult to compensate
> > >> + * for, so hand assemble everything between, and including, the PMCR accesses
> > >> + * to start and stop counting.
> > >> + */
> > >> +static inline void loop(int i, uint32_t pmcr)
> > >> +{
> > >> +	asm volatile(
> > >> +	"	msr	pmcr_el0, %[pmcr]\n"
> > >> +	"1:	subs	%[i], %[i], #1\n"
> > >> +	"	b.gt	1b\n"
> > >> +	"	msr	pmcr_el0, xzr\n"
> > >> +	: [i] "+r" (i)
> > >> +	: [pmcr] "r" (pmcr)
> > >> +	: "cc");
> > >> +}
> > >>  #endif
> > >>  
> > >>  struct pmu_data {
> > >> @@ -131,12 +165,79 @@ static bool check_cycles_increase(void)
> > >>  	return true;
> > >>  }
> > >>  
> > >> -int main(void)
> > >> +/*
> > >> + * Execute a known number of guest instructions. Only odd instruction counts
> > >> + * greater than or equal to 3 are supported by the in-line assembly code. The
> > >> + * control register (PMCR_EL0) is initialized with the provided value (allowing
> > >> + * for example for the cycle counter or event counters to be reset). At the end
> > >> + * of the exact instruction loop, zero is written to PMCR_EL0 to disable
> > >> + * counting, allowing the cycle counter or event counters to be read at the
> > >> + * leisure of the calling code.
> > >> + */
> > >> +static void measure_instrs(int num, uint32_t pmcr)
> > >> +{
> > >> +	int i = (num - 1) / 2;
> > >> +
> > >> +	assert(num >= 3 && ((num - 1) % 2 == 0));
> > >> +	loop(i, pmcr);
> > >> +}
> > >> +
> > >> +/*
> > >> + * Measure cycle counts for various known instruction counts. Ensure that the
> > >> + * cycle counter progresses (similar to check_cycles_increase() but with more
> > >> + * instructions and using reset and stop controls). If supplied a positive,
> > >> + * nonzero CPI parameter, also strictly check that every measurement matches
> > >> + * it. Strict CPI checking is used to test -icount mode.
> > >> + */
> > >> +static bool check_cpi(int cpi)
> > >> +{
> > >> +	struct pmu_data pmu = {0};
> > >> +
> > >> +	pmu.cycle_counter_reset = 1;
> > >> +	pmu.enable = 1;
> > >> +
> > >> +	if (cpi > 0)
> > >> +		printf("Checking for CPI=%d.\n", cpi);
> > >> +	printf("instrs : cycles0 cycles1 ...\n");
> > >> +
> > >> +	for (int i = 3; i < 300; i += 32) {
> > >> +		int avg, sum = 0;
> > >> +
> > >> +		printf("%d :", i);
> > >> +		for (int j = 0; j < NR_SAMPLES; j++) {
> > >> +			int cycles;
> > >> +
> > >> +			measure_instrs(i, pmu.pmcr_el0);
> > >> +			cycles = get_pmccntr();
> > >> +			printf(" %d", cycles);
> > >> +
> > >> +			if (!cycles || (cpi > 0 && cycles != i * cpi)) {
> > >> +				printf("\n");
> > >> +				return false;
> > >> +			}
> > >> +
> > >> +			sum += cycles;
> > >> +		}
> > >> +		avg = sum / NR_SAMPLES;
> > >> +		printf(" sum=%d avg=%d avg_ipc=%d avg_cpi=%d\n",
> > >> +			sum, avg, i / avg, avg / i);
> > >> +	}
> > >> +
> > >> +	return true;
> > >> +}
> > >> +
> > >> +int main(int argc, char *argv[])
> > >>  {
> > >> +	int cpi = 0;
> > >> +
> > >> +	if (argc >= 1)
> > >> +		cpi = atol(argv[0]);
> > >> +
> > >>  	report_prefix_push("pmu");
> > >>  
> > >>  	report("Control register", check_pmcr());
> > >>  	report("Monotonically increasing cycle count", check_cycles_increase());
> > >> +	report("Cycle/instruction ratio", check_cpi(cpi));
> > >>  
> > >>  	return report_summary();
> > >>  }
> > > 
> > > I applied and tested this (by adding -icount 1 -append 1 to the cmdline),
> > 
> > Thanks for giving this a spin. For whatever reason the -icount argument is the
> > exponent n in 2^n. I could match that logic if you prefer, but the pmu.c code
> 
> Oh yeah, I forgot how you had that in your earlier posts. So in that
> case
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> I've applied these three patches to 
> 
> https://github.com/rhdrjones/kvm-unit-tests/commits/staging
> 
> I'll send a pull request to Paolo for that branch soon.

Hi Christopher,

I still have these queued on staging, but before we ask Paolo to commit,
I think we should try them with Shannon's patches for KVM in order to
make sure they work there, as well as with TCG (I have a feeling we'll
need to initialize a couple more registers). Also, now that we've got
the 'ACCEL' patch in master, we can take the unittests.cfg -icount patch
as well. Can you please resubmit with any changes needed for KVM, and
also with a unittests.cfg patch enabling both KVM and TCG tests?

Thanks,
drew

> 
> Thanks,
> drew
> 
> > currently takes the fully calculated shift value rather than the exponent.
> > I've been testing with the following option pairs (dependent on 'accel = tcg'
> > support).
> > 
> > -- >8 --
> > Subject: [PATCH] arm: pmu: Add -icount checking configurations
> > 
> > Pass a couple -icount values in TCG mode and strictly check the
> > resulting cycle counts.
> > 
> > Signed-off-by: Christopher Covington <cov@codeaurora.org>
> > ---
> >  arm/unittests.cfg | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> > index fd94adb..5ca1e6a 100644
> > --- a/arm/unittests.cfg
> > +++ b/arm/unittests.cfg
> > @@ -40,3 +40,17 @@ groups = selftest
> >  [pmu]
> >  file = pmu.flat
> >  groups = pmu
> > +
> > +# Test PMU support with -icount IPC=1
> > +[pmu-icount-1]
> > +file = pmu.flat
> > +extra_params = -icount 0 -append '1'
> > +groups = pmu
> > +accel = tcg
> > +
> > +# Test PMU support with -icount IPC=256
> > +[pmu-icount-256]
> > +file = pmu.flat
> > +extra_params = -icount 8 -append '256'
> > +groups = pmu
> > +accel = tcg
> > -- 
> > Qualcomm Innovation Center, Inc.
> > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> > a Linux Foundation Collaborative Project
> > 
