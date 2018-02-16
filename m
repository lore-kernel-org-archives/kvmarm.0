From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 10/19] KVM: arm/arm64: Do not use kern_hyp_va() with
 kvm_vgic_global_state
Date: Fri, 16 Feb 2018 10:05:43 +0100
Message-ID: <20180216090543.GC10440@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-11-marc.zyngier@arm.com>
 <20180115153632.GK21403@cbox>
 <af5ddd03-ddaa-0fe9-51ec-4946b5adfe1c@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <af5ddd03-ddaa-0fe9-51ec-4946b5adfe1c@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Feb 15, 2018 at 01:22:56PM +0000, Marc Zyngier wrote:
> On 15/01/18 15:36, Christoffer Dall wrote:
> > On Thu, Jan 04, 2018 at 06:43:25PM +0000, Marc Zyngier wrote:
> >> kvm_vgic_global_state is part of the read-only section, and is
> >> usually accessed using a PC-relative address generation (adrp + add).
> >>
> >> It is thus useless to use kern_hyp_va() on it, and actively problematic
> >> if kern_hyp_va() becomes non-idempotent. On the other hand, there is
> >> no way that the compiler is going to guarantee that such access is
> >> always be PC relative.
> > 
> > nit: is always be
> > 
> >>
> >> So let's bite the bullet and provide our own accessor.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  arch/arm/include/asm/kvm_hyp.h   | 6 ++++++
> >>  arch/arm64/include/asm/kvm_hyp.h | 9 +++++++++
> >>  virt/kvm/arm/hyp/vgic-v2-sr.c    | 4 ++--
> >>  3 files changed, 17 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
> >> index ab20ffa8b9e7..1d42d0aa2feb 100644
> >> --- a/arch/arm/include/asm/kvm_hyp.h
> >> +++ b/arch/arm/include/asm/kvm_hyp.h
> >> @@ -26,6 +26,12 @@
> >>  
> >>  #define __hyp_text __section(.hyp.text) notrace
> >>  
> >> +#define hyp_symbol_addr(s)						\
> >> +	({								\
> >> +		typeof(s) *addr = &(s);					\
> >> +		addr;							\
> >> +	})
> >> +
> >>  #define __ACCESS_VFP(CRn)			\
> >>  	"mrc", "mcr", __stringify(p10, 7, %0, CRn, cr0, 0), u32
> >>  
> >> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> >> index 08d3bb66c8b7..a2d98c539023 100644
> >> --- a/arch/arm64/include/asm/kvm_hyp.h
> >> +++ b/arch/arm64/include/asm/kvm_hyp.h
> >> @@ -25,6 +25,15 @@
> >>  
> >>  #define __hyp_text __section(.hyp.text) notrace
> >>  
> >> +#define hyp_symbol_addr(s)						\
> >> +	({								\
> >> +		typeof(s) *addr;					\
> >> +		asm volatile("adrp	%0, %1\n"			\
> >> +			     "add	%0, %0, :lo12:%1\n"		\
> >> +			     : "=r" (addr) : "S" (&s));			\
> > 
> > Can't we use adr_l here?
> 
> Unfortunately not. All the asm/assembler.h macros are unavailable to
> inline assembly. We could start introducing equivalent macros for that
> purpose, but that's starting to be outside of the scope of this series.
> 

Absolutely.  Forget I asked.

> > 
> >> +		addr;							\
> >> +	})
> >> +
> > 
> > I don't fully appreciate the semantics of this macro going by its name
> > only.  My understanding is that if you want to resolve a symbol to an
> > address which is mapped in hyp, then use this.  Is this correct?
> 
> The goal of this macro is to return a symbol's address based on a
> PC-relative computation, as opposed to a loading the VA from a constant
> pool or something similar. This works well for HYP, as an absolute VA is
> guaranteed to be wrong.
> 
> > 
> > If so, can we add a small comment (because I can't come up with a better
> > name).
> 
> I'll add the above if that works for you.
> 

Yes it does.  The only thing that remains a bit unclear is what the
difference between this and kern_hyp_va is, and when you'd choose to use
one over the other.  Perhaps we need a single place which documents our
primitives and tells us what to use when.  At least, I'm for sure not
going to be able to figure this out later on.


Thanks,
-Christoffer
