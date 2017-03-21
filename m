From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 9/9] KVM: arm/arm64: vgic: Improve sync_hwstate performance
Date: Tue, 21 Mar 2017 13:29:06 +0000
Message-ID: <822a56eb-0989-493a-545e-15deb3de7ddc@arm.com>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-10-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EA1F40C33
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 09:27:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O13vO1kAeyI8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 09:27:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75B1240BDE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 09:27:22 -0400 (EDT)
In-Reply-To: <20170320105818.20481-10-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 20/03/17 10:58, Christoffer Dall wrote:
> There is no need to call any functions to fold LRs when we don't use any
> LRs and we don't need to mess with overflow flags, take spinlocks, or
> prune the AP list if the AP list is empty.
> 
> Note: list_empty is a single atomic read (uses READ_ONCE) and can
> therefore check if a list is empty or not without the need to take the
> spinlock protecting the list.
> 
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 093873e..8ecb009 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -639,15 +639,18 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>  
> -	if (unlikely(!vgic_initialized(vcpu->kvm)))

Could this be folded with the previous patch? It is the same optimisation.

> +	/* An empty ap_list_head implies used_lrs == 0 */
> +	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
>  		return;
>  
>  	vgic_clear_uie(vcpu);
> -	vgic_fold_lr_state(vcpu);
> -	vgic_prune_ap_list(vcpu);
>  
> -	/* Make sure we can fast-path in flush_hwstate */
> -	vgic_cpu->used_lrs = 0;
> +	if (vgic_cpu->used_lrs) {
> +		vgic_fold_lr_state(vcpu);
> +		vgic_cpu->used_lrs = 0;

This zeroing could also be moved to vgic_fold_lr_state(), though I don't
feel strongly about it.

> +	}
> +
> +	vgic_prune_ap_list(vcpu);
>  }
>  
>  /* Flush our emulation state into the GIC hardware before entering the guest. */
> 

Otherwise looks good to me.

	M.
-- 
Jazz is not dead. It just smells funny...
