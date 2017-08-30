From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: stop propagating DAIF flags between kernel
 and VHE's world switch
Date: Wed, 30 Aug 2017 10:33:17 +0200
Message-ID: <20170830083317.GB24522@cbox>
References: <20170810113021.1110-1-james.morse@arm.com>
 <20170824152304.GB2150@lvm> <59A5A021.1090102@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C7FB40FAE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 04:31:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id boIj9KtRMxcp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Aug 2017 04:31:07 -0400 (EDT)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B204C40A80
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 04:31:07 -0400 (EDT)
Received: by mail-wm0-f50.google.com with SMTP id a80so5309914wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 01:33:19 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <59A5A021.1090102@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 29, 2017 at 06:10:57PM +0100, James Morse wrote:
> Hi Christoffer,
> 
> 
> (I suspect I'm using some term differently here ...)
> 
> On 24/08/17 16:23, Christoffer Dall wrote:
> > On Thu, Aug 10, 2017 at 12:30:21PM +0100, James Morse wrote:
> >> KVM calls __kvm_vcpu_run() in a loop with interrupts masked for the
> >> duration of the call. On a non-vhe system we HVC to EL2 and the
> >> host DAIF flags are save/restored via the SPSR.
> >>
> >> On a system with vhe, we branch to the EL2 code because the kernel
> >> also runs at EL2. This means the other kernel DAIF flags propagate into
> >> KVMs EL2 code.
> >>
> >> The same happens in reverse, we take an exception to exit the guest
> >> and all the flags are masked. __guest_exit() unmasks SError, and we
> >> return with these flags through world switch and back into the host
> >> kernel. KVM unmasks interrupts as part of its __kvm_vcpu_run(), but
> > 
> > when does KVM unmask interrupts as part of the __kvm_vcpu_run()?  Do you
> > mean kvm_arch_vcpu_ioctl_run() ?
> 
> Oops, yes, I meant kvm_arch_vcpu_ioctl_run().
> 
> 
> >> debug exceptions remain disabled due to the guest exit exception,
> >> (as does SError: today this is the only time SError is unmasked in the
> >> kernel). The flags stay in this state until we return to userspace.
> >>
> >> We have a __vhe_hyp_call() function that does the isb that we implicitly
> >> have on non-vhe systems, add the DAIF save/restore here, instead of in
> >> __sysreg_{save,restore}_host_state() which would require an extra isb()
> >> between the hosts VBAR_EL1 being restored and DAIF being restored.
> 
> > This also means that anyone else calling kvm_call_hyp(), which we are
> > beginning to do more often, would also do this save/restore which
> > shouldn't really be necessary, doesn't it?
> 
> I think it is, its done implicitly via SPSR_EL2 by the HVC/ERET on non-VHE.
> Does the HYP code on the other end of kvm_call_hyp() expect to be called with
> DAIF masked? What about the other way, if the HYP code modifies the DAIF flags
> should that spread back into the kernel?

Well, for VHE I don't think this is any different than any other
function.  There really is no concept of 'hyp code' --- or we should aim
for there not to be --- with VHE, so if some code expects interrupts
disabled or other changes to the DAIF flags, that code should really do
that for VHE.

The rationale being that in the long run we want to keep "jumping to
hyp" the oddball legacy case, where everything else is just the
kernel/hypervisor functionality.

> 
> Today this behaviour differs depending on whether we have VHE.
> 
> I think KVM expects its HYP code to be called with DAIF masked, (e.g. there is
> no explicit mask of debug before save/restoring MDSCR_EL1).

I think this is different for the world-switch code and the hyp code.  I
think we need a VHE-only call that masks debug exceptions before messing
with the execution context.

> 
> I'll argue all kvm_call_hyp() users expect the code be called at HYP with DAIF
> masked, as if we just took an HVC. On return the flags should be restored as
> they would with an ERET.

We could make that call, and say that kvm_call_hyp() semantically means
either "jump to special EL2 mode with the CPU configued as done when
taking an exception" or "change the current CPU mode to something that
looks like having just taken an exception and run code".  I think the
latter is a bit contrived, and we will quickly have some hidden
assumptions in our code.

I think if we have something like this:

    invalidate_vm_tlb_vhe()
    {
        local_irq_disable();
	mask_debug();
	asm("..."); /* flush stuff */
        unmask_debug();
	local_irq_enable();
    }

    invalidate_vm_tlb_nvhe()
    {
        kvm_call_hyp(__hyp_flush_stuff);
    }

    if (has_vhe())
        invalidate_vm_tlb_vhe();
    else 
    	invalidate_vm_tlb_nvhe();


It becomes more clear what our expectations are.  If we really wanted,
and we have the need to mask a certain set of exceptions, then we could
create a wrapper for that in the VHE case.

Have we actually looked at the places where we call kvm_call_hyp() and
do they require a different setting of the DAIF flags from other kernel
code running at EL2 with VHE ?


> 
> On VHE we are already at EL2 so we don't have HVC's DAIF-masking behaviour.
> 
> 
> > Also, I can't really see why we need to save/restore this.  We are
> > 'entering the kernel' similarly to entering the kernel from user space.
> 
> (I'm lost here, entering KVM's HYP code from a guest, or returning to the kernel
> from KVM?)
> 
> 

My thinking was that I don't think the kernel in general (outside of
KVM) saves the kernel's DAIF flags before doing an eret to user space
and then restores them when taking an exception back into the kernel,
does it?

If it doesn't, it must mean that the kernel knows what the DAIF flags
should be when entering from a lower exception level, and I don't
immediately understand why KVM is any different?

Is there some condition that's true when running a VM from KVM which is
not true as we are about to return from user space, for example related
to how debug is configured?

> > Does the kernel/userspace boundry preserve kernel state or can we simply
> > set what the wanted state of the flags should be upon having entered the
> > kernel from EL2?
> 
> Entering KVM's HYP code from a guest is an exception so the CPU masks DAIF, KVM
> unmasks SError, world-switches back to the host and on VHE: 'ret's to the kernel.
> 
> On VHE before kvm_call_hyp() SError was masked and Debug was enabled, on return
> SError is unmasked and Debug disabled. We can then re-schedule to some other
> task with Debug disabled.

I understand that the behavior is currently different, but what I'm
asking is, instead of having to save and restore anything to the stack,
can you simply do:

     __kvm_vcpu_run(struct kvm_vcpu *vcpu)
     {
         if (has_vhe())
             asm("msr     daifset, #0xf");

	...
        exit_code = __guest_enter(vcpu, host_ctxt);
	...

	if (has_vhe())
             asm("msr     daifclr, #0xd");
     }

(not sure about the FIQ flag - does the kernel usually 

The overall point being that we avoid a potentially unnecessary
save/restore on the stack in the critical path and we avoid potentially
unnecessary work and hidden assumptions for non-world-switch uses of
kvm_call_hyp.

Thanks,
-Christoffer
