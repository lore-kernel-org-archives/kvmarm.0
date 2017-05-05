From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v6 23/24] KVM: arm64: vgic-its: Fix pending table sync
Date: Fri, 5 May 2017 07:54:04 -0700
Message-ID: <20170505145404.GK1419@lvm>
References: <1493898284-29504-1-git-send-email-eric.auger@redhat.com>
 <1493898284-29504-24-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1493898284-29504-24-git-send-email-eric.auger@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, marc.zyngier@arm.com, andre.przywara@arm.com, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Prasun.Kapoor@cavium.com, drjones@redhat.com, pbonzini@redhat.com, dgilbert@redhat.com, quintela@redhat.com, bjsprakash.linux@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 04, 2017 at 01:44:43PM +0200, Eric Auger wrote:
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
> index 376d963..3c114b1 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -278,13 +278,13 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
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
> @@ -303,14 +303,14 @@ static int vgic_copy_lpi_list(struct kvm *kvm, u32 **intid_ptr)
>  	spin_lock(&dist->lpi_list_lock);
>  	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
>  		/* We don't need to "get" the IRQ, as we hold the list lock. */
> -		intids[i] = irq->intid;
> -		if (++i == irq_count)
> -			break;
> +		if (irq->target_vcpu != vcpu)
> +			continue;
> +		intids[i++] = irq->intid;
>  	}
>  	spin_unlock(&dist->lpi_list_lock);
>  
>  	*intid_ptr = intids;
> -	return irq_count;
> +	return i;
>  }
>  
>  /*
> @@ -359,7 +359,7 @@ static u32 max_lpis_propbaser(u64 propbaser)
>  }
>  
>  /*
> - * Scan the whole LPI pending table and sync the pending bit in there
> + * Sync the pending table pending bit of LPIs targeting @vcpu
>   * with our own data structures. This relies on the LPI being
>   * mapped before.
>   */
> @@ -372,7 +372,7 @@ static int its_sync_lpi_pending_table(struct kvm_vcpu *vcpu)
>  	u32 *intids;
>  	int nr_irqs, i;
>  
> -	nr_irqs = vgic_copy_lpi_list(vcpu->kvm, &intids);
> +	nr_irqs = vgic_copy_lpi_list(vcpu, &intids);
>  	if (nr_irqs < 0)
>  		return nr_irqs;
>  
> @@ -1055,7 +1055,7 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
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

Reviewed-by: Christoffer Dall <cdall@linaro.org>
