From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: replace vcpu->arch.pause with a
 vcpu request
Date: Sat, 8 Apr 2017 01:35:33 -0700
Message-ID: <20170408083533.GA28739@lvm>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-5-drjones@redhat.com>
 <20170404160417.GN11752@cbox>
 <20170404175718.su4tjx3psyez3qee@kamzik.brq.redhat.com>
 <20170404190438.GF31208@cbox>
 <63209d09-0c45-0bb2-322b-e422f1360df7@redhat.com>
 <20170405070959.GA1526@cbox>
 <91ab3b0b-c30e-7a19-f60f-882d26388ef5@redhat.com>
 <20170406141443.GC27123@cbox>
 <b435db93-9d46-52d6-7aa7-458dbbc2b7ef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7096740CD2
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Apr 2017 04:33:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7rry0kQchHE9 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  8 Apr 2017 04:33:17 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5DEBA40CD1
 for <kvmarm@lists.cs.columbia.edu>; Sat,  8 Apr 2017 04:33:17 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id w64so6956627wma.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 08 Apr 2017 01:35:36 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <b435db93-9d46-52d6-7aa7-458dbbc2b7ef@redhat.com>
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
Cc: marc.zyngier@arm.com, Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 07, 2017 at 07:47:29PM +0800, Paolo Bonzini wrote:
> 
> 
> On 06/04/2017 22:14, Christoffer Dall wrote:
> >> So it seems like there are no races after all in KVM/ARM code
> >
> > No races after Drew's fix has been applied to set vcpu->mode =
> > IN_GUEST_MODE, before checking the pause flag, correct?  (I think that's
> > what the spin model below is modeling).
> 
> Yes.  All of them include the vcpu->mode = IN_GUEST_MODE assignment and
> (implicitly because spin is sequentially consistent) the memory barrier.
> 
> >> After this experiment, I think I like Drew's KVM_REQ_PAUSE more than I did
> >> yesterday.  However, yet another alternative is to leave pause/power_off as
> >> they are, while taking some inspiration from his patch to do some cleanups:
> >>
> >> 1) change the "if"
> >>
> >>                 if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
> >>                         vcpu->arch.power_off || vcpu->arch.pause) {
> >>
> >> to test kvm_requests_pending instead of pause/power_off
> >>
> >> 2) clear KVM_REQ_VCPU_EXIT before the other "if":
> >>
> >>                 if (vcpu->arch.power_off || vcpu->arch.pause)
> >>                         vcpu_sleep(vcpu);
> >
> > I like using requests as only requests from one thread to the VCPU
> > thread, and not to maintain specific state about a VCPU.
> > 
> > The benefit of Drew's approach is that since these pieces of state are
> > boolean, you can have just a single check in the critical path in the
> > run loop instead of having to access multiple fields.
> 
> I think you'd still need two checks for KVM_REQ_PAUSE/KVM_REQ_POWEROFF:
> one to check whether to sleep, and one to check whether to abort the
> vmentry.
> 
> Pause and power_off could be merged into a single bitmask if necessary, too.

True, a sort of flags.

I think at this point, I'll let Drew decide what looks cleanest when he
writes up the next revision and review those.

Thanks for the thorough help and checking!
-Christoffer
