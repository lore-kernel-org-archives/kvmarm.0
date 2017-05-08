From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v7 22/24] KVM: arm64: vgic-its: ITT save and restore
Date: Mon, 8 May 2017 13:49:56 +0200
Message-ID: <20170508114956.GC28342@cbox>
References: <1494084283-12723-1-git-send-email-eric.auger@redhat.com>
 <1494084283-12723-23-git-send-email-eric.auger@redhat.com>
 <87shkgiy5m.fsf@on-the-bus.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shkgiy5m.fsf@on-the-bus.cambridge.arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Sun, May 07, 2017 at 02:39:33PM +0100, Marc Zyngier wrote:
> On Sat, May 06 2017 at  4:24:41 pm BST, Eric Auger <eric.auger@redhat.com> wrote:
> > Implement routines to save and restore device ITT and their
> > interrupt table entries (ITE).
> >
> > Signed-off-by: Eric Auger <eric.auger@redhat.com>
> > Reviewed-by: Christoffer Dall <cdall@linaro.org>
> >
> > ---
> > v6 -> v7:
> > - added Christoffer's R-b
> >
> > v5 -> v6:
> > - accomodate vgic_its_alloc_ite change of proto
> > - check LPI ID on restore, check eventid offset
> > - initializations on separate line
> > - coming after device save/restore
> > - add_lpi does config and pending bit sync
> >
> > v4 -> v5:
> > - ITE are now sorted by eventid on the flush
> > - rename *flush* into *save*
> > - use macros for shits and masks
> > - pass ite_esz to vgic_its_save_ite
> >
> > v3 -> v4:
> > - lookup_table and compute_next_eventid_offset become static in this
> >   patch
> > - remove static along with vgic_its_flush/restore_itt to avoid
> >   compilation warnings
> > - next field only computed with a shift (mask removed)
> > - handle the case where the last element has not been found
> >
> > v2 -> v3:
> > - add return 0 in vgic_its_restore_ite (was in subsequent patch)
> >
> > v2: creation
> > ---
> >  virt/kvm/arm/vgic/vgic-its.c | 116 +++++++++++++++++++++++++++++++++++++++++--
> >  virt/kvm/arm/vgic/vgic.h     |   4 ++
> >  2 files changed, 117 insertions(+), 3 deletions(-)
> >
> > diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> > index 3dea626..adb3d9e 100644
> > --- a/virt/kvm/arm/vgic/vgic-its.c
> > +++ b/virt/kvm/arm/vgic/vgic-its.c
> > @@ -1750,7 +1750,7 @@ static u32 compute_next_devid_offset(struct list_head *h,
> >  	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
> >  }
> >  
> > -u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
> > +static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
> >  {
> >  	struct its_ite *next;
> >  	u32 next_offset;
> > @@ -1827,14 +1827,124 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, int esz,
> >  	return ret;
> >  }
> >  
> > +/**
> > + * vgic_its_save_ite - Save an interrupt translation entry at @gpa
> > + */
> > +static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
> > +			      struct its_ite *ite, gpa_t gpa, int ite_esz)
> > +{
> > +	struct kvm *kvm = its->dev->kvm;
> > +	u32 next_offset;
> > +	u64 val;
> > +
> > +	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
> > +	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
> > +	       ((u64)ite->lpi << KVM_ITS_ITE_PINTID_SHIFT) |
> > +		ite->collection->collection_id;
> > +	val = cpu_to_le64(val);
> > +	return kvm_write_guest(kvm, gpa, &val, ite_esz);
> > +}
> > +
> > +/**
> > + * vgic_its_restore_ite - restore an interrupt translation entry
> > + * @event_id: id used for indexing
> > + * @ptr: pointer to the ITE entry
> > + * @opaque: pointer to the its_device
> > + */
> > +static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
> > +				void *ptr, void *opaque)
> > +{
> > +	struct its_device *dev = (struct its_device *)opaque;
> > +	struct its_collection *collection;
> > +	struct kvm *kvm = its->dev->kvm;
> > +	struct kvm_vcpu *vcpu = NULL;
> > +	u64 val;
> > +	u64 *p = (u64 *)ptr;
> > +	struct vgic_irq *irq;
> > +	u32 coll_id, lpi_id;
> > +	struct its_ite *ite;
> > +	u32 offset;
> > +
> > +	val = *p;
> > +
> > +	val = le64_to_cpu(val);
> > +
> > +	coll_id = val & KVM_ITS_ITE_ICID_MASK;
> > +	lpi_id = (val & KVM_ITS_ITE_PINTID_MASK) >> KVM_ITS_ITE_PINTID_SHIFT;
> > +
> > +	if (!lpi_id)
> > +		return 1; /* invalid entry, no choice but to scan next entry */
> > +
> > +	if (lpi_id < VGIC_MIN_LPI)
> > +		return -EINVAL;
> > +
> > +	offset = val >> KVM_ITS_ITE_NEXT_SHIFT;
> > +	if (event_id + offset >= BIT_ULL(dev->num_eventid_bits))
> > +		return -EINVAL;
> > +
> > +	collection = find_collection(its, coll_id);
> > +	if (!collection)
> > +		return -EINVAL;
> > +
> > +	ite = vgic_its_alloc_ite(dev, collection, lpi_id, event_id);
> > +	if (IS_ERR(ite))
> > +		return PTR_ERR(ite);
> > +
> > +	if (its_is_collection_mapped(collection))
> > +		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
> > +
> > +	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
> > +	if (IS_ERR(irq))
> > +		return PTR_ERR(irq);
> 
> Same remark as the previous patch: the its_ite structure should be freed
> on failure. Otherwise, I suspect we end0up leaking memory.
> 

This error would be propagated back to vgic_its_restore_dte() which
(folllowing our discussion on the previous patch) will clean up the
dte including freeing all ITEs associated with the device's ITT.

Thanks,
-Christoffer

> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead, it just smell funny.
