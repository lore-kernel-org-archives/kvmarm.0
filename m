From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] KVM: arm64: vgic-its: Plug race in vgic_put_irq
Date: Tue, 9 Aug 2016 12:20:19 +0200
Message-ID: <20160809102019.GC9175@cbox>
References: <20160803161325.14933-1-christoffer.dall@linaro.org>
 <20160803161325.14933-3-christoffer.dall@linaro.org>
 <ff8d6b98-a013-5292-af35-8fd97ec54700@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ff8d6b98-a013-5292-af35-8fd97ec54700@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Aug 08, 2016 at 12:20:14PM +0100, Andre Przywara wrote:
> Hi,
> 
> On 03/08/16 17:13, Christoffer Dall wrote:
> > Right now the following sequence of events can happen:
> > 
> >   1. Thread X calls vgic_put_irq
> >   2. Thread Y calls vgic_add_lpi
> >   3. Thread Y gets lpi_list_lock
> >   4. Thread X drops the ref count to 0 and blocks on lpi_list_lock
> >   5. Thread Y finds the irq via the lpi_list_lock, raises the ref
> >      count to 1, and release the lpi_list_lock.
> >   6. Thread X proceeds and frees the irq.
> > 
> > Avoid this by holding the spinlock around the kref_put.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> >  virt/kvm/arm/vgic/vgic.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index e7aeac7..fb8c0ab 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -117,22 +117,22 @@ static void vgic_irq_release(struct kref *ref)
> >  
> >  void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> >  {
> > -	struct vgic_dist *dist;
> > +	struct vgic_dist *dist = &kvm->arch.vgic;
> >  
> >  	if (irq->intid < VGIC_MIN_LPI)
> >  		return;
> >  
> > -	if (!kref_put(&irq->refcount, vgic_irq_release))
> > -		return;
> > -
> > -	dist = &kvm->arch.vgic;
> > -
> >  	spin_lock(&dist->lpi_list_lock);
> > -	list_del(&irq->lpi_list);
> > -	dist->lpi_list_count--;
> > -	spin_unlock(&dist->lpi_list_lock);
> > +	if (!kref_put(&irq->refcount, vgic_irq_release)) {
> > +		spin_unlock(&dist->lpi_list_lock);
> > +		return;
> > +	} else {
> 
> Just a nit, I guess, but we don't need this "else" since the if-branch
> always returns?
> 

correct, I can change that.

> > +		list_del(&irq->lpi_list);
> > +		dist->lpi_list_count--;
> > +		spin_unlock(&dist->lpi_list_lock);
> >  
> > -	kfree(irq);
> > +		kfree(irq);
> > +	}
> >  }
> >  
> >  /**
> > 
> 
> Otherwise:
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> 
Thanks.
-Christoffer
