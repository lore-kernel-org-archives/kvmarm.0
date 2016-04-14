From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 06/45] KVM: arm/arm64: vgic-new: Implement virtual
 IRQ injection
Date: Thu, 14 Apr 2016 14:15:06 +0200
Message-ID: <20160414121506.GI30804@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-7-git-send-email-andre.przywara@arm.com>
 <20160329211650.GF4126@cbox> <5703F5D7.5060803@arm.com>
 <20160406142358.GA26026@cbox> <570F769A.7040104@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AB96649B75
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 08:13:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7HryQX2hcTbV for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Apr 2016 08:13:03 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C1C949B6F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 08:13:02 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id v188so217338468wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Apr 2016 05:14:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <570F769A.7040104@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Apr 14, 2016 at 11:53:14AM +0100, Andre Przywara wrote:
> Hej,
> 
> On 06/04/16 15:23, Christoffer Dall wrote:
> > On Tue, Apr 05, 2016 at 06:28:55PM +0100, Andre Przywara wrote:
> >> Hi,
> >>
> >> On 29/03/16 22:16, Christoffer Dall wrote:
> >>> On Fri, Mar 25, 2016 at 02:04:29AM +0000, Andre Przywara wrote:
> >>>> From: Christoffer Dall <christoffer.dall@linaro.org>
> >>>>
> >>>> Provide a vgic_queue_irq() function which decides whether a given
> >>>> IRQ needs to be queued to a VCPU's ap_list.
> >>>> This should be called whenever an IRQ became pending or got enabled,
> >>>
> >>> becomes pending or enabled,
> >>>
> >>>> either as a result of userspace injection, from in-kernel emulated
> >>>> devices like the architected timer or from MMIO accesses to the
> >>>> distributor emulation.
> >>>> Also provides the necessary functions to allow userland to inject an
> >>>> IRQ to a guest.
> >>>
> >>> Since this is the first code that starts using our locking mechanism, we
> >>> add some (hopefully) clear documentation of our locking strategy and
> >>> requirements along with this patch.
> >>>
> >>>> [Andre: refactor out vgic_queue_irq()]
> >>>>
> >>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> >>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> >>>> ---
> >>>>  include/kvm/vgic/vgic.h  |   3 +
> >>>>  virt/kvm/arm/vgic/vgic.c | 181 +++++++++++++++++++++++++++++++++++++++++++++++
> >>>>  virt/kvm/arm/vgic/vgic.h |   1 +
> >>>>  3 files changed, 185 insertions(+)
> >>>>
> >>>> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> >>>> index 659f8b1..f32b284 100644
> >>>> --- a/include/kvm/vgic/vgic.h
> >>>> +++ b/include/kvm/vgic/vgic.h
> >>>> @@ -178,6 +178,9 @@ struct vgic_cpu {
> >>>>  	struct list_head ap_list_head;
> >>>>  };
> >>>>  
> >>>> +int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> >>>> +			bool level);
> >>>> +
> >>>>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
> >>>>  #define vgic_initialized(k)	(false)
> >>>>  #define vgic_ready(k)		((k)->arch.vgic.ready)
> >>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >>>> index 8e34916..a95aabc 100644
> >>>> --- a/virt/kvm/arm/vgic/vgic.c
> >>>> +++ b/virt/kvm/arm/vgic/vgic.c
> >>>> @@ -19,8 +19,25 @@
> >>>>  
> >>>>  #include "vgic.h"
> >>>>  
> >>>> +#define CREATE_TRACE_POINTS
> >>>> +#include "../trace.h"
> >>>> +
> >>>>  struct vgic_global kvm_vgic_global_state;
> >>>>  
> >>>> +/*
> >>>> + * Locking order is always:
> >>>> + *   vgic_cpu->ap_list_lock
> >>>> + *     vgic_irq->irq_lock
> >>>> + *
> >>>> + * (that is, always take the ap_list_lock before the struct vgic_irq lock).
> >>>> + *
> >>>> + * When taking more than one ap_list_lock at the same time, always take the
> >>>> + * lowest numbered VCPU's ap_list_lock first, so:
> >>>> + *   vcpuX->vcpu_id < vcpuY->vcpu_id:
> >>>> + *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
> >>>> + *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
> >>>> + */
> >>>> +
> >>>>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> >>>>  			      u32 intid)
> >>>>  {
> >>>> @@ -39,3 +56,167 @@ struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
> >>>>  	WARN(1, "Looking up struct vgic_irq for reserved INTID");
> >>>>  	return NULL;
> >>>>  }
> >>>> +
> >>>> +/**
> >>>> + * kvm_vgic_target_oracle - compute the target vcpu for an irq
> >>>> + *
> >>>> + * @irq:	The irq to route. Must be already locked.
> >>
> >>                                   ^^^^^^^^^^^^^^^^^^^^^^
> >>
> >>>> + *
> >>>> + * Based on the current state of the interrupt (enabled, pending,
> >>>> + * active, vcpu and target_vcpu), compute the next vcpu this should be
> >>>> + * given to. Return NULL if this shouldn't be injected at all.
> >>>> + */
> >>>> +static struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq)
> >>>> +{
> >>>> +	/* If the interrupt is active, it must stay on the current vcpu */
> >>>> +	if (irq->active)
> >>>> +		return irq->vcpu;
> >>>
> >>> we are not taking a lock here.  What are the locking expectations?  If
> >>> the expectarions are that the IRQ is locked when calling this function,
> >>> can we have a BIG FAT COMMENT saying that then?
> >>
> >> Do you mean really BIG FAT or is the above sufficient? (I guess not).
> >> I will make it more prominent.
> > 
> > well, maybe it doesn't have to be BIG FAT.  But I did miss the existing
> > comment.  I think it would be preferred to have a separate paragraph
> > explaining the locking expectaions, but perhaps I'm just
> > being stupid.
> 
> Fixed - not you being stupid - which you clearly aren't, so nothing to
> fix here; but the insufficient comment ;-)
> 
> >>
> >>> It seems to me that we are somehow expecting irq->active and irq->vcpu
> >>> to be in sync, but that's not necessarily the case if the IRQ is not
> >>> locked.
> >>>
> >>>> +
> >>>> +	/* If enabled and pending, it can migrate to a new one */
> >>>
> >>> I think this comment should be rewritten to:
> >>>
> >>> If the IRQ is not active but enabled and pending, we should direct it to
> >>> its configured target VCPU.
> >>>
> >>>> +	if (irq->enabled && irq->pending)
> >>>> +		return irq->target_vcpu;
> >>>> +
> >>>> +	/* Otherwise, it is considered idle */
> >>>
> >>> not sure what idle means here, I suggest something like:
> >>>
> >>> If neither active nor pending and enabled, then this IRQ should not be
> >>> queued to any VCPU.
> >>>
> >>>> +	return NULL;
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * Only valid injection if changing level for level-triggered IRQs or for a
> >>>> + * rising edge.
> >>>> + */
> >>>> +static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
> >>>> +{
> >>>> +	switch (irq->config) {
> >>>> +	case VGIC_CONFIG_LEVEL:
> >>>> +		return irq->line_level != level;
> >>>> +	case VGIC_CONFIG_EDGE:
> >>>> +		return level;
> >>>> +	default:
> >>>> +		BUG();
> >>>
> >>> is the default case there for making the compiler happy or can we just
> >>> get rid of it?
> >>
> >> Just removing it was fine (for GCC 5.3.0, at least).
> >>
> >>>> +	}
> >>>> +}
> >>>> +
> >>>> +/*
> >>>> + * Check whether an IRQ needs to (and can) be queued to a VCPU's ap list.
> >>>> + * Do the queuing if necessary, taking the right locks in the right order.
> >>>> + * Returns true when the IRQ was queued, false otherwise.
> >>>> + *
> >>>> + * Needs to be entered with the IRQ lock already held, but will return
> >>>> + * with all locks dropped.
> >>>> + */
> >>>> +bool vgic_queue_irq(struct kvm *kvm, struct vgic_irq *irq)
> >>>
> >>> should we name this vgic_try_queue_irq_locked ?
> >>
> >> Mmh, since it (re-)tries quite hard I am not sure _try_ would be
> >> misleading. Basically it queues the IRQ whenever possible and/or
> >> sensible. Having _unlock in it like you suggested in another reply makes
> >> more sense, I think.
> > 
> > agreed
> > 
> >>
> >>>> +{
> >>>> +	struct kvm_vcpu *vcpu = vgic_target_oracle(irq);
> >>>
> >>> should we have something like BUG_ON(!spin_is_locked(irq->irq_lock));
> >>> here?
> >>>
> >>> Not sure if there's some bug checking here which is only emitted if a
> >>> user select CONFIG_CHECK_SOME_LOCKING_THINGS that we could use...?
> >>
> >> There is CONFIG_DEBUG_SPINLOCK, but I couldn't find some conditional
> >> debug macro suitable for the purpose. I defined one now for the file
> >> only (since we have quite some users here).
> >>
> >>>> +
> >>>> +	if (irq->vcpu || !(irq->pending && irq->enabled) || !vcpu) {
> >>>> +		/*
> >>>> +		 * If this IRQ is already on a VCPU's ap_list, then it
> >>>> +		 * cannot be moved or modified and there is no more work for
> >>>> +		 * us to do.
> >>>> +		 *
> >>>> +		 * Otherwise, if the irq is not pending and enabled, it does
> >>>> +		 * not need to be inserted into an ap_list and there is also
> >>>> +		 * no more work for us to do.
> >>>> +		 */
> >>>
> >>> is the !vcpu check here not redundant because if you ever get to
> >>> evaluating it, then irq->vcpu is null, and pending and enabled are set,
> >>> which means the oracle couldn't have returned null, could it?
> >>
> >> In this case vcpu is always irq->target_vcpu, if I did the math
> >> correctly. So can this be NULL?
> >> Even if this is correct reasoning, I wonder if we optimize something
> >> prematurely here and rely on the current implementation of
> >> vgic_target_oracle(). I think the check for "!vcpu" is here to avoid a
> >> NULL pointer deference below (in the first spin_lock after the retry:
> >> label), so I'd rather keep this explicit check in here.
> > 
> > I'm really not a fan of building the correctness of one of the most
> > crucial parts of our code based on "let's add a few extra checks which
> > may not be necessary, just in case" kind of logic.
> > 
> > So let's be clear on why we have an if-statement here exactly:
> > 
> > As the comment says, if we can't move the IRQ, because it's already
> > assigned to somebody or if this IRQ is not pending or active, then it's
> > shouldn't be queued.
> > 
> > So the simple and all-encompassing check here is simply:
> > 
> > 	if (irq->vcpu || !vcpu) {
> > 		spin_unlock(&irq->irq_lock);
> > 		return false;
> > 	}
> > 
> > The only requirement for this to be correct is that the MMIO handler for
> > ISACTIVER to both set the active bit and the irq->vcpu pointer (and put
> > it on the AP list), without calling this function...).  That was my
> > quesiton below.
> > 
> > Because if that's not the case, you could end up here with irq->active
> > set, but irq->vcpu == NULL and !(pending && enabled) and you'd error
> > out, which means you would have to check explicitly for the active state
> > here as well, but I think that just becomes too messy.
> > 
> > So, just change this to what I propose and we can deal with the active
> > state MMIO handler separately.
> 
> I agree that setting the active state via MMIO is a mess in general and
> stuffing this case into this function here gets hairy.
> I am tempted to not support it in the first version, I guess it never
> really worked reliably before ...

I'm pretty sure it did, because we ran into migration breaking when this
wasn't supported for the save/restore userspace interface.

> 
> At the moment I am trying to code this explicitly into the SACTIVER
> handler and it's messy, too (because of the corner cases).
> Let's see how this will look like ...

ok.

If you want, you can focus on getting a new version out, and I can take
a stab at the SACTIVER together with the priority stuff.  OTOH, if you
already have something, then it may be worth following through with
that.

> 
> >>
> >>> that would also explain why we don't have to re-check the same
> >>> conditions below...
> >>>
> >>> or am I getting this wrong, because you could also have someone
> >>> explicitly setting the IRQ to active via trapped MMIO, in which case we
> >>> should be able to queue it without it being pending && enabled, which
> >>> would indicate that it's the other way around, you should only evaluate
> >>> !vcpu and kup the !(pending && enabled) part....?
> >>
> >> You lost me here, which hints at the fragility of this optimization ;-)
> >>
> >>>> +		spin_unlock(&irq->irq_lock);
> >>>> +		return false;
> >>>> +	}
> >>>> +
> >>>> +	/*
> >>>> +	 * We must unlock the irq lock to take the ap_list_lock where
> >>>> +	 * we are going to insert this new pending interrupt.
> >>>> +	 */
> >>>> +	spin_unlock(&irq->irq_lock);
> >>>> +
> >>>> +	/* someone can do stuff here, which we re-check below */
> >>>> +retry:
> >>>> +	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
> >>>> +	spin_lock(&irq->irq_lock);
> >>>> +
> >>>> +	/*
> >>>> +	 * Did something change behind our backs?
> >>>> +	 *
> >>>> +	 * There are two cases:
> >>>> +	 * 1) The irq became pending or active behind our backs and/or
> >>>> +	 *    the irq->vcpu field was set correspondingly when putting
> >>>> +	 *    the irq on an ap_list. Then drop the locks and return.
> >>>> +	 * 2) Someone changed the affinity on this irq behind our
> >>>> +	 *    backs and we are now holding the wrong ap_list_lock.
> >>>> +	 *    Then drop the locks and try the new VCPU.
> >>>> +	 */
> >>>> +	if (irq->vcpu || !(irq->pending && irq->enabled)) {
> >>>
> >>> here I'm concerned about the active state again.
> >>
> >> Mmmh, can you elaborate and sketch a case where the active state would
> >> cause trouble? This check is just here to avoid iterating on a no longer
> >> pending or enabled IRQ. I wonder if an active IRQ can really sneak into
> >> this function here in the first place?
> > 
> > After having gone through the series I think we should deal with
> > the active state queing directly in the vgic_mmio_write_sactive()
> > function.
> > 
> > But I still prefer to move the retry label to the very top of this
> > function, and simplify these two statemtns to the condition I suggested:
> > 
> > 	if (unlinkely(irq->vcpu || vcpu != vgic_target_oracle(irq)))
> > 		goto retry;
> > 
> > The cost is that we perform a few additional checks at runtime in the
> > case where the IRQ was migrated while we released a lock (rare), but I
> > think it simplifies the code.
> 
> OK, I made this change. Also the shorter check after asking the oracle
> above.
> This should also better work in the case where target_vcpu is NULL
> (because either no bit in TARGETSR is set or a non-existent MPIDR has
> been written into IROUTER).
> 
right.

Thanks,
-Christoffer
