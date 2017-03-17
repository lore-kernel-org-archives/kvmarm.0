From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 12/19] KVM: arm64: ITS: vgic_its_alloc_ite/device
Date: Fri, 17 Mar 2017 17:01:03 +0000
Message-ID: <f913a9be-d994-9c18-3a30-e60e1778480a@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-13-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2073B40A74
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 12:57:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g0eD7SxFlnA3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Mar 2017 12:57:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D6CCA40064
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Mar 2017 12:57:33 -0400 (EDT)
In-Reply-To: <1488800074-21991-13-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Prasun.Kapoor@cavium.com, quintela@redhat.com, dgilbert@redhat.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 06/03/17 11:34, Eric Auger wrote:
> Add two new helpers to allocate an its ite and an its device.
> This will avoid duplication on restore path.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - report itt_size fix and remove ITE_SIZE
> - s/itte/ite/g
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 70 +++++++++++++++++++++++++++++---------------
>  1 file changed, 47 insertions(+), 23 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index dd7545a..9792110 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -734,6 +734,26 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
>  	kfree(collection);
>  }
>  

Can you please propagate the:
"Must be called with its_lock mutex held." comment here?

> +static int vgic_its_alloc_ite(struct its_device *device,
> +			       struct its_ite **itep,
> +			       struct its_collection *collection,
> +			       u32 lpi_id, u32 event_id)
> +{
> +	struct its_ite *ite;
> +
> +	ite = kzalloc(sizeof(ite), GFP_KERNEL);

That should be sizeof(*ite) or sizeof(struct its_ite).

> +	if (!ite)
> +		return -ENOMEM;
> +
> +	ite->event_id	= event_id;
> +	ite->collection = collection;
> +	ite->lpi = lpi_id;
> +
> +	list_add_tail(&ite->ite_list, &device->itt_head);
> +	*itep = ite;
> +	return 0;
> +}
> +
>  /*
>   * The MAPTI and MAPI commands map LPIs to ITTEs.
>   * Must be called with its_lock mutex held.
> @@ -747,7 +767,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	struct its_ite *ite;
>  	struct its_device *device;
>  	struct its_collection *collection, *new_coll = NULL;
> -	int lpi_nr;
> +	int lpi_nr, ret;
>  	struct vgic_irq *irq;
>  
>  	device = find_its_device(its, device_id);
> @@ -777,19 +797,13 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  		new_coll = collection;
>  	}
>  
> -	ite = kzalloc(sizeof(struct its_ite), GFP_KERNEL);
> -	if (!ite) {
> +	ret = vgic_its_alloc_ite(device, &ite, collection, lpi_nr, event_id);
> +	if (ret) {
>  		if (new_coll)
>  			vgic_its_free_collection(its, coll_id);
> -		return -ENOMEM;
> +		return ret;
>  	}
>  
> -	ite->event_id	= event_id;
> -	list_add_tail(&ite->ite_list, &device->itt_head);
> -
> -	ite->collection = collection;
> -	ite->lpi = lpi_nr;
> -
>  	irq = vgic_add_lpi(kvm, lpi_nr);
>  	if (IS_ERR(irq)) {
>  		if (new_coll)
> @@ -828,6 +842,28 @@ static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
>  	kfree(device);
>  }
>  
> +static int vgic_its_alloc_device(struct vgic_its *its,
> +				 struct its_device **devp,
> +				 u32 device_id, gpa_t itt_addr_field,
> +				 size_t size_field)
> +{
> +	struct its_device *device;
> +
> +	device = kzalloc(sizeof(*device), GFP_KERNEL);
> +	if (!device)
> +		return -ENOMEM;
> +
> +	device->device_id = device_id;
> +	device->itt_addr = itt_addr_field << 8;
> +	device->nb_eventid_bits = size_field + 1;

I'd rather see these command buffer entry decodings done at the source,
not here (though this isn't in this patch).

The rest looks fine.

Cheers,
Andre

> +	INIT_LIST_HEAD(&device->itt_head);
> +
> +	list_add_tail(&device->dev_list, &its->device_list);
> +	*devp = device;
> +
> +	return 0;
> +}
> +
>  /*
>   * MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs).
>   * Must be called with the its_lock mutex held.
> @@ -864,19 +900,7 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  	if (!valid)
>  		return 0;
>  
> -	device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
> -	if (!device)
> -		return -ENOMEM;
> -
> -	device->device_id = device_id;
> -	device->itt_addr = itt_addr << 8;
> -	device->nb_eventid_bits = size + 1;
> -
> -	INIT_LIST_HEAD(&device->itt_head);
> -
> -	list_add_tail(&device->dev_list, &its->device_list);
> -
> -	return 0;
> +	return vgic_its_alloc_device(its, &device, device_id, itt_addr, size);
>  }
>  
>  /*
> 
