From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 14/26] KVM: arm/arm64: GICv4: Handle MOVALL applied to
 a vPE
Date: Wed, 25 Oct 2017 18:27:19 +0200
Message-ID: <20171025162719.GN91785@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-15-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 198C749D26
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 12:26:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0+Vjinr1QWCr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Oct 2017 12:26:03 -0400 (EDT)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12605406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 12:26:03 -0400 (EDT)
Received: by mail-wm0-f65.google.com with SMTP id u138so2975164wmu.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Oct 2017 09:27:23 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-15-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:33:49PM +0100, Marc Zyngier wrote:
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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

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
> -- 
> 2.14.1
> 
