From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 01/37] KVM: arm64: Avoid storing the vcpu pointer on the
 stack
Date: Wed, 29 Nov 2017 19:20:52 +0100
Message-ID: <20171129182052.GG10563@lvm>
References: <20171012104141.26902-1-christoffer.dall@linaro.org>
 <20171012104141.26902-2-christoffer.dall@linaro.org>
 <ef4bffe5-b3c5-5fdd-cb8b-1840d2243ae1@arm.com>
 <20171123205902.GF28855@cbox> <5A1BF2D8.1050907@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89EED49D75
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 13:18:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3btyQLquQ8XI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Nov 2017 13:18:02 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3FF2149D6C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 13:18:02 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id v19so7807634wmh.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Nov 2017 10:20:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <5A1BF2D8.1050907@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On Mon, Nov 27, 2017 at 11:11:20AM +0000, James Morse wrote:
> On 23/11/17 20:59, Christoffer Dall wrote:
> > On Thu, Oct 12, 2017 at 04:49:44PM +0100, Marc Zyngier wrote:
> >> On 12/10/17 11:41, Christoffer Dall wrote:
> >>> We already have the percpu area for the host cpu state, which points to
> >>> the VCPU, so there's no need to store the VCPU pointer on the stack on
> >>> every context switch.  We can be a little more clever and just use
> >>> tpidr_el2 for the percpu offset and load the VCPU pointer from the host
> >>> context.
> >>>
> >>> This requires us to have a scratch register though, so we take the
> >>> chance to rearrange some of the el1_sync code to only look at the
> >>> vttbr_el2 to determine if this is a trap from the guest or an HVC from
> >>> the host.  We do add an extra check to call the panic code if the kernel
> >>> is configured with debugging enabled and we saw a trap from the host
> >>> which wasn't an HVC, indicating that we left some EL2 trap configured by
> >>> mistake.
> 
> >>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> >>> index ab4d0a9..7e48a39 100644
> >>> --- a/arch/arm64/include/asm/kvm_asm.h
> >>> +++ b/arch/arm64/include/asm/kvm_asm.h
> >>> @@ -70,4 +70,24 @@ extern u32 __init_stage2_translation(void);
> >>>  
> >>>  #endif
> >>>  
> >>> +#ifdef __ASSEMBLY__
> >>> +.macro get_host_ctxt reg, tmp
> >>> +	/*
> >>> +	 * '=kvm_host_cpu_state' is a host VA from the constant pool, it may
> >>> +	 * not be accessible by this address from EL2, hyp_panic() converts
> >>> +	 * it with kern_hyp_va() before use.
> >>> +	 */
> >>
> >> This really looks like a stale comment, as there is no hyp_panic
> >> involved here anymore (thankfully!).
> >>
> >>> +	ldr	\reg, =kvm_host_cpu_state
> >>> +	mrs	\tmp, tpidr_el2
> >>> +	add	\reg, \reg, \tmp
> 
> This looks like the arch code's adr_this_cpu.
> 
> 
> >>> +	kern_hyp_va \reg
> >>
> >> Here, we're trading a load from the stack for a load from the constant
> >> pool. Can't we do something like:
> >>
> >> 	adr_l	\reg, kvm_host_cpu_state
> >> 	msr	\tmp, tpidr_el2
> >> 	add	\reg, \reg, \tmp
> >>
> >> and that's it? This relies on the property that the kernel/hyp offset is
> >> constant, and that it doesn't matter if we add the offset to a kernel VA
> >> or a HYP VA... Completely untested of course!
> >>
> > 
> > Coming back to this one, annoyingly, it doesn't seem to work. 
> 
> The disassembly looks wrong?, or it generates the wrong address?
> 

The assembly above was just something Marc suggested.  I think it's
wrong (it's should be mrs, not msr in the second line), but I just took
it as inspiration, so that's not part of the problem at hand.  Sorry for
the confusion.

> 
> > This is the code I use for get_host_ctxt:
> > 
> > .macro get_host_ctxt reg, tmp
> > 	adr_l	\reg, kvm_host_cpu_state
> > 	mrs	\tmp, tpidr_el2
> > 	add	\reg, \reg, \tmp
> 
> (adr_this_cpu)
> 
> > 	kern_hyp_va \reg
> 
> As we know adr_l used adrp to generate a PC-relative address, when executed at
> EL2 it should always generate an EL2 address, so the kern_hyp_va will just mask
> out some bits that are already zero.

yes, that's right

> 
> (this subtly depends on KVM's EL2 code not being a module, and
> kvm_host_cpu_state not being percpu_alloc()d)
> 
> 

yes, and I have your "KVM: arm/arm64: Convert kvm_host_cpu_state to a
static per-cpu allocation" patch.

> > .endm
> > 
> > And this is the disassembly for one of the uses in the hyp code:
> > 
> > 	adrp	x0, ffff000008ca9000 <overflow_stack+0xd20>
> > 	add	x0, x0, #0x7f0
> > 	mrs	x1, tpidr_el2
> > 	add	x0, x0, x1
> > 	and	x0, x0, #0xffffffffffff
> 
> (that looks right to me).
> 
> 

to me too, but it doesn't work :(

> > For comparison, the following C-code:
> > 
> > 	struct kvm_cpu_context *host_ctxt;
> > 	host_ctxt = this_cpu_ptr(&kvm_host_cpu_state);
> > 	host_ctxt = kern_hyp_va(host_ctxt);
> > 
> > Gets compiled into this:
> > 
> > 	adrp	x0, ffff000008ca9000 <overflow_stack+0xd20>
> > 	add	x0, x0, #0x7d0
> > 	mrs	x1, tpidr_el1
> > 	add	x0, x0, #0x20
> > 	add	x0, x0, x1
> > 	and	x0, x0, #0xffffffffffff
> 
> > Any ideas what could be going on here?
> 
> You expected tpidr_el2 in the above disassembly?

No, because I'm not on a VHE host, but I expect tpidr_el1 and tpidr_el2
to be the same in the hyp code.

I now realize that I never said that this breaks on a non-VHE host, I
haven't actually tried a VHE host, but it shouldn't matter.

> 
> The patch 'arm64: alternatives: use tpidr_el2 on VHE hosts'[0] wraps the tpidr
> access in adr_this_cpu,ldr_this_cpu and __my_cpu_offset() in
> ARM64_HAS_VIRT_HOST_EXTN alternatives.
> 
> You should have an altinstr_replacement section that contains the 'mrs x1,
> tpidr_el2' for this sequence, which will get patched in by the cpufeature code
> when we find VHE.
> 

Yes, I think all that is fine.

> 
> I'm guessing you want to always use tpidr_el2 as cpu_offset for KVM, even on
> v8.0 hardware. To do this you can't use the kernel's 'this_cpu_ptr' as its
> defined in percpu-defs.h as:
> > SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
> 
> ... and the arch code provides a static-inline 'my_cpu_offset' that resolves to
> the correct tpidr for EL1.
> 
> I guess you need an asm-accessor for each per-cpu variable you want to access,
> or a kvm_this_per_cpu().
> 

I was under the impression that we were essentially open-coding this
functionality with the assembly above.  What did I miss?

> 
> > And, during hyp init we do:
> > 	mrs	x1, tpidr_el1
> > 	msr	tpidr_el2, x1
> 
> In the SDEI series this was so that the asm that used tpidr_el2 directly had the
> correct value on non-VHE hardware.
> 
> 
Yes, and I simply generalized that bit of assembly (the hyp panic logic)
which also needed the vcpu context to all the assembly that needs the
vcpu context.

And it works fine with a load from the constant pool and the mask, but
not with the open-coded this_cpu_ptr() at EL2.  On a non-VHE system.
Even though the assembly seems identical, and it should just work (TM).

Thoughts?

Thanks,
-Christoffer
