From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 14/24] KVM: arm64: vgic-v3:
 vgic_v3_lpi_sync_pending_status
Date: Fri, 5 May 2017 07:50:57 -0700
Message-ID: <20170505145057.GJ1419@lvm>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-15-git-send-email-eric.auger@redhat.com>
 <20170505081113.GA1419@lvm>
 <2a1f0e35-5a2a-bb60-1e8f-5b7a13bae58c@redhat.com>
 <2e240438-486a-e34b-0513-67d4e422e2b6@arm.com>
 <20170505101003.GC1419@lvm>
 <df6557f5-0696-e0ed-4ecd-6ff043e24683@arm.com>
 <fdbe6b14-7a30-d0aa-0ac0-07e6db6586b8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4BF340992
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 10:47:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O-vC1mOgI6sj for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 May 2017 10:47:53 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5EAE940625
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 10:47:53 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id u65so3351245wmu.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 May 2017 07:51:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <fdbe6b14-7a30-d0aa-0ac0-07e6db6586b8@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 05, 2017 at 04:20:42PM +0200, Auger Eric wrote:
> Hi Christoffer, Marc,
> 
> On 05/05/2017 12:35, Marc Zyngier wrote:
> > On 05/05/17 11:10, Christoffer Dall wrote:
> >> On Fri, May 05, 2017 at 10:59:09AM +0100, Marc Zyngier wrote:
> >>> On 05/05/17 10:45, Auger Eric wrote:
> >>>> Hi,
> >>>>
> >>>> On 05/05/2017 10:11, Christoffer Dall wrote:
> >>>>> On Thu, May 04, 2017 at 01:44:34PM +0200, Eric Auger wrote:
> >>>>>> this new helper synchronizes the irq pending_latch
> >>>>>> with the LPI pending bit status found in rdist pending table.
> >>>>>> As the status is consumed, we reset the bit in pending table.
> >>>>>>
> >>>>>> As we need the PENDBASER_ADDRESS() in vgic-v3, let's move its
> >>>>>> definition in the irqchip header. We restore the full length
> >>>>>> of the field, ie [51:16]. Same for PROPBASER_ADDRESS with full
> >>>>>> field length of [51:12].
> >>>>>
> >>>>> why into irqchip and not just the vgic header file?
> >>>> Well most register field shift/masks are located there. This may be
> >>>> useful as well for the ITS driver if power management gets implemented
> >>>
> >>> Yeah, I'm fine with that. Having all of the HW description in one single
> >>> place makes sense.
> >>>
> >>>>>
> >>>>>>
> >>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>>>>>
> >>>>>> ---
> >>>>>>
> >>>>>> v6: new
> >>>>>> ---
> >>>>>>  include/linux/irqchip/arm-gic-v3.h |  2 ++
> >>>>>>  virt/kvm/arm/vgic/vgic-its.c       |  6 ++----
> >>>>>>  virt/kvm/arm/vgic/vgic-v3.c        | 44 ++++++++++++++++++++++++++++++++++++++
> >>>>>>  virt/kvm/arm/vgic/vgic.h           |  1 +
> >>>>>>  4 files changed, 49 insertions(+), 4 deletions(-)
> >>>>>>
> >>>>>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> >>>>>> index 9519c7b..e09e5d7 100644
> >>>>>> --- a/include/linux/irqchip/arm-gic-v3.h
> >>>>>> +++ b/include/linux/irqchip/arm-gic-v3.h
> >>>>>> @@ -159,6 +159,8 @@
> >>>>>>  #define GICR_PROPBASER_RaWaWb	GIC_BASER_CACHEABILITY(GICR_PROPBASER, INNER, RaWaWb)
> >>>>>>  
> >>>>>>  #define GICR_PROPBASER_IDBITS_MASK			(0x1f)
> >>>>>> +#define GICR_PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 12))
> >>>>>> +#define GICR_PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(51, 16))
> >>>>>>  
> >>>>>>  #define GICR_PENDBASER_SHAREABILITY_SHIFT		(10)
> >>>>>>  #define GICR_PENDBASER_INNER_CACHEABILITY_SHIFT		(7)
> >>>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> >>>>>> index e7bb86a..f43ea30c 100644
> >>>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
> >>>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
> >>>>>> @@ -198,8 +198,6 @@ static struct its_ite *find_ite(struct vgic_its *its, u32 device_id,
> >>>>>>   */
> >>>>>>  #define BASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
> >>>>>>  #define CBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
> >>>>>> -#define PENDBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 16))
> >>>>>> -#define PROPBASER_ADDRESS(x)	((x) & GENMASK_ULL(47, 12))
> >>>>>>  
> >>>>>>  #define GIC_LPI_OFFSET 8192
> >>>>>>  
> >>>>>> @@ -234,7 +232,7 @@ static struct its_collection *find_collection(struct vgic_its *its, int coll_id)
> >>>>>>  static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> >>>>>>  			     struct kvm_vcpu *filter_vcpu)
> >>>>>>  {
> >>>>>> -	u64 propbase = PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
> >>>>>> +	u64 propbase = GICR_PROPBASER_ADDRESS(kvm->arch.vgic.propbaser);
> >>>>>>  	u8 prop;
> >>>>>>  	int ret;
> >>>>>>  
> >>>>>> @@ -346,7 +344,7 @@ static u32 max_lpis_propbaser(u64 propbaser)
> >>>>>>   */
> >>>>>>  static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
> >>>>>>  {
> >>>>>> -	gpa_t pendbase = PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
> >>>>>> +	gpa_t pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
> >>>>>>  	struct vgic_irq *irq;
> >>>>>>  	int last_byte_offset = -1;
> >>>>>>  	int ret = 0;
> >>>>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >>>>>> index be0f4c3..0d753ae 100644
> >>>>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >>>>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >>>>>> @@ -252,6 +252,50 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
> >>>>>>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
> >>>>>>  }
> >>>>>>  
> >>>>>> +int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
> >>>>>> +{
> >>>>>> +	struct kvm_vcpu *vcpu;
> >>>>>> +	int byte_offset, bit_nr;
> >>>>>> +	gpa_t pendbase, ptr;
> >>>>>> +	bool status;
> >>>>>> +	u8 val;
> >>>>>> +	int ret;
> >>>>>> +
> >>>>>> +retry:
> >>>>>> +	vcpu = irq->target_vcpu;
> >>>>>> +	if (!vcpu)
> >>>>>> +		return 0;
> >>>>>> +
> >>>>>> +	pendbase = GICR_PENDBASER_ADDRESS(vcpu->arch.vgic_cpu.pendbaser);
> >>>>>> +
> >>>>>> +	byte_offset = irq->intid / BITS_PER_BYTE;
> >>>>>> +	bit_nr = irq->intid % BITS_PER_BYTE;
> >>>>>> +	ptr = pendbase + byte_offset;
> >>>>>> +
> >>>>>> +	ret = kvm_read_guest(kvm, ptr, &val, 1);
> >>>>>> +	if (ret)
> >>>>>> +		return ret;
> >>>>>> +
> >>>>>> +	status = val & (1 << bit_nr);
> >>>>>> +
> >>>>>> +	spin_lock(&irq->irq_lock);
> >>>>>> +	if (irq->target_vcpu != vcpu) {
> >>>>>> +		spin_unlock(&irq->irq_lock);
> >>>>>> +		goto retry;
> >>>>>
> >>>>> Can the guest be continuously changing the configuration of the LPI and
> >>>>> cause this function to be called, which will efficiently hog this CPU
> >>>>> from the system, or am I being overly cautious here?
> >>>> Yes but on the other hand, there is a risk the target_vcpu has changed,
> >>>> isn't it? So the alternative you be to return -EBUSY. and caller, ie.
> >>>> its_add_lpi would return that error?
> >>>
> >>> For the guest to be changing the LPI configuration, it would take a
> >>> command to be issued. If there is a concern that we're racing against a
> >>> command, can we take the command queue mutex?
> >>>
> >>
> >> So this is a redistributor thing, not an ITS thing, so I'd prefer not
> >> solving it that way.
> > 
> > Indeed.
> > 
> >> I was just thinking if we should do a limit of the number of times we'll
> >> do this or check if we have a pending signal and just return, but
> >> actually, I don't think this is a problem, because the path that keeps
> >> changing the configuration will eventually run out of CPU resources and
> >> this thread would have forward progress.
> > 
> > Yes, assuming we're not holding any other spinlock on the same path.
> > Looking at the code, we only seem to come here from handling MAPI/MAPTI,
> > so we should be good.
> > 
> >>>>>
> >>>>>> +	}
> >>>>>> +	irq->pending_latch = status;
> >>>>>> +	vgic_queue_irq_unlock(vcpu->kvm, irq);
> >>>>>> +
> >>>>>> +	if (status) {
> >>>>>> +		/* clear consumed data */
> >>>>>> +		val &= ~(1 << bit_nr);
> >>>>>> +		ret = kvm_write_guest(kvm, ptr, &val, 1);
> >>>>>> +		if (ret)
> >>>>>> +			return ret;
> >>>>>
> >>>>> Do we have a problem that if this is done twice within the same byte (on
> >>>>> different LPIs) then the data could be strangely out of sync?
> >>>> Not sure I get what you mean here? I reset a single bit within the byte.
> >>>> Do you mean there could be a concurrency issue?
> >>>>
> >>>> In principle we are not obliged to reset the bit, right? Why do we care?
> >>>> The table will be updated on next pending table save.
> >>>
> >>> 1) the guest should never write to the pending table.
> >>> 2) if there is an interrupt being injected, it will be made pending in
> >>> the irq structure, and not in the PT.
> >>
> >> If you have tGwo separate cores running this function at the same time,
> >> trying to clear each a bit in the same word, wouldn't you loose one of
> >> the cleared bits?
> > 
> > Ah, I see what you mean now (I was obviously looking at the wrong end of
> > the problem).
> > 
> >> Maybe that can never happen because the commands would be serialized and
> >> we should be restoring the system in serial as well?
> > 
> > I think that should be the case. What does it mean to do two restore in
> > parallel? We should probably enforce this. Eric?
> We can't have 2 restores in parallel as we hold the kvm->lock all along.
> MAPI commands are serialized by its_cmd_lock. MAPI and restore cannot
> happen concurrently since vcpu is stopped and kvm_lock is held during
> GITS_CWRITER setting too. So my understanding is it can't have this race.
> 

Agreed.  Thanks for helping me figure this out.

-Christoffer
