From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 20:38:34 +0200
Message-ID: <20170404183834.GE31208@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <20170404160417.GN11752@cbox>
 <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
 <20170404171953.GP11752@cbox>
 <e3977a97-a240-58a6-288d-09f3c12de56c@redhat.com>
 <20170404175750.GD31208@cbox>
 <b49156ee-ca97-5d43-15a6-ed6ec8116535@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A19840948
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 14:36:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id becrqlwhQ6vh for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 14:36:20 -0400 (EDT)
Received: from mail-wr0-f182.google.com (mail-wr0-f182.google.com
 [209.85.128.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 17E4640296
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 14:36:19 -0400 (EDT)
Received: by mail-wr0-f182.google.com with SMTP id w11so219555631wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 11:38:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <b49156ee-ca97-5d43-15a6-ed6ec8116535@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 04, 2017 at 08:15:09PM +0200, Paolo Bonzini wrote:
> 
> 
> On 04/04/2017 19:57, Christoffer Dall wrote:
> >> Right.  That code does
> >>
> >>                 tmp->arch.power_off = true;
> >>                 kvm_vcpu_kick(tmp);
> >>
> >> and I think what's really missing in arm.c is the "if (vcpu->mode ==
> >> EXITING_GUEST_MODE)" check that is found in x86.c.  Then pausing can
> >> also simply use kvm_vcpu_kick.
> > I see, that's why the cmpxchg() works the way it does.  We just still
> > need to move the vcpu->mode = IN_GUEST_MODE before our
> > with-interrupts-disabled check.
> > 
> > What I'm not sure is why you can get away without using a memory barrier
> > or WRITE_ONCE on x86, but is this simply because x86 is a strongly
> > ordered architecture?
> 
> x86 does have a memory barrier:
> 
>         vcpu->mode = IN_GUEST_MODE;
> 
>         srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
>         smp_mb__after_srcu_read_unlock();

duh, the long complicated barrier version made me totally miss it.
Sorry.

> 
>         /*
>          * This handles the case where a posted interrupt was
>          * notified with kvm_vcpu_kick.
>          */
>         if (kvm_lapic_enabled(vcpu)) {
>                 if (kvm_x86_ops->sync_pir_to_irr && vcpu->arch.apicv_active)
>                         kvm_x86_ops->sync_pir_to_irr(vcpu);
>         }
> 
>         if (vcpu->mode == EXITING_GUEST_MODE || vcpu->requests
> 
> and WRITE_ONCE is not needed if you have a memory barrier (though I find it
> more self-documenting to use it anyway).
> 

ok, thanks.

-Christoffer
