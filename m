From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] KVM: arm/arm64: ensure vcpu target is unset on reset
 failure
Date: Fri, 5 Apr 2019 09:27:36 +0200
Message-ID: <20190405072736.lfxea4fxe6wvlffp@kamzik.brq.redhat.com>
References: <20190404174230.18587-1-drjones@redhat.com>
 <86ftqx3qik.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F4AB4A44D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 03:27:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NIyCmVl5K2cg for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Apr 2019 03:27:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 804114A332
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Apr 2019 03:27:42 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <86ftqx3qik.wl-marc.zyngier@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 05, 2019 at 07:38:59AM +0100, Marc Zyngier wrote:
> On Thu, 04 Apr 2019 18:42:30 +0100,
> Andrew Jones <drjones@redhat.com> wrote:
> > 
> > A failed KVM_ARM_VCPU_INIT, should not set the vcpu target,
> > as the vcpu target is used by kvm_vcpu_initialized() to
> > determine if other vcpu ioctls may proceed. We need to set
> > the target before calling kvm_reset_vcpu(), but if that call
> > fails, we should then unset it.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  virt/kvm/arm/arm.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > index 99c37384ba7b..7e5724ae1efd 100644
> > --- a/virt/kvm/arm/arm.c
> > +++ b/virt/kvm/arm/arm.c
> > @@ -934,7 +934,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
> >  static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >  			       const struct kvm_vcpu_init *init)
> >  {
> > -	unsigned int i;
> > +	unsigned int i, ret;
> >  	int phys_target = kvm_target_cpu();
> >  
> >  	if (init->target != phys_target)
> > @@ -969,9 +969,15 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
> >  	vcpu->arch.target = phys_target;
> >  
> >  	/* Now we know what it is, we can reset it. */
> > -	return kvm_reset_vcpu(vcpu);
> > -}
> > +	ret = kvm_reset_vcpu(vcpu);
> > +	if (ret) {
> > +		vcpu->arch.target = -1;
> > +		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
> > +		return ret;
> 
> This return could trivially be removed...
> 
> > +	}
> >  
> > +	return 0;
> > +}
> 
> ... and this turned into 'return ret'.
> 
> I've tentatively applied this to the 5.1-fixes branch. Let me know if
> you're OK with it.
>

Either way is fine by me. I actually did it this way on purpose though
because I preferred the way the explicit 'return 0' at the bottom
documented that we were sure at that point of success, so no longer
needed to be concerned that target should be reset to -1.

Thanks,
drew
