From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 19:19:53 +0200
Message-ID: <20170404171953.GP11752@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <20170404160417.GN11752@cbox>
 <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEC0F40A63
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 13:17:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kSTKp2yUS5C2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 13:17:39 -0400 (EDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com [74.125.82.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 815A540948
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 13:17:39 -0400 (EDT)
Received: by mail-wm0-f51.google.com with SMTP id o81so31184458wmb.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 10:19:51 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
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

On Tue, Apr 04, 2017 at 06:24:36PM +0200, Paolo Bonzini wrote:
> 
> 
> On 04/04/2017 18:04, Christoffer Dall wrote:
> >> For pause, only the requester should do the clearing.
> 
> This suggests that maybe this should not be a request.  The request
> would be just the need to act on a GIC command, exactly as before this patch.

Maybe the semantics should be:

requester:                                vcpu:
----------                                -----
make_requet(vcpu, KVM_REQ_PAUSE);
                                          handles the request by
					  clearing it and setting
					  vcpu->pause = true;
wait until vcpu->pause == true
make_request(vcpu, KVM_REQ_UNPAUSE);
                                          vcpus 'wake up' clear the
					  UNPAUSE request and set
					  vcpu->pause = false;

The benefit would be that we get to re-use the complicated "figure out
the VCPU mode and whether or not we should send an IPI and get the
barriers right" stuff.

> 
> What I don't understand is:
> 
> >> With this patch, while the vcpu will still initially enter
> >> the guest, it will exit immediately due to the IPI sent by the vcpu
> >> kick issued after making the vcpu request.
> 
> Isn't this also true of KVM_REQ_VCPU_EXIT that was used before?
> 
> So this:
> 
> +			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
> +			WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
> 
> is the crux of the fix, you can keep using vcpu->arch.pause.

Probably; I feel like there's a fix here which should be a separate
patch from using a different requests instead of the KVM_REQ_VCPU_EXIT +
the pause flag.

> 
> By the way, vcpu->arch.power_off can go away from this "if" too because
> KVM_RUN and KVM_SET_MP_STATE are mutually exclusive through the vcpu mutex.

But we also allow setting the power_off flag from the in-kernel PSCI
emulation in the context of another VCPU thread.

> The earlier check is enough:
> 
>                  if (vcpu->arch.power_off || vcpu->arch.pause)
>                          vcpu_sleep(vcpu);
> 
> 
> >> +		/*
> >> +		 * Indicate we're in guest mode now, before doing a final
> >> +		 * check for pending vcpu requests. The general barrier
> >> +		 * pairs with the one in kvm_arch_vcpu_should_kick().
> >> +		 * Please see the comment there for more details.
> >> +		 */
> >> +		WRITE_ONCE(vcpu->mode, IN_GUEST_MODE);
> >> +		smp_mb();
> > 
> > There are two changes here:
> > 
> > there's a change from a normal write to a WRITE_ONCE and there's also a
> > change to that adds a memory barrier.  I feel like I'd like to know if
> > these are tied together or two separate cleanups.  I also wonder if we
> > could split out more general changes from the pause thing to have a
> > better log of why we changed the run loop?
> 
> You probably should just use smp_store_mb here.
> 

That looks cleaner at least.

Thanks,
-Christoffer
