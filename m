From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 01/13] arm/arm64: Add new is_kernel_in_hyp_mode predicate
Date: Thu, 9 Jul 2015 11:12:44 +0100
Message-ID: <20150709101244.GC20105@leverpostej>
References: <1436372356-30410-1-git-send-email-marc.zyngier@arm.com>
 <1436372356-30410-2-git-send-email-marc.zyngier@arm.com>
 <20150709094230.GA20105@leverpostej>
 <559E476E.2000306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <559E476E.2000306@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <Will.Deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 09, 2015 at 11:05:34AM +0100, Marc Zyngier wrote:
> On 09/07/15 10:42, Mark Rutland wrote:
> > Hi,
> > 
> >> +static inline bool is_kernel_in_hyp_mode(void)
> >> +{
> >> +	u64 el;
> >> +
> >> +	asm("mrs %0, CurrentEL" : "=r" (el));
> >> +	return el == CurrentEL_EL2;
> >> +}
> > 
> > If you can include cputype.h, I think this can be:
> > 
> > static inline bool is_kernel_in_hyp_mode(void)
> > {
> > 	return read_cpuid(CurrentEL) == CurrentEL_EL2;
> > }
> 
> This would indeed work, but CurrentEL is hardly an ID register. I feel
> slightly uncomfortable using read_cpuid (which might return a cached
> version at some point) for random system registers.
> 
> Thoughts?

I have no strong feelings either way, but I agree with the general
uneasiness w.r.t. what read_cpuid can be expected to do.

Elsewhere we just use inline asm to read non CPUID system registers, so
let's leave your patch as it was.

Thanks,
Mark.
