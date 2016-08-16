From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm64: ITS: avoid re-mapping LPIs
Date: Tue, 16 Aug 2016 19:26:58 +0200
Message-ID: <20160816172658.GE14088@cbox>
References: <20160816165106.25057-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB4D448531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 13:17:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U6yJ1hy+mUAo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2016 13:17:33 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C3DA413E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 13:17:33 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id i5so182563125wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2016 10:25:00 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160816165106.25057-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 16, 2016 at 05:51:06PM +0100, Andre Przywara wrote:
> When a guest wants to map a device-ID/event-ID combination that is
> already mapped, we may end up in a situation where an LPI is never
> "put", thus never being freed.
> Since the GICv3 spec says that mapping an already mapped LPI is
> UNPREDICTABLE, lets just bail out early in this situation to avoid
> any potential leaks.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

Thanks!
-Christoffer

> ---
>  virt/kvm/arm/vgic/vgic-its.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 9533080..4660a7d 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -731,7 +731,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	u32 device_id = its_cmd_get_deviceid(its_cmd);
>  	u32 event_id = its_cmd_get_id(its_cmd);
>  	u32 coll_id = its_cmd_get_collection(its_cmd);
> -	struct its_itte *itte, *new_itte = NULL;
> +	struct its_itte *itte;
>  	struct its_device *device;
>  	struct its_collection *collection, *new_coll = NULL;
>  	int lpi_nr;
> @@ -749,6 +749,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	    lpi_nr >= max_lpis_propbaser(kvm->arch.vgic.propbaser))
>  		return E_ITS_MAPTI_PHYSICALID_OOR;
>  
> +	/* If there is an existing mapping, behavior is UNPREDICTABLE. */
> +	if (find_itte(its, device_id, event_id))
> +		return 0;
> +
>  	collection = find_collection(its, coll_id);
>  	if (!collection) {
>  		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
> @@ -757,20 +761,16 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  		new_coll = collection;
>  	}
>  
> -	itte = find_itte(its, device_id, event_id);
> +	itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
>  	if (!itte) {
> -		itte = kzalloc(sizeof(struct its_itte), GFP_KERNEL);
> -		if (!itte) {
> -			if (new_coll)
> -				vgic_its_free_collection(its, coll_id);
> -			return -ENOMEM;
> -		}
> -
> -		new_itte = itte;
> -		itte->event_id	= event_id;
> -		list_add_tail(&itte->itte_list, &device->itt_head);
> +		if (new_coll)
> +			vgic_its_free_collection(its, coll_id);
> +		return -ENOMEM;
>  	}
>  
> +	itte->event_id	= event_id;
> +	list_add_tail(&itte->itte_list, &device->itt_head);
> +
>  	itte->collection = collection;
>  	itte->lpi = lpi_nr;
>  
> @@ -778,8 +778,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	if (IS_ERR(irq)) {
>  		if (new_coll)
>  			vgic_its_free_collection(its, coll_id);
> -		if (new_itte)
> -			its_free_itte(kvm, new_itte);
> +		its_free_itte(kvm, itte);
>  		return PTR_ERR(irq);
>  	}
>  	itte->irq = irq;
> -- 
> 2.9.0
> 
