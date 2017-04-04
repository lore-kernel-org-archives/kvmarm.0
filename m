From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Tue, 4 Apr 2017 19:57:50 +0200
Message-ID: <20170404175750.GD31208@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <20170404160417.GN11752@cbox>
 <06b2a225-192c-9c96-c092-6e0575dd9410@redhat.com>
 <20170404171953.GP11752@cbox>
 <e3977a97-a240-58a6-288d-09f3c12de56c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 600E640A69
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 13:55:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tKbGxy6pzFfV for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 13:55:36 -0400 (EDT)
Received: from mail-wr0-f180.google.com (mail-wr0-f180.google.com
 [209.85.128.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB5E240992
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 13:55:35 -0400 (EDT)
Received: by mail-wr0-f180.google.com with SMTP id w11so218876925wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 10:57:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <e3977a97-a240-58a6-288d-09f3c12de56c@redhat.com>
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

On Tue, Apr 04, 2017 at 07:35:11PM +0200, Paolo Bonzini wrote:
> 
> 
> On 04/04/2017 19:19, Christoffer Dall wrote:
> > On Tue, Apr 04, 2017 at 06:24:36PM +0200, Paolo Bonzini wrote:
> >>
> >>
> >> On 04/04/2017 18:04, Christoffer Dall wrote:
> >>>> For pause, only the requester should do the clearing.
> >>
> >> This suggests that maybe this should not be a request.  The request
> >> would be just the need to act on a GIC command, exactly as before this patch.
> > 
> > Maybe the semantics should be:
> > 
> > requester:                                vcpu:
> > ----------                                -----
> > make_requet(vcpu, KVM_REQ_PAUSE);
> >                                           handles the request by
> > 					  clearing it and setting
> > 					  vcpu->pause = true;
> > wait until vcpu->pause == true
> > make_request(vcpu, KVM_REQ_UNPAUSE);
> >                                           vcpus 'wake up' clear the
> > 					  UNPAUSE request and set
> > 					  vcpu->pause = false;
> > 
> > The benefit would be that we get to re-use the complicated "figure out
> > the VCPU mode and whether or not we should send an IPI and get the
> > barriers right" stuff.
> 
> I don't think that's necessary.  As long as the complicated stuff avoids
> that you enter the VCPU, the next run through the loop will
> find that 'vcpu->arch.power_off || vcpu->arch.pause' is true and
> go to sleep.
> 
> >> What I don't understand is:
> >>
> >>>> With this patch, while the vcpu will still initially enter
> >>>> the guest, it will exit immediately due to the IPI sent by the vcpu
> >>>> kick issued after making the vcpu request.
> >>
> >> Isn't this also true of KVM_REQ_VCPU_EXIT that was used before?
> >>
> >> So this:
> >>
> >> +			vcpu->arch.power_off || kvm_request_pending(vcpu)) {
> >> +			WRITE_ONCE(vcpu->mode, OUTSIDE_GUEST_MODE);
> >>
> >> is the crux of the fix, you can keep using vcpu->arch.pause.
> > 
> > Probably; I feel like there's a fix here which should be a separate
> > patch from using a different requests instead of the KVM_REQ_VCPU_EXIT +
> > the pause flag.
> 
> Yeah, and then the pause flag can stay.
> 
> >> By the way, vcpu->arch.power_off can go away from this "if" too because
> >> KVM_RUN and KVM_SET_MP_STATE are mutually exclusive through the vcpu mutex.
> > 
> > But we also allow setting the power_off flag from the in-kernel PSCI
> > emulation in the context of another VCPU thread.
> 
> Right.  That code does
> 
>                 tmp->arch.power_off = true;
>                 kvm_vcpu_kick(tmp);
> 
> and I think what's really missing in arm.c is the "if (vcpu->mode ==
> EXITING_GUEST_MODE)" check that is found in x86.c.  Then pausing can
> also simply use kvm_vcpu_kick.

I see, that's why the cmpxchg() works the way it does.  We just still
need to move the vcpu->mode = IN_GUEST_MODE before our
with-interrupts-disabled check.

What I'm not sure is why you can get away without using a memory barrier
or WRITE_ONCE on x86, but is this simply because x86 is a strongly
ordered architecture?

> 
> My understanding is that KVM-ARM is using KVM_REQ_VCPU_EXIT simply to
> reuse the smp_call_function_many code in kvm_make_all_cpus_request.

Your understanding is correct.

> Once you add EXITING_GUEST_MODE, ARM can just add a new function
> kvm_kick_all_cpus and use it for both pause and power_off.
> 

Yes, that should work.

I think Drew's approach should also work, but at this point, I'm not
really sure which approach is better than the other.


Thanks,
-Christoffer
