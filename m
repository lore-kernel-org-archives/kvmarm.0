Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062118BF6
	for <kvmarm@lists.linux.dev>; Sun, 21 Apr 2024 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713684523; cv=none; b=hVZPNdsRw5g9/mscL1+cdxQkM9/liFpsA/JQHJ3WQpFWAv5wHVYsySG7/T60Rt3WDD3ZxZ9IH0Ooly5q3f5vcbzEUSYoVEAvyHnNgeVR29gPmOqQkfDZG8NhD+3hTbDEnRMRPjcIZIXfD6Hl2qxyIlopuSgHU1THTi2IntsUiIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713684523; c=relaxed/simple;
	bh=OfHY12ydOu2Ke0tUIIo089e5Is2fVfEKTWAOZRFHw/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GijmOt0tPjnaGmXf5nEV2uUvQqVDc5w+zFWeS9bGDY/VhX4S4qgwfqMWPVDcY1dLe5CwMoqzbTVtdhE/SW4n2+caBXWLBQ7h7bIk+s9ddsSt8YZPwxPYfMo3OnjCxitLtRLDsOkzgpZY+zlxMqsfq/LTzzkkx8TWnF97mILk1K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NSR3+2i8; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NSR3+2i8"
Date: Sun, 21 Apr 2024 00:28:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713684518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JwgIZJUfpfeDFqLnFomH4usJ2vXeTSDN6B4zIHeL9q4=;
	b=NSR3+2i8cH5tw+o62kCwS72o+ctyuPEbTM/xh9W+TINXrKiuTRfSdy2FHVx6k0cR0I0fHH
	BafqgVepvwRuCcAOY0D73eII9RdFxsSdnTPDvJTTiwmVpB+rtnaIuS2xHLSQYPv1l7LuNH
	1W/Z0XhdMbfw+baNCMHFg/TTcQs1sJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 09/19] KVM: arm64: vgic-its: Maintain a translation
 cache per ITS
Message-ID: <ZiTAJiD292meragb@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
 <20240419223842.951452-10-oliver.upton@linux.dev>
 <87wmorrgwb.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wmorrgwb.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 20, 2024 at 08:08:36PM +0100, Marc Zyngier wrote:
> On Fri, 19 Apr 2024 23:38:32 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > Within the context of a single ITS, it is possible to use an xarray to
> > cache the device ID & event ID translation to a particular irq
> > descriptor. Take advantage of this to build a translation cache capable
> > of fitting all valid translations for a given ITS.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/kvm/vgic/vgic-its.c | 26 +++++++++++++++++++++++++-
> >  include/kvm/arm_vgic.h         |  6 ++++++
> >  2 files changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> > index be17a53d16ef..fd576377c084 100644
> > --- a/arch/arm64/kvm/vgic/vgic-its.c
> > +++ b/arch/arm64/kvm/vgic/vgic-its.c
> > @@ -530,6 +530,11 @@ static struct vgic_its *__vgic_doorbell_to_its(struct kvm *kvm, gpa_t db)
> >  	return iodev->its;
> >  }
> >  
> > +static unsigned long vgic_its_cache_key(u32 devid, u32 eventid)
> > +{
> > +	return (((unsigned long)devid) << 32) | eventid;
> > +}
> > +
> 
> Although this is correct, you may want to use the fact that our
> EIDs/DIDs are limited to 16 bits, as advertised in GITS_TYPER. By
> having a more compact index, you'd get better performance from the
> xarray itself (this is alluded to in the documentation).

Right, that'd definitely be useful. I think we'll need an early,
explicit check that EID + DID are within range if we go with this
option, as we currently rely on find_ite() failing in the slow path to
do that for us.

> >  static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
> >  					       phys_addr_t db,
> >  					       u32 devid, u32 eventid)
> > @@ -583,6 +588,7 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> >  				       u32 devid, u32 eventid,
> >  				       struct vgic_irq *irq)
> >  {
> > +	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
> >  	struct vgic_dist *dist = &kvm->arch.vgic;
> >  	struct vgic_translation_cache_entry *cte;
> >  	unsigned long flags;
> > @@ -592,6 +598,9 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> >  	if (irq->hw)
> >  		return;
> >  
> > +	if (xa_reserve_irq(&its->translation_cache, cache_key, GFP_KERNEL_ACCOUNT))
> > +		return;
> > +
> >  	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> >  
> >  	if (unlikely(list_empty(&dist->lpi_translation_cache)))
> > @@ -624,6 +633,11 @@ static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> >  	 */
> >  	lockdep_assert_held(&its->its_lock);
> >  	vgic_get_irq_kref(irq);
> > +	/*
> > +	 * Get a second ref for the ITS' translation cache. This will
> > +	 * disappear.
> 
> Is that for the *global* translation cache? Or this one? I guess there
> is one for each, but a clearer comment would help, even if this gets
> removed three patches down the line.

Sounds good, I'll just spell it out completely.

> > @@ -1967,6 +1988,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
> >  
> >  	INIT_LIST_HEAD(&its->device_list);
> >  	INIT_LIST_HEAD(&its->collection_list);
> > +	xa_init_flags(&its->translation_cache, XA_FLAGS_LOCK_IRQ);
> >  
> >  	dev->kvm->arch.vgic.msis_require_devid = true;
> >  	dev->kvm->arch.vgic.has_its = true;
> > @@ -1997,6 +2019,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
> >  
> >  	vgic_its_free_device_list(kvm, its);
> >  	vgic_its_free_collection_list(kvm, its);
> > +	vgic_its_invalidate_cache(its);
> > +	xa_destroy(&its->translation_cache);
> >  
> >  	mutex_unlock(&its->its_lock);
> >  	kfree(its);
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index ac7f15ec1586..0b027ed71dac 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -210,6 +210,12 @@ struct vgic_its {
> >  	struct mutex		its_lock;
> >  	struct list_head	device_list;
> >  	struct list_head	collection_list;
> > +
> > +	/*
> > +	 * Caches the (device_id, event_id) -> vgic_irq translation for
> > +	 * *deliverable* LPIs.
> 
> Can you clarify what "deliverable" LPIs are? That's not an
> architectural term, and I'd rather you describe the conditions that
> allow the LPI to be cached (my guess is: mapped and enabled).

Sure, I can just say that instead.

-- 
Thanks,
Oliver
