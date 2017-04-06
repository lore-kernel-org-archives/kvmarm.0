From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 2/9] KVM: Add documentation for VCPU requests
Date: Thu, 6 Apr 2017 16:27:14 +0200
Message-ID: <20170406142714.GE27123@cbox>
References: <20170331160658.4331-1-drjones@redhat.com>
 <20170331160658.4331-3-drjones@redhat.com>
 <20170404152403.GK11752@cbox>
 <20170404170600.w6snnecqoi4aqv4d@kamzik.brq.redhat.com>
 <20170404172340.GQ11752@cbox>
 <20170405141139.GA13944@potion>
 <20170405174538.GB27123@cbox>
 <45234347-1773-3359-81e3-e1ffe2ae560b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45234347-1773-3359-81e3-e1ffe2ae560b@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Apr 05, 2017 at 08:29:12PM +0200, Paolo Bonzini wrote:
> 
> 
> On 05/04/2017 19:45, Christoffer Dall wrote:
> >>> But the problem is that kvm_make_all_cpus_request() only sends IPIs to
> >>> CPUs where the mode was different from OUTSIDE_GUEST_MODE, so there it's
> >>> about !OUTSIDE_GUEST_MODE rather than !IN_GUEST_MODE, so there's some
> >>> subtlety here which I feel like it's dangerous to paper over.
> >> Right, that needs fixing in the code.
> > Really?  I thought Paolo said that this is the intended behavior and
> > semantics; non-urgent requests that should just be serviced before the
> > next guest entry.
> 
> Indeed, that's right...
> 
> >> guest_mode is just an optimization that allows us to skip sending the
> >> IPI when the VCPU is known to handle the request as soon as possible.
> >>
> >>   IN_GUEST_MODE: we must force VM exit or the request could never be
> >>     handled
> >>   EXITING_GUEST_MODE: another request already forces the VM exit and
> >>     we're just waiting for the VCPU to notice our request
> >>   OUTSIDE_GUEST_MODE: KVM is going to notice our request without any
> >>     intervention
> >>   READING_SHADOW_PAGE_TABLES: same as OUTSIDE_GUEST_MODE -- rename to
> >>     unwieldly OUTSIDE_GUEST_MODE_READING_SHADOW_PAGE_TABLES?
> > Again, I thought Paolo was arguing that EXITING_GUEST_MODE makes the
> > whole thing work because you check that after checking requests?
> 
> ... but apparently I was wrong here, see my email from this morning.
> 
I now managed to understand that e-mail, so it feels like we're
converging in our understanding, which I hope is a good thing - meaning
that we're converging to a correct understanding :)

-Christoffer
