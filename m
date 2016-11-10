From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/2] arm64: perf: Move ARMv8 PMU perf event definitions
 to asm/perf_event.h
Date: Thu, 10 Nov 2016 15:29:47 +0000
Message-ID: <20161110152946.GG4418@leverpostej>
References: <1478721480-24852-1-git-send-email-wei@redhat.com>
 <aa5b2275-374f-4d74-d9d9-0959d90454ca@arm.com>
 <d9ef10b9-44f2-b02e-9d90-02cf348aa49c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d9ef10b9-44f2-b02e-9d90-02cf348aa49c@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wei Huang <wei@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org, kvm@vger.kernel.org, christoffer.dall@linaro.org, drjones@redhat.com, cov@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 10, 2016 at 09:12:35AM -0600, Wei Huang wrote:
> On 11/10/2016 03:10 AM, Marc Zyngier wrote:
> > On 09/11/16 19:57, Wei Huang wrote:
> >> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h

> >> +/*
> >> + * ARMv8 PMUv3 Performance Events handling code.
> >> + * Common event types.
> >> + */
> >> +
> >> +/* Required events. */
> >> +#define ARMV8_PMUV3_PERFCTR_SW_INCR				0x00
> >> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE_REFILL			0x03
> >> +#define ARMV8_PMUV3_PERFCTR_L1D_CACHE				0x04
> >> +#define ARMV8_PMUV3_PERFCTR_BR_MIS_PRED				0x10
> >> +#define ARMV8_PMUV3_PERFCTR_CPU_CYCLES				0x11
> >> +#define ARMV8_PMUV3_PERFCTR_BR_PRED				0x12
> > 
> > In my initial review, I asked for the "required" events to be moved to a
> > shared location. What's the rational for moving absolutely everything?
> 
> I did notice the phrase "required" in the original email. However I
> think it is weird to have two places for a same set of PMU definitions.
> Other developers might think these two are missing if they don't search
> kernel files carefully.
> 
> If Will Deacon and you insist, I can move only two defs to perf_event.h,
> consolidated with the 2nd patch into a single one.

FWIW, my personal preference would be for all the definitions (or at
least all of the ARMV8_PMUV3_* ones) to be in one place.

That said, I don't feel particularly strongly either way, and I'll defer
to Will.

Thanks,
Mark.
