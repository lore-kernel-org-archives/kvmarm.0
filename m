From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 20/26] KVM: arm/arm64: GICv4: Use the doorbell
 interrupt as an unblocking source
Date: Tue, 7 Nov 2017 22:45:58 +0100
Message-ID: <badc7dbf-bbfa-cf50-ea45-52e5e1eb8f9f@redhat.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-21-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171027142855.21584-21-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Christoffer Dall <christoffer.dall@linaro.org>, Shanker Donthineni <shankerd@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 27/10/2017 16:28, Marc Zyngier wrote:
> The doorbell interrupt is only useful if the vcpu is blocked on WFI.
> In all other cases, recieving a doorbell interrupt is just a waste
> of cycles.
> 
> So let's only enable the doorbell if a vcpu is getting blocked,
> and disable it when it is unblocked. This is very similar to
> what we're doing for the background timer.
> 
> Reviewed-by: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  include/kvm/arm_vgic.h      |  3 +++
>  virt/kvm/arm/arm.c          |  2 ++
>  virt/kvm/arm/vgic/vgic-v4.c | 18 ++++++++++++++++++
>  3 files changed, 23 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index 2f750c770bf2..8c896540a72c 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -381,4 +381,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
>  int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
>  				 struct kvm_kernel_irq_routing_entry *irq_entry);
>  
> +void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
> +void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
> +
>  #endif /* __KVM_ARM_VGIC_H */
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 8388c1cc23f6..092a4ec03e57 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -316,11 +316,13 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
>  void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
>  {
>  	kvm_timer_schedule(vcpu);
> +	kvm_vgic_v4_enable_doorbell(vcpu);
>  }
>  
>  void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
>  {
>  	kvm_timer_unschedule(vcpu);
> +	kvm_vgic_v4_disable_doorbell(vcpu);
>  }
>  
>  int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
> index ea898af1a7a9..1a2f2fcdfa67 100644
> --- a/virt/kvm/arm/vgic/vgic-v4.c
> +++ b/virt/kvm/arm/vgic/vgic-v4.c
> @@ -237,3 +237,21 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
>  	mutex_unlock(&its->its_lock);
>  	return ret;
>  }
> +
> +void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu)
> +{
> +	if (vgic_supports_direct_msis(vcpu->kvm)) {
> +		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> +		if (irq)
> +			enable_irq(irq);
> +	}
> +}
> +
> +void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu)
> +{
> +	if (vgic_supports_direct_msis(vcpu->kvm)) {
> +		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
> +		if (irq)
> +			disable_irq(irq);
> +	}
> +}
> 
