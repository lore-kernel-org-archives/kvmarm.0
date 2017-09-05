From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 5/6] KVM: arm/arm64: Rearrange kvm_vgic_[un]map_phys
 code in vgic.c
Date: Tue, 5 Sep 2017 16:00:24 +0200
Message-ID: <20170905140024.GP13572@cbox>
References: <20170904102456.9025-1-cdall@linaro.org>
 <20170904102456.9025-6-cdall@linaro.org>
 <56431c9d-3f7e-f8b2-2d31-6baec4e294da@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E48940D25
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 09:58:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wKuKMY6hhwI9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Sep 2017 09:58:05 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DDD9040A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Sep 2017 09:58:04 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id 187so19738444wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Sep 2017 07:00:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <56431c9d-3f7e-f8b2-2d31-6baec4e294da@redhat.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Sep 05, 2017 at 12:26:14PM +0200, Auger Eric wrote:
> Hi Christoffer,
> On 04/09/2017 12:24, Christoffer Dall wrote:
> > The small indirection of a static function made the locking very obvious
> > but becomes pretty ugly as we start passing function pointer around.
> > Let's inline these two functions first to make the following patch more
> > readable.
> > 
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  virt/kvm/arm/vgic/vgic.c | 38 +++++++++++++-------------------------
> >  1 file changed, 13 insertions(+), 25 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index 7aec730..b704ff5 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -435,12 +435,17 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> >  	return 0;
> >  }
> >  
> > -/* @irq->irq_lock must be held */
> I chose to hold the lock outside of kvm_vgic_map/unmap_irq because in
> kvm_vgic_set_forwarding(see https://lkml.org/lkml/2017/6/15/278) I was
> also testing hw and target_vcpu fields. As you pointed out maybe I am
> not obliged to check them but that was the rationale.
> 

Ah ok, I see, you want to reuse this bit of code and the caller will
already be holding the spin-lock?

I can rework it then to pass the callback in kvm_vgic_map_irq.  Would
that fit better with your subsequent patches?

Thanks,
-Christoffer

> > -static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> > -			    unsigned int host_irq)
> > +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> > +			  u32 vintid)
> >  {
> > +	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
> >  	struct irq_desc *desc;
> >  	struct irq_data *data;
> > +	int ret = 0;
> > +
> > +	BUG_ON(!irq);
> > +
> > +	spin_lock(&irq->irq_lock);
> >  
> >  	/*
> >  	 * Find the physical IRQ number corresponding to @host_irq
> > @@ -448,7 +453,8 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> >  	desc = irq_to_desc(host_irq);
> >  	if (!desc) {
> >  		kvm_err("%s: no interrupt descriptor\n", __func__);
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		goto out;
> >  	}
> >  	data = irq_desc_get_irq_data(desc);
> >  	while (data->parent_data)
> > @@ -457,29 +463,10 @@ static int kvm_vgic_map_irq(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> >  	irq->hw = true;
> >  	irq->host_irq = host_irq;
> >  	irq->hwintid = data->hwirq;
> > -	return 0;
> > -}
> > -
> > -/* @irq->irq_lock must be held */
> > -static inline void kvm_vgic_unmap_irq(struct vgic_irq *irq)
> > -{
> > -	irq->hw = false;
> > -	irq->hwintid = 0;
> > -}
> > -
> > -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> > -			  u32 vintid)
> > -{
> > -	struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, vintid);
> > -	int ret;
> >  
> > -	BUG_ON(!irq);
> > -
> > -	spin_lock(&irq->irq_lock);
> > -	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
> > +out:
> >  	spin_unlock(&irq->irq_lock);
> >  	vgic_put_irq(vcpu->kvm, irq);
> > -
> >  	return ret;
> >  }
> >  
> > @@ -494,7 +481,8 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int vintid)
> >  	BUG_ON(!irq);
> >  
> >  	spin_lock(&irq->irq_lock);
> > -	kvm_vgic_unmap_irq(irq);
> > +	irq->hw = false;
> > +	irq->hwintid = 0;
> >  	spin_unlock(&irq->irq_lock);
> >  	vgic_put_irq(vcpu->kvm, irq);
> >  
> > 
