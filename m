From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH v3 13/19] KVM: arm64: ITS: Sort the device and ITE lists
Date: Mon, 20 Mar 2017 18:14:52 +0000
Message-ID: <02ff8c85-abd9-ba29-bbc7-bb88761aeaa2@arm.com>
References: <1488800074-21991-1-git-send-email-eric.auger@redhat.com>
 <1488800074-21991-14-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E137640C22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:11:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id crV9W988XS0e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 14:11:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BA0E40AE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:11:13 -0400 (EDT)
In-Reply-To: <1488800074-21991-14-git-send-email-eric.auger@redhat.com>
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

Hi Eric,

On 06/03/17 11:34, Eric Auger wrote:
> Natively sort the device and ITE lists in ascending
> deviceId/eventid order. This paves the way to optimized
> DTE and ITE scan in guest RAM table where entries are chained
> together using a next ID offset.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

Looks correct to me.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 9792110..1cd6ae6 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -734,6 +734,21 @@ static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
>  	kfree(collection);
>  }
>  
> +static void ite_list_insert_sorted(struct list_head *h, struct its_ite *ite)
> +{
> +	struct list_head *pos = h->next;
> +	u32 id = ite->event_id;
> +
> +	while (pos != h) {
> +		struct its_ite *iter =
> +			list_entry(pos, struct its_ite, ite_list);
> +		if (id < iter->event_id)
> +			break;
> +		pos = pos->next;
> +	}
> +	list_add_tail(&ite->ite_list, pos);
> +}
> +
>  static int vgic_its_alloc_ite(struct its_device *device,
>  			       struct its_ite **itep,
>  			       struct its_collection *collection,
> @@ -749,7 +764,7 @@ static int vgic_its_alloc_ite(struct its_device *device,
>  	ite->collection = collection;
>  	ite->lpi = lpi_id;
>  
> -	list_add_tail(&ite->ite_list, &device->itt_head);
> +	ite_list_insert_sorted(&device->itt_head, ite);
>  	*itep = ite;
>  	return 0;
>  }
> @@ -842,6 +857,22 @@ static void vgic_its_unmap_device(struct kvm *kvm, struct its_device *device)
>  	kfree(device);
>  }
>  
> +static void device_list_insert_sorted(struct list_head *h,
> +				      struct its_device *dev)
> +{
> +	struct list_head *pos = h->next;
> +	u32 id = dev->device_id;
> +
> +	while (pos != h) {
> +		struct its_device *iter =
> +			list_entry(pos, struct its_device, dev_list);
> +		if (id < iter->device_id)
> +			break;
> +		pos = pos->next;
> +	}
> +	list_add_tail(&dev->dev_list, pos);
> +}
> +
>  static int vgic_its_alloc_device(struct vgic_its *its,
>  				 struct its_device **devp,
>  				 u32 device_id, gpa_t itt_addr_field,
> @@ -858,7 +889,8 @@ static int vgic_its_alloc_device(struct vgic_its *its,
>  	device->nb_eventid_bits = size_field + 1;
>  	INIT_LIST_HEAD(&device->itt_head);
>  
> -	list_add_tail(&device->dev_list, &its->device_list);
> +	device_list_insert_sorted(&its->device_list, device);
> +
>  	*devp = device;
>  
>  	return 0;
> 
