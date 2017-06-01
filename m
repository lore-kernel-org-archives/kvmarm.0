From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 09/11] KVM: arm/arm64: use vcpu requests for irq
 injection
Date: Thu, 1 Jun 2017 15:27:16 +0200
Message-ID: <20170601132716.GL20919@cbox>
References: <20170516022035.7674-1-drjones@redhat.com>
 <20170516022035.7674-10-drjones@redhat.com>
 <20170601103533.GI20919@cbox>
 <20170601105921.ggkuxft6nb32yio5@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE35040C4B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 09:23:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zh+oWKjkXj7p for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Jun 2017 09:23:35 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A800540C07
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Jun 2017 09:23:35 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id d127so60443034wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Jun 2017 06:27:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170601105921.ggkuxft6nb32yio5@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 12:59:21PM +0200, Andrew Jones wrote:
> On Thu, Jun 01, 2017 at 12:35:33PM +0200, Christoffer Dall wrote:
> > On Tue, May 16, 2017 at 04:20:33AM +0200, Andrew Jones wrote:
> > > Don't use request-less VCPU kicks when injecting IRQs, as a VCPU
> > > kick meant to trigger the interrupt injection could be sent while
> > > the VCPU is outside guest mode, which means no IPI is sent, and
> > > after it has called kvm_vgic_flush_hwstate(), meaning it won't see
> > > the updated GIC state until its next exit some time later for some
> > > other reason.  The receiving VCPU only needs to check this request
> > > in VCPU RUN to handle it.  By checking it, if it's pending, a
> > > memory barrier will be issued that ensures all state is visible.
> > > We still create a vcpu_req_irq_pending() function (which is a nop),
> > > though, in order to allow us to use the standard request checking
> > > pattern.
> > > 
> > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > ---
> > >  arch/arm/include/asm/kvm_host.h   |  1 +
> > >  arch/arm64/include/asm/kvm_host.h |  1 +
> > >  virt/kvm/arm/arm.c                | 12 ++++++++++++
> > >  virt/kvm/arm/vgic/vgic.c          |  9 +++++++--
> > >  4 files changed, 21 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > > index fdd644c01c89..00ad56ee6455 100644
> > > --- a/arch/arm/include/asm/kvm_host.h
> > > +++ b/arch/arm/include/asm/kvm_host.h
> > > @@ -46,6 +46,7 @@
> > >  
> > >  #define KVM_REQ_SLEEP \
> > >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > > +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> > >  
> > >  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
> > >  int __attribute_const__ kvm_target_cpu(void);
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 9bd0d1040de9..0c4fd1f46e10 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -43,6 +43,7 @@
> > >  
> > >  #define KVM_REQ_SLEEP \
> > >  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > > +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
> > >  
> > >  int __attribute_const__ kvm_target_cpu(void);
> > >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> > > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > > index ddc833987dfb..73a75ca91e41 100644
> > > --- a/virt/kvm/arm/arm.c
> > > +++ b/virt/kvm/arm/arm.c
> > > @@ -570,6 +570,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
> > >  	}
> > >  }
> > >  
> > > +static void vcpu_req_irq_pending(struct kvm_vcpu *vcpu)
> > > +{
> > > +	/*
> > > +	 * Nothing to do here. kvm_check_request() already issued a memory
> > > +	 * barrier that pairs with kvm_make_request(), so all hardware state
> > > +	 * we need to flush should now be visible.
> > > +	 */
> > 
> > I don't understand this comment :(
> 
> We need a kvm_check_request() to pair with a requesting VCPU's setting
> of virtual irq state and call of kvm_make_request(). The requester's
> kvm_make_request() ensures the target VCPU executes VCPU RUN, and the
> barriers wrapped in kvm_check/make_request() ensure that when VCPU RUN
> calls kvm_vgic_flush_hwstate() that the virtual irq state set by the
> requester is visible to the target VCPU.
> 
> But you knew all that already :-) So, maybe I just need to replace
> 'all hardware state we need to flush should now be visible.' with
> 'the virtual irq state is now visible.'?
> 

Yes, the hardware state is definitely vague here, but I also feel like
you're trying to repeat parts of the documentation here, and it's better
to just refer to the complete documentation for the how the barreirs
etc. work, and just explain why you don't need to do anything, yet still
have a vcpu request.

Which is why I suggested the alternative comment below instead ;)

> > 
> > And I don't much like this empty function either.
> > 
> > 
> > > +}
> > > +
> > >  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> > >  {
> > >  	return vcpu->arch.target >= 0;
> > > @@ -580,6 +589,8 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
> > >  	if (kvm_request_pending(vcpu)) {
> > >  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> > >  			vcpu_req_sleep(vcpu);
> > > +		if (kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu))
> > > +			vcpu_req_irq_pending(vcpu);
> > 
> > 
> > Can we just do:
> > 		/* 
> > 		 * Clear IRQ_PENDING requests that were made to
> > 		 * guarantee that a VCPU sees new virtual interrupts.
> > 		 */
> > 		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
> > 
> > ?
> 
> I won't insist, but I prefer the empty function to breaking the pattern
> of this if-sequence, and also to the calling of a function named "check"
> without considering its return value.

I like scratching our OCD as much as the next reviewer, but I think my
version more clearly expresses the purpose, which is more important than
having multiple identically-looking statements.

Thanks,
-Christoffer
