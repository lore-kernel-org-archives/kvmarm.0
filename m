From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 15/26] KVM: arm/arm64: GICv4: Handle MOVALL applied to
 a vPE
Date: Tue, 7 Nov 2017 22:06:21 +0100
Message-ID: <cb8b5335-6885-14cc-3936-bf923fb6d380@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-16-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-16-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 27/10/2017 16:28, Marc Zyngier wrote:
> The current implementation of MOVALL doesn't allow us to call
> into the core ITS code as we hold a number of spinlocks.
> 
> Let's try a method used in other parts of the code, were we copy
nit: where
> the intids of the candicate interrupts, and then do whatever
candidate
> we need to do with them outside of the critical section.
> 
> This allows us to move the interrupts one by one, at the expense
> of a bit of CPU time. Who cares? MOVALL is such a stupid command
> anyway...
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 5778b50911e8..0b7e648e7a0c 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -1148,11 +1148,12 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
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
> @@ -1164,19 +1165,19 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>  	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
>  	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
>  
> -	spin_lock(&dist->lpi_list_lock);
> +	irq_count = vgic_copy_lpi_list(vcpu1, &intids);
> +	if (irq_count < 0)
nit: <=?

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

> +		return irq_count;
>  
> -	list_for_each_entry(irq, &dist->lpi_list_head, lpi_list) {
> -		spin_lock(&irq->irq_lock);
> +	for (i = 0; i < irq_count; i++) {
> +		irq = vgic_get_irq(kvm, NULL, intids[i]);
>  
> -		if (irq->target_vcpu == vcpu1)
> -			irq->target_vcpu = vcpu2;
> +		update_affinity(irq, vcpu2);
>  
> -		spin_unlock(&irq->irq_lock);
> +		vgic_put_irq(kvm, irq);
>  	}
>  
> -	spin_unlock(&dist->lpi_list_lock);
> -
> +	kfree(intids);
>  	return 0;
>  }
>  
> 
