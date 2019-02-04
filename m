From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/5] arm/arm64: KVM: Allow a VCPU to fully reset itself
Date: Mon, 4 Feb 2019 16:08:57 +0100
Message-ID: <20190204150857.wea2t5z7ogt7bdgq@kamzik.brq.redhat.com>
References: <20190129160347.fcbry76igwyatqzx@kamzik.brq.redhat.com>
 <20190130093431.GE13482@e113682-lin.lund.arm.com>
 <20190130152721.7fbiza3glifvzlqk@kamzik.brq.redhat.com>
 <20190131074353.GI13482@e113682-lin.lund.arm.com>
 <20190131101254.rh23ntvwxtq3yqsz@kamzik.brq.redhat.com>
 <20190131115156.GP13482@e113682-lin.lund.arm.com>
 <20190131125712.pwupvf4favbqi6hu@kamzik.brq.redhat.com>
 <b356cded-fc12-d996-a860-1ef94b6a8ffb@arm.com>
 <20190131170609.3e7pvmyrcsm2xgq2@kamzik.brq.redhat.com>
 <20190201075834.GQ13482@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 489AC4A380
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 10:09:04 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eXZP0EueEdiR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Feb 2019 10:09:03 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E25374A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Feb 2019 10:09:02 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190201075834.GQ13482@e113682-lin.lund.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 01, 2019 at 08:58:34AM +0100, Christoffer Dall wrote:
> On Thu, Jan 31, 2019 at 06:06:09PM +0100, Andrew Jones wrote:
> > On Thu, Jan 31, 2019 at 02:52:11PM +0000, Marc Zyngier wrote:
> > > On 31/01/2019 12:57, Andrew Jones wrote:
> > > > On Thu, Jan 31, 2019 at 12:51:56PM +0100, Christoffer Dall wrote:
> > > 
> > > [...]
> > > 
> > > >> I don't think there's anything very unconventional here.
> > > > 
> > > > Normally if a thread observes a change to vcpu->requests, then we ensure a
> > > > change to some accompanying data is also observable. We're reversing that
> > > > here, which adds a need for additional barriers and a strict request
> > > > checking order.
> > > > 
> > > >>
> > > >> Let's try this:  If you have a better way of implementing this, how
> > > >> about you write a patch?
> > > > 
> > > > It would just be this patch minus the unnecessary barriers. I can send it
> > > > if you like, but I wouldn't want to change the authorship for such a small
> > > > change.
> > > 
> > > Having these barriers makes it explicit (at least to me) what data we
> > > expect to be visible in other threads and in which order. You keep
> > > saying that order doesn't matter and we disagree on this. Yes, you've
> > > listed cases where we can survive things coming in out of order, but
> > > that's not a proof that we don't need them.
> > > 
> > > So at the end of the day, and unless you can prove that the barriers are
> > > not necessary by providing the same form of validation tool, I'm
> > > inclined to go with the verified approach.
> > 
> > I don't know how to compile and run the litmus test, but I'd be happy to
> > try if given some pointers.
> 
> You can look in tools/memory-model/README as a start.

Thanks. Neat tool.

> 
> 
> > If I did know how, I would add vcpu->mode to
> > the P1 inputs and some additional lines that look similar to what's in
> > "Ensuring Requests Are Seen" of Documentation/virtual/kvm/vcpu-requests.rst
> > Even without the litmus test please allow me to try again to describe why
> > I think the barriers may be removed.
> > 
> > Any vcpu we're attempting to power on must be on its way to sleep with a
> > SLEEP request, or already be sleeping. This means that it's outside guest
> > mode, or will be shortly. If the vcpu observes power_off=false in
> > vcpu_req_sleep(), whether it was awaken or never even got to sleep, we
> > know that observation is taking place with vcpu->mode != IN_GUEST_MODE.
> > 
> > We now no longer need to be concerned with the relationship between
> > power_off and the RESET vcpu request. 
> 
> I disagree.  That argument requires more explanation.
> 
> If you set power_off = false before posting the reset
> request, then if the VCPU thread is awoken (for any reason) it can run
> the VCPU without observing the reset request and that's the problem.
> 
> If you are making assumptions about only being woken up as a result of a
> reset request, or the interaction with the pause flag, or setting the
> sleep request to prevent the guest from executing again, that is a more
> complex argument (which you haven't made yet!) and I add that it's a
> brittle construction.

Yes, I was attempting to integrate more of the expected state of the
is / will be sleeping vcpu into the analysis. I was hoping that it was
provable to make stronger statements about the use of vcpu requests.
I failed to do so though, both with logical arguments and I couldn't
come up with a way to model outside-guest mode with the litmus test.

> 
> What we have here are three pieces of state:
> 
>   reset_state->reset
>   vcpu->requests
>   vcpu->arch.power_state
> 
> They must be written to, and the writes must be observed, in that
> particular order without any additional assumptions.
> 
> You keep arguing that you can enforce an ordering between these three
> states with a single barrier which is clearly not possible.

There's also the mode state and barriers in place that ensure the order
of observation for that and requests, but as I said I couldn't model it
well enough to prove anything.

> 
> So this boils down to you making additional assumptions (see above,
> brittle) without explaining what they are.  I suspect you want this to
> fit in your mental model of how vcpu requests solve the world, otherwise
> I'm not sure what your concern with this patch, which we all agree is
> correct, really is.

Well, I don't expect the vcpu requests to solve the world (if only!),
but I was hoping that they could be used with a simpler pattern. I.e.
on the sending side the vcpu request is fired off (probably with a kick
too) and then forgotten. On the receiving side path only a check and
handler need to be added, with no concern for the order of the handlers
nor of other data that we cannot observe without also observing the
request. I surrender though, because I do agree there's nothing wrong
with the additional barriers in this patch, only that it no longer fits
my opinion of the simplest pattern.

Anyway, thanks for your patience and sorry for the noise.

drew
