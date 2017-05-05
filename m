From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 17/24] KVM: arm64: vgic-its: vgic_its_alloc_ite/device
Date: Fri, 5 May 2017 05:04:56 -0700
Message-ID: <20170505120456.GE1419@lvm>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-18-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493898284-29504-18-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:37PM +0200, Eric Auger wrote:
> Add two new helpers to allocate an its ite and an its device.
> This will avoid duplication on restore path.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v5 -> v6:
> - remove Marc's A-b
> - both functions now return the newly allocated struct
> 
> v4 -> v5:
> - add Marc's A-b
> 
> v3 -> v4:
> - fix allocation
> - add comment about its_lock mutex hold
> 
> v1 -> v2:
> - report itt_size fix and remove ITE_SIZE
> - s/itte/ite/g
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 68 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 47 insertions(+), 21 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 5b251dc..ea8eb6a 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -776,6 +776,25 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
>  	kfree(collection);
>  }
>  
> +/* Must be called with its_lock mutex held */
> +static struct its_ite *vgic_its_alloc_ite(struct its_device *device,
> +					  struct its_collection *collection,
> +					  u32 lpi_id, u32 event_id)
> +{
> +	struct its_ite *ite;
> +
> +	ite = kzalloc(sizeof(*ite), GFP_KERNEL);
> +	if (!ite)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ite->event_id	= event_id;
> +	ite->collection = collection;
> +	ite->lpi = lpi_id;
> +
> +	list_add_tail(&ite->ite_list, &device->itt_head);
> +	return ite;
> +}
> +
>  /*
>   * The MAPTI and MAPI commands map LPIs to ITTEs.
>   * Must be called with its_lock mutex held.
> @@ -790,8 +809,8 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	struct kvm_vcpu *vcpu = NULL;
>  	struct its_device *device;
>  	struct its_collection *collection, *new_coll = NULL;
> -	int lpi_nr;
>  	struct vgic_irq *irq;
> +	int lpi_nr;
>  
>  	device = find_its_device(its, device_id);
>  	if (!device)
> @@ -820,19 +839,13 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  		new_coll = collection;
>  	}
>  
> -	ite = kzalloc(sizeof(struct its_ite), GFP_KERNEL);
> -	if (!ite) {
> +	ite = vgic_its_alloc_ite(device, collection, lpi_nr, event_id);
> +	if (IS_ERR(ite)) {
>  		if (new_coll)
>  			vgic_its_free_collection(its, coll_id);
> -		return -ENOMEM;
> +		return PTR_ERR(ite);
>  	}
>  
> -	ite->event_id	= event_id;
> -	list_add_tail(&ite->ite_list, &device->itt_head);
> -
> -	ite->collection = collection;
> -	ite->lpi = lpi_nr;
> -
>  	if (its_is_collection_mapped(collection))
>  		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>  
> @@ -865,6 +878,26 @@ static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
>  	kfree(device);
>  }
>  
> +/* Must be called with its_lock mutex held */
> +static struct its_device *vgic_its_alloc_device(struct vgic_its *its,
> +						u32 device_id, gpa_t itt_addr,
> +						u8 num_eventid_bits)
> +{
> +	struct its_device *device;
> +
> +	device = kzalloc(sizeof(*device), GFP_KERNEL);
> +	if (!device)
> +		return ERR_PTR(-ENOMEM);
> +
> +	device->device_id = device_id;
> +	device->itt_addr = itt_addr;
> +	device->num_eventid_bits = num_eventid_bits;
> +	INIT_LIST_HEAD(&device->itt_head);
> +
> +	list_add_tail(&device->dev_list, &its->device_list);
> +	return device;
> +}
> +
>  /*
>   * MAPD maps or unmaps a device ID to Interrupt Translation Tables (ITTs).
>   * Must be called with the its_lock mutex held.
> @@ -901,17 +934,10 @@ static int vgic_its_cmd_handle_mapd(struct kvm *kvm, struct vgic_its *its,
>  	if (!valid)
>  		return 0;
>  
> -	device = kzalloc(sizeof(struct its_device), GFP_KERNEL);
> -	if (!device)
> -		return -ENOMEM;
> -
> -	device->device_id = device_id;
> -	device->num_eventid_bits = num_eventid_bits;
> -	device->itt_addr = itt_addr;
> -
> -	INIT_LIST_HEAD(&device->itt_head);
> -
> -	list_add_tail(&device->dev_list, &its->device_list);
> +	device = vgic_its_alloc_device(its, device_id, itt_addr,
> +				       num_eventid_bits);
> +	if (IS_ERR(device))
> +		return PTR_ERR(device);
>  
>  	return 0;
>  }
> -- 
> 2.5.5
> 

Reviewed-by: Christoffer Dall <cdall@linaro.org>
