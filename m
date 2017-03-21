From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 2/9] KVM: arm/arm64: vgic: Avoid flushing vgic state when
 there's no pending IRQ
Date: Tue, 21 Mar 2017 10:57:49 +0000
Message-ID: <0583faa8-4b61-f960-f761-901e4963d3fe@arm.com>
References: <20170320105818.20481-1-cdall@linaro.org>
 <20170320105818.20481-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170320105818.20481-3-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@redhat.com>, Shih-Wei Li <shihwei@cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 20/03/17 10:58, Christoffer Dall wrote:
> From: Shih-Wei Li <shihwei@cs.columbia.edu>
> 
> We do not need to flush vgic states in each world switch unless
> there is pending IRQ queued to the vgic's ap list. We can thus reduce
> the overhead by not grabbing the spinlock and not making the extra
> function call to vgic_flush_lr_state.
> 
> Signed-off-by: Shih-Wei Li <shihwei@cs.columbia.edu>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index 2ac0def..1436c2e 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -637,12 +637,17 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>  /* Sync back the hardware VGIC state into our emulation after a guest's run. */
>  void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
>  {
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +
>  	if (unlikely(!vgic_initialized(vcpu->kvm)))
>  		return;
>  
>  	vgic_process_maintenance_interrupt(vcpu);
>  	vgic_fold_lr_state(vcpu);
>  	vgic_prune_ap_list(vcpu);
> +
> +	/* Make sure we can fast-path in flush_hwstate */
> +	vgic_cpu->used_lrs = 0;
>  }
>  
>  /* Flush our emulation state into the GIC hardware before entering the guest. */
> @@ -651,6 +656,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  	if (unlikely(!vgic_initialized(vcpu->kvm)))
>  		return;
>  
> +	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
> +		return;
> +

While I can see the READ_ONCE in list_empty(), it is not completely
obvious that the race with another CPU injecting an interrupt is safe
(if I get it correctly, it will have the same effect as if it was added
right after the critical section below).

Can we have a nice comment explaining this?

>  	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
>  	vgic_flush_lr_state(vcpu);
>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
> 

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
