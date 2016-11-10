From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] arm64: perf: Move ARMv8 PMU perf event definitions
 to asm/perf_event.h
Date: Thu, 10 Nov 2016 17:17:32 +0000
Message-ID: <20161110171732.GA17134@arm.com>
References: <1478721480-24852-1-git-send-email-wei@redhat.com>
 <aa5b2275-374f-4d74-d9d9-0959d90454ca@arm.com>
 <d9ef10b9-44f2-b02e-9d90-02cf348aa49c@redhat.com>
 <733f067d-7f3b-df28-eab7-a15abba947fc@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D011C402EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 12:17:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VOi8uNA-bWeO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Nov 2016 12:17:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 905B4402A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Nov 2016 12:17:06 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <733f067d-7f3b-df28-eab7-a15abba947fc@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 10, 2016 at 03:32:12PM +0000, Marc Zyngier wrote:
> On 10/11/16 15:12, Wei Huang wrote:
> > 
> > 
> > On 11/10/2016 03:10 AM, Marc Zyngier wrote:
> >> Hi Wei,
> >>
> >> On 09/11/16 19:57, Wei Huang wrote:
> >>> This patch moves ARMv8-related perf event definitions from perf_event.c
> >>> to asm/perf_event.h; so KVM code can use them directly. This also help
> >>> remove a duplicated definition of SW_INCR in perf_event.h.
> >>>
> >>> Signed-off-by: Wei Huang <wei@redhat.com>
> >>> ---
> >>>  arch/arm64/include/asm/perf_event.h | 161 +++++++++++++++++++++++++++++++++++-
> >>>  arch/arm64/kernel/perf_event.c      | 161 ------------------------------------
> >>>  2 files changed, 160 insertions(+), 162 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
> >>> index 2065f46..6c7b18b 100644
> >>> --- a/arch/arm64/include/asm/perf_event.h
> >>> +++ b/arch/arm64/include/asm/perf_event.h
> >>> @@ -46,7 +46,166 @@
> >>>  #define	ARMV8_PMU_EVTYPE_MASK	0xc800ffff	/* Mask for writable bits */
> >>>  #define	ARMV8_PMU_EVTYPE_EVENT	0xffff		/* Mask for EVENT bits */
> >>>  
> >>> -#define ARMV8_PMU_EVTYPE_EVENT_SW_INCR	0	/* Software increment event */
> >>> +/*
> >>> + * ARMv8 PMUv3 Performance Events handling code.
> >>> + * Common event types.
> >>> + */
> >>> +
> >>> +/* Required events. */
> >>> +#define ARMV8_PMUV3_PERFCTR_SW_INCR				0x00
> >>> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_REFILL			0x03
> >>> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE				0x04
> >>> +#define ARMV8_PMUV3_PERFCTR_BR_MIS_PRED				0x10
> >>> +#define ARMV8_PMUV3_PERFCTR_CPU_CYCLES				0x11
> >>> +#define ARMV8_PMUV3_PERFCTR_BR_PRED				0x12
> >>
> >> In my initial review, I asked for the "required" events to be moved to a
> >> shared location. What's the rational for moving absolutely everything?
> > 
> > I did notice the phrase "required" in the original email. However I
> > think it is weird to have two places for a same set of PMU definitions.
> > Other developers might think these two are missing if they don't search
> > kernel files carefully.
> > 
> > If Will Deacon and you insist, I can move only two defs to perf_event.h,
> > consolidated with the 2nd patch into a single one.
> 
> My personal feeling is that only architected events should be in a
> public header. The CPU-specific ones are probably better kept private,
> as it is doubtful that other users would appear).
> 
> I'll leave it up to Will to decide, as all I want to avoid is the
> duplication of constants between the PMU and KVM code bases.

Yeah, just take the sets that you need (i.e. the architected events).

Also, check that it builds.

Will
