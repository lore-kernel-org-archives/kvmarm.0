From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 08/17] arm64: KVM: vgic-v2: Save maintenance
 interrupt state only if required
Date: Thu, 3 Mar 2016 08:28:18 +0000
Message-ID: <20160303082818.13c217a9@arm.com>
References: <1455727249-24752-1-git-send-email-marc.zyngier@arm.com>
 <1455727249-24752-9-git-send-email-marc.zyngier@arm.com>
 <20160302230806.GB9634@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0A8411BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 03:21:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jpFIgPQYJdyF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Mar 2016 03:21:13 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 198C8410EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Mar 2016 03:21:12 -0500 (EST)
In-Reply-To: <20160302230806.GB9634@cbox>
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
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 3 Mar 2016 00:08:06 +0100
Christoffer Dall <christoffer.dall@linaro.org> wrote:

> On Wed, Feb 17, 2016 at 04:40:40PM +0000, Marc Zyngier wrote:
> > Next on our list of useless accesses is the maintenance interrupt
> > status registers (GICH_MISR, GICH_EISR{0,1}).
> > 
> > It is pointless to save them if we haven't asked for a maintenance
> > interrupt the first place, which can only happen for two reasons:
> > - Underflow: GICH_HCR_UIE will be set,
> > - EOI: GICH_LR_EOI will be set.
> > 
> > These conditions can be checked on the in-memory copies of the regs.
> > Should any of these two condition be valid, we must read GICH_MISR.
> > We can then check for GICH_MISR_EOI, and only when set read
> > GICH_EISR*.
> > 
> > This means that in most case, we don't have to save them at all.
> > 
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/vgic-v2-sr.c | 54 +++++++++++++++++++++++++++++++++++------
> >  1 file changed, 47 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/vgic-v2-sr.c b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> > index 5ab8d63..1bda5ce 100644
> > --- a/arch/arm64/kvm/hyp/vgic-v2-sr.c
> > +++ b/arch/arm64/kvm/hyp/vgic-v2-sr.c
> > @@ -23,6 +23,49 @@
> >  
> >  #include "hyp.h"
> >  
> > +static void __hyp_text save_maint_int_state(struct kvm_vcpu *vcpu,
> > +					    void __iomem *base)
> > +{
> > +	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> > +	int nr_lr = vcpu->arch.vgic_cpu.nr_lr;
> > +	u32 eisr0, eisr1;
> > +	int i;
> > +	bool expect_mi;
> > +
> > +	expect_mi = !!(cpu_if->vgic_hcr & GICH_HCR_UIE);
> > +
> > +	for (i = 0; i < nr_lr; i++) {
> > +		if (!(vcpu->arch.vgic_cpu.live_lrs & (1UL << i)))
> > +				continue;
> > +
> > +		expect_mi |= (!(cpu_if->vgic_lr[i] & GICH_LR_HW) &&
> > +			      (cpu_if->vgic_lr[i] & GICH_LR_EOI));
> > +	}
> 
> Just eye balling the code it really feels crazy that this is faster than
> reading two registers, but I believe that may just be the case given the
> speed of the GIC.

I've measured things like 300 cycles per access on some implementation.
Pretty scary. On the other hand, this loop is usually short (we
usually have very few LRs, and even fewer are actually live), so it
ends up being a couple of memory accesses at most (completely dwarfed
by the cost of the MMIO access).

> 
> As an alternative to this loop, you could keep a counter for the number
> of requested EOI MIs and whenever we program an LR with the EOI bit set,
> then we increment the counter, and whenever we clear such an LR, we
> decrement the counter, and then you can just check here if it's
> non-zero.  What do you think?  Is it worth it?  Does it make the code
> even worse?

This indeed could be a clearer/cleaner optimization indeed.

> 
> I can also write that on top of this patch if you'd like.

Yes please! :-)

> In any case, for this functionality:
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks!

	M.
-- 
Jazz is not dead. It just smells funny.
