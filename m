From: Dave Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 1/5] KVM: arm/arm64: Reset the VCPU without preemption
 and vcpu state loaded
Date: Wed, 27 Feb 2019 12:05:29 +0000
Message-ID: <20190227120527.GC3567@e103592.cambridge.arm.com>
References: <20190125094656.5026-1-christoffer.dall@arm.com>
 <20190125094656.5026-2-christoffer.dall@arm.com>
 <20190220191450.GT3567@e103592.cambridge.arm.com>
 <20190220194143.2e1a7d2c@why.wild-wind.fr.eu.org>
 <20190226135352.GX3567@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B80C14A44F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Feb 2019 07:05:39 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eV9LE9PA8ESK for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Feb 2019 07:05:33 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 97ABD4A3B2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Feb 2019 07:05:33 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20190226135352.GX3567@e103592.cambridge.arm.com>
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

On Tue, Feb 26, 2019 at 01:53:52PM +0000, Dave Martin wrote:
> On Wed, Feb 20, 2019 at 07:41:43PM +0000, Marc Zyngier wrote:
> > On Wed, 20 Feb 2019 19:14:53 +0000
> > Dave Martin <Dave.Martin@arm.com> wrote:

[...]

> > > Perhaps an alternative approach would be to nobble the preempt notifier
> > > and stick an explicit vcpu_put()...vcpu_load() around the
> > > swait_event_interruptible_exclusive() call in vcpu_req_sleep().  This
> > > is not fast path.
> > 
> > What does it buy us? The problem we're solving here is a powered-off,
> > spuriously woken-up vcpu racing against the reset performed from
> > another vcpu. I don't see what adding more put/load would solve.
> 
> Not a lot.  Changes in this area would allow some code to move outside
> preempt_disable(), but only at the expense of extra cost elsewhere...
> 
> > > Any, with the code as-is, it looks like the SVE regs resetting should
> > > go in the preempt_disable() region, after the kvm_arch_vcpu_put() call.
> > 
> > All resets must go there. This is the only safe location.
> 
> OK, that's what I wanted to be sure of.

Hmmm, it turns out this is no good because we may need to kzalloc()
the vcpu->arch.sve_state storage here in the new-vcpu case.

Rather than create additional mess in this code, I will move that
allocation to be done more eagerly rather than deferred until the last
possible moment.

With the current API flow, this may mean krealloc()'ing the buffer if
the set of vector lengths for the vcpu is modified from the default
before the vcpu is run, via a user write to KVM_REG_ARM64_SVE_VLS --
though we would anyway get away with not doing it, since the default
buffer size will be the maximum that the hardware could possibly
require anyway.  We could waste a few K per vcpu, but that's almost not
worth caring about.

I'd rather not churn the API at this point, but I'll experiment to see
which approach under the hood looks cleanest.

Thoughts?

Cheers
---Dave
