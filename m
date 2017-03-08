From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/5] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu-request
Date: Wed, 8 Mar 2017 15:44:11 +0100
Message-ID: <20170308144411.tobywqs7qh4g4n2y@hawk.localdomain>
References: <20170227175504.15751-1-drjones@redhat.com>
 <20170227175504.15751-3-drjones@redhat.com>
 <20170308143312.GC109908@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 472E740A54
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 09:42:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aktKXmERyNyB for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Mar 2017 09:42:53 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3CA2240296
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Mar 2017 09:42:52 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20170308143312.GC109908@lvm>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, ashoks@broadcom.com, imammedo@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 08, 2017 at 06:33:12AM -0800, Christoffer Dall wrote:
> >  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> > @@ -621,7 +617,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  
> >  		update_vttbr(vcpu->kvm);
> >  
> > -		if (vcpu->arch.power_off || vcpu->arch.pause)
> > +		if (vcpu->arch.power_off || __kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu))
> >  			vcpu_sleep(vcpu);
> >  
> >  		/*
> > @@ -644,8 +640,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> >  			run->exit_reason = KVM_EXIT_INTR;
> >  		}
> >  
> > +		vcpu->mode = IN_GUEST_MODE;
> > +		smp_mb(); /* ensure vcpu->mode is visible to kvm_vcpu_kick */
> 
> I think this comment is misleading, because this smp_mb() is really
> about ensuring that with respect to other CPUs, the write to vcpu->mode
> is observable before the read of kvm_request_pending below, and the
> corresponding other barrier is the barrier implied in cmpxchg used by
> kvm_vcpu_exiting_guest_mode, which gets called by kvm_vcpu_kick(), which
> is called after __kvm_set_request.

Agreed

> 
> So this also means that our direct use of kvm_vcpu_kick() without making
> a request is currently racy, so we should address that where appropriate
> as well.
> 
> Do you feel brave enough to take a look at that?

Yup, mission accepted.

Thanks,
drew
