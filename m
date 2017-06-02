From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC 07/55] KVM: arm/arm64: Add virtual EL2 state emulation
 framework
Date: Fri, 2 Jun 2017 13:51:40 +0200
Message-ID: <20170602115140.GB397@cbox>
References: <1483943091-1364-1-git-send-email-jintack@cs.columbia.edu>
 <1483943091-1364-8-git-send-email-jintack@cs.columbia.edu>
 <jpg37bj1nj6.fsf@linux.bootlegged.copy>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48D3040C56
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 07:48:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LqdFN-M+kkBh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Jun 2017 07:47:58 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD33A40625
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Jun 2017 07:47:58 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id b84so22964643wmh.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 02 Jun 2017 04:51:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <jpg37bj1nj6.fsf@linux.bootlegged.copy>
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

On Thu, Jun 01, 2017 at 04:05:49PM -0400, Bandan Das wrote:
> Jintack Lim <jintack@cs.columbia.edu> writes:
> ...
> > +/**
> > + * kvm_arm_setup_shadow_state -- prepare shadow state based on emulated mode
> > + * @vcpu: The VCPU pointer
> > + */
> > +void kvm_arm_setup_shadow_state(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> > +
> > +	ctxt->hw_pstate = *vcpu_cpsr(vcpu);
> > +	ctxt->hw_sys_regs = ctxt->sys_regs;
> > +	ctxt->hw_sp_el1 = ctxt->gp_regs.sp_el1;
> > +}
> > +
> > +/**
> > + * kvm_arm_restore_shadow_state -- write back shadow state from guest
> > + * @vcpu: The VCPU pointer
> > + */
> > +void kvm_arm_restore_shadow_state(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> > +
> > +	*vcpu_cpsr(vcpu) = ctxt->hw_pstate;
> > +	ctxt->gp_regs.sp_el1 = ctxt->hw_sp_el1;
> > +}
> > +
> > +void kvm_arm_init_cpu_context(kvm_cpu_context_t *cpu_ctxt)
> > +{
> > +	cpu_ctxt->hw_sys_regs = &cpu_ctxt->sys_regs[0];
> > +}
> 
> 
> IIUC, the *_shadow_state() functions will set hw_* pointers to
> either point to the "real" state or the shadow state to manage L2 ?
> Maybe, it might make sense to make these function names a little more
> generic since they are not dealing with setting the shadow state
> alone.
> 

The notion of 'shadow state' is borrowed from shadow page tables, in
which you always load some 'shadow copy' of the 'real value' into the
hardware, so the shadow state is the one that's used for execution by
the hardware.

The shadow state may be the same as the VCPU's EL1 state, for example,
or it may be a modified version of the VCPU's EL2 state, for example.

If you have better suggestions for naming, we're open to that though.

Thanks,
-Christoffer
