From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v5 21/22] KVM: arm64: vgic-its: Fix pending table sync
Date: Sun, 30 Apr 2017 14:10:33 -0700
Message-ID: <20170430211033.GD1499@lvm>
References: <1492164934-988-1-git-send-email-eric.auger@redhat.com>
 <1492164934-988-22-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F29BB40C54
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Apr 2017 17:07:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wfkQurrphcv4 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 30 Apr 2017 17:07:37 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E4B8940C50
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Apr 2017 17:07:36 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id r190so86545425wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 30 Apr 2017 14:10:35 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1492164934-988-22-git-send-email-eric.auger@redhat.com>
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
Cc: kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, marc.zyngier@arm.com, andre.przywara@arm.com, quintela@redhat.com, dgilbert@redhat.com, Vijaya.Kumar@cavium.com, vijayak@caviumnetworks.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Apr 14, 2017 at 12:15:33PM +0200, Eric Auger wrote:
> In its_sync_lpi_pending_table() we currently ignore the
> target_vcpu of the LPIs. We sync the pending bit found in
> the vcpu pending table even if the LPI is not targeting it.
> 
> Also in vgic_its_cmd_handle_invall() we are supposed to
> read the config table data for the LPIs associated to the
> collection ID. At the moment we refresh all LPI config
> information.
> 
> This patch passes a vpcu to vgic_copy_lpi_list() so that
> this latter returns a snapshot of the LPIs targeting this
> CPU and only those.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 86dfc6c..be848be 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -252,13 +252,13 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
>  }
>  
>  /*
> - * Create a snapshot of the current LPI list, so that we can enumerate all
> - * LPIs without holding any lock.
> - * Returns the array length and puts the kmalloc'ed array into intid_ptr.
> + * Create a snapshot of the current LPIs targeting @vcpu, so that we can
> + * enumerate those LPIs without holding any lock.
> + * Returns their number and puts the kmalloc'ed array into intid_ptr.
>   */
> -static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
> +static int vgic_copy_lpi_list(struct kvm_vcpu *vcpu, u32 **intid_ptr)
>  {
> -	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	struct vgic_irq *irq;
>  	u32 *intids;
>  	int irq_count = dist->lpi_list_count, i = 0;
> @@ -277,14 +277,14 @@ static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
>  	spin_lock(&dist->lpi_list_lock);
>  	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>  		/* We don't need to "get" the IRQ, as we hold the list lock. */
> -		intids[i] = irq->intid;
> -		if (++i == irq_count)
> -			break;
> +		if (irq->target_vcpu != vcpu)
> +			continue;
> +		intids[i++] = irq->intid;

were we checking the ++i == irq_count condition for no good reason
before since we can just drop it now?

>  	}
>  	spin_unlock(&dist->lpi_list_lock);
>  
>  	*intid_ptr = intids;
> -	return irq_count;
> +	return i;
>  }
>  
>  /*
> @@ -333,7 +333,7 @@ static u32 max_lpis_propbaser(u64 propbaser)
>  }
>  
>  /*
> - * Scan the whole LPI pending table and sync the pending bit in there
> + * Sync the pending table pending bit of LPIs targeting @vcpu
>   * with our own data structures. This relies on the LPI being
>   * mapped before.
>   */
> @@ -346,7 +346,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>  	u32 *intids;
>  	int nr_irqs, i;
>  
> -	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, &intids);
> +	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
>  	if (nr_irqs < 0)
>  		return nr_irqs;
>  
> @@ -1027,7 +1027,7 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
>  
>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>  
> -	irq_count = vgic_copy_lpi_list(kvm, &intids);
> +	irq_count = vgic_copy_lpi_list(vcpu, &intids);
>  	if (irq_count < 0)
>  		return irq_count;
>  
> -- 
> 2.5.5
> 

Assuming that it's ok to remove the irq_count check above, the rest of
this patch looks good to me.

Thanks,
-Christoffer
