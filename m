From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 2/5] arm/arm64: KVM: Allow a VCPU to fully reset itself
Date: Thu, 31 Jan 2019 18:06:09 +0100
Message-ID: <20190131170609.3e7pvmyrcsm2xgq2@kamzik.brq.redhat.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-3-christoffer.dall@arm.com>
 <20190129160347.fcbry76igwyatqzx@kamzik.brq.redhat.com>
 <20190130093431.GE13482@e113682-lin.lund.arm.com>
 <20190130152721.7fbiza3glifvzlqk@kamzik.brq.redhat.com>
 <20190131074353.GI13482@e113682-lin.lund.arm.com>
 <20190131101254.rh23ntvwxtq3yqsz@kamzik.brq.redhat.com>
 <20190131115156.GP13482@e113682-lin.lund.arm.com>
 <20190131125712.pwupvf4favbqi6hu@kamzik.brq.redhat.com>
 <b356cded-fc12-d996-a860-1ef94b6a8ffb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D17224A332
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 12:06:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zl4zKdPDS6xu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 31 Jan 2019 12:06:13 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BCED54A321
 for <kvmarm@lists.cs.columbia.edu>; Thu, 31 Jan 2019 12:06:13 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <b356cded-fc12-d996-a860-1ef94b6a8ffb@arm.com>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 31, 2019 at 02:52:11PM +0000, Marc Zyngier wrote:
> On 31/01/2019 12:57, Andrew Jones wrote:
> > On Thu, Jan 31, 2019 at 12:51:56PM +0100, Christoffer Dall wrote:
> 
> [...]
> 
> >> I don't think there's anything very unconventional here.
> > 
> > Normally if a thread observes a change to vcpu->requests, then we ensure a
> > change to some accompanying data is also observable. We're reversing that
> > here, which adds a need for additional barriers and a strict request
> > checking order.
> > 
> >>
> >> Let's try this:  If you have a better way of implementing this, how
> >> about you write a patch?
> > 
> > It would just be this patch minus the unnecessary barriers. I can send it
> > if you like, but I wouldn't want to change the authorship for such a small
> > change.
> 
> Having these barriers makes it explicit (at least to me) what data we
> expect to be visible in other threads and in which order. You keep
> saying that order doesn't matter and we disagree on this. Yes, you've
> listed cases where we can survive things coming in out of order, but
> that's not a proof that we don't need them.
> 
> So at the end of the day, and unless you can prove that the barriers are
> not necessary by providing the same form of validation tool, I'm
> inclined to go with the verified approach.

I don't know how to compile and run the litmus test, but I'd be happy to
try if given some pointers. If I did know how, I would add vcpu->mode to
the P1 inputs and some additional lines that look similar to what's in
"Ensuring Requests Are Seen" of Documentation/virtual/kvm/vcpu-requests.rst
Even without the litmus test please allow me to try again to describe why
I think the barriers may be removed.

Any vcpu we're attempting to power on must be on its way to sleep with a
SLEEP request, or already be sleeping. This means that it's outside guest
mode, or will be shortly. If the vcpu observes power_off=false in
vcpu_req_sleep(), whether it was awaken or never even got to sleep, we
know that observation is taking place with vcpu->mode != IN_GUEST_MODE.

We now no longer need to be concerned with the relationship between
power_off and the RESET vcpu request. Now we just need to be certain
that if another thread made a RESET vcpu request at some point since
the powering off of the vcpu (the requesting for it to sleep), then
there's no way to miss the reset request before the vcpu reenters guest
mode. And of that we are certain.

Thanks,
drew
