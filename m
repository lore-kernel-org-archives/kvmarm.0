From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 11/15] KVM: arm64: handle pending bit for LPIs in ITS
 emulation
Date: Wed, 7 Oct 2015 21:53:18 +0200
Message-ID: <20151007195318.GB14315@cbox>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com>
 <1436538111-4294-12-git-send-email-andre.przywara@arm.com>
 <017701d100db$b003c550$100b4ff0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <017701d100db$b003c550$100b4ff0$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: 'Andre Przywara' <andre.przywara@arm.com>, marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 'Peter Maydell' <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 07, 2015 at 11:39:30AM +0300, Pavel Fedin wrote:
>  Hello!
> 
> > +/* Called with the distributor lock held by the caller. */
> > +void vits_unqueue_lpi(struct kvm_vcpu *vcpu, int lpi)
> > +{
> > +	struct vgic_its *its = &vcpu->kvm->arch.vgic.its;
> > +	struct its_itte *itte;
> > +
> > +	spin_lock(&its->lock);
> > +
> > +	/* Find the right ITTE and put the pending state back in there */
> > +	itte = find_itte_by_lpi(vcpu->kvm, lpi);
> > +	if (itte)
> > +		__set_bit(vcpu->vcpu_id, itte->pending);
> > +
> > +	spin_unlock(&its->lock);
> > +}
> 
>  I am working on implementing live migration for the ITS. And here i have one fundamental problem.
> vits_unqueue_lpi() processes only PENDING state. And looks like this corresponds to the HW
> implementation, which has only bitwise pending table. But, in terms of migration, we can actually
> have LPI in active state, while it's being processed.

I thought LPIs had strict fire-and-forget semantics, not allowing any
active state, and that they are either pending or inactive?


>  The question is - how can we handle it? Should we have one more bitwise table for active LPIs, or
> is it enough to remember only a single, currently active LPI? Can LPIs be preempted on a real
> hardware, or not?
> 
Perhaps you're asking if LPIs have active state semantics on real
hardware and thus supports threaded interrupt handling for LPIs?

That is not supported on real hardware, which I think addresses your
concerns.

Thanks,
-Christoffer
