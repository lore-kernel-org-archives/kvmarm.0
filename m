From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 01/37] KVM: arm64: Avoid storing the vcpu pointer on the
 stack
Date: Thu, 23 Nov 2017 21:59:02 +0100
Message-ID: <20171123205902.GF28855@cbox>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-2-christoffer.dall@linaro.org>
 <ef4bffe5-b3c5-5fdd-cb8b-1840d2243ae1@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ef4bffe5-b3c5-5fdd-cb8b-1840d2243ae1@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On Thu, Oct 12, 2017 at 04:49:44PM +0100, Marc Zyngier wrote:
> On 12/10/17 11:41, Christoffer Dall wrote:
> > We already have the percpu area for the host cpu state, which points to
> > the VCPU, so there's no need to store the VCPU pointer on the stack on
> > every context switch.  We can be a little more clever and just use
> > tpidr_el2 for the percpu offset and load the VCPU pointer from the host
> > context.
> > 
> > This requires us to have a scratch register though, so we take the
> > chance to rearrange some of the el1_sync code to only look at the
> > vttbr_el2 to determine if this is a trap from the guest or an HVC from
> > the host.  We do add an extra check to call the panic code if the kernel
> > is configured with debugging enabled and we saw a trap from the host
> > which wasn't an HVC, indicating that we left some EL2 trap configured by
> > mistake.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  arch/arm64/include/asm/kvm_asm.h | 20 ++++++++++++++++++++
> >  arch/arm64/kernel/asm-offsets.c  |  1 +
> >  arch/arm64/kvm/hyp/entry.S       |  5 +----
> >  arch/arm64/kvm/hyp/hyp-entry.S   | 39 ++++++++++++++++++---------------------
> >  arch/arm64/kvm/hyp/switch.c      |  2 +-
> >  5 files changed, 41 insertions(+), 26 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> > index ab4d0a9..7e48a39 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -70,4 +70,24 @@ extern u32 __init_stage2_translation(void);
> >  
> >  #endif
> >  
> > +#ifdef __ASSEMBLY__
> > +.macro get_host_ctxt reg, tmp
> > +	/*
> > +	 * '=kvm_host_cpu_state' is a host VA from the constant pool, it may
> > +	 * not be accessible by this address from EL2, hyp_panic() converts
> > +	 * it with kern_hyp_va() before use.
> > +	 */
> 
> This really looks like a stale comment, as there is no hyp_panic
> involved here anymore (thankfully!).
> 
> > +	ldr	\reg, =kvm_host_cpu_state
> > +	mrs	\tmp, tpidr_el2
> > +	add	\reg, \reg, \tmp
> > +	kern_hyp_va \reg
> 
> Here, we're trading a load from the stack for a load from the constant
> pool. Can't we do something like:
> 
> 	adr_l	\reg, kvm_host_cpu_state
> 	msr	\tmp, tpidr_el2
> 	add	\reg, \reg, \tmp
> 
> and that's it? This relies on the property that the kernel/hyp offset is
> constant, and that it doesn't matter if we add the offset to a kernel VA
> or a HYP VA... Completely untested of course!
> 

Coming back to this one, annoyingly, it doesn't seem to work.  This is
the code I use for get_host_ctxt:

.macro get_host_ctxt reg, tmp
	adr_l	\reg, kvm_host_cpu_state
	mrs	\tmp, tpidr_el2
	add	\reg, \reg, \tmp
	kern_hyp_va \reg
.endm

And this is the disassembly for one of the uses in the hyp code:

	adrp	x0, ffff000008ca9000 <overflow_stack+0xd20>
	add	x0, x0, #0x7f0
	mrs	x1, tpidr_el2
	add	x0, x0, x1
	and	x0, x0, #0xffffffffffff
	
For comparison, the following C-code:

	struct kvm_cpu_context *host_ctxt;
	host_ctxt = this_cpu_ptr(&kvm_host_cpu_state);
	host_ctxt = kern_hyp_va(host_ctxt);

Gets compiled into this:

	adrp	x0, ffff000008ca9000 <overflow_stack+0xd20>
	add	x0, x0, #0x7d0
	mrs	x1, tpidr_el1
	add	x0, x0, #0x20
	add	x0, x0, x1
	and	x0, x0, #0xffffffffffff

And, during hyp init we do:
	mrs	x1, tpidr_el1
	msr	tpidr_el2, x1

Any ideas what could be going on here?

Thanks,
-Christoffer
