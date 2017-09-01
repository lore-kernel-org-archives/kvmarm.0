From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vITS: Drop its_ite->lpi field
Date: Fri, 1 Sep 2017 18:03:00 +0100
Message-ID: <956fab56-0d64-6c36-183c-11b43d0fabd9@arm.com>
References: <20170901165156.30775-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170901165156.30775-1-marc.zyngier@arm.com>
Content-Language: en-GB
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 01/09/17 17:51, Marc Zyngier wrote:
> For unknown reasons, the its_ite data structure carries an "lpi" field
> which contains the intid of the LPI. This is an obvious duplication
> of the vgic_irq->intid field, so let's fix the only user and remove
> the now useless field.

Interesting, I guess that comes from the dawn of time, before we had
struct vgic_irq. And since the architecture says that the LPI ID is the
actual information stored in the ITE, I never revisited this again.

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Looks good to me!

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Thanks,
Andre.

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index dd85817a9b29..01aa4d9d405e 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -142,7 +142,6 @@ struct its_ite {
>  
>  	struct vgic_irq *irq;
>  	struct its_collection *collection;
> -	u32 lpi;
>  	u32 event_id;
>  };
>  
> @@ -851,7 +850,7 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
>  /* Must be called with its_lock mutex held */
>  static struct its_ite *vgic_its_alloc_ite(struct its_device *device,
>  					  struct its_collection *collection,
> -					  u32 lpi_id, u32 event_id)
> +					  u32 event_id)
>  {
>  	struct its_ite *ite;
>  
> @@ -861,7 +860,6 @@ static struct its_ite *vgic_its_alloc_ite(struct its_device *device,
>  
>  	ite->event_id	= event_id;
>  	ite->collection = collection;
> -	ite->lpi = lpi_id;
>  
>  	list_add_tail(&ite->ite_list, &device->itt_head);
>  	return ite;
> @@ -911,7 +909,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  		new_coll = collection;
>  	}
>  
> -	ite = vgic_its_alloc_ite(device, collection, lpi_nr, event_id);
> +	ite = vgic_its_alloc_ite(device, collection, event_id);
>  	if (IS_ERR(ite)) {
>  		if (new_coll)
>  			vgic_its_free_collection(its, coll_id);
> @@ -1902,7 +1900,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>  
>  	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
>  	val = ((u64)next_offset << KVM_ITS_ITE_NEXT_SHIFT) |
> -	       ((u64)ite->lpi << KVM_ITS_ITE_PINTID_SHIFT) |
> +	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
>  		ite->collection->collection_id;
>  	val = cpu_to_le64(val);
>  	return kvm_write_guest(kvm, gpa, &val, ite_esz);
> @@ -1949,7 +1947,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
>  	if (!collection)
>  		return -EINVAL;
>  
> -	ite = vgic_its_alloc_ite(dev, collection, lpi_id, event_id);
> +	ite = vgic_its_alloc_ite(dev, collection, event_id);
>  	if (IS_ERR(ite))
>  		return PTR_ERR(ite);
>  
> 
