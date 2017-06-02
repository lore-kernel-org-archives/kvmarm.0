From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 07/55] KVM: arm/arm64: Add virtual EL2 state emulation
 framework
Date: Fri, 2 Jun 2017 21:06:22 +0200
Message-ID: <20170602190622.GF397@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-8-git-send-email-jintack@cs.columbia.edu>
 <jpg37bj1nj6.fsf@linux.bootlegged.copy> <20170602115140.GB397@cbox>
 <jpg8tlal2aw.fsf@linux.bootlegged.copy>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB01140C26
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 15:02:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yaioXTP7NRK2 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 15:02:39 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FE494095A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 15:02:39 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id d127so33791905wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Jun 2017 12:06:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <jpg8tlal2aw.fsf@linux.bootlegged.copy>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Bandan Das <bsd@redhat.com>
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, will.deacon@arm.com, shihwei@cs.columbia.edu, lorenzo.pieralisi@arm.com, linux@armlinux.org.uk, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, andre.przywara@arm.com, kevin.brodsky@arm.com, wcohen@redhat.com, anna-maria@linutronix.de, geoff@infradead.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jun 02, 2017 at 01:36:23PM -0400, Bandan Das wrote:
> Christoffer Dall <cdall@linaro.org> writes:
> 
> > On Thu, Jun 01, 2017 at 04:05:49PM -0400, Bandan Das wrote:
> >> Jintack Lim <jintack@cs.columbia.edu> writes:
> >> ...
> >> > +/**
> >> > + * kvm_arm_setup_shadow_state -- prepare shadow state based on emulated mode
> >> > + * @vcpu: The VCPU pointer
> >> > + */
> >> > +void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
> >> > +{
> >> > +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> >> > +
> >> > +	ctxt->hw_pstate = *vcpu_cpsr(vcpu);
> >> > +	ctxt->hw_sys_regs = ctxt->sys_regs;
> >> > +	ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
> >> > +}
> >> > +
> >> > +/**
> >> > + * kvm_arm_restore_shadow_state -- write back shadow state from guest
> >> > + * @vcpu: The VCPU pointer
> >> > + */
> >> > +void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
> >> > +{
> >> > +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> >> > +
> >> > +	*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
> >> > +	ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
> >> > +}
> >> > +
> >> > +void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt)
> >> > +{
> >> > +	cpu_ctxt->hw_sys_regs = &cpu_ctxt->sys_regs[0];
> >> > +}
> >> 
> >> 
> >> IIUC, the *_shadow_state() functions will set hw_* pointers to
> >> either point to the "real" state or the shadow state to manage L2 ?
> >> Maybe, it might make sense to make these function names a little more
> >> generic since they are not dealing with setting the shadow state
> >> alone.
> >> 
> >
> > The notion of 'shadow state' is borrowed from shadow page tables, in
> > which you always load some 'shadow copy' of the 'real value' into the
> > hardware, so the shadow state is the one that's used for execution by
> > the hardware.
> >
> > The shadow state may be the same as the VCPU's EL1 state, for example,
> > or it may be a modified version of the VCPU's EL2 state, for example.
> 
> Yes, it can be the same. Although, as you said above, "shadow" conventionally
> refers to the latter.

That's not what I said.  I said shadow is the thing you use in the
hardware, which may be the same, and may be something different.  The
important point being, that it is what gets used by the hardware, and
that it's decoupled, not necessarily different, from the virtual
state.

> When it's pointing to EL1 state, it's not really
> shadow state anymore.
> 

You can argue it both ways, in the end, all that's important is whether
or not it's clear what the functions do.

> > If you have better suggestions for naming, we're open to that though.
> >
> 
> Oh nothing specifically, I just felt like "shadow" in the function name
> could be confusing. Borrowing from kvm_arm_init_cpu_context(), 
> how about kvm_arm_setup/restore_cpu_context()  ?

I have no objection to these names.

> 
> BTW, on a separate note, we might as well get away with the typedef and
> call struct kvm_cpu_context directly.
> 
I don't think it's worth changing the code just for that, but if you
feel it's a significant cleanup, you can send a patch with a good
argument for why it's worth changing in the commit message.

Thanks,
-Christoffer
