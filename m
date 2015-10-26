From: Andrew Jones <drjones@redhat.com>
Subject: Re: [Qemu-devel] [kvm-unit-tests PATCHv5 2/3] arm: pmu: Check cycle
 count increases
Date: Mon, 26 Oct 2015 17:04:57 +0100
Message-ID: <20151026160457.GH30256@hawk.localdomain>
References: <1444662470-13045-1-git-send-email-cov@codeaurora.org>
 <1445873930-9058-1-git-send-email-cov@codeaurora.org>
 <1445873930-9058-3-git-send-email-cov@codeaurora.org>
 <20151026155843.GG30256@hawk.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 34F2240F9B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 12:02:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VkclCTZJ9gkD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Oct 2015 12:02:13 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8DD91407A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Oct 2015 12:02:13 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20151026155843.GG30256@hawk.localdomain>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christopher Covington <cov@codeaurora.org>
Cc: alindsay@codeaurora.org, kvm@vger.kernel.org, croberts@codeaurora.org, qemu-devel@nongnu.org, alistair.francis@xilinx.com, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 26, 2015 at 04:58:43PM +0100, Andrew Jones wrote:
> On Mon, Oct 26, 2015 at 11:38:49AM -0400, Christopher Covington wrote:
> > Ensure that reads of the PMCCNTR_EL0 are monotonically increasing,
> > even for the smallest delta of two subsequent reads.
> > 
> > Signed-off-by: Christopher Covington <cov@codeaurora.org>
> > ---
> >  arm/pmu.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 60 insertions(+)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 42d0ee1..c44d708 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -14,6 +14,8 @@
> >   */
> >  #include "libcflat.h"
> >  
> > +#define NR_SAMPLES 10
> > +
> >  #if defined(__arm__)
> >  static inline uint32_t get_pmcr(void)
> >  {
> > @@ -22,6 +24,25 @@ static inline uint32_t get_pmcr(void)
> >  	asm volatile("mrc p15, 0, %0, c9, c12, 0" : "=r" (ret));
> >  	return ret;
> >  }
> > +
> > +static inline void set_pmcr(uint32_t pmcr)
> > +{
> > +	asm volatile("mcr p15, 0, %0, c9, c12, 0" : : "r" (pmcr));
> > +}
> > +
> > +/*
> > + * While PMCCNTR can be accessed as a 64 bit coprocessor register, returning 64
> > + * bits doesn't seem worth the trouble when differential usage of the result is
> > + * expected (with differences that can easily fit in 32 bits). So just return
> > + * the lower 32 bits of the cycle count in AArch32.
> > + */
> > +static inline unsigned long get_pmccntr(void)
> > +{
> > +	unsigned long cycles;
> > +
> > +	asm volatile("mrc p15, 0, %0, c9, c13, 0" : "=r" (cycles));
> > +	return cycles;
> > +}
> >  #elif defined(__aarch64__)
> >  static inline uint32_t get_pmcr(void)
> >  {
> > @@ -30,6 +51,19 @@ static inline uint32_t get_pmcr(void)
> >  	asm volatile("mrs %0, pmcr_el0" : "=r" (ret));
> >  	return ret;
> >  }
> > +
> > +static inline void set_pmcr(uint32_t pmcr)
> > +{
> > +	asm volatile("msr pmcr_el0, %0" : : "r" (pmcr));
> > +}
> > +
> > +static inline unsigned long get_pmccntr(void)
> > +{
> > +	unsigned long cycles;
> > +
> > +	asm volatile("mrs %0, pmccntr_el0" : "=r" (cycles));
> > +	return cycles;
> > +}
> >  #endif
> >  
> >  struct pmu_data {
> > @@ -72,11 +106,37 @@ static bool check_pmcr(void)
> >  	return pmu.implementer != 0;
> >  }
> >  
> > +/*
> > + * Ensure that the cycle counter progresses between back-to-back reads.
> > + */
> > +static bool check_cycles_increase(void)
> > +{
> > +	struct pmu_data pmu = { {0} };
> 
> One set of {} is enough, and looks better.

Ah, just read your cover letter and now see that this was done on purpose.
So your compiler complains about {0}? Is there a problem besides the
warning? If not, then I'm still a bit inclined to keep the code neat. The
warnings will go away with compiler updates.

Thanks,
drew
> 
> > +
> > +	pmu.enable = 1;
> > +	set_pmcr(pmu.pmcr_el0);
> > +
> > +	for (int i = 0; i < NR_SAMPLES; i++) {
> > +		unsigned long a, b;
> > +
> > +		a = get_pmccntr();
> > +		b = get_pmccntr();
> > +
> > +		if (a >= b) {
> > +			printf("Read %ld then %ld.\n", a, b);
> > +			return false;
> > +		}
> > +	}
> > +
> > +	return true;
> > +}
> > +
> >  int main(void)
> >  {
> >  	report_prefix_push("pmu");
> >  
> >  	report("Control register", check_pmcr());
> > +	report("Monotonically increasing cycle count", check_cycles_increase());
> >  
> >  	return report_summary();
> >  }
> > -- 
> > Qualcomm Innovation Center, Inc.
> > The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> > a Linux Foundation Collaborative Project
> > 
> >
> 
> Otherwise
> Reviewed-by: Andrew Jones <drjones@redhat.com>
