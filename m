From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: kvm_arch_vcpu_runnable: don't miss
 injected irqs
Date: Tue, 10 Oct 2017 15:28:12 +0200
Message-ID: <20171010132812.hsfvhkuw7eer2r6m@kamzik.brq.redhat.com>
References: <20170929113041.24371-1-drjones@redhat.com>
 <20170929113041.24371-6-drjones@redhat.com>
 <f94ab402-e108-baf7-1d4f-9e465a5b0f7f@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4026449D37
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 09:27:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NaXl-aVCTiDH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 Oct 2017 09:27:37 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D2AF49D2C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 Oct 2017 09:27:37 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <f94ab402-e108-baf7-1d4f-9e465a5b0f7f@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: cdall@linaro.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Oct 05, 2017 at 10:37:32AM +0100, Marc Zyngier wrote:
> On 29/09/17 12:30, Andrew Jones wrote:
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
> >  }
> >  
> >  bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
> > 
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> On a side note, I just had a look at our usage of KVM_REQ_IRQ_PENDING,
> and we always seem to have a make_request/kick pair (which definitely
> makes sense). Maybe there is room for a bit of consolidation there too.

I think Radim had a plan to do that with some more VCPU request cleanups.

Thanks,
drew

> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
