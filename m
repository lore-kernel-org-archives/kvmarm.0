From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: kvm_arch_vcpu_runnable: don't miss
 injected irqs
Date: Wed, 18 Oct 2017 14:13:05 +0200
Message-ID: <20171018121305.imlyjg7tssfjqc53@kamzik.brq.redhat.com>
References: <20170929113041.24371-1-drjones@redhat.com>
 <20170929113041.24371-6-drjones@redhat.com>
 <20171014191335.GD1929@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7A5E40795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 08:12:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HytAJw1xiV2m for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 08:12:08 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3D8C406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 08:12:08 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20171014191335.GD1929@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Sat, Oct 14, 2017 at 09:13:35PM +0200, Christoffer Dall wrote:
> On Fri, Sep 29, 2017 at 01:30:41PM +0200, Andrew Jones wrote:
> > When the vPMU is in use if a VCPU's perf event overflow handler
> > were to fire after the VCPU started waiting, then the wake up
> > done by the kvm_vcpu_kick() call in the handler would do nothing,
> > as no "pmu overflow" state is checked in kvm_arch_vcpu_runnable().
> > Fix this by checking the IRQ_PENDING VCPU request in runnable().
> > Checking the request also sufficiently covers all the cases that
> > kvm_vgic_vcpu_pending_irq() cover, so we can just replace that.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  virt/kvm/arm/arm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 5bc9b0d2fd0f..725527f491e4 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -423,7 +423,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
> >  	return !vcpu_should_sleep(vcpu) &&
> >  	       (vcpu->arch.mp_state != KVM_MP_STATE_HALTED ||
> >  		(!!vcpu->arch.irq_lines ||
> > -		 kvm_vgic_vcpu_pending_irq(vcpu)));
> > +		 kvm_test_request(KVM_REQ_IRQ_PENDING, vcpu)));
> 
> So what if a VCPU blocks, a device raises an IRQ, the VCPU loops around,
> clears the KVM_REQ_IRQ_PENDING flag, enters the VM again, which does
> another WFI (for fun), and you end up here again with a pending IRQ but
> no KVM_REQ_IRQ_PENDING flag anymore.  Doesn't this end up incorrectly
> stalling the VCPU?

Hmm, I see what you mean. I'm sorry I missed that.

> 
> I don't think that a transient flag will work for a persistent binary
> state here.

I think we can fix it by adding

 if (kvm_vgic_vcpu_pending_irq(vcpu))
     kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);

to kvm_vgic_sync_hwstate(), if the additional overhead would be
acceptable. Otherwise we need to find some other way to ensure
vPMU irqs unblock the VCPU.

> 
> 
> >  }
> >  
> >  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> > -- 
> > 2.13.5
> > 
> 
> 
> Thanks,
> -Christoffer

Thanks,
drew
