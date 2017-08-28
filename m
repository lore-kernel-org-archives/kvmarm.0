From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 46/59] KVM: arm/arm64: GICv4: Handle MOVALL applied to
 a vPE
Date: Mon, 28 Aug 2017 20:18:27 +0200
Message-ID: <20170828181827.GG24649@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-47-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170731172637.29355-47-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 31, 2017 at 06:26:24PM +0100, Marc Zyngier wrote:
> The current implementation of MOVALL doesn't allow us to call
> into the core ITS code as we hold a number of spinlocks.
> 
> Let's try a method used in other parts of the code, were we copy
> the intids of the candicate interrupts, and then do whatever
> we need to do with them outside of the critical section.
> 
> This allows us to move the interrupts one by one, at the expense
> of a bit of CPU time. Who cares? MOVALL is such a stupid command
> anyway...
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 2c065c970ba0..65cc77fde609 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1147,11 +1147,12 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
>  static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>  				      u64 *its_cmd)
>  {
> -	struct vgic_dist *dist = &kvm->arch.vgic;
>  	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
>  	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
>  	struct kvm_vcpu *vcpu1, *vcpu2;
>  	struct vgic_irq *irq;
> +	u32 *intids;
> +	int irq_count, i;
>  
>  	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
>  	    target2_addr >= atomic_read(&kvm->online_vcpus))
> @@ -1163,19 +1164,31 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>  	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
>  	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
>  
> -	spin_lock(&dist->lpi_list_lock);
> +	irq_count = vgic_copy_lpi_list(vcpu1, &intids);
> +	if (irq_count < 0)
> +		return irq_count;
>  
> -	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> -		spin_lock(&irq->irq_lock);
> +	for (i = 0; i < irq_count; i++) {
> +		irq = vgic_get_irq(kvm, NULL, intids[i]);
> +		if (!irq)
> +			continue;

Getting irq == NULL means that we've removed this LPI since
vgic_copy_lpi_list, right?  Can this really happen while we hold the its
mutex?

Also, we don't check this in its_sync_lpi_pending_table which would
indicate that we either have a bug there or are being overly careful
here (or should change the continue to BUG).


>  
>  		if (irq->target_vcpu == vcpu1)
>  			irq->target_vcpu = vcpu2;
>  
> -		spin_unlock(&irq->irq_lock);

Is it safe to modify target_vcpu without holding the irq_lock?

> -	}
> +		if (irq->hw) {
> +			struct its_vlpi_map map;
>  
> -	spin_unlock(&dist->lpi_list_lock);
> +			if (!its_get_vlpi(irq->host_irq, &map)) {
> +				map.vpe_idx = vcpu2->vcpu_id;
> +				its_map_vlpi(irq->host_irq, &map);
> +			}
> +		}
>  
> +		vgic_put_irq(kvm, irq);
> +	}
> +
> +	kfree(intids);
>  	return 0;
>  }
>  
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
