From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH 4/4] KVM: arm/arm64: vgic: Allow VMs to configure
 interrupt groups
Date: Mon, 25 Jun 2018 11:53:30 +0200
Message-ID: <20180625095330.GD8004@C02W217FHV2R.local>
References: <20180624221103.15055-1-christoffer.dall@arm.com>
 <20180624221103.15055-5-christoffer.dall@arm.com>
 <2f5feed6-c026-1871-25e4-943123c8b977@arm.com>
 <20180625093406.GC8004@C02W217FHV2R.local>
 <4c2f318d-29be-fb1a-3bb2-56bb56be1420@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <4c2f318d-29be-fb1a-3bb2-56bb56be1420@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 25, 2018 at 10:44:17AM +0100, Marc Zyngier wrote:
> On 25/06/18 10:34, Christoffer Dall wrote:
> > On Mon, Jun 25, 2018 at 09:19:07AM +0100, Marc Zyngier wrote:
> >> On 24/06/18 23:11, Christoffer Dall wrote:
> >>> Implement the required MMIO accessors for GICv2 and GICv3 for the
> >>> IGROUPR distributor and redistributor registers.
> >>>
> >>> This can allow guests to change behavior compared to running on previous
> >>> versions of KVM, but only to align with the architecture and hardware
> >>> implementations.
> >>>
> >>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> >>> ---
> >>>  virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
> >>>  virt/kvm/arm/vgic/vgic-mmio-v3.c |  2 +-
> >>>  virt/kvm/arm/vgic/vgic-mmio.c    | 38 ++++++++++++++++++++++++++++++++
> >>>  virt/kvm/arm/vgic/vgic-mmio.h    |  6 +++++
> >>>  4 files changed, 46 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >>> index 8d18f89397d3..ff3834d16ac9 100644
> >>> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >>> @@ -362,7 +362,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
> >>>  		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
> >>>  		VGIC_ACCESS_32bit),
> >>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
> >>> -		vgic_mmio_read_raz, vgic_mmio_write_wi, NULL, NULL, 1,
> >>> +		vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
> >>>  		VGIC_ACCESS_32bit),
> >>>  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
> >>>  		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
> >>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >>> index 287784095b5b..76e422859745 100644
> >>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> >>> @@ -451,7 +451,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
> >>>  		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
> >>>  		VGIC_ACCESS_32bit),
> >>>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
> >>> -		vgic_mmio_read_rao, vgic_mmio_write_wi, NULL, NULL, 1,
> >>> +		vgic_mmio_read_group, vgic_mmio_write_group, NULL, NULL, 1,
> >>>  		VGIC_ACCESS_32bit),
> >>>  	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
> >>>  		vgic_mmio_read_enable, vgic_mmio_write_senable, NULL, NULL, 1,
> >>
> >> I think you're missing the GICR_IGROUPR accessor in the redistributor
> >> (despite mentioning it in the commit message).
> >>
> > 
> > Indeed.  I fixed this up on my kernel.org branch (vgic-group-fixes), and
> > the fix is pretty trivial:
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > index 76e422859745..d2acad07dd30 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > @@ -524,7 +524,7 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
> >  
> >  static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
> >  	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
> > -		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
> > +		vgic_mmio_read_group, vgic_mmio_write_group, 4,
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
> >  		vgic_mmio_read_enable, vgic_mmio_write_senable, 4,
> > 
> > I did a test on the model using both GICv3 and GICv2-on-GICv3, seems
> > happy still.
> > 
> > Do you want me to send a v2, or do you prefer to fix this up locally?
> I can fix that myself. But this raises another question: As this change
> is obviously observable by the guest, should we consider bumping up the
> IIDR revision field?
> 

Hmm, yeah, good idea.  To really nit pick: Should we make this change
along with the change of visibility of the group of GICv2 interrupts, or
when the guest can actually modify the grouping, or should we bump the
revision twice, one for GICv2 only, and the second time for both GICv2
and GICv3?

I suggest the latter, making it:

Current:
  GICv2 revision: 0
  GICv3 revision: 0

GICv2 fix:
  GICv2 revision: 1
  GICv3 revision: 0

Support both groups:
  GICv2 revision: 2
  GICv3 revision: 2

Thanks,
-Christoffer
