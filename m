From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Handle errors from vgic_add_lpi
Date: Tue, 2 Aug 2016 17:08:34 +0200
Message-ID: <20160802150834.GT32244@cbox>
References: <20160801182952.3005-1-christoffer.dall@linaro.org>
 <57A0776F.5070401@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57F48411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 11:00:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYNkRHb-n8WP for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Aug 2016 11:00:09 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 05B484113E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Aug 2016 11:00:08 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id f65so413114434wmi.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Aug 2016 08:06:56 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <57A0776F.5070401@arm.com>
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
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 02, 2016 at 11:35:27AM +0100, Marc Zyngier wrote:
> On 01/08/16 19:29, Christoffer Dall wrote:
> > During low memory conditions, we could be dereferencing a NULL pointer
> > when vgic_add_lpi fails to allocate memory.
> > 
> > Consider for example this call sequence:
> > 
> >   vgic_its_cmd_handle_mapi
> >       itte->irq = vgic_add_lpi(kvm, lpi_nr);
> >           update_lpi_config(kvm, itte->irq, NULL);
> >               ret = kvm_read_guest(kvm, propbase + irq->intid
> > 	                                             ^^^^
> > 						     kaboom?
> > 
> > Instead, return an error pointer from vgic_add_lpi and check the return
> > value from its single caller.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic-its.c | 42 +++++++++++++++++++++++++++++-------------
> >  1 file changed, 29 insertions(+), 13 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> > index 07411cf..3515bdb 100644
> > --- a/virt/kvm/arm/vgic/vgic-its.c
> > +++ b/virt/kvm/arm/vgic/vgic-its.c
> > @@ -51,7 +51,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
> >  
> >  	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
> >  	if (!irq)
> > -		return NULL;
> > +		return ERR_PTR(-ENOMEM);
> >  
> >  	INIT_LIST_HEAD(&irq->lpi_list);
> >  	INIT_LIST_HEAD(&irq->ap_list);
> > @@ -697,24 +697,33 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  	struct its_device *device;
> >  	struct its_collection *collection, *new_coll = NULL;
> >  	int lpi_nr;
> > -
> > -	device = find_its_device(its, device_id);
> > -	if (!device)
> > -		return E_ITS_MAPTI_UNMAPPED_DEVICE;
> > +	struct vgic_irq *irq = NULL;
> > +	int err = 0;
> >  
> >  	if (its_cmd_get_command(its_cmd) == GITS_CMD_MAPTI)
> >  		lpi_nr = its_cmd_get_physical_id(its_cmd);
> >  	else
> >  		lpi_nr = event_id;
> > +
> >  	if (lpi_nr < GIC_LPI_OFFSET ||
> >  	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
> >  		return E_ITS_MAPTI_PHYSICALID_OOR;
> >  
> > +	irq = vgic_add_lpi(kvm, lpi_nr);
> > +	if (IS_ERR(irq))
> > +		return PTR_ERR(irq);
> > +
> > +	device = find_its_device(its, device_id);
> > +	if (!device) {
> > +		err = E_ITS_MAPTI_UNMAPPED_DEVICE;
> > +		goto out;
> > +	}
> > +
> >  	collection = find_collection(its, coll_id);
> >  	if (!collection) {
> > -		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
> > -		if (ret)
> > -			return ret;
> > +		err = vgic_its_alloc_collection(its, &collection, coll_id);
> > +		if (err)
> > +			goto out;
> >  		new_coll = collection;
> >  	}
> >  
> > @@ -722,9 +731,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  	if (!itte) {
> >  		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
> >  		if (!itte) {
> > -			if (new_coll)
> > -				vgic_its_free_collection(its, coll_id);
> > -			return -ENOMEM;
> > +			err = -ENOMEM;
> > +			goto out;
> >  		}
> >  
> >  		itte->event_id	= event_id;
> > @@ -733,7 +741,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  
> >  	itte->collection = collection;
> >  	itte->lpi = lpi_nr;
> > -	itte->irq = vgic_add_lpi(kvm, lpi_nr);
> > +	vgic_get_irq_kref(irq);
> > +	itte->irq = irq;
> >  	update_affinity_itte(kvm, itte);
> >  
> >  	/*
> > @@ -742,8 +751,15 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  	 * the respective config data from memory here upon mapping the LPI.
> >  	 */
> >  	update_lpi_config(kvm, itte->irq, NULL);
> > +	new_coll = NULL;
> > +	irq = NULL;
> >  
> > -	return 0;
> > +out:
> > +	if (new_coll)
> > +		vgic_its_free_collection(its, coll_id);
> > +	if (irq)
> > +		vgic_put_irq(kvm, irq);
> 
> Ah, it took me a moment to understand why you had the
> vgic_irq_get_kref() above. Maybe a small comment?
> 

actually, now I'm confused.

vgic_add_lpi returns a struct vgic_irq with a reference count for the
reference in the itte struct, right?

So we never get a reference for the irq->lpi_list/dist->lpi_list_head ?

In which case my code above is wrong and I should not be getting the
extra reference.  Right?



Now, this made me think of another issue.  vgic_add_lpi has a blurb in
there about racing with another vgic_add_lpi and then it returns an irq
with an additional reference.  But I don't understand how this can
happen, given that the function only has a single caller which has to
run with a mutex held???

Can two different itte's point to the same struct vgic_irq ?


Thanks,
-Christoffer
