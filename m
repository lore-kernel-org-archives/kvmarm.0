From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 09/11] KVM: arm/arm64: use vcpu requests for irq
 injection
Date: Thu, 1 Jun 2017 12:59:21 +0200
Message-ID: <20170601105921.ggkuxft6nb32yio5@kamzik.brq.redhat.com>
References: <20170516022035.7674-1-drjones@redhat.com>
 <20170516022035.7674-10-drjones@redhat.com>
 <20170601103533.GI20919@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601103533.GI20919@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 12:35:33PM +0200, Christoffer Dall wrote:
> On Tue, May 16, 2017 at 04:20:33AM +0200, Andrew Jones wrote:
> > Don't use request-less VCPU kicks when injecting IRQs, as a VCPU
> > kick meant to trigger the interrupt injection could be sent while
> > the VCPU is outside guest mode, which means no IPI is sent, and
> > after it has called kvm_vgic_flush_hwstate(), meaning it won't see
> > the updated GIC state until its next exit some time later for some
> > other reason.  The receiving VCPU only needs to check this request
> > in VCPU RUN to handle it.  By checking it, if it's pending, a
> > memory barrier will be issued that ensures all state is visible.
> > We still create a vcpu_req_irq_pending() function (which is a nop),
> > though, in order to allow us to use the standard request checking
> > pattern.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   |  1 +
> >  arch/arm64/include/asm/kvm_host.h |  1 +
> >  virt/kvm/arm/arm.c                | 12 ++++++++++++
> >  virt/kvm/arm/vgic/vgic.c          |  9 +++++++--
> >  4 files changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index fdd644c01c89..00ad56ee6455 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -46,6 +46,7 @@
> >  
> >  #define KVM_REQ_SLEEP \
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> >  
> >  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
> >  int __attribute_const__ kvm_target_cpu(void);
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 9bd0d1040de9..0c4fd1f46e10 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -43,6 +43,7 @@
> >  
> >  #define KVM_REQ_SLEEP \
> >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> >  
> >  int __attribute_const__ kvm_target_cpu(void);
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index ddc833987dfb..73a75ca91e41 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -570,6 +570,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> >  	}
> >  }
> >  
> > +static void vcpu_req_irq_pending(struct kvm_vcpu *vcpu)
> > +{
> > +	/*
> > +	 * Nothing to do here. kvm_check_request() already issued a memory
> > +	 * barrier that pairs with kvm_make_request(), so all hardware state
> > +	 * we need to flush should now be visible.
> > +	 */
> 
> I don't understand this comment :(

We need a kvm_check_request() to pair with a requesting VCPU's setting
of virtual irq state and call of kvm_make_request(). The requester's
kvm_make_request() ensures the target VCPU executes VCPU RUN, and the
barriers wrapped in kvm_check/make_request() ensure that when VCPU RUN
calls kvm_vgic_flush_hwstate() that the virtual irq state set by the
requester is visible to the target VCPU.

But you knew all that already :-) So, maybe I just need to replace
'all hardware state we need to flush should now be visible.' with
'the virtual irq state is now visible.'?

> 
> And I don't much like this empty function either.
> 
> 
> > +}
> > +
> >  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> >  {
> >  	return vcpu->arch.target >= 0;
> > @@ -580,6 +589,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> >  	if (kvm_request_pending(vcpu)) {
> >  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> >  			vcpu_req_sleep(vcpu);
> > +		if (kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu))
> > +			vcpu_req_irq_pending(vcpu);
> 
> 
> Can we just do:
> 		/* 
> 		 * Clear IRQ_PENDING requests that were made to
> 		 * guarantee that a VCPU sees new virtual interrupts.
> 		 */
> 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
> 
> ?

I won't insist, but I prefer the empty function to breaking the pattern
of this if-sequence, and also to the calling of a function named "check"
without considering its return value.

> 
> >  	}
> >  }
> >  
> > @@ -771,6 +782,7 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
> >  	 * trigger a world-switch round on the running physical CPU to set the
> >  	 * virtual IRQ/FIQ fields in the HCR appropriately.
> >  	 */
> > +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> >  	kvm_vcpu_kick(vcpu);
> >  
> >  	return 0;
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index aea080a2c443..c66feaca2a5d 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -286,8 +286,10 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
> >  		 * won't see this one until it exits for some other
> >  		 * reason.
> >  		 */
> > -		if (vcpu)
> > +		if (vcpu) {
> > +			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> >  			kvm_vcpu_kick(vcpu);
> > +		}
> >  		return false;
> >  	}
> >  
> > @@ -333,6 +335,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
> >  	spin_unlock(&irq->irq_lock);
> >  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >  
> > +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> >  	kvm_vcpu_kick(vcpu);
> >  
> >  	return true;
> > @@ -722,8 +725,10 @@ void vgic_kick_vcpus(struct kvm *kvm)
> >  	 * a good kick...
> >  	 */
> >  	kvm_for_each_vcpu(c, vcpu, kvm) {
> > -		if (kvm_vgic_vcpu_pending_irq(vcpu))
> > +		if (kvm_vgic_vcpu_pending_irq(vcpu)) {
> > +			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
> >  			kvm_vcpu_kick(vcpu);
> > +		}
> >  	}
> >  }
> >  
> > -- 
> > 2.9.3
> > 
> Otherwise:
> 
> Reviewed-by: Christoffer Dall <cdall@linaro.org>

Thanks,
drew
