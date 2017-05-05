From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 15/24] KVM: arm64: vgic-its: Read config and pending
 bit in add_lpi()
Date: Fri, 5 May 2017 02:57:08 -0700
Message-ID: <20170505095708.GB1419@lvm>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-16-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EC7E40A6A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 05:54:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UPeQzyfmXVd6 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 May 2017 05:54:04 -0400 (EDT)
Received: from mail-lf0-f42.google.com (mail-lf0-f42.google.com
 [209.85.215.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCF2E40190
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 May 2017 05:54:03 -0400 (EDT)
Received: by mail-lf0-f42.google.com with SMTP id 99so703940lfu.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 05 May 2017 02:57:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1493898284-29504-16-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, bjsprakash.linux@gmail.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:35PM +0200, Eric Auger wrote:
> When creating the lpi we now ask the redistributor what is the state
> of the LPI (priority, enabled, pending).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v6: creation
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 35 ++++++++++++++++++++++++-----------
>  1 file changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index f43ea30c..3ad615a 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -38,6 +38,8 @@
>  
>  static int vgic_its_set_abi(struct vgic_its *its, int rev);
>  static const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its);
> +static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
> +			     struct kvm_vcpu *filter_vcpu);
>  
>  /*
>   * Creates a new (reference to a) struct vgic_irq for a given LPI.
> @@ -46,10 +48,12 @@ static const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its);
>   * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
>   * This function returns a pointer to the _unlocked_ structure.
>   */
> -static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
> +static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
> +				     struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  	struct vgic_irq *irq = vgic_get_irq(kvm, NULL, intid), *oldirq;
> +	int ret;
>  
>  	/* In this case there is no put, since we keep the reference. */
>  	if (irq)
> @@ -66,6 +70,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
>  	irq->config = VGIC_CONFIG_EDGE;
>  	kref_init(&irq->refcount);
>  	irq->intid = intid;
> +	irq->target_vcpu = vcpu;
>  
>  	spin_lock(&dist->lpi_list_lock);
>  
> @@ -97,6 +102,19 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid)
>  out_unlock:
>  	spin_unlock(&dist->lpi_list_lock);
>  
> +	/*
> +	 * We "cache" the configuration table entries in out struct vgic_irq's.

s/out/our/ ?

> +	 * However we only have those structs for mapped IRQs, so we read in
> +	 * the respective config data from memory here upon mapping the LPI.
> +	 */
> +	ret = update_lpi_config(kvm, irq, NULL);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	ret = vgic_v3_lpi_sync_pending_status(kvm, irq);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
>  	return irq;
>  }
>  
> @@ -769,6 +787,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	u32 event_id = its_cmd_get_id(its_cmd);
>  	u32 coll_id = its_cmd_get_collection(its_cmd);
>  	struct its_ite *ite;
> +	struct kvm_vcpu *vcpu = NULL;
>  	struct its_device *device;
>  	struct its_collection *collection, *new_coll = NULL;
>  	int lpi_nr;
> @@ -814,7 +833,10 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	ite->collection = collection;
>  	ite->lpi = lpi_nr;
>  
> -	irq = vgic_add_lpi(kvm, lpi_nr);
> +	if (its_is_collection_mapped(collection))
> +		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
> +
> +	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);

So, if we don't have the collection and therefore end up with irq->vcpu
== NULL, how do we ever read the pending bit from memory as the affinity
may later change?

Is this a problem with our idea of only looking at the pending bit on
vgic_add_lpi, or does it just mean that we should sample the pending bit
whenever we move LPIs around to VCPUs and if the bit is set, then also
set the pennding_latch (if not already set), or what should happen here?

I think in any case, we should have a comment here explaining that vcpu
configuration data gets picked up later?

Thanks,
-Christoffer

>  	if (IS_ERR(irq)) {
>  		if (new_coll)
>  			vgic_its_free_collection(its, coll_id);
> @@ -823,15 +845,6 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  	}
>  	ite->irq = irq;
>  
> -	update_affinity_ite(kvm, ite);
> -
> -	/*
> -	 * We "cache" the configuration table entries in out struct vgic_irq's.
> -	 * However we only have those structs for mapped IRQs, so we read in
> -	 * the respective config data from memory here upon mapping the LPI.
> -	 */
> -	update_lpi_config(kvm, ite->irq, NULL);
> -
>  	return 0;
>  }
>  
> -- 
> 2.5.5
> 
