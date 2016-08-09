From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 1/3] KVM: arm64: vgic-its: Handle errors from
 vgic_add_lpi
Date: Tue, 9 Aug 2016 12:09:56 +0200
Message-ID: <20160809100956.GB9175@cbox>
References: <20160803161325.14933-1-christoffer.dall@linaro.org>
 <20160803161325.14933-2-christoffer.dall@linaro.org>
 <cd0efae8-4584-bc57-705e-f0c0087020b2@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cd0efae8-4584-bc57-705e-f0c0087020b2@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 08, 2016 at 12:00:50PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 03/08/16 17:13, Christoffer Dall wrote:
> > During low memory conditions, we could be dereferencing a NULL pointer
> > when vgic_add_lpi fails to allocate memory.
> > 
> > Consider for example this call sequence:
> > 
> >   vgic_its_cmd_handle_mapi
> >       itte->irq = vgic_add_lpi(kvm, lpi_nr);
> 
> Ouch! Thanks for catching this unhandled error return!
> 
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
> > Changes since v1:
> >  - Don't errornously get an extra kref refernce for the struct vgic_irq
> >  - Don't rework the entire error handling of the function, but follow
> >    what Marc suggested he prefers based on his fixup patch.
> >  virt/kvm/arm/vgic/vgic-its.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> > index 07411cf..424f7a5 100644
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
> > @@ -693,10 +693,11 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  	u32 device_id = its_cmd_get_deviceid(its_cmd);
> >  	u32 event_id = its_cmd_get_id(its_cmd);
> >  	u32 coll_id = its_cmd_get_collection(its_cmd);
> > -	struct its_itte *itte;
> > +	struct its_itte *itte, *new_itte = NULL;
> >  	struct its_device *device;
> >  	struct its_collection *collection, *new_coll = NULL;
> >  	int lpi_nr;
> > +	struct vgic_irq *irq;
> >  
> >  	device = find_its_device(its, device_id);
> >  	if (!device)
> > @@ -720,7 +721,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  
> >  	itte = find_itte(its, device_id, event_id);
> >  	if (!itte) {
> > -		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
> > +		new_itte = itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
> 
> Nit: Aren't double assignments frowned upon in the kernel?
> 

Seems like it is accoding to CodingStyle, although it can be found
numerous places in the code base.  But you're right, let's follow the
official style.

> >  		if (!itte) {
> >  			if (new_coll)
> >  				vgic_its_free_collection(its, coll_id);
> > @@ -733,7 +734,16 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
> >  
> >  	itte->collection = collection;
> >  	itte->lpi = lpi_nr;
> > -	itte->irq = vgic_add_lpi(kvm, lpi_nr);
> > +
> > +	irq = vgic_add_lpi(kvm, lpi_nr);
> > +	if (IS_ERR(irq)) {
> > +		if (new_coll)
> > +			vgic_its_free_collection(its, coll_id);
> > +		kfree(new_itte);
> 
> But at this point we already have added that ITTE to the
> device->itt_head, haven't we?
> Since we hold the its_lock, would a simple:
> 
> 		if (new_itte) {
> 			list_del(&itte->itte_list);
> 			kfree(new_itte);
> 		}
> 
> suffice to fix this?
> 

hmm, it would be good to call its_free_itte for this.  But then that
would put a reference on an IRQ, which wouldn't necessarily have been
taken.  That could be reworked by changing its_free_itte like this:

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 424f7a5..6342c92 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -502,7 +502,8 @@ static void its_free_itte(struct kvm *kvm, struct its_itte *itte)
 	list_del(&itte->itte_list);
 
 	/* This put matches the get in vgic_add_lpi. */
-	vgic_put_irq(kvm, itte->irq);
+	if (iite->irq)
+		vgic_put_irq(kvm, itte->irq);
 
 	kfree(itte);
 }

But this makes me wonder how we're really dealing with reference counts
in the case where you find an itte and don't need to allocate one.
Would this BUG_ON ever fire?:

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 424f7a5..a33fbf1 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -730,6 +730,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 
 		itte->event_id	= event_id;
 		list_add_tail(&itte->itte_list, &device->itt_head);
+	} else {
+		BUG_ON(itte->irq);
 	}
 
 	itte->collection = collection;

If not, I don't understand how you can just assign the irq field on
the itte without putting whatever IRQ there may already be held with a
reference there.

Can you explain me the flow of how an itte is allocated, but not
assigned an IRQ, and then later found in vgic_its_cmd_handle_mapi?

> > +		return PTR_ERR(irq);
> > +	}
> > +	itte->irq = irq;
> > +
> >  	update_affinity_itte(kvm, itte);
> >  
> >  	/*
> > 
> 
Thanks,
-Christoffer
