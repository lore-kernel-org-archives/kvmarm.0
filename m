From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v4 03/10] KVM: arm/arm64: vgic: GICv2 IGROUPR should read
 as zero
Date: Thu, 19 Jul 2018 22:56:53 +0200
Message-ID: <20180719205653.GA6399@C02W217FHV2R.local>
References: <1531746387-7033-1-git-send-email-christoffer.dall@arm.com>
 <1531746387-7033-4-git-send-email-christoffer.dall@arm.com>
 <20180719181636.mtlxhyrxtsweio2y@kamzik.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A3E949EA2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 16:43:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HKKLPJqlGjQ3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Jul 2018 16:43:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 952E8402AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Jul 2018 16:43:50 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20180719181636.mtlxhyrxtsweio2y@kamzik.brq.redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jul 19, 2018 at 08:16:36PM +0200, Andrew Jones wrote:
> On Mon, Jul 16, 2018 at 03:06:20PM +0200, Christoffer Dall wrote:
> > We currently don't support grouping in the emulated VGIC, which is a
> > known defect on KVM (not hurting any currently used guests as far as
> > we're aware). This is currently handled by treating all interrupts as
> > group 0 interrupts for an emulated GICv2 and always signaling interrupts
> > as group 0 to the virtual CPU interface.
> > 
> > However, when reading which group interrupts belongs to in the guest
> > from the emulated VGIC, the VGIC currently reports group 1 instead of
> > group 0, which is misleading.  Fix this temporarily before introducing
> > full group support by changing the hander to _raz instead of _rao.
> > 
> > Fixes: fb848db39661a "KVM: arm/arm64: vgic-new: Add GICv2 MMIO handling framework"
> > Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> > ---
> >  virt/kvm/arm/vgic/vgic-init.c    | 2 +-
> >  virt/kvm/arm/vgic/vgic-mmio-v2.c | 8 +++++++-
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> > index 8b6fc45..230c922 100644
> > --- a/virt/kvm/arm/vgic/vgic-init.c
> > +++ b/virt/kvm/arm/vgic/vgic-init.c
> > @@ -298,7 +298,7 @@ int vgic_init(struct kvm *kvm)
> >  
> >  	vgic_debug_init(kvm);
> >  
> > -	dist->implementation_rev = 0;
> > +	dist->implementation_rev = 1;
> >  	dist->initialized = true;
> >  
> >  out:
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > index f0c5351..db646f1 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > @@ -22,6 +22,12 @@
> >  #include "vgic.h"
> >  #include "vgic-mmio.h"
> >  
> > +/*
> > + * The Revision field in the IIDR have the following meanings:
> > + *
> > + * Revision 1: Report GICv2 interrupts as group 0 instead of group 1
> > + */
> > +
> >  static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
> >  					    gpa_t addr, unsigned int len)
> >  {
> > @@ -365,7 +371,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
> >  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
> > -		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
> > +		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
> >  		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
> > -- 
> > 2.7.4
> >
> 
> I realize that this is fixing the emulation, so any guest that would find
> this change a problem is broken, but guest-visible changes without user
> consent always seem a bit wrong.
> 
> We could drop this patch and only allow gicv2 guests to read ones from the
> IGROUP registers until v2_groups_user_writable is true. Then, if a broken
> guest needs to run on a host with an updated kernel, userspace, which must
> have been updated too, can give the guest the broken group view it needs.

That won't really help because those interrupts will no longer be
injected as IRQs, but as FIQs, which is also a departure from what the
guest expects.

> 
> That said, I'm not overly concerned about this guest-visible issue. So

Any guests relying on this broken behavior will not run on hardwre, so
I'm not going to change this.

> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks!
-Christoffer
