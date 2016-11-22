From: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v10 3/3] arm: pmu: Add CPI checking
Date: Tue, 22 Nov 2016 13:52:40 +0100
Message-ID: <20161122125240.mqvyc2lagwsxf2lf@kamzik.brq.redhat.com>
References: <1479759895-10042-1-git-send-email-wei@redhat.com>
 <1479759895-10042-4-git-send-email-wei@redhat.com>
 <13b86440-3b37-ff24-3080-f0deece175fa@codeaurora.org>
 <5263e77a-b987-c955-c328-040a11543c94@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41DE540223
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Nov 2016 07:52:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lc2ELoNnfg6m for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Nov 2016 07:52:07 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53E35401E7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Nov 2016 07:52:07 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <5263e77a-b987-c955-c328-040a11543c94@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Wei Huang <wei@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, shannon.zhao@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Nov 21, 2016 at 04:49:20PM -0600, Wei Huang wrote:
> 
> 
> On 11/21/2016 03:40 PM, Christopher Covington wrote:
> > Hi Wei,
> > 
> > On 11/21/2016 03:24 PM, Wei Huang wrote:
> >> From: Christopher Covington <cov@codeaurora.org>
> > 
> > I really appreciate your work on these patches. If for any or all of these
> > you have more lines added/modified than me (or using any other better
> > metric), please make sure to change the author to be you with
> > `git commit --amend --reset-author` or equivalent.
> 
> Sure, I will if needed. Regarding your comments below, I will fix the
> patch series after Drew's comments, if any.
> 
> > 
> >> Calculate the numbers of cycles per instruction (CPI) implied by ARM
> >> PMU cycle counter values. The code includes a strict checking facility
> >> intended for the -icount option in TCG mode in the configuration file.
> >>
> >> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> >> Signed-off-by: Wei Huang <wei@redhat.com>
> >> ---
> >>  arm/pmu.c         | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >>  arm/unittests.cfg |  14 +++++++
> >>  2 files changed, 132 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/arm/pmu.c b/arm/pmu.c
> >> index 176b070..129ef1e 100644
> >> --- a/arm/pmu.c
> >> +++ b/arm/pmu.c
> >> @@ -104,6 +104,25 @@ static inline uint32_t id_dfr0_read(void)
> >>  	asm volatile("mrc p15, 0, %0, c0, c1, 2" : "=r" (val));
> >>  	return val;
> >>  }
> >> +
> >> +/*
> >> + * Extra instructions inserted by the compiler would be difficult to compensate
> >> + * for, so hand assemble everything between, and including, the PMCR accesses
> >> + * to start and stop counting. Total cycles = isb + mcr + 2*loop = 2 + 2*loop.
>                                    ^^^^^^^^^^^^
> I will change the comment above to "Total instrs".
> 
> >> + */
> >> +static inline void precise_cycles_loop(int loop, uint32_t pmcr)
> > 
> > Nit: I would call this precise_instrs_loop. How many cycles it takes is
> > IMPLEMENTATION DEFINED.
> 
> You are right. The cycle indeed depends on the design. Will fix.
> 
> > 
> >> +{
> >> +	asm volatile(
> >> +	"	mcr	p15, 0, %[pmcr], c9, c12, 0\n"
> >> +	"	isb\n"
> >> +	"1:	subs	%[loop], %[loop], #1\n"
> >> +	"	bgt	1b\n"
> > 
> > Is there any chance we might need an isb here, to prevent the stop from happening
> > before or during the loop? Where ISBs are required, the Linux best practice is to
> 
> In theory, I think this can happen when mcr is executed before all loop
> instructions completed, causing pmccntr_read() to miss some cycles. But
> QEMU TCG mode doesn't support out-order-execution. So the test
> condition, "cpi > 0 && cycles != i * cpi", will never be TRUE. Because
> cpi==0 in KVM, this same test condition won't be TRUE under KVM mode either.
> 
> > diligently comment why they are needed. Perhaps it would be a good habit to
> > carry over into kvm-unit-tests.
> 
> Agreed. Most isb() instructions were added following CP15 writes (not
> all CP15 writes, but at limited locations). We tried to follow what
> Linux kernel does in perf_event.c. If you feel that any isb() place
> needs special comment, I will be more than happy to add it.
> 
> <snip>

No new comments from me. Thanks guys for catching the need to update the
comments.

drew
