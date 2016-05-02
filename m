From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 19/54] KVM: arm/arm64: vgic-new: Implement
Date: Mon, 2 May 2016 14:24:53 +0200
Message-ID: <57274715.8080801@linaro.org>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
 <1461861973-26464-20-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1461861973-26464-20-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,

minor comment: patch title has been altered since v1, should be

KVM: arm/arm64: vgic-new: Implement kvm_vgic_vcpu_pending_irq

Cheers

Eric

On 04/28/2016 06:45 PM, Andre Przywara wrote:
> From: Eric Auger <eric.auger@linaro.org>
> 
> Tell KVM whether a particular VCPU has an IRQ that needs handling
> in the guest. This is used to decide whether a VCPU is runnable.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Changelog RFC..v1:
> - return false if distributor is disabled
> - add vgic_kick_vcpus() implementations
> 
>  include/kvm/vgic/vgic.h  |  2 ++
>  virt/kvm/arm/vgic/vgic.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h |  1 +
>  3 files changed, 43 insertions(+)
> 
> diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
> index 5fae4a9..2615205 100644
> --- a/include/kvm/vgic/vgic.h
> +++ b/include/kvm/vgic/vgic.h
> @@ -184,6 +184,8 @@ struct vgic_cpu {
>  int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
>  			bool level);
>  
> +int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> +
>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
>  #define vgic_initialized(k)	(false)
>  #define vgic_ready(k)		((k)->arch.vgic.ready)
> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> index ae52928..eeb766e 100644
> --- a/virt/kvm/arm/vgic/vgic.c
> +++ b/virt/kvm/arm/vgic/vgic.c
> @@ -519,3 +519,43 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
>  	vgic_flush_lr_state(vcpu);
>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
>  }
> +
> +int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
> +{
> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> +	struct vgic_irq *irq;
> +	bool pending = false;
> +
> +	if (!vcpu->kvm->arch.vgic.enabled)
> +		return false;
> +
> +	spin_lock(&vgic_cpu->ap_list_lock);
> +
> +	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
> +		spin_lock(&irq->irq_lock);
> +		pending = irq->pending && irq->enabled;
> +		spin_unlock(&irq->irq_lock);
> +
> +		if (pending)
> +			break;
> +	}
> +
> +	spin_unlock(&vgic_cpu->ap_list_lock);
> +
> +	return pending;
> +}
> +
> +void vgic_kick_vcpus(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int c;
> +
> +	/*
> +	 * We've injected an interrupt, time to find out who deserves
> +	 * a good kick...
> +	 */
> +	kvm_for_each_vcpu(c, vcpu, kvm) {
> +		if (kvm_vgic_vcpu_pending_irq(vcpu))
> +			kvm_vcpu_kick(vcpu);
> +	}
> +}
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index 81b1a20..0c92cda 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -21,6 +21,7 @@
>  struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
>  			      u32 intid);
>  bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
> +void vgic_kick_vcpus(struct kvm *kvm);
>  
>  void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
>  void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
> 

