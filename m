From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/5] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu-request
Date: Mon, 13 Mar 2017 18:27:55 +0100
Message-ID: <20170313172642.hsrtpcxo4cd6p74s@kamzik.brq.redhat.com>
References: <20170227175504.15751-1-drjones@redhat.com>
 <20170227175504.15751-3-drjones@redhat.com>
 <20170308143312.GC109908@lvm>
 <20170308144411.tobywqs7qh4g4n2y@hawk.localdomain>
 <20170313103005.GA1277@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7F5240AF9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Mar 2017 13:26:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VJIUHqKA1m7o for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Mar 2017 13:26:27 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 71BEB40430
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Mar 2017 13:26:27 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20170313103005.GA1277@cbox>
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
Cc: marc.zyngier@arm.com, imammedo@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 13, 2017 at 11:30:05AM +0100, Christoffer Dall wrote:
> On Wed, Mar 08, 2017 at 03:44:11PM +0100, Andrew Jones wrote:
> > On Wed, Mar 08, 2017 at 06:33:12AM -0800, Christoffer Dall wrote:
> > > >  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
> > > > @@ -621,7 +617,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > > >  
> > > >  		update_vttbr(vcpu->kvm);
> > > >  
> > > > -		if (vcpu->arch.power_off || vcpu->arch.pause)
> > > > +		if (vcpu->arch.power_off || __kvm_request_test(KVM_REQ_VCPU_PAUSE, vcpu))
> > > >  			vcpu_sleep(vcpu);
> > > >  
> > > >  		/*
> > > > @@ -644,8 +640,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
> > > >  			run->exit_reason = KVM_EXIT_INTR;
> > > >  		}
> > > >  
> > > > +		vcpu->mode = IN_GUEST_MODE;
> > > > +		smp_mb(); /* ensure vcpu->mode is visible to kvm_vcpu_kick */
> > > 
> > > I think this comment is misleading, because this smp_mb() is really
> > > about ensuring that with respect to other CPUs, the write to vcpu->mode
> > > is observable before the read of kvm_request_pending below, and the
> > > corresponding other barrier is the barrier implied in cmpxchg used by
> > > kvm_vcpu_exiting_guest_mode, which gets called by kvm_vcpu_kick(), which
> > > is called after __kvm_set_request.
> > 
> > Agreed
> > 
> 
> Just an adjustment to our conclusion from last week:
> 
> Will Deacon clarified that the cmpxchg doesn't have barrier semantics if
> the cmpxchg operation fails.  My brain hurts trying to work out if we're
> still safe in that case.  Thoughts?
>

OK, I just ran my brain through a blender, and then I grabbed Radim to
bounce my thoughts off him first. I think he and I are in agreement that
kvm_arch_vcpu_should_kick() should get a read barrier before the cmpxchg.
That smp_rmb() would pair with the general barrier that I have poorly
commented in the code above.

I'll refresh this series in the next couple days, adding that barrier,
and some better comments.

Thanks,
drew
