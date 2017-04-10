From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 20/22] KVM: arm64: ITS: ITT flush and restore
Date: Mon, 10 Apr 2017 13:39:21 +0100
Message-ID: <718afa1b-e0ad-f758-012a-8e0ac6a140b8@arm.com>
References: <1490607072-21610-1-git-send-email-eric.auger@redhat.com>
 <1490607072-21610-21-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1490607072-21610-21-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, christoffer.dall@linaro.org, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 27/03/17 10:31, Eric Auger wrote:
> Introduce routines to flush and restore device ITT and their
> interrupt table entries (ITE).
> 
> The routines will be called on device table flush and
> restore. They will become static in subsequent patches.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v3 -> v4:
> - lookup_table and compute_next_eventid_offset become static in this
>   patch
> - remove static along with vgic_its_flush/restore_itt to avoid
>   compilation warnings
> - next field only computed with a shift (mask removed)
> - handle the case where the last element has not been found
> 
> v2 -> v3:
> - add return 0 in vgic_its_restore_ite (was in subsequent patch)
> 
> v2: creation
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 107 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 104 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index b907e3c..02c0694 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1707,7 +1707,7 @@ u32 compute_next_devid_offset(struct list_head *h, struct its_device *dev)
>  	return min_t(u32, next_offset, VITS_DTE_MAX_DEVID_OFFSET);
>  }
>  
> -u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
> +static u32 compute_next_eventid_offset(struct list_head *h, struct its_ite *ite)
>  {
>  	struct list_head *e = &ite->ite_list;
>  	struct its_ite *next;
> @@ -1749,8 +1749,8 @@ typedef int (*entry_fn_t)(struct vgic_its *its, u32 id, void *addr,
>   *
>   * Return: < 0 on error, 1 if last element identified, 0 otherwise
>   */
> -int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
> -		 int start_id, entry_fn_t fn, void *opaque)
> +static int lookup_table(struct vgic_its *its, gpa_t base, int size, int esz,
> +			int start_id, entry_fn_t fn, void *opaque)
>  {
>  	gpa_t gpa = base, top = base + size - 1;
>  	unsigned long len = size;
> @@ -1815,6 +1815,107 @@ static int vgic_its_restore_pending_tables(struct kvm *kvm)
>  	return -ENXIO;
>  }
>  
> +static int vgic_its_flush_ite(struct vgic_its *its, struct its_device *dev,
> +			      struct its_ite *ite, gpa_t gpa)
> +{
> +	struct kvm *kvm = its->dev->kvm;
> +	u32 next_offset;
> +	u64 val;
> +
> +	next_offset = compute_next_eventid_offset(&dev->itt_head, ite);
> +	val = ((u64)next_offset << 48) | ((u64)ite->lpi << 16) |
> +		ite->collection->collection_id;

Same remark as before concerning the #define-ing of the encoding and the
name of the function.

> +	val = cpu_to_le64(val);
> +	return kvm_write_guest(kvm, gpa, &val, VITS_ESZ);
> +}
> +
> +/**
> + * vgic_its_restore_ite - restore an interrupt translation entry
> + * @event_id: id used for indexing
> + * @ptr: kernel VA where the 8 byte ITE is located
> + * @opaque: pointer to the its_device
> + * @next: id offset to the next entry
> + */
> +static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
> +				void *ptr, void *opaque, u32 *next)
> +{
> +	struct its_device *dev = (struct its_device *)opaque;
> +	struct its_collection *collection;
> +	struct kvm *kvm = its->dev->kvm;
> +	u64 val, *p = (u64 *)ptr;
> +	struct vgic_irq *irq;
> +	u32 coll_id, lpi_id;
> +	struct its_ite *ite;
> +	int ret;
> +
> +	val = *p;
> +	*next = 1;
> +
> +	val = le64_to_cpu(val);
> +
> +	coll_id = val & GENMASK_ULL(15, 0);
> +	lpi_id = (val & GENMASK_ULL(47, 16)) >> 16;
> +
> +	if (!lpi_id)
> +		return 0;
> +
> +	*next = val >> 48;
> +
> +	collection = find_collection(its, coll_id);
> +	if (!collection)
> +		return -EINVAL;
> +
> +	ret = vgic_its_alloc_ite(dev, &ite, collection,
> +				  lpi_id, event_id);
> +	if (ret)
> +		return ret;
> +
> +	irq = vgic_add_lpi(kvm, lpi_id);
> +	if (IS_ERR(irq))
> +		return PTR_ERR(irq);
> +	ite->irq = irq;
> +
> +	/* restore the configuration of the LPI */
> +	ret = update_lpi_config(kvm, irq, NULL);
> +	if (ret)
> +		return ret;
> +
> +	update_affinity_ite(kvm, ite);
> +	return 0;
> +}
> +
> +int vgic_its_flush_itt(struct vgic_its *its, struct its_device *device)
> +{
> +	gpa_t base = device->itt_addr;
> +	struct its_ite *ite;
> +	int ret;
> +
> +	list_for_each_entry(ite, &device->itt_head, ite_list) {
> +		gpa_t gpa = base + ite->event_id * VITS_ESZ;
> +
> +		ret = vgic_its_flush_ite(its, device, ite, gpa);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +int vgic_its_restore_itt(struct vgic_its *its, struct its_device *dev)
> +{
> +	size_t max_size = BIT_ULL(dev->nb_eventid_bits) * VITS_ESZ;
> +	gpa_t base = dev->itt_addr;
> +	int ret;
> +
> +	ret =  lookup_table(its, base, max_size, VITS_ESZ, 0,
> +			    vgic_its_restore_ite, dev);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	/* if the last element has not been found we are in trouble */
> +	return ret ? 0 : -EINVAL;

This makes me wonder. Can't lookup_table perform that check on its own
and always return an error when something went wrong?

> +}
> +
>  /**
>   * vgic_its_flush_device_tables - flush the device table and all ITT
>   * into guest RAM
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
