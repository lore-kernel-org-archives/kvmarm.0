From: Christoffer Dall <cdall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/11] KVM: arm64: Store vcpu on the stack during
 __guest_enter()
Date: Wed, 9 Aug 2017 10:48:09 +0200
Message-ID: <20170809084809.GA16705@cbox>
References: <20170515174400.29735-1-james.morse@arm.com>
 <20170515174400.29735-2-james.morse@arm.com>
 <20170606195951.GN9464@cbox>
 <5989EB5D.6@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5989EB5D.6-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 08, 2017 at 05:48:29PM +0100, James Morse wrote:
> Hi Christoffer,
> 
> On 06/06/17 20:59, Christoffer Dall wrote:
> > On Mon, May 15, 2017 at 06:43:49PM +0100, James Morse wrote:
> >> KVM uses tpidr_el2 as its private vcpu register, which makes sense for
> >> non-vhe world switch as only KVM can access this register. This means
> >> vhe Linux has to use tpidr_el1, which KVM has to save/restore as part
> >> of the host context.
> >>
> >> __guest_enter() stores the host_ctxt on the stack, do the same with
> >> the vcpu.
> 
> >> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> >> index 12ee62d6d410..113735df7d01 100644
> >> --- a/arch/arm64/kvm/hyp/entry.S
> >> +++ b/arch/arm64/kvm/hyp/entry.S
> >> @@ -159,9 +159,15 @@ abort_guest_exit_end:
> >>  ENDPROC(__guest_exit)
> >>  
> >>  ENTRY(__fpsimd_guest_restore)
> >> +	// x0: esr
> >> +	// x1: vcpu
> >> +	// x2-x29,lr: vcpu regs
> >> +	// vcpu x0-x1 on the stack
> >>  	stp	x2, x3, [sp, #-16]!
> >>  	stp	x4, lr, [sp, #-16]!
> >>  
> >> +	mov	x3, x1
> >> +
> > 
> > nit: can you avoid this by using x1 for the vcpu pointer in this routine
> > instead?
> 
> Unfortunately x1 is clobbered by the __fpsimd_{save,restore}_state() macros that
> are called further down this function.
> 
> (its a bit obscure:
> > fpsimd_save	x0, 1
> that '1' is used to generate 'x1' or 'w1' in includes/asm/fpsimdmacros.h)
> 

Ah, I guess I missed that.

Thanks,
-Christoffer
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
